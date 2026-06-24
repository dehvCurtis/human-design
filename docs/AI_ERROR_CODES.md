# AI Chat Edge Function Error Codes

Error responses from the `ai-chat` edge function include a `code` field for programmatic handling.

## Response Format

```json
{
  "error": "Human-readable error message",
  "code": "ERROR_CODE"
}
```

## Error Codes

| Code | HTTP Status | Description | User Action |
|------|-------------|-------------|-------------|
| `AUTH_MISSING` | 401 | No Authorization header in request | Re-authenticate / sign in again |
| `AUTH_INVALID` | 401 | JWT is expired or invalid | Re-authenticate / sign in again |
| `RATE_LIMITED` | 429 | Too many requests per minute (max 10/min) | Wait and retry |
| `QUOTA_EXCEEDED` | 429 | Monthly free message limit reached | Upgrade to Premium |
| `VALIDATION_ERROR` | 400 | Invalid input (empty message, too long, bad UUID) | Fix input and retry |
| `CONVERSATION_NOT_FOUND` | 404 | Conversation ID doesn't exist or belongs to another user | Start a new conversation |
| `CONVERSATION_CREATE_FAILED` | 500 | Database error creating conversation | Retry; if persistent, check DB |
| `USAGE_TRACKING_FAILED` | 503 | Could not increment usage counter | Retry; if persistent, check DB RPCs |
| `AI_PROVIDER_ERROR` | 502 | AI provider API returned an error | Retry; check provider status/model ID |
| `AI_NOT_CONFIGURED` | 500 | API key not set for the configured AI provider | Set secrets: `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`, or `OPENAI_API_KEY` |
| `INTERNAL_ERROR` | 500 | Unhandled server error | Check edge function logs |

## Debugging Checklist

1. **`AI_NOT_CONFIGURED`** - Run `supabase secrets list` to verify API keys are set
2. **`AI_PROVIDER_ERROR`** - Check the model ID is valid and the API key has credits
3. **`AUTH_INVALID`** - User's session may have expired; trigger a token refresh
4. **`RATE_LIMITED`** - Client should implement exponential backoff
5. **`QUOTA_EXCEEDED`** - Check `ai_usage` table for the user's current period

## Environment Variables

| Variable | Required When | Description |
|----------|---------------|-------------|
| `AI_PROVIDER` | Always (default: `claude`) | `claude`, `gemini`, or `openai` |
| `ANTHROPIC_API_KEY` | `AI_PROVIDER=claude` | Anthropic API key |
| `GEMINI_API_KEY` | `AI_PROVIDER=gemini` | Google Gemini API key |
| `OPENAI_API_KEY` | `AI_PROVIDER=openai` | OpenAI API key |
