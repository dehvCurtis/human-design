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
  /// **'Today'**
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

  /// No description provided for @social_sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get social_sendRequest;

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

  /// No description provided for @social_shared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get social_shared;

  /// No description provided for @social_noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No Friends Yet'**
  String get social_noFriendsYet;

  /// No description provided for @social_noFriendsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add friends to compare charts and see how you connect.'**
  String get social_noFriendsMessage;

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
  /// **'Charts that friends share with you will appear here.'**
  String get social_noSharedChartsMessage;

  /// No description provided for @social_pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get social_pendingRequests;

  /// No description provided for @social_friendRequests.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get social_friendRequests;

  /// No description provided for @social_noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get social_noPendingRequests;

  /// No description provided for @social_addFriendPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your friend\'s email address to send a request.'**
  String get social_addFriendPrompt;

  /// No description provided for @social_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get social_emailLabel;

  /// No description provided for @social_emailHint.
  ///
  /// In en, this message translates to:
  /// **'friend@example.com'**
  String get social_emailHint;

  /// No description provided for @social_userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with that email'**
  String get social_userNotFound;

  /// No description provided for @social_requestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent to {name}!'**
  String social_requestSent(String name);

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

  /// No description provided for @social_friendsSince.
  ///
  /// In en, this message translates to:
  /// **'Friends since {date}'**
  String social_friendsSince(String date);

  /// No description provided for @social_compareCharts.
  ///
  /// In en, this message translates to:
  /// **'Compare Charts'**
  String get social_compareCharts;

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

  /// No description provided for @social_loadFriendsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load friends'**
  String get social_loadFriendsFailed;

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

  /// No description provided for @social_sentAgo.
  ///
  /// In en, this message translates to:
  /// **'Sent {time}'**
  String social_sentAgo(String time);

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
