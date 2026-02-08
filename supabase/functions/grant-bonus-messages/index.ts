// Grant Bonus Messages Edge Function
// Security: Validates that a matching ai_purchases record exists before granting.
// Only service_role can call the underlying add_ai_bonus_messages RPC.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

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

    // Verify user JWT
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

    // ---- 2. Validate input ----
    const body = await req.json();
    const { count, purchase_id: purchaseId } = body;

    if (typeof count !== "number" || count < 1 || count > 500) {
      return new Response(
        JSON.stringify({ error: "Invalid message count" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (typeof purchaseId !== "string" || purchaseId.length === 0) {
      return new Response(
        JSON.stringify({ error: "Missing purchase_id" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // ---- 3. Verify purchase exists and belongs to this user ----
    const adminClient = createClient(supabaseUrl, supabaseServiceKey);

    const { data: purchase } = await adminClient
      .from("ai_purchases")
      .select("id, user_id, message_count, redeemed")
      .eq("id", purchaseId)
      .eq("user_id", userId)
      .maybeSingle();

    if (!purchase) {
      return new Response(
        JSON.stringify({ error: "Purchase not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (purchase.redeemed) {
      return new Response(
        JSON.stringify({ error: "Purchase already redeemed" }),
        { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Use the purchase's message_count, not the client-provided count
    const grantCount = purchase.message_count ?? count;

    // ---- 4. Grant bonus messages (service role) ----
    const now = new Date();
    const periodStart = `${now.getFullYear()}-${String(
      now.getMonth() + 1
    ).padStart(2, "0")}-01`;

    const { error: rpcError } = await adminClient.rpc(
      "add_ai_bonus_messages",
      {
        p_user_id: userId,
        p_period_start: periodStart,
        p_count: grantCount,
      }
    );

    if (rpcError) {
      console.error("Failed to grant bonus messages:", rpcError);
      return new Response(
        JSON.stringify({ error: "Failed to grant bonus messages" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // ---- 5. Mark purchase as redeemed ----
    await adminClient
      .from("ai_purchases")
      .update({ redeemed: true, redeemed_at: new Date().toISOString() })
      .eq("id", purchaseId);

    return new Response(
      JSON.stringify({
        success: true,
        messages_granted: grantCount,
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("Grant bonus messages error:", error);
    return new Response(
      JSON.stringify({ error: "An internal error occurred" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
