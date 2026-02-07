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

  /// No description provided for @common_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get common_type;

  /// No description provided for @common_strategy.
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get common_strategy;

  /// No description provided for @common_authority.
  ///
  /// In en, this message translates to:
  /// **'Authority'**
  String get common_authority;

  /// No description provided for @common_definition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get common_definition;

  /// No description provided for @common_create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get common_create;

  /// No description provided for @common_viewFull.
  ///
  /// In en, this message translates to:
  /// **'View Full'**
  String get common_viewFull;

  /// No description provided for @common_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get common_send;

  /// No description provided for @common_like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get common_like;

  /// No description provided for @common_reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get common_reply;

  /// No description provided for @common_deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this? This action cannot be undone.'**
  String get common_deleteConfirmation;

  /// No description provided for @common_comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get common_comingSoon;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_chart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get nav_chart;

  /// No description provided for @nav_today.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get nav_today;

  /// No description provided for @nav_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get nav_social;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @nav_more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get nav_more;

  /// No description provided for @nav_learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get nav_learn;

  /// No description provided for @affirmation_savedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Affirmation saved!'**
  String get affirmation_savedSuccess;

  /// No description provided for @affirmation_alreadySaved.
  ///
  /// In en, this message translates to:
  /// **'Affirmation already saved'**
  String get affirmation_alreadySaved;

  /// No description provided for @home_goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get home_goodMorning;

  /// No description provided for @home_goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get home_goodAfternoon;

  /// No description provided for @home_goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get home_goodEvening;

  /// No description provided for @home_yourDesign.
  ///
  /// In en, this message translates to:
  /// **'Your Design'**
  String get home_yourDesign;

  /// No description provided for @home_completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get home_completeProfile;

  /// No description provided for @home_enterBirthData.
  ///
  /// In en, this message translates to:
  /// **'Enter Birth Data'**
  String get home_enterBirthData;

  /// No description provided for @home_myChart.
  ///
  /// In en, this message translates to:
  /// **'My Chart'**
  String get home_myChart;

  /// No description provided for @home_savedCharts.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get home_savedCharts;

  /// No description provided for @home_composite.
  ///
  /// In en, this message translates to:
  /// **'Composite'**
  String get home_composite;

  /// No description provided for @home_penta.
  ///
  /// In en, this message translates to:
  /// **'Penta'**
  String get home_penta;

  /// No description provided for @home_friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get home_friends;

  /// No description provided for @home_myBodygraph.
  ///
  /// In en, this message translates to:
  /// **'My Bodygraph'**
  String get home_myBodygraph;

  /// No description provided for @home_definedCenters.
  ///
  /// In en, this message translates to:
  /// **'Defined Centers'**
  String get home_definedCenters;

  /// No description provided for @home_activeChannels.
  ///
  /// In en, this message translates to:
  /// **'Active Channels'**
  String get home_activeChannels;

  /// No description provided for @home_activeGates.
  ///
  /// In en, this message translates to:
  /// **'Active Gates'**
  String get home_activeGates;

  /// No description provided for @transit_today.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Transits'**
  String get transit_today;

  /// No description provided for @transit_sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get transit_sun;

  /// No description provided for @transit_earth.
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get transit_earth;

  /// No description provided for @transit_moon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get transit_moon;

  /// No description provided for @transit_gate.
  ///
  /// In en, this message translates to:
  /// **'Gate {number}'**
  String transit_gate(int number);

  /// No description provided for @transit_newChannelsActivated.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new channel activated} other{{count} new channels activated}}'**
  String transit_newChannelsActivated(int count);

  /// No description provided for @transit_gatesHighlighted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 gate highlighted} other{{count} gates highlighted}}'**
  String transit_gatesHighlighted(int count);

  /// No description provided for @transit_noConnections.
  ///
  /// In en, this message translates to:
  /// **'No direct transit connections today'**
  String get transit_noConnections;

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

  /// No description provided for @auth_welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get auth_welcomeBack;

  /// No description provided for @auth_signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your Human Design journey'**
  String get auth_signInSubtitle;

  /// No description provided for @auth_signInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign In Required'**
  String get auth_signInRequired;

  /// No description provided for @auth_signInToCalculateChart.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to calculate and save your Human Design chart.'**
  String get auth_signInToCalculateChart;

  /// No description provided for @auth_signInToCreateStory.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to share stories with the community.'**
  String get auth_signInToCreateStory;

  /// No description provided for @auth_signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your Human Design journey today'**
  String get auth_signUpSubtitle;

  /// No description provided for @auth_signUpWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Apple'**
  String get auth_signUpWithApple;

  /// No description provided for @auth_signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get auth_signUpWithGoogle;

  /// No description provided for @auth_enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get auth_enterName;

  /// No description provided for @auth_nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get auth_nameRequired;

  /// No description provided for @auth_termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get auth_termsOfService;

  /// No description provided for @auth_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get auth_privacyPolicy;

  /// No description provided for @auth_acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms of Service to continue'**
  String get auth_acceptTerms;

  /// No description provided for @auth_resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_resetPasswordTitle;

  /// No description provided for @auth_resetPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get auth_resetPasswordPrompt;

  /// No description provided for @auth_enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get auth_enterEmail;

  /// No description provided for @auth_resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent!'**
  String get auth_resetEmailSent;

  /// No description provided for @auth_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get auth_name;

  /// No description provided for @auth_createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_createAccount;

  /// No description provided for @auth_iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get auth_iAgreeTo;

  /// No description provided for @auth_and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get auth_and;

  /// No description provided for @auth_birthInformation.
  ///
  /// In en, this message translates to:
  /// **'Birth Information'**
  String get auth_birthInformation;

  /// No description provided for @auth_calculateMyChart.
  ///
  /// In en, this message translates to:
  /// **'Calculate My Chart'**
  String get auth_calculateMyChart;

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

  /// No description provided for @onboarding_birthDataExplanation.
  ///
  /// In en, this message translates to:
  /// **'Your birth data is used to calculate your unique Human Design chart. The more accurate the information, the more precise your chart will be.'**
  String get onboarding_birthDataExplanation;

  /// No description provided for @onboarding_noTimeWarning.
  ///
  /// In en, this message translates to:
  /// **'Without an accurate birth time, some chart details (like your Rising sign and exact gate lines) may not be precise. We\'ll use noon as a default.'**
  String get onboarding_noTimeWarning;

  /// No description provided for @onboarding_enterBirthTimeInstead.
  ///
  /// In en, this message translates to:
  /// **'Enter birth time instead'**
  String get onboarding_enterBirthTimeInstead;

  /// No description provided for @onboarding_birthDataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your birth data is encrypted and stored securely. You can update or delete it anytime from your profile settings.'**
  String get onboarding_birthDataPrivacy;

  /// No description provided for @onboarding_saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save birth data'**
  String get onboarding_saveFailed;

  /// No description provided for @onboarding_fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get onboarding_fillAllFields;

  /// No description provided for @onboarding_selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get onboarding_selectLanguage;

  /// No description provided for @onboarding_getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_getStarted;

  /// No description provided for @onboarding_alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get onboarding_alreadyHaveAccount;

  /// No description provided for @onboarding_liveInAlignment.
  ///
  /// In en, this message translates to:
  /// **'Discover your unique energetic blueprint and live in alignment with your true nature.'**
  String get onboarding_liveInAlignment;

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

  /// No description provided for @chart_createChart.
  ///
  /// In en, this message translates to:
  /// **'Create Chart'**
  String get chart_createChart;

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

  /// No description provided for @chart_planets.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get chart_planets;

  /// No description provided for @chart_details.
  ///
  /// In en, this message translates to:
  /// **'Chart Details'**
  String get chart_details;

  /// No description provided for @chart_properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get chart_properties;

  /// No description provided for @chart_gates.
  ///
  /// In en, this message translates to:
  /// **'Gates'**
  String get chart_gates;

  /// No description provided for @chart_channels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get chart_channels;

  /// No description provided for @chart_noChartYet.
  ///
  /// In en, this message translates to:
  /// **'No Chart Yet'**
  String get chart_noChartYet;

  /// No description provided for @chart_addBirthDataPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your birth data to generate your unique Human Design chart.'**
  String get chart_addBirthDataPrompt;

  /// No description provided for @chart_addBirthData.
  ///
  /// In en, this message translates to:
  /// **'Add Birth Data'**
  String get chart_addBirthData;

  /// No description provided for @chart_noActiveChannels.
  ///
  /// In en, this message translates to:
  /// **'No Active Channels'**
  String get chart_noActiveChannels;

  /// No description provided for @chart_channelsFormedBothGates.
  ///
  /// In en, this message translates to:
  /// **'Channels are formed when both gates are defined.'**
  String get chart_channelsFormedBothGates;

  /// No description provided for @chart_savedCharts.
  ///
  /// In en, this message translates to:
  /// **'Saved Charts'**
  String get chart_savedCharts;

  /// No description provided for @chart_addChart.
  ///
  /// In en, this message translates to:
  /// **'Add Chart'**
  String get chart_addChart;

  /// No description provided for @chart_noSavedCharts.
  ///
  /// In en, this message translates to:
  /// **'No Saved Charts'**
  String get chart_noSavedCharts;

  /// No description provided for @chart_noSavedChartsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create charts for yourself and others to save them here.'**
  String get chart_noSavedChartsMessage;

  /// No description provided for @chart_loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load charts'**
  String get chart_loadFailed;

  /// No description provided for @chart_renameChart.
  ///
  /// In en, this message translates to:
  /// **'Rename Chart'**
  String get chart_renameChart;

  /// No description provided for @chart_rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get chart_rename;

  /// No description provided for @chart_renameFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to rename chart'**
  String get chart_renameFailed;

  /// No description provided for @chart_deleteChart.
  ///
  /// In en, this message translates to:
  /// **'Delete Chart'**
  String get chart_deleteChart;

  /// No description provided for @chart_deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String chart_deleteConfirm(String name);

  /// No description provided for @chart_deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete chart'**
  String get chart_deleteFailed;

  /// No description provided for @chart_you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get chart_you;

  /// No description provided for @chart_personName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get chart_personName;

  /// No description provided for @chart_enterPersonName.
  ///
  /// In en, this message translates to:
  /// **'Enter person\'s name'**
  String get chart_enterPersonName;

  /// No description provided for @chart_addChartDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a chart for someone else by entering their birth information.'**
  String get chart_addChartDescription;

  /// No description provided for @chart_calculateAndSave.
  ///
  /// In en, this message translates to:
  /// **'Calculate & Save Chart'**
  String get chart_calculateAndSave;

  /// No description provided for @chart_saved.
  ///
  /// In en, this message translates to:
  /// **'Chart saved successfully'**
  String get chart_saved;

  /// No description provided for @chart_consciousGates.
  ///
  /// In en, this message translates to:
  /// **'Conscious Gates'**
  String get chart_consciousGates;

  /// No description provided for @chart_unconsciousGates.
  ///
  /// In en, this message translates to:
  /// **'Unconscious Gates'**
  String get chart_unconsciousGates;

  /// No description provided for @chart_personalitySide.
  ///
  /// In en, this message translates to:
  /// **'Personality side - what you\'re aware of'**
  String get chart_personalitySide;

  /// No description provided for @chart_designSide.
  ///
  /// In en, this message translates to:
  /// **'Design side - what others see in you'**
  String get chart_designSide;

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

  /// No description provided for @social_title.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social_title;

  /// No description provided for @social_thoughts.
  ///
  /// In en, this message translates to:
  /// **'Thoughts'**
  String get social_thoughts;

  /// No description provided for @social_discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get social_discover;

  /// No description provided for @social_groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get social_groups;

  /// No description provided for @social_invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get social_invite;

  /// No description provided for @social_createPost.
  ///
  /// In en, this message translates to:
  /// **'Share a thought...'**
  String get social_createPost;

  /// No description provided for @social_noThoughtsYet.
  ///
  /// In en, this message translates to:
  /// **'No thoughts yet'**
  String get social_noThoughtsYet;

  /// No description provided for @social_noThoughtsMessage.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your Human Design insights!'**
  String get social_noThoughtsMessage;

  /// No description provided for @social_createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get social_createGroup;

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

  /// No description provided for @social_shared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get social_shared;

  /// No description provided for @social_noGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'No Groups Yet'**
  String get social_noGroupsYet;

  /// No description provided for @social_noGroupsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create groups to analyze team dynamics with Penta analysis.'**
  String get social_noGroupsMessage;

  /// No description provided for @social_noSharedCharts.
  ///
  /// In en, this message translates to:
  /// **'No Shared Charts'**
  String get social_noSharedCharts;

  /// No description provided for @social_noSharedChartsMessage.
  ///
  /// In en, this message translates to:
  /// **'Charts shared with you will appear here.'**
  String get social_noSharedChartsMessage;

  /// No description provided for @social_createGroupPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create a group to analyze team dynamics.'**
  String get social_createGroupPrompt;

  /// No description provided for @social_groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get social_groupName;

  /// No description provided for @social_groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'Family, Team, etc.'**
  String get social_groupNameHint;

  /// No description provided for @social_groupDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get social_groupDescription;

  /// No description provided for @social_groupDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is this group for?'**
  String get social_groupDescriptionHint;

  /// No description provided for @social_groupCreated.
  ///
  /// In en, this message translates to:
  /// **'Group \"{name}\" created!'**
  String social_groupCreated(String name);

  /// No description provided for @social_groupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a group name'**
  String get social_groupNameRequired;

  /// No description provided for @social_createGroupFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create group. Please try again.'**
  String get social_createGroupFailed;

  /// No description provided for @social_noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get social_noDescription;

  /// No description provided for @social_admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get social_admin;

  /// No description provided for @social_sharedBy.
  ///
  /// In en, this message translates to:
  /// **'Shared by {name}'**
  String social_sharedBy(String name);

  /// No description provided for @social_loadGroupsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load groups'**
  String get social_loadGroupsFailed;

  /// No description provided for @social_loadSharedFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load shared charts'**
  String get social_loadSharedFailed;

  /// No description provided for @social_userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get social_userNotFound;

  /// No description provided for @discovery_userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get discovery_userNotFound;

  /// No description provided for @discovery_following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get discovery_following;

  /// No description provided for @discovery_follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get discovery_follow;

  /// No description provided for @discovery_sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get discovery_sendMessage;

  /// No description provided for @discovery_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get discovery_about;

  /// No description provided for @discovery_humanDesign.
  ///
  /// In en, this message translates to:
  /// **'Human Design'**
  String get discovery_humanDesign;

  /// No description provided for @discovery_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get discovery_type;

  /// No description provided for @discovery_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get discovery_profile;

  /// No description provided for @discovery_authority.
  ///
  /// In en, this message translates to:
  /// **'Authority'**
  String get discovery_authority;

  /// No description provided for @discovery_compatibility.
  ///
  /// In en, this message translates to:
  /// **'Compatibility'**
  String get discovery_compatibility;

  /// No description provided for @discovery_compatible.
  ///
  /// In en, this message translates to:
  /// **'compatible'**
  String get discovery_compatible;

  /// No description provided for @discovery_followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get discovery_followers;

  /// No description provided for @discovery_followingLabel.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get discovery_followingLabel;

  /// No description provided for @discovery_noResults.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get discovery_noResults;

  /// No description provided for @discovery_noResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or check back later'**
  String get discovery_noResultsMessage;

  /// No description provided for @userProfile_viewChart.
  ///
  /// In en, this message translates to:
  /// **'Bodygraph'**
  String get userProfile_viewChart;

  /// No description provided for @userProfile_chartPrivate.
  ///
  /// In en, this message translates to:
  /// **'This chart is private'**
  String get userProfile_chartPrivate;

  /// No description provided for @userProfile_chartFriendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Become mutual followers to view this chart'**
  String get userProfile_chartFriendsOnly;

  /// No description provided for @userProfile_chartFollowToView.
  ///
  /// In en, this message translates to:
  /// **'Follow to view this chart'**
  String get userProfile_chartFollowToView;

  /// No description provided for @userProfile_publicProfile.
  ///
  /// In en, this message translates to:
  /// **'Public Profile'**
  String get userProfile_publicProfile;

  /// No description provided for @userProfile_privateProfile.
  ///
  /// In en, this message translates to:
  /// **'Private Profile'**
  String get userProfile_privateProfile;

  /// No description provided for @userProfile_friendsOnlyProfile.
  ///
  /// In en, this message translates to:
  /// **'Friends Only'**
  String get userProfile_friendsOnlyProfile;

  /// No description provided for @userProfile_followersList.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get userProfile_followersList;

  /// No description provided for @userProfile_followingList.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get userProfile_followingList;

  /// No description provided for @userProfile_noFollowers.
  ///
  /// In en, this message translates to:
  /// **'No followers yet'**
  String get userProfile_noFollowers;

  /// No description provided for @userProfile_noFollowing.
  ///
  /// In en, this message translates to:
  /// **'Not following anyone yet'**
  String get userProfile_noFollowing;

  /// No description provided for @userProfile_thoughts.
  ///
  /// In en, this message translates to:
  /// **'Thoughts'**
  String get userProfile_thoughts;

  /// No description provided for @userProfile_noThoughts.
  ///
  /// In en, this message translates to:
  /// **'No thoughts shared yet'**
  String get userProfile_noThoughts;

  /// No description provided for @userProfile_showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get userProfile_showAll;

  /// No description provided for @popularCharts_title.
  ///
  /// In en, this message translates to:
  /// **'Popular Charts'**
  String get popularCharts_title;

  /// No description provided for @popularCharts_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Most followed public charts'**
  String get popularCharts_subtitle;

  /// No description provided for @time_minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String time_minutesAgo(int minutes);

  /// No description provided for @time_hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String time_hoursAgo(int hours);

  /// No description provided for @time_daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String time_daysAgo(int days);

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

  /// No description provided for @penta_analysis.
  ///
  /// In en, this message translates to:
  /// **'Penta Analysis'**
  String get penta_analysis;

  /// No description provided for @penta_clearAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Clear Analysis'**
  String get penta_clearAnalysis;

  /// No description provided for @penta_infoText.
  ///
  /// In en, this message translates to:
  /// **'Penta analysis reveals the natural roles that emerge in small groups of 3-5 people, showing how each member contributes to team dynamics.'**
  String get penta_infoText;

  /// No description provided for @penta_calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get penta_calculating;

  /// No description provided for @penta_calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate Penta'**
  String get penta_calculate;

  /// No description provided for @penta_groupRoles.
  ///
  /// In en, this message translates to:
  /// **'Group Roles'**
  String get penta_groupRoles;

  /// No description provided for @penta_electromagneticConnections.
  ///
  /// In en, this message translates to:
  /// **'Electromagnetic Connections'**
  String get penta_electromagneticConnections;

  /// No description provided for @penta_connectionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Special energy connections between members that create attraction and chemistry.'**
  String get penta_connectionsDescription;

  /// No description provided for @penta_areasForAttention.
  ///
  /// In en, this message translates to:
  /// **'Areas for Attention'**
  String get penta_areasForAttention;

  /// No description provided for @composite_title.
  ///
  /// In en, this message translates to:
  /// **'Composite Chart'**
  String get composite_title;

  /// No description provided for @composite_infoText.
  ///
  /// In en, this message translates to:
  /// **'A composite chart shows the relationship dynamics between two people, revealing how your charts interact and complement each other.'**
  String get composite_infoText;

  /// No description provided for @composite_selectTwoCharts.
  ///
  /// In en, this message translates to:
  /// **'Select 2 Charts'**
  String get composite_selectTwoCharts;

  /// No description provided for @composite_calculate.
  ///
  /// In en, this message translates to:
  /// **'Analyze Connection'**
  String get composite_calculate;

  /// No description provided for @composite_calculating.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get composite_calculating;

  /// No description provided for @composite_clearAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Clear Analysis'**
  String get composite_clearAnalysis;

  /// No description provided for @composite_connectionTheme.
  ///
  /// In en, this message translates to:
  /// **'Connection Theme'**
  String get composite_connectionTheme;

  /// No description provided for @composite_definedCenters.
  ///
  /// In en, this message translates to:
  /// **'Defined'**
  String get composite_definedCenters;

  /// No description provided for @composite_undefinedCenters.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get composite_undefinedCenters;

  /// No description provided for @composite_score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get composite_score;

  /// No description provided for @composite_themeVeryBonded.
  ///
  /// In en, this message translates to:
  /// **'Very bonded connection - you may feel deeply intertwined, which can be intense'**
  String get composite_themeVeryBonded;

  /// No description provided for @composite_themeBonded.
  ///
  /// In en, this message translates to:
  /// **'Bonded connection - strong sense of togetherness and shared energy'**
  String get composite_themeBonded;

  /// No description provided for @composite_themeBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced connection - healthy mix of togetherness and independence'**
  String get composite_themeBalanced;

  /// No description provided for @composite_themeIndependent.
  ///
  /// In en, this message translates to:
  /// **'Independent connection - more space for individual growth'**
  String get composite_themeIndependent;

  /// No description provided for @composite_themeVeryIndependent.
  ///
  /// In en, this message translates to:
  /// **'Very independent connection - intentional connection time helps strengthen bond'**
  String get composite_themeVeryIndependent;

  /// No description provided for @composite_electromagnetic.
  ///
  /// In en, this message translates to:
  /// **'Electromagnetic Channels'**
  String get composite_electromagnetic;

  /// No description provided for @composite_electromagneticDesc.
  ///
  /// In en, this message translates to:
  /// **'Intense attraction - you complete each other'**
  String get composite_electromagneticDesc;

  /// No description provided for @composite_companionship.
  ///
  /// In en, this message translates to:
  /// **'Companionship Channels'**
  String get composite_companionship;

  /// No description provided for @composite_companionshipDesc.
  ///
  /// In en, this message translates to:
  /// **'Comfort and stability - shared understanding'**
  String get composite_companionshipDesc;

  /// No description provided for @composite_dominance.
  ///
  /// In en, this message translates to:
  /// **'Dominance Channels'**
  String get composite_dominance;

  /// No description provided for @composite_dominanceDesc.
  ///
  /// In en, this message translates to:
  /// **'One teaches/conditions the other'**
  String get composite_dominanceDesc;

  /// No description provided for @composite_compromise.
  ///
  /// In en, this message translates to:
  /// **'Compromise Channels'**
  String get composite_compromise;

  /// No description provided for @composite_compromiseDesc.
  ///
  /// In en, this message translates to:
  /// **'Natural tension - requires awareness'**
  String get composite_compromiseDesc;

  /// No description provided for @composite_noConnections.
  ///
  /// In en, this message translates to:
  /// **'No Channel Connections'**
  String get composite_noConnections;

  /// No description provided for @composite_noConnectionsDesc.
  ///
  /// In en, this message translates to:
  /// **'These charts don\'t form any direct channel connections, but there may still be interesting gate interactions.'**
  String get composite_noConnectionsDesc;

  /// No description provided for @composite_noChartsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Charts Available'**
  String get composite_noChartsTitle;

  /// No description provided for @composite_noChartsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create charts for yourself and others to compare your relationship dynamics.'**
  String get composite_noChartsDesc;

  /// No description provided for @composite_needMoreCharts.
  ///
  /// In en, this message translates to:
  /// **'Need More Charts'**
  String get composite_needMoreCharts;

  /// No description provided for @composite_needMoreChartsDesc.
  ///
  /// In en, this message translates to:
  /// **'You need at least 2 charts to analyze a relationship. Add another chart to continue.'**
  String get composite_needMoreChartsDesc;

  /// No description provided for @composite_selectTwoHint.
  ///
  /// In en, this message translates to:
  /// **'Select 2 charts to analyze their connection'**
  String get composite_selectTwoHint;

  /// No description provided for @composite_selectOneMore.
  ///
  /// In en, this message translates to:
  /// **'Select 1 more chart'**
  String get composite_selectOneMore;

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

  /// No description provided for @settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearance;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settings_selectLanguage;

  /// No description provided for @settings_changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get settings_changeLanguage;

  /// No description provided for @settings_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme;

  /// No description provided for @settings_selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get settings_selectTheme;

  /// No description provided for @settings_chartDisplay.
  ///
  /// In en, this message translates to:
  /// **'Chart Display'**
  String get settings_chartDisplay;

  /// No description provided for @settings_showGateNumbers.
  ///
  /// In en, this message translates to:
  /// **'Show Gate Numbers'**
  String get settings_showGateNumbers;

  /// No description provided for @settings_showGateNumbersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display gate numbers on the bodygraph'**
  String get settings_showGateNumbersSubtitle;

  /// No description provided for @settings_use24HourTime.
  ///
  /// In en, this message translates to:
  /// **'Use 24-Hour Time'**
  String get settings_use24HourTime;

  /// No description provided for @settings_use24HourTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display time in 24-hour format'**
  String get settings_use24HourTimeSubtitle;

  /// No description provided for @settings_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get settings_feedback;

  /// No description provided for @settings_hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get settings_hapticFeedback;

  /// No description provided for @settings_hapticFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibration on interactions'**
  String get settings_hapticFeedbackSubtitle;

  /// No description provided for @settings_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_account;

  /// No description provided for @settings_changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settings_changePassword;

  /// No description provided for @settings_deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settings_deleteAccount;

  /// No description provided for @settings_deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.'**
  String get settings_deleteAccountConfirm;

  /// No description provided for @settings_appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settings_appVersion;

  /// No description provided for @settings_rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get settings_rateApp;

  /// No description provided for @settings_sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get settings_sendFeedback;

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

  /// No description provided for @settings_chartVisibility.
  ///
  /// In en, this message translates to:
  /// **'Chart Visibility'**
  String get settings_chartVisibility;

  /// No description provided for @settings_chartVisibilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control who can view your Human Design chart'**
  String get settings_chartVisibilitySubtitle;

  /// No description provided for @settings_chartPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get settings_chartPrivate;

  /// No description provided for @settings_chartPrivateDesc.
  ///
  /// In en, this message translates to:
  /// **'Only you can see your chart'**
  String get settings_chartPrivateDesc;

  /// No description provided for @settings_chartFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get settings_chartFriends;

  /// No description provided for @settings_chartFriendsDesc.
  ///
  /// In en, this message translates to:
  /// **'Mutual followers can view your chart'**
  String get settings_chartFriendsDesc;

  /// No description provided for @settings_chartPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get settings_chartPublic;

  /// No description provided for @settings_chartPublicDesc.
  ///
  /// In en, this message translates to:
  /// **'Your followers can view your chart'**
  String get settings_chartPublicDesc;

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

  /// No description provided for @settings_dailyTransits.
  ///
  /// In en, this message translates to:
  /// **'Daily Transits'**
  String get settings_dailyTransits;

  /// No description provided for @settings_dailyTransitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive daily transit updates'**
  String get settings_dailyTransitsSubtitle;

  /// No description provided for @settings_gateChanges.
  ///
  /// In en, this message translates to:
  /// **'Gate Changes'**
  String get settings_gateChanges;

  /// No description provided for @settings_gateChangesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify when Sun changes gates'**
  String get settings_gateChangesSubtitle;

  /// No description provided for @settings_socialActivity.
  ///
  /// In en, this message translates to:
  /// **'Social Activity'**
  String get settings_socialActivity;

  /// No description provided for @settings_socialActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Friend requests and shared charts'**
  String get settings_socialActivitySubtitle;

  /// No description provided for @settings_achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get settings_achievements;

  /// No description provided for @settings_achievementsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Badge unlocks and milestones'**
  String get settings_achievementsSubtitle;

  /// No description provided for @settings_deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your data including charts, posts, and messages.'**
  String get settings_deleteAccountWarning;

  /// No description provided for @settings_deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get settings_deleteAccountFailed;

  /// No description provided for @settings_passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get settings_passwordChanged;

  /// No description provided for @settings_passwordChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password. Please try again.'**
  String get settings_passwordChangeFailed;

  /// No description provided for @settings_feedbackSubject.
  ///
  /// In en, this message translates to:
  /// **'Human Design App Feedback'**
  String get settings_feedbackSubject;

  /// No description provided for @settings_feedbackBody.
  ///
  /// In en, this message translates to:
  /// **'Hi,\n\nI would like to share the following feedback about the Human Design app:\n\n'**
  String get settings_feedbackBody;

  /// No description provided for @auth_newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get auth_newPassword;

  /// No description provided for @auth_passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get auth_passwordRequired;

  /// No description provided for @auth_passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get auth_passwordTooShort;

  /// No description provided for @auth_passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get auth_passwordsDoNotMatch;

  /// No description provided for @settings_exportData.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get settings_exportData;

  /// No description provided for @settings_exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download a copy of all your data (GDPR)'**
  String get settings_exportDataSubtitle;

  /// No description provided for @settings_exportingData.
  ///
  /// In en, this message translates to:
  /// **'Preparing your data export...'**
  String get settings_exportingData;

  /// No description provided for @settings_exportDataSubject.
  ///
  /// In en, this message translates to:
  /// **'Human Design App - My Data Export'**
  String get settings_exportDataSubject;

  /// No description provided for @settings_exportDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export data. Please try again.'**
  String get settings_exportDataFailed;

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

  /// No description provided for @profile_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_editProfile;

  /// No description provided for @profile_shareChart.
  ///
  /// In en, this message translates to:
  /// **'Share My Chart'**
  String get profile_shareChart;

  /// No description provided for @profile_exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export Chart PDF'**
  String get profile_exportPdf;

  /// No description provided for @profile_upgradePremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get profile_upgradePremium;

  /// No description provided for @profile_birthData.
  ///
  /// In en, this message translates to:
  /// **'Birth Data'**
  String get profile_birthData;

  /// No description provided for @profile_chartSummary.
  ///
  /// In en, this message translates to:
  /// **'Chart Summary'**
  String get profile_chartSummary;

  /// No description provided for @profile_viewFullChart.
  ///
  /// In en, this message translates to:
  /// **'View Full Chart'**
  String get profile_viewFullChart;

  /// No description provided for @profile_signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profile_signOut;

  /// No description provided for @profile_signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get profile_signOutConfirm;

  /// No description provided for @profile_addBirthDataPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your birth data to generate your Human Design chart.'**
  String get profile_addBirthDataPrompt;

  /// No description provided for @profile_addBirthDataToShare.
  ///
  /// In en, this message translates to:
  /// **'Add birth data to share your chart'**
  String get profile_addBirthDataToShare;

  /// No description provided for @profile_addBirthDataToExport.
  ///
  /// In en, this message translates to:
  /// **'Add birth data to export your chart'**
  String get profile_addBirthDataToExport;

  /// No description provided for @profile_exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export PDF'**
  String get profile_exportFailed;

  /// No description provided for @profile_signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profile_signOutConfirmTitle;

  /// No description provided for @profile_loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profile_loadFailed;

  /// No description provided for @profile_defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'Human Design User'**
  String get profile_defaultUserName;

  /// No description provided for @profile_birthDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get profile_birthDate;

  /// No description provided for @profile_birthTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get profile_birthTime;

  /// No description provided for @profile_birthLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profile_birthLocation;

  /// No description provided for @profile_birthTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get profile_birthTimezone;

  /// No description provided for @chart_chakras.
  ///
  /// In en, this message translates to:
  /// **'Chakras'**
  String get chart_chakras;

  /// No description provided for @chakra_title.
  ///
  /// In en, this message translates to:
  /// **'Chakra Energy'**
  String get chakra_title;

  /// No description provided for @chakra_activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get chakra_activated;

  /// No description provided for @chakra_inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get chakra_inactive;

  /// No description provided for @chakra_activatedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of 7 chakras activated'**
  String chakra_activatedCount(int count);

  /// No description provided for @chakra_hdMapping.
  ///
  /// In en, this message translates to:
  /// **'HD Center Mapping'**
  String get chakra_hdMapping;

  /// No description provided for @chakra_element.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get chakra_element;

  /// No description provided for @chakra_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get chakra_location;

  /// No description provided for @chakra_root.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get chakra_root;

  /// No description provided for @chakra_root_sanskrit.
  ///
  /// In en, this message translates to:
  /// **'Muladhara'**
  String get chakra_root_sanskrit;

  /// No description provided for @chakra_root_description.
  ///
  /// In en, this message translates to:
  /// **'Grounding, survival, and stability'**
  String get chakra_root_description;

  /// No description provided for @chakra_sacral.
  ///
  /// In en, this message translates to:
  /// **'Sacral'**
  String get chakra_sacral;

  /// No description provided for @chakra_sacral_sanskrit.
  ///
  /// In en, this message translates to:
  /// **'Svadhisthana'**
  String get chakra_sacral_sanskrit;

  /// No description provided for @chakra_sacral_description.
  ///
  /// In en, this message translates to:
  /// **'Creativity, sexuality, and emotions'**
  String get chakra_sacral_description;

  /// No description provided for @chakra_solarPlexus.
  ///
  /// In en, this message translates to:
  /// **'Solar Plexus'**
  String get chakra_solarPlexus;

  /// No description provided for @chakra_solarPlexus_sanskrit.
  ///
  /// In en, this message translates to:
  /// **'Manipura'**
  String get chakra_solarPlexus_sanskrit;

  /// No description provided for @chakra_solarPlexus_description.
  ///
  /// In en, this message translates to:
  /// **'Personal power, confidence, and will'**
  String get chakra_solarPlexus_description;

  /// No description provided for @chakra_heart.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get chakra_heart;

  /// No description provided for @chakra_heart_sanskrit.
  ///
  /// In en, this message translates to:
  /// **'Anahata'**
  String get chakra_heart_sanskrit;

  /// No description provided for @chakra_heart_description.
  ///
  /// In en, this message translates to:
  /// **'Love, compassion, and connection'**
  String get chakra_heart_description;

  /// No description provided for @chakra_throat.
  ///
  /// In en, this message translates to:
  /// **'Throat'**
  String get chakra_throat;

  /// No description provided for @chakra_throat_sanskrit.
  ///
  /// In en, this message translates to:
  /// **'Vishuddha'**
  String get chakra_throat_sanskrit;

  /// No description provided for @chakra_throat_description.
  ///
  /// In en, this message translates to:
  /// **'Communication, expression, and truth'**
  String get chakra_throat_description;

  /// No description provided for @chakra_thirdEye.
  ///
  /// In en, this message translates to:
  /// **'Third Eye'**
  String get chakra_thirdEye;

  /// No description provided for @chakra_thirdEye_sanskrit.
  ///
  /// In en, this message translates to:
  /// **'Ajna'**
  String get chakra_thirdEye_sanskrit;

  /// No description provided for @chakra_thirdEye_description.
  ///
  /// In en, this message translates to:
  /// **'Intuition, insight, and imagination'**
  String get chakra_thirdEye_description;

  /// No description provided for @chakra_crown.
  ///
  /// In en, this message translates to:
  /// **'Crown'**
  String get chakra_crown;

  /// No description provided for @chakra_crown_sanskrit.
  ///
  /// In en, this message translates to:
  /// **'Sahasrara'**
  String get chakra_crown_sanskrit;

  /// No description provided for @chakra_crown_description.
  ///
  /// In en, this message translates to:
  /// **'Spiritual connection and consciousness'**
  String get chakra_crown_description;

  /// No description provided for @quiz_title.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quiz_title;

  /// No description provided for @quiz_yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get quiz_yourProgress;

  /// No description provided for @quiz_quizzesCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} quizzes completed'**
  String quiz_quizzesCompleted(int count);

  /// No description provided for @quiz_accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get quiz_accuracy;

  /// No description provided for @quiz_streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get quiz_streak;

  /// No description provided for @quiz_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get quiz_all;

  /// No description provided for @quiz_difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get quiz_difficulty;

  /// No description provided for @quiz_beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get quiz_beginner;

  /// No description provided for @quiz_intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get quiz_intermediate;

  /// No description provided for @quiz_advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get quiz_advanced;

  /// No description provided for @quiz_questions.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String quiz_questions(int count);

  /// No description provided for @quiz_points.
  ///
  /// In en, this message translates to:
  /// **'+{points} pts'**
  String quiz_points(int points);

  /// No description provided for @quiz_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get quiz_completed;

  /// No description provided for @quiz_noQuizzes.
  ///
  /// In en, this message translates to:
  /// **'No quizzes available'**
  String get quiz_noQuizzes;

  /// No description provided for @quiz_checkBackLater.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new content'**
  String get quiz_checkBackLater;

  /// No description provided for @quiz_startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get quiz_startQuiz;

  /// No description provided for @quiz_tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get quiz_tryAgain;

  /// No description provided for @quiz_backToQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Back to Quizzes'**
  String get quiz_backToQuizzes;

  /// No description provided for @quiz_shareResults.
  ///
  /// In en, this message translates to:
  /// **'Share Results'**
  String get quiz_shareResults;

  /// No description provided for @quiz_yourBest.
  ///
  /// In en, this message translates to:
  /// **'Your Best'**
  String get quiz_yourBest;

  /// No description provided for @quiz_perfectScore.
  ///
  /// In en, this message translates to:
  /// **'Perfect Score!'**
  String get quiz_perfectScore;

  /// No description provided for @quiz_newBest.
  ///
  /// In en, this message translates to:
  /// **'New Best!'**
  String get quiz_newBest;

  /// No description provided for @quiz_streakExtended.
  ///
  /// In en, this message translates to:
  /// **'Streak Extended!'**
  String get quiz_streakExtended;

  /// No description provided for @quiz_questionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quiz_questionOf(int current, int total);

  /// No description provided for @quiz_correct.
  ///
  /// In en, this message translates to:
  /// **'{count} correct'**
  String quiz_correct(int count);

  /// No description provided for @quiz_submitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get quiz_submitAnswer;

  /// No description provided for @quiz_nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get quiz_nextQuestion;

  /// No description provided for @quiz_seeResults.
  ///
  /// In en, this message translates to:
  /// **'See Results'**
  String get quiz_seeResults;

  /// No description provided for @quiz_exitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Exit Quiz?'**
  String get quiz_exitQuiz;

  /// No description provided for @quiz_exitWarning.
  ///
  /// In en, this message translates to:
  /// **'Your progress will be lost if you exit now.'**
  String get quiz_exitWarning;

  /// No description provided for @quiz_exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get quiz_exit;

  /// No description provided for @quiz_timesUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s Up!'**
  String get quiz_timesUp;

  /// No description provided for @quiz_timesUpMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve run out of time. Your progress will be submitted.'**
  String get quiz_timesUpMessage;

  /// No description provided for @quiz_excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get quiz_excellent;

  /// No description provided for @quiz_goodJob.
  ///
  /// In en, this message translates to:
  /// **'Good Job!'**
  String get quiz_goodJob;

  /// No description provided for @quiz_keepLearning.
  ///
  /// In en, this message translates to:
  /// **'Keep Learning!'**
  String get quiz_keepLearning;

  /// No description provided for @quiz_keepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep Practicing!'**
  String get quiz_keepPracticing;

  /// No description provided for @quiz_masteredTopic.
  ///
  /// In en, this message translates to:
  /// **'You\'ve mastered this topic!'**
  String get quiz_masteredTopic;

  /// No description provided for @quiz_strongUnderstanding.
  ///
  /// In en, this message translates to:
  /// **'You have a strong understanding.'**
  String get quiz_strongUnderstanding;

  /// No description provided for @quiz_onRightTrack.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the right track.'**
  String get quiz_onRightTrack;

  /// No description provided for @quiz_reviewExplanations.
  ///
  /// In en, this message translates to:
  /// **'Review the explanations to improve.'**
  String get quiz_reviewExplanations;

  /// No description provided for @quiz_studyMaterial.
  ///
  /// In en, this message translates to:
  /// **'Study the material and try again.'**
  String get quiz_studyMaterial;

  /// No description provided for @quiz_attemptHistory.
  ///
  /// In en, this message translates to:
  /// **'Attempt History'**
  String get quiz_attemptHistory;

  /// No description provided for @quiz_statistics.
  ///
  /// In en, this message translates to:
  /// **'Quiz Statistics'**
  String get quiz_statistics;

  /// No description provided for @quiz_totalQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quiz_totalQuizzes;

  /// No description provided for @quiz_totalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get quiz_totalQuestions;

  /// No description provided for @quiz_bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get quiz_bestStreak;

  /// No description provided for @quiz_strongest.
  ///
  /// In en, this message translates to:
  /// **'Strongest: {category}'**
  String quiz_strongest(String category);

  /// No description provided for @quiz_needsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs work: {category}'**
  String quiz_needsWork(String category);

  /// No description provided for @quiz_category_types.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get quiz_category_types;

  /// No description provided for @quiz_category_centers.
  ///
  /// In en, this message translates to:
  /// **'Centers'**
  String get quiz_category_centers;

  /// No description provided for @quiz_category_authorities.
  ///
  /// In en, this message translates to:
  /// **'Authorities'**
  String get quiz_category_authorities;

  /// No description provided for @quiz_category_profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get quiz_category_profiles;

  /// No description provided for @quiz_category_gates.
  ///
  /// In en, this message translates to:
  /// **'Gates'**
  String get quiz_category_gates;

  /// No description provided for @quiz_category_channels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get quiz_category_channels;

  /// No description provided for @quiz_category_definitions.
  ///
  /// In en, this message translates to:
  /// **'Definitions'**
  String get quiz_category_definitions;

  /// No description provided for @quiz_category_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get quiz_category_general;

  /// No description provided for @quiz_explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get quiz_explanation;

  /// No description provided for @quiz_quizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quiz_quizzes;

  /// No description provided for @quiz_questionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get quiz_questionsLabel;

  /// No description provided for @quiz_shareProgress.
  ///
  /// In en, this message translates to:
  /// **'Share Progress'**
  String get quiz_shareProgress;

  /// No description provided for @quiz_shareProgressSubject.
  ///
  /// In en, this message translates to:
  /// **'My Human Design Learning Progress'**
  String get quiz_shareProgressSubject;

  /// No description provided for @quiz_sharePerfect.
  ///
  /// In en, this message translates to:
  /// **'I achieved a perfect score! I\'m mastering Human Design.'**
  String get quiz_sharePerfect;

  /// No description provided for @quiz_shareExcellent.
  ///
  /// In en, this message translates to:
  /// **'I\'m doing great on my Human Design learning journey!'**
  String get quiz_shareExcellent;

  /// No description provided for @quiz_shareGoodJob.
  ///
  /// In en, this message translates to:
  /// **'I\'m learning about Human Design. Every quiz helps me grow!'**
  String get quiz_shareGoodJob;

  /// No description provided for @quiz_shareSubject.
  ///
  /// In en, this message translates to:
  /// **'I scored {score}% on \"{quizTitle}\" - Human Design Quiz'**
  String quiz_shareSubject(String quizTitle, int score);

  /// No description provided for @quiz_failedToLoadStats.
  ///
  /// In en, this message translates to:
  /// **'Failed to load stats'**
  String get quiz_failedToLoadStats;

  /// No description provided for @planetary_personality.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get planetary_personality;

  /// No description provided for @planetary_design.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get planetary_design;

  /// No description provided for @planetary_consciousBirth.
  ///
  /// In en, this message translates to:
  /// **'Conscious · Birth'**
  String get planetary_consciousBirth;

  /// No description provided for @planetary_unconsciousPrenatal.
  ///
  /// In en, this message translates to:
  /// **'Unconscious · 88° Prenatal'**
  String get planetary_unconsciousPrenatal;

  /// No description provided for @gamification_yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get gamification_yourProgress;

  /// No description provided for @gamification_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get gamification_level;

  /// No description provided for @gamification_points.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get gamification_points;

  /// No description provided for @gamification_viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get gamification_viewAll;

  /// No description provided for @gamification_allChallengesComplete.
  ///
  /// In en, this message translates to:
  /// **'All daily challenges complete!'**
  String get gamification_allChallengesComplete;

  /// No description provided for @gamification_dailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get gamification_dailyChallenge;

  /// No description provided for @gamification_achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get gamification_achievements;

  /// No description provided for @gamification_challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get gamification_challenges;

  /// No description provided for @gamification_leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get gamification_leaderboard;

  /// No description provided for @gamification_streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get gamification_streak;

  /// No description provided for @gamification_badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get gamification_badges;

  /// No description provided for @gamification_earnedBadge.
  ///
  /// In en, this message translates to:
  /// **'You earned a badge!'**
  String get gamification_earnedBadge;

  /// No description provided for @gamification_claimReward.
  ///
  /// In en, this message translates to:
  /// **'Claim Reward'**
  String get gamification_claimReward;

  /// No description provided for @gamification_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get gamification_completed;

  /// No description provided for @common_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get common_copy;

  /// No description provided for @share_myShares.
  ///
  /// In en, this message translates to:
  /// **'My Shares'**
  String get share_myShares;

  /// No description provided for @share_createNew.
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get share_createNew;

  /// No description provided for @share_newLink.
  ///
  /// In en, this message translates to:
  /// **'New Link'**
  String get share_newLink;

  /// No description provided for @share_noShares.
  ///
  /// In en, this message translates to:
  /// **'No Shared Links'**
  String get share_noShares;

  /// No description provided for @share_noSharesMessage.
  ///
  /// In en, this message translates to:
  /// **'Create share links to let others view your chart without needing an account.'**
  String get share_noSharesMessage;

  /// No description provided for @share_createFirst.
  ///
  /// In en, this message translates to:
  /// **'Create Your First Link'**
  String get share_createFirst;

  /// No description provided for @share_activeLinks.
  ///
  /// In en, this message translates to:
  /// **'{count} Active Links'**
  String share_activeLinks(int count);

  /// No description provided for @share_expiredLinks.
  ///
  /// In en, this message translates to:
  /// **'{count} Expired'**
  String share_expiredLinks(int count);

  /// No description provided for @share_clearExpired.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get share_clearExpired;

  /// No description provided for @share_clearExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Expired Links'**
  String get share_clearExpiredTitle;

  /// No description provided for @share_clearExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove {count} expired links from your history.'**
  String share_clearExpiredMessage(int count);

  /// No description provided for @share_clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get share_clearAll;

  /// No description provided for @share_expiredCleared.
  ///
  /// In en, this message translates to:
  /// **'Expired links cleared'**
  String get share_expiredCleared;

  /// No description provided for @share_linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get share_linkCopied;

  /// No description provided for @share_revokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke Link'**
  String get share_revokeTitle;

  /// No description provided for @share_revokeMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently disable this share link. Anyone with the link will no longer be able to view your chart.'**
  String get share_revokeMessage;

  /// No description provided for @share_revoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get share_revoke;

  /// No description provided for @share_linkRevoked.
  ///
  /// In en, this message translates to:
  /// **'Link revoked'**
  String get share_linkRevoked;

  /// No description provided for @share_totalLinks.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get share_totalLinks;

  /// No description provided for @share_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get share_active;

  /// No description provided for @share_totalViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get share_totalViews;

  /// No description provided for @share_chartLink.
  ///
  /// In en, this message translates to:
  /// **'Chart Share'**
  String get share_chartLink;

  /// No description provided for @share_transitLink.
  ///
  /// In en, this message translates to:
  /// **'Transit Share'**
  String get share_transitLink;

  /// No description provided for @share_compatibilityLink.
  ///
  /// In en, this message translates to:
  /// **'Compatibility Report'**
  String get share_compatibilityLink;

  /// No description provided for @share_link.
  ///
  /// In en, this message translates to:
  /// **'Share Link'**
  String get share_link;

  /// No description provided for @share_views.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String share_views(int count);

  /// No description provided for @share_expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get share_expired;

  /// No description provided for @share_activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get share_activeLabel;

  /// No description provided for @share_expiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired {date}'**
  String share_expiredOn(String date);

  /// No description provided for @share_expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in {time}'**
  String share_expiresIn(String time);

  /// No description provided for @auth_emailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email'**
  String get auth_emailNotConfirmed;

  /// No description provided for @auth_resendConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Resend Confirmation Email'**
  String get auth_resendConfirmation;

  /// No description provided for @auth_confirmationSent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent'**
  String get auth_confirmationSent;

  /// No description provided for @auth_checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email for the confirmation link'**
  String get auth_checkEmail;

  /// No description provided for @auth_checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get auth_checkYourEmail;

  /// No description provided for @auth_confirmationLinkSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation link to:'**
  String get auth_confirmationLinkSent;

  /// No description provided for @auth_clickLinkToActivate.
  ///
  /// In en, this message translates to:
  /// **'Please click the link in the email to activate your account.'**
  String get auth_clickLinkToActivate;

  /// No description provided for @auth_goToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Go to Sign In'**
  String get auth_goToSignIn;

  /// No description provided for @auth_returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get auth_returnToHome;

  /// No description provided for @hashtags_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore Hashtags'**
  String get hashtags_explore;

  /// No description provided for @hashtags_trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get hashtags_trending;

  /// No description provided for @hashtags_popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get hashtags_popular;

  /// No description provided for @hashtags_hdTopics.
  ///
  /// In en, this message translates to:
  /// **'HD Topics'**
  String get hashtags_hdTopics;

  /// No description provided for @hashtags_noTrending.
  ///
  /// In en, this message translates to:
  /// **'No trending hashtags yet'**
  String get hashtags_noTrending;

  /// No description provided for @hashtags_noPopular.
  ///
  /// In en, this message translates to:
  /// **'No popular hashtags yet'**
  String get hashtags_noPopular;

  /// No description provided for @hashtags_noHdTopics.
  ///
  /// In en, this message translates to:
  /// **'No HD topics yet'**
  String get hashtags_noHdTopics;

  /// No description provided for @hashtag_noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get hashtag_noPosts;

  /// No description provided for @hashtag_beFirst.
  ///
  /// In en, this message translates to:
  /// **'Be the first to post with this hashtag!'**
  String get hashtag_beFirst;

  /// No description provided for @hashtag_postCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 post} other{{count} posts}}'**
  String hashtag_postCount(int count);

  /// No description provided for @hashtag_recentPosts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 post today} other{{count} posts today}}'**
  String hashtag_recentPosts(int count);

  /// No description provided for @feed_forYou.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get feed_forYou;

  /// No description provided for @feed_trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get feed_trending;

  /// No description provided for @feed_hdTopics.
  ///
  /// In en, this message translates to:
  /// **'HD Topics'**
  String get feed_hdTopics;

  /// No description provided for @feed_gateTitle.
  ///
  /// In en, this message translates to:
  /// **'Gate {number}'**
  String feed_gateTitle(int number);

  /// No description provided for @feed_gatePosts.
  ///
  /// In en, this message translates to:
  /// **'Posts about Gate {number}'**
  String feed_gatePosts(int number);

  /// No description provided for @transit_events_title.
  ///
  /// In en, this message translates to:
  /// **'Transit Events'**
  String get transit_events_title;

  /// No description provided for @transit_events_happening.
  ///
  /// In en, this message translates to:
  /// **'Happening Now'**
  String get transit_events_happening;

  /// No description provided for @transit_events_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get transit_events_upcoming;

  /// No description provided for @transit_events_past.
  ///
  /// In en, this message translates to:
  /// **'Past Events'**
  String get transit_events_past;

  /// No description provided for @transit_events_noCurrentEvents.
  ///
  /// In en, this message translates to:
  /// **'No events happening right now'**
  String get transit_events_noCurrentEvents;

  /// No description provided for @transit_events_noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events scheduled'**
  String get transit_events_noUpcomingEvents;

  /// No description provided for @transit_events_noPastEvents.
  ///
  /// In en, this message translates to:
  /// **'No past events'**
  String get transit_events_noPastEvents;

  /// No description provided for @transit_events_live.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get transit_events_live;

  /// No description provided for @transit_events_join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get transit_events_join;

  /// No description provided for @transit_events_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get transit_events_joined;

  /// No description provided for @transit_events_leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get transit_events_leave;

  /// No description provided for @transit_events_participating.
  ///
  /// In en, this message translates to:
  /// **'participating'**
  String get transit_events_participating;

  /// No description provided for @transit_events_posts.
  ///
  /// In en, this message translates to:
  /// **'posts'**
  String get transit_events_posts;

  /// No description provided for @transit_events_viewInsights.
  ///
  /// In en, this message translates to:
  /// **'View Insights'**
  String get transit_events_viewInsights;

  /// No description provided for @transit_events_endsIn.
  ///
  /// In en, this message translates to:
  /// **'Ends in {time}'**
  String transit_events_endsIn(String time);

  /// No description provided for @transit_events_startsIn.
  ///
  /// In en, this message translates to:
  /// **'Starts in {time}'**
  String transit_events_startsIn(String time);

  /// No description provided for @transit_events_notFound.
  ///
  /// In en, this message translates to:
  /// **'Event not found'**
  String get transit_events_notFound;

  /// No description provided for @transit_events_communityPosts.
  ///
  /// In en, this message translates to:
  /// **'Community Posts'**
  String get transit_events_communityPosts;

  /// No description provided for @transit_events_noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet for this event'**
  String get transit_events_noPosts;

  /// No description provided for @transit_events_shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share Experience'**
  String get transit_events_shareExperience;

  /// No description provided for @transit_events_participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get transit_events_participants;

  /// No description provided for @transit_events_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get transit_events_duration;

  /// No description provided for @transit_events_eventEnded.
  ///
  /// In en, this message translates to:
  /// **'This event has ended'**
  String get transit_events_eventEnded;

  /// No description provided for @transit_events_youreParticipating.
  ///
  /// In en, this message translates to:
  /// **'You\'re participating!'**
  String get transit_events_youreParticipating;

  /// No description provided for @transit_events_experiencingWith.
  ///
  /// In en, this message translates to:
  /// **'Experiencing this transit with {count} others'**
  String transit_events_experiencingWith(int count);

  /// No description provided for @transit_events_joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join the Community'**
  String get transit_events_joinCommunity;

  /// No description provided for @transit_events_shareYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience and connect with others'**
  String get transit_events_shareYourExperience;

  /// No description provided for @activity_title.
  ///
  /// In en, this message translates to:
  /// **'Friend Activity'**
  String get activity_title;

  /// No description provided for @activity_noActivities.
  ///
  /// In en, this message translates to:
  /// **'No friend activity yet'**
  String get activity_noActivities;

  /// No description provided for @activity_followFriends.
  ///
  /// In en, this message translates to:
  /// **'Follow friends to see their achievements and milestones here!'**
  String get activity_followFriends;

  /// No description provided for @activity_findFriends.
  ///
  /// In en, this message translates to:
  /// **'Find Friends'**
  String get activity_findFriends;

  /// No description provided for @activity_celebrate.
  ///
  /// In en, this message translates to:
  /// **'Celebrate'**
  String get activity_celebrate;

  /// No description provided for @activity_celebrated.
  ///
  /// In en, this message translates to:
  /// **'Celebrated'**
  String get activity_celebrated;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @groupChallenges_title.
  ///
  /// In en, this message translates to:
  /// **'Group Challenges'**
  String get groupChallenges_title;

  /// No description provided for @groupChallenges_myTeams.
  ///
  /// In en, this message translates to:
  /// **'My Teams'**
  String get groupChallenges_myTeams;

  /// No description provided for @groupChallenges_challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get groupChallenges_challenges;

  /// No description provided for @groupChallenges_leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get groupChallenges_leaderboard;

  /// No description provided for @groupChallenges_createTeam.
  ///
  /// In en, this message translates to:
  /// **'Create Team'**
  String get groupChallenges_createTeam;

  /// No description provided for @groupChallenges_teamName.
  ///
  /// In en, this message translates to:
  /// **'Team Name'**
  String get groupChallenges_teamName;

  /// No description provided for @groupChallenges_teamNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a team name'**
  String get groupChallenges_teamNameHint;

  /// No description provided for @groupChallenges_teamDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get groupChallenges_teamDescription;

  /// No description provided for @groupChallenges_teamDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is your team about?'**
  String get groupChallenges_teamDescriptionHint;

  /// No description provided for @groupChallenges_teamCreated.
  ///
  /// In en, this message translates to:
  /// **'Team created successfully!'**
  String get groupChallenges_teamCreated;

  /// No description provided for @groupChallenges_noTeams.
  ///
  /// In en, this message translates to:
  /// **'No Teams Yet'**
  String get groupChallenges_noTeams;

  /// No description provided for @groupChallenges_noTeamsDescription.
  ///
  /// In en, this message translates to:
  /// **'Create or join a team to compete in group challenges!'**
  String get groupChallenges_noTeamsDescription;

  /// No description provided for @groupChallenges_memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String groupChallenges_memberCount(int count);

  /// No description provided for @groupChallenges_points.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String groupChallenges_points(int points);

  /// No description provided for @groupChallenges_noChallenges.
  ///
  /// In en, this message translates to:
  /// **'No Active Challenges'**
  String get groupChallenges_noChallenges;

  /// No description provided for @groupChallenges_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get groupChallenges_active;

  /// No description provided for @groupChallenges_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get groupChallenges_upcoming;

  /// No description provided for @groupChallenges_reward.
  ///
  /// In en, this message translates to:
  /// **'{points} pts reward'**
  String groupChallenges_reward(int points);

  /// No description provided for @groupChallenges_teamsEnrolled.
  ///
  /// In en, this message translates to:
  /// **'{count} teams'**
  String groupChallenges_teamsEnrolled(String count);

  /// No description provided for @groupChallenges_participants.
  ///
  /// In en, this message translates to:
  /// **'{count} participants'**
  String groupChallenges_participants(String count);

  /// No description provided for @groupChallenges_endsIn.
  ///
  /// In en, this message translates to:
  /// **'Ends in {time}'**
  String groupChallenges_endsIn(String time);

  /// No description provided for @groupChallenges_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get groupChallenges_weekly;

  /// No description provided for @groupChallenges_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get groupChallenges_monthly;

  /// No description provided for @groupChallenges_allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get groupChallenges_allTime;

  /// No description provided for @groupChallenges_noTeamsOnLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'No teams on leaderboard yet'**
  String get groupChallenges_noTeamsOnLeaderboard;

  /// No description provided for @groupChallenges_pts.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get groupChallenges_pts;

  /// No description provided for @groupChallenges_teamNotFound.
  ///
  /// In en, this message translates to:
  /// **'Team not found'**
  String get groupChallenges_teamNotFound;

  /// No description provided for @groupChallenges_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get groupChallenges_members;

  /// No description provided for @groupChallenges_totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get groupChallenges_totalPoints;

  /// No description provided for @groupChallenges_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get groupChallenges_joined;

  /// No description provided for @groupChallenges_join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get groupChallenges_join;

  /// No description provided for @groupChallenges_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get groupChallenges_status;

  /// No description provided for @groupChallenges_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get groupChallenges_about;

  /// No description provided for @groupChallenges_noMembers.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get groupChallenges_noMembers;

  /// No description provided for @groupChallenges_admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get groupChallenges_admin;

  /// No description provided for @groupChallenges_contributed.
  ///
  /// In en, this message translates to:
  /// **'{points} pts contributed'**
  String groupChallenges_contributed(int points);

  /// No description provided for @groupChallenges_joinedTeam.
  ///
  /// In en, this message translates to:
  /// **'Successfully joined the team!'**
  String get groupChallenges_joinedTeam;

  /// No description provided for @groupChallenges_leaveTeam.
  ///
  /// In en, this message translates to:
  /// **'Leave Team'**
  String get groupChallenges_leaveTeam;

  /// No description provided for @groupChallenges_leaveConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this team? Your contributed points will remain with the team.'**
  String get groupChallenges_leaveConfirmation;

  /// No description provided for @groupChallenges_leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get groupChallenges_leave;

  /// No description provided for @groupChallenges_leftTeam.
  ///
  /// In en, this message translates to:
  /// **'You have left the team'**
  String get groupChallenges_leftTeam;

  /// No description provided for @groupChallenges_challengeDetails.
  ///
  /// In en, this message translates to:
  /// **'Challenge Details'**
  String get groupChallenges_challengeDetails;

  /// No description provided for @groupChallenges_challengeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Challenge not found'**
  String get groupChallenges_challengeNotFound;

  /// No description provided for @groupChallenges_target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get groupChallenges_target;

  /// No description provided for @groupChallenges_starts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get groupChallenges_starts;

  /// No description provided for @groupChallenges_ends.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get groupChallenges_ends;

  /// No description provided for @groupChallenges_hdTypes.
  ///
  /// In en, this message translates to:
  /// **'HD Types'**
  String get groupChallenges_hdTypes;

  /// No description provided for @groupChallenges_noTeamsToEnroll.
  ///
  /// In en, this message translates to:
  /// **'No Teams to Enroll'**
  String get groupChallenges_noTeamsToEnroll;

  /// No description provided for @groupChallenges_createTeamToJoin.
  ///
  /// In en, this message translates to:
  /// **'Create a team first to enroll in challenges'**
  String get groupChallenges_createTeamToJoin;

  /// No description provided for @groupChallenges_enrollTeam.
  ///
  /// In en, this message translates to:
  /// **'Enroll a Team'**
  String get groupChallenges_enrollTeam;

  /// No description provided for @groupChallenges_enrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get groupChallenges_enrolled;

  /// No description provided for @groupChallenges_enroll.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get groupChallenges_enroll;

  /// No description provided for @groupChallenges_teamEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Team enrolled successfully!'**
  String get groupChallenges_teamEnrolled;

  /// No description provided for @groupChallenges_noTeamsEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No teams enrolled yet'**
  String get groupChallenges_noTeamsEnrolled;

  /// No description provided for @circles_title.
  ///
  /// In en, this message translates to:
  /// **'Compatibility Circles'**
  String get circles_title;

  /// No description provided for @circles_myCircles.
  ///
  /// In en, this message translates to:
  /// **'My Circles'**
  String get circles_myCircles;

  /// No description provided for @circles_invitations.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get circles_invitations;

  /// No description provided for @circles_create.
  ///
  /// In en, this message translates to:
  /// **'Create Circle'**
  String get circles_create;

  /// No description provided for @circles_selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select an icon'**
  String get circles_selectIcon;

  /// No description provided for @circles_name.
  ///
  /// In en, this message translates to:
  /// **'Circle Name'**
  String get circles_name;

  /// No description provided for @circles_nameHint.
  ///
  /// In en, this message translates to:
  /// **'Family, Team, Friends...'**
  String get circles_nameHint;

  /// No description provided for @circles_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get circles_description;

  /// No description provided for @circles_descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is this circle for?'**
  String get circles_descriptionHint;

  /// No description provided for @circles_created.
  ///
  /// In en, this message translates to:
  /// **'Circle created successfully!'**
  String get circles_created;

  /// No description provided for @circles_noCircles.
  ///
  /// In en, this message translates to:
  /// **'No Circles Yet'**
  String get circles_noCircles;

  /// No description provided for @circles_noCirclesDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a circle to analyze compatibility with friends, family, or team members.'**
  String get circles_noCirclesDescription;

  /// No description provided for @circles_suggestions.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get circles_suggestions;

  /// No description provided for @circles_memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String circles_memberCount(int count);

  /// No description provided for @circles_private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get circles_private;

  /// No description provided for @circles_noInvitations.
  ///
  /// In en, this message translates to:
  /// **'No Invitations'**
  String get circles_noInvitations;

  /// No description provided for @circles_noInvitationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Circle invitations you receive will appear here.'**
  String get circles_noInvitationsDescription;

  /// No description provided for @circles_invitedBy.
  ///
  /// In en, this message translates to:
  /// **'Invited by {name}'**
  String circles_invitedBy(String name);

  /// No description provided for @circles_decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get circles_decline;

  /// No description provided for @circles_accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get circles_accept;

  /// No description provided for @circles_invitationDeclined.
  ///
  /// In en, this message translates to:
  /// **'Invitation declined'**
  String get circles_invitationDeclined;

  /// No description provided for @circles_invitationAccepted.
  ///
  /// In en, this message translates to:
  /// **'You\'ve joined the circle!'**
  String get circles_invitationAccepted;

  /// No description provided for @circles_notFound.
  ///
  /// In en, this message translates to:
  /// **'Circle not found'**
  String get circles_notFound;

  /// No description provided for @circles_invite.
  ///
  /// In en, this message translates to:
  /// **'Invite Member'**
  String get circles_invite;

  /// No description provided for @circles_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get circles_members;

  /// No description provided for @circles_analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get circles_analysis;

  /// No description provided for @circles_feed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get circles_feed;

  /// No description provided for @circles_inviteMember.
  ///
  /// In en, this message translates to:
  /// **'Invite Member'**
  String get circles_inviteMember;

  /// No description provided for @circles_sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get circles_sendInvite;

  /// No description provided for @circles_invitationSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent!'**
  String get circles_invitationSent;

  /// No description provided for @circles_invitationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send invitation'**
  String get circles_invitationFailed;

  /// No description provided for @circles_deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Circle'**
  String get circles_deleteTitle;

  /// No description provided for @circles_deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String circles_deleteConfirmation(String name);

  /// No description provided for @circles_deleted.
  ///
  /// In en, this message translates to:
  /// **'Circle deleted'**
  String get circles_deleted;

  /// No description provided for @circles_noMembers.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get circles_noMembers;

  /// No description provided for @circles_noAnalysis.
  ///
  /// In en, this message translates to:
  /// **'No Analysis Yet'**
  String get circles_noAnalysis;

  /// No description provided for @circles_runAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Run a compatibility analysis to see how your circle members interact.'**
  String get circles_runAnalysis;

  /// No description provided for @circles_needMoreMembers.
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 members to run an analysis.'**
  String get circles_needMoreMembers;

  /// No description provided for @circles_analyzeCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Analyze Compatibility'**
  String get circles_analyzeCompatibility;

  /// No description provided for @circles_harmonyScore.
  ///
  /// In en, this message translates to:
  /// **'Harmony Score'**
  String get circles_harmonyScore;

  /// No description provided for @circles_typeDistribution.
  ///
  /// In en, this message translates to:
  /// **'Type Distribution'**
  String get circles_typeDistribution;

  /// No description provided for @circles_electromagneticConnections.
  ///
  /// In en, this message translates to:
  /// **'Electromagnetic Connections'**
  String get circles_electromagneticConnections;

  /// No description provided for @circles_electromagneticDesc.
  ///
  /// In en, this message translates to:
  /// **'Intense attraction - you complete each other'**
  String get circles_electromagneticDesc;

  /// No description provided for @circles_companionshipConnections.
  ///
  /// In en, this message translates to:
  /// **'Companionship Connections'**
  String get circles_companionshipConnections;

  /// No description provided for @circles_companionshipDesc.
  ///
  /// In en, this message translates to:
  /// **'Comfort and stability - shared understanding'**
  String get circles_companionshipDesc;

  /// No description provided for @circles_groupStrengths.
  ///
  /// In en, this message translates to:
  /// **'Group Strengths'**
  String get circles_groupStrengths;

  /// No description provided for @circles_areasForGrowth.
  ///
  /// In en, this message translates to:
  /// **'Areas for Growth'**
  String get circles_areasForGrowth;

  /// No description provided for @circles_writePost.
  ///
  /// In en, this message translates to:
  /// **'Share something with your circle...'**
  String get circles_writePost;

  /// No description provided for @circles_noPosts.
  ///
  /// In en, this message translates to:
  /// **'No Posts Yet'**
  String get circles_noPosts;

  /// No description provided for @circles_beFirstToPost.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share something with your circle!'**
  String get circles_beFirstToPost;

  /// No description provided for @experts_title.
  ///
  /// In en, this message translates to:
  /// **'HD Experts'**
  String get experts_title;

  /// No description provided for @experts_becomeExpert.
  ///
  /// In en, this message translates to:
  /// **'Become an Expert'**
  String get experts_becomeExpert;

  /// No description provided for @experts_filterBySpecialization.
  ///
  /// In en, this message translates to:
  /// **'Filter by Specialization'**
  String get experts_filterBySpecialization;

  /// No description provided for @experts_allExperts.
  ///
  /// In en, this message translates to:
  /// **'All Experts'**
  String get experts_allExperts;

  /// No description provided for @experts_experts.
  ///
  /// In en, this message translates to:
  /// **'Experts'**
  String get experts_experts;

  /// No description provided for @experts_noExperts.
  ///
  /// In en, this message translates to:
  /// **'No experts found'**
  String get experts_noExperts;

  /// No description provided for @experts_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured Experts'**
  String get experts_featured;

  /// No description provided for @experts_followers.
  ///
  /// In en, this message translates to:
  /// **'{count} followers'**
  String experts_followers(int count);

  /// No description provided for @experts_notFound.
  ///
  /// In en, this message translates to:
  /// **'Expert not found'**
  String get experts_notFound;

  /// No description provided for @experts_following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get experts_following;

  /// No description provided for @experts_follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get experts_follow;

  /// No description provided for @experts_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get experts_about;

  /// No description provided for @experts_specializations.
  ///
  /// In en, this message translates to:
  /// **'Specializations'**
  String get experts_specializations;

  /// No description provided for @experts_credentials.
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get experts_credentials;

  /// No description provided for @experts_reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get experts_reviews;

  /// No description provided for @experts_writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get experts_writeReview;

  /// No description provided for @experts_reviewContent.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get experts_reviewContent;

  /// No description provided for @experts_reviewHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience working with this expert...'**
  String get experts_reviewHint;

  /// No description provided for @experts_submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get experts_submitReview;

  /// No description provided for @experts_reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully!'**
  String get experts_reviewSubmitted;

  /// No description provided for @experts_noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get experts_noReviews;

  /// No description provided for @experts_followersLabel.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get experts_followersLabel;

  /// No description provided for @experts_rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get experts_rating;

  /// No description provided for @experts_years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get experts_years;

  /// No description provided for @learningPaths_title.
  ///
  /// In en, this message translates to:
  /// **'Learning Paths'**
  String get learningPaths_title;

  /// No description provided for @learningPaths_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get learningPaths_explore;

  /// No description provided for @learningPaths_inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get learningPaths_inProgress;

  /// No description provided for @learningPaths_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learningPaths_completed;

  /// No description provided for @learningPaths_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured Paths'**
  String get learningPaths_featured;

  /// No description provided for @learningPaths_allPaths.
  ///
  /// In en, this message translates to:
  /// **'All Paths'**
  String get learningPaths_allPaths;

  /// No description provided for @learningPaths_noPathsExplore.
  ///
  /// In en, this message translates to:
  /// **'No learning paths available'**
  String get learningPaths_noPathsExplore;

  /// No description provided for @learningPaths_noPathsInProgress.
  ///
  /// In en, this message translates to:
  /// **'No Paths In Progress'**
  String get learningPaths_noPathsInProgress;

  /// No description provided for @learningPaths_noPathsInProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'Enroll in a learning path to start your journey!'**
  String get learningPaths_noPathsInProgressDescription;

  /// No description provided for @learningPaths_browsePaths.
  ///
  /// In en, this message translates to:
  /// **'Browse Paths'**
  String get learningPaths_browsePaths;

  /// No description provided for @learningPaths_noPathsCompleted.
  ///
  /// In en, this message translates to:
  /// **'No Completed Paths'**
  String get learningPaths_noPathsCompleted;

  /// No description provided for @learningPaths_noPathsCompletedDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete learning paths to see them here!'**
  String get learningPaths_noPathsCompletedDescription;

  /// No description provided for @learningPaths_enrolled.
  ///
  /// In en, this message translates to:
  /// **'{count} enrolled'**
  String learningPaths_enrolled(int count);

  /// No description provided for @learningPaths_stepsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String learningPaths_stepsCount(int count);

  /// No description provided for @learningPaths_progress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} steps'**
  String learningPaths_progress(int completed, int total);

  /// No description provided for @learningPaths_resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get learningPaths_resume;

  /// No description provided for @learningPaths_completedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date}'**
  String learningPaths_completedOn(String date);

  /// No description provided for @learningPathNotFound.
  ///
  /// In en, this message translates to:
  /// **'Learning path not found'**
  String get learningPathNotFound;

  /// No description provided for @learningPathMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String learningPathMinutes(int minutes);

  /// No description provided for @learningPathSteps.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String learningPathSteps(int count);

  /// No description provided for @learningPathBy.
  ///
  /// In en, this message translates to:
  /// **'By {author}'**
  String learningPathBy(String author);

  /// No description provided for @learningPathEnrolled.
  ///
  /// In en, this message translates to:
  /// **'{count} enrolled'**
  String learningPathEnrolled(int count);

  /// No description provided for @learningPathCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} completed'**
  String learningPathCompleted(int count);

  /// No description provided for @learningPathEnroll.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get learningPathEnroll;

  /// No description provided for @learningPathYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get learningPathYourProgress;

  /// No description provided for @learningPathCompletedBadge.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learningPathCompletedBadge;

  /// No description provided for @learningPathProgressText.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} steps completed'**
  String learningPathProgressText(int completed, int total);

  /// No description provided for @learningPathStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Steps'**
  String get learningPathStepsTitle;

  /// No description provided for @learningPathEnrollTitle.
  ///
  /// In en, this message translates to:
  /// **'Start This Path?'**
  String get learningPathEnrollTitle;

  /// No description provided for @learningPathEnrollMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be enrolled in \"{title}\" and can track your progress as you complete each step.'**
  String learningPathEnrollMessage(String title);

  /// No description provided for @learningPathViewContent.
  ///
  /// In en, this message translates to:
  /// **'View Content'**
  String get learningPathViewContent;

  /// No description provided for @learningPathMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get learningPathMarkComplete;

  /// No description provided for @learningPathStepCompleted.
  ///
  /// In en, this message translates to:
  /// **'Step completed!'**
  String get learningPathStepCompleted;

  /// No description provided for @thought_title.
  ///
  /// In en, this message translates to:
  /// **'Thoughts'**
  String get thought_title;

  /// No description provided for @thought_feedTitle.
  ///
  /// In en, this message translates to:
  /// **'Thoughts'**
  String get thought_feedTitle;

  /// No description provided for @thought_createNew.
  ///
  /// In en, this message translates to:
  /// **'Share a Thought'**
  String get thought_createNew;

  /// No description provided for @thought_emptyFeed.
  ///
  /// In en, this message translates to:
  /// **'Your thoughts feed is empty'**
  String get thought_emptyFeed;

  /// No description provided for @thought_emptyFeedMessage.
  ///
  /// In en, this message translates to:
  /// **'Follow people or share a thought to get started'**
  String get thought_emptyFeedMessage;

  /// No description provided for @thought_regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get thought_regenerate;

  /// No description provided for @thought_regeneratedFrom.
  ///
  /// In en, this message translates to:
  /// **'Regenerated from @{username}'**
  String thought_regeneratedFrom(String username);

  /// No description provided for @thought_regenerateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thought regenerated to your wall!'**
  String get thought_regenerateSuccess;

  /// No description provided for @thought_regenerateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Regenerate this thought?'**
  String get thought_regenerateConfirm;

  /// No description provided for @thought_regenerateDescription.
  ///
  /// In en, this message translates to:
  /// **'This will share this thought to your wall, crediting the original author.'**
  String get thought_regenerateDescription;

  /// No description provided for @thought_addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment (optional)'**
  String get thought_addComment;

  /// No description provided for @thought_regenerateCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 regenerate} other{{count} regenerates}}'**
  String thought_regenerateCount(int count);

  /// No description provided for @thought_cannotRegenerateOwn.
  ///
  /// In en, this message translates to:
  /// **'You cannot regenerate your own thought'**
  String get thought_cannotRegenerateOwn;

  /// No description provided for @thought_alreadyRegenerated.
  ///
  /// In en, this message translates to:
  /// **'You have already regenerated this thought'**
  String get thought_alreadyRegenerated;

  /// No description provided for @thought_postDetail.
  ///
  /// In en, this message translates to:
  /// **'Thought'**
  String get thought_postDetail;

  /// No description provided for @thought_noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet. Be the first to comment!'**
  String get thought_noComments;

  /// No description provided for @thought_replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to {username}'**
  String thought_replyingTo(String username);

  /// No description provided for @thought_writeReply.
  ///
  /// In en, this message translates to:
  /// **'Write a reply...'**
  String get thought_writeReply;

  /// No description provided for @thought_commentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get thought_commentPlaceholder;

  /// No description provided for @messages_title.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages_title;

  /// No description provided for @messages_conversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get messages_conversation;

  /// No description provided for @messages_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get messages_loading;

  /// No description provided for @messages_muteNotifications.
  ///
  /// In en, this message translates to:
  /// **'Mute Notifications'**
  String get messages_muteNotifications;

  /// No description provided for @messages_notificationsMuted.
  ///
  /// In en, this message translates to:
  /// **'Notifications muted'**
  String get messages_notificationsMuted;

  /// No description provided for @messages_blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get messages_blockUser;

  /// No description provided for @messages_blockUserConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this user? You will no longer receive messages from them.'**
  String get messages_blockUserConfirm;

  /// No description provided for @messages_userBlocked.
  ///
  /// In en, this message translates to:
  /// **'User blocked'**
  String get messages_userBlocked;

  /// No description provided for @messages_block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get messages_block;

  /// No description provided for @messages_deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get messages_deleteConversation;

  /// No description provided for @messages_deleteConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation? This action cannot be undone.'**
  String get messages_deleteConversationConfirm;

  /// No description provided for @messages_conversationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Conversation deleted'**
  String get messages_conversationDeleted;

  /// No description provided for @messages_startConversation.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation!'**
  String get messages_startConversation;

  /// No description provided for @profile_takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get profile_takePhoto;

  /// No description provided for @profile_chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get profile_chooseFromGallery;

  /// No description provided for @profile_avatarUpdated.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated successfully'**
  String get profile_avatarUpdated;

  /// No description provided for @profile_profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_profileUpdated;

  /// No description provided for @profile_noProfileFound.
  ///
  /// In en, this message translates to:
  /// **'No profile found'**
  String get profile_noProfileFound;

  /// No description provided for @discovery_title.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discovery_title;

  /// No description provided for @discovery_searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get discovery_searchUsers;

  /// No description provided for @discovery_discoverTab.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discovery_discoverTab;

  /// No description provided for @discovery_followingTab.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get discovery_followingTab;

  /// No description provided for @discovery_followersTab.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get discovery_followersTab;

  /// No description provided for @discovery_noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get discovery_noUsersFound;

  /// No description provided for @discovery_tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get discovery_tryAdjustingFilters;

  /// No description provided for @discovery_notFollowingAnyone.
  ///
  /// In en, this message translates to:
  /// **'Not following anyone'**
  String get discovery_notFollowingAnyone;

  /// No description provided for @discovery_discoverPeople.
  ///
  /// In en, this message translates to:
  /// **'Discover people to follow'**
  String get discovery_discoverPeople;

  /// No description provided for @discovery_noFollowersYet.
  ///
  /// In en, this message translates to:
  /// **'No followers yet'**
  String get discovery_noFollowersYet;

  /// No description provided for @discovery_shareInsights.
  ///
  /// In en, this message translates to:
  /// **'Share your insights to gain followers'**
  String get discovery_shareInsights;

  /// No description provided for @discovery_clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get discovery_clearAll;

  /// No description provided for @chart_gate.
  ///
  /// In en, this message translates to:
  /// **'Gate {number}'**
  String chart_gate(int number);

  /// No description provided for @chart_channel.
  ///
  /// In en, this message translates to:
  /// **'Channel {id}'**
  String chart_channel(String id);

  /// No description provided for @chart_center.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get chart_center;

  /// No description provided for @chart_keynote.
  ///
  /// In en, this message translates to:
  /// **'Keynote'**
  String get chart_keynote;

  /// No description provided for @chart_element.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get chart_element;

  /// No description provided for @chart_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get chart_location;

  /// No description provided for @chart_hdCenters.
  ///
  /// In en, this message translates to:
  /// **'HD Centers'**
  String get chart_hdCenters;

  /// No description provided for @reaction_comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get reaction_comment;

  /// No description provided for @reaction_react.
  ///
  /// In en, this message translates to:
  /// **'React'**
  String get reaction_react;

  /// No description provided for @reaction_standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get reaction_standard;

  /// No description provided for @reaction_humanDesign.
  ///
  /// In en, this message translates to:
  /// **'Human Design'**
  String get reaction_humanDesign;

  /// No description provided for @share_shareChart.
  ///
  /// In en, this message translates to:
  /// **'Share Chart'**
  String get share_shareChart;

  /// No description provided for @share_createShareLink.
  ///
  /// In en, this message translates to:
  /// **'Create Share Link'**
  String get share_createShareLink;

  /// No description provided for @share_shareViaUrl.
  ///
  /// In en, this message translates to:
  /// **'Share via URL'**
  String get share_shareViaUrl;

  /// No description provided for @share_exportAsPng.
  ///
  /// In en, this message translates to:
  /// **'Export as PNG'**
  String get share_exportAsPng;

  /// No description provided for @share_fullReport.
  ///
  /// In en, this message translates to:
  /// **'Full report'**
  String get share_fullReport;

  /// No description provided for @share_linkExpiration.
  ///
  /// In en, this message translates to:
  /// **'Link Expiration'**
  String get share_linkExpiration;

  /// No description provided for @share_neverExpires.
  ///
  /// In en, this message translates to:
  /// **'Never expires'**
  String get share_neverExpires;

  /// No description provided for @share_oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get share_oneHour;

  /// No description provided for @share_twentyFourHours.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get share_twentyFourHours;

  /// No description provided for @share_sevenDays.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get share_sevenDays;

  /// No description provided for @share_thirtyDays.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get share_thirtyDays;

  /// No description provided for @share_creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get share_creating;

  /// No description provided for @share_signInToShare.
  ///
  /// In en, this message translates to:
  /// **'Sign in to share your chart'**
  String get share_signInToShare;

  /// No description provided for @share_createShareableLinks.
  ///
  /// In en, this message translates to:
  /// **'Create shareable links to your Human Design chart'**
  String get share_createShareableLinks;

  /// No description provided for @share_linkImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get share_linkImage;

  /// No description provided for @share_pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get share_pdf;

  /// No description provided for @post_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get post_share;

  /// No description provided for @post_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get post_edit;

  /// No description provided for @post_report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get post_report;

  /// No description provided for @mentorship_title.
  ///
  /// In en, this message translates to:
  /// **'Mentorship'**
  String get mentorship_title;

  /// No description provided for @mentorship_pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get mentorship_pendingRequests;

  /// No description provided for @mentorship_availableMentors.
  ///
  /// In en, this message translates to:
  /// **'Available Mentors'**
  String get mentorship_availableMentors;

  /// No description provided for @mentorship_noMentorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No mentors available'**
  String get mentorship_noMentorsAvailable;

  /// No description provided for @mentorship_requestMentorship.
  ///
  /// In en, this message translates to:
  /// **'Request Mentorship from {name}'**
  String mentorship_requestMentorship(String name);

  /// No description provided for @mentorship_sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send a message explaining what you would like to learn:'**
  String get mentorship_sendMessage;

  /// No description provided for @mentorship_learnPrompt.
  ///
  /// In en, this message translates to:
  /// **'I would like to learn more about...'**
  String get mentorship_learnPrompt;

  /// No description provided for @mentorship_requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent!'**
  String get mentorship_requestSent;

  /// No description provided for @mentorship_sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get mentorship_sendRequest;

  /// No description provided for @mentorship_becomeAMentor.
  ///
  /// In en, this message translates to:
  /// **'Become a Mentor'**
  String get mentorship_becomeAMentor;

  /// No description provided for @mentorship_shareKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Share your Human Design knowledge'**
  String get mentorship_shareKnowledge;

  /// No description provided for @story_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get story_cancel;

  /// No description provided for @story_createStory.
  ///
  /// In en, this message translates to:
  /// **'Create Story'**
  String get story_createStory;

  /// No description provided for @story_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get story_share;

  /// No description provided for @story_typeYourStory.
  ///
  /// In en, this message translates to:
  /// **'Type your story...'**
  String get story_typeYourStory;

  /// No description provided for @story_background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get story_background;

  /// No description provided for @story_attachTransitGate.
  ///
  /// In en, this message translates to:
  /// **'Attach Transit Gate (optional)'**
  String get story_attachTransitGate;

  /// No description provided for @story_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get story_none;

  /// No description provided for @story_gateNumber.
  ///
  /// In en, this message translates to:
  /// **'Gate {number}'**
  String story_gateNumber(int number);

  /// No description provided for @story_whoCanSee.
  ///
  /// In en, this message translates to:
  /// **'Who can see this?'**
  String get story_whoCanSee;

  /// No description provided for @story_followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get story_followers;

  /// No description provided for @story_everyone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get story_everyone;

  /// No description provided for @challenges_title.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges_title;

  /// No description provided for @challenges_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get challenges_daily;

  /// No description provided for @challenges_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get challenges_weekly;

  /// No description provided for @challenges_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get challenges_monthly;

  /// No description provided for @challenges_noDailyChallenges.
  ///
  /// In en, this message translates to:
  /// **'No daily challenges available'**
  String get challenges_noDailyChallenges;

  /// No description provided for @challenges_noWeeklyChallenges.
  ///
  /// In en, this message translates to:
  /// **'No weekly challenges available'**
  String get challenges_noWeeklyChallenges;

  /// No description provided for @challenges_noMonthlyChallenges.
  ///
  /// In en, this message translates to:
  /// **'No monthly challenges available'**
  String get challenges_noMonthlyChallenges;

  /// No description provided for @challenges_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading challenges'**
  String get challenges_errorLoading;

  /// No description provided for @challenges_claimedPoints.
  ///
  /// In en, this message translates to:
  /// **'Claimed {points} points!'**
  String challenges_claimedPoints(int points);

  /// No description provided for @challenges_totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get challenges_totalPoints;

  /// No description provided for @challenges_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get challenges_level;

  /// No description provided for @learning_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get learning_all;

  /// No description provided for @learning_types.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get learning_types;

  /// No description provided for @learning_gates.
  ///
  /// In en, this message translates to:
  /// **'Gates'**
  String get learning_gates;

  /// No description provided for @learning_centers.
  ///
  /// In en, this message translates to:
  /// **'Centers'**
  String get learning_centers;

  /// No description provided for @learning_liveSessions.
  ///
  /// In en, this message translates to:
  /// **'Live Sessions'**
  String get learning_liveSessions;

  /// No description provided for @quiz_noActiveSession.
  ///
  /// In en, this message translates to:
  /// **'No active quiz session'**
  String get quiz_noActiveSession;

  /// No description provided for @quiz_noQuestionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No questions available'**
  String get quiz_noQuestionsAvailable;

  /// No description provided for @quiz_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get quiz_ok;

  /// No description provided for @liveSessions_title.
  ///
  /// In en, this message translates to:
  /// **'Live Sessions'**
  String get liveSessions_title;

  /// No description provided for @liveSessions_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get liveSessions_upcoming;

  /// No description provided for @liveSessions_mySessions.
  ///
  /// In en, this message translates to:
  /// **'My Sessions'**
  String get liveSessions_mySessions;

  /// No description provided for @liveSessions_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading sessions'**
  String get liveSessions_errorLoading;

  /// No description provided for @liveSessions_registeredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully!'**
  String get liveSessions_registeredSuccessfully;

  /// No description provided for @liveSessions_cancelRegistration.
  ///
  /// In en, this message translates to:
  /// **'Cancel Registration'**
  String get liveSessions_cancelRegistration;

  /// No description provided for @liveSessions_cancelRegistrationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your registration?'**
  String get liveSessions_cancelRegistrationConfirm;

  /// No description provided for @liveSessions_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get liveSessions_no;

  /// No description provided for @liveSessions_yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get liveSessions_yesCancel;

  /// No description provided for @liveSessions_registrationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Registration cancelled'**
  String get liveSessions_registrationCancelled;

  /// No description provided for @gateChannelPicker_gates.
  ///
  /// In en, this message translates to:
  /// **'Gates (64)'**
  String get gateChannelPicker_gates;

  /// No description provided for @gateChannelPicker_channels.
  ///
  /// In en, this message translates to:
  /// **'Channels (36)'**
  String get gateChannelPicker_channels;

  /// No description provided for @gateChannelPicker_search.
  ///
  /// In en, this message translates to:
  /// **'Search gates or channels...'**
  String get gateChannelPicker_search;

  /// No description provided for @leaderboard_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get leaderboard_weekly;

  /// No description provided for @leaderboard_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get leaderboard_monthly;

  /// No description provided for @leaderboard_allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get leaderboard_allTime;

  /// No description provided for @ai_chatTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get ai_chatTitle;

  /// No description provided for @ai_askAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get ai_askAi;

  /// No description provided for @ai_askAboutChart.
  ///
  /// In en, this message translates to:
  /// **'Ask AI About Your Chart'**
  String get ai_askAboutChart;

  /// No description provided for @ai_miniDescription.
  ///
  /// In en, this message translates to:
  /// **'Get personalized insights about your Human Design'**
  String get ai_miniDescription;

  /// No description provided for @ai_welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your HD Assistant'**
  String get ai_welcomeTitle;

  /// No description provided for @ai_welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your Human Design chart. I can explain your type, strategy, authority, gates, channels, and more.'**
  String get ai_welcomeSubtitle;

  /// No description provided for @ai_inputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ask about your chart...'**
  String get ai_inputPlaceholder;

  /// No description provided for @ai_newConversation.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get ai_newConversation;

  /// No description provided for @ai_conversations.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get ai_conversations;

  /// No description provided for @ai_noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get ai_noConversations;

  /// No description provided for @ai_noConversationsMessage.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with the AI to get personalized chart insights.'**
  String get ai_noConversationsMessage;

  /// No description provided for @ai_deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get ai_deleteConversation;

  /// No description provided for @ai_deleteConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation?'**
  String get ai_deleteConversationConfirm;

  /// No description provided for @ai_messagesExhausted.
  ///
  /// In en, this message translates to:
  /// **'Free Messages Used Up'**
  String get ai_messagesExhausted;

  /// No description provided for @ai_upgradeForUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium for unlimited AI conversations about your Human Design chart.'**
  String get ai_upgradeForUnlimited;

  /// No description provided for @ai_usageCount.
  ///
  /// In en, this message translates to:
  /// **'{used} of {limit} free messages used'**
  String ai_usageCount(int used, int limit);

  /// No description provided for @ai_errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get ai_errorGeneric;

  /// No description provided for @ai_errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the AI service. Check your connection.'**
  String get ai_errorNetwork;

  /// No description provided for @events_title.
  ///
  /// In en, this message translates to:
  /// **'Community Events'**
  String get events_title;

  /// No description provided for @events_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get events_upcoming;

  /// No description provided for @events_past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get events_past;

  /// No description provided for @events_create.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get events_create;

  /// No description provided for @events_noUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get events_noUpcoming;

  /// No description provided for @events_noUpcomingMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an event to connect with the HD community!'**
  String get events_noUpcomingMessage;

  /// No description provided for @events_online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get events_online;

  /// No description provided for @events_inPerson.
  ///
  /// In en, this message translates to:
  /// **'In Person'**
  String get events_inPerson;

  /// No description provided for @events_hybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get events_hybrid;

  /// No description provided for @events_participants.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 participant} other{{count} participants}}'**
  String events_participants(int count);

  /// No description provided for @events_register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get events_register;

  /// No description provided for @events_registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get events_registered;

  /// No description provided for @events_cancelRegistration.
  ///
  /// In en, this message translates to:
  /// **'Cancel Registration'**
  String get events_cancelRegistration;

  /// No description provided for @events_registrationFull.
  ///
  /// In en, this message translates to:
  /// **'Event Full'**
  String get events_registrationFull;

  /// No description provided for @events_eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Title'**
  String get events_eventTitle;

  /// No description provided for @events_eventDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get events_eventDescription;

  /// No description provided for @events_eventType.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get events_eventType;

  /// No description provided for @events_startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date & Time'**
  String get events_startDate;

  /// No description provided for @events_endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date & Time'**
  String get events_endDate;

  /// No description provided for @events_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get events_location;

  /// No description provided for @events_virtualLink.
  ///
  /// In en, this message translates to:
  /// **'Virtual Meeting Link'**
  String get events_virtualLink;

  /// No description provided for @events_maxParticipants.
  ///
  /// In en, this message translates to:
  /// **'Max Participants'**
  String get events_maxParticipants;

  /// No description provided for @events_hdTypeFilter.
  ///
  /// In en, this message translates to:
  /// **'HD Type Filter'**
  String get events_hdTypeFilter;

  /// No description provided for @events_allTypes.
  ///
  /// In en, this message translates to:
  /// **'Open to All Types'**
  String get events_allTypes;

  /// No description provided for @events_created.
  ///
  /// In en, this message translates to:
  /// **'Event created!'**
  String get events_created;

  /// No description provided for @events_deleted.
  ///
  /// In en, this message translates to:
  /// **'Event deleted'**
  String get events_deleted;

  /// No description provided for @events_notFound.
  ///
  /// In en, this message translates to:
  /// **'Event not found'**
  String get events_notFound;

  /// No description provided for @chartOfDay_title.
  ///
  /// In en, this message translates to:
  /// **'Chart of the Day'**
  String get chartOfDay_title;

  /// No description provided for @chartOfDay_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured Chart'**
  String get chartOfDay_featured;

  /// No description provided for @chartOfDay_viewChart.
  ///
  /// In en, this message translates to:
  /// **'View Chart'**
  String get chartOfDay_viewChart;

  /// No description provided for @discussion_typeDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Type Discussion'**
  String get discussion_typeDiscussion;

  /// No description provided for @discussion_channelDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Channel Discussion'**
  String get discussion_channelDiscussion;
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
