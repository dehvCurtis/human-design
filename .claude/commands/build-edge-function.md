# Build Edge Function

Scaffold a Supabase Edge Function (Deno/TypeScript) with JWT auth, input validation, error handling, and CORS.

## Instructions

When the user describes the function needed: `$ARGUMENTS`

### Step 1: Study existing pattern

Read the reference implementation:
- `supabase/functions/ai-chat/index.ts`

Note the established conventions:
- CORS headers on every response
- OPTIONS preflight handler
- JWT validation via `supabase.auth.getUser()`
- User client (anon key + user JWT) for auth verification
- Admin client (service role key) for privileged DB operations
- Input validation with custom `ValidationError` class
- Structured JSON error responses with status codes
- `try/catch` with different error types

### Step 2: Create the function directory and file

Create `supabase/functions/<function-name>/index.ts`

Follow this template:

```typescript
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// ============================================================================
// Input Validation
// ============================================================================

class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ValidationError";
  }
}

function validateUuid(value: unknown, fieldName: string): string {
  if (typeof value !== "string") {
    throw new ValidationError(`${fieldName} must be a string`);
  }
  const uuidRegex =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  if (!uuidRegex.test(value)) {
    throw new ValidationError(`Invalid ${fieldName} format`);
  }
  return value;
}

function validateString(
  value: unknown,
  fieldName: string,
  maxLength: number
): string {
  if (typeof value !== "string") {
    throw new ValidationError(`${fieldName} must be a string`);
  }
  const trimmed = value.trim();
  if (trimmed.length === 0) {
    throw new ValidationError(`${fieldName} cannot be empty`);
  }
  if (trimmed.length > maxLength) {
    throw new ValidationError(
      `${fieldName} exceeds maximum length of ${maxLength}`
    );
  }
  return trimmed;
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
        {
          status: 401,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY")!;

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
        {
          status: 401,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const userId = user.id;

    // Admin client for privileged operations
    const adminClient = createClient(supabaseUrl, supabaseServiceKey);

    // ---- 2. Parse and validate input ----
    const body = await req.json();
    // TODO: Validate body fields using validateString/validateUuid

    // ---- 3. Business logic ----
    // TODO: Implement

    // ---- 4. Return response ----
    return new Response(
      JSON.stringify({ success: true }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Function error:", error);

    if (error instanceof ValidationError) {
      return new Response(
        JSON.stringify({ error: error.message }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    return new Response(
      JSON.stringify({ error: "An internal error occurred" }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});
```

### Step 3: Implement the business logic

Replace the TODO sections with actual logic based on the user's description. Follow these rules:

- **Always** validate all input fields before using them
- **Always** use `adminClient` (service role) for database writes, never the user client
- **Always** verify resource ownership before mutations (`WHERE user_id = userId`)
- **Never** expose the service role key in responses or logs
- **Enforce** premium/quota checks server-side if the feature is gated

### Step 4: Remind about deployment

After creating the function, remind the user:
```
Next steps:
1. Review the function code
2. Set required secrets: supabase secrets set KEY=value
3. Deploy: supabase functions deploy <function-name>
4. Test: curl -X POST https://<project>.supabase.co/functions/v1/<function-name> \
     -H "Authorization: Bearer <user-jwt>" \
     -H "Content-Type: application/json" \
     -d '{"key": "value"}'
```
