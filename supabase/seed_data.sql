-- ==================== Seed Data ====================
-- Initial data for badges, challenges, and learning content

-- ==================== Badges ====================
INSERT INTO public.badges (id, name, description, icon_name, category, tier, points_required, criteria) VALUES
-- Engagement badges
('b1000000-0000-0000-0000-000000000001', 'First Steps', 'Created your first Human Design chart', 'star', 'engagement', 'bronze', 0, '{"action": "create_chart", "count": 1}'),
('b1000000-0000-0000-0000-000000000002', 'Chart Explorer', 'Created 5 charts for yourself or others', 'explore', 'engagement', 'silver', 100, '{"action": "create_chart", "count": 5}'),
('b1000000-0000-0000-0000-000000000003', 'Chart Master', 'Created 25 charts', 'workspace_premium', 'engagement', 'gold', 500, '{"action": "create_chart", "count": 25}'),
('b1000000-0000-0000-0000-000000000004', 'Social Butterfly', 'Made your first friend connection', 'people', 'social', 'bronze', 0, '{"action": "add_friend", "count": 1}'),
('b1000000-0000-0000-0000-000000000005', 'Community Builder', 'Connected with 10 friends', 'groups', 'social', 'silver', 200, '{"action": "add_friend", "count": 10}'),
('b1000000-0000-0000-0000-000000000006', 'Influencer', 'Connected with 50 friends', 'hub', 'social', 'gold', 1000, '{"action": "add_friend", "count": 50}'),

-- Learning badges
('b2000000-0000-0000-0000-000000000001', 'Curious Mind', 'Completed your first learning module', 'school', 'learning', 'bronze', 0, '{"action": "complete_content", "count": 1}'),
('b2000000-0000-0000-0000-000000000002', 'Knowledge Seeker', 'Completed 10 learning modules', 'auto_stories', 'learning', 'silver', 300, '{"action": "complete_content", "count": 10}'),
('b2000000-0000-0000-0000-000000000003', 'HD Scholar', 'Completed 50 learning modules', 'psychology', 'learning', 'gold', 1500, '{"action": "complete_content", "count": 50}'),

-- Type-specific badges
('b3000000-0000-0000-0000-000000000001', 'Manifestor Pride', 'Verified as a Manifestor type', 'bolt', 'type', 'bronze', 0, '{"type": "Manifestor"}'),
('b3000000-0000-0000-0000-000000000002', 'Generator Power', 'Verified as a Generator type', 'battery_charging_full', 'type', 'bronze', 0, '{"type": "Generator"}'),
('b3000000-0000-0000-0000-000000000003', 'MG Energy', 'Verified as a Manifesting Generator', 'electric_bolt', 'type', 'bronze', 0, '{"type": "Manifesting Generator"}'),
('b3000000-0000-0000-0000-000000000004', 'Projector Wisdom', 'Verified as a Projector type', 'visibility', 'type', 'bronze', 0, '{"type": "Projector"}'),
('b3000000-0000-0000-0000-000000000005', 'Reflector Mirror', 'Verified as a Reflector type', 'blur_circular', 'type', 'bronze', 0, '{"type": "Reflector"}'),

-- Streak badges
('b4000000-0000-0000-0000-000000000001', 'Week Warrior', '7-day login streak', 'local_fire_department', 'streak', 'bronze', 50, '{"action": "login_streak", "days": 7}'),
('b4000000-0000-0000-0000-000000000002', 'Month Master', '30-day login streak', 'whatshot', 'streak', 'silver', 300, '{"action": "login_streak", "days": 30}'),
('b4000000-0000-0000-0000-000000000003', 'Year Champion', '365-day login streak', 'emoji_events', 'streak', 'gold', 3650, '{"action": "login_streak", "days": 365}');

-- ==================== Challenges ====================
INSERT INTO public.challenges (id, title, description, challenge_type, criteria, points_reward, start_date, end_date, is_active) VALUES
-- Daily challenges
('c1000000-0000-0000-0000-000000000001', 'Daily Check-in', 'Open the app and view your chart today', 'daily', '{"action": "view_chart", "count": 1}', 10, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 day', true),
('c1000000-0000-0000-0000-000000000002', 'Transit Tracker', 'Check today''s transits and how they affect you', 'daily', '{"action": "view_transits", "count": 1}', 15, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 day', true),
('c1000000-0000-0000-0000-000000000003', 'Social Connect', 'View a friend''s chart or profile', 'daily', '{"action": "view_friend", "count": 1}', 10, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 day', true),

-- Weekly challenges
('c2000000-0000-0000-0000-000000000001', 'Learning Week', 'Complete 3 learning modules this week', 'weekly', '{"action": "complete_content", "count": 3}', 100, DATE_TRUNC('week', CURRENT_DATE), DATE_TRUNC('week', CURRENT_DATE) + INTERVAL '1 week', true),
('c2000000-0000-0000-0000-000000000002', 'Chart Creator', 'Create 2 new charts this week', 'weekly', '{"action": "create_chart", "count": 2}', 75, DATE_TRUNC('week', CURRENT_DATE), DATE_TRUNC('week', CURRENT_DATE) + INTERVAL '1 week', true),
('c2000000-0000-0000-0000-000000000003', 'Community Contributor', 'Post or comment 5 times this week', 'weekly', '{"action": "social_interaction", "count": 5}', 80, DATE_TRUNC('week', CURRENT_DATE), DATE_TRUNC('week', CURRENT_DATE) + INTERVAL '1 week', true),

-- Monthly challenges
('c3000000-0000-0000-0000-000000000001', 'HD Expert', 'Complete 10 learning modules this month', 'monthly', '{"action": "complete_content", "count": 10}', 500, DATE_TRUNC('month', CURRENT_DATE), DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month', true),
('c3000000-0000-0000-0000-000000000002', 'Network Builder', 'Connect with 5 new friends this month', 'monthly', '{"action": "add_friend", "count": 5}', 400, DATE_TRUNC('month', CURRENT_DATE), DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month', true);

-- ==================== Learning Content ====================
INSERT INTO public.content_library (id, title, content, content_type, category, is_official, is_premium, is_published, estimated_read_time, tags) VALUES
-- Introduction articles
('l1000000-0000-0000-0000-000000000001', 'What is Human Design?',
'Human Design is a synthesis of ancient and modern sciences that provides a unique blueprint of your energetic makeup. Created by Ra Uru Hu in 1987, it combines elements of:

• **Astrology** - planetary positions at birth
• **I Ching** - the 64 hexagrams as 64 gates
• **Kabbalah** - the Tree of Life as the bodygraph
• **Chakra System** - the 9 energy centers
• **Quantum Physics** - neutrino science

Your Human Design chart reveals:
- Your **Type** - your role and how you interact with the world
- Your **Strategy** - how to make aligned decisions
- Your **Authority** - your inner guidance system
- Your **Profile** - your personality and life purpose
- Your **Centers** - your consistent and inconsistent energies

Understanding your design helps you live authentically, make better decisions, and improve relationships.',
'article', 'general', true, false, true, 5, ARRAY['introduction', 'basics', 'overview']),

('l1000000-0000-0000-0000-000000000002', 'The 5 Human Design Types',
'There are five distinct Types in Human Design, each with a unique role and strategy:

## Manifestor (9% of population)
**Role**: Initiators and catalysts
**Strategy**: Inform before acting
**Signature**: Peace
**Not-Self Theme**: Anger

Manifestors are here to initiate and impact. They have a closed, repelling aura that protects their independence.

## Generator (37% of population)
**Role**: Life force and builders
**Strategy**: Wait to respond
**Signature**: Satisfaction
**Not-Self Theme**: Frustration

Generators have sustainable energy when doing work they love. Their open, enveloping aura draws life to them.

## Manifesting Generator (33% of population)
**Role**: Multi-passionate doers
**Strategy**: Wait to respond, then inform
**Signature**: Satisfaction
**Not-Self Theme**: Frustration and Anger

MGs are Generators with Manifestor qualities - they move fast and often have multiple interests.

## Projector (20% of population)
**Role**: Guides and managers
**Strategy**: Wait for the invitation
**Signature**: Success
**Not-Self Theme**: Bitterness

Projectors see others deeply and are here to guide energy, not generate it. Their focused, absorbing aura reads others.

## Reflector (1% of population)
**Role**: Mirrors of community health
**Strategy**: Wait a lunar cycle (28 days)
**Signature**: Surprise
**Not-Self Theme**: Disappointment

Reflectors have all centers undefined, making them completely open to their environment. They reflect the health of their community.',
'article', 'type', true, false, true, 8, ARRAY['types', 'basics', 'strategy']),

('l1000000-0000-0000-0000-000000000003', 'Understanding Your Authority',
'Your Authority is your inner decision-making guidance system. It tells you HOW to make correct decisions for yourself.

## Emotional Authority (50% of people)
If you have a defined Solar Plexus, you have Emotional Authority. Never make decisions in the moment - wait through your emotional wave. There is no truth in the now for you. Sleep on big decisions.

## Sacral Authority (35% of people)
Generators without a defined Solar Plexus have Sacral Authority. Listen to your gut responses: "uh-huh" (yes) or "uhn-uhn" (no). Your body knows before your mind.

## Splenic Authority (11% of people)
Rare and instantaneous. The Spleen speaks once, quietly, in the moment. Trust your instincts and intuition - it''s about survival and wellbeing.

## Ego/Heart Authority (1% of people)
Your willpower guides you. Ask yourself: "Do I want this?" and "What''s in it for me?" Honor your commitments and rest.

## Self-Projected Authority
Your truth comes through your voice. Talk things out with others (not for advice, but to hear yourself). Your identity guides you.

## Environmental/Mental Authority
You need the right environment and people to bounce ideas off. Decision clarity comes from being in correct places.

## Lunar Authority (Reflectors only)
Wait 28 days (a full lunar cycle) for major decisions. Sample the experience over time.',
'article', 'authority', true, false, true, 7, ARRAY['authority', 'decision-making', 'strategy']),

('l1000000-0000-0000-0000-000000000004', 'The 9 Centers Explained',
'The Human Design bodygraph contains 9 Centers, evolved from the 7 chakras. Each center represents specific themes and energies.

## Head Center (top)
**Theme**: Inspiration, mental pressure, questions
**Defined**: Consistent source of inspiration
**Undefined**: Open to many questions and inspirations

## Ajna Center
**Theme**: Conceptualization, thinking patterns, opinions
**Defined**: Fixed way of processing information
**Undefined**: Flexible thinking, can see all perspectives

## Throat Center
**Theme**: Communication, manifestation, action
**Defined**: Consistent voice and expression
**Undefined**: Variable communication style

## G Center (Identity)
**Theme**: Identity, love, direction, higher self
**Defined**: Fixed sense of self and direction
**Undefined**: Adaptable identity, chameleon-like

## Heart/Ego Center
**Theme**: Willpower, ego, material world, value
**Defined**: Reliable willpower (use wisely!)
**Undefined**: Nothing to prove, avoid promises

## Sacral Center
**Theme**: Life force, sexuality, work capacity
**Defined**: Sustainable energy (Generators/MGs)
**Undefined**: Borrowed energy, need rest (Projectors/Manifestors/Reflectors)

## Solar Plexus Center
**Theme**: Emotions, desires, sensitivity
**Defined**: Emotional wave, emotional authority
**Undefined**: Empathic, amplifies others'' emotions

## Spleen Center
**Theme**: Intuition, immune system, survival, timing
**Defined**: Consistent intuition and wellbeing sense
**Undefined**: Sensitive to environment, holds onto what''s unhealthy

## Root Center (bottom)
**Theme**: Adrenaline, pressure, stress, drive
**Defined**: Consistent way of handling pressure
**Undefined**: Amplifies stress, rushing to be free of pressure',
'article', 'center', true, false, true, 10, ARRAY['centers', 'bodygraph', 'basics']),

('l1000000-0000-0000-0000-000000000005', 'Introduction to Gates and Channels',
'The 64 Gates and 36 Channels form the circuitry of your Human Design chart.

## The 64 Gates
Gates are derived from the I Ching hexagrams. Each gate represents a specific energy or theme. When a gate is activated (colored in), you have consistent access to that energy.

Gates can be activated:
- **Consciously** (black/personality) - energies you''re aware of
- **Unconsciously** (red/design) - energies others see in you

## The 36 Channels
A Channel is formed when both gates on either end are activated. Channels connect two centers and create **definition** - reliable, consistent energy.

### Channel Types by Circuit:
**Individual Circuit** - Mutation, empowerment, melancholy
**Collective Circuit** - Sharing (logic or abstract patterns)
**Tribal Circuit** - Support, resources, agreements

## Reading Your Channels
When you have a full channel:
1. Both centers become **defined** (colored)
2. You have consistent access to that energy
3. The theme of the channel is part of your design

## Hanging Gates
Gates without the connecting gate are "hanging gates." These create attraction to others who have the completing gate - this is how we connect and need each other.',
'article', 'channel', true, false, true, 6, ARRAY['gates', 'channels', 'circuitry', 'basics']),

-- Premium content
('l2000000-0000-0000-0000-000000000001', 'Deep Dive: The 12 Profiles',
'Your Profile is a crucial aspect of your Human Design, revealing your personality costume and life purpose...

[Premium content - detailed exploration of all 12 profiles with examples and guidance]',
'article', 'profile', true, true, true, 15, ARRAY['profiles', 'advanced', 'personality']),

('l2000000-0000-0000-0000-000000000002', 'Incarnation Crosses Explained',
'Your Incarnation Cross represents your life purpose and is determined by the gates of your Sun and Earth...

[Premium content - understanding your unique life purpose through your cross]',
'article', 'general', true, true, true, 20, ARRAY['incarnation cross', 'purpose', 'advanced']),

-- Gate-specific content
('l3000000-0000-0000-0000-000000000001', 'Gate 1: The Creative',
'## Gate 1 - The Gate of Self-Expression

**Center**: G Center
**Circuit**: Individual (Knowing)
**Channel**: 1-8 (Inspiration)

Gate 1 carries the energy of pure creative self-expression. Those with this gate have a deep need to express their unique individuality.

### Themes:
- Creative self-expression
- Uniqueness and individuality
- Leading by example
- Artistic inspiration

### Shadow/Gift/Siddhi:
- **Shadow**: Entropy (feeling creatively blocked)
- **Gift**: Freshness (authentic self-expression)
- **Siddhi**: Beauty (transcendent creativity)

### In Your Chart:
If you have Gate 1, you''re here to express your unique creative essence. You don''t need permission to be yourself.',
'article', 'gate', true, false, true, 4, ARRAY['gate 1', 'g center', 'creativity']),

('l3000000-0000-0000-0000-000000000002', 'Gate 2: The Direction of Self',
'## Gate 2 - The Gate of the Direction of Self

**Center**: G Center
**Circuit**: Individual (Knowing)
**Channel**: 2-14 (The Beat)

Gate 2 is the Driver - the receptive feminine that knows the direction. It''s about being a vessel for higher direction.

### Themes:
- Receptivity to direction
- Natural orientation
- Driver of resources
- Magnetic presence

### Shadow/Gift/Siddhi:
- **Shadow**: Dislocation (feeling lost)
- **Gift**: Orientation (natural knowing of direction)
- **Siddhi**: Unity (oneness with all direction)

### In Your Chart:
If you have Gate 2, you have a natural sense of direction when you''re relaxed and receptive. Don''t push - allow direction to come.',
'article', 'gate', true, false, true, 4, ARRAY['gate 2', 'g center', 'direction']);

-- ==================== Sample Live Sessions ====================
INSERT INTO public.live_sessions (id, title, description, session_type, scheduled_at, duration_minutes, max_participants, is_premium, status, tags) VALUES
('s1000000-0000-0000-0000-000000000001', 'Introduction to Human Design Q&A', 'Ask any questions about Human Design basics. Perfect for newcomers!', 'q_and_a', NOW() + INTERVAL '7 days', 60, 50, false, 'scheduled', ARRAY['basics', 'q&a', 'beginners']),
('s1000000-0000-0000-0000-000000000002', 'Understanding Your Type Workshop', 'Deep dive into the 5 Types and their strategies', 'workshop', NOW() + INTERVAL '14 days', 90, 30, false, 'scheduled', ARRAY['types', 'workshop', 'strategy']),
('s1000000-0000-0000-0000-000000000003', 'Premium: Personal Chart Reading Demo', 'Watch a live chart reading and learn how to interpret charts', 'workshop', NOW() + INTERVAL '10 days', 120, 20, true, 'scheduled', ARRAY['reading', 'premium', 'advanced']);

SELECT 'Seed data inserted successfully!' as result;
