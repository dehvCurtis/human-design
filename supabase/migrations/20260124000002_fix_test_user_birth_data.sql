-- Fix test user profiles with complete birth data for chart calculation
-- and ensure chart_visibility is set correctly

-- Update Alice (Manifestor 1/3)
UPDATE public.profiles
SET
    birth_location = '{"city": "New York", "country": "United States", "latitude": 40.7128, "longitude": -74.0060}'::jsonb,
    timezone = 'America/New_York',
    chart_visibility = 'public'
WHERE email = 'alice@test.hd';

-- Update Bob (Generator 2/4)
UPDATE public.profiles
SET
    birth_location = '{"city": "Los Angeles", "country": "United States", "latitude": 34.0522, "longitude": -118.2437}'::jsonb,
    timezone = 'America/Los_Angeles',
    chart_visibility = 'public'
WHERE email = 'bob@test.hd';

-- Update Carol (Manifesting Generator 3/5)
UPDATE public.profiles
SET
    birth_location = '{"city": "San Francisco", "country": "United States", "latitude": 37.7749, "longitude": -122.4194}'::jsonb,
    timezone = 'America/Los_Angeles',
    chart_visibility = 'public'
WHERE email = 'carol@test.hd';

-- Update David (Projector 4/6)
UPDATE public.profiles
SET
    birth_location = '{"city": "London", "country": "United Kingdom", "latitude": 51.5074, "longitude": -0.1278}'::jsonb,
    timezone = 'Europe/London',
    chart_visibility = 'public'
WHERE email = 'david@test.hd';

-- Update Emma (Reflector 5/1)
UPDATE public.profiles
SET
    birth_location = '{"city": "Sydney", "country": "Australia", "latitude": -33.8688, "longitude": 151.2093}'::jsonb,
    timezone = 'Australia/Sydney',
    chart_visibility = 'public'
WHERE email = 'emma@test.hd';

-- Update Frank (Generator 6/2) - Friends only visibility
UPDATE public.profiles
SET
    birth_location = '{"city": "Chicago", "country": "United States", "latitude": 41.8781, "longitude": -87.6298}'::jsonb,
    timezone = 'America/Chicago',
    chart_visibility = 'friends'
WHERE email = 'frank@test.hd';

-- Update Grace (Projector 2/5)
UPDATE public.profiles
SET
    birth_location = '{"city": "Seoul", "country": "South Korea", "latitude": 37.5665, "longitude": 126.9780}'::jsonb,
    timezone = 'Asia/Seoul',
    chart_visibility = 'public'
WHERE email = 'grace@test.hd';

-- Update Henry (Manifesting Generator 1/4)
UPDATE public.profiles
SET
    birth_location = '{"city": "Toronto", "country": "Canada", "latitude": 43.6532, "longitude": -79.3832}'::jsonb,
    timezone = 'America/Toronto',
    chart_visibility = 'public'
WHERE email = 'henry@test.hd';
