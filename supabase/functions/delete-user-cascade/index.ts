// Delete User Cascade Edge Function
// GDPR Article 17 — Right to Erasure
//
// Security:
// - JWT validation: user must be authenticated
// - Self-only: user can only delete their own account (JWT user_id must match)
// - Service-role: all deletions use admin client to bypass RLS
// - Ordered deletion: respects foreign key constraints
// - Auth user deletion: removes the auth.users entry last

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

    // ---- 2. Validate request — user can only delete themselves ----
    const body = await req.json();
    const requestedUserId = body.userId;

    if (!requestedUserId || requestedUserId !== user.id) {
      return new Response(
        JSON.stringify({ error: "You can only delete your own account" }),
        { status: 403, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const userId = user.id;

    // ---- 3. Delete all user data (service-role client) ----
    const adminClient = createClient(supabaseUrl, supabaseServiceKey);

    // Delete in order to respect foreign key constraints.
    // Child tables first, then parent tables.
    const deletionTables = [
      // AI data
      { table: "ai_messages", via: "ai_conversations", column: "user_id" },
      { table: "ai_conversations", column: "user_id" },
      { table: "ai_usage", column: "user_id" },
      { table: "ai_purchases", column: "user_id" },

      // Social content
      { table: "reactions", column: "user_id" },
      { table: "comments", column: "user_id" },
      { table: "posts", column: "user_id" },
      { table: "stories", column: "user_id" },

      // Messaging
      { table: "direct_messages", column: "sender_id" },

      // Social connections
      { table: "follows", column: "follower_id" },
      { table: "follows", column: "following_id" },

      // Groups & circles
      { table: "group_members", column: "user_id" },
      { table: "circle_members", column: "user_id" },
      { table: "team_members", column: "user_id" },
      { table: "event_registrations", column: "user_id" },

      // Gamification
      { table: "point_transactions", column: "user_id" },
      { table: "user_challenges", column: "user_id" },
      { table: "user_badges", column: "user_id" },
      { table: "user_points", column: "user_id" },

      // Learning
      { table: "quiz_attempts", column: "user_id" },
      { table: "user_learning_paths", column: "user_id" },

      // Charts & shares
      { table: "shares", column: "shared_by" },
      { table: "shares", column: "user_id" },
      { table: "charts", column: "user_id" },

      // Dream journal
      { table: "journal_entries", column: "user_id" },

      // Notifications
      { table: "notifications", column: "user_id" },

      // Subscriptions
      { table: "subscriptions", column: "user_id" },

      // Profile (last before auth)
      { table: "profiles", column: "id" },
    ];

    const errors: string[] = [];

    for (const { table, via, column } of deletionTables) {
      try {
        if (via) {
          // Delete child records via parent relationship
          // e.g., ai_messages via ai_conversations.user_id
          const { data: parentIds } = await adminClient
            .from(via)
            .select("id")
            .eq(column!, userId);

          if (parentIds && parentIds.length > 0) {
            const ids = parentIds.map((r: { id: string }) => r.id);
            await adminClient
              .from(table)
              .delete()
              .in("conversation_id", ids);
          }
        } else {
          await adminClient.from(table).delete().eq(column, userId);
        }
      } catch (e) {
        // Log but continue — some tables may not exist or have no data
        console.warn(`Warning deleting from ${table}: ${e}`);
        errors.push(`${table}: ${e}`);
      }
    }

    // ---- 4. Delete the auth user ----
    const { error: deleteAuthError } =
      await adminClient.auth.admin.deleteUser(userId);

    if (deleteAuthError) {
      console.error("Failed to delete auth user:", deleteAuthError);
      return new Response(
        JSON.stringify({
          error: "Failed to delete account. Please contact support.",
          details: deleteAuthError.message,
        }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    console.log(`User ${userId} account deleted successfully`);

    return new Response(
      JSON.stringify({
        success: true,
        message: "Account and all associated data deleted",
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("Delete user cascade error:", error);
    return new Response(
      JSON.stringify({ error: "An internal error occurred" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
