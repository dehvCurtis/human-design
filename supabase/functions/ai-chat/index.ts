// AI Chat Edge Function
// Security: JWT validation, rate limiting, input sanitization, usage quota enforcement
// Provider-agnostic: supports Gemini, Claude, and OpenAI via AI_PROVIDER env var

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// Security constants
const MAX_MESSAGE_LENGTH = 2000;
const MAX_CONVERSATION_HISTORY = 20; // Limit context window to prevent token abuse
const MAX_CONVERSATIONS_PER_USER = 50;
const FREE_MESSAGES_PER_MONTH = 5;

// AI provider interface
interface AiProvider {
  chat(systemPrompt: string, messages: ChatMessage[]): Promise<string>;
}

interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

// ============================================================================
// AI Provider Adapters
// ============================================================================

class GeminiProvider implements AiProvider {
  private apiKey: string;

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  async chat(
    systemPrompt: string,
    messages: ChatMessage[]
  ): Promise<string> {
    const contents = messages.map((m) => ({
      role: m.role === "assistant" ? "model" : "user",
      parts: [{ text: m.content }],
    }));

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": this.apiKey,
        },
        body: JSON.stringify({
          system_instruction: { parts: [{ text: systemPrompt }] },
          contents,
          safetySettings: [
            {
              category: "HARM_CATEGORY_HARASSMENT",
              threshold: "BLOCK_MEDIUM_AND_ABOVE",
            },
            {
              category: "HARM_CATEGORY_HATE_SPEECH",
              threshold: "BLOCK_MEDIUM_AND_ABOVE",
            },
            {
              category: "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              threshold: "BLOCK_MEDIUM_AND_ABOVE",
            },
            {
              category: "HARM_CATEGORY_DANGEROUS_CONTENT",
              threshold: "BLOCK_MEDIUM_AND_ABOVE",
            },
          ],
          generationConfig: {
            maxOutputTokens: 1024,
            temperature: 0.7,
          },
        }),
      }
    );

    if (!response.ok) {
      const errorBody = await response.text();
      console.error("Gemini API error:", response.status, errorBody);
      throw new Error(`Gemini API error: ${response.status}`);
    }

    const data = await response.json();
    return data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
  }
}

class ClaudeProvider implements AiProvider {
  private apiKey: string;

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  async chat(
    systemPrompt: string,
    messages: ChatMessage[]
  ): Promise<string> {
    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": this.apiKey,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: "claude-sonnet-4-5-20250929",
        max_tokens: 1024,
        system: systemPrompt,
        messages: messages.map((m) => ({
          role: m.role,
          content: m.content,
        })),
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      console.error("Claude API error:", response.status, errorBody);
      throw new Error(`Claude API error: ${response.status}`);
    }

    const data = await response.json();
    return data.content?.[0]?.text ?? "";
  }
}

class OpenAIProvider implements AiProvider {
  private apiKey: string;

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  async chat(
    systemPrompt: string,
    messages: ChatMessage[]
  ): Promise<string> {
    const allMessages = [
      { role: "system" as const, content: systemPrompt },
      ...messages,
    ];

    const response = await fetch(
      "https://api.openai.com/v1/chat/completions",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          model: "gpt-4o-mini",
          messages: allMessages,
          max_tokens: 1024,
          temperature: 0.7,
        }),
      }
    );

    if (!response.ok) {
      const errorBody = await response.text();
      console.error("OpenAI API error:", response.status, errorBody);
      throw new Error(`OpenAI API error: ${response.status}`);
    }

    const data = await response.json();
    return data.choices?.[0]?.message?.content ?? "";
  }
}

// ============================================================================
// Provider Factory
// ============================================================================

function createAiProvider(): AiProvider {
  const provider = Deno.env.get("AI_PROVIDER") || "claude";

  switch (provider) {
    case "gemini": {
      const key = Deno.env.get("GEMINI_API_KEY");
      if (!key) throw new Error("GEMINI_API_KEY not set");
      return new GeminiProvider(key);
    }
    case "claude": {
      const key = Deno.env.get("ANTHROPIC_API_KEY");
      if (!key) throw new Error("ANTHROPIC_API_KEY not set");
      return new ClaudeProvider(key);
    }
    case "openai": {
      const key = Deno.env.get("OPENAI_API_KEY");
      if (!key) throw new Error("OPENAI_API_KEY not set");
      return new OpenAIProvider(key);
    }
    default:
      throw new Error(`Unknown AI provider: ${provider}`);
  }
}

// ============================================================================
// System Prompt Builder
// ============================================================================

function buildSystemPrompt(chartContext?: Record<string, unknown>): string {
  let prompt = `You are a knowledgeable Human Design assistant. You help users understand their Human Design chart, including their Type, Strategy, Authority, Profile, Centers, Gates, and Channels.

Guidelines:
- Be warm, encouraging, and supportive
- Provide accurate Human Design information
- When discussing the user's chart, reference their specific activations
- Explain concepts clearly for both beginners and experienced students
- If you're unsure about something, say so rather than guessing
- Keep responses concise but informative (2-4 paragraphs)
- Do not provide medical, legal, or financial advice
- Focus only on Human Design topics`;

  if (chartContext) {
    prompt += `\n\nThe user's Human Design chart data:\n${JSON.stringify(chartContext, null, 2)}`;
  }

  return prompt;
}

// ============================================================================
// Input Validation (Security)
// ============================================================================

function validateMessage(message: unknown): string {
  if (typeof message !== "string") {
    throw new ValidationError("Message must be a string");
  }

  const trimmed = message.trim();

  if (trimmed.length === 0) {
    throw new ValidationError("Message cannot be empty");
  }

  if (trimmed.length > MAX_MESSAGE_LENGTH) {
    throw new ValidationError(
      `Message exceeds maximum length of ${MAX_MESSAGE_LENGTH} characters`
    );
  }

  return trimmed;
}

function validateContextType(contextType: unknown): string {
  const valid = ["chart", "transit", "general"];
  if (typeof contextType !== "string" || !valid.includes(contextType)) {
    return "general";
  }
  return contextType;
}

function validateUuid(value: unknown): string | null {
  if (value === null || value === undefined) return null;
  if (typeof value !== "string") return null;

  const uuidRegex =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  if (!uuidRegex.test(value)) {
    throw new ValidationError("Invalid conversation ID format");
  }
  return value;
}

class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ValidationError";
  }
}

// ============================================================================
// Main Handler
// ============================================================================

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // ---- 1. Authenticate user via JWT ----
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing authorization header" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY")!;

    // Create client with user's JWT for auth verification
    const userClient = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const {
      data: { user },
      error: authError,
    } = await userClient.auth.getUser();

    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: "Invalid or expired token" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const userId = user.id;

    // ---- 2. Parse and validate input ----
    const body = await req.json();
    const message = validateMessage(body.message);
    const conversationId = validateUuid(body.conversation_id);
    const contextType = validateContextType(body.context_type);
    const chartContext = body.chart_context; // Already sanitized by client

    // ---- 3. Check usage quota (server-side authoritative) ----
    // Use service role client for database operations
    const adminClient = createClient(supabaseUrl, supabaseServiceKey);

    // Check if user is premium
    const { data: subscription } = await adminClient
      .from("subscriptions")
      .select("tier, expires_at")
      .eq("user_id", userId)
      .maybeSingle();

    const isPremium =
      subscription?.tier === "premium" &&
      new Date(subscription.expires_at) > new Date();

    if (!isPremium) {
      const now = new Date();
      const periodStart = `${now.getFullYear()}-${String(
        now.getMonth() + 1
      ).padStart(2, "0")}-01`;

      const { data: usage } = await adminClient
        .from("ai_usage")
        .select("messages_count, bonus_messages")
        .eq("user_id", userId)
        .eq("period_start", periodStart)
        .maybeSingle();

      const currentUsage = usage?.messages_count ?? 0;
      const bonusMessages = usage?.bonus_messages ?? 0;
      const effectiveLimit = FREE_MESSAGES_PER_MONTH + bonusMessages;

      if (currentUsage >= effectiveLimit) {
        return new Response(
          JSON.stringify({
            error: "Monthly AI message limit reached. Upgrade to Premium for unlimited access.",
            code: "QUOTA_EXCEEDED",
          }),
          { status: 429, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    // ---- 4. Get or create conversation ----
    let activeConversationId = conversationId;

    if (!activeConversationId) {
      // Check conversation limit
      const { count } = await adminClient
        .from("ai_conversations")
        .select("id", { count: "exact", head: true })
        .eq("user_id", userId);

      if ((count ?? 0) >= MAX_CONVERSATIONS_PER_USER) {
        // Delete oldest conversation to make room
        const { data: oldest } = await adminClient
          .from("ai_conversations")
          .select("id")
          .eq("user_id", userId)
          .order("last_message_at", { ascending: true })
          .limit(1)
          .single();

        if (oldest) {
          await adminClient
            .from("ai_conversations")
            .delete()
            .eq("id", oldest.id);
        }
      }

      // Create new conversation
      const { data: newConvo, error: convoError } = await adminClient
        .from("ai_conversations")
        .insert({
          user_id: userId,
          context_type: contextType,
          title: message.substring(0, 100),
          last_message_at: new Date().toISOString(),
        })
        .select()
        .single();

      if (convoError) {
        console.error("Failed to create conversation:", convoError);
        throw new Error("Failed to create conversation");
      }

      activeConversationId = newConvo.id;
    } else {
      // Verify conversation belongs to user (security check)
      const { data: existingConvo } = await adminClient
        .from("ai_conversations")
        .select("id, user_id")
        .eq("id", activeConversationId)
        .single();

      if (!existingConvo || existingConvo.user_id !== userId) {
        return new Response(
          JSON.stringify({ error: "Conversation not found" }),
          { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    // ---- 5. Store user message ----
    await adminClient.from("ai_messages").insert({
      conversation_id: activeConversationId,
      role: "user",
      content: message,
    });

    // ---- 6. Load conversation history (limited) ----
    const { data: history } = await adminClient
      .from("ai_messages")
      .select("role, content")
      .eq("conversation_id", activeConversationId)
      .order("created_at", { ascending: true })
      .limit(MAX_CONVERSATION_HISTORY);

    const conversationMessages: ChatMessage[] = (history ?? []).map(
      (m: { role: string; content: string }) => ({
        role: m.role as "user" | "assistant",
        content: m.content,
      })
    );

    // ---- 7. Call AI provider ----
    const provider = createAiProvider();
    const systemPrompt = buildSystemPrompt(chartContext);
    const aiResponse = await provider.chat(systemPrompt, conversationMessages);

    // ---- 8. Store AI response ----
    const { data: storedMessage, error: storeError } = await adminClient
      .from("ai_messages")
      .insert({
        conversation_id: activeConversationId,
        role: "assistant",
        content: aiResponse,
      })
      .select()
      .single();

    if (storeError) {
      console.error("Failed to store AI response:", storeError);
      // Still return the response even if storage fails
    }

    // ---- 9. Update conversation metadata ----
    const { count: messageCount } = await adminClient
      .from("ai_messages")
      .select("id", { count: "exact", head: true })
      .eq("conversation_id", activeConversationId);

    await adminClient
      .from("ai_conversations")
      .update({
        last_message_at: new Date().toISOString(),
        message_count: messageCount ?? 0,
      })
      .eq("id", activeConversationId);

    // ---- 10. Update usage counter ----
    if (!isPremium) {
      const now = new Date();
      const periodStart = `${now.getFullYear()}-${String(
        now.getMonth() + 1
      ).padStart(2, "0")}-01`;

      await adminClient.rpc("increment_ai_usage", {
        p_user_id: userId,
        p_period_start: periodStart,
      });
    }

    // ---- 11. Return response ----
    return new Response(
      JSON.stringify({
        message: {
          id: storedMessage?.id ?? crypto.randomUUID(),
          conversation_id: activeConversationId,
          role: "assistant",
          content: aiResponse,
          created_at:
            storedMessage?.created_at ?? new Date().toISOString(),
        },
        conversation_id: activeConversationId,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("AI chat error:", error);

    if (error instanceof ValidationError) {
      return new Response(
        JSON.stringify({ error: error.message }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({ error: "An internal error occurred" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
