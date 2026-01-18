// Human Design system constants including gates, channels, centers, and types.
//
// Gate sequence follows the traditional Human Design wheel mapping
// starting at 0° Aries with Gate 41.

// ignore_for_file: constant_identifier_names

/// The 9 Centers in the Human Design bodygraph
enum HumanDesignCenter {
  head('Head', 'Inspiration & Mental Pressure'),
  ajna('Ajna', 'Conceptualization & Mental Awareness'),
  throat('Throat', 'Communication & Manifestation'),
  g('G/Self', 'Identity, Direction & Love'),
  heart('Heart/Ego', 'Willpower & Material World'),
  sacral('Sacral', 'Life Force & Sexuality'),
  solarPlexus('Solar Plexus', 'Emotional Awareness'),
  spleen('Spleen', 'Intuition & Survival Instinct'),
  root('Root', 'Adrenaline & Pressure');

  const HumanDesignCenter(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// The 5 Human Design Types
enum HumanDesignType {
  manifestor('Manifestor', 'To Inform', 'Anger', 'Peace'),
  generator('Generator', 'To Respond', 'Frustration', 'Satisfaction'),
  manifestingGenerator('Manifesting Generator', 'To Respond', 'Frustration', 'Satisfaction'),
  projector('Projector', 'To Wait for Invitation', 'Bitterness', 'Success'),
  reflector('Reflector', 'To Wait a Lunar Cycle', 'Disappointment', 'Surprise');

  const HumanDesignType(this.displayName, this.strategy, this.notSelfTheme, this.signature);
  final String displayName;
  final String strategy;
  final String notSelfTheme;
  final String signature;
}

/// The 7 Authority types
enum Authority {
  emotional('Emotional', 'Ride the emotional wave before deciding'),
  sacral('Sacral', 'Listen to gut responses in the moment'),
  splenic('Splenic', 'Trust spontaneous intuitive hits'),
  ego('Ego/Heart', 'Follow what you want and can commit to'),
  self('Self-Projected', 'Talk through decisions to hear your truth'),
  environment('Mental/Environmental', 'Use environment as sounding board'),
  lunar('Lunar', 'Wait 28 days for clarity');

  const Authority(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// The 12 Profiles (combinations of conscious and unconscious lines)
enum Profile {
  oneThree('1/3', 'Investigator/Martyr'),
  oneFour('1/4', 'Investigator/Opportunist'),
  twoFour('2/4', 'Hermit/Opportunist'),
  twoFive('2/5', 'Hermit/Heretic'),
  threeFive('3/5', 'Martyr/Heretic'),
  threeSix('3/6', 'Martyr/Role Model'),
  fourSix('4/6', 'Opportunist/Role Model'),
  fourOne('4/1', 'Opportunist/Investigator'),
  fiveOne('5/1', 'Heretic/Investigator'),
  fiveTwo('5/2', 'Heretic/Hermit'),
  sixTwo('6/2', 'Role Model/Hermit'),
  sixThree('6/3', 'Role Model/Martyr');

  const Profile(this.notation, this.name);
  final String notation;
  final String name;
}

/// Definition types (how centers are connected)
enum Definition {
  none('No Definition', 'Reflector - all centers open'),
  single('Single Definition', 'All defined centers connected'),
  split('Split Definition', 'Two separate areas of definition'),
  tripleSplit('Triple Split', 'Three separate areas of definition'),
  quadrupleSplit('Quadruple Split', 'Four separate areas of definition');

  const Definition(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Gate data with associated center, keynote, and description
class GateData {
  const GateData({
    required this.number,
    required this.name,
    required this.center,
    required this.keynote,
  });

  final int number;
  final String name;
  final HumanDesignCenter center;
  final String keynote;
}

/// Channel data connecting two gates
class ChannelData {
  const ChannelData({
    required this.gate1,
    required this.gate2,
    required this.name,
    required this.type,
  });

  final int gate1;
  final int gate2;
  final String name;
  final String type; // Format, Understanding, Awareness, etc.

  String get id => '${gate1 < gate2 ? gate1 : gate2}-${gate1 < gate2 ? gate2 : gate1}';
}

/// All 64 Gates with their associated centers and meanings
const Map<int, GateData> gates = {
  1: GateData(number: 1, name: 'The Creative', center: HumanDesignCenter.g, keynote: 'Self-Expression'),
  2: GateData(number: 2, name: 'The Receptive', center: HumanDesignCenter.g, keynote: 'Direction of Self'),
  3: GateData(number: 3, name: 'Ordering', center: HumanDesignCenter.sacral, keynote: 'Difficulty at the Beginning'),
  4: GateData(number: 4, name: 'Formulization', center: HumanDesignCenter.ajna, keynote: 'Mental Solutions'),
  5: GateData(number: 5, name: 'Fixed Patterns', center: HumanDesignCenter.sacral, keynote: 'Waiting'),
  6: GateData(number: 6, name: 'Friction', center: HumanDesignCenter.solarPlexus, keynote: 'Conflict Resolution'),
  7: GateData(number: 7, name: 'The Army', center: HumanDesignCenter.g, keynote: 'The Role of Self in Interaction'),
  8: GateData(number: 8, name: 'Contribution', center: HumanDesignCenter.throat, keynote: 'Making a Contribution'),
  9: GateData(number: 9, name: 'Focus', center: HumanDesignCenter.sacral, keynote: 'Determination'),
  10: GateData(number: 10, name: 'Behavior of Self', center: HumanDesignCenter.g, keynote: 'Self-Love'),
  11: GateData(number: 11, name: 'Ideas', center: HumanDesignCenter.ajna, keynote: 'Peace'),
  12: GateData(number: 12, name: 'Caution', center: HumanDesignCenter.throat, keynote: 'Standstill'),
  13: GateData(number: 13, name: 'The Listener', center: HumanDesignCenter.g, keynote: 'Fellowship'),
  14: GateData(number: 14, name: 'Power Skills', center: HumanDesignCenter.sacral, keynote: 'Possession in Great Measure'),
  15: GateData(number: 15, name: 'Extremes', center: HumanDesignCenter.g, keynote: 'Modesty'),
  16: GateData(number: 16, name: 'Skills', center: HumanDesignCenter.throat, keynote: 'Enthusiasm'),
  17: GateData(number: 17, name: 'Opinions', center: HumanDesignCenter.ajna, keynote: 'Following'),
  18: GateData(number: 18, name: 'Correction', center: HumanDesignCenter.spleen, keynote: 'Work on What Has Been Spoiled'),
  19: GateData(number: 19, name: 'Wanting', center: HumanDesignCenter.root, keynote: 'Approach'),
  20: GateData(number: 20, name: 'The Now', center: HumanDesignCenter.throat, keynote: 'Contemplation'),
  21: GateData(number: 21, name: 'The Hunter', center: HumanDesignCenter.heart, keynote: 'Biting Through'),
  22: GateData(number: 22, name: 'Openness', center: HumanDesignCenter.solarPlexus, keynote: 'Grace'),
  23: GateData(number: 23, name: 'Assimilation', center: HumanDesignCenter.throat, keynote: 'Splitting Apart'),
  24: GateData(number: 24, name: 'Rationalization', center: HumanDesignCenter.ajna, keynote: 'Return'),
  25: GateData(number: 25, name: 'The Spirit of Self', center: HumanDesignCenter.g, keynote: 'Innocence'),
  26: GateData(number: 26, name: 'The Taming Power', center: HumanDesignCenter.heart, keynote: 'The Great Taming Force'),
  27: GateData(number: 27, name: 'Caring', center: HumanDesignCenter.sacral, keynote: 'Nourishment'),
  28: GateData(number: 28, name: 'The Player', center: HumanDesignCenter.spleen, keynote: 'Preponderance of the Great'),
  29: GateData(number: 29, name: 'Perseverance', center: HumanDesignCenter.sacral, keynote: 'The Abysmal'),
  30: GateData(number: 30, name: 'Feelings', center: HumanDesignCenter.solarPlexus, keynote: 'The Clinging Fire'),
  31: GateData(number: 31, name: 'Leading', center: HumanDesignCenter.throat, keynote: 'Influence'),
  32: GateData(number: 32, name: 'Continuity', center: HumanDesignCenter.spleen, keynote: 'Duration'),
  33: GateData(number: 33, name: 'Privacy', center: HumanDesignCenter.throat, keynote: 'Retreat'),
  34: GateData(number: 34, name: 'Power', center: HumanDesignCenter.sacral, keynote: 'Great Power'),
  35: GateData(number: 35, name: 'Change', center: HumanDesignCenter.throat, keynote: 'Progress'),
  36: GateData(number: 36, name: 'Crisis', center: HumanDesignCenter.solarPlexus, keynote: 'Darkening of the Light'),
  37: GateData(number: 37, name: 'Friendship', center: HumanDesignCenter.solarPlexus, keynote: 'The Family'),
  38: GateData(number: 38, name: 'The Fighter', center: HumanDesignCenter.root, keynote: 'Opposition'),
  39: GateData(number: 39, name: 'Provocation', center: HumanDesignCenter.root, keynote: 'Obstruction'),
  40: GateData(number: 40, name: 'Aloneness', center: HumanDesignCenter.heart, keynote: 'Deliverance'),
  41: GateData(number: 41, name: 'Contraction', center: HumanDesignCenter.root, keynote: 'Decrease'),
  42: GateData(number: 42, name: 'Growth', center: HumanDesignCenter.sacral, keynote: 'Increase'),
  43: GateData(number: 43, name: 'Insight', center: HumanDesignCenter.ajna, keynote: 'Breakthrough'),
  44: GateData(number: 44, name: 'Alertness', center: HumanDesignCenter.spleen, keynote: 'Coming to Meet'),
  45: GateData(number: 45, name: 'The Gatherer', center: HumanDesignCenter.throat, keynote: 'Gathering Together'),
  46: GateData(number: 46, name: 'The Determination', center: HumanDesignCenter.g, keynote: 'Pushing Upward'),
  47: GateData(number: 47, name: 'Realization', center: HumanDesignCenter.ajna, keynote: 'Oppression'),
  48: GateData(number: 48, name: 'Depth', center: HumanDesignCenter.spleen, keynote: 'The Well'),
  49: GateData(number: 49, name: 'Revolution', center: HumanDesignCenter.solarPlexus, keynote: 'Revolution'),
  50: GateData(number: 50, name: 'Values', center: HumanDesignCenter.spleen, keynote: 'The Cauldron'),
  51: GateData(number: 51, name: 'Shock', center: HumanDesignCenter.heart, keynote: 'The Arousing'),
  52: GateData(number: 52, name: 'Stillness', center: HumanDesignCenter.root, keynote: 'Keeping Still'),
  53: GateData(number: 53, name: 'Starting', center: HumanDesignCenter.root, keynote: 'Development'),
  54: GateData(number: 54, name: 'Ambition', center: HumanDesignCenter.root, keynote: 'The Marrying Maiden'),
  55: GateData(number: 55, name: 'Spirit', center: HumanDesignCenter.solarPlexus, keynote: 'Abundance'),
  56: GateData(number: 56, name: 'Stimulation', center: HumanDesignCenter.throat, keynote: 'The Wanderer'),
  57: GateData(number: 57, name: 'Intuition', center: HumanDesignCenter.spleen, keynote: 'The Gentle'),
  58: GateData(number: 58, name: 'Vitality', center: HumanDesignCenter.root, keynote: 'The Joyous'),
  59: GateData(number: 59, name: 'Sexuality', center: HumanDesignCenter.sacral, keynote: 'Dispersion'),
  60: GateData(number: 60, name: 'Limitation', center: HumanDesignCenter.root, keynote: 'Limitation'),
  61: GateData(number: 61, name: 'Mystery', center: HumanDesignCenter.head, keynote: 'Inner Truth'),
  62: GateData(number: 62, name: 'Details', center: HumanDesignCenter.throat, keynote: 'Preponderance of the Small'),
  63: GateData(number: 63, name: 'Doubt', center: HumanDesignCenter.head, keynote: 'After Completion'),
  64: GateData(number: 64, name: 'Confusion', center: HumanDesignCenter.head, keynote: 'Before Completion'),
};

/// All 36 Channels connecting gates
const List<ChannelData> channels = [
  // Format Channels (Individual)
  ChannelData(gate1: 1, gate2: 8, name: 'Inspiration', type: 'Individual'),
  ChannelData(gate1: 2, gate2: 14, name: 'The Beat', type: 'Individual'),
  ChannelData(gate1: 3, gate2: 60, name: 'Mutation', type: 'Individual'),
  ChannelData(gate1: 12, gate2: 22, name: 'Openness', type: 'Individual'),
  ChannelData(gate1: 20, gate2: 34, name: 'Charisma', type: 'Individual'),
  ChannelData(gate1: 23, gate2: 43, name: 'Structuring', type: 'Individual'),
  ChannelData(gate1: 28, gate2: 38, name: 'Struggle', type: 'Individual'),
  ChannelData(gate1: 39, gate2: 55, name: 'Emoting', type: 'Individual'),
  ChannelData(gate1: 51, gate2: 25, name: 'Initiation', type: 'Individual'),
  ChannelData(gate1: 57, gate2: 20, name: 'The Brain Wave', type: 'Individual'),

  // Understanding Channels (Collective Sharing)
  ChannelData(gate1: 4, gate2: 63, name: 'Logic', type: 'Collective'),
  ChannelData(gate1: 5, gate2: 15, name: 'Rhythm', type: 'Collective'),
  ChannelData(gate1: 7, gate2: 31, name: 'The Alpha', type: 'Collective'),
  ChannelData(gate1: 9, gate2: 52, name: 'Concentration', type: 'Collective'),
  ChannelData(gate1: 11, gate2: 56, name: 'Curiosity', type: 'Collective'),
  ChannelData(gate1: 13, gate2: 33, name: 'The Prodigal', type: 'Collective'),
  ChannelData(gate1: 16, gate2: 48, name: 'The Wavelength', type: 'Collective'),
  ChannelData(gate1: 17, gate2: 62, name: 'Acceptance', type: 'Collective'),
  ChannelData(gate1: 18, gate2: 58, name: 'Judgment', type: 'Collective'),
  ChannelData(gate1: 29, gate2: 46, name: 'Discovery', type: 'Collective'),
  ChannelData(gate1: 30, gate2: 41, name: 'Recognition', type: 'Collective'),
  ChannelData(gate1: 35, gate2: 36, name: 'Transitoriness', type: 'Collective'),
  ChannelData(gate1: 47, gate2: 64, name: 'Abstraction', type: 'Collective'),

  // Awareness Channels (Tribal)
  ChannelData(gate1: 6, gate2: 59, name: 'Intimacy', type: 'Tribal'),
  ChannelData(gate1: 10, gate2: 20, name: 'Awakening', type: 'Tribal'),
  ChannelData(gate1: 19, gate2: 49, name: 'Synthesis', type: 'Tribal'),
  ChannelData(gate1: 21, gate2: 45, name: 'Money', type: 'Tribal'),
  ChannelData(gate1: 26, gate2: 44, name: 'Surrender', type: 'Tribal'),
  ChannelData(gate1: 27, gate2: 50, name: 'Preservation', type: 'Tribal'),
  ChannelData(gate1: 32, gate2: 54, name: 'Transformation', type: 'Tribal'),
  ChannelData(gate1: 37, gate2: 40, name: 'Community', type: 'Tribal'),

  // Integration Channels
  ChannelData(gate1: 10, gate2: 34, name: 'Exploration', type: 'Integration'),
  ChannelData(gate1: 10, gate2: 57, name: 'Perfected Form', type: 'Integration'),
  ChannelData(gate1: 20, gate2: 57, name: 'The Brain Wave', type: 'Integration'),
  ChannelData(gate1: 34, gate2: 57, name: 'Power', type: 'Integration'),
];

/// Centers connected by each channel
const Map<String, List<HumanDesignCenter>> channelCenters = {
  '1-8': [HumanDesignCenter.g, HumanDesignCenter.throat],
  '2-14': [HumanDesignCenter.g, HumanDesignCenter.sacral],
  '3-60': [HumanDesignCenter.sacral, HumanDesignCenter.root],
  '4-63': [HumanDesignCenter.ajna, HumanDesignCenter.head],
  '5-15': [HumanDesignCenter.sacral, HumanDesignCenter.g],
  '6-59': [HumanDesignCenter.solarPlexus, HumanDesignCenter.sacral],
  '7-31': [HumanDesignCenter.g, HumanDesignCenter.throat],
  '9-52': [HumanDesignCenter.sacral, HumanDesignCenter.root],
  '10-20': [HumanDesignCenter.g, HumanDesignCenter.throat],
  '10-34': [HumanDesignCenter.g, HumanDesignCenter.sacral],
  '10-57': [HumanDesignCenter.g, HumanDesignCenter.spleen],
  '11-56': [HumanDesignCenter.ajna, HumanDesignCenter.throat],
  '12-22': [HumanDesignCenter.throat, HumanDesignCenter.solarPlexus],
  '13-33': [HumanDesignCenter.g, HumanDesignCenter.throat],
  '14-2': [HumanDesignCenter.sacral, HumanDesignCenter.g],
  '16-48': [HumanDesignCenter.throat, HumanDesignCenter.spleen],
  '17-62': [HumanDesignCenter.ajna, HumanDesignCenter.throat],
  '18-58': [HumanDesignCenter.spleen, HumanDesignCenter.root],
  '19-49': [HumanDesignCenter.root, HumanDesignCenter.solarPlexus],
  '20-34': [HumanDesignCenter.throat, HumanDesignCenter.sacral],
  '20-57': [HumanDesignCenter.throat, HumanDesignCenter.spleen],
  '21-45': [HumanDesignCenter.heart, HumanDesignCenter.throat],
  '22-12': [HumanDesignCenter.solarPlexus, HumanDesignCenter.throat],
  '23-43': [HumanDesignCenter.throat, HumanDesignCenter.ajna],
  '24-61': [HumanDesignCenter.ajna, HumanDesignCenter.head],
  '25-51': [HumanDesignCenter.g, HumanDesignCenter.heart],
  '26-44': [HumanDesignCenter.heart, HumanDesignCenter.spleen],
  '27-50': [HumanDesignCenter.sacral, HumanDesignCenter.spleen],
  '28-38': [HumanDesignCenter.spleen, HumanDesignCenter.root],
  '29-46': [HumanDesignCenter.sacral, HumanDesignCenter.g],
  '30-41': [HumanDesignCenter.solarPlexus, HumanDesignCenter.root],
  '31-7': [HumanDesignCenter.throat, HumanDesignCenter.g],
  '32-54': [HumanDesignCenter.spleen, HumanDesignCenter.root],
  '33-13': [HumanDesignCenter.throat, HumanDesignCenter.g],
  '34-10': [HumanDesignCenter.sacral, HumanDesignCenter.g],
  '34-20': [HumanDesignCenter.sacral, HumanDesignCenter.throat],
  '34-57': [HumanDesignCenter.sacral, HumanDesignCenter.spleen],
  '35-36': [HumanDesignCenter.throat, HumanDesignCenter.solarPlexus],
  '36-35': [HumanDesignCenter.solarPlexus, HumanDesignCenter.throat],
  '37-40': [HumanDesignCenter.solarPlexus, HumanDesignCenter.heart],
  '38-28': [HumanDesignCenter.root, HumanDesignCenter.spleen],
  '39-55': [HumanDesignCenter.root, HumanDesignCenter.solarPlexus],
  '40-37': [HumanDesignCenter.heart, HumanDesignCenter.solarPlexus],
  '41-30': [HumanDesignCenter.root, HumanDesignCenter.solarPlexus],
  '43-23': [HumanDesignCenter.ajna, HumanDesignCenter.throat],
  '44-26': [HumanDesignCenter.spleen, HumanDesignCenter.heart],
  '45-21': [HumanDesignCenter.throat, HumanDesignCenter.heart],
  '46-29': [HumanDesignCenter.g, HumanDesignCenter.sacral],
  '47-64': [HumanDesignCenter.ajna, HumanDesignCenter.head],
  '48-16': [HumanDesignCenter.spleen, HumanDesignCenter.throat],
  '49-19': [HumanDesignCenter.solarPlexus, HumanDesignCenter.root],
  '50-27': [HumanDesignCenter.spleen, HumanDesignCenter.sacral],
  '51-25': [HumanDesignCenter.heart, HumanDesignCenter.g],
  '52-9': [HumanDesignCenter.root, HumanDesignCenter.sacral],
  '53-42': [HumanDesignCenter.root, HumanDesignCenter.sacral],
  '54-32': [HumanDesignCenter.root, HumanDesignCenter.spleen],
  '55-39': [HumanDesignCenter.solarPlexus, HumanDesignCenter.root],
  '56-11': [HumanDesignCenter.throat, HumanDesignCenter.ajna],
  '57-10': [HumanDesignCenter.spleen, HumanDesignCenter.g],
  '57-20': [HumanDesignCenter.spleen, HumanDesignCenter.throat],
  '57-34': [HumanDesignCenter.spleen, HumanDesignCenter.sacral],
  '58-18': [HumanDesignCenter.root, HumanDesignCenter.spleen],
  '59-6': [HumanDesignCenter.sacral, HumanDesignCenter.solarPlexus],
  '60-3': [HumanDesignCenter.root, HumanDesignCenter.sacral],
  '61-24': [HumanDesignCenter.head, HumanDesignCenter.ajna],
  '62-17': [HumanDesignCenter.throat, HumanDesignCenter.ajna],
  '63-4': [HumanDesignCenter.head, HumanDesignCenter.ajna],
  '64-47': [HumanDesignCenter.head, HumanDesignCenter.ajna],
};

/// Gate sequence for the Human Design wheel (starting from 0° Aries)
/// Each gate spans 5.625° (360° / 64 gates)
/// The sequence defines the position of each gate on the zodiac wheel
const List<int> gateWheelSequence = [
  41, // 0° - 5.625°
  19, // 5.625° - 11.25°
  13, // 11.25° - 16.875°
  49, // 16.875° - 22.5°
  30, // 22.5° - 28.125°
  55, // 28.125° - 33.75°
  37, // 33.75° - 39.375°
  63, // 39.375° - 45°
  22, // 45° - 50.625°
  36, // 50.625° - 56.25°
  25, // 56.25° - 61.875°
  17, // 61.875° - 67.5°
  21, // 67.5° - 73.125°
  51, // 73.125° - 78.75°
  42, // 78.75° - 84.375°
  3,  // 84.375° - 90°
  27, // 90° - 95.625°
  24, // 95.625° - 101.25°
  2,  // 101.25° - 106.875°
  23, // 106.875° - 112.5°
  8,  // 112.5° - 118.125°
  20, // 118.125° - 123.75°
  16, // 123.75° - 129.375°
  35, // 129.375° - 135°
  45, // 135° - 140.625°
  12, // 140.625° - 146.25°
  15, // 146.25° - 151.875°
  52, // 151.875° - 157.5°
  39, // 157.5° - 163.125°
  53, // 163.125° - 168.75°
  62, // 168.75° - 174.375°
  56, // 174.375° - 180°
  31, // 180° - 185.625°
  33, // 185.625° - 191.25°
  7,  // 191.25° - 196.875°
  4,  // 196.875° - 202.5°
  29, // 202.5° - 208.125°
  59, // 208.125° - 213.75°
  40, // 213.75° - 219.375°
  64, // 219.375° - 225°
  47, // 225° - 230.625°
  6,  // 230.625° - 236.25°
  46, // 236.25° - 241.875°
  18, // 241.875° - 247.5°
  48, // 247.5° - 253.125°
  57, // 253.125° - 258.75°
  32, // 258.75° - 264.375°
  50, // 264.375° - 270°
  28, // 270° - 275.625°
  44, // 275.625° - 281.25°
  1,  // 281.25° - 286.875°
  43, // 286.875° - 292.5°
  14, // 292.5° - 298.125°
  34, // 298.125° - 303.75°
  9,  // 303.75° - 309.375°
  5,  // 309.375° - 315°
  26, // 315° - 320.625°
  11, // 320.625° - 326.25°
  10, // 326.25° - 331.875°
  58, // 331.875° - 337.5°
  38, // 337.5° - 343.125°
  54, // 343.125° - 348.75°
  61, // 348.75° - 354.375°
  60, // 354.375° - 360°
];

/// Planets used in Human Design calculations
enum HumanDesignPlanet {
  sun('Sun', '☉'),
  earth('Earth', '⊕'),
  moon('Moon', '☽'),
  northNode('North Node', '☊'),
  southNode('South Node', '☋'),
  mercury('Mercury', '☿'),
  venus('Venus', '♀'),
  mars('Mars', '♂'),
  jupiter('Jupiter', '♃'),
  saturn('Saturn', '♄'),
  uranus('Uranus', '♅'),
  neptune('Neptune', '♆'),
  pluto('Pluto', '♇');

  const HumanDesignPlanet(this.displayName, this.symbol);
  final String displayName;
  final String symbol;
}

/// Mapping from sweph planet indices to Human Design planets
const Map<int, HumanDesignPlanet> swephPlanetMap = {
  0: HumanDesignPlanet.sun,
  1: HumanDesignPlanet.moon,
  2: HumanDesignPlanet.mercury,
  3: HumanDesignPlanet.venus,
  4: HumanDesignPlanet.mars,
  5: HumanDesignPlanet.jupiter,
  6: HumanDesignPlanet.saturn,
  7: HumanDesignPlanet.uranus,
  8: HumanDesignPlanet.neptune,
  9: HumanDesignPlanet.pluto,
  10: HumanDesignPlanet.northNode, // True Node
};

/// Gate degrees per each position
const double degreesPerGate = 5.625; // 360 / 64
const double degreesPerLine = 0.9375; // 5.625 / 6

/// Hexagram line meanings
const Map<int, String> lineThemes = {
  1: 'Investigator - Foundation, introspection',
  2: 'Hermit - Natural talent, projection',
  3: 'Martyr - Trial and error, adaptation',
  4: 'Opportunist - Network, friendship',
  5: 'Heretic - Universalization, projection',
  6: 'Role Model - Administration, transition',
};
