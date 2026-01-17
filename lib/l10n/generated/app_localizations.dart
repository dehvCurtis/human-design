import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Human Design'**
  String get appName;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get common_done;

  /// No description provided for @common_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get common_next;

  /// No description provided for @common_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// No description provided for @common_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get common_skip;

  /// No description provided for @common_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get common_continue;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// No description provided for @common_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get common_search;

  /// No description provided for @common_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get common_share;

  /// No description provided for @common_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get common_settings;

  /// No description provided for @common_logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get common_logout;

  /// No description provided for @common_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get common_profile;

  /// No description provided for @auth_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get auth_signIn;

  /// No description provided for @auth_signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_signUp;

  /// No description provided for @auth_signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get auth_signInWithApple;

  /// No description provided for @auth_signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get auth_signInWithGoogle;

  /// No description provided for @auth_signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get auth_signInWithEmail;

  /// No description provided for @auth_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email;

  /// No description provided for @auth_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// No description provided for @auth_confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_confirmPassword;

  /// No description provided for @auth_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgotPassword;

  /// No description provided for @auth_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get auth_noAccount;

  /// No description provided for @auth_hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get auth_hasAccount;

  /// No description provided for @auth_termsAgree.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our Terms of Service and Privacy Policy'**
  String get auth_termsAgree;

  /// No description provided for @onboarding_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Human Design'**
  String get onboarding_welcome;

  /// No description provided for @onboarding_welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover your unique energetic blueprint'**
  String get onboarding_welcomeSubtitle;

  /// No description provided for @onboarding_birthData.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Birth Data'**
  String get onboarding_birthData;

  /// No description provided for @onboarding_birthDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need this to calculate your chart'**
  String get onboarding_birthDataSubtitle;

  /// No description provided for @onboarding_birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get onboarding_birthDate;

  /// No description provided for @onboarding_birthTime.
  ///
  /// In en, this message translates to:
  /// **'Birth Time'**
  String get onboarding_birthTime;

  /// No description provided for @onboarding_birthLocation.
  ///
  /// In en, this message translates to:
  /// **'Birth Location'**
  String get onboarding_birthLocation;

  /// No description provided for @onboarding_searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search for a city...'**
  String get onboarding_searchLocation;

  /// No description provided for @onboarding_unknownTime.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know my birth time'**
  String get onboarding_unknownTime;

  /// No description provided for @onboarding_timeImportance.
  ///
  /// In en, this message translates to:
  /// **'Knowing your exact birth time is important for an accurate chart'**
  String get onboarding_timeImportance;

  /// No description provided for @chart_myChart.
  ///
  /// In en, this message translates to:
  /// **'My Chart'**
  String get chart_myChart;

  /// No description provided for @chart_viewChart.
  ///
  /// In en, this message translates to:
  /// **'View Chart'**
  String get chart_viewChart;

  /// No description provided for @chart_calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate Chart'**
  String get chart_calculate;

  /// No description provided for @chart_recalculate.
  ///
  /// In en, this message translates to:
  /// **'Recalculate'**
  String get chart_recalculate;

  /// No description provided for @chart_share.
  ///
  /// In en, this message translates to:
  /// **'Share Chart'**
  String get chart_share;

  /// No description provided for @chart_composite.
  ///
  /// In en, this message translates to:
  /// **'Composite Chart'**
  String get chart_composite;

  /// No description provided for @chart_transit.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Transits'**
  String get chart_transit;

  /// No description provided for @chart_bodygraph.
  ///
  /// In en, this message translates to:
  /// **'Bodygraph'**
  String get chart_bodygraph;

  /// No description provided for @chart_details.
  ///
  /// In en, this message translates to:
  /// **'Chart Details'**
  String get chart_details;

  /// No description provided for @type_manifestor.
  ///
  /// In en, this message translates to:
  /// **'Manifestor'**
  String get type_manifestor;

  /// No description provided for @type_generator.
  ///
  /// In en, this message translates to:
  /// **'Generator'**
  String get type_generator;

  /// No description provided for @type_manifestingGenerator.
  ///
  /// In en, this message translates to:
  /// **'Manifesting Generator'**
  String get type_manifestingGenerator;

  /// No description provided for @type_projector.
  ///
  /// In en, this message translates to:
  /// **'Projector'**
  String get type_projector;

  /// No description provided for @type_reflector.
  ///
  /// In en, this message translates to:
  /// **'Reflector'**
  String get type_reflector;

  /// No description provided for @type_manifestor_strategy.
  ///
  /// In en, this message translates to:
  /// **'To Inform'**
  String get type_manifestor_strategy;

  /// No description provided for @type_generator_strategy.
  ///
  /// In en, this message translates to:
  /// **'To Respond'**
  String get type_generator_strategy;

  /// No description provided for @type_manifestingGenerator_strategy.
  ///
  /// In en, this message translates to:
  /// **'To Respond'**
  String get type_manifestingGenerator_strategy;

  /// No description provided for @type_projector_strategy.
  ///
  /// In en, this message translates to:
  /// **'To Wait for Invitation'**
  String get type_projector_strategy;

  /// No description provided for @type_reflector_strategy.
  ///
  /// In en, this message translates to:
  /// **'To Wait a Lunar Cycle'**
  String get type_reflector_strategy;

  /// No description provided for @authority_emotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get authority_emotional;

  /// No description provided for @authority_sacral.
  ///
  /// In en, this message translates to:
  /// **'Sacral'**
  String get authority_sacral;

  /// No description provided for @authority_splenic.
  ///
  /// In en, this message translates to:
  /// **'Splenic'**
  String get authority_splenic;

  /// No description provided for @authority_ego.
  ///
  /// In en, this message translates to:
  /// **'Ego/Heart'**
  String get authority_ego;

  /// No description provided for @authority_self.
  ///
  /// In en, this message translates to:
  /// **'Self-Projected'**
  String get authority_self;

  /// No description provided for @authority_environment.
  ///
  /// In en, this message translates to:
  /// **'Mental/Environmental'**
  String get authority_environment;

  /// No description provided for @authority_lunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar'**
  String get authority_lunar;

  /// No description provided for @definition_none.
  ///
  /// In en, this message translates to:
  /// **'No Definition'**
  String get definition_none;

  /// No description provided for @definition_single.
  ///
  /// In en, this message translates to:
  /// **'Single Definition'**
  String get definition_single;

  /// No description provided for @definition_split.
  ///
  /// In en, this message translates to:
  /// **'Split Definition'**
  String get definition_split;

  /// No description provided for @definition_tripleSplit.
  ///
  /// In en, this message translates to:
  /// **'Triple Split'**
  String get definition_tripleSplit;

  /// No description provided for @definition_quadrupleSplit.
  ///
  /// In en, this message translates to:
  /// **'Quadruple Split'**
  String get definition_quadrupleSplit;

  /// No description provided for @profile_1_3.
  ///
  /// In en, this message translates to:
  /// **'1/3 Investigator/Martyr'**
  String get profile_1_3;

  /// No description provided for @profile_1_4.
  ///
  /// In en, this message translates to:
  /// **'1/4 Investigator/Opportunist'**
  String get profile_1_4;

  /// No description provided for @profile_2_4.
  ///
  /// In en, this message translates to:
  /// **'2/4 Hermit/Opportunist'**
  String get profile_2_4;

  /// No description provided for @profile_2_5.
  ///
  /// In en, this message translates to:
  /// **'2/5 Hermit/Heretic'**
  String get profile_2_5;

  /// No description provided for @profile_3_5.
  ///
  /// In en, this message translates to:
  /// **'3/5 Martyr/Heretic'**
  String get profile_3_5;

  /// No description provided for @profile_3_6.
  ///
  /// In en, this message translates to:
  /// **'3/6 Martyr/Role Model'**
  String get profile_3_6;

  /// No description provided for @profile_4_6.
  ///
  /// In en, this message translates to:
  /// **'4/6 Opportunist/Role Model'**
  String get profile_4_6;

  /// No description provided for @profile_4_1.
  ///
  /// In en, this message translates to:
  /// **'4/1 Opportunist/Investigator'**
  String get profile_4_1;

  /// No description provided for @profile_5_1.
  ///
  /// In en, this message translates to:
  /// **'5/1 Heretic/Investigator'**
  String get profile_5_1;

  /// No description provided for @profile_5_2.
  ///
  /// In en, this message translates to:
  /// **'5/2 Heretic/Hermit'**
  String get profile_5_2;

  /// No description provided for @profile_6_2.
  ///
  /// In en, this message translates to:
  /// **'6/2 Role Model/Hermit'**
  String get profile_6_2;

  /// No description provided for @profile_6_3.
  ///
  /// In en, this message translates to:
  /// **'6/3 Role Model/Martyr'**
  String get profile_6_3;

  /// No description provided for @center_head.
  ///
  /// In en, this message translates to:
  /// **'Head'**
  String get center_head;

  /// No description provided for @center_ajna.
  ///
  /// In en, this message translates to:
  /// **'Ajna'**
  String get center_ajna;

  /// No description provided for @center_throat.
  ///
  /// In en, this message translates to:
  /// **'Throat'**
  String get center_throat;

  /// No description provided for @center_g.
  ///
  /// In en, this message translates to:
  /// **'G/Self'**
  String get center_g;

  /// No description provided for @center_heart.
  ///
  /// In en, this message translates to:
  /// **'Heart/Ego'**
  String get center_heart;

  /// No description provided for @center_sacral.
  ///
  /// In en, this message translates to:
  /// **'Sacral'**
  String get center_sacral;

  /// No description provided for @center_solarPlexus.
  ///
  /// In en, this message translates to:
  /// **'Solar Plexus'**
  String get center_solarPlexus;

  /// No description provided for @center_spleen.
  ///
  /// In en, this message translates to:
  /// **'Spleen'**
  String get center_spleen;

  /// No description provided for @center_root.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get center_root;

  /// No description provided for @center_defined.
  ///
  /// In en, this message translates to:
  /// **'Defined'**
  String get center_defined;

  /// No description provided for @center_undefined.
  ///
  /// In en, this message translates to:
  /// **'Undefined'**
  String get center_undefined;

  /// No description provided for @section_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get section_type;

  /// No description provided for @section_strategy.
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get section_strategy;

  /// No description provided for @section_authority.
  ///
  /// In en, this message translates to:
  /// **'Authority'**
  String get section_authority;

  /// No description provided for @section_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get section_profile;

  /// No description provided for @section_definition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get section_definition;

  /// No description provided for @section_centers.
  ///
  /// In en, this message translates to:
  /// **'Centers'**
  String get section_centers;

  /// No description provided for @section_channels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get section_channels;

  /// No description provided for @section_gates.
  ///
  /// In en, this message translates to:
  /// **'Gates'**
  String get section_gates;

  /// No description provided for @section_conscious.
  ///
  /// In en, this message translates to:
  /// **'Conscious (Personality)'**
  String get section_conscious;

  /// No description provided for @section_unconscious.
  ///
  /// In en, this message translates to:
  /// **'Unconscious (Design)'**
  String get section_unconscious;

  /// No description provided for @social_friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get social_friends;

  /// No description provided for @social_groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get social_groups;

  /// No description provided for @social_addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get social_addFriend;

  /// No description provided for @social_createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get social_createGroup;

  /// No description provided for @social_invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get social_invite;

  /// No description provided for @social_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get social_members;

  /// No description provided for @social_comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get social_comments;

  /// No description provided for @social_addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get social_addComment;

  /// No description provided for @social_noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get social_noComments;

  /// No description provided for @social_shareLimit.
  ///
  /// In en, this message translates to:
  /// **'You have {remaining} shares remaining this month'**
  String social_shareLimit(int remaining);

  /// No description provided for @social_visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get social_visibility;

  /// No description provided for @social_private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get social_private;

  /// No description provided for @social_friendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Friends Only'**
  String get social_friendsOnly;

  /// No description provided for @social_public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get social_public;

  /// No description provided for @transit_title.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Transits'**
  String get transit_title;

  /// No description provided for @transit_currentEnergies.
  ///
  /// In en, this message translates to:
  /// **'Current Energies'**
  String get transit_currentEnergies;

  /// No description provided for @transit_sunGate.
  ///
  /// In en, this message translates to:
  /// **'Sun Gate'**
  String get transit_sunGate;

  /// No description provided for @transit_earthGate.
  ///
  /// In en, this message translates to:
  /// **'Earth Gate'**
  String get transit_earthGate;

  /// No description provided for @transit_moonGate.
  ///
  /// In en, this message translates to:
  /// **'Moon Gate'**
  String get transit_moonGate;

  /// No description provided for @transit_activeGates.
  ///
  /// In en, this message translates to:
  /// **'Active Transit Gates'**
  String get transit_activeGates;

  /// No description provided for @transit_activeChannels.
  ///
  /// In en, this message translates to:
  /// **'Active Transit Channels'**
  String get transit_activeChannels;

  /// No description provided for @transit_personalImpact.
  ///
  /// In en, this message translates to:
  /// **'Personal Impact'**
  String get transit_personalImpact;

  /// No description provided for @transit_gateActivated.
  ///
  /// In en, this message translates to:
  /// **'Gate {gate} activated by transit'**
  String transit_gateActivated(int gate);

  /// No description provided for @transit_channelFormed.
  ///
  /// In en, this message translates to:
  /// **'Channel {channel} formed with your chart'**
  String transit_channelFormed(String channel);

  /// No description provided for @transit_noPersonalImpact.
  ///
  /// In en, this message translates to:
  /// **'No direct transit connections today'**
  String get transit_noPersonalImpact;

  /// No description provided for @transit_viewFullTransit.
  ///
  /// In en, this message translates to:
  /// **'View Full Transit Chart'**
  String get transit_viewFullTransit;

  /// No description provided for @affirmation_title.
  ///
  /// In en, this message translates to:
  /// **'Daily Affirmation'**
  String get affirmation_title;

  /// No description provided for @affirmation_forYourType.
  ///
  /// In en, this message translates to:
  /// **'For Your {type}'**
  String affirmation_forYourType(String type);

  /// No description provided for @affirmation_basedOnGate.
  ///
  /// In en, this message translates to:
  /// **'Based on Gate {gate}'**
  String affirmation_basedOnGate(int gate);

  /// No description provided for @affirmation_refresh.
  ///
  /// In en, this message translates to:
  /// **'New Affirmation'**
  String get affirmation_refresh;

  /// No description provided for @affirmation_save.
  ///
  /// In en, this message translates to:
  /// **'Save Affirmation'**
  String get affirmation_save;

  /// No description provided for @affirmation_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved Affirmations'**
  String get affirmation_saved;

  /// No description provided for @affirmation_share.
  ///
  /// In en, this message translates to:
  /// **'Share Affirmation'**
  String get affirmation_share;

  /// No description provided for @affirmation_notifications.
  ///
  /// In en, this message translates to:
  /// **'Daily Affirmation Notifications'**
  String get affirmation_notifications;

  /// No description provided for @affirmation_notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get affirmation_notificationTime;

  /// No description provided for @lifestyle_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get lifestyle_today;

  /// No description provided for @lifestyle_insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get lifestyle_insights;

  /// No description provided for @lifestyle_journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get lifestyle_journal;

  /// No description provided for @lifestyle_addJournalEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Journal Entry'**
  String get lifestyle_addJournalEntry;

  /// No description provided for @lifestyle_journalPrompt.
  ///
  /// In en, this message translates to:
  /// **'How are you experiencing your design today?'**
  String get lifestyle_journalPrompt;

  /// No description provided for @lifestyle_noJournalEntries.
  ///
  /// In en, this message translates to:
  /// **'No journal entries yet'**
  String get lifestyle_noJournalEntries;

  /// No description provided for @lifestyle_mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get lifestyle_mood;

  /// No description provided for @lifestyle_energy.
  ///
  /// In en, this message translates to:
  /// **'Energy Level'**
  String get lifestyle_energy;

  /// No description provided for @lifestyle_reflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get lifestyle_reflection;

  /// No description provided for @penta_title.
  ///
  /// In en, this message translates to:
  /// **'Penta'**
  String get penta_title;

  /// No description provided for @penta_description.
  ///
  /// In en, this message translates to:
  /// **'Group analysis for 3-5 people'**
  String get penta_description;

  /// No description provided for @penta_createNew.
  ///
  /// In en, this message translates to:
  /// **'Create Penta'**
  String get penta_createNew;

  /// No description provided for @penta_selectMembers.
  ///
  /// In en, this message translates to:
  /// **'Select Members'**
  String get penta_selectMembers;

  /// No description provided for @penta_minMembers.
  ///
  /// In en, this message translates to:
  /// **'Minimum 3 members required'**
  String get penta_minMembers;

  /// No description provided for @penta_maxMembers.
  ///
  /// In en, this message translates to:
  /// **'Maximum 5 members'**
  String get penta_maxMembers;

  /// No description provided for @penta_groupDynamics.
  ///
  /// In en, this message translates to:
  /// **'Group Dynamics'**
  String get penta_groupDynamics;

  /// No description provided for @penta_missingRoles.
  ///
  /// In en, this message translates to:
  /// **'Missing Roles'**
  String get penta_missingRoles;

  /// No description provided for @penta_strengths.
  ///
  /// In en, this message translates to:
  /// **'Group Strengths'**
  String get penta_strengths;

  /// No description provided for @premium_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get premium_upgrade;

  /// No description provided for @premium_subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get premium_subscribe;

  /// No description provided for @premium_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get premium_restore;

  /// No description provided for @premium_features.
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get premium_features;

  /// No description provided for @premium_unlimitedShares.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Chart Sharing'**
  String get premium_unlimitedShares;

  /// No description provided for @premium_groupCharts.
  ///
  /// In en, this message translates to:
  /// **'Group Charts'**
  String get premium_groupCharts;

  /// No description provided for @premium_advancedTransits.
  ///
  /// In en, this message translates to:
  /// **'Advanced Transit Analysis'**
  String get premium_advancedTransits;

  /// No description provided for @premium_personalizedAffirmations.
  ///
  /// In en, this message translates to:
  /// **'Personalized Affirmations'**
  String get premium_personalizedAffirmations;

  /// No description provided for @premium_journalInsights.
  ///
  /// In en, this message translates to:
  /// **'Journal Insights'**
  String get premium_journalInsights;

  /// No description provided for @premium_adFree.
  ///
  /// In en, this message translates to:
  /// **'Ad-Free Experience'**
  String get premium_adFree;

  /// No description provided for @premium_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get premium_monthly;

  /// No description provided for @premium_yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get premium_yearly;

  /// No description provided for @premium_perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get premium_perMonth;

  /// No description provided for @premium_perYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get premium_perYear;

  /// No description provided for @premium_bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get premium_bestValue;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme;

  /// No description provided for @settings_themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_themeLight;

  /// No description provided for @settings_themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_themeDark;

  /// No description provided for @settings_themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_themeSystem;

  /// No description provided for @settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_notifications;

  /// No description provided for @settings_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settings_privacy;

  /// No description provided for @settings_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// No description provided for @settings_help.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get settings_help;

  /// No description provided for @settings_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settings_terms;

  /// No description provided for @settings_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacyPolicy;

  /// No description provided for @settings_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settings_version;

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error_generic;

  /// No description provided for @error_network.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_network;

  /// No description provided for @error_invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get error_invalidEmail;

  /// No description provided for @error_invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get error_invalidPassword;

  /// No description provided for @error_passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get error_passwordMismatch;

  /// No description provided for @error_birthDataRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your birth data'**
  String get error_birthDataRequired;

  /// No description provided for @error_locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your birth location'**
  String get error_locationRequired;

  /// No description provided for @error_chartCalculation.
  ///
  /// In en, this message translates to:
  /// **'Could not calculate your chart'**
  String get error_chartCalculation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
