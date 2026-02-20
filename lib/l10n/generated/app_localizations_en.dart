// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Inside Me';

  @override
  String get common_save => 'Save';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_done => 'Done';

  @override
  String get common_next => 'Next';

  @override
  String get common_back => 'Back';

  @override
  String get common_skip => 'Skip';

  @override
  String get common_continue => 'Continue';

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_error => 'Error';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_close => 'Close';

  @override
  String get common_search => 'Search';

  @override
  String get common_share => 'Share';

  @override
  String get common_settings => 'Settings';

  @override
  String get common_logout => 'Log Out';

  @override
  String get common_profile => 'Profile';

  @override
  String get common_type => 'Type';

  @override
  String get common_strategy => 'Strategy';

  @override
  String get common_authority => 'Authority';

  @override
  String get common_definition => 'Definition';

  @override
  String get common_create => 'Create';

  @override
  String get common_viewFull => 'View Full';

  @override
  String get common_send => 'Send';

  @override
  String get common_like => 'Like';

  @override
  String get common_reply => 'Reply';

  @override
  String get common_deleteConfirmation =>
      'Are you sure you want to delete this? This action cannot be undone.';

  @override
  String get common_comingSoon => 'Coming soon!';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_chart => 'Chart';

  @override
  String get nav_today => 'Daily';

  @override
  String get nav_social => 'Social';

  @override
  String get nav_profile => 'Profile';

  @override
  String get nav_ai => 'AI';

  @override
  String get nav_more => 'More';

  @override
  String get nav_learn => 'Learn';

  @override
  String get affirmation_savedSuccess => 'Affirmation saved!';

  @override
  String get affirmation_alreadySaved => 'Affirmation already saved';

  @override
  String get home_goodMorning => 'Good morning';

  @override
  String get home_goodAfternoon => 'Good afternoon';

  @override
  String get home_goodEvening => 'Good evening';

  @override
  String get home_yourDesign => 'Your Design';

  @override
  String get home_completeProfile => 'Complete Your Profile';

  @override
  String get home_enterBirthData => 'Enter Birth Data';

  @override
  String get home_myChart => 'My Chart';

  @override
  String get home_savedCharts => 'Saved';

  @override
  String get home_composite => 'Composite';

  @override
  String get home_penta => 'Penta';

  @override
  String get home_friends => 'Friends';

  @override
  String get home_myBodygraph => 'My Bodygraph';

  @override
  String get home_definedCenters => 'Defined Centers';

  @override
  String get home_activeChannels => 'Active Channels';

  @override
  String get home_activeGates => 'Active Gates';

  @override
  String get transit_today => 'Today\'s Transits';

  @override
  String get transit_sun => 'Sun';

  @override
  String get transit_earth => 'Earth';

  @override
  String get transit_moon => 'Moon';

  @override
  String transit_gate(int number) {
    return 'Gate $number';
  }

  @override
  String transit_newChannelsActivated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new channels activated',
      one: '1 new channel activated',
    );
    return '$_temp0';
  }

  @override
  String transit_gatesHighlighted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gates highlighted',
      one: '1 gate highlighted',
    );
    return '$_temp0';
  }

  @override
  String get transit_noConnections => 'No direct transit connections today';

  @override
  String get auth_signIn => 'Sign In';

  @override
  String get auth_signUp => 'Sign Up';

  @override
  String get auth_signInWithApple => 'Sign in with Apple';

  @override
  String get auth_signInWithGoogle => 'Sign in with Google';

  @override
  String get auth_signInWithEmail => 'Sign in with Email';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Password';

  @override
  String get auth_confirmPassword => 'Confirm Password';

  @override
  String get auth_forgotPassword => 'Forgot Password?';

  @override
  String get auth_noAccount => 'Don\'t have an account?';

  @override
  String get auth_hasAccount => 'Already have an account?';

  @override
  String get auth_termsAgree =>
      'By signing up, you agree to our Terms of Service and Privacy Policy';

  @override
  String get auth_welcomeBack => 'Welcome back';

  @override
  String get auth_signInSubtitle =>
      'Sign in to continue your Human Design journey';

  @override
  String get auth_signInRequired => 'Sign In Required';

  @override
  String get auth_signInToCalculateChart =>
      'Please sign in to calculate and save your Human Design chart.';

  @override
  String get auth_signInToCreateStory =>
      'Please sign in to share stories with the community.';

  @override
  String get auth_signUpSubtitle => 'Start your Human Design journey today';

  @override
  String get auth_signUpWithApple => 'Sign up with Apple';

  @override
  String get auth_signUpWithGoogle => 'Sign up with Google';

  @override
  String get auth_enterName => 'Enter your name';

  @override
  String get auth_nameRequired => 'Name is required';

  @override
  String get auth_termsOfService => 'Terms of Service';

  @override
  String get auth_privacyPolicy => 'Privacy Policy';

  @override
  String get auth_acceptTerms =>
      'Please accept the Terms of Service to continue';

  @override
  String get auth_resetPasswordTitle => 'Reset Password';

  @override
  String get auth_resetPasswordPrompt =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get auth_enterEmail => 'Enter your email';

  @override
  String get auth_resetEmailSent => 'Password reset email sent!';

  @override
  String get auth_name => 'Name';

  @override
  String get auth_createAccount => 'Create Account';

  @override
  String get auth_iAgreeTo => 'I agree to the ';

  @override
  String get auth_and => ' and ';

  @override
  String get auth_birthInformation => 'Birth Information';

  @override
  String get auth_calculateMyChart => 'Calculate My Chart';

  @override
  String get onboarding_welcome => 'Inside Me: Human Design';

  @override
  String get onboarding_welcomeSubtitle =>
      'Discover your unique energetic blueprint';

  @override
  String get onboarding_birthData => 'Enter Your Birth Data';

  @override
  String get onboarding_birthDataSubtitle =>
      'We need this to calculate your chart';

  @override
  String get onboarding_birthDate => 'Birth Date';

  @override
  String get onboarding_birthTime => 'Birth Time';

  @override
  String get onboarding_birthLocation => 'Birth Location';

  @override
  String get onboarding_searchLocation => 'Search for a city...';

  @override
  String get onboarding_unknownTime => 'I don\'t know my birth time';

  @override
  String get onboarding_timeImportance =>
      'Knowing your exact birth time is important for an accurate chart';

  @override
  String get onboarding_birthDataExplanation =>
      'Your birth data is used to calculate your unique Human Design chart. The more accurate the information, the more precise your chart will be.';

  @override
  String get onboarding_noTimeWarning =>
      'Without an accurate birth time, some chart details (like your Rising sign and exact gate lines) may not be precise. We\'ll use noon as a default.';

  @override
  String get onboarding_enterBirthTimeInstead => 'Enter birth time instead';

  @override
  String get onboarding_birthDataPrivacy =>
      'Your birth data is encrypted and stored securely. You can update or delete it anytime from your profile settings.';

  @override
  String get onboarding_saveFailed => 'Failed to save birth data';

  @override
  String get onboarding_fillAllFields => 'Please fill in all required fields';

  @override
  String get onboarding_selectLanguage => 'Select Language';

  @override
  String get onboarding_getStarted => 'Get Started';

  @override
  String get onboarding_alreadyHaveAccount => 'I already have an account';

  @override
  String get onboarding_liveInAlignment =>
      'Discover your unique energetic blueprint and live in alignment with your true nature.';

  @override
  String get chart_myChart => 'My Chart';

  @override
  String get chart_viewChart => 'View Chart';

  @override
  String get chart_calculate => 'Calculate Chart';

  @override
  String get chart_recalculate => 'Recalculate';

  @override
  String get chart_share => 'Share Chart';

  @override
  String get chart_createChart => 'Create Chart';

  @override
  String get chart_composite => 'Composite Chart';

  @override
  String get chart_transit => 'Today\'s Transits';

  @override
  String get chart_bodygraph => 'Bodygraph';

  @override
  String get chart_planets => 'Planets';

  @override
  String get chart_details => 'Chart Details';

  @override
  String get chart_properties => 'Properties';

  @override
  String get chart_gates => 'Gates';

  @override
  String get chart_channels => 'Channels';

  @override
  String get chart_noChartYet => 'No Chart Yet';

  @override
  String get chart_addBirthDataPrompt =>
      'Add your birth data to generate your unique Human Design chart.';

  @override
  String get chart_addBirthData => 'Add Birth Data';

  @override
  String get chart_noActiveChannels => 'No Active Channels';

  @override
  String get chart_channelsFormedBothGates =>
      'Channels are formed when both gates are defined.';

  @override
  String get chart_savedCharts => 'Saved Charts';

  @override
  String get chart_addChart => 'Add Chart';

  @override
  String get chart_noSavedCharts => 'No Saved Charts';

  @override
  String get chart_noSavedChartsMessage =>
      'Create charts for yourself and others to save them here.';

  @override
  String get chart_loadFailed => 'Failed to load charts';

  @override
  String get chart_renameChart => 'Rename Chart';

  @override
  String get chart_rename => 'Rename';

  @override
  String get chart_renameFailed => 'Failed to rename chart';

  @override
  String get chart_deleteChart => 'Delete Chart';

  @override
  String chart_deleteConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get chart_deleteFailed => 'Failed to delete chart';

  @override
  String get chart_you => 'You';

  @override
  String get chart_personName => 'Name';

  @override
  String get chart_enterPersonName => 'Enter person\'s name';

  @override
  String get chart_addChartDescription =>
      'Create a chart for someone else by entering their birth information.';

  @override
  String get chart_calculateAndSave => 'Calculate & Save Chart';

  @override
  String get chart_saved => 'Chart saved successfully';

  @override
  String get chart_consciousGates => 'Conscious Gates';

  @override
  String get chart_unconsciousGates => 'Unconscious Gates';

  @override
  String get chart_personalitySide =>
      'Personality side - what you\'re aware of';

  @override
  String get chart_designSide => 'Design side - what others see in you';

  @override
  String get type_manifestor => 'Manifestor';

  @override
  String get type_generator => 'Generator';

  @override
  String get type_manifestingGenerator => 'Manifesting Generator';

  @override
  String get type_projector => 'Projector';

  @override
  String get type_reflector => 'Reflector';

  @override
  String get type_manifestor_strategy => 'To Inform';

  @override
  String get type_generator_strategy => 'To Respond';

  @override
  String get type_manifestingGenerator_strategy => 'To Respond';

  @override
  String get type_projector_strategy => 'To Wait for Invitation';

  @override
  String get type_reflector_strategy => 'To Wait a Lunar Cycle';

  @override
  String get authority_emotional => 'Emotional';

  @override
  String get authority_sacral => 'Sacral';

  @override
  String get authority_splenic => 'Splenic';

  @override
  String get authority_ego => 'Ego/Heart';

  @override
  String get authority_self => 'Self-Projected';

  @override
  String get authority_environment => 'Mental/Environmental';

  @override
  String get authority_lunar => 'Lunar';

  @override
  String get definition_none => 'No Definition';

  @override
  String get definition_single => 'Single Definition';

  @override
  String get definition_split => 'Split Definition';

  @override
  String get definition_tripleSplit => 'Triple Split';

  @override
  String get definition_quadrupleSplit => 'Quadruple Split';

  @override
  String get profile_1_3 => '1/3 Investigator/Martyr';

  @override
  String get profile_1_4 => '1/4 Investigator/Opportunist';

  @override
  String get profile_2_4 => '2/4 Hermit/Opportunist';

  @override
  String get profile_2_5 => '2/5 Hermit/Heretic';

  @override
  String get profile_3_5 => '3/5 Martyr/Heretic';

  @override
  String get profile_3_6 => '3/6 Martyr/Role Model';

  @override
  String get profile_4_6 => '4/6 Opportunist/Role Model';

  @override
  String get profile_4_1 => '4/1 Opportunist/Investigator';

  @override
  String get profile_5_1 => '5/1 Heretic/Investigator';

  @override
  String get profile_5_2 => '5/2 Heretic/Hermit';

  @override
  String get profile_6_2 => '6/2 Role Model/Hermit';

  @override
  String get profile_6_3 => '6/3 Role Model/Martyr';

  @override
  String get center_head => 'Head';

  @override
  String get center_ajna => 'Ajna';

  @override
  String get center_throat => 'Throat';

  @override
  String get center_g => 'G/Self';

  @override
  String get center_heart => 'Heart/Ego';

  @override
  String get center_sacral => 'Sacral';

  @override
  String get center_solarPlexus => 'Solar Plexus';

  @override
  String get center_spleen => 'Spleen';

  @override
  String get center_root => 'Root';

  @override
  String get center_defined => 'Defined';

  @override
  String get center_undefined => 'Undefined';

  @override
  String get section_type => 'Type';

  @override
  String get section_strategy => 'Strategy';

  @override
  String get section_authority => 'Authority';

  @override
  String get section_profile => 'Profile';

  @override
  String get section_definition => 'Definition';

  @override
  String get section_centers => 'Centers';

  @override
  String get section_channels => 'Channels';

  @override
  String get section_gates => 'Gates';

  @override
  String get section_conscious => 'Conscious (Personality)';

  @override
  String get section_unconscious => 'Unconscious (Design)';

  @override
  String get social_title => 'Social';

  @override
  String get social_thoughts => 'Thoughts';

  @override
  String get social_discover => 'Discover';

  @override
  String get social_groups => 'Groups';

  @override
  String get social_invite => 'Invite';

  @override
  String get social_createPost => 'Share a thought...';

  @override
  String get social_noThoughtsYet => 'No thoughts yet';

  @override
  String get social_noThoughtsMessage =>
      'Be the first to share your Human Design insights!';

  @override
  String get social_createGroup => 'Create Group';

  @override
  String get social_members => 'Members';

  @override
  String get social_comments => 'Comments';

  @override
  String get social_addComment => 'Add a comment...';

  @override
  String get social_noComments => 'No comments yet';

  @override
  String social_shareLimit(int remaining) {
    return 'You have $remaining shares remaining this month';
  }

  @override
  String get social_visibility => 'Visibility';

  @override
  String get social_private => 'Private';

  @override
  String get social_friendsOnly => 'Friends Only';

  @override
  String get social_public => 'Public';

  @override
  String get social_shared => 'Shared';

  @override
  String get social_noGroupsYet => 'No Groups Yet';

  @override
  String get social_noGroupsMessage =>
      'Create groups to analyze team dynamics with Penta analysis.';

  @override
  String get social_noSharedCharts => 'No Shared Charts';

  @override
  String get social_noSharedChartsMessage =>
      'Charts shared with you will appear here.';

  @override
  String get social_createGroupPrompt =>
      'Create a group to analyze team dynamics.';

  @override
  String get social_groupName => 'Group Name';

  @override
  String get social_groupNameHint => 'Family, Team, etc.';

  @override
  String get social_groupDescription => 'Description (optional)';

  @override
  String get social_groupDescriptionHint => 'What is this group for?';

  @override
  String social_groupCreated(String name) {
    return 'Group \"$name\" created!';
  }

  @override
  String get social_groupNameRequired => 'Please enter a group name';

  @override
  String get social_createGroupFailed =>
      'Failed to create group. Please try again.';

  @override
  String get social_noDescription => 'No description';

  @override
  String get social_admin => 'Admin';

  @override
  String social_sharedBy(String name) {
    return 'Shared by $name';
  }

  @override
  String get social_loadGroupsFailed => 'Failed to load groups';

  @override
  String get social_loadSharedFailed => 'Failed to load shared charts';

  @override
  String get social_userNotFound => 'User not found';

  @override
  String get discovery_userNotFound => 'User not found';

  @override
  String get discovery_following => 'Following';

  @override
  String get discovery_follow => 'Follow';

  @override
  String get discovery_sendMessage => 'Send Message';

  @override
  String get discovery_about => 'About';

  @override
  String get discovery_humanDesign => 'Human Design';

  @override
  String get discovery_type => 'Type';

  @override
  String get discovery_profile => 'Profile';

  @override
  String get discovery_authority => 'Authority';

  @override
  String get discovery_compatibility => 'Compatibility';

  @override
  String get discovery_compatible => 'compatible';

  @override
  String get discovery_followers => 'Followers';

  @override
  String get discovery_followingLabel => 'Following';

  @override
  String get discovery_noResults => 'No users found';

  @override
  String get discovery_noResultsMessage =>
      'Try adjusting your filters or check back later';

  @override
  String get userProfile_viewChart => 'Bodygraph';

  @override
  String get userProfile_chartPrivate => 'This chart is private';

  @override
  String get userProfile_chartFriendsOnly =>
      'Become mutual followers to view this chart';

  @override
  String get userProfile_chartFollowToView => 'Follow to view this chart';

  @override
  String get userProfile_publicProfile => 'Public Profile';

  @override
  String get userProfile_privateProfile => 'Private Profile';

  @override
  String get userProfile_friendsOnlyProfile => 'Friends Only';

  @override
  String get userProfile_followersList => 'Followers';

  @override
  String get userProfile_followingList => 'Following';

  @override
  String get userProfile_noFollowers => 'No followers yet';

  @override
  String get userProfile_noFollowing => 'Not following anyone yet';

  @override
  String get userProfile_thoughts => 'Thoughts';

  @override
  String get userProfile_noThoughts => 'No thoughts shared yet';

  @override
  String get userProfile_showAll => 'Show All';

  @override
  String get popularCharts_title => 'Popular Charts';

  @override
  String get popularCharts_subtitle => 'Most followed public charts';

  @override
  String time_minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String time_hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String time_daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get transit_title => 'Today\'s Transits';

  @override
  String get transit_currentEnergies => 'Current Energies';

  @override
  String get transit_sunGate => 'Sun Gate';

  @override
  String get transit_earthGate => 'Earth Gate';

  @override
  String get transit_moonGate => 'Moon Gate';

  @override
  String get transit_activeGates => 'Active Transit Gates';

  @override
  String get transit_activeChannels => 'Active Transit Channels';

  @override
  String get transit_personalImpact => 'Personal Impact';

  @override
  String transit_gateActivated(int gate) {
    return 'Gate $gate activated by transit';
  }

  @override
  String transit_channelFormed(String channel) {
    return 'Channel $channel formed with your chart';
  }

  @override
  String get transit_noPersonalImpact => 'No direct transit connections today';

  @override
  String get transit_viewFullTransit => 'View Full Transit Chart';

  @override
  String get affirmation_title => 'Daily Affirmation';

  @override
  String affirmation_forYourType(String type) {
    return 'For Your $type';
  }

  @override
  String affirmation_basedOnGate(int gate) {
    return 'Based on Gate $gate';
  }

  @override
  String get affirmation_refresh => 'New Affirmation';

  @override
  String get affirmation_save => 'Save Affirmation';

  @override
  String get affirmation_saved => 'Saved Affirmations';

  @override
  String get affirmation_share => 'Share Affirmation';

  @override
  String get affirmation_notifications => 'Daily Affirmation Notifications';

  @override
  String get affirmation_notificationTime => 'Notification Time';

  @override
  String get lifestyle_today => 'Today';

  @override
  String get lifestyle_insights => 'Insights';

  @override
  String get lifestyle_journal => 'Journal';

  @override
  String get lifestyle_addJournalEntry => 'Add Journal Entry';

  @override
  String get lifestyle_journalPrompt =>
      'How are you experiencing your design today?';

  @override
  String get lifestyle_noJournalEntries => 'No journal entries yet';

  @override
  String get lifestyle_mood => 'Mood';

  @override
  String get lifestyle_energy => 'Energy Level';

  @override
  String get lifestyle_reflection => 'Reflection';

  @override
  String get penta_title => 'Penta';

  @override
  String get penta_description => 'Group analysis for 3-5 people';

  @override
  String get penta_createNew => 'Create Penta';

  @override
  String get penta_selectMembers => 'Select Members';

  @override
  String get penta_minMembers => 'Minimum 3 members required';

  @override
  String get penta_maxMembers => 'Maximum 5 members';

  @override
  String get penta_groupDynamics => 'Group Dynamics';

  @override
  String get penta_missingRoles => 'Missing Roles';

  @override
  String get penta_strengths => 'Group Strengths';

  @override
  String get penta_analysis => 'Penta Analysis';

  @override
  String get penta_clearAnalysis => 'Clear Analysis';

  @override
  String get penta_infoText =>
      'Penta analysis reveals the natural roles that emerge in small groups of 3-5 people, showing how each member contributes to team dynamics.';

  @override
  String get penta_calculating => 'Calculating...';

  @override
  String get penta_calculate => 'Calculate Penta';

  @override
  String get penta_groupRoles => 'Group Roles';

  @override
  String get penta_electromagneticConnections => 'Electromagnetic Connections';

  @override
  String get penta_connectionsDescription =>
      'Special energy connections between members that create attraction and chemistry.';

  @override
  String get penta_areasForAttention => 'Areas for Attention';

  @override
  String get composite_title => 'Composite Chart';

  @override
  String get composite_infoText =>
      'A composite chart shows the relationship dynamics between two people, revealing how your charts interact and complement each other.';

  @override
  String get composite_selectTwoCharts => 'Select 2 Charts';

  @override
  String get composite_calculate => 'Analyze Connection';

  @override
  String get composite_calculating => 'Analyzing...';

  @override
  String get composite_clearAnalysis => 'Clear Analysis';

  @override
  String get composite_connectionTheme => 'Connection Theme';

  @override
  String get composite_definedCenters => 'Defined';

  @override
  String get composite_undefinedCenters => 'Open';

  @override
  String get composite_score => 'Score';

  @override
  String get composite_themeVeryBonded =>
      'Very bonded connection - you may feel deeply intertwined, which can be intense';

  @override
  String get composite_themeBonded =>
      'Bonded connection - strong sense of togetherness and shared energy';

  @override
  String get composite_themeBalanced =>
      'Balanced connection - healthy mix of togetherness and independence';

  @override
  String get composite_themeIndependent =>
      'Independent connection - more space for individual growth';

  @override
  String get composite_themeVeryIndependent =>
      'Very independent connection - intentional connection time helps strengthen bond';

  @override
  String get composite_electromagnetic => 'Electromagnetic Channels';

  @override
  String get composite_electromagneticDesc =>
      'Intense attraction - you complete each other';

  @override
  String get composite_companionship => 'Companionship Channels';

  @override
  String get composite_companionshipDesc =>
      'Comfort and stability - shared understanding';

  @override
  String get composite_dominance => 'Dominance Channels';

  @override
  String get composite_dominanceDesc => 'One teaches/conditions the other';

  @override
  String get composite_compromise => 'Compromise Channels';

  @override
  String get composite_compromiseDesc => 'Natural tension - requires awareness';

  @override
  String get composite_noConnections => 'No Channel Connections';

  @override
  String get composite_noConnectionsDesc =>
      'These charts don\'t form any direct channel connections, but there may still be interesting gate interactions.';

  @override
  String get composite_noChartsTitle => 'No Charts Available';

  @override
  String get composite_noChartsDesc =>
      'Create charts for yourself and others to compare your relationship dynamics.';

  @override
  String get composite_needMoreCharts => 'Need More Charts';

  @override
  String get composite_needMoreChartsDesc =>
      'You need at least 2 charts to analyze a relationship. Add another chart to continue.';

  @override
  String get composite_selectTwoHint =>
      'Select 2 charts to analyze their connection';

  @override
  String get composite_selectOneMore => 'Select 1 more chart';

  @override
  String get premium_upgrade => 'Upgrade to Premium';

  @override
  String get premium_subscribe => 'Subscribe';

  @override
  String get premium_restore => 'Restore Purchases';

  @override
  String get premium_features => 'Premium Features';

  @override
  String get premium_unlimitedShares => 'Unlimited Chart Sharing';

  @override
  String get premium_groupCharts => 'Group Charts';

  @override
  String get premium_advancedTransits => 'Advanced Transit Analysis';

  @override
  String get premium_personalizedAffirmations => 'Personalized Affirmations';

  @override
  String get premium_journalInsights => 'Journal Insights';

  @override
  String get premium_adFree => 'Ad-Free Experience';

  @override
  String get premium_monthly => 'Monthly';

  @override
  String get premium_yearly => 'Yearly';

  @override
  String get premium_perMonth => '/month';

  @override
  String get premium_perYear => '/year';

  @override
  String get premium_bestValue => 'Best Value';

  @override
  String get settings_appearance => 'Appearance';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_selectLanguage => 'Select Language';

  @override
  String get settings_changeLanguage => 'Change Language';

  @override
  String get settings_theme => 'Theme';

  @override
  String get settings_selectTheme => 'Select Theme';

  @override
  String get settings_chartDisplay => 'Chart Display';

  @override
  String get settings_showGateNumbers => 'Show Gate Numbers';

  @override
  String get settings_showGateNumbersSubtitle =>
      'Display gate numbers on the bodygraph';

  @override
  String get settings_use24HourTime => 'Use 24-Hour Time';

  @override
  String get settings_use24HourTimeSubtitle => 'Display time in 24-hour format';

  @override
  String get settings_feedback => 'Feedback';

  @override
  String get settings_hapticFeedback => 'Haptic Feedback';

  @override
  String get settings_hapticFeedbackSubtitle => 'Vibration on interactions';

  @override
  String get settings_account => 'Account';

  @override
  String get settings_changePassword => 'Change Password';

  @override
  String get settings_deleteAccount => 'Delete Account';

  @override
  String get settings_deleteAccountConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.';

  @override
  String get settings_appVersion => 'App Version';

  @override
  String get settings_rateApp => 'Rate the App';

  @override
  String get settings_sendFeedback => 'Send Feedback';

  @override
  String get settings_telegramSupport => 'Telegram Support';

  @override
  String get settings_telegramSupportSubtitle =>
      'Get help in our Telegram group';

  @override
  String get settings_themeLight => 'Light';

  @override
  String get settings_themeDark => 'Dark';

  @override
  String get settings_themeSystem => 'System';

  @override
  String get settings_notifications => 'Notifications';

  @override
  String get settings_privacy => 'Privacy';

  @override
  String get settings_chartVisibility => 'Chart Visibility';

  @override
  String get settings_chartVisibilitySubtitle =>
      'Control who can view your Human Design chart';

  @override
  String get settings_chartPrivate => 'Private';

  @override
  String get settings_chartPrivateDesc => 'Only you can see your chart';

  @override
  String get settings_chartFriends => 'Friends';

  @override
  String get settings_chartFriendsDesc =>
      'Mutual followers can view your chart';

  @override
  String get settings_chartPublic => 'Public';

  @override
  String get settings_chartPublicDesc => 'Your followers can view your chart';

  @override
  String get settings_about => 'About';

  @override
  String get settings_help => 'Help & Support';

  @override
  String get settings_terms => 'Terms of Service';

  @override
  String get settings_privacyPolicy => 'Privacy Policy';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_dailyTransits => 'Daily Transits';

  @override
  String get settings_dailyTransitsSubtitle => 'Receive daily transit updates';

  @override
  String get settings_gateChanges => 'Gate Changes';

  @override
  String get settings_gateChangesSubtitle => 'Notify when Sun changes gates';

  @override
  String get settings_socialActivity => 'Social Activity';

  @override
  String get settings_socialActivitySubtitle =>
      'Friend requests and shared charts';

  @override
  String get settings_achievements => 'Achievements';

  @override
  String get settings_achievementsSubtitle => 'Badge unlocks and milestones';

  @override
  String get settings_deleteAccountWarning =>
      'This will permanently delete all your data including charts, posts, and messages.';

  @override
  String get settings_deleteAccountFailed =>
      'Failed to delete account. Please try again.';

  @override
  String get settings_passwordChanged => 'Password changed successfully';

  @override
  String get settings_passwordChangeFailed =>
      'Failed to change password. Please try again.';

  @override
  String get settings_feedbackSubject => 'Inside Me App Feedback';

  @override
  String get settings_feedbackBody =>
      'Hi,\n\nI would like to share the following feedback about Inside Me:\n\n';

  @override
  String get auth_newPassword => 'New Password';

  @override
  String get auth_passwordRequired => 'Password is required';

  @override
  String get auth_passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get auth_passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get settings_exportData => 'Export My Data';

  @override
  String get settings_exportDataSubtitle =>
      'Download a copy of all your data (GDPR)';

  @override
  String get settings_exportingData => 'Preparing your data export...';

  @override
  String get settings_exportDataSubject => 'Inside Me - My Data Export';

  @override
  String get settings_exportDataFailed =>
      'Failed to export data. Please try again.';

  @override
  String get error_generic => 'Something went wrong';

  @override
  String get error_network => 'No internet connection';

  @override
  String get error_invalidEmail => 'Please enter a valid email';

  @override
  String get error_invalidPassword => 'Password must be at least 8 characters';

  @override
  String get error_passwordMismatch => 'Passwords do not match';

  @override
  String get error_birthDataRequired => 'Please enter your birth data';

  @override
  String get error_locationRequired => 'Please select your birth location';

  @override
  String get error_chartCalculation => 'Could not calculate your chart';

  @override
  String get profile_editProfile => 'Edit Profile';

  @override
  String get profile_shareChart => 'Share My Chart';

  @override
  String get profile_exportPdf => 'Export Chart PDF';

  @override
  String get profile_upgradePremium => 'Upgrade to Premium';

  @override
  String get profile_birthData => 'Birth Data';

  @override
  String get profile_chartSummary => 'Chart Summary';

  @override
  String get profile_viewFullChart => 'View Full Chart';

  @override
  String get profile_signOut => 'Sign Out';

  @override
  String get profile_signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get profile_addBirthDataPrompt =>
      'Add your birth data to generate your Human Design chart.';

  @override
  String get profile_addBirthDataToShare =>
      'Add birth data to share your chart';

  @override
  String get profile_addBirthDataToExport =>
      'Add birth data to export your chart';

  @override
  String get profile_exportFailed => 'Failed to export PDF';

  @override
  String get profile_signOutConfirmTitle => 'Sign Out';

  @override
  String get profile_loadFailed => 'Failed to load profile';

  @override
  String get profile_defaultUserName => 'Inside Me User';

  @override
  String get profile_birthDate => 'Date';

  @override
  String get profile_birthTime => 'Time';

  @override
  String get profile_birthLocation => 'Location';

  @override
  String get profile_birthTimezone => 'Timezone';

  @override
  String get chart_chakras => 'Chakras';

  @override
  String get chakra_title => 'Chakra Energy';

  @override
  String get chakra_activated => 'Activated';

  @override
  String get chakra_inactive => 'Inactive';

  @override
  String chakra_activatedCount(int count) {
    return '$count of 7 chakras activated';
  }

  @override
  String get chakra_hdMapping => 'HD Center Mapping';

  @override
  String get chakra_element => 'Element';

  @override
  String get chakra_location => 'Location';

  @override
  String get chakra_root => 'Root';

  @override
  String get chakra_root_sanskrit => 'Muladhara';

  @override
  String get chakra_root_description => 'Grounding, survival, and stability';

  @override
  String get chakra_sacral => 'Sacral';

  @override
  String get chakra_sacral_sanskrit => 'Svadhisthana';

  @override
  String get chakra_sacral_description => 'Creativity, sexuality, and emotions';

  @override
  String get chakra_solarPlexus => 'Solar Plexus';

  @override
  String get chakra_solarPlexus_sanskrit => 'Manipura';

  @override
  String get chakra_solarPlexus_description =>
      'Personal power, confidence, and will';

  @override
  String get chakra_heart => 'Heart';

  @override
  String get chakra_heart_sanskrit => 'Anahata';

  @override
  String get chakra_heart_description => 'Love, compassion, and connection';

  @override
  String get chakra_throat => 'Throat';

  @override
  String get chakra_throat_sanskrit => 'Vishuddha';

  @override
  String get chakra_throat_description =>
      'Communication, expression, and truth';

  @override
  String get chakra_thirdEye => 'Third Eye';

  @override
  String get chakra_thirdEye_sanskrit => 'Ajna';

  @override
  String get chakra_thirdEye_description =>
      'Intuition, insight, and imagination';

  @override
  String get chakra_crown => 'Crown';

  @override
  String get chakra_crown_sanskrit => 'Sahasrara';

  @override
  String get chakra_crown_description =>
      'Spiritual connection and consciousness';

  @override
  String get quiz_title => 'Quizzes';

  @override
  String get quiz_yourProgress => 'Your Progress';

  @override
  String quiz_quizzesCompleted(int count) {
    return '$count quizzes completed';
  }

  @override
  String get quiz_accuracy => 'Accuracy';

  @override
  String get quiz_streak => 'Streak';

  @override
  String get quiz_all => 'All';

  @override
  String get quiz_difficulty => 'Difficulty';

  @override
  String get quiz_beginner => 'Beginner';

  @override
  String get quiz_intermediate => 'Intermediate';

  @override
  String get quiz_advanced => 'Advanced';

  @override
  String quiz_questions(int count) {
    return '$count questions';
  }

  @override
  String quiz_points(int points) {
    return '+$points pts';
  }

  @override
  String get quiz_completed => 'Completed';

  @override
  String get quiz_noQuizzes => 'No quizzes available';

  @override
  String get quiz_checkBackLater => 'Check back later for new content';

  @override
  String get quiz_startQuiz => 'Start Quiz';

  @override
  String get quiz_tryAgain => 'Try Again';

  @override
  String get quiz_backToQuizzes => 'Back to Quizzes';

  @override
  String get quiz_shareResults => 'Share Results';

  @override
  String get quiz_yourBest => 'Your Best';

  @override
  String get quiz_perfectScore => 'Perfect Score!';

  @override
  String get quiz_newBest => 'New Best!';

  @override
  String get quiz_streakExtended => 'Streak Extended!';

  @override
  String quiz_questionOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String quiz_correct(int count) {
    return '$count correct';
  }

  @override
  String get quiz_submitAnswer => 'Submit Answer';

  @override
  String get quiz_nextQuestion => 'Next Question';

  @override
  String get quiz_seeResults => 'See Results';

  @override
  String get quiz_exitQuiz => 'Exit Quiz?';

  @override
  String get quiz_exitWarning => 'Your progress will be lost if you exit now.';

  @override
  String get quiz_exit => 'Exit';

  @override
  String get quiz_timesUp => 'Time\'s Up!';

  @override
  String get quiz_timesUpMessage =>
      'You\'ve run out of time. Your progress will be submitted.';

  @override
  String get quiz_excellent => 'Excellent!';

  @override
  String get quiz_goodJob => 'Good Job!';

  @override
  String get quiz_keepLearning => 'Keep Learning!';

  @override
  String get quiz_keepPracticing => 'Keep Practicing!';

  @override
  String get quiz_masteredTopic => 'You\'ve mastered this topic!';

  @override
  String get quiz_strongUnderstanding => 'You have a strong understanding.';

  @override
  String get quiz_onRightTrack => 'You\'re on the right track.';

  @override
  String get quiz_reviewExplanations => 'Review the explanations to improve.';

  @override
  String get quiz_studyMaterial => 'Study the material and try again.';

  @override
  String get quiz_attemptHistory => 'Attempt History';

  @override
  String get quiz_statistics => 'Quiz Statistics';

  @override
  String get quiz_totalQuizzes => 'Quizzes';

  @override
  String get quiz_totalQuestions => 'Questions';

  @override
  String get quiz_bestStreak => 'Best Streak';

  @override
  String quiz_strongest(String category) {
    return 'Strongest: $category';
  }

  @override
  String quiz_needsWork(String category) {
    return 'Needs work: $category';
  }

  @override
  String get quiz_category_types => 'Types';

  @override
  String get quiz_category_centers => 'Centers';

  @override
  String get quiz_category_authorities => 'Authorities';

  @override
  String get quiz_category_profiles => 'Profiles';

  @override
  String get quiz_category_gates => 'Gates';

  @override
  String get quiz_category_channels => 'Channels';

  @override
  String get quiz_category_definitions => 'Definitions';

  @override
  String get quiz_category_general => 'General';

  @override
  String get quiz_explanation => 'Explanation';

  @override
  String get quiz_quizzes => 'Quizzes';

  @override
  String get quiz_questionsLabel => 'Questions';

  @override
  String get quiz_shareProgress => 'Share Progress';

  @override
  String get quiz_shareProgressSubject => 'My Human Design Learning Progress';

  @override
  String get quiz_sharePerfect =>
      'I achieved a perfect score! I\'m mastering Human Design.';

  @override
  String get quiz_shareExcellent =>
      'I\'m doing great on my Human Design learning journey!';

  @override
  String get quiz_shareGoodJob =>
      'I\'m learning about Human Design. Every quiz helps me grow!';

  @override
  String quiz_shareSubject(String quizTitle, int score) {
    return 'I scored $score% on \"$quizTitle\" - Human Design Quiz';
  }

  @override
  String get quiz_failedToLoadStats => 'Failed to load stats';

  @override
  String get planetary_personality => 'Personality';

  @override
  String get planetary_design => 'Design';

  @override
  String get planetary_consciousBirth => 'Conscious · Birth';

  @override
  String get planetary_unconsciousPrenatal => 'Unconscious · 88° Prenatal';

  @override
  String get gamification_yourProgress => 'Your Progress';

  @override
  String get gamification_level => 'Level';

  @override
  String get gamification_points => 'pts';

  @override
  String get gamification_viewAll => 'View All';

  @override
  String get gamification_allChallengesComplete =>
      'All daily challenges complete!';

  @override
  String get gamification_dailyChallenge => 'Daily Challenge';

  @override
  String get gamification_achievements => 'Achievements';

  @override
  String get gamification_challenges => 'Challenges';

  @override
  String get gamification_leaderboard => 'Leaderboard';

  @override
  String get gamification_streak => 'Streak';

  @override
  String get gamification_badges => 'Badges';

  @override
  String get gamification_earnedBadge => 'You earned a badge!';

  @override
  String get gamification_claimReward => 'Claim Reward';

  @override
  String get gamification_completed => 'Completed';

  @override
  String get common_copy => 'Copy';

  @override
  String get share_myShares => 'My Shares';

  @override
  String get share_createNew => 'Create New';

  @override
  String get share_newLink => 'New Link';

  @override
  String get share_noShares => 'No Shared Links';

  @override
  String get share_noSharesMessage =>
      'Create share links to let others view your chart without needing an account.';

  @override
  String get share_createFirst => 'Create Your First Link';

  @override
  String share_activeLinks(int count) {
    return '$count Active Links';
  }

  @override
  String share_expiredLinks(int count) {
    return '$count Expired';
  }

  @override
  String get share_clearExpired => 'Clear';

  @override
  String get share_clearExpiredTitle => 'Clear Expired Links';

  @override
  String share_clearExpiredMessage(int count) {
    return 'This will remove $count expired links from your history.';
  }

  @override
  String get share_clearAll => 'Clear All';

  @override
  String get share_expiredCleared => 'Expired links cleared';

  @override
  String get share_linkCopied => 'Link copied to clipboard';

  @override
  String get share_revokeTitle => 'Revoke Link';

  @override
  String get share_revokeMessage =>
      'This will permanently disable this share link. Anyone with the link will no longer be able to view your chart.';

  @override
  String get share_revoke => 'Revoke';

  @override
  String get share_linkRevoked => 'Link revoked';

  @override
  String get share_totalLinks => 'Total';

  @override
  String get share_active => 'Active';

  @override
  String get share_totalViews => 'Views';

  @override
  String get share_chartLink => 'Chart Share';

  @override
  String get share_transitLink => 'Transit Share';

  @override
  String get share_compatibilityLink => 'Compatibility Report';

  @override
  String get share_link => 'Share Link';

  @override
  String share_views(int count) {
    return '$count views';
  }

  @override
  String get share_expired => 'Expired';

  @override
  String get share_activeLabel => 'Active';

  @override
  String share_expiredOn(String date) {
    return 'Expired $date';
  }

  @override
  String share_expiresIn(String time) {
    return 'Expires in $time';
  }

  @override
  String get auth_emailNotConfirmed => 'Please confirm your email';

  @override
  String get auth_resendConfirmation => 'Resend Confirmation Email';

  @override
  String get auth_confirmationSent => 'Confirmation email sent';

  @override
  String get auth_checkEmail => 'Check your email for the confirmation link';

  @override
  String get auth_checkYourEmail => 'Check Your Email';

  @override
  String get auth_confirmationLinkSent => 'We\'ve sent a confirmation link to:';

  @override
  String get auth_clickLinkToActivate =>
      'Please click the link in the email to activate your account.';

  @override
  String get auth_goToSignIn => 'Go to Sign In';

  @override
  String get auth_returnToHome => 'Return to Home';

  @override
  String get hashtags_explore => 'Explore Hashtags';

  @override
  String get hashtags_trending => 'Trending';

  @override
  String get hashtags_popular => 'Popular';

  @override
  String get hashtags_hdTopics => 'HD Topics';

  @override
  String get hashtags_noTrending => 'No trending hashtags yet';

  @override
  String get hashtags_noPopular => 'No popular hashtags yet';

  @override
  String get hashtags_noHdTopics => 'No HD topics yet';

  @override
  String get hashtag_noPosts => 'No posts yet';

  @override
  String get hashtag_beFirst => 'Be the first to post with this hashtag!';

  @override
  String hashtag_postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts',
      one: '1 post',
    );
    return '$_temp0';
  }

  @override
  String hashtag_recentPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts today',
      one: '1 post today',
    );
    return '$_temp0';
  }

  @override
  String get feed_forYou => 'For You';

  @override
  String get feed_trending => 'Trending';

  @override
  String get feed_hdTopics => 'HD Topics';

  @override
  String feed_gateTitle(int number) {
    return 'Gate $number';
  }

  @override
  String feed_gatePosts(int number) {
    return 'Posts about Gate $number';
  }

  @override
  String get transit_events_title => 'Transit Events';

  @override
  String get transit_events_happening => 'Happening Now';

  @override
  String get transit_events_upcoming => 'Upcoming';

  @override
  String get transit_events_past => 'Past Events';

  @override
  String get transit_events_noCurrentEvents => 'No events happening right now';

  @override
  String get transit_events_noUpcomingEvents => 'No upcoming events scheduled';

  @override
  String get transit_events_noPastEvents => 'No past events';

  @override
  String get transit_events_live => 'LIVE';

  @override
  String get transit_events_join => 'Join';

  @override
  String get transit_events_joined => 'Joined';

  @override
  String get transit_events_leave => 'Leave';

  @override
  String get transit_events_participating => 'participating';

  @override
  String get transit_events_posts => 'posts';

  @override
  String get transit_events_viewInsights => 'View Insights';

  @override
  String transit_events_endsIn(String time) {
    return 'Ends in $time';
  }

  @override
  String transit_events_startsIn(String time) {
    return 'Starts in $time';
  }

  @override
  String get transit_events_notFound => 'Event not found';

  @override
  String get transit_events_communityPosts => 'Community Posts';

  @override
  String get transit_events_noPosts => 'No posts yet for this event';

  @override
  String get transit_events_shareExperience => 'Share Experience';

  @override
  String get transit_events_participants => 'Participants';

  @override
  String get transit_events_duration => 'Duration';

  @override
  String get transit_events_eventEnded => 'This event has ended';

  @override
  String get transit_events_youreParticipating => 'You\'re participating!';

  @override
  String transit_events_experiencingWith(int count) {
    return 'Experiencing this transit with $count others';
  }

  @override
  String get transit_events_joinCommunity => 'Join the Community';

  @override
  String get transit_events_shareYourExperience =>
      'Share your experience and connect with others';

  @override
  String get activity_title => 'Friend Activity';

  @override
  String get activity_noActivities => 'No friend activity yet';

  @override
  String get activity_followFriends =>
      'Follow friends to see their achievements and milestones here!';

  @override
  String get activity_findFriends => 'Find Friends';

  @override
  String get activity_celebrate => 'Celebrate';

  @override
  String get activity_celebrated => 'Celebrated';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get groupChallenges_title => 'Group Challenges';

  @override
  String get groupChallenges_myTeams => 'My Teams';

  @override
  String get groupChallenges_challenges => 'Challenges';

  @override
  String get groupChallenges_leaderboard => 'Leaderboard';

  @override
  String get groupChallenges_createTeam => 'Create Team';

  @override
  String get groupChallenges_teamName => 'Team Name';

  @override
  String get groupChallenges_teamNameHint => 'Enter a team name';

  @override
  String get groupChallenges_teamDescription => 'Description';

  @override
  String get groupChallenges_teamDescriptionHint => 'What is your team about?';

  @override
  String get groupChallenges_teamCreated => 'Team created successfully!';

  @override
  String get groupChallenges_noTeams => 'No Teams Yet';

  @override
  String get groupChallenges_noTeamsDescription =>
      'Create or join a team to compete in group challenges!';

  @override
  String groupChallenges_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String groupChallenges_points(int points) {
    return '$points pts';
  }

  @override
  String get groupChallenges_noChallenges => 'No Active Challenges';

  @override
  String get groupChallenges_active => 'Active';

  @override
  String get groupChallenges_upcoming => 'Upcoming';

  @override
  String groupChallenges_reward(int points) {
    return '$points pts reward';
  }

  @override
  String groupChallenges_teamsEnrolled(String count) {
    return '$count teams';
  }

  @override
  String groupChallenges_participants(String count) {
    return '$count participants';
  }

  @override
  String groupChallenges_endsIn(String time) {
    return 'Ends in $time';
  }

  @override
  String get groupChallenges_weekly => 'Weekly';

  @override
  String get groupChallenges_monthly => 'Monthly';

  @override
  String get groupChallenges_allTime => 'All Time';

  @override
  String get groupChallenges_noTeamsOnLeaderboard =>
      'No teams on leaderboard yet';

  @override
  String get groupChallenges_pts => 'pts';

  @override
  String get groupChallenges_teamNotFound => 'Team not found';

  @override
  String get groupChallenges_members => 'Members';

  @override
  String get groupChallenges_totalPoints => 'Total Points';

  @override
  String get groupChallenges_joined => 'Joined';

  @override
  String get groupChallenges_join => 'Join';

  @override
  String get groupChallenges_status => 'Status';

  @override
  String get groupChallenges_about => 'About';

  @override
  String get groupChallenges_noMembers => 'No members yet';

  @override
  String get groupChallenges_admin => 'Admin';

  @override
  String groupChallenges_contributed(int points) {
    return '$points pts contributed';
  }

  @override
  String get groupChallenges_joinedTeam => 'Successfully joined the team!';

  @override
  String get groupChallenges_leaveTeam => 'Leave Team';

  @override
  String get groupChallenges_leaveConfirmation =>
      'Are you sure you want to leave this team? Your contributed points will remain with the team.';

  @override
  String get groupChallenges_leave => 'Leave';

  @override
  String get groupChallenges_leftTeam => 'You have left the team';

  @override
  String get groupChallenges_challengeDetails => 'Challenge Details';

  @override
  String get groupChallenges_challengeNotFound => 'Challenge not found';

  @override
  String get groupChallenges_target => 'Target';

  @override
  String get groupChallenges_starts => 'Starts';

  @override
  String get groupChallenges_ends => 'Ends';

  @override
  String get groupChallenges_hdTypes => 'HD Types';

  @override
  String get groupChallenges_noTeamsToEnroll => 'No Teams to Enroll';

  @override
  String get groupChallenges_createTeamToJoin =>
      'Create a team first to enroll in challenges';

  @override
  String get groupChallenges_enrollTeam => 'Enroll a Team';

  @override
  String get groupChallenges_enrolled => 'Enrolled';

  @override
  String get groupChallenges_enroll => 'Enroll';

  @override
  String get groupChallenges_teamEnrolled => 'Team enrolled successfully!';

  @override
  String get groupChallenges_noTeamsEnrolled => 'No teams enrolled yet';

  @override
  String get circles_title => 'Compatibility Circles';

  @override
  String get circles_myCircles => 'My Circles';

  @override
  String get circles_invitations => 'Invitations';

  @override
  String get circles_create => 'Create Circle';

  @override
  String get circles_selectIcon => 'Select an icon';

  @override
  String get circles_name => 'Circle Name';

  @override
  String get circles_nameHint => 'Family, Team, Friends...';

  @override
  String get circles_description => 'Description';

  @override
  String get circles_descriptionHint => 'What is this circle for?';

  @override
  String get circles_created => 'Circle created successfully!';

  @override
  String get circles_noCircles => 'No Circles Yet';

  @override
  String get circles_noCirclesDescription =>
      'Create a circle to analyze compatibility with friends, family, or team members.';

  @override
  String get circles_suggestions => 'Quick Start';

  @override
  String circles_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get circles_private => 'Private';

  @override
  String get circles_noInvitations => 'No Invitations';

  @override
  String get circles_noInvitationsDescription =>
      'Circle invitations you receive will appear here.';

  @override
  String circles_invitedBy(String name) {
    return 'Invited by $name';
  }

  @override
  String get circles_decline => 'Decline';

  @override
  String get circles_accept => 'Accept';

  @override
  String get circles_invitationDeclined => 'Invitation declined';

  @override
  String get circles_invitationAccepted => 'You\'ve joined the circle!';

  @override
  String get circles_notFound => 'Circle not found';

  @override
  String get circles_invite => 'Invite Member';

  @override
  String get circles_members => 'Members';

  @override
  String get circles_analysis => 'Analysis';

  @override
  String get circles_feed => 'Feed';

  @override
  String get circles_inviteMember => 'Invite Member';

  @override
  String get circles_sendInvite => 'Send Invite';

  @override
  String get circles_invitationSent => 'Invitation sent!';

  @override
  String get circles_invitationFailed => 'Failed to send invitation';

  @override
  String get circles_deleteTitle => 'Delete Circle';

  @override
  String circles_deleteConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get circles_deleted => 'Circle deleted';

  @override
  String get circles_noMembers => 'No members yet';

  @override
  String get circles_noAnalysis => 'No Analysis Yet';

  @override
  String get circles_runAnalysis =>
      'Run a compatibility analysis to see how your circle members interact.';

  @override
  String get circles_needMoreMembers =>
      'Add at least 2 members to run an analysis.';

  @override
  String get circles_analyzeCompatibility => 'Analyze Compatibility';

  @override
  String get circles_harmonyScore => 'Harmony Score';

  @override
  String get circles_typeDistribution => 'Type Distribution';

  @override
  String get circles_electromagneticConnections =>
      'Electromagnetic Connections';

  @override
  String get circles_electromagneticDesc =>
      'Intense attraction - you complete each other';

  @override
  String get circles_companionshipConnections => 'Companionship Connections';

  @override
  String get circles_companionshipDesc =>
      'Comfort and stability - shared understanding';

  @override
  String get circles_groupStrengths => 'Group Strengths';

  @override
  String get circles_areasForGrowth => 'Areas for Growth';

  @override
  String get circles_writePost => 'Share something with your circle...';

  @override
  String get circles_noPosts => 'No Posts Yet';

  @override
  String get circles_beFirstToPost =>
      'Be the first to share something with your circle!';

  @override
  String get experts_title => 'HD Experts';

  @override
  String get experts_becomeExpert => 'Become an Expert';

  @override
  String get experts_filterBySpecialization => 'Filter by Specialization';

  @override
  String get experts_allExperts => 'All Experts';

  @override
  String get experts_experts => 'Experts';

  @override
  String get experts_noExperts => 'No experts found';

  @override
  String get experts_featured => 'Featured Experts';

  @override
  String experts_followers(int count) {
    return '$count followers';
  }

  @override
  String get experts_notFound => 'Expert not found';

  @override
  String get experts_following => 'Following';

  @override
  String get experts_follow => 'Follow';

  @override
  String get experts_about => 'About';

  @override
  String get experts_specializations => 'Specializations';

  @override
  String get experts_credentials => 'Credentials';

  @override
  String get experts_reviews => 'Reviews';

  @override
  String get experts_writeReview => 'Write Review';

  @override
  String get experts_reviewContent => 'Your Review';

  @override
  String get experts_reviewHint =>
      'Share your experience working with this expert...';

  @override
  String get experts_submitReview => 'Submit Review';

  @override
  String get experts_reviewSubmitted => 'Review submitted successfully!';

  @override
  String get experts_noReviews => 'No reviews yet';

  @override
  String get experts_followersLabel => 'Followers';

  @override
  String get experts_rating => 'Rating';

  @override
  String get experts_years => 'Years';

  @override
  String get learningPaths_title => 'Learning Paths';

  @override
  String get learningPaths_explore => 'Explore';

  @override
  String get learningPaths_inProgress => 'In Progress';

  @override
  String get learningPaths_completed => 'Completed';

  @override
  String get learningPaths_featured => 'Featured Paths';

  @override
  String get learningPaths_allPaths => 'All Paths';

  @override
  String get learningPaths_noPathsExplore => 'No learning paths available';

  @override
  String get learningPaths_noPathsInProgress => 'No Paths In Progress';

  @override
  String get learningPaths_noPathsInProgressDescription =>
      'Enroll in a learning path to start your journey!';

  @override
  String get learningPaths_browsePaths => 'Browse Paths';

  @override
  String get learningPaths_noPathsCompleted => 'No Completed Paths';

  @override
  String get learningPaths_noPathsCompletedDescription =>
      'Complete learning paths to see them here!';

  @override
  String learningPaths_enrolled(int count) {
    return '$count enrolled';
  }

  @override
  String learningPaths_stepsCount(int count) {
    return '$count steps';
  }

  @override
  String learningPaths_progress(int completed, int total) {
    return '$completed of $total steps';
  }

  @override
  String get learningPaths_resume => 'Resume';

  @override
  String learningPaths_completedOn(String date) {
    return 'Completed on $date';
  }

  @override
  String get learningPathNotFound => 'Learning path not found';

  @override
  String learningPathMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String learningPathSteps(int count) {
    return '$count steps';
  }

  @override
  String learningPathBy(String author) {
    return 'By $author';
  }

  @override
  String learningPathEnrolled(int count) {
    return '$count enrolled';
  }

  @override
  String learningPathCompleted(int count) {
    return '$count completed';
  }

  @override
  String get learningPathEnroll => 'Start Learning';

  @override
  String get learningPathYourProgress => 'Your Progress';

  @override
  String get learningPathCompletedBadge => 'Completed';

  @override
  String learningPathProgressText(int completed, int total) {
    return '$completed of $total steps completed';
  }

  @override
  String get learningPathStepsTitle => 'Learning Steps';

  @override
  String get learningPathEnrollTitle => 'Start This Path?';

  @override
  String learningPathEnrollMessage(String title) {
    return 'You\'ll be enrolled in \"$title\" and can track your progress as you complete each step.';
  }

  @override
  String get learningPathViewContent => 'View Content';

  @override
  String get learningPathMarkComplete => 'Mark as Complete';

  @override
  String get learningPathStepCompleted => 'Step completed!';

  @override
  String get thought_title => 'Thoughts';

  @override
  String get thought_feedTitle => 'Thoughts';

  @override
  String get thought_createNew => 'Share a Thought';

  @override
  String get thought_emptyFeed => 'Your thoughts feed is empty';

  @override
  String get thought_emptyFeedMessage =>
      'Follow people or share a thought to get started';

  @override
  String get thought_regenerate => 'Regenerate';

  @override
  String thought_regeneratedFrom(String username) {
    return 'Regenerated from @$username';
  }

  @override
  String get thought_regenerateSuccess => 'Thought regenerated to your wall!';

  @override
  String get thought_regenerateConfirm => 'Regenerate this thought?';

  @override
  String get thought_regenerateDescription =>
      'This will share this thought to your wall, crediting the original author.';

  @override
  String get thought_addComment => 'Add a comment (optional)';

  @override
  String thought_regenerateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count regenerates',
      one: '1 regenerate',
    );
    return '$_temp0';
  }

  @override
  String get thought_cannotRegenerateOwn =>
      'You cannot regenerate your own thought';

  @override
  String get thought_alreadyRegenerated =>
      'You have already regenerated this thought';

  @override
  String get thought_postDetail => 'Thought';

  @override
  String get thought_noComments => 'No comments yet. Be the first to comment!';

  @override
  String thought_replyingTo(String username) {
    return 'Replying to $username';
  }

  @override
  String get thought_writeReply => 'Write a reply...';

  @override
  String get thought_commentPlaceholder => 'Add a comment...';

  @override
  String get messages_title => 'Messages';

  @override
  String get messages_conversation => 'Conversation';

  @override
  String get messages_loading => 'Loading...';

  @override
  String get messages_muteNotifications => 'Mute Notifications';

  @override
  String get messages_notificationsMuted => 'Notifications muted';

  @override
  String get messages_blockUser => 'Block User';

  @override
  String get messages_blockUserConfirm =>
      'Are you sure you want to block this user? You will no longer receive messages from them.';

  @override
  String get messages_userBlocked => 'User blocked';

  @override
  String get messages_block => 'Block';

  @override
  String get messages_deleteConversation => 'Delete Conversation';

  @override
  String get messages_deleteConversationConfirm =>
      'Are you sure you want to delete this conversation? This action cannot be undone.';

  @override
  String get messages_conversationDeleted => 'Conversation deleted';

  @override
  String get messages_startConversation => 'Start the conversation!';

  @override
  String get profile_takePhoto => 'Take Photo';

  @override
  String get profile_chooseFromGallery => 'Choose from Gallery';

  @override
  String get profile_avatarUpdated => 'Avatar updated successfully';

  @override
  String get profile_profileUpdated => 'Profile updated successfully';

  @override
  String get profile_noProfileFound => 'No profile found';

  @override
  String get discovery_title => 'Discover';

  @override
  String get discovery_searchUsers => 'Search users...';

  @override
  String get discovery_discoverTab => 'Discover';

  @override
  String get discovery_followingTab => 'Following';

  @override
  String get discovery_followersTab => 'Followers';

  @override
  String get discovery_noUsersFound => 'No users found';

  @override
  String get discovery_tryAdjustingFilters => 'Try adjusting your filters';

  @override
  String get discovery_notFollowingAnyone => 'Not following anyone';

  @override
  String get discovery_discoverPeople => 'Discover people to follow';

  @override
  String get discovery_noFollowersYet => 'No followers yet';

  @override
  String get discovery_shareInsights => 'Share your insights to gain followers';

  @override
  String get discovery_clearAll => 'Clear all';

  @override
  String chart_gate(int number) {
    return 'Gate $number';
  }

  @override
  String chart_channel(String id) {
    return 'Channel $id';
  }

  @override
  String get chart_center => 'Center';

  @override
  String get chart_keynote => 'Keynote';

  @override
  String get chart_element => 'Element';

  @override
  String get chart_location => 'Location';

  @override
  String get chart_hdCenters => 'HD Centers';

  @override
  String get reaction_comment => 'Comment';

  @override
  String get reaction_react => 'React';

  @override
  String get reaction_standard => 'Standard';

  @override
  String get reaction_humanDesign => 'Human Design';

  @override
  String get share_shareChart => 'Share Chart';

  @override
  String get share_createShareLink => 'Create Share Link';

  @override
  String get share_shareViaUrl => 'Share via URL';

  @override
  String get share_exportAsPng => 'Export as PNG';

  @override
  String get share_fullReport => 'Full report';

  @override
  String get share_linkExpiration => 'Link Expiration';

  @override
  String get share_neverExpires => 'Never expires';

  @override
  String get share_oneHour => '1 hour';

  @override
  String get share_twentyFourHours => '24 hours';

  @override
  String get share_sevenDays => '7 days';

  @override
  String get share_thirtyDays => '30 days';

  @override
  String get share_creating => 'Creating...';

  @override
  String get share_signInToShare => 'Sign in to share your chart';

  @override
  String get share_createShareableLinks =>
      'Create shareable links to your Human Design chart';

  @override
  String get share_linkImage => 'Image';

  @override
  String get share_pdf => 'PDF';

  @override
  String get post_share => 'Share';

  @override
  String get post_edit => 'Edit';

  @override
  String get post_report => 'Report';

  @override
  String get mentorship_title => 'Mentorship';

  @override
  String get mentorship_pendingRequests => 'Pending Requests';

  @override
  String get mentorship_availableMentors => 'Available Mentors';

  @override
  String get mentorship_noMentorsAvailable => 'No mentors available';

  @override
  String mentorship_requestMentorship(String name) {
    return 'Request Mentorship from $name';
  }

  @override
  String get mentorship_sendMessage =>
      'Send a message explaining what you would like to learn:';

  @override
  String get mentorship_learnPrompt => 'I would like to learn more about...';

  @override
  String get mentorship_requestSent => 'Request sent!';

  @override
  String get mentorship_sendRequest => 'Send Request';

  @override
  String get mentorship_becomeAMentor => 'Become a Mentor';

  @override
  String get mentorship_shareKnowledge => 'Share your Human Design knowledge';

  @override
  String get story_cancel => 'Cancel';

  @override
  String get story_createStory => 'Create Story';

  @override
  String get story_share => 'Share';

  @override
  String get story_typeYourStory => 'Type your story...';

  @override
  String get story_background => 'Background';

  @override
  String get story_attachTransitGate => 'Attach Transit Gate (optional)';

  @override
  String get story_none => 'None';

  @override
  String story_gateNumber(int number) {
    return 'Gate $number';
  }

  @override
  String get story_whoCanSee => 'Who can see this?';

  @override
  String get story_followers => 'Followers';

  @override
  String get story_everyone => 'Everyone';

  @override
  String get challenges_title => 'Challenges';

  @override
  String get challenges_daily => 'Daily';

  @override
  String get challenges_weekly => 'Weekly';

  @override
  String get challenges_monthly => 'Monthly';

  @override
  String get challenges_noDailyChallenges => 'No daily challenges available';

  @override
  String get challenges_noWeeklyChallenges => 'No weekly challenges available';

  @override
  String get challenges_noMonthlyChallenges =>
      'No monthly challenges available';

  @override
  String get challenges_errorLoading => 'Error loading challenges';

  @override
  String challenges_claimedPoints(int points) {
    return 'Claimed $points points!';
  }

  @override
  String get challenges_totalPoints => 'Total Points';

  @override
  String get challenges_level => 'Level';

  @override
  String get learning_all => 'All';

  @override
  String get learning_types => 'Types';

  @override
  String get learning_gates => 'Gates';

  @override
  String get learning_centers => 'Centers';

  @override
  String get learning_liveSessions => 'Live Sessions';

  @override
  String get quiz_noActiveSession => 'No active quiz session';

  @override
  String get quiz_noQuestionsAvailable => 'No questions available';

  @override
  String get quiz_ok => 'OK';

  @override
  String get liveSessions_title => 'Live Sessions';

  @override
  String get liveSessions_upcoming => 'Upcoming';

  @override
  String get liveSessions_mySessions => 'My Sessions';

  @override
  String get liveSessions_errorLoading => 'Error loading sessions';

  @override
  String get liveSessions_registeredSuccessfully => 'Registered successfully!';

  @override
  String get liveSessions_cancelRegistration => 'Cancel Registration';

  @override
  String get liveSessions_cancelRegistrationConfirm =>
      'Are you sure you want to cancel your registration?';

  @override
  String get liveSessions_no => 'No';

  @override
  String get liveSessions_yesCancel => 'Yes, Cancel';

  @override
  String get liveSessions_registrationCancelled => 'Registration cancelled';

  @override
  String get gateChannelPicker_gates => 'Gates (64)';

  @override
  String get gateChannelPicker_channels => 'Channels (36)';

  @override
  String get gateChannelPicker_search => 'Search gates or channels...';

  @override
  String get leaderboard_weekly => 'Weekly';

  @override
  String get leaderboard_monthly => 'Monthly';

  @override
  String get leaderboard_allTime => 'All Time';

  @override
  String get ai_chatTitle => 'AI Assistant';

  @override
  String get ai_askAi => 'Ask AI';

  @override
  String get ai_askAboutChart => 'Ask AI About Your Chart';

  @override
  String get ai_miniDescription =>
      'Get personalized insights about your Human Design';

  @override
  String get ai_startChatting => 'Start chatting';

  @override
  String get ai_welcomeTitle => 'Your HD Assistant';

  @override
  String get ai_welcomeSubtitle =>
      'Ask me anything about your Human Design chart. I can explain your type, strategy, authority, gates, channels, and more.';

  @override
  String get ai_inputPlaceholder => 'Ask about your chart...';

  @override
  String get ai_newConversation => 'New Conversation';

  @override
  String get ai_conversations => 'Conversations';

  @override
  String get ai_noConversations => 'No conversations yet';

  @override
  String get ai_noConversationsMessage =>
      'Start a conversation with the AI to get personalized chart insights.';

  @override
  String get ai_deleteConversation => 'Delete Conversation';

  @override
  String get ai_deleteConversationConfirm =>
      'Are you sure you want to delete this conversation?';

  @override
  String get ai_messagesExhausted => 'Free Messages Used Up';

  @override
  String get ai_upgradeForUnlimited =>
      'Upgrade to Premium for unlimited AI conversations about your Human Design chart.';

  @override
  String ai_usageCount(int used, int limit) {
    return '$used of $limit free messages used';
  }

  @override
  String get ai_errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get ai_errorNetwork =>
      'Could not reach the AI service. Check your connection.';

  @override
  String get events_title => 'Community Events';

  @override
  String get events_upcoming => 'Upcoming';

  @override
  String get events_past => 'Past';

  @override
  String get events_create => 'Create Event';

  @override
  String get events_noUpcoming => 'No upcoming events';

  @override
  String get events_noUpcomingMessage =>
      'Create an event to connect with the HD community!';

  @override
  String get events_online => 'Online';

  @override
  String get events_inPerson => 'In Person';

  @override
  String get events_hybrid => 'Hybrid';

  @override
  String events_participants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '1 participant',
    );
    return '$_temp0';
  }

  @override
  String get events_register => 'Register';

  @override
  String get events_registered => 'Registered';

  @override
  String get events_cancelRegistration => 'Cancel Registration';

  @override
  String get events_registrationFull => 'Event Full';

  @override
  String get events_eventTitle => 'Event Title';

  @override
  String get events_eventDescription => 'Description';

  @override
  String get events_eventType => 'Event Type';

  @override
  String get events_startDate => 'Start Date & Time';

  @override
  String get events_endDate => 'End Date & Time';

  @override
  String get events_location => 'Location';

  @override
  String get events_virtualLink => 'Virtual Meeting Link';

  @override
  String get events_maxParticipants => 'Max Participants';

  @override
  String get events_hdTypeFilter => 'HD Type Filter';

  @override
  String get events_allTypes => 'Open to All Types';

  @override
  String get events_created => 'Event created!';

  @override
  String get events_deleted => 'Event deleted';

  @override
  String get events_notFound => 'Event not found';

  @override
  String get chartOfDay_title => 'Chart of the Day';

  @override
  String get chartOfDay_featured => 'Featured Chart';

  @override
  String get chartOfDay_viewChart => 'View Chart';

  @override
  String get discussion_typeDiscussion => 'Type Discussion';

  @override
  String get discussion_channelDiscussion => 'Channel Discussion';

  @override
  String get ai_wantMoreInsights => 'Want more AI insights?';

  @override
  String ai_messagesPackTitle(int count) {
    return '$count Messages';
  }

  @override
  String get ai_orSubscribe => 'or subscribe for unlimited';

  @override
  String get ai_bestValue => 'Best value';

  @override
  String get ai_getMoreMessages => 'Get more messages';

  @override
  String ai_fromPrice(String price) {
    return 'From $price';
  }

  @override
  String ai_perMessage(String price) {
    return '$price/message';
  }

  @override
  String get ai_transitInsightTitle => 'Today\'s Transit Insight';

  @override
  String get ai_transitInsightDesc =>
      'Get a personalized AI interpretation of how today\'s transits affect your chart.';

  @override
  String get ai_chartReadingTitle => 'AI Chart Reading';

  @override
  String get ai_chartReadingDesc =>
      'Generate a comprehensive AI reading of your Human Design chart.';

  @override
  String get ai_chartReadingCost =>
      'This reading uses 3 AI messages from your quota.';

  @override
  String get ai_compatibilityTitle => 'AI Compatibility Reading';

  @override
  String get ai_compatibilityReading => 'AI Compatibility Analysis';

  @override
  String get ai_dreamJournalTitle => 'Dream Journal';

  @override
  String get ai_dreamEntryHint =>
      'Record your dreams to discover hidden insights from your design...';

  @override
  String get ai_interpretDream => 'Interpret Dream';

  @override
  String get ai_journalPromptsTitle => 'Journal Prompts';

  @override
  String get ai_journalPromptsDesc =>
      'Get personalized journaling prompts based on your chart and today\'s transits.';

  @override
  String get ai_generating => 'Generating...';

  @override
  String get ai_askFollowUp => 'Ask Follow-up';

  @override
  String get ai_regenerate => 'Regenerate';

  @override
  String get ai_exportPdf => 'Export PDF';

  @override
  String get ai_shareReading => 'Share Reading';
}
