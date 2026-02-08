// AI Chat Edge Function
// Security: JWT validation, rate limiting, input sanitization, usage quota enforcement
// Provider-agnostic: supports Gemini, Claude, and OpenAI via AI_PROVIDER env var

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Allowed origins for CORS (restrict in production)
const ALLOWED_ORIGINS = (Deno.env.get("ALLOWED_ORIGINS") || "*").split(",");

function getCorsHeaders(req: Request): Record<string, string> {
  const origin = req.headers.get("Origin") || "";
  const allowedOrigin =
    ALLOWED_ORIGINS.includes("*") || ALLOWED_ORIGINS.includes(origin)
      ? origin || "*"
      : ALLOWED_ORIGINS[0];

  return {
    "Access-Control-Allow-Origin": allowedOrigin,
    "Access-Control-Allow-Headers":
      "authorization, x-client-info, apikey, content-type",
  };
}

// Security constants
const MAX_MESSAGE_LENGTH = 2000;
const MAX_CONVERSATION_HISTORY = 20; // Limit context window to prevent token abuse
const MAX_CONVERSATIONS_PER_USER = 50;
const FREE_MESSAGES_PER_MONTH = 5;
const MAX_CHART_CONTEXT_SIZE = 10000; // Max JSON chars for chart_context
const RATE_LIMIT_PER_MINUTE = 10;
const RATE_LIMIT_WINDOW_MS = 60_000;

// AI provider interface
interface AiProvider {
  chat(systemPrompt: string, messages: ChatMessage[], maxTokens?: number): Promise<string>;
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
    messages: ChatMessage[],
    maxTokens: number = 1024
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
            maxOutputTokens: maxTokens,
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
    messages: ChatMessage[],
    maxTokens: number = 1024
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
        max_tokens: maxTokens,
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
    messages: ChatMessage[],
    maxTokens: number = 1024
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
          max_tokens: maxTokens,
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

// Max tokens per context type
const MAX_TOKENS_BY_CONTEXT: Record<string, number> = {
  chart_reading: 4096,
  compatibility: 2048,
  transit_insight: 1024,
  dream: 1024,
  journal: 1024,
  chart: 1024,
  transit: 1024,
  general: 1024,
};

function getMaxTokens(contextType: string, requestedMaxTokens?: number): number {
  const contextDefault = MAX_TOKENS_BY_CONTEXT[contextType] ?? 1024;
  if (requestedMaxTokens && requestedMaxTokens > 0) {
    return Math.min(requestedMaxTokens, 4096);
  }
  return contextDefault;
}

function buildSystemPrompt(contextType: string, chartContext?: Record<string, unknown>): string {
  let prompt: string;

  switch (contextType) {
    case "transit_insight":
      prompt = `You are a knowledgeable Human Design transit analyst. Interpret how today's transits affect this person's chart. Focus on the Sun gate transit, channels being completed, and centers being temporarily defined. Be specific and actionable.

Guidelines:
- Reference the specific transit gates and their meanings
- Explain which channels are being temporarily completed
- Describe how temporarily defined centers affect the person
- Provide practical advice for navigating today's energy
- Be warm, encouraging, and supportive
- Keep the reading focused and personal (3-5 paragraphs)`;
      break;

    case "chart_reading":
      prompt = `You are an expert Human Design analyst providing a comprehensive chart reading. Generate a detailed, insightful reading covering all major aspects of this person's design.

Structure your reading with these sections (use markdown headers):
## Type & Strategy
## Inner Authority
## Profile
## Defined Centers
## Key Channels
## Incarnation Cross & Life Purpose

Guidelines:
- Write 6-8 detailed paragraphs covering each section
- Be specific to their chart activations — avoid generic descriptions
- Include practical advice for living their design
- Reference specific gates and channels by number and name
- Be warm, wise, and encouraging
- Do not provide medical, legal, or financial advice`;
      break;

    case "compatibility":
      prompt = `You are a Human Design relationship analyst. Analyze the compatibility between two people based on their Human Design charts.

Cover these aspects:
- Overall dynamic between the two types
- Electromagnetic channels (mutual attraction and magnetism)
- Companionship channels (shared understanding and comfort)
- Center bridging dynamics (growth and conditioning)
- Profile harmonics and interaction style
- Practical advice for the relationship

Guidelines:
- Be balanced — highlight both strengths and growth areas
- Reference specific channels and gates by number
- Explain the energetic dynamics in accessible language
- Provide practical relationship guidance
- Be warm, supportive, and non-judgmental
- Write 5-7 detailed paragraphs`;
      break;

    case "dream":
      prompt = `You are a Human Design dream interpreter. Interpret this dream through the lens of the person's Human Design chart and current transits. Connect dream symbols to their defined/undefined centers, active gates, and today's transit energies.

Guidelines:
- Relate dream symbols to specific centers (defined vs undefined)
- Connect themes to their active gates and channels
- Reference current transit energies if transit data is provided
- Offer insights about what the subconscious may be processing
- Be warm, intuitive, and supportive
- Keep the interpretation focused (2-4 paragraphs)
- Do not provide medical or psychological advice`;
      break;

    case "journal":
      prompt = `You are a Human Design journaling guide. Generate 3-5 reflective journaling prompts personalized to this person's chart and today's transits. Each prompt should help them explore their design.

Format as a numbered list with each prompt on its own line. After each prompt number, include a brief (one sentence) context note about which aspect of their design it relates to.

Guidelines:
- Make prompts specific to their Type, Authority, and defined/undefined centers
- Reference current transit gates if transit data is provided
- Vary the depth — mix introspective and practical prompts
- Keep prompts open-ended to encourage exploration
- Be warm, encouraging, and supportive`;
      break;

    default:
      prompt = `You are a knowledgeable Human Design assistant. You help users understand their Human Design chart, including their Type, Strategy, Authority, Profile, Centers, Gates, and Channels.

Guidelines:
- Be warm, encouraging, and supportive
- Provide accurate Human Design information
- When discussing the user's chart, reference their specific activations
- Explain concepts clearly for both beginners and experienced students
- If you're unsure about something, say so rather than guessing
- Keep responses concise but informative (2-4 paragraphs)
- Do not provide medical, legal, or financial advice
- Focus only on Human Design topics`;
      break;
  }

  if (chartContext) {
    prompt += `\n\nChart data:\n${JSON.stringify(chartContext, null, 2)}`;
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
  const valid = [
    "chart", "transit", "general",
    "transit_insight", "chart_reading", "compatibility", "dream", "journal",
  ];
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

// Validate chart_context to prevent prompt injection and oversized payloads
function validateChartContext(ctx: unknown): Record<string, unknown> | undefined {
  if (ctx === null || ctx === undefined) return undefined;
  if (typeof ctx !== "object" || Array.isArray(ctx)) {
    throw new ValidationError("chart_context must be an object");
  }

  const serialized = JSON.stringify(ctx);
  if (serialized.length > MAX_CHART_CONTEXT_SIZE) {
    throw new ValidationError(
      `chart_context exceeds maximum size of ${MAX_CHART_CONTEXT_SIZE} characters`
    );
  }

  // Only allow known top-level keys (matches ChartContextBuilder output)
  const allowedKeys = new Set([
    "name", "type", "strategy", "authority", "profile", "definition",
    "definedCenters", "undefinedCenters", "channels", "consciousGates",
    "unconsciousGates", "incarnationCross",
    // Transit context
    "transitGates", "transitChannels", "newChannels", "activatedGates",
    // Compatibility context
    "person1", "person2", "compositeResult",
    "electromagneticChannels", "companionshipChannels",
    "dominanceChannels", "compromiseChannels",
  ]);

  const obj = ctx as Record<string, unknown>;
  for (const key of Object.keys(obj)) {
    if (!allowedKeys.has(key)) {
      delete obj[key];
    }
  }

  return obj;
}

// In-memory rate limiter (per-instance; resets on cold start)
const rateLimitMap = new Map<string, number[]>();

function checkRateLimit(userId: string): boolean {
  const now = Date.now();
  const timestamps = rateLimitMap.get(userId) ?? [];

  // Remove expired entries
  const recent = timestamps.filter((t) => now - t < RATE_LIMIT_WINDOW_MS);

  if (recent.length >= RATE_LIMIT_PER_MINUTE) {
    rateLimitMap.set(userId, recent);
    return false; // Rate limited
  }

  recent.push(now);
  rateLimitMap.set(userId, recent);
  return true;
}

// ============================================================================
// Main Handler
// ============================================================================

Deno.serve(async (req) => {
  const cors = getCorsHeaders(req);

  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: cors });
  }

  try {
    // ---- 1. Authenticate user via JWT ----
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing authorization header" }),
        { status: 401, headers: { ...cors, "Content-Type": "application/json" } }
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
        { status: 401, headers: { ...cors, "Content-Type": "application/json" } }
      );
    }

    const userId = user.id;

    // ---- Rate limit check (before any DB work) ----
    if (!checkRateLimit(userId)) {
      return new Response(
        JSON.stringify({ error: "Too many requests. Please wait a moment." }),
        { status: 429, headers: { ...cors, "Content-Type": "application/json" } }
      );
    }

    // ---- 2. Parse and validate input ----
    const body = await req.json();
    const message = validateMessage(body.message);
    const conversationId = validateUuid(body.conversation_id);
    const contextType = validateContextType(body.context_type);
    const chartContext = validateChartContext(body.chart_context);
    const requestedMaxTokens = typeof body.max_tokens === "number" ? body.max_tokens : undefined;

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
          { status: 429, headers: { ...cors, "Content-Type": "application/json" } }
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
          { status: 404, headers: { ...cors, "Content-Type": "application/json" } }
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
    const maxTokens = getMaxTokens(contextType, requestedMaxTokens);
    const systemPrompt = buildSystemPrompt(contextType, chartContext);
    const aiResponse = await provider.chat(systemPrompt, conversationMessages, maxTokens);

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
        headers: { ...cors, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("AI chat error:", error);

    if (error instanceof ValidationError) {
      return new Response(
        JSON.stringify({ error: error.message }),
        { status: 400, headers: { ...cors, "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({ error: "An internal error occurred" }),
      { status: 500, headers: { ...cors, "Content-Type": "application/json" } }
    );
  }
});
