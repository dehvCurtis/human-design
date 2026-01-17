import '../../../core/constants/human_design_constants.dart';

/// Affirmations organized by Human Design type
const Map<HumanDesignType, List<String>> typeAffirmations = {
  HumanDesignType.manifestor: [
    'I inform others and then act on my creative urges.',
    'My impact on the world is meant to be felt.',
    'I honor my need for independence while staying connected.',
    'I initiate when the time feels right for me.',
    'My anger is a signal that something needs to change.',
    'I am here to set things in motion.',
    'I create space for my unique vision to unfold.',
    'My peace comes from informing before I act.',
    'I trust my inner knowing about when to begin.',
    'I release the need for permission to be who I am.',
  ],
  HumanDesignType.generator: [
    'I wait to respond to what life brings me.',
    'My sacral response guides me to right action.',
    'I honor my energy by doing work that lights me up.',
    'Satisfaction comes when I use my energy wisely.',
    'I trust my gut response—it knows what is correct for me.',
    'I am a powerful life force when aligned with my truth.',
    'I release frustration by returning to what I love.',
    'My "uh-huh" and "uhn-uhn" are my guiding compass.',
    'I build mastery through responding to what excites me.',
    'My energy is sustainable when I follow my response.',
  ],
  HumanDesignType.manifestingGenerator: [
    'I respond and then inform before taking action.',
    'My multi-passionate nature is my superpower.',
    'I honor my need to move quickly once I have responded.',
    'It is okay for me to change directions when something no longer excites me.',
    'My satisfaction comes from efficient, joyful work.',
    'I trust my sacral response to guide my many interests.',
    'I skip steps wisely while honoring my commitments.',
    'My frustration signals I am not following my response.',
    'I embrace being a specialist at many things.',
    'Speed and response are my natural way of operating.',
  ],
  HumanDesignType.projector: [
    'I wait for recognition and invitation in important decisions.',
    'My wisdom is valued when I am truly seen.',
    'I honor my need for rest and manage my energy wisely.',
    'Success comes when I am invited to share my gifts.',
    'I release bitterness by focusing on those who recognize me.',
    'My guidance is powerful when offered to receptive people.',
    'I am here to see and guide, not to do the doing.',
    'Waiting for invitation protects my energy and ensures success.',
    'I study and master what fascinates me.',
    'My value does not depend on how much I produce.',
  ],
  HumanDesignType.reflector: [
    'I take my time—a full lunar cycle—for major decisions.',
    'I am a mirror reflecting the health of my community.',
    'My sensitivity is a gift that shows me what needs attention.',
    'Surprise and delight are my natural state when I am in the right place.',
    'I honor my ever-changing nature as my strength.',
    'Disappointment signals I am in the wrong environment.',
    'I sample life without identifying with any one energy.',
    'The Moon is my guide; I follow its wisdom.',
    'I am here to reflect back what I see with compassion.',
    'My openness allows me to experience life in unique ways.',
  ],
};

/// Affirmations based on gate energies
const Map<int, List<String>> gateAffirmations = {
  1: [
    'I express my creative self authentically.',
    'My individuality is my contribution to the world.',
    'I trust my unique creative expression.',
  ],
  2: [
    'I am receptive to the direction that emerges naturally.',
    'I allow myself to be guided without forcing direction.',
    'My receptivity is my strength.',
  ],
  3: [
    'I embrace the chaos that precedes new order.',
    'Difficulty at the beginning leads to innovation.',
    'I trust the mutation process of life.',
  ],
  4: [
    'I formulate answers when asked, not before.',
    'My mental solutions come when they are needed.',
    'I release the pressure to have all the answers.',
  ],
  5: [
    'I honor my natural rhythms and patterns.',
    'Waiting in my rhythm brings what I need.',
    'My fixed patterns create stability.',
  ],
  6: [
    'I navigate conflict with emotional awareness.',
    'Intimacy grows through honest friction.',
    'I embrace the depth that comes from emotional truth.',
  ],
  7: [
    'I lead by example, not by force.',
    'My role in democracy is to guide when asked.',
    'Leadership emerges naturally when I am recognized.',
  ],
  8: [
    'I contribute my unique style to the collective.',
    'My creative contribution matters.',
    'I express individuality through my work.',
  ],
  9: [
    'I focus my energy on what truly matters.',
    'Small details build great foundations.',
    'My determination carries me through.',
  ],
  10: [
    'I behave authentically regardless of others\' expectations.',
    'Self-love is the foundation of my well-being.',
    'I embrace all aspects of who I am.',
  ],
  // ... Gates 11-64 would continue similarly
  11: [
    'I embrace new ideas as they flow through me.',
    'My ideas are meant to be shared, not hoarded.',
    'Peaceful contemplation brings clarity.',
  ],
  12: [
    'I speak when the timing and mood are right.',
    'Caution in expression protects my message.',
    'My voice carries social impact.',
  ],
  13: [
    'I listen deeply to others\' stories.',
    'I hold secrets with honor and discretion.',
    'My role as witness brings healing.',
  ],
  14: [
    'I use my resources to empower others.',
    'Abundance flows through aligned action.',
    'My power skills create prosperity.',
  ],
  15: [
    'I embrace the full range of human experience.',
    'My rhythm may differ from others—and that is okay.',
    'Extremes teach me about balance.',
  ],
  16: [
    'I develop skills through dedicated practice.',
    'Enthusiasm fuels my mastery.',
    'My talents unfold through experimentation.',
  ],
  17: [
    'I share opinions only when asked.',
    'My logical perspective helps organize chaos.',
    'Others follow when my patterns prove reliable.',
  ],
  18: [
    'I correct patterns that need improvement.',
    'My critical eye serves evolution.',
    'Judgment transforms into healing insight.',
  ],
  19: [
    'I approach others with sensitivity to their needs.',
    'My desire for connection is natural.',
    'I honor both my needs and the needs of others.',
  ],
  20: [
    'I express authentically in the present moment.',
    'Contemplation leads to wise action.',
    'I am fully present in the now.',
  ],
  21: [
    'I control my own resources wisely.',
    'My willpower is directed toward what matters.',
    'I bite through obstacles with determination.',
  ],
  22: [
    'My emotional openness invites grace.',
    'I share my mood when the timing is right.',
    'Beauty emerges through emotional expression.',
  ],
  23: [
    'I simplify complex ideas for others.',
    'Speaking my knowing requires the right timing.',
    'My unique voice breaks through convention.',
  ],
  24: [
    'I revisit ideas until they crystallize.',
    'Rationalization leads to understanding.',
    'Returning to concepts brings new insight.',
  ],
  25: [
    'I love unconditionally without expectation.',
    'My innocence is a form of spiritual strength.',
    'I embrace the universal spirit within me.',
  ],
  26: [
    'I use my influence with integrity.',
    'My persuasive abilities serve truth.',
    'I honor my need for material success.',
  ],
  27: [
    'I nourish and care for those who need it.',
    'My caring nature extends to myself as well.',
    'Preservation of life is my natural gift.',
  ],
  28: [
    'I embrace the struggle that leads to purpose.',
    'My game-playing spirit finds meaning.',
    'Risk is part of my path to fulfillment.',
  ],
  29: [
    'I commit fully once I have responded.',
    'Perseverance carries me through challenges.',
    'I say yes only when my body agrees.',
  ],
  30: [
    'I embrace the full range of my feelings.',
    'Desire fuels my experiences.',
    'My emotional fire illuminates new paths.',
  ],
  31: [
    'I lead with influence, not control.',
    'My voice carries democratic authority.',
    'Recognition brings out my leadership.',
  ],
  32: [
    'I recognize what has enduring value.',
    'Transformation happens through patient waiting.',
    'I sense what can survive and thrive.',
  ],
  33: [
    'I retreat to process my experiences.',
    'Sharing my stories comes when time has passed.',
    'Privacy allows me to integrate life.',
  ],
  34: [
    'My power is available in response.',
    'I use my energy for what truly matters.',
    'My great power requires great awareness.',
  ],
  35: [
    'I seek new experiences that bring growth.',
    'Change and progress are my nature.',
    'Each experience adds to my wisdom.',
  ],
  36: [
    'I learn through emotional experiences.',
    'Crisis leads to new emotional depth.',
    'Inexperience transforms into wisdom.',
  ],
  37: [
    'I nurture harmony in my community.',
    'My friendships are based on mutual support.',
    'Family extends to all those I care for.',
  ],
  38: [
    'I fight for what has meaning to me.',
    'Opposition strengthens my conviction.',
    'My struggle serves individual purpose.',
  ],
  39: [
    'I provoke emotions to move energy.',
    'My spirit breaks through stagnation.',
    'Provocation serves awakening.',
  ],
  40: [
    'I value my alone time and restoration.',
    'Aloneness prepares me for true connection.',
    'I give from a place of fullness.',
  ],
  41: [
    'I honor my dreams and imaginings.',
    'New beginnings emerge from inner vision.',
    'I contract before I expand.',
  ],
  42: [
    'I bring things to completion.',
    'Growth comes through finishing what I start.',
    'Each cycle completes in its own time.',
  ],
  43: [
    'I know things without knowing how I know.',
    'My insights require the right ears.',
    'Breakthrough happens when I am heard.',
  ],
  44: [
    'I sense patterns from the past.',
    'Alertness serves my community.',
    'I recognize what has come before.',
  ],
  45: [
    'I gather resources for the collective.',
    'My leadership serves material well-being.',
    'Education and resources flow through me.',
  ],
  46: [
    'I commit fully to life in this body.',
    'Good fortune comes through embodiment.',
    'My body is my vehicle for love.',
  ],
  47: [
    'I realize meaning from abstract experiences.',
    'Oppressive times lead to realization.',
    'Understanding comes in its own time.',
  ],
  48: [
    'I trust my depth of knowledge.',
    'My well of wisdom fills over time.',
    'Adequacy comes through patient development.',
  ],
  49: [
    'I honor my principles and values.',
    'Revolution serves necessary change.',
    'My rejection creates needed boundaries.',
  ],
  50: [
    'I establish and uphold values.',
    'My responsibility is to what I value.',
    'Nurturing through law and order.',
  ],
  51: [
    'I initiate others into new experiences.',
    'Shock awakens dormant potential.',
    'My competitive spirit serves evolution.',
  ],
  52: [
    'I embrace stillness and concentration.',
    'Focus brings depth of understanding.',
    'My stillness is not laziness—it is power.',
  ],
  53: [
    'I begin new cycles with enthusiasm.',
    'Starting is my gift; completion may be others\'.',
    'Development unfolds through new beginnings.',
  ],
  54: [
    'I transform through ambition and drive.',
    'My ambition serves my community.',
    'Rising up is my natural movement.',
  ],
  55: [
    'I embrace the full spectrum of emotions.',
    'Abundance flows through emotional clarity.',
    'My spirit soars through feeling.',
  ],
  56: [
    'I stimulate others through storytelling.',
    'My experiences become teaching moments.',
    'Ideas come to life through my words.',
  ],
  57: [
    'I trust my intuitive knowing.',
    'My intuition speaks in the moment.',
    'Gentle awareness guides my path.',
  ],
  58: [
    'I bring vitality and joy to life.',
    'My zest for life is contagious.',
    'Joyful challenge fuels my energy.',
  ],
  59: [
    'I break down barriers with intimacy.',
    'My sexuality is creative and bonding.',
    'Openness creates new possibilities.',
  ],
  60: [
    'I accept limitations as creative fuel.',
    'Mutation requires acceptance of constraint.',
    'My limitations define my unique expression.',
  ],
  61: [
    'I embrace the mystery of knowing.',
    'Inner truth emerges in its own time.',
    'I am comfortable not knowing.',
  ],
  62: [
    'I express details with precision.',
    'My facts serve understanding.',
    'Small things matter in my communication.',
  ],
  63: [
    'I question to reach completion.',
    'My doubt serves the search for truth.',
    'After completion comes new questions.',
  ],
  64: [
    'I embrace mental confusion as part of process.',
    'Before completion lies divine chaos.',
    'My visions are seeds of new beginnings.',
  ],
};

/// Affirmations based on authority type
const Map<Authority, List<String>> authorityAffirmations = {
  Authority.emotional: [
    'I ride my emotional wave before making decisions.',
    'Clarity comes over time, not in the moment.',
    'I honor my emotional process without rushing.',
  ],
  Authority.sacral: [
    'I listen to my gut response.',
    'My body knows before my mind does.',
    'I trust my sacral sounds to guide me.',
  ],
  Authority.splenic: [
    'I trust my instant intuitive hits.',
    'My body\'s survival instincts guide me.',
    'In the moment knowing is my gift.',
  ],
  Authority.ego: [
    'I commit to what I truly want.',
    'My willpower guides my promises.',
    'I follow through on my heart\'s commitments.',
  ],
  Authority.self: [
    'I talk through decisions to hear my truth.',
    'My identity speaks through my voice.',
    'I discover my direction by expressing myself.',
  ],
  Authority.environment: [
    'I use my environment as my sounding board.',
    'The right place helps me decide.',
    'I trust the external reflections I receive.',
  ],
  Authority.lunar: [
    'I wait a full lunar cycle for major decisions.',
    'The Moon guides my timing.',
    'Patience is my greatest decision-making tool.',
  ],
};
