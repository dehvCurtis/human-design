# Test Users

This document lists the test users available for development and testing of social features.

> **Note:** These are temporary test accounts that will be deleted. Credentials are intentionally shared for testing purposes only.

## Main Test Account

| Field | Value |
|-------|-------|
| **Email** | `test@humandesign.app` |
| **Password** | *(set during signup)* |
| **User ID** | `afba19ba-08ca-44a3-b5c7-fa2a141916e5` |

## Test User Accounts

All test users share the same password: **`TestPass123`**

| Name | Email | Type | Profile | Authority | Location |
|------|-------|------|---------|-----------|----------|
| Alice Thompson | `alice@test.hd` | Manifestor | 1/3 | Emotional | New York, USA |
| Bob Martinez | `bob@test.hd` | Generator | 2/4 | Sacral | Los Angeles, USA |
| Carol Chen | `carol@test.hd` | Manifesting Generator | 3/5 | Emotional | San Francisco, USA |
| David Wilson | `david@test.hd` | Projector | 4/6 | Splenic | London, UK |
| Emma Johnson | `emma@test.hd` | Reflector | 5/1 | Lunar | Sydney, Australia |
| Frank Davis | `frank@test.hd` | Generator | 6/2 | Sacral | Chicago, USA |
| Grace Kim | `grace@test.hd` | Projector | 2/5 | Self-Projected | Seoul, South Korea |
| Henry Brown | `henry@test.hd` | Manifesting Generator | 1/4 | Emotional | Toronto, Canada |

### Full Profile Data

Each test user has complete profile data including:
- **Birth data**: Date, time, and location with coordinates
- **Avatar**: Unique avatar from pravatar.cc
- **Bio**: HD-themed bio describing their type/experience
- **Visibility**: Public profiles with chart visibility enabled (except Frank)
- **Gamification**: Points (450-5200), levels (2-15), and streaks (1-45 days)
- **Badges**: 2-3 random badges per user

## Pre-configured Relationships

### Follow Relationships (for test@humandesign.app)

| Direction | Users |
|-----------|-------|
| **Followers** (7) | Alice, Bob, Carol, David, Emma, Frank, Grace |
| **Following** (5) | Alice, Bob, Carol, David, Henry |

## Test Posts

Each test user has created a post in the feed:

| User | Post Type | Content Preview |
|------|-----------|-----------------|
| Alice | insight | "Just had an amazing manifestor moment..." |
| Bob | reflection | "Sacral said YES today..." |
| Carol | insight | "Riding my emotional wave today..." |
| David | reflection | "Received an amazing invitation today..." |
| Emma | question | "New moon tonight! Making my monthly decisions..." |
| Frank | transit_share | "Gate 34 transit hitting different today..." |
| Grace | insight | "Just analyzed my first composite chart..." |
| Henry | reflection | "Multi-passionate MG life: started 3 new projects..." |

## HD Type Coverage

The test users cover all 5 Human Design types:

| Type | Users |
|------|-------|
| Manifestor | Alice |
| Generator | Bob, Frank |
| Manifesting Generator | Carol, Henry |
| Projector | David, Grace |
| Reflector | Emma |

## Authority Coverage

| Authority | Users |
|-----------|-------|
| Emotional | Alice, Carol, Henry |
| Sacral | Bob, Frank |
| Splenic | David |
| Self-Projected | Grace |
| Lunar | Emma |

## Profile Coverage

| Profile | User |
|---------|------|
| 1/3 | Alice |
| 1/4 | Henry |
| 2/4 | Bob |
| 2/5 | Grace |
| 3/5 | Carol |
| 4/6 | David |
| 5/1 | Emma |
| 6/2 | Frank |

## Recreating Test Data

If you need to recreate the test data, run the seed script:

```bash
# Using Supabase SQL Editor (Dashboard)
# Copy contents of: supabase/seed_test_users.sql

# Or use the REST API script approach documented in the migration
```

The seed scripts are located at:
- `supabase/seed_test_users.sql` - Full seed with auth users
- `supabase/seed_test_social_data.sql` - Social relationships only

## Cleanup

To remove test users, delete them from the Supabase Dashboard:
1. Go to Authentication > Users
2. Delete users with `@test.hd` email domain
3. The cascade delete will remove all related data (profiles, posts, follows)
