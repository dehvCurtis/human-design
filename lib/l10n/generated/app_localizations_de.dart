// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'AuraMap';

  @override
  String get common_save => 'Speichern';

  @override
  String get common_cancel => 'Abbrechen';

  @override
  String get common_delete => 'Löschen';

  @override
  String get common_edit => 'Bearbeiten';

  @override
  String get common_done => 'Fertig';

  @override
  String get common_next => 'Weiter';

  @override
  String get common_back => 'Zurück';

  @override
  String get common_skip => 'Überspringen';

  @override
  String get common_continue => 'Fortfahren';

  @override
  String get common_loading => 'Lädt...';

  @override
  String get common_error => 'Fehler';

  @override
  String get common_retry => 'Erneut versuchen';

  @override
  String get common_close => 'Schließen';

  @override
  String get common_search => 'Suchen';

  @override
  String get common_share => 'Teilen';

  @override
  String get common_settings => 'Einstellungen';

  @override
  String get common_logout => 'Abmelden';

  @override
  String get common_profile => 'Profil';

  @override
  String get common_type => 'Typ';

  @override
  String get common_strategy => 'Strategie';

  @override
  String get common_authority => 'Autorität';

  @override
  String get common_definition => 'Definition';

  @override
  String get common_create => 'Erstellen';

  @override
  String get common_viewFull => 'Vollständig anzeigen';

  @override
  String get common_send => 'Senden';

  @override
  String get common_like => 'Gefällt mir';

  @override
  String get common_reply => 'Antworten';

  @override
  String get common_deleteConfirmation =>
      'Sind Sie sicher, dass Sie dies löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get common_comingSoon => 'Demnächst verfügbar!';

  @override
  String get nav_home => 'Start';

  @override
  String get nav_chart => 'Chart';

  @override
  String get nav_today => 'Täglich';

  @override
  String get nav_social => 'Sozial';

  @override
  String get nav_profile => 'Profil';

  @override
  String get nav_ai => 'KI';

  @override
  String get nav_more => 'Mehr';

  @override
  String get nav_learn => 'Lernen';

  @override
  String get affirmation_savedSuccess => 'Affirmation gespeichert!';

  @override
  String get affirmation_alreadySaved => 'Affirmation bereits gespeichert';

  @override
  String get home_goodMorning => 'Guten Morgen';

  @override
  String get home_goodAfternoon => 'Guten Tag';

  @override
  String get home_goodEvening => 'Guten Abend';

  @override
  String get home_yourDesign => 'Ihr Design';

  @override
  String get home_completeProfile => 'Vervollständigen Sie Ihr Profil';

  @override
  String get home_enterBirthData => 'Geburtsdaten eingeben';

  @override
  String get home_myChart => 'Mein Chart';

  @override
  String get home_savedCharts => 'Gespeichert';

  @override
  String get home_composite => 'Komposit';

  @override
  String get home_penta => 'Penta';

  @override
  String get home_friends => 'Freunde';

  @override
  String get home_myBodygraph => 'Mein Bodygraph';

  @override
  String get home_definedCenters => 'Definierte Zentren';

  @override
  String get home_activeChannels => 'Aktive Kanäle';

  @override
  String get home_activeGates => 'Aktive Tore';

  @override
  String get transit_today => 'Heutige Transite';

  @override
  String get transit_sun => 'Sonne';

  @override
  String get transit_earth => 'Erde';

  @override
  String get transit_moon => 'Mond';

  @override
  String transit_gate(int number) {
    return 'Tor $number';
  }

  @override
  String transit_newChannelsActivated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neue Kanäle aktiviert',
      one: '1 neuer Kanal aktiviert',
    );
    return '$_temp0';
  }

  @override
  String transit_gatesHighlighted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tore hervorgehoben',
      one: '1 Tor hervorgehoben',
    );
    return '$_temp0';
  }

  @override
  String get transit_noConnections =>
      'Heute keine direkten Transitverbindungen';

  @override
  String get auth_signIn => 'Anmelden';

  @override
  String get auth_signUp => 'Registrieren';

  @override
  String get auth_signInWithApple => 'Mit Apple anmelden';

  @override
  String get auth_signInWithGoogle => 'Mit Google anmelden';

  @override
  String get auth_signInWithEmail => 'Mit E-Mail anmelden';

  @override
  String get auth_email => 'E-Mail';

  @override
  String get auth_password => 'Passwort';

  @override
  String get auth_confirmPassword => 'Passwort bestätigen';

  @override
  String get auth_forgotPassword => 'Passwort vergessen?';

  @override
  String get auth_noAccount => 'Noch kein Konto?';

  @override
  String get auth_hasAccount => 'Bereits ein Konto?';

  @override
  String get auth_termsAgree =>
      'Mit der Registrierung stimmen Sie unseren Nutzungsbedingungen und Datenschutzrichtlinien zu';

  @override
  String get auth_welcomeBack => 'Willkommen zurück';

  @override
  String get auth_signInSubtitle =>
      'Melden Sie sich an, um Ihre Human Design Reise fortzusetzen';

  @override
  String get auth_signInRequired => 'Anmeldung erforderlich';

  @override
  String get auth_signInToCalculateChart =>
      'Bitte melden Sie sich an, um Ihr Human Design Chart zu berechnen und zu speichern.';

  @override
  String get auth_signInToCreateStory =>
      'Bitte melden Sie sich an, um Storys mit der Community zu teilen.';

  @override
  String get auth_signUpSubtitle =>
      'Beginnen Sie heute Ihre Human Design Reise';

  @override
  String get auth_signUpWithApple => 'Mit Apple registrieren';

  @override
  String get auth_signUpWithGoogle => 'Mit Google registrieren';

  @override
  String get auth_enterName => 'Geben Sie Ihren Namen ein';

  @override
  String get auth_nameRequired => 'Name ist erforderlich';

  @override
  String get auth_termsOfService => 'Nutzungsbedingungen';

  @override
  String get auth_privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get auth_acceptTerms =>
      'Bitte akzeptieren Sie die Nutzungsbedingungen, um fortzufahren';

  @override
  String get auth_resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get auth_resetPasswordPrompt =>
      'Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen Link zum Zurücksetzen Ihres Passworts.';

  @override
  String get auth_enterEmail => 'Geben Sie Ihre E-Mail ein';

  @override
  String get auth_resetEmailSent =>
      'E-Mail zum Zurücksetzen des Passworts gesendet!';

  @override
  String get auth_name => 'Name';

  @override
  String get auth_createAccount => 'Konto erstellen';

  @override
  String get auth_iAgreeTo => 'Ich stimme zu ';

  @override
  String get auth_and => ' und ';

  @override
  String get auth_birthInformation => 'Geburtsinformationen';

  @override
  String get auth_calculateMyChart => 'Mein Chart berechnen';

  @override
  String get onboarding_welcome => 'Willkommen bei AuraMap';

  @override
  String get onboarding_welcomeSubtitle =>
      'Entdecken Sie Ihre einzigartige energetische Blaupause';

  @override
  String get onboarding_birthData => 'Geben Sie Ihre Geburtsdaten ein';

  @override
  String get onboarding_birthDataSubtitle =>
      'Wir benötigen diese, um Ihr Chart zu berechnen';

  @override
  String get onboarding_birthDate => 'Geburtsdatum';

  @override
  String get onboarding_birthTime => 'Geburtszeit';

  @override
  String get onboarding_birthLocation => 'Geburtsort';

  @override
  String get onboarding_searchLocation => 'Nach einer Stadt suchen...';

  @override
  String get onboarding_unknownTime => 'Ich kenne meine Geburtszeit nicht';

  @override
  String get onboarding_timeImportance =>
      'Die genaue Geburtszeit ist wichtig für ein präzises Chart';

  @override
  String get onboarding_birthDataExplanation =>
      'Ihre Geburtsdaten werden verwendet, um Ihr einzigartiges Human Design Chart zu berechnen. Je genauer die Informationen, desto präziser Ihr Chart.';

  @override
  String get onboarding_noTimeWarning =>
      'Ohne genaue Geburtszeit können einige Chart-Details (wie Ihr Aszendent und genaue Tor-Linien) möglicherweise nicht präzise sein. Wir verwenden standardmäßig Mittag.';

  @override
  String get onboarding_enterBirthTimeInstead =>
      'Stattdessen Geburtszeit eingeben';

  @override
  String get onboarding_birthDataPrivacy =>
      'Ihre Geburtsdaten werden verschlüsselt und sicher gespeichert. Sie können sie jederzeit in Ihren Profileinstellungen aktualisieren oder löschen.';

  @override
  String get onboarding_saveFailed =>
      'Speichern der Geburtsdaten fehlgeschlagen';

  @override
  String get onboarding_fillAllFields =>
      'Bitte füllen Sie alle erforderlichen Felder aus';

  @override
  String get onboarding_selectLanguage => 'Sprache auswählen';

  @override
  String get onboarding_getStarted => 'Loslegen';

  @override
  String get onboarding_alreadyHaveAccount => 'Ich habe bereits ein Konto';

  @override
  String get onboarding_liveInAlignment =>
      'Entdecken Sie Ihre einzigartige energetische Blaupause und leben Sie im Einklang mit Ihrer wahren Natur.';

  @override
  String get chart_myChart => 'Mein Chart';

  @override
  String get chart_viewChart => 'Chart anzeigen';

  @override
  String get chart_calculate => 'Chart berechnen';

  @override
  String get chart_recalculate => 'Neu berechnen';

  @override
  String get chart_share => 'Chart teilen';

  @override
  String get chart_createChart => 'Chart erstellen';

  @override
  String get chart_composite => 'Komposit-Chart';

  @override
  String get chart_transit => 'Heutige Transite';

  @override
  String get chart_bodygraph => 'Bodygraph';

  @override
  String get chart_planets => 'Planeten';

  @override
  String get chart_details => 'Chart-Details';

  @override
  String get chart_properties => 'Eigenschaften';

  @override
  String get chart_gates => 'Tore';

  @override
  String get chart_channels => 'Kanäle';

  @override
  String get chart_noChartYet => 'Noch kein Chart';

  @override
  String get chart_addBirthDataPrompt =>
      'Fügen Sie Ihre Geburtsdaten hinzu, um Ihr einzigartiges Human Design Chart zu erstellen.';

  @override
  String get chart_addBirthData => 'Geburtsdaten hinzufügen';

  @override
  String get chart_noActiveChannels => 'Keine aktiven Kanäle';

  @override
  String get chart_channelsFormedBothGates =>
      'Kanäle werden gebildet, wenn beide Tore definiert sind.';

  @override
  String get chart_savedCharts => 'Gespeicherte Charts';

  @override
  String get chart_addChart => 'Chart hinzufügen';

  @override
  String get chart_noSavedCharts => 'Keine gespeicherten Charts';

  @override
  String get chart_noSavedChartsMessage =>
      'Erstellen Sie Charts für sich selbst und andere, um sie hier zu speichern.';

  @override
  String get chart_loadFailed => 'Laden der Charts fehlgeschlagen';

  @override
  String get chart_renameChart => 'Chart umbenennen';

  @override
  String get chart_rename => 'Umbenennen';

  @override
  String get chart_renameFailed => 'Umbenennen des Charts fehlgeschlagen';

  @override
  String get chart_deleteChart => 'Chart löschen';

  @override
  String chart_deleteConfirm(String name) {
    return 'Sind Sie sicher, dass Sie \"$name\" löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get chart_deleteFailed => 'Löschen des Charts fehlgeschlagen';

  @override
  String get chart_you => 'Sie';

  @override
  String get chart_personName => 'Name';

  @override
  String get chart_enterPersonName => 'Namen der Person eingeben';

  @override
  String get chart_addChartDescription =>
      'Erstellen Sie ein Chart für jemand anderen, indem Sie dessen Geburtsinformationen eingeben.';

  @override
  String get chart_calculateAndSave => 'Berechnen & Chart speichern';

  @override
  String get chart_saved => 'Chart erfolgreich gespeichert';

  @override
  String get chart_consciousGates => 'Bewusste Tore';

  @override
  String get chart_unconsciousGates => 'Unbewusste Tore';

  @override
  String get chart_personalitySide =>
      'Persönlichkeitsseite - was Sie bewusst wahrnehmen';

  @override
  String get chart_designSide => 'Designseite - was andere in Ihnen sehen';

  @override
  String get type_manifestor => 'Manifestor';

  @override
  String get type_generator => 'Generator';

  @override
  String get type_manifestingGenerator => 'Manifestierender Generator';

  @override
  String get type_projector => 'Projektor';

  @override
  String get type_reflector => 'Reflektor';

  @override
  String get type_manifestor_strategy => 'Informieren';

  @override
  String get type_generator_strategy => 'Reagieren';

  @override
  String get type_manifestingGenerator_strategy => 'Reagieren';

  @override
  String get type_projector_strategy => 'Auf Einladung warten';

  @override
  String get type_reflector_strategy => 'Einen Mondzyklus warten';

  @override
  String get authority_emotional => 'Emotional';

  @override
  String get authority_sacral => 'Sakral';

  @override
  String get authority_splenic => 'Milz';

  @override
  String get authority_ego => 'Ego/Herz';

  @override
  String get authority_self => 'Selbst-Projiziert';

  @override
  String get authority_environment => 'Mental/Umgebung';

  @override
  String get authority_lunar => 'Lunar';

  @override
  String get definition_none => 'Keine Definition';

  @override
  String get definition_single => 'Einfache Definition';

  @override
  String get definition_split => 'Geteilte Definition';

  @override
  String get definition_tripleSplit => 'Dreifach-Teilung';

  @override
  String get definition_quadrupleSplit => 'Vierfach-Teilung';

  @override
  String get profile_1_3 => '1/3 Forscher/Märtyrer';

  @override
  String get profile_1_4 => '1/4 Forscher/Opportunist';

  @override
  String get profile_2_4 => '2/4 Eremit/Opportunist';

  @override
  String get profile_2_5 => '2/5 Eremit/Ketzer';

  @override
  String get profile_3_5 => '3/5 Märtyrer/Ketzer';

  @override
  String get profile_3_6 => '3/6 Märtyrer/Rollenvorbild';

  @override
  String get profile_4_6 => '4/6 Opportunist/Rollenvorbild';

  @override
  String get profile_4_1 => '4/1 Opportunist/Forscher';

  @override
  String get profile_5_1 => '5/1 Ketzer/Forscher';

  @override
  String get profile_5_2 => '5/2 Ketzer/Eremit';

  @override
  String get profile_6_2 => '6/2 Rollenvorbild/Eremit';

  @override
  String get profile_6_3 => '6/3 Rollenvorbild/Märtyrer';

  @override
  String get center_head => 'Kopf';

  @override
  String get center_ajna => 'Ajna';

  @override
  String get center_throat => 'Kehle';

  @override
  String get center_g => 'G/Selbst';

  @override
  String get center_heart => 'Herz/Ego';

  @override
  String get center_sacral => 'Sakral';

  @override
  String get center_solarPlexus => 'Solarplexus';

  @override
  String get center_spleen => 'Milz';

  @override
  String get center_root => 'Wurzel';

  @override
  String get center_defined => 'Definiert';

  @override
  String get center_undefined => 'Undefiniert';

  @override
  String get section_type => 'Typ';

  @override
  String get section_strategy => 'Strategie';

  @override
  String get section_authority => 'Autorität';

  @override
  String get section_profile => 'Profil';

  @override
  String get section_definition => 'Definition';

  @override
  String get section_centers => 'Zentren';

  @override
  String get section_channels => 'Kanäle';

  @override
  String get section_gates => 'Tore';

  @override
  String get section_conscious => 'Bewusst (Persönlichkeit)';

  @override
  String get section_unconscious => 'Unbewusst (Design)';

  @override
  String get social_title => 'Sozial';

  @override
  String get social_thoughts => 'Gedanken';

  @override
  String get social_discover => 'Entdecken';

  @override
  String get social_groups => 'Gruppen';

  @override
  String get social_invite => 'Einladen';

  @override
  String get social_createPost => 'Teilen Sie einen Gedanken...';

  @override
  String get social_noThoughtsYet => 'Noch keine Gedanken';

  @override
  String get social_noThoughtsMessage =>
      'Seien Sie der Erste, der seine Human Design Erkenntnisse teilt!';

  @override
  String get social_createGroup => 'Gruppe erstellen';

  @override
  String get social_members => 'Mitglieder';

  @override
  String get social_comments => 'Kommentare';

  @override
  String get social_addComment => 'Kommentar hinzufügen...';

  @override
  String get social_noComments => 'Noch keine Kommentare';

  @override
  String social_shareLimit(int remaining) {
    return 'Sie haben noch $remaining Shares in diesem Monat verfügbar';
  }

  @override
  String get social_visibility => 'Sichtbarkeit';

  @override
  String get social_private => 'Privat';

  @override
  String get social_friendsOnly => 'Nur Freunde';

  @override
  String get social_public => 'Öffentlich';

  @override
  String get social_shared => 'Geteilt';

  @override
  String get social_noGroupsYet => 'Noch keine Gruppen';

  @override
  String get social_noGroupsMessage =>
      'Erstellen Sie Gruppen, um Teamdynamiken mit Penta-Analyse zu analysieren.';

  @override
  String get social_noSharedCharts => 'Keine geteilten Charts';

  @override
  String get social_noSharedChartsMessage =>
      'Mit Ihnen geteilte Charts werden hier angezeigt.';

  @override
  String get social_createGroupPrompt =>
      'Erstellen Sie eine Gruppe, um Teamdynamiken zu analysieren.';

  @override
  String get social_groupName => 'Gruppenname';

  @override
  String get social_groupNameHint => 'Familie, Team, usw.';

  @override
  String get social_groupDescription => 'Beschreibung (optional)';

  @override
  String get social_groupDescriptionHint => 'Wofür ist diese Gruppe?';

  @override
  String social_groupCreated(String name) {
    return 'Gruppe \"$name\" erstellt!';
  }

  @override
  String get social_groupNameRequired =>
      'Bitte geben Sie einen Gruppennamen ein';

  @override
  String get social_createGroupFailed =>
      'Erstellen der Gruppe fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get social_noDescription => 'Keine Beschreibung';

  @override
  String get social_admin => 'Administrator';

  @override
  String social_sharedBy(String name) {
    return 'Geteilt von $name';
  }

  @override
  String get social_loadGroupsFailed => 'Laden der Gruppen fehlgeschlagen';

  @override
  String get social_loadSharedFailed =>
      'Laden der geteilten Charts fehlgeschlagen';

  @override
  String get social_userNotFound => 'Benutzer nicht gefunden';

  @override
  String get discovery_userNotFound => 'Benutzer nicht gefunden';

  @override
  String get discovery_following => 'Folge ich';

  @override
  String get discovery_follow => 'Folgen';

  @override
  String get discovery_sendMessage => 'Nachricht senden';

  @override
  String get discovery_about => 'Über';

  @override
  String get discovery_humanDesign => 'Human Design';

  @override
  String get discovery_type => 'Typ';

  @override
  String get discovery_profile => 'Profil';

  @override
  String get discovery_authority => 'Autorität';

  @override
  String get discovery_compatibility => 'Kompatibilität';

  @override
  String get discovery_compatible => 'kompatibel';

  @override
  String get discovery_followers => 'Follower';

  @override
  String get discovery_followingLabel => 'Folge ich';

  @override
  String get discovery_noResults => 'Keine Benutzer gefunden';

  @override
  String get discovery_noResultsMessage =>
      'Versuchen Sie, Ihre Filter anzupassen oder schauen Sie später wieder vorbei';

  @override
  String get userProfile_viewChart => 'Bodygraph';

  @override
  String get userProfile_chartPrivate => 'Dieses Chart ist privat';

  @override
  String get userProfile_chartFriendsOnly =>
      'Werden Sie gegenseitige Follower, um dieses Chart anzusehen';

  @override
  String get userProfile_chartFollowToView =>
      'Folgen, um dieses Chart anzusehen';

  @override
  String get userProfile_publicProfile => 'Öffentliches Profil';

  @override
  String get userProfile_privateProfile => 'Privates Profil';

  @override
  String get userProfile_friendsOnlyProfile => 'Nur Freunde';

  @override
  String get userProfile_followersList => 'Follower';

  @override
  String get userProfile_followingList => 'Folge ich';

  @override
  String get userProfile_noFollowers => 'Noch keine Follower';

  @override
  String get userProfile_noFollowing => 'Folgt noch niemandem';

  @override
  String get userProfile_thoughts => 'Gedanken';

  @override
  String get userProfile_noThoughts => 'Noch keine Gedanken geteilt';

  @override
  String get userProfile_showAll => 'Alle anzeigen';

  @override
  String get popularCharts_title => 'Beliebte Charts';

  @override
  String get popularCharts_subtitle => 'Meistgefolgte öffentliche Charts';

  @override
  String time_minutesAgo(int minutes) {
    return 'vor ${minutes}m';
  }

  @override
  String time_hoursAgo(int hours) {
    return 'vor ${hours}h';
  }

  @override
  String time_daysAgo(int days) {
    return 'vor ${days}d';
  }

  @override
  String get transit_title => 'Heutige Transite';

  @override
  String get transit_currentEnergies => 'Aktuelle Energien';

  @override
  String get transit_sunGate => 'Sonnentor';

  @override
  String get transit_earthGate => 'Erdtor';

  @override
  String get transit_moonGate => 'Mondtor';

  @override
  String get transit_activeGates => 'Aktive Transittore';

  @override
  String get transit_activeChannels => 'Aktive Transitkanäle';

  @override
  String get transit_personalImpact => 'Persönliche Auswirkung';

  @override
  String transit_gateActivated(int gate) {
    return 'Tor $gate durch Transit aktiviert';
  }

  @override
  String transit_channelFormed(String channel) {
    return 'Kanal $channel mit Ihrem Chart gebildet';
  }

  @override
  String get transit_noPersonalImpact =>
      'Heute keine direkten Transitverbindungen';

  @override
  String get transit_viewFullTransit => 'Vollständiges Transit-Chart anzeigen';

  @override
  String get affirmation_title => 'Tägliche Affirmation';

  @override
  String affirmation_forYourType(String type) {
    return 'Für Ihren $type';
  }

  @override
  String affirmation_basedOnGate(int gate) {
    return 'Basierend auf Tor $gate';
  }

  @override
  String get affirmation_refresh => 'Neue Affirmation';

  @override
  String get affirmation_save => 'Affirmation speichern';

  @override
  String get affirmation_saved => 'Gespeicherte Affirmationen';

  @override
  String get affirmation_share => 'Affirmation teilen';

  @override
  String get affirmation_notifications =>
      'Tägliche Affirmations-Benachrichtigungen';

  @override
  String get affirmation_notificationTime => 'Benachrichtigungszeit';

  @override
  String get lifestyle_today => 'Heute';

  @override
  String get lifestyle_insights => 'Erkenntnisse';

  @override
  String get lifestyle_journal => 'Tagebuch';

  @override
  String get lifestyle_addJournalEntry => 'Tagebucheintrag hinzufügen';

  @override
  String get lifestyle_journalPrompt => 'Wie erleben Sie Ihr Design heute?';

  @override
  String get lifestyle_noJournalEntries => 'Noch keine Tagebucheinträge';

  @override
  String get lifestyle_mood => 'Stimmung';

  @override
  String get lifestyle_energy => 'Energieniveau';

  @override
  String get lifestyle_reflection => 'Reflexion';

  @override
  String get penta_title => 'Penta';

  @override
  String get penta_description => 'Gruppenanalyse für 3-5 Personen';

  @override
  String get penta_createNew => 'Penta erstellen';

  @override
  String get penta_selectMembers => 'Mitglieder auswählen';

  @override
  String get penta_minMembers => 'Mindestens 3 Mitglieder erforderlich';

  @override
  String get penta_maxMembers => 'Maximal 5 Mitglieder';

  @override
  String get penta_groupDynamics => 'Gruppendynamik';

  @override
  String get penta_missingRoles => 'Fehlende Rollen';

  @override
  String get penta_strengths => 'Gruppenstärken';

  @override
  String get penta_analysis => 'Penta-Analyse';

  @override
  String get penta_clearAnalysis => 'Analyse löschen';

  @override
  String get penta_infoText =>
      'Die Penta-Analyse zeigt die natürlichen Rollen, die in kleinen Gruppen von 3-5 Personen entstehen, und zeigt, wie jedes Mitglied zur Teamdynamik beiträgt.';

  @override
  String get penta_calculating => 'Berechne...';

  @override
  String get penta_calculate => 'Penta berechnen';

  @override
  String get penta_groupRoles => 'Gruppenrollen';

  @override
  String get penta_electromagneticConnections =>
      'Elektromagnetische Verbindungen';

  @override
  String get penta_connectionsDescription =>
      'Besondere Energieverbindungen zwischen Mitgliedern, die Anziehung und Chemie erzeugen.';

  @override
  String get penta_areasForAttention =>
      'Bereiche, die Aufmerksamkeit benötigen';

  @override
  String get composite_title => 'Komposit-Chart';

  @override
  String get composite_infoText =>
      'Ein Komposit-Chart zeigt die Beziehungsdynamik zwischen zwei Personen und offenbart, wie Ihre Charts interagieren und sich ergänzen.';

  @override
  String get composite_selectTwoCharts => '2 Charts auswählen';

  @override
  String get composite_calculate => 'Verbindung analysieren';

  @override
  String get composite_calculating => 'Analysiere...';

  @override
  String get composite_clearAnalysis => 'Analyse löschen';

  @override
  String get composite_connectionTheme => 'Verbindungsthema';

  @override
  String get composite_definedCenters => 'Definiert';

  @override
  String get composite_undefinedCenters => 'Offen';

  @override
  String get composite_score => 'Punktzahl';

  @override
  String get composite_themeVeryBonded =>
      'Sehr verbundene Beziehung - Sie fühlen sich möglicherweise tief miteinander verwoben, was intensiv sein kann';

  @override
  String get composite_themeBonded =>
      'Verbundene Beziehung - starkes Gefühl von Zusammengehörigkeit und geteilter Energie';

  @override
  String get composite_themeBalanced =>
      'Ausgewogene Beziehung - gesunde Mischung aus Zusammengehörigkeit und Unabhängigkeit';

  @override
  String get composite_themeIndependent =>
      'Unabhängige Beziehung - mehr Raum für individuelles Wachstum';

  @override
  String get composite_themeVeryIndependent =>
      'Sehr unabhängige Beziehung - bewusste gemeinsame Zeit hilft, die Bindung zu stärken';

  @override
  String get composite_electromagnetic => 'Elektromagnetische Kanäle';

  @override
  String get composite_electromagneticDesc =>
      'Intensive Anziehung - Sie vervollständigen einander';

  @override
  String get composite_companionship => 'Kameradschaftskanäle';

  @override
  String get composite_companionshipDesc =>
      'Komfort und Stabilität - geteiltes Verständnis';

  @override
  String get composite_dominance => 'Dominanzkanäle';

  @override
  String get composite_dominanceDesc => 'Einer lehrt/konditioniert den anderen';

  @override
  String get composite_compromise => 'Kompromisskanäle';

  @override
  String get composite_compromiseDesc =>
      'Natürliche Spannung - erfordert Bewusstsein';

  @override
  String get composite_noConnections => 'Keine Kanalverbindungen';

  @override
  String get composite_noConnectionsDesc =>
      'Diese Charts bilden keine direkten Kanalverbindungen, aber es kann dennoch interessante Tor-Interaktionen geben.';

  @override
  String get composite_noChartsTitle => 'Keine Charts verfügbar';

  @override
  String get composite_noChartsDesc =>
      'Erstellen Sie Charts für sich selbst und andere, um Ihre Beziehungsdynamiken zu vergleichen.';

  @override
  String get composite_needMoreCharts => 'Mehr Charts benötigt';

  @override
  String get composite_needMoreChartsDesc =>
      'Sie benötigen mindestens 2 Charts, um eine Beziehung zu analysieren. Fügen Sie ein weiteres Chart hinzu, um fortzufahren.';

  @override
  String get composite_selectTwoHint =>
      'Wählen Sie 2 Charts aus, um ihre Verbindung zu analysieren';

  @override
  String get composite_selectOneMore => 'Wählen Sie noch 1 Chart aus';

  @override
  String get premium_upgrade => 'Auf Premium upgraden';

  @override
  String get premium_subscribe => 'Abonnieren';

  @override
  String get premium_restore => 'Käufe wiederherstellen';

  @override
  String get premium_features => 'Premium-Funktionen';

  @override
  String get premium_unlimitedShares => 'Unbegrenztes Chart-Teilen';

  @override
  String get premium_groupCharts => 'Gruppen-Charts';

  @override
  String get premium_advancedTransits => 'Erweiterte Transit-Analyse';

  @override
  String get premium_personalizedAffirmations =>
      'Personalisierte Affirmationen';

  @override
  String get premium_journalInsights => 'Tagebuch-Erkenntnisse';

  @override
  String get premium_adFree => 'Werbefrei';

  @override
  String get premium_monthly => 'Monatlich';

  @override
  String get premium_yearly => 'Jährlich';

  @override
  String get premium_perMonth => '/Monat';

  @override
  String get premium_perYear => '/Jahr';

  @override
  String get premium_bestValue => 'Bester Wert';

  @override
  String get settings_appearance => 'Erscheinungsbild';

  @override
  String get settings_language => 'Sprache';

  @override
  String get settings_selectLanguage => 'Sprache auswählen';

  @override
  String get settings_changeLanguage => 'Sprache ändern';

  @override
  String get settings_theme => 'Design';

  @override
  String get settings_selectTheme => 'Design auswählen';

  @override
  String get settings_chartDisplay => 'Chart-Anzeige';

  @override
  String get settings_showGateNumbers => 'Tornummern anzeigen';

  @override
  String get settings_showGateNumbersSubtitle =>
      'Tornummern auf dem Bodygraph anzeigen';

  @override
  String get settings_use24HourTime => '24-Stunden-Format verwenden';

  @override
  String get settings_use24HourTimeSubtitle =>
      'Zeit im 24-Stunden-Format anzeigen';

  @override
  String get settings_feedback => 'Feedback';

  @override
  String get settings_hapticFeedback => 'Haptisches Feedback';

  @override
  String get settings_hapticFeedbackSubtitle => 'Vibration bei Interaktionen';

  @override
  String get settings_account => 'Konto';

  @override
  String get settings_changePassword => 'Passwort ändern';

  @override
  String get settings_deleteAccount => 'Konto löschen';

  @override
  String get settings_deleteAccountConfirm =>
      'Sind Sie sicher, dass Sie Ihr Konto löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden und alle Ihre Daten werden dauerhaft gelöscht.';

  @override
  String get settings_appVersion => 'App-Version';

  @override
  String get settings_rateApp => 'App bewerten';

  @override
  String get settings_sendFeedback => 'Feedback senden';

  @override
  String get settings_themeLight => 'Hell';

  @override
  String get settings_themeDark => 'Dunkel';

  @override
  String get settings_themeSystem => 'System';

  @override
  String get settings_notifications => 'Benachrichtigungen';

  @override
  String get settings_privacy => 'Datenschutz';

  @override
  String get settings_chartVisibility => 'Chart-Sichtbarkeit';

  @override
  String get settings_chartVisibilitySubtitle =>
      'Steuern Sie, wer Ihr Human Design Chart sehen kann';

  @override
  String get settings_chartPrivate => 'Privat';

  @override
  String get settings_chartPrivateDesc => 'Nur Sie können Ihr Chart sehen';

  @override
  String get settings_chartFriends => 'Freunde';

  @override
  String get settings_chartFriendsDesc =>
      'Gegenseitige Follower können Ihr Chart sehen';

  @override
  String get settings_chartPublic => 'Öffentlich';

  @override
  String get settings_chartPublicDesc => 'Ihre Follower können Ihr Chart sehen';

  @override
  String get settings_about => 'Über';

  @override
  String get settings_help => 'Hilfe & Support';

  @override
  String get settings_terms => 'Nutzungsbedingungen';

  @override
  String get settings_privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_dailyTransits => 'Tägliche Transite';

  @override
  String get settings_dailyTransitsSubtitle =>
      'Tägliche Transit-Updates erhalten';

  @override
  String get settings_gateChanges => 'Tor-Wechsel';

  @override
  String get settings_gateChangesSubtitle =>
      'Benachrichtigen, wenn die Sonne das Tor wechselt';

  @override
  String get settings_socialActivity => 'Soziale Aktivität';

  @override
  String get settings_socialActivitySubtitle =>
      'Freundschaftsanfragen und geteilte Charts';

  @override
  String get settings_achievements => 'Erfolge';

  @override
  String get settings_achievementsSubtitle =>
      'Freischaltung von Abzeichen und Meilensteinen';

  @override
  String get settings_deleteAccountWarning =>
      'Dies wird dauerhaft alle Ihre Daten einschließlich Charts, Beiträge und Nachrichten löschen.';

  @override
  String get settings_deleteAccountFailed =>
      'Löschen des Kontos fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get settings_passwordChanged => 'Passwort erfolgreich geändert';

  @override
  String get settings_passwordChangeFailed =>
      'Ändern des Passworts fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get settings_feedbackSubject => 'AuraMap App Feedback';

  @override
  String get settings_feedbackBody =>
      'Hallo,\n\nIch möchte folgendes Feedback zu AuraMap teilen:\n\n';

  @override
  String get auth_newPassword => 'Neues Passwort';

  @override
  String get auth_passwordRequired => 'Passwort ist erforderlich';

  @override
  String get auth_passwordTooShort =>
      'Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get auth_passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get settings_exportData => 'Meine Daten exportieren';

  @override
  String get settings_exportDataSubtitle =>
      'Eine Kopie all Ihrer Daten herunterladen (DSGVO)';

  @override
  String get settings_exportingData => 'Bereite Ihren Datenexport vor...';

  @override
  String get settings_exportDataSubject => 'AuraMap - Mein Datenexport';

  @override
  String get settings_exportDataFailed =>
      'Datenexport fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get error_generic => 'Etwas ist schief gelaufen';

  @override
  String get error_network => 'Keine Internetverbindung';

  @override
  String get error_invalidEmail => 'Bitte geben Sie eine gültige E-Mail ein';

  @override
  String get error_invalidPassword =>
      'Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get error_passwordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get error_birthDataRequired => 'Bitte geben Sie Ihre Geburtsdaten ein';

  @override
  String get error_locationRequired => 'Bitte wählen Sie Ihren Geburtsort aus';

  @override
  String get error_chartCalculation =>
      'Ihr Chart konnte nicht berechnet werden';

  @override
  String get profile_editProfile => 'Profil bearbeiten';

  @override
  String get profile_shareChart => 'Mein Chart teilen';

  @override
  String get profile_exportPdf => 'Chart als PDF exportieren';

  @override
  String get profile_upgradePremium => 'Auf Premium upgraden';

  @override
  String get profile_birthData => 'Geburtsdaten';

  @override
  String get profile_chartSummary => 'Chart-Zusammenfassung';

  @override
  String get profile_viewFullChart => 'Vollständiges Chart anzeigen';

  @override
  String get profile_signOut => 'Abmelden';

  @override
  String get profile_signOutConfirm =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get profile_addBirthDataPrompt =>
      'Fügen Sie Ihre Geburtsdaten hinzu, um Ihr Human Design Chart zu erstellen.';

  @override
  String get profile_addBirthDataToShare =>
      'Fügen Sie Geburtsdaten hinzu, um Ihr Chart zu teilen';

  @override
  String get profile_addBirthDataToExport =>
      'Fügen Sie Geburtsdaten hinzu, um Ihr Chart zu exportieren';

  @override
  String get profile_exportFailed => 'PDF-Export fehlgeschlagen';

  @override
  String get profile_signOutConfirmTitle => 'Abmelden';

  @override
  String get profile_loadFailed => 'Laden des Profils fehlgeschlagen';

  @override
  String get profile_defaultUserName => 'AuraMap Benutzer';

  @override
  String get profile_birthDate => 'Datum';

  @override
  String get profile_birthTime => 'Zeit';

  @override
  String get profile_birthLocation => 'Ort';

  @override
  String get profile_birthTimezone => 'Zeitzone';

  @override
  String get chart_chakras => 'Chakras';

  @override
  String get chakra_title => 'Chakra-Energie';

  @override
  String get chakra_activated => 'Aktiviert';

  @override
  String get chakra_inactive => 'Inaktiv';

  @override
  String chakra_activatedCount(int count) {
    return '$count von 7 Chakras aktiviert';
  }

  @override
  String get chakra_hdMapping => 'HD-Zentrum-Zuordnung';

  @override
  String get chakra_element => 'Element';

  @override
  String get chakra_location => 'Ort';

  @override
  String get chakra_root => 'Wurzel';

  @override
  String get chakra_root_sanskrit => 'Muladhara';

  @override
  String get chakra_root_description => 'Erdung, Überleben und Stabilität';

  @override
  String get chakra_sacral => 'Sakral';

  @override
  String get chakra_sacral_sanskrit => 'Svadhisthana';

  @override
  String get chakra_sacral_description =>
      'Kreativität, Sexualität und Emotionen';

  @override
  String get chakra_solarPlexus => 'Solarplexus';

  @override
  String get chakra_solarPlexus_sanskrit => 'Manipura';

  @override
  String get chakra_solarPlexus_description =>
      'Persönliche Kraft, Selbstvertrauen und Wille';

  @override
  String get chakra_heart => 'Herz';

  @override
  String get chakra_heart_sanskrit => 'Anahata';

  @override
  String get chakra_heart_description => 'Liebe, Mitgefühl und Verbindung';

  @override
  String get chakra_throat => 'Kehle';

  @override
  String get chakra_throat_sanskrit => 'Vishuddha';

  @override
  String get chakra_throat_description =>
      'Kommunikation, Ausdruck und Wahrheit';

  @override
  String get chakra_thirdEye => 'Drittes Auge';

  @override
  String get chakra_thirdEye_sanskrit => 'Ajna';

  @override
  String get chakra_thirdEye_description =>
      'Intuition, Einsicht und Vorstellungskraft';

  @override
  String get chakra_crown => 'Krone';

  @override
  String get chakra_crown_sanskrit => 'Sahasrara';

  @override
  String get chakra_crown_description =>
      'Spirituelle Verbindung und Bewusstsein';

  @override
  String get quiz_title => 'Quiz';

  @override
  String get quiz_yourProgress => 'Ihr Fortschritt';

  @override
  String quiz_quizzesCompleted(int count) {
    return '$count Quiz abgeschlossen';
  }

  @override
  String get quiz_accuracy => 'Genauigkeit';

  @override
  String get quiz_streak => 'Serie';

  @override
  String get quiz_all => 'Alle';

  @override
  String get quiz_difficulty => 'Schwierigkeit';

  @override
  String get quiz_beginner => 'Anfänger';

  @override
  String get quiz_intermediate => 'Fortgeschritten';

  @override
  String get quiz_advanced => 'Experte';

  @override
  String quiz_questions(int count) {
    return '$count Fragen';
  }

  @override
  String quiz_points(int points) {
    return '+$points Pkt';
  }

  @override
  String get quiz_completed => 'Abgeschlossen';

  @override
  String get quiz_noQuizzes => 'Keine Quiz verfügbar';

  @override
  String get quiz_checkBackLater => 'Schauen Sie später nach neuen Inhalten';

  @override
  String get quiz_startQuiz => 'Quiz starten';

  @override
  String get quiz_tryAgain => 'Erneut versuchen';

  @override
  String get quiz_backToQuizzes => 'Zurück zu Quiz';

  @override
  String get quiz_shareResults => 'Ergebnisse teilen';

  @override
  String get quiz_yourBest => 'Ihr Bestes';

  @override
  String get quiz_perfectScore => 'Perfekte Punktzahl!';

  @override
  String get quiz_newBest => 'Neue Bestleistung!';

  @override
  String get quiz_streakExtended => 'Serie erweitert!';

  @override
  String quiz_questionOf(int current, int total) {
    return 'Frage $current von $total';
  }

  @override
  String quiz_correct(int count) {
    return '$count richtig';
  }

  @override
  String get quiz_submitAnswer => 'Antwort absenden';

  @override
  String get quiz_nextQuestion => 'Nächste Frage';

  @override
  String get quiz_seeResults => 'Ergebnisse anzeigen';

  @override
  String get quiz_exitQuiz => 'Quiz beenden?';

  @override
  String get quiz_exitWarning =>
      'Ihr Fortschritt geht verloren, wenn Sie jetzt beenden.';

  @override
  String get quiz_exit => 'Beenden';

  @override
  String get quiz_timesUp => 'Zeit abgelaufen!';

  @override
  String get quiz_timesUpMessage =>
      'Ihre Zeit ist abgelaufen. Ihr Fortschritt wird übermittelt.';

  @override
  String get quiz_excellent => 'Ausgezeichnet!';

  @override
  String get quiz_goodJob => 'Gut gemacht!';

  @override
  String get quiz_keepLearning => 'Weiter lernen!';

  @override
  String get quiz_keepPracticing => 'Weiter üben!';

  @override
  String get quiz_masteredTopic => 'Sie haben dieses Thema gemeistert!';

  @override
  String get quiz_strongUnderstanding => 'Sie haben ein gutes Verständnis.';

  @override
  String get quiz_onRightTrack => 'Sie sind auf dem richtigen Weg.';

  @override
  String get quiz_reviewExplanations =>
      'Überprüfen Sie die Erklärungen, um sich zu verbessern.';

  @override
  String get quiz_studyMaterial =>
      'Studieren Sie das Material und versuchen Sie es erneut.';

  @override
  String get quiz_attemptHistory => 'Versuchsverlauf';

  @override
  String get quiz_statistics => 'Quiz-Statistiken';

  @override
  String get quiz_totalQuizzes => 'Quiz';

  @override
  String get quiz_totalQuestions => 'Fragen';

  @override
  String get quiz_bestStreak => 'Beste Serie';

  @override
  String quiz_strongest(String category) {
    return 'Stärkste: $category';
  }

  @override
  String quiz_needsWork(String category) {
    return 'Verbesserungsbedarf: $category';
  }

  @override
  String get quiz_category_types => 'Typen';

  @override
  String get quiz_category_centers => 'Zentren';

  @override
  String get quiz_category_authorities => 'Autoritäten';

  @override
  String get quiz_category_profiles => 'Profile';

  @override
  String get quiz_category_gates => 'Tore';

  @override
  String get quiz_category_channels => 'Kanäle';

  @override
  String get quiz_category_definitions => 'Definitionen';

  @override
  String get quiz_category_general => 'Allgemein';

  @override
  String get quiz_explanation => 'Erklärung';

  @override
  String get quiz_quizzes => 'Quiz';

  @override
  String get quiz_questionsLabel => 'Fragen';

  @override
  String get quiz_shareProgress => 'Fortschritt teilen';

  @override
  String get quiz_shareProgressSubject => 'Mein Human Design Lernfortschritt';

  @override
  String get quiz_sharePerfect =>
      'Ich habe eine perfekte Punktzahl erreicht! Ich beherrsche Human Design.';

  @override
  String get quiz_shareExcellent =>
      'Ich mache großartige Fortschritte auf meiner Human Design Lernreise!';

  @override
  String get quiz_shareGoodJob =>
      'Ich lerne über Human Design. Jedes Quiz hilft mir zu wachsen!';

  @override
  String quiz_shareSubject(String quizTitle, int score) {
    return 'Ich habe $score% bei \"$quizTitle\" erreicht - Human Design Quiz';
  }

  @override
  String get quiz_failedToLoadStats => 'Laden der Statistiken fehlgeschlagen';

  @override
  String get planetary_personality => 'Persönlichkeit';

  @override
  String get planetary_design => 'Design';

  @override
  String get planetary_consciousBirth => 'Bewusst · Geburt';

  @override
  String get planetary_unconsciousPrenatal => 'Unbewusst · 88° Pränatal';

  @override
  String get gamification_yourProgress => 'Ihr Fortschritt';

  @override
  String get gamification_level => 'Level';

  @override
  String get gamification_points => 'Pkt';

  @override
  String get gamification_viewAll => 'Alle anzeigen';

  @override
  String get gamification_allChallengesComplete =>
      'Alle täglichen Herausforderungen abgeschlossen!';

  @override
  String get gamification_dailyChallenge => 'Tägliche Herausforderung';

  @override
  String get gamification_achievements => 'Erfolge';

  @override
  String get gamification_challenges => 'Herausforderungen';

  @override
  String get gamification_leaderboard => 'Bestenliste';

  @override
  String get gamification_streak => 'Serie';

  @override
  String get gamification_badges => 'Abzeichen';

  @override
  String get gamification_earnedBadge => 'Sie haben ein Abzeichen verdient!';

  @override
  String get gamification_claimReward => 'Belohnung beanspruchen';

  @override
  String get gamification_completed => 'Abgeschlossen';

  @override
  String get common_copy => 'Kopieren';

  @override
  String get share_myShares => 'Meine Shares';

  @override
  String get share_createNew => 'Neu erstellen';

  @override
  String get share_newLink => 'Neuer Link';

  @override
  String get share_noShares => 'Keine geteilten Links';

  @override
  String get share_noSharesMessage =>
      'Erstellen Sie Share-Links, damit andere Ihr Chart ohne Konto ansehen können.';

  @override
  String get share_createFirst => 'Erstellen Sie Ihren ersten Link';

  @override
  String share_activeLinks(int count) {
    return '$count aktive Links';
  }

  @override
  String share_expiredLinks(int count) {
    return '$count abgelaufen';
  }

  @override
  String get share_clearExpired => 'Löschen';

  @override
  String get share_clearExpiredTitle => 'Abgelaufene Links löschen';

  @override
  String share_clearExpiredMessage(int count) {
    return 'Dies entfernt $count abgelaufene Links aus Ihrem Verlauf.';
  }

  @override
  String get share_clearAll => 'Alle löschen';

  @override
  String get share_expiredCleared => 'Abgelaufene Links gelöscht';

  @override
  String get share_linkCopied => 'Link in Zwischenablage kopiert';

  @override
  String get share_revokeTitle => 'Link widerrufen';

  @override
  String get share_revokeMessage =>
      'Dies wird diesen Share-Link dauerhaft deaktivieren. Niemand mit diesem Link kann mehr Ihr Chart ansehen.';

  @override
  String get share_revoke => 'Widerrufen';

  @override
  String get share_linkRevoked => 'Link widerrufen';

  @override
  String get share_totalLinks => 'Gesamt';

  @override
  String get share_active => 'Aktiv';

  @override
  String get share_totalViews => 'Aufrufe';

  @override
  String get share_chartLink => 'Chart-Share';

  @override
  String get share_transitLink => 'Transit-Share';

  @override
  String get share_compatibilityLink => 'Kompatibilitätsbericht';

  @override
  String get share_link => 'Link teilen';

  @override
  String share_views(int count) {
    return '$count Aufrufe';
  }

  @override
  String get share_expired => 'Abgelaufen';

  @override
  String get share_activeLabel => 'Aktiv';

  @override
  String share_expiredOn(String date) {
    return 'Abgelaufen am $date';
  }

  @override
  String share_expiresIn(String time) {
    return 'Läuft ab in $time';
  }

  @override
  String get auth_emailNotConfirmed => 'Bitte bestätigen Sie Ihre E-Mail';

  @override
  String get auth_resendConfirmation => 'Bestätigungs-E-Mail erneut senden';

  @override
  String get auth_confirmationSent => 'Bestätigungs-E-Mail gesendet';

  @override
  String get auth_checkEmail =>
      'Überprüfen Sie Ihre E-Mail für den Bestätigungslink';

  @override
  String get auth_checkYourEmail => 'Überprüfen Sie Ihre E-Mail';

  @override
  String get auth_confirmationLinkSent =>
      'Wir haben einen Bestätigungslink gesendet an:';

  @override
  String get auth_clickLinkToActivate =>
      'Bitte klicken Sie auf den Link in der E-Mail, um Ihr Konto zu aktivieren.';

  @override
  String get auth_goToSignIn => 'Zur Anmeldung';

  @override
  String get auth_returnToHome => 'Zurück zur Startseite';

  @override
  String get hashtags_explore => 'Hashtags erkunden';

  @override
  String get hashtags_trending => 'Trending';

  @override
  String get hashtags_popular => 'Beliebt';

  @override
  String get hashtags_hdTopics => 'HD-Themen';

  @override
  String get hashtags_noTrending => 'Noch keine Trend-Hashtags';

  @override
  String get hashtags_noPopular => 'Noch keine beliebten Hashtags';

  @override
  String get hashtags_noHdTopics => 'Noch keine HD-Themen';

  @override
  String get hashtag_noPosts => 'Noch keine Beiträge';

  @override
  String get hashtag_beFirst =>
      'Seien Sie der Erste, der mit diesem Hashtag postet!';

  @override
  String hashtag_postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Beiträge',
      one: '1 Beitrag',
    );
    return '$_temp0';
  }

  @override
  String hashtag_recentPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Beiträge heute',
      one: '1 Beitrag heute',
    );
    return '$_temp0';
  }

  @override
  String get feed_forYou => 'Für Sie';

  @override
  String get feed_trending => 'Trending';

  @override
  String get feed_hdTopics => 'HD-Themen';

  @override
  String feed_gateTitle(int number) {
    return 'Tor $number';
  }

  @override
  String feed_gatePosts(int number) {
    return 'Beiträge über Tor $number';
  }

  @override
  String get transit_events_title => 'Transit-Ereignisse';

  @override
  String get transit_events_happening => 'Gerade jetzt';

  @override
  String get transit_events_upcoming => 'Bevorstehend';

  @override
  String get transit_events_past => 'Vergangene Ereignisse';

  @override
  String get transit_events_noCurrentEvents => 'Derzeit keine Ereignisse';

  @override
  String get transit_events_noUpcomingEvents =>
      'Keine bevorstehenden Ereignisse geplant';

  @override
  String get transit_events_noPastEvents => 'Keine vergangenen Ereignisse';

  @override
  String get transit_events_live => 'LIVE';

  @override
  String get transit_events_join => 'Beitreten';

  @override
  String get transit_events_joined => 'Beigetreten';

  @override
  String get transit_events_leave => 'Verlassen';

  @override
  String get transit_events_participating => 'teilnehmend';

  @override
  String get transit_events_posts => 'Beiträge';

  @override
  String get transit_events_viewInsights => 'Erkenntnisse anzeigen';

  @override
  String transit_events_endsIn(String time) {
    return 'Endet in $time';
  }

  @override
  String transit_events_startsIn(String time) {
    return 'Beginnt in $time';
  }

  @override
  String get transit_events_notFound => 'Ereignis nicht gefunden';

  @override
  String get transit_events_communityPosts => 'Community-Beiträge';

  @override
  String get transit_events_noPosts =>
      'Noch keine Beiträge für dieses Ereignis';

  @override
  String get transit_events_shareExperience => 'Erfahrung teilen';

  @override
  String get transit_events_participants => 'Teilnehmer';

  @override
  String get transit_events_duration => 'Dauer';

  @override
  String get transit_events_eventEnded => 'Dieses Ereignis ist beendet';

  @override
  String get transit_events_youreParticipating => 'Sie nehmen teil!';

  @override
  String transit_events_experiencingWith(int count) {
    return 'Erleben Sie diesen Transit mit $count anderen';
  }

  @override
  String get transit_events_joinCommunity => 'Der Community beitreten';

  @override
  String get transit_events_shareYourExperience =>
      'Teilen Sie Ihre Erfahrung und vernetzen Sie sich mit anderen';

  @override
  String get activity_title => 'Freundesaktivität';

  @override
  String get activity_noActivities => 'Noch keine Freundesaktivität';

  @override
  String get activity_followFriends =>
      'Folgen Sie Freunden, um ihre Erfolge und Meilensteine hier zu sehen!';

  @override
  String get activity_findFriends => 'Freunde finden';

  @override
  String get activity_celebrate => 'Feiern';

  @override
  String get activity_celebrated => 'Gefeiert';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get create => 'Erstellen';

  @override
  String get groupChallenges_title => 'Gruppenherausforderungen';

  @override
  String get groupChallenges_myTeams => 'Meine Teams';

  @override
  String get groupChallenges_challenges => 'Herausforderungen';

  @override
  String get groupChallenges_leaderboard => 'Bestenliste';

  @override
  String get groupChallenges_createTeam => 'Team erstellen';

  @override
  String get groupChallenges_teamName => 'Teamname';

  @override
  String get groupChallenges_teamNameHint => 'Geben Sie einen Teamnamen ein';

  @override
  String get groupChallenges_teamDescription => 'Beschreibung';

  @override
  String get groupChallenges_teamDescriptionHint =>
      'Worum geht es bei Ihrem Team?';

  @override
  String get groupChallenges_teamCreated => 'Team erfolgreich erstellt!';

  @override
  String get groupChallenges_noTeams => 'Noch keine Teams';

  @override
  String get groupChallenges_noTeamsDescription =>
      'Erstellen oder treten Sie einem Team bei, um an Gruppenherausforderungen teilzunehmen!';

  @override
  String groupChallenges_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String groupChallenges_points(int points) {
    return '$points Pkt';
  }

  @override
  String get groupChallenges_noChallenges => 'Keine aktiven Herausforderungen';

  @override
  String get groupChallenges_active => 'Aktiv';

  @override
  String get groupChallenges_upcoming => 'Bevorstehend';

  @override
  String groupChallenges_reward(int points) {
    return '$points Pkt Belohnung';
  }

  @override
  String groupChallenges_teamsEnrolled(String count) {
    return '$count Teams';
  }

  @override
  String groupChallenges_participants(String count) {
    return '$count Teilnehmer';
  }

  @override
  String groupChallenges_endsIn(String time) {
    return 'Endet in $time';
  }

  @override
  String get groupChallenges_weekly => 'Wöchentlich';

  @override
  String get groupChallenges_monthly => 'Monatlich';

  @override
  String get groupChallenges_allTime => 'Alle Zeiten';

  @override
  String get groupChallenges_noTeamsOnLeaderboard =>
      'Noch keine Teams auf der Bestenliste';

  @override
  String get groupChallenges_pts => 'Pkt';

  @override
  String get groupChallenges_teamNotFound => 'Team nicht gefunden';

  @override
  String get groupChallenges_members => 'Mitglieder';

  @override
  String get groupChallenges_totalPoints => 'Gesamtpunkte';

  @override
  String get groupChallenges_joined => 'Beigetreten';

  @override
  String get groupChallenges_join => 'Beitreten';

  @override
  String get groupChallenges_status => 'Status';

  @override
  String get groupChallenges_about => 'Über';

  @override
  String get groupChallenges_noMembers => 'Noch keine Mitglieder';

  @override
  String get groupChallenges_admin => 'Administrator';

  @override
  String groupChallenges_contributed(int points) {
    return '$points Pkt beigetragen';
  }

  @override
  String get groupChallenges_joinedTeam => 'Erfolgreich dem Team beigetreten!';

  @override
  String get groupChallenges_leaveTeam => 'Team verlassen';

  @override
  String get groupChallenges_leaveConfirmation =>
      'Sind Sie sicher, dass Sie dieses Team verlassen möchten? Ihre beigetragenen Punkte verbleiben beim Team.';

  @override
  String get groupChallenges_leave => 'Verlassen';

  @override
  String get groupChallenges_leftTeam => 'Sie haben das Team verlassen';

  @override
  String get groupChallenges_challengeDetails => 'Herausforderungsdetails';

  @override
  String get groupChallenges_challengeNotFound =>
      'Herausforderung nicht gefunden';

  @override
  String get groupChallenges_target => 'Ziel';

  @override
  String get groupChallenges_starts => 'Beginnt';

  @override
  String get groupChallenges_ends => 'Endet';

  @override
  String get groupChallenges_hdTypes => 'HD-Typen';

  @override
  String get groupChallenges_noTeamsToEnroll => 'Keine Teams zum Anmelden';

  @override
  String get groupChallenges_createTeamToJoin =>
      'Erstellen Sie zuerst ein Team, um an Herausforderungen teilzunehmen';

  @override
  String get groupChallenges_enrollTeam => 'Team anmelden';

  @override
  String get groupChallenges_enrolled => 'Angemeldet';

  @override
  String get groupChallenges_enroll => 'Anmelden';

  @override
  String get groupChallenges_teamEnrolled => 'Team erfolgreich angemeldet!';

  @override
  String get groupChallenges_noTeamsEnrolled => 'Noch keine Teams angemeldet';

  @override
  String get circles_title => 'Kompatibilitätskreise';

  @override
  String get circles_myCircles => 'Meine Kreise';

  @override
  String get circles_invitations => 'Einladungen';

  @override
  String get circles_create => 'Kreis erstellen';

  @override
  String get circles_selectIcon => 'Symbol auswählen';

  @override
  String get circles_name => 'Kreisname';

  @override
  String get circles_nameHint => 'Familie, Team, Freunde...';

  @override
  String get circles_description => 'Beschreibung';

  @override
  String get circles_descriptionHint => 'Wofür ist dieser Kreis?';

  @override
  String get circles_created => 'Kreis erfolgreich erstellt!';

  @override
  String get circles_noCircles => 'Noch keine Kreise';

  @override
  String get circles_noCirclesDescription =>
      'Erstellen Sie einen Kreis, um Kompatibilität mit Freunden, Familie oder Teammitgliedern zu analysieren.';

  @override
  String get circles_suggestions => 'Schnellstart';

  @override
  String circles_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String get circles_private => 'Privat';

  @override
  String get circles_noInvitations => 'Keine Einladungen';

  @override
  String get circles_noInvitationsDescription =>
      'Kreiseinladungen, die Sie erhalten, werden hier angezeigt.';

  @override
  String circles_invitedBy(String name) {
    return 'Eingeladen von $name';
  }

  @override
  String get circles_decline => 'Ablehnen';

  @override
  String get circles_accept => 'Annehmen';

  @override
  String get circles_invitationDeclined => 'Einladung abgelehnt';

  @override
  String get circles_invitationAccepted => 'Sie sind dem Kreis beigetreten!';

  @override
  String get circles_notFound => 'Kreis nicht gefunden';

  @override
  String get circles_invite => 'Mitglied einladen';

  @override
  String get circles_members => 'Mitglieder';

  @override
  String get circles_analysis => 'Analyse';

  @override
  String get circles_feed => 'Feed';

  @override
  String get circles_inviteMember => 'Mitglied einladen';

  @override
  String get circles_sendInvite => 'Einladung senden';

  @override
  String get circles_invitationSent => 'Einladung gesendet!';

  @override
  String get circles_invitationFailed => 'Senden der Einladung fehlgeschlagen';

  @override
  String get circles_deleteTitle => 'Kreis löschen';

  @override
  String circles_deleteConfirmation(String name) {
    return 'Sind Sie sicher, dass Sie \"$name\" löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get circles_deleted => 'Kreis gelöscht';

  @override
  String get circles_noMembers => 'Noch keine Mitglieder';

  @override
  String get circles_noAnalysis => 'Noch keine Analyse';

  @override
  String get circles_runAnalysis =>
      'Führen Sie eine Kompatibilitätsanalyse durch, um zu sehen, wie Ihre Kreismitglieder interagieren.';

  @override
  String get circles_needMoreMembers =>
      'Fügen Sie mindestens 2 Mitglieder hinzu, um eine Analyse durchzuführen.';

  @override
  String get circles_analyzeCompatibility => 'Kompatibilität analysieren';

  @override
  String get circles_harmonyScore => 'Harmonie-Score';

  @override
  String get circles_typeDistribution => 'Typ-Verteilung';

  @override
  String get circles_electromagneticConnections =>
      'Elektromagnetische Verbindungen';

  @override
  String get circles_electromagneticDesc =>
      'Intensive Anziehung - Sie vervollständigen einander';

  @override
  String get circles_companionshipConnections => 'Kameradschaftsverbindungen';

  @override
  String get circles_companionshipDesc =>
      'Komfort und Stabilität - geteiltes Verständnis';

  @override
  String get circles_groupStrengths => 'Gruppenstärken';

  @override
  String get circles_areasForGrowth => 'Wachstumsbereiche';

  @override
  String get circles_writePost => 'Teilen Sie etwas mit Ihrem Kreis...';

  @override
  String get circles_noPosts => 'Noch keine Beiträge';

  @override
  String get circles_beFirstToPost =>
      'Seien Sie der Erste, der etwas mit Ihrem Kreis teilt!';

  @override
  String get experts_title => 'HD-Experten';

  @override
  String get experts_becomeExpert => 'Experte werden';

  @override
  String get experts_filterBySpecialization => 'Nach Spezialisierung filtern';

  @override
  String get experts_allExperts => 'Alle Experten';

  @override
  String get experts_experts => 'Experten';

  @override
  String get experts_noExperts => 'Keine Experten gefunden';

  @override
  String get experts_featured => 'Empfohlene Experten';

  @override
  String experts_followers(int count) {
    return '$count Follower';
  }

  @override
  String get experts_notFound => 'Experte nicht gefunden';

  @override
  String get experts_following => 'Folge ich';

  @override
  String get experts_follow => 'Folgen';

  @override
  String get experts_about => 'Über';

  @override
  String get experts_specializations => 'Spezialisierungen';

  @override
  String get experts_credentials => 'Qualifikationen';

  @override
  String get experts_reviews => 'Bewertungen';

  @override
  String get experts_writeReview => 'Bewertung schreiben';

  @override
  String get experts_reviewContent => 'Ihre Bewertung';

  @override
  String get experts_reviewHint =>
      'Teilen Sie Ihre Erfahrung mit diesem Experten...';

  @override
  String get experts_submitReview => 'Bewertung absenden';

  @override
  String get experts_reviewSubmitted => 'Bewertung erfolgreich eingereicht!';

  @override
  String get experts_noReviews => 'Noch keine Bewertungen';

  @override
  String get experts_followersLabel => 'Follower';

  @override
  String get experts_rating => 'Bewertung';

  @override
  String get experts_years => 'Jahre';

  @override
  String get learningPaths_title => 'Lernpfade';

  @override
  String get learningPaths_explore => 'Erkunden';

  @override
  String get learningPaths_inProgress => 'In Bearbeitung';

  @override
  String get learningPaths_completed => 'Abgeschlossen';

  @override
  String get learningPaths_featured => 'Empfohlene Pfade';

  @override
  String get learningPaths_allPaths => 'Alle Pfade';

  @override
  String get learningPaths_noPathsExplore => 'Keine Lernpfade verfügbar';

  @override
  String get learningPaths_noPathsInProgress => 'Keine Pfade in Bearbeitung';

  @override
  String get learningPaths_noPathsInProgressDescription =>
      'Melden Sie sich für einen Lernpfad an, um Ihre Reise zu beginnen!';

  @override
  String get learningPaths_browsePaths => 'Pfade durchsuchen';

  @override
  String get learningPaths_noPathsCompleted => 'Keine abgeschlossenen Pfade';

  @override
  String get learningPaths_noPathsCompletedDescription =>
      'Schließen Sie Lernpfade ab, um sie hier zu sehen!';

  @override
  String learningPaths_enrolled(int count) {
    return '$count angemeldet';
  }

  @override
  String learningPaths_stepsCount(int count) {
    return '$count Schritte';
  }

  @override
  String learningPaths_progress(int completed, int total) {
    return '$completed von $total Schritten';
  }

  @override
  String get learningPaths_resume => 'Fortsetzen';

  @override
  String learningPaths_completedOn(String date) {
    return 'Abgeschlossen am $date';
  }

  @override
  String get learningPathNotFound => 'Lernpfad nicht gefunden';

  @override
  String learningPathMinutes(int minutes) {
    return '$minutes Min';
  }

  @override
  String learningPathSteps(int count) {
    return '$count Schritte';
  }

  @override
  String learningPathBy(String author) {
    return 'Von $author';
  }

  @override
  String learningPathEnrolled(int count) {
    return '$count angemeldet';
  }

  @override
  String learningPathCompleted(int count) {
    return '$count abgeschlossen';
  }

  @override
  String get learningPathEnroll => 'Lernen beginnen';

  @override
  String get learningPathYourProgress => 'Ihr Fortschritt';

  @override
  String get learningPathCompletedBadge => 'Abgeschlossen';

  @override
  String learningPathProgressText(int completed, int total) {
    return '$completed von $total Schritten abgeschlossen';
  }

  @override
  String get learningPathStepsTitle => 'Lernschritte';

  @override
  String get learningPathEnrollTitle => 'Diesen Pfad beginnen?';

  @override
  String learningPathEnrollMessage(String title) {
    return 'Sie werden für \"$title\" angemeldet und können Ihren Fortschritt verfolgen, während Sie jeden Schritt abschließen.';
  }

  @override
  String get learningPathViewContent => 'Inhalt anzeigen';

  @override
  String get learningPathMarkComplete => 'Als abgeschlossen markieren';

  @override
  String get learningPathStepCompleted => 'Schritt abgeschlossen!';

  @override
  String get thought_title => 'Gedanken';

  @override
  String get thought_feedTitle => 'Gedanken';

  @override
  String get thought_createNew => 'Gedanken teilen';

  @override
  String get thought_emptyFeed => 'Ihr Gedanken-Feed ist leer';

  @override
  String get thought_emptyFeedMessage =>
      'Folgen Sie Personen oder teilen Sie einen Gedanken, um loszulegen';

  @override
  String get thought_regenerate => 'Regenerieren';

  @override
  String thought_regeneratedFrom(String username) {
    return 'Regeneriert von @$username';
  }

  @override
  String get thought_regenerateSuccess =>
      'Gedanke auf Ihrer Pinnwand regeneriert!';

  @override
  String get thought_regenerateConfirm => 'Diesen Gedanken regenerieren?';

  @override
  String get thought_regenerateDescription =>
      'Dies wird diesen Gedanken auf Ihrer Pinnwand teilen und den ursprünglichen Autor nennen.';

  @override
  String get thought_addComment => 'Kommentar hinzufügen (optional)';

  @override
  String thought_regenerateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Regenerierungen',
      one: '1 Regenerierung',
    );
    return '$_temp0';
  }

  @override
  String get thought_cannotRegenerateOwn =>
      'Sie können Ihren eigenen Gedanken nicht regenerieren';

  @override
  String get thought_alreadyRegenerated =>
      'Sie haben diesen Gedanken bereits regeneriert';

  @override
  String get thought_postDetail => 'Gedanke';

  @override
  String get thought_noComments =>
      'Noch keine Kommentare. Seien Sie der Erste, der kommentiert!';

  @override
  String thought_replyingTo(String username) {
    return 'Antwort an $username';
  }

  @override
  String get thought_writeReply => 'Antwort schreiben...';

  @override
  String get thought_commentPlaceholder => 'Kommentar hinzufügen...';

  @override
  String get messages_title => 'Nachrichten';

  @override
  String get messages_conversation => 'Konversation';

  @override
  String get messages_loading => 'Lädt...';

  @override
  String get messages_muteNotifications => 'Benachrichtigungen stummschalten';

  @override
  String get messages_notificationsMuted =>
      'Benachrichtigungen stummgeschaltet';

  @override
  String get messages_blockUser => 'Benutzer blockieren';

  @override
  String get messages_blockUserConfirm =>
      'Sind Sie sicher, dass Sie diesen Benutzer blockieren möchten? Sie erhalten keine Nachrichten mehr von ihm.';

  @override
  String get messages_userBlocked => 'Benutzer blockiert';

  @override
  String get messages_block => 'Blockieren';

  @override
  String get messages_deleteConversation => 'Konversation löschen';

  @override
  String get messages_deleteConversationConfirm =>
      'Sind Sie sicher, dass Sie diese Konversation löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get messages_conversationDeleted => 'Konversation gelöscht';

  @override
  String get messages_startConversation => 'Beginnen Sie die Konversation!';

  @override
  String get profile_takePhoto => 'Foto aufnehmen';

  @override
  String get profile_chooseFromGallery => 'Aus Galerie auswählen';

  @override
  String get profile_avatarUpdated => 'Avatar erfolgreich aktualisiert';

  @override
  String get profile_profileUpdated => 'Profil erfolgreich aktualisiert';

  @override
  String get profile_noProfileFound => 'Kein Profil gefunden';

  @override
  String get discovery_title => 'Entdecken';

  @override
  String get discovery_searchUsers => 'Benutzer suchen...';

  @override
  String get discovery_discoverTab => 'Entdecken';

  @override
  String get discovery_followingTab => 'Folge ich';

  @override
  String get discovery_followersTab => 'Follower';

  @override
  String get discovery_noUsersFound => 'Keine Benutzer gefunden';

  @override
  String get discovery_tryAdjustingFilters =>
      'Versuchen Sie, Ihre Filter anzupassen';

  @override
  String get discovery_notFollowingAnyone => 'Folgt niemandem';

  @override
  String get discovery_discoverPeople => 'Entdecken Sie Personen zum Folgen';

  @override
  String get discovery_noFollowersYet => 'Noch keine Follower';

  @override
  String get discovery_shareInsights =>
      'Teilen Sie Ihre Erkenntnisse, um Follower zu gewinnen';

  @override
  String get discovery_clearAll => 'Alle löschen';

  @override
  String chart_gate(int number) {
    return 'Tor $number';
  }

  @override
  String chart_channel(String id) {
    return 'Kanal $id';
  }

  @override
  String get chart_center => 'Zentrum';

  @override
  String get chart_keynote => 'Grundton';

  @override
  String get chart_element => 'Element';

  @override
  String get chart_location => 'Ort';

  @override
  String get chart_hdCenters => 'HD-Zentren';

  @override
  String get reaction_comment => 'Kommentieren';

  @override
  String get reaction_react => 'Reagieren';

  @override
  String get reaction_standard => 'Standard';

  @override
  String get reaction_humanDesign => 'Human Design';

  @override
  String get share_shareChart => 'Chart teilen';

  @override
  String get share_createShareLink => 'Share-Link erstellen';

  @override
  String get share_shareViaUrl => 'Via URL teilen';

  @override
  String get share_exportAsPng => 'Als PNG exportieren';

  @override
  String get share_fullReport => 'Vollständiger Bericht';

  @override
  String get share_linkExpiration => 'Link-Ablauf';

  @override
  String get share_neverExpires => 'Läuft nie ab';

  @override
  String get share_oneHour => '1 Stunde';

  @override
  String get share_twentyFourHours => '24 Stunden';

  @override
  String get share_sevenDays => '7 Tage';

  @override
  String get share_thirtyDays => '30 Tage';

  @override
  String get share_creating => 'Erstelle...';

  @override
  String get share_signInToShare =>
      'Melden Sie sich an, um Ihr Chart zu teilen';

  @override
  String get share_createShareableLinks =>
      'Erstellen Sie teilbare Links zu Ihrem Human Design Chart';

  @override
  String get share_linkImage => 'Bild';

  @override
  String get share_pdf => 'PDF';

  @override
  String get post_share => 'Teilen';

  @override
  String get post_edit => 'Bearbeiten';

  @override
  String get post_report => 'Melden';

  @override
  String get mentorship_title => 'Mentoring';

  @override
  String get mentorship_pendingRequests => 'Ausstehende Anfragen';

  @override
  String get mentorship_availableMentors => 'Verfügbare Mentoren';

  @override
  String get mentorship_noMentorsAvailable => 'Keine Mentoren verfügbar';

  @override
  String mentorship_requestMentorship(String name) {
    return 'Mentoring von $name anfragen';
  }

  @override
  String get mentorship_sendMessage =>
      'Senden Sie eine Nachricht, in der Sie erklären, was Sie lernen möchten:';

  @override
  String get mentorship_learnPrompt => 'Ich möchte mehr erfahren über...';

  @override
  String get mentorship_requestSent => 'Anfrage gesendet!';

  @override
  String get mentorship_sendRequest => 'Anfrage senden';

  @override
  String get mentorship_becomeAMentor => 'Mentor werden';

  @override
  String get mentorship_shareKnowledge => 'Teilen Sie Ihr Human Design Wissen';

  @override
  String get story_cancel => 'Abbrechen';

  @override
  String get story_createStory => 'Story erstellen';

  @override
  String get story_share => 'Teilen';

  @override
  String get story_typeYourStory => 'Schreiben Sie Ihre Story...';

  @override
  String get story_background => 'Hintergrund';

  @override
  String get story_attachTransitGate => 'Transittor anhängen (optional)';

  @override
  String get story_none => 'Keine';

  @override
  String story_gateNumber(int number) {
    return 'Tor $number';
  }

  @override
  String get story_whoCanSee => 'Wer kann dies sehen?';

  @override
  String get story_followers => 'Follower';

  @override
  String get story_everyone => 'Alle';

  @override
  String get challenges_title => 'Herausforderungen';

  @override
  String get challenges_daily => 'Täglich';

  @override
  String get challenges_weekly => 'Wöchentlich';

  @override
  String get challenges_monthly => 'Monatlich';

  @override
  String get challenges_noDailyChallenges =>
      'Keine täglichen Herausforderungen verfügbar';

  @override
  String get challenges_noWeeklyChallenges =>
      'Keine wöchentlichen Herausforderungen verfügbar';

  @override
  String get challenges_noMonthlyChallenges =>
      'Keine monatlichen Herausforderungen verfügbar';

  @override
  String get challenges_errorLoading =>
      'Fehler beim Laden der Herausforderungen';

  @override
  String challenges_claimedPoints(int points) {
    return '$points Punkte beansprucht!';
  }

  @override
  String get challenges_totalPoints => 'Gesamtpunkte';

  @override
  String get challenges_level => 'Level';

  @override
  String get learning_all => 'Alle';

  @override
  String get learning_types => 'Typen';

  @override
  String get learning_gates => 'Tore';

  @override
  String get learning_centers => 'Zentren';

  @override
  String get learning_liveSessions => 'Live-Sessions';

  @override
  String get quiz_noActiveSession => 'Keine aktive Quiz-Session';

  @override
  String get quiz_noQuestionsAvailable => 'Keine Fragen verfügbar';

  @override
  String get quiz_ok => 'OK';

  @override
  String get liveSessions_title => 'Live-Sessions';

  @override
  String get liveSessions_upcoming => 'Bevorstehend';

  @override
  String get liveSessions_mySessions => 'Meine Sessions';

  @override
  String get liveSessions_errorLoading => 'Fehler beim Laden der Sessions';

  @override
  String get liveSessions_registeredSuccessfully => 'Erfolgreich registriert!';

  @override
  String get liveSessions_cancelRegistration => 'Registrierung abbrechen';

  @override
  String get liveSessions_cancelRegistrationConfirm =>
      'Sind Sie sicher, dass Sie Ihre Registrierung abbrechen möchten?';

  @override
  String get liveSessions_no => 'Nein';

  @override
  String get liveSessions_yesCancel => 'Ja, abbrechen';

  @override
  String get liveSessions_registrationCancelled => 'Registrierung abgebrochen';

  @override
  String get gateChannelPicker_gates => 'Tore (64)';

  @override
  String get gateChannelPicker_channels => 'Kanäle (36)';

  @override
  String get gateChannelPicker_search => 'Tore oder Kanäle suchen...';

  @override
  String get leaderboard_weekly => 'Wöchentlich';

  @override
  String get leaderboard_monthly => 'Monatlich';

  @override
  String get leaderboard_allTime => 'Alle Zeiten';

  @override
  String get ai_chatTitle => 'KI-Assistent';

  @override
  String get ai_askAi => 'KI fragen';

  @override
  String get ai_askAboutChart => 'KI über Ihr Chart fragen';

  @override
  String get ai_miniDescription =>
      'Erhalten Sie personalisierte Einblicke in Ihr Human Design';

  @override
  String get ai_startChatting => 'Chat starten';

  @override
  String get ai_welcomeTitle => 'Ihr HD-Assistent';

  @override
  String get ai_welcomeSubtitle =>
      'Fragen Sie mich alles über Ihr Human Design Chart. Ich kann Ihren Typ, Ihre Strategie, Autorität, Tore, Kanäle und mehr erklären.';

  @override
  String get ai_inputPlaceholder => 'Fragen über Ihr Chart...';

  @override
  String get ai_newConversation => 'Neue Konversation';

  @override
  String get ai_conversations => 'Konversationen';

  @override
  String get ai_noConversations => 'Noch keine Konversationen';

  @override
  String get ai_noConversationsMessage =>
      'Starten Sie eine Konversation mit der KI, um personalisierte Chart-Einblicke zu erhalten.';

  @override
  String get ai_deleteConversation => 'Konversation löschen';

  @override
  String get ai_deleteConversationConfirm =>
      'Sind Sie sicher, dass Sie diese Konversation löschen möchten?';

  @override
  String get ai_messagesExhausted => 'Kostenlose Nachrichten aufgebraucht';

  @override
  String get ai_upgradeForUnlimited =>
      'Upgraden Sie auf Premium für unbegrenzte KI-Konversationen über Ihr Human Design Chart.';

  @override
  String ai_usageCount(int used, int limit) {
    return '$used von $limit kostenlosen Nachrichten verwendet';
  }

  @override
  String get ai_errorGeneric =>
      'Etwas ist schief gelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get ai_errorNetwork =>
      'Der KI-Service konnte nicht erreicht werden. Überprüfen Sie Ihre Verbindung.';

  @override
  String get events_title => 'Community-Events';

  @override
  String get events_upcoming => 'Bevorstehend';

  @override
  String get events_past => 'Vergangen';

  @override
  String get events_create => 'Event erstellen';

  @override
  String get events_noUpcoming => 'Keine bevorstehenden Events';

  @override
  String get events_noUpcomingMessage =>
      'Erstellen Sie ein Event, um sich mit der HD-Community zu vernetzen!';

  @override
  String get events_online => 'Online';

  @override
  String get events_inPerson => 'Vor Ort';

  @override
  String get events_hybrid => 'Hybrid';

  @override
  String events_participants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Teilnehmer',
      one: '1 Teilnehmer',
    );
    return '$_temp0';
  }

  @override
  String get events_register => 'Registrieren';

  @override
  String get events_registered => 'Registriert';

  @override
  String get events_cancelRegistration => 'Registrierung abbrechen';

  @override
  String get events_registrationFull => 'Event voll';

  @override
  String get events_eventTitle => 'Event-Titel';

  @override
  String get events_eventDescription => 'Beschreibung';

  @override
  String get events_eventType => 'Event-Typ';

  @override
  String get events_startDate => 'Startdatum & -zeit';

  @override
  String get events_endDate => 'Enddatum & -zeit';

  @override
  String get events_location => 'Ort';

  @override
  String get events_virtualLink => 'Virtueller Meeting-Link';

  @override
  String get events_maxParticipants => 'Max. Teilnehmer';

  @override
  String get events_hdTypeFilter => 'HD-Typ-Filter';

  @override
  String get events_allTypes => 'Offen für alle Typen';

  @override
  String get events_created => 'Event erstellt!';

  @override
  String get events_deleted => 'Event gelöscht';

  @override
  String get events_notFound => 'Event nicht gefunden';

  @override
  String get chartOfDay_title => 'Chart des Tages';

  @override
  String get chartOfDay_featured => 'Empfohlenes Chart';

  @override
  String get chartOfDay_viewChart => 'Chart anzeigen';

  @override
  String get discussion_typeDiscussion => 'Typ-Diskussion';

  @override
  String get discussion_channelDiscussion => 'Kanal-Diskussion';

  @override
  String get ai_wantMoreInsights => 'Mehr AI-Einblicke gewünscht?';

  @override
  String ai_messagesPackTitle(int count) {
    return '$count Nachrichten';
  }

  @override
  String get ai_orSubscribe => 'oder abonnieren für unbegrenzt';

  @override
  String get ai_bestValue => 'Bester Wert';

  @override
  String get ai_getMoreMessages => 'Mehr Nachrichten erhalten';

  @override
  String ai_fromPrice(String price) {
    return 'Ab $price';
  }

  @override
  String ai_perMessage(String price) {
    return '$price/Nachricht';
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
