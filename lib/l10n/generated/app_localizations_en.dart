// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Human Design';

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
  String get nav_home => 'Home';

  @override
  String get nav_chart => 'Chart';

  @override
  String get nav_today => 'Today';

  @override
  String get nav_social => 'Social';

  @override
  String get nav_profile => 'Profile';

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
  String get onboarding_welcome => 'Welcome to Human Design';

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
  String get social_friends => 'Friends';

  @override
  String get social_groups => 'Groups';

  @override
  String get social_addFriend => 'Add Friend';

  @override
  String get social_sendRequest => 'Send Request';

  @override
  String get social_createGroup => 'Create Group';

  @override
  String get social_invite => 'Invite';

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
  String get social_noFriendsYet => 'No Friends Yet';

  @override
  String get social_noFriendsMessage =>
      'Add friends to compare charts and see how you connect.';

  @override
  String get social_noGroupsYet => 'No Groups Yet';

  @override
  String get social_noGroupsMessage =>
      'Create groups to analyze team dynamics with Penta analysis.';

  @override
  String get social_noSharedCharts => 'No Shared Charts';

  @override
  String get social_noSharedChartsMessage =>
      'Charts that friends share with you will appear here.';

  @override
  String get social_pendingRequests => 'Pending Requests';

  @override
  String get social_friendRequests => 'Friend Requests';

  @override
  String get social_noPendingRequests => 'No pending requests';

  @override
  String get social_addFriendPrompt =>
      'Enter your friend\'s email address to send a request.';

  @override
  String get social_emailLabel => 'Email';

  @override
  String get social_emailHint => 'friend@example.com';

  @override
  String get social_userNotFound => 'No user found with that email';

  @override
  String social_requestSent(String name) {
    return 'Friend request sent to $name!';
  }

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
  String social_friendsSince(String date) {
    return 'Friends since $date';
  }

  @override
  String get social_compareCharts => 'Compare Charts';

  @override
  String get social_noDescription => 'No description';

  @override
  String get social_admin => 'Admin';

  @override
  String social_sharedBy(String name) {
    return 'Shared by $name';
  }

  @override
  String get social_loadFriendsFailed => 'Failed to load friends';

  @override
  String get social_loadGroupsFailed => 'Failed to load groups';

  @override
  String get social_loadSharedFailed => 'Failed to load shared charts';

  @override
  String social_sentAgo(String time) {
    return 'Sent $time';
  }

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
  String get profile_defaultUserName => 'Human Design User';

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
  String get planetary_personality => 'Personality';

  @override
  String get planetary_design => 'Design';

  @override
  String get planetary_consciousBirth => 'Conscious · Birth';

  @override
  String get planetary_unconsciousPrenatal => 'Unconscious · 88° Prenatal';
}
