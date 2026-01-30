-- Populate test user profiles with complete data for testing
-- These are test accounts and will be deleted later

-- Update Alice (Manifestor 1/3)
UPDATE public.profiles
SET
    name = 'Alice Thompson',
    bio = 'Manifestor exploring the power of initiation. Love starting new projects and helping others understand their unique design.',
    avatar_url = 'https://i.pravatar.cc/150?u=alice@test.hd',
    birth_date = '1985-03-15 14:30:00+00',
    birth_location = '{"city": "New York", "country": "United States", "latitude": 40.7128, "longitude": -74.0060}',
    timezone = 'America/New_York',
    hd_type = 'Manifestor',
    hd_profile = '1/3',
    hd_authority = 'Emotional',
    is_public = true,
    show_chart_publicly = true,
    allow_messages = 'everyone'
WHERE email = 'alice@test.hd';

-- Update Bob (Generator 2/4)
UPDATE public.profiles
SET
    name = 'Bob Martinez',
    bio = 'Generator with endless energy for the things I love. Passionate about Human Design and helping people find their flow.',
    avatar_url = 'https://i.pravatar.cc/150?u=bob@test.hd',
    birth_date = '1990-07-22 09:15:00+00',
    birth_location = '{"city": "Los Angeles", "country": "United States", "latitude": 34.0522, "longitude": -118.2437}',
    timezone = 'America/Los_Angeles',
    hd_type = 'Generator',
    hd_profile = '2/4',
    hd_authority = 'Sacral',
    is_public = true,
    show_chart_publicly = true,
    allow_messages = 'everyone'
WHERE email = 'bob@test.hd';

-- Update Carol (Manifesting Generator 3/5)
UPDATE public.profiles
SET
    name = 'Carol Chen',
    bio = 'MG who loves to multi-task and find shortcuts. Always experimenting with new ways to live my design authentically.',
    avatar_url = 'https://i.pravatar.cc/150?u=carol@test.hd',
    birth_date = '1988-11-08 16:45:00+00',
    birth_location = '{"city": "San Francisco", "country": "United States", "latitude": 37.7749, "longitude": -122.4194}',
    timezone = 'America/Los_Angeles',
    hd_type = 'Manifesting Generator',
    hd_profile = '3/5',
    hd_authority = 'Emotional',
    is_public = true,
    show_chart_publicly = true,
    allow_messages = 'followers'
WHERE email = 'carol@test.hd';

-- Update David (Projector 4/6)
UPDATE public.profiles
SET
    name = 'David Wilson',
    bio = 'Projector learning to wait for the invitation. Guide and advisor specializing in helping others optimize their energy.',
    avatar_url = 'https://i.pravatar.cc/150?u=david@test.hd',
    birth_date = '1982-05-30 11:00:00+00',
    birth_location = '{"city": "London", "country": "United Kingdom", "latitude": 51.5074, "longitude": -0.1278}',
    timezone = 'Europe/London',
    hd_type = 'Projector',
    hd_profile = '4/6',
    hd_authority = 'Splenic',
    is_public = true,
    show_chart_publicly = true,
    allow_messages = 'everyone'
WHERE email = 'david@test.hd';

-- Update Emma (Reflector 5/1)
UPDATE public.profiles
SET
    name = 'Emma Johnson',
    bio = 'Reflector taking life one lunar cycle at a time. Mirror for the community and lover of deep connections.',
    avatar_url = 'https://i.pravatar.cc/150?u=emma@test.hd',
    birth_date = '1995-01-12 03:20:00+00',
    birth_location = '{"city": "Sydney", "country": "Australia", "latitude": -33.8688, "longitude": 151.2093}',
    timezone = 'Australia/Sydney',
    hd_type = 'Reflector',
    hd_profile = '5/1',
    hd_authority = 'Lunar',
    is_public = true,
    show_chart_publicly = true,
    allow_messages = 'followers'
WHERE email = 'emma@test.hd';

-- Update Frank (Generator 6/2)
UPDATE public.profiles
SET
    name = 'Frank Davis',
    bio = 'Generator on the roof, observing life. Third phase role model sharing wisdom from years of trial and error.',
    avatar_url = 'https://i.pravatar.cc/150?u=frank@test.hd',
    birth_date = '1975-09-18 20:00:00+00',
    birth_location = '{"city": "Chicago", "country": "United States", "latitude": 41.8781, "longitude": -87.6298}',
    timezone = 'America/Chicago',
    hd_type = 'Generator',
    hd_profile = '6/2',
    hd_authority = 'Sacral',
    is_public = true,
    show_chart_publicly = false,
    allow_messages = 'everyone'
WHERE email = 'frank@test.hd';

-- Update Grace (Projector 2/5)
UPDATE public.profiles
SET
    name = 'Grace Kim',
    bio = 'Projector with a talent for seeing what others need. Hermit who loves deep conversations when invited.',
    avatar_url = 'https://i.pravatar.cc/150?u=grace@test.hd',
    birth_date = '1992-04-05 07:30:00+00',
    birth_location = '{"city": "Seoul", "country": "South Korea", "latitude": 37.5665, "longitude": 126.9780}',
    timezone = 'Asia/Seoul',
    hd_type = 'Projector',
    hd_profile = '2/5',
    hd_authority = 'Self-Projected',
    is_public = true,
    show_chart_publicly = true,
    allow_messages = 'followers'
WHERE email = 'grace@test.hd';

-- Update Henry (Manifesting Generator 1/4)
UPDATE public.profiles
SET
    name = 'Henry Brown',
    bio = 'MG researcher who loves diving deep into Human Design foundations. Building a network of fellow enthusiasts.',
    avatar_url = 'https://i.pravatar.cc/150?u=henry@test.hd',
    birth_date = '1987-12-25 12:00:00+00',
    birth_location = '{"city": "Toronto", "country": "Canada", "latitude": 43.6532, "longitude": -79.3832}',
    timezone = 'America/Toronto',
    hd_type = 'Manifesting Generator',
    hd_profile = '1/4',
    hd_authority = 'Emotional',
    is_public = true,
    show_chart_publicly = true,
    allow_messages = 'everyone'
WHERE email = 'henry@test.hd';

-- Add gamification data for test users
-- First, ensure they have user_points records

INSERT INTO public.user_points (user_id, total_points, current_level, current_streak, longest_streak, last_activity_date)
SELECT id,
    CASE
        WHEN email = 'alice@test.hd' THEN 1250
        WHEN email = 'bob@test.hd' THEN 2100
        WHEN email = 'carol@test.hd' THEN 890
        WHEN email = 'david@test.hd' THEN 3500
        WHEN email = 'emma@test.hd' THEN 450
        WHEN email = 'frank@test.hd' THEN 5200
        WHEN email = 'grace@test.hd' THEN 1800
        WHEN email = 'henry@test.hd' THEN 720
    END,
    CASE
        WHEN email = 'alice@test.hd' THEN 5
        WHEN email = 'bob@test.hd' THEN 8
        WHEN email = 'carol@test.hd' THEN 4
        WHEN email = 'david@test.hd' THEN 12
        WHEN email = 'emma@test.hd' THEN 2
        WHEN email = 'frank@test.hd' THEN 15
        WHEN email = 'grace@test.hd' THEN 7
        WHEN email = 'henry@test.hd' THEN 3
    END,
    CASE
        WHEN email = 'alice@test.hd' THEN 5
        WHEN email = 'bob@test.hd' THEN 12
        WHEN email = 'carol@test.hd' THEN 3
        WHEN email = 'david@test.hd' THEN 30
        WHEN email = 'emma@test.hd' THEN 1
        WHEN email = 'frank@test.hd' THEN 45
        WHEN email = 'grace@test.hd' THEN 8
        WHEN email = 'henry@test.hd' THEN 2
    END,
    CASE
        WHEN email = 'alice@test.hd' THEN 15
        WHEN email = 'bob@test.hd' THEN 25
        WHEN email = 'carol@test.hd' THEN 10
        WHEN email = 'david@test.hd' THEN 60
        WHEN email = 'emma@test.hd' THEN 5
        WHEN email = 'frank@test.hd' THEN 90
        WHEN email = 'grace@test.hd' THEN 20
        WHEN email = 'henry@test.hd' THEN 8
    END,
    CURRENT_DATE
FROM public.profiles
WHERE email IN ('alice@test.hd', 'bob@test.hd', 'carol@test.hd', 'david@test.hd', 'emma@test.hd', 'frank@test.hd', 'grace@test.hd', 'henry@test.hd')
ON CONFLICT (user_id) DO UPDATE SET
    total_points = EXCLUDED.total_points,
    current_level = EXCLUDED.current_level,
    current_streak = EXCLUDED.current_streak,
    longest_streak = EXCLUDED.longest_streak,
    last_activity_date = EXCLUDED.last_activity_date;

-- Add some badges for test users
-- Give each test user 2-3 random badges from different categories
INSERT INTO public.user_badges (user_id, badge_id, earned_at)
SELECT p.id, b.id, NOW() - (random() * interval '30 days')
FROM public.profiles p
CROSS JOIN LATERAL (
    SELECT id FROM public.badges
    ORDER BY RANDOM()
    LIMIT 3
) b
WHERE p.email IN ('alice@test.hd', 'bob@test.hd', 'carol@test.hd', 'david@test.hd', 'frank@test.hd', 'grace@test.hd')
ON CONFLICT (user_id, badge_id) DO NOTHING;
