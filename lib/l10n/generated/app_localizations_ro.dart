// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appName => 'Inside Me';

  @override
  String get common_save => 'Salvează';

  @override
  String get common_cancel => 'Anulează';

  @override
  String get common_delete => 'Șterge';

  @override
  String get common_edit => 'Editează';

  @override
  String get common_done => 'Gata';

  @override
  String get common_next => 'Următorul';

  @override
  String get common_back => 'Înapoi';

  @override
  String get common_skip => 'Sari peste';

  @override
  String get common_continue => 'Continuă';

  @override
  String get common_loading => 'Se încarcă...';

  @override
  String get common_error => 'Eroare';

  @override
  String get common_retry => 'Reîncearcă';

  @override
  String get common_close => 'Închide';

  @override
  String get common_search => 'Caută';

  @override
  String get common_share => 'Distribuie';

  @override
  String get common_settings => 'Setări';

  @override
  String get common_logout => 'Deconectare';

  @override
  String get common_profile => 'Profil';

  @override
  String get common_type => 'Tip';

  @override
  String get common_strategy => 'Strategie';

  @override
  String get common_authority => 'Autoritate';

  @override
  String get common_definition => 'Definiție';

  @override
  String get common_create => 'Creează';

  @override
  String get common_viewFull => 'Vezi Complet';

  @override
  String get common_send => 'Trimite';

  @override
  String get common_like => 'Apreciază';

  @override
  String get common_reply => 'Răspunde';

  @override
  String get common_deleteConfirmation =>
      'Ești sigur că vrei să ștergi asta? Această acțiune nu poate fi anulată.';

  @override
  String get common_comingSoon => 'În curând!';

  @override
  String get nav_home => 'Acasă';

  @override
  String get nav_chart => 'Hartă';

  @override
  String get nav_today => 'Zilnic';

  @override
  String get nav_social => 'Social';

  @override
  String get nav_profile => 'Profil';

  @override
  String get nav_ai => 'IA';

  @override
  String get nav_more => 'Mai mult';

  @override
  String get nav_learn => 'Învață';

  @override
  String get affirmation_savedSuccess => 'Afirmație salvată!';

  @override
  String get affirmation_alreadySaved => 'Afirmație deja salvată';

  @override
  String get home_goodMorning => 'Bună dimineața';

  @override
  String get home_goodAfternoon => 'Bună ziua';

  @override
  String get home_goodEvening => 'Bună seara';

  @override
  String get home_yourDesign => 'Designul Tău';

  @override
  String get home_completeProfile => 'Completează Profilul';

  @override
  String get home_enterBirthData => 'Introdu Datele de Naștere';

  @override
  String get home_myChart => 'Harta Mea';

  @override
  String get home_savedCharts => 'Salvate';

  @override
  String get home_composite => 'Compozit';

  @override
  String get home_penta => 'Penta';

  @override
  String get home_friends => 'Prieteni';

  @override
  String get home_myBodygraph => 'Bodygraph-ul Meu';

  @override
  String get home_definedCenters => 'Centre Definite';

  @override
  String get home_activeChannels => 'Canale Active';

  @override
  String get home_activeGates => 'Porți Active';

  @override
  String get transit_today => 'Tranzitele de Astăzi';

  @override
  String get transit_sun => 'Soare';

  @override
  String get transit_earth => 'Pământ';

  @override
  String get transit_moon => 'Lună';

  @override
  String transit_gate(int number) {
    return 'Poarta $number';
  }

  @override
  String transit_newChannelsActivated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canale noi activate',
      one: '1 canal nou activat',
    );
    return '$_temp0';
  }

  @override
  String transit_gatesHighlighted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porți evidențiate',
      one: '1 poartă evidențiată',
    );
    return '$_temp0';
  }

  @override
  String get transit_noConnections =>
      'Nicio conexiune directă de tranzit astăzi';

  @override
  String get auth_signIn => 'Conectare';

  @override
  String get auth_signUp => 'Înregistrare';

  @override
  String get auth_signInWithApple => 'Conectează-te cu Apple';

  @override
  String get auth_signInWithGoogle => 'Conectează-te cu Google';

  @override
  String get auth_signInWithEmail => 'Conectează-te cu Email';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Parolă';

  @override
  String get auth_confirmPassword => 'Confirmă Parola';

  @override
  String get auth_forgotPassword => 'Ai uitat parola?';

  @override
  String get auth_noAccount => 'Nu ai cont?';

  @override
  String get auth_hasAccount => 'Ai deja un cont?';

  @override
  String get auth_termsAgree =>
      'Prin înregistrare, accepți Termenii și Condițiile și Politica de Confidențialitate';

  @override
  String get auth_welcomeBack => 'Bine ai revenit';

  @override
  String get auth_signInSubtitle =>
      'Conectează-te pentru a continua călătoria ta în Design Uman';

  @override
  String get auth_signInRequired => 'Autentificare Necesară';

  @override
  String get auth_signInToCalculateChart =>
      'Te rugăm să te conectezi pentru a calcula și salva harta ta de Design Uman.';

  @override
  String get auth_signInToCreateStory =>
      'Te rugăm să te conectezi pentru a distribui povești cu comunitatea.';

  @override
  String get auth_signUpSubtitle => 'Începe călătoria ta în Design Uman astăzi';

  @override
  String get auth_signUpWithApple => 'Înregistrează-te cu Apple';

  @override
  String get auth_signUpWithGoogle => 'Înregistrează-te cu Google';

  @override
  String get auth_signUpWithMicrosoft => 'Înregistrare cu Microsoft';

  @override
  String get auth_signUpWithFacebook => 'Înregistrare cu Facebook';

  @override
  String get auth_signInWithMicrosoft => 'Autentificare cu Microsoft';

  @override
  String get auth_signInWithFacebook => 'Autentificare cu Facebook';

  @override
  String get auth_oauthTermsNotice =>
      'Continuând, sunteți de acord cu Termenii de utilizare și Politica de confidențialitate.';

  @override
  String get auth_enterName => 'Introdu numele tău';

  @override
  String get auth_nameRequired => 'Numele este obligatoriu';

  @override
  String get auth_termsOfService => 'Termeni și Condiții';

  @override
  String get auth_privacyPolicy => 'Politica de Confidențialitate';

  @override
  String get auth_acceptTerms =>
      'Te rugăm să accepți Termenii și Condițiile pentru a continua';

  @override
  String get auth_resetPasswordTitle => 'Resetare Parolă';

  @override
  String get auth_resetPasswordPrompt =>
      'Introdu adresa ta de email și îți vom trimite un link pentru a-ți reseta parola.';

  @override
  String get auth_enterEmail => 'Introdu email-ul tău';

  @override
  String get auth_resetEmailSent => 'Email de resetare parolă trimis!';

  @override
  String get auth_name => 'Nume';

  @override
  String get auth_createAccount => 'Creează Cont';

  @override
  String get auth_iAgreeTo => 'Sunt de acord cu ';

  @override
  String get auth_and => ' și ';

  @override
  String get auth_birthInformation => 'Informații de Naștere';

  @override
  String get auth_calculateMyChart => 'Calculează Harta Mea';

  @override
  String get onboarding_welcome => 'Bine ai venit la Inside Me';

  @override
  String get onboarding_welcomeSubtitle =>
      'Descoperă planul tău energetic unic';

  @override
  String get onboarding_birthData => 'Introdu Datele Tale de Naștere';

  @override
  String get onboarding_birthDataSubtitle =>
      'Avem nevoie de acestea pentru a calcula harta ta';

  @override
  String get onboarding_birthDate => 'Data Nașterii';

  @override
  String get onboarding_birthTime => 'Ora Nașterii';

  @override
  String get onboarding_birthLocation => 'Locul Nașterii';

  @override
  String get onboarding_searchLocation => 'Caută un oraș...';

  @override
  String get onboarding_unknownTime => 'Nu știu ora nașterii';

  @override
  String get onboarding_timeImportance =>
      'Cunoașterea exactă a orei nașterii este importantă pentru o hartă precisă';

  @override
  String get onboarding_birthDataExplanation =>
      'Datele tale de naștere sunt folosite pentru a calcula harta ta unică de Design Uman. Cu cât informațiile sunt mai precise, cu atât harta ta va fi mai exactă.';

  @override
  String get onboarding_noTimeWarning =>
      'Fără o oră exactă a nașterii, unele detalii ale hărții (cum ar fi semnul ascendent și liniile exacte ale porților) pot să nu fie precise. Vom folosi amiaza ca valoare implicită.';

  @override
  String get onboarding_enterBirthTimeInstead =>
      'Introdu ora nașterii în schimb';

  @override
  String get onboarding_birthDataPrivacy =>
      'Datele tale de naștere sunt criptate și stocate în siguranță. Le poți actualiza sau șterge oricând din setările profilului.';

  @override
  String get onboarding_saveFailed => 'Salvarea datelor de naștere a eșuat';

  @override
  String get onboarding_fillAllFields =>
      'Te rugăm să completezi toate câmpurile necesare';

  @override
  String get onboarding_selectLanguage => 'Selectează Limba';

  @override
  String get onboarding_getStarted => 'Începe';

  @override
  String get onboarding_alreadyHaveAccount => 'Am deja un cont';

  @override
  String get onboarding_liveInAlignment =>
      'Descoperă planul tău energetic unic și trăiește în armonie cu adevărata ta natură.';

  @override
  String get chart_myChart => 'Harta Mea';

  @override
  String get chart_viewChart => 'Vezi Harta';

  @override
  String get chart_calculate => 'Calculează Harta';

  @override
  String get chart_recalculate => 'Recalculează';

  @override
  String get chart_share => 'Distribuie Harta';

  @override
  String get chart_createChart => 'Creează Hartă';

  @override
  String get chart_composite => 'Hartă Compozită';

  @override
  String get chart_transit => 'Tranzitele de Astăzi';

  @override
  String get chart_bodygraph => 'Bodygraph';

  @override
  String get chart_planets => 'Planete';

  @override
  String get chart_details => 'Detalii Hartă';

  @override
  String get chart_properties => 'Proprietăți';

  @override
  String get chart_gates => 'Porți';

  @override
  String get chart_channels => 'Canale';

  @override
  String get chart_noChartYet => 'Încă Fără Hartă';

  @override
  String get chart_addBirthDataPrompt =>
      'Adaugă datele tale de naștere pentru a genera harta ta unică de Design Uman.';

  @override
  String get chart_addBirthData => 'Adaugă Date de Naștere';

  @override
  String get chart_noActiveChannels => 'Niciun Canal Activ';

  @override
  String get chart_channelsFormedBothGates =>
      'Canalele se formează când ambele porți sunt definite.';

  @override
  String get chart_savedCharts => 'Hărți Salvate';

  @override
  String get chart_addChart => 'Adaugă Hartă';

  @override
  String get chart_noSavedCharts => 'Nicio Hartă Salvată';

  @override
  String get chart_noSavedChartsMessage =>
      'Creează hărți pentru tine și alții pentru a le salva aici.';

  @override
  String get chart_loadFailed => 'Încărcarea hărților a eșuat';

  @override
  String get chart_renameChart => 'Redenumește Harta';

  @override
  String get chart_rename => 'Redenumește';

  @override
  String get chart_renameFailed => 'Redenumirea hărții a eșuat';

  @override
  String get chart_deleteChart => 'Șterge Harta';

  @override
  String chart_deleteConfirm(String name) {
    return 'Ești sigur că vrei să ștergi \"$name\"? Această acțiune nu poate fi anulată.';
  }

  @override
  String get chart_deleteFailed => 'Ștergerea hărții a eșuat';

  @override
  String get chart_you => 'Tu';

  @override
  String get chart_personName => 'Nume';

  @override
  String get chart_enterPersonName => 'Introdu numele persoanei';

  @override
  String get chart_addChartDescription =>
      'Creează o hartă pentru altcineva introducând informațiile lor de naștere.';

  @override
  String get chart_calculateAndSave => 'Calculează & Salvează Harta';

  @override
  String get chart_saved => 'Hartă salvată cu succes';

  @override
  String get chart_consciousGates => 'Porți Conștiente';

  @override
  String get chart_unconsciousGates => 'Porți Inconștiente';

  @override
  String get chart_personalitySide =>
      'Partea Personalității - ceea ce ești conștient';

  @override
  String get chart_designSide =>
      'Partea Designului - ceea ce văd alții în tine';

  @override
  String get type_manifestor => 'Manifestor';

  @override
  String get type_generator => 'Generator';

  @override
  String get type_manifestingGenerator => 'Generator Manifestor';

  @override
  String get type_projector => 'Proiector';

  @override
  String get type_reflector => 'Reflector';

  @override
  String get type_manifestor_strategy => 'Să Informezi';

  @override
  String get type_generator_strategy => 'Să Răspunzi';

  @override
  String get type_manifestingGenerator_strategy => 'Să Răspunzi';

  @override
  String get type_projector_strategy => 'Să Aștepți Invitația';

  @override
  String get type_reflector_strategy => 'Să Aștepți un Ciclu Lunar';

  @override
  String get authority_emotional => 'Emoțională';

  @override
  String get authority_sacral => 'Sacrală';

  @override
  String get authority_splenic => 'Splenică';

  @override
  String get authority_ego => 'Ego/Inimă';

  @override
  String get authority_self => 'Auto-Proiectată';

  @override
  String get authority_environment => 'Mentală/Ambientală';

  @override
  String get authority_lunar => 'Lunară';

  @override
  String get definition_none => 'Fără Definiție';

  @override
  String get definition_single => 'Definiție Simplă';

  @override
  String get definition_split => 'Definiție Divizată';

  @override
  String get definition_tripleSplit => 'Divizare Triplă';

  @override
  String get definition_quadrupleSplit => 'Divizare Cvadrupla';

  @override
  String get profile_1_3 => '1/3 Investigator/Martir';

  @override
  String get profile_1_4 => '1/4 Investigator/Oportunist';

  @override
  String get profile_2_4 => '2/4 Eremit/Oportunist';

  @override
  String get profile_2_5 => '2/5 Eremit/Eretic';

  @override
  String get profile_3_5 => '3/5 Martir/Eretic';

  @override
  String get profile_3_6 => '3/6 Martir/Model de Rol';

  @override
  String get profile_4_6 => '4/6 Oportunist/Model de Rol';

  @override
  String get profile_4_1 => '4/1 Oportunist/Investigator';

  @override
  String get profile_5_1 => '5/1 Eretic/Investigator';

  @override
  String get profile_5_2 => '5/2 Eretic/Eremit';

  @override
  String get profile_6_2 => '6/2 Model de Rol/Eremit';

  @override
  String get profile_6_3 => '6/3 Model de Rol/Martir';

  @override
  String get center_head => 'Cap';

  @override
  String get center_ajna => 'Ajna';

  @override
  String get center_throat => 'Gât';

  @override
  String get center_g => 'G/Sinele';

  @override
  String get center_heart => 'Inimă/Ego';

  @override
  String get center_sacral => 'Sacral';

  @override
  String get center_solarPlexus => 'Plexul Solar';

  @override
  String get center_spleen => 'Splină';

  @override
  String get center_root => 'Rădăcină';

  @override
  String get center_defined => 'Definit';

  @override
  String get center_undefined => 'Nedefinit';

  @override
  String get section_type => 'Tip';

  @override
  String get section_strategy => 'Strategie';

  @override
  String get section_authority => 'Autoritate';

  @override
  String get section_profile => 'Profil';

  @override
  String get section_definition => 'Definiție';

  @override
  String get section_centers => 'Centre';

  @override
  String get section_channels => 'Canale';

  @override
  String get section_gates => 'Porți';

  @override
  String get section_conscious => 'Conștient (Personalitate)';

  @override
  String get section_unconscious => 'Inconștient (Design)';

  @override
  String get social_title => 'Social';

  @override
  String get social_thoughts => 'Gânduri';

  @override
  String get social_discover => 'Descoperă';

  @override
  String get social_groups => 'Grupuri';

  @override
  String get social_invite => 'Invită';

  @override
  String get social_createPost => 'Distribuie un gând...';

  @override
  String get social_noThoughtsYet => 'Încă fără gânduri';

  @override
  String get social_noThoughtsMessage =>
      'Fii primul care își împărtășește perspectivele despre Design Uman!';

  @override
  String get social_createGroup => 'Creează Grup';

  @override
  String get social_members => 'Membri';

  @override
  String get social_comments => 'Comentarii';

  @override
  String get social_addComment => 'Adaugă un comentariu...';

  @override
  String get social_noComments => 'Încă fără comentarii';

  @override
  String social_shareLimit(int remaining) {
    return 'Ai rămas $remaining distribuiri în această lună';
  }

  @override
  String get social_visibility => 'Vizibilitate';

  @override
  String get social_private => 'Privat';

  @override
  String get social_friendsOnly => 'Doar Prieteni';

  @override
  String get social_public => 'Public';

  @override
  String get social_shared => 'Distribuit';

  @override
  String get social_noGroupsYet => 'Încă Fără Grupuri';

  @override
  String get social_noGroupsMessage =>
      'Creează grupuri pentru a analiza dinamica echipei cu analiza Penta.';

  @override
  String get social_noSharedCharts => 'Nicio Hartă Distribuită';

  @override
  String get social_noSharedChartsMessage =>
      'Hărțile distribuite cu tine vor apărea aici.';

  @override
  String get social_createGroupPrompt =>
      'Creează un grup pentru a analiza dinamica echipei.';

  @override
  String get social_groupName => 'Nume Grup';

  @override
  String get social_groupNameHint => 'Familie, Echipă, etc.';

  @override
  String get social_groupDescription => 'Descriere (opțional)';

  @override
  String get social_groupDescriptionHint => 'Pentru ce este acest grup?';

  @override
  String social_groupCreated(String name) {
    return 'Grupul \"$name\" a fost creat!';
  }

  @override
  String get social_groupNameRequired =>
      'Te rugăm să introduci un nume pentru grup';

  @override
  String get social_createGroupFailed =>
      'Crearea grupului a eșuat. Te rugăm să încerci din nou.';

  @override
  String get social_noDescription => 'Fără descriere';

  @override
  String get social_admin => 'Administrator';

  @override
  String social_sharedBy(String name) {
    return 'Distribuit de $name';
  }

  @override
  String get social_loadGroupsFailed => 'Încărcarea grupurilor a eșuat';

  @override
  String get social_loadSharedFailed =>
      'Încărcarea hărților distribuite a eșuat';

  @override
  String get social_userNotFound => 'Utilizator negăsit';

  @override
  String get discovery_userNotFound => 'Utilizator negăsit';

  @override
  String get discovery_following => 'Urmărești';

  @override
  String get discovery_follow => 'Urmărește';

  @override
  String get discovery_sendMessage => 'Trimite Mesaj';

  @override
  String get discovery_about => 'Despre';

  @override
  String get discovery_humanDesign => 'Design Uman';

  @override
  String get discovery_type => 'Tip';

  @override
  String get discovery_profile => 'Profil';

  @override
  String get discovery_authority => 'Autoritate';

  @override
  String get discovery_compatibility => 'Compatibilitate';

  @override
  String get discovery_compatible => 'compatibil';

  @override
  String get discovery_followers => 'Urmăritori';

  @override
  String get discovery_followingLabel => 'Urmărești';

  @override
  String get discovery_noResults => 'Niciun utilizator găsit';

  @override
  String get discovery_noResultsMessage =>
      'Încearcă să ajustezi filtrele sau verifică mai târziu';

  @override
  String get userProfile_viewChart => 'Bodygraph';

  @override
  String get userProfile_chartPrivate => 'Această hartă este privată';

  @override
  String get userProfile_chartFriendsOnly =>
      'Deveniți urmăritori reciproci pentru a vedea această hartă';

  @override
  String get userProfile_chartFollowToView =>
      'Urmărește pentru a vedea această hartă';

  @override
  String get userProfile_publicProfile => 'Profil Public';

  @override
  String get userProfile_privateProfile => 'Profil Privat';

  @override
  String get userProfile_friendsOnlyProfile => 'Doar Prieteni';

  @override
  String get userProfile_followersList => 'Urmăritori';

  @override
  String get userProfile_followingList => 'Urmărești';

  @override
  String get userProfile_noFollowers => 'Încă fără urmăritori';

  @override
  String get userProfile_noFollowing => 'Nu urmărești pe nimeni încă';

  @override
  String get userProfile_thoughts => 'Gânduri';

  @override
  String get userProfile_noThoughts => 'Încă fără gânduri distribuite';

  @override
  String get userProfile_showAll => 'Arată Tot';

  @override
  String get popularCharts_title => 'Hărți Populare';

  @override
  String get popularCharts_subtitle => 'Cele mai urmărite hărți publice';

  @override
  String time_minutesAgo(int minutes) {
    return 'Acum ${minutes}m';
  }

  @override
  String time_hoursAgo(int hours) {
    return 'Acum ${hours}h';
  }

  @override
  String time_daysAgo(int days) {
    return 'Acum ${days}z';
  }

  @override
  String get transit_title => 'Tranzitele de Astăzi';

  @override
  String get transit_currentEnergies => 'Energii Curente';

  @override
  String get transit_sunGate => 'Poarta Soarelui';

  @override
  String get transit_earthGate => 'Poarta Pământului';

  @override
  String get transit_moonGate => 'Poarta Lunii';

  @override
  String get transit_activeGates => 'Porți de Tranzit Active';

  @override
  String get transit_activeChannels => 'Canale de Tranzit Active';

  @override
  String get transit_personalImpact => 'Impact Personal';

  @override
  String transit_gateActivated(int gate) {
    return 'Poarta $gate activată prin tranzit';
  }

  @override
  String transit_channelFormed(String channel) {
    return 'Canalul $channel format cu harta ta';
  }

  @override
  String get transit_noPersonalImpact =>
      'Nicio conexiune directă de tranzit astăzi';

  @override
  String get transit_viewFullTransit => 'Vezi Harta Completă de Tranzit';

  @override
  String get affirmation_title => 'Afirmația Zilei';

  @override
  String affirmation_forYourType(String type) {
    return 'Pentru $type Tău';
  }

  @override
  String affirmation_basedOnGate(int gate) {
    return 'Bazată pe Poarta $gate';
  }

  @override
  String get affirmation_refresh => 'Afirmație Nouă';

  @override
  String get affirmation_save => 'Salvează Afirmația';

  @override
  String get affirmation_saved => 'Afirmații Salvate';

  @override
  String get affirmation_share => 'Distribuie Afirmația';

  @override
  String get affirmation_notifications => 'Notificări Afirmație Zilnică';

  @override
  String get affirmation_notificationTime => 'Ora Notificării';

  @override
  String get lifestyle_today => 'Astăzi';

  @override
  String get lifestyle_insights => 'Perspective';

  @override
  String get lifestyle_journal => 'Jurnal';

  @override
  String get lifestyle_addJournalEntry => 'Adaugă Intrare în Jurnal';

  @override
  String get lifestyle_journalPrompt =>
      'Cum experimentezi designul tău astăzi?';

  @override
  String get lifestyle_noJournalEntries => 'Încă fără intrări în jurnal';

  @override
  String get lifestyle_mood => 'Stare';

  @override
  String get lifestyle_energy => 'Nivel de Energie';

  @override
  String get lifestyle_reflection => 'Reflecție';

  @override
  String get penta_title => 'Penta';

  @override
  String get penta_description => 'Analiză de grup pentru 3-5 persoane';

  @override
  String get penta_createNew => 'Creează Penta';

  @override
  String get penta_selectMembers => 'Selectează Membri';

  @override
  String get penta_minMembers => 'Minim 3 membri necesari';

  @override
  String get penta_maxMembers => 'Maxim 5 membri';

  @override
  String get penta_groupDynamics => 'Dinamica Grupului';

  @override
  String get penta_missingRoles => 'Roluri Lipsă';

  @override
  String get penta_strengths => 'Puncte Forte ale Grupului';

  @override
  String get penta_analysis => 'Analiză Penta';

  @override
  String get penta_clearAnalysis => 'Șterge Analiza';

  @override
  String get penta_infoText =>
      'Analiza Penta dezvăluie rolurile naturale care apar în grupuri mici de 3-5 persoane, arătând cum contribuie fiecare membru la dinamica echipei.';

  @override
  String get penta_calculating => 'Se calculează...';

  @override
  String get penta_calculate => 'Calculează Penta';

  @override
  String get penta_groupRoles => 'Roluri în Grup';

  @override
  String get penta_electromagneticConnections => 'Conexiuni Electromagnetice';

  @override
  String get penta_connectionsDescription =>
      'Conexiuni energetice speciale între membri care creează atracție și chimie.';

  @override
  String get penta_areasForAttention => 'Zone de Atenție';

  @override
  String get composite_title => 'Hartă Compozită';

  @override
  String get composite_infoText =>
      'O hartă compozită arată dinamica relației dintre două persoane, dezvăluind cum interacționează și se completează hărțile voastre.';

  @override
  String get composite_selectTwoCharts => 'Selectează 2 Hărți';

  @override
  String get composite_calculate => 'Analizează Conexiunea';

  @override
  String get composite_calculating => 'Se analizează...';

  @override
  String get composite_clearAnalysis => 'Șterge Analiza';

  @override
  String get composite_connectionTheme => 'Tema Conexiunii';

  @override
  String get composite_definedCenters => 'Definite';

  @override
  String get composite_undefinedCenters => 'Deschise';

  @override
  String get composite_score => 'Scor';

  @override
  String get composite_themeVeryBonded =>
      'Conexiune foarte strânsă - te poți simți profund interconectat, ceea ce poate fi intens';

  @override
  String get composite_themeBonded =>
      'Conexiune strânsă - sentiment puternic de unitate și energie partajată';

  @override
  String get composite_themeBalanced =>
      'Conexiune echilibrată - mix sănătos de unitate și independență';

  @override
  String get composite_themeIndependent =>
      'Conexiune independentă - mai mult spațiu pentru creștere individuală';

  @override
  String get composite_themeVeryIndependent =>
      'Conexiune foarte independentă - timpul intenționat de conexiune ajută la întărirea legăturii';

  @override
  String get composite_electromagnetic => 'Canale Electromagnetice';

  @override
  String get composite_electromagneticDesc =>
      'Atracție intensă - vă completați unul pe celălalt';

  @override
  String get composite_companionship => 'Canale de Tovărășie';

  @override
  String get composite_companionshipDesc =>
      'Confort și stabilitate - înțelegere partajată';

  @override
  String get composite_dominance => 'Canale de Dominație';

  @override
  String get composite_dominanceDesc => 'Unul predă/condiționează pe celălalt';

  @override
  String get composite_compromise => 'Canale de Compromis';

  @override
  String get composite_compromiseDesc =>
      'Tensiune naturală - necesită conștientizare';

  @override
  String get composite_noConnections => 'Fără Conexiuni de Canale';

  @override
  String get composite_noConnectionsDesc =>
      'Aceste hărți nu formează nicio conexiune directă de canale, dar pot exista totuși interacțiuni interesante între porți.';

  @override
  String get composite_noChartsTitle => 'Nicio Hartă Disponibilă';

  @override
  String get composite_noChartsDesc =>
      'Creează hărți pentru tine și alții pentru a compara dinamica relațiilor.';

  @override
  String get composite_needMoreCharts => 'Sunt Necesare Mai Multe Hărți';

  @override
  String get composite_needMoreChartsDesc =>
      'Ai nevoie de cel puțin 2 hărți pentru a analiza o relație. Adaugă altă hartă pentru a continua.';

  @override
  String get composite_selectTwoHint =>
      'Selectează 2 hărți pentru a analiza conexiunea lor';

  @override
  String get composite_selectOneMore => 'Selectează încă 1 hartă';

  @override
  String get premium_upgrade => 'Actualizează la Premium';

  @override
  String get premium_subscribe => 'Abonează-te';

  @override
  String get premium_restore => 'Restaurează Achizițiile';

  @override
  String get premium_features => 'Funcții Premium';

  @override
  String get premium_unlimitedShares => 'Distribuiri Nelimitate de Hărți';

  @override
  String get premium_groupCharts => 'Hărți de Grup';

  @override
  String get premium_advancedTransits => 'Analiză Avansată de Tranzite';

  @override
  String get premium_personalizedAffirmations => 'Afirmații Personalizate';

  @override
  String get premium_journalInsights => 'Perspective din Jurnal';

  @override
  String get premium_adFree => 'Experiență Fără Reclame';

  @override
  String get premium_monthly => 'Lunar';

  @override
  String get premium_yearly => 'Anual';

  @override
  String get premium_perMonth => '/lună';

  @override
  String get premium_perYear => '/an';

  @override
  String get premium_bestValue => 'Cel Mai Bun Preț';

  @override
  String get settings_appearance => 'Aspect';

  @override
  String get settings_language => 'Limba';

  @override
  String get settings_selectLanguage => 'Selectează Limba';

  @override
  String get settings_changeLanguage => 'Schimbă Limba';

  @override
  String get settings_theme => 'Temă';

  @override
  String get settings_selectTheme => 'Selectează Tema';

  @override
  String get settings_chartDisplay => 'Afișare Hartă';

  @override
  String get settings_showGateNumbers => 'Arată Numerele Porților';

  @override
  String get settings_showGateNumbersSubtitle =>
      'Afișează numerele porților pe bodygraph';

  @override
  String get settings_use24HourTime => 'Folosește Ora în Format 24h';

  @override
  String get settings_use24HourTimeSubtitle =>
      'Afișează ora în format 24 de ore';

  @override
  String get settings_feedback => 'Feedback';

  @override
  String get settings_hapticFeedback => 'Feedback Haptic';

  @override
  String get settings_hapticFeedbackSubtitle => 'Vibrație la interacțiuni';

  @override
  String get settings_account => 'Cont';

  @override
  String get settings_changePassword => 'Schimbă Parola';

  @override
  String get settings_deleteAccount => 'Șterge Contul';

  @override
  String get settings_deleteAccountConfirm =>
      'Ești sigur că vrei să ștergi contul? Această acțiune nu poate fi anulată și toate datele tale vor fi șterse permanent.';

  @override
  String get settings_appVersion => 'Versiune Aplicație';

  @override
  String get settings_rateApp => 'Evaluează Aplicația';

  @override
  String get settings_sendFeedback => 'Trimite Feedback';

  @override
  String get settings_telegramSupport => 'Suport Telegram';

  @override
  String get settings_telegramSupportSubtitle =>
      'Obține ajutor în grupul nostru de Telegram';

  @override
  String get settings_themeLight => 'Luminos';

  @override
  String get settings_themeDark => 'Întunecat';

  @override
  String get settings_themeSystem => 'Sistem';

  @override
  String get settings_notifications => 'Notificări';

  @override
  String get settings_privacy => 'Confidențialitate';

  @override
  String get settings_chartVisibility => 'Vizibilitate Hartă';

  @override
  String get settings_chartVisibilitySubtitle =>
      'Controlează cine poate vedea harta ta de Design Uman';

  @override
  String get settings_chartPrivate => 'Privat';

  @override
  String get settings_chartPrivateDesc => 'Doar tu poți vedea harta ta';

  @override
  String get settings_chartFriends => 'Prieteni';

  @override
  String get settings_chartFriendsDesc =>
      'Urmăritorii reciproci pot vedea harta ta';

  @override
  String get settings_chartPublic => 'Public';

  @override
  String get settings_chartPublicDesc => 'Urmăritorii tăi pot vedea harta ta';

  @override
  String get settings_about => 'Despre';

  @override
  String get settings_help => 'Ajutor & Suport';

  @override
  String get settings_terms => 'Termeni și Condiții';

  @override
  String get settings_privacyPolicy => 'Politica de Confidențialitate';

  @override
  String get settings_version => 'Versiune';

  @override
  String get settings_dailyTransits => 'Tranzite Zilnice';

  @override
  String get settings_dailyTransitsSubtitle =>
      'Primește actualizări zilnice despre tranzite';

  @override
  String get settings_gateChanges => 'Schimbări de Porți';

  @override
  String get settings_gateChangesSubtitle =>
      'Notifică când Soarele schimbă porțile';

  @override
  String get settings_socialActivity => 'Activitate Socială';

  @override
  String get settings_socialActivitySubtitle =>
      'Cereri de prietenie și hărți distribuite';

  @override
  String get settings_achievements => 'Realizări';

  @override
  String get settings_achievementsSubtitle =>
      'Deblocări de insigne și obiective';

  @override
  String get settings_deleteAccountWarning =>
      'Aceasta va șterge permanent toate datele tale, inclusiv hărți, postări și mesaje.';

  @override
  String get settings_deleteAccountFailed =>
      'Ștergerea contului a eșuat. Te rugăm să încerci din nou.';

  @override
  String get settings_passwordChanged => 'Parolă schimbată cu succes';

  @override
  String get settings_passwordChangeFailed =>
      'Schimbarea parolei a eșuat. Te rugăm să încerci din nou.';

  @override
  String get settings_feedbackSubject => 'Feedback Aplicație Inside Me';

  @override
  String get settings_feedbackBody =>
      'Bună,\n\nAș dori să împărtășesc următorul feedback despre Inside Me:\n\n';

  @override
  String get auth_newPassword => 'Parolă Nouă';

  @override
  String get auth_passwordRequired => 'Parola este obligatorie';

  @override
  String get auth_passwordTooShort =>
      'Parola trebuie să aibă cel puțin 8 caractere';

  @override
  String get auth_passwordsDoNotMatch => 'Parolele nu se potrivesc';

  @override
  String get settings_exportData => 'Exportă Datele Mele';

  @override
  String get settings_exportDataSubtitle =>
      'Descarcă o copie a tuturor datelor tale (GDPR)';

  @override
  String get settings_exportingData => 'Se pregătesc datele pentru export...';

  @override
  String get settings_exportDataSubject => 'Inside Me - Export Date Personale';

  @override
  String get settings_exportDataFailed =>
      'Exportul datelor a eșuat. Te rugăm să încerci din nou.';

  @override
  String get error_generic => 'Ceva nu a mers bine';

  @override
  String get error_network => 'Fără conexiune la internet';

  @override
  String get error_invalidEmail => 'Te rugăm să introduci un email valid';

  @override
  String get error_invalidPassword =>
      'Parola trebuie să aibă cel puțin 8 caractere';

  @override
  String get error_passwordMismatch => 'Parolele nu se potrivesc';

  @override
  String get error_birthDataRequired =>
      'Te rugăm să introduci datele tale de naștere';

  @override
  String get error_locationRequired => 'Te rugăm să selectezi locul nașterii';

  @override
  String get error_chartCalculation => 'Nu s-a putut calcula harta ta';

  @override
  String get profile_editProfile => 'Editează Profilul';

  @override
  String get profile_shareChart => 'Distribuie Harta Mea';

  @override
  String get profile_exportPdf => 'Exportă Harta PDF';

  @override
  String get profile_upgradePremium => 'Actualizează la Premium';

  @override
  String get profile_birthData => 'Date de Naștere';

  @override
  String get profile_chartSummary => 'Rezumat Hartă';

  @override
  String get profile_viewFullChart => 'Vezi Harta Completă';

  @override
  String get profile_signOut => 'Deconectare';

  @override
  String get profile_signOutConfirm => 'Ești sigur că vrei să te deconectezi?';

  @override
  String get profile_addBirthDataPrompt =>
      'Adaugă datele tale de naștere pentru a genera harta ta de Design Uman.';

  @override
  String get profile_addBirthDataToShare =>
      'Adaugă date de naștere pentru a distribui harta ta';

  @override
  String get profile_addBirthDataToExport =>
      'Adaugă date de naștere pentru a exporta harta ta';

  @override
  String get profile_exportFailed => 'Exportul PDF a eșuat';

  @override
  String get profile_signOutConfirmTitle => 'Deconectare';

  @override
  String get profile_loadFailed => 'Încărcarea profilului a eșuat';

  @override
  String get profile_defaultUserName => 'Utilizator Inside Me';

  @override
  String get profile_birthDate => 'Data';

  @override
  String get profile_birthTime => 'Ora';

  @override
  String get profile_birthLocation => 'Locație';

  @override
  String get profile_birthTimezone => 'Fus Orar';

  @override
  String get chart_chakras => 'Chakre';

  @override
  String get chakra_title => 'Energie Chakră';

  @override
  String get chakra_activated => 'Activată';

  @override
  String get chakra_inactive => 'Inactivă';

  @override
  String chakra_activatedCount(int count) {
    return '$count din 7 chakre activate';
  }

  @override
  String get chakra_hdMapping => 'Corespondență Centre HD';

  @override
  String get chakra_element => 'Element';

  @override
  String get chakra_location => 'Locație';

  @override
  String get chakra_root => 'Rădăcină';

  @override
  String get chakra_root_sanskrit => 'Muladhara';

  @override
  String get chakra_root_description =>
      'Înrădăcinare, supraviețuire și stabilitate';

  @override
  String get chakra_sacral => 'Sacrală';

  @override
  String get chakra_sacral_sanskrit => 'Svadhisthana';

  @override
  String get chakra_sacral_description => 'Creativitate, sexualitate și emocii';

  @override
  String get chakra_solarPlexus => 'Plexul Solar';

  @override
  String get chakra_solarPlexus_sanskrit => 'Manipura';

  @override
  String get chakra_solarPlexus_description =>
      'Putere personală, încredere și voință';

  @override
  String get chakra_heart => 'Inimă';

  @override
  String get chakra_heart_sanskrit => 'Anahata';

  @override
  String get chakra_heart_description => 'Dragoste, compasiune și conexiune';

  @override
  String get chakra_throat => 'Gât';

  @override
  String get chakra_throat_sanskrit => 'Vishuddha';

  @override
  String get chakra_throat_description => 'Comunicare, expresie și adevăr';

  @override
  String get chakra_thirdEye => 'Al Treilea Ochi';

  @override
  String get chakra_thirdEye_sanskrit => 'Ajna';

  @override
  String get chakra_thirdEye_description =>
      'Intuiție, perspicacitate și imaginație';

  @override
  String get chakra_crown => 'Coroană';

  @override
  String get chakra_crown_sanskrit => 'Sahasrara';

  @override
  String get chakra_crown_description => 'Conexiune spirituală și conștiință';

  @override
  String get quiz_title => 'Chestionare';

  @override
  String get quiz_yourProgress => 'Progresul Tău';

  @override
  String quiz_quizzesCompleted(int count) {
    return '$count chestionare completate';
  }

  @override
  String get quiz_accuracy => 'Precizie';

  @override
  String get quiz_streak => 'Serie';

  @override
  String get quiz_all => 'Toate';

  @override
  String get quiz_difficulty => 'Dificultate';

  @override
  String get quiz_beginner => 'Începător';

  @override
  String get quiz_intermediate => 'Intermediar';

  @override
  String get quiz_advanced => 'Avansat';

  @override
  String quiz_questions(int count) {
    return '$count întrebări';
  }

  @override
  String quiz_points(int points) {
    return '+$points pct';
  }

  @override
  String get quiz_completed => 'Completat';

  @override
  String get quiz_noQuizzes => 'Niciun chestionar disponibil';

  @override
  String get quiz_checkBackLater => 'Verifică mai târziu pentru conținut nou';

  @override
  String get quiz_startQuiz => 'Începe Chestionarul';

  @override
  String get quiz_tryAgain => 'Încearcă Din Nou';

  @override
  String get quiz_backToQuizzes => 'Înapoi la Chestionare';

  @override
  String get quiz_shareResults => 'Distribuie Rezultatele';

  @override
  String get quiz_yourBest => 'Cel Mai Bun Scor';

  @override
  String get quiz_perfectScore => 'Scor Perfect!';

  @override
  String get quiz_newBest => 'Scor Nou Maxim!';

  @override
  String get quiz_streakExtended => 'Serie Extinsă!';

  @override
  String quiz_questionOf(int current, int total) {
    return 'Întrebarea $current din $total';
  }

  @override
  String quiz_correct(int count) {
    return '$count corecte';
  }

  @override
  String get quiz_submitAnswer => 'Trimite Răspunsul';

  @override
  String get quiz_nextQuestion => 'Următoarea Întrebare';

  @override
  String get quiz_seeResults => 'Vezi Rezultatele';

  @override
  String get quiz_exitQuiz => 'Ieși din Chestionar?';

  @override
  String get quiz_exitWarning => 'Progresul tău va fi pierdut dacă ieși acum.';

  @override
  String get quiz_exit => 'Ieși';

  @override
  String get quiz_timesUp => 'Timpul Expirat!';

  @override
  String get quiz_timesUpMessage =>
      'Ai rămas fără timp. Progresul tău va fi trimis.';

  @override
  String get quiz_excellent => 'Excelent!';

  @override
  String get quiz_goodJob => 'Bună Treabă!';

  @override
  String get quiz_keepLearning => 'Continuă să Înveți!';

  @override
  String get quiz_keepPracticing => 'Continuă să Exersezi!';

  @override
  String get quiz_masteredTopic => 'Ai stăpânit acest subiect!';

  @override
  String get quiz_strongUnderstanding => 'Ai o înțelegere solidă.';

  @override
  String get quiz_onRightTrack => 'Ești pe drumul cel bun.';

  @override
  String get quiz_reviewExplanations =>
      'Revizuiește explicațiile pentru a te îmbunătăți.';

  @override
  String get quiz_studyMaterial => 'Studiază materialul și încearcă din nou.';

  @override
  String get quiz_attemptHistory => 'Istoric Încercări';

  @override
  String get quiz_statistics => 'Statistici Chestionare';

  @override
  String get quiz_totalQuizzes => 'Chestionare';

  @override
  String get quiz_totalQuestions => 'Întrebări';

  @override
  String get quiz_bestStreak => 'Cea Mai Bună Serie';

  @override
  String quiz_strongest(String category) {
    return 'Cel mai puternic: $category';
  }

  @override
  String quiz_needsWork(String category) {
    return 'Necesită îmbunătățire: $category';
  }

  @override
  String get quiz_category_types => 'Tipuri';

  @override
  String get quiz_category_centers => 'Centre';

  @override
  String get quiz_category_authorities => 'Autorități';

  @override
  String get quiz_category_profiles => 'Profiluri';

  @override
  String get quiz_category_gates => 'Porți';

  @override
  String get quiz_category_channels => 'Canale';

  @override
  String get quiz_category_definitions => 'Definiții';

  @override
  String get quiz_category_general => 'General';

  @override
  String get quiz_explanation => 'Explicație';

  @override
  String get quiz_quizzes => 'Chestionare';

  @override
  String get quiz_questionsLabel => 'Întrebări';

  @override
  String get quiz_shareProgress => 'Distribuie Progresul';

  @override
  String get quiz_shareProgressSubject =>
      'Progresul Meu în Învățarea Designului Uman';

  @override
  String get quiz_sharePerfect =>
      'Am obținut un scor perfect! Stăpânesc Design Uman.';

  @override
  String get quiz_shareExcellent =>
      'Mă descurc foarte bine în călătoria mea de învățare a Designului Uman!';

  @override
  String get quiz_shareGoodJob =>
      'Învăț despre Design Uman. Fiecare chestionar mă ajută să cresc!';

  @override
  String quiz_shareSubject(String quizTitle, int score) {
    return 'Am obținut $score% la \"$quizTitle\" - Chestionar Design Uman';
  }

  @override
  String get quiz_failedToLoadStats => 'Încărcarea statisticilor a eșuat';

  @override
  String get planetary_personality => 'Personalitate';

  @override
  String get planetary_design => 'Design';

  @override
  String get planetary_consciousBirth => 'Conștient · Naștere';

  @override
  String get planetary_unconsciousPrenatal => 'Inconștient · 88° Prenatal';

  @override
  String get gamification_yourProgress => 'Progresul Tău';

  @override
  String get gamification_level => 'Nivel';

  @override
  String get gamification_points => 'pct';

  @override
  String get gamification_viewAll => 'Vezi Tot';

  @override
  String get gamification_allChallengesComplete =>
      'Toate provocările zilnice completate!';

  @override
  String get gamification_dailyChallenge => 'Provocare Zilnică';

  @override
  String get gamification_achievements => 'Realizări';

  @override
  String get gamification_challenges => 'Provocări';

  @override
  String get gamification_leaderboard => 'Clasament';

  @override
  String get gamification_streak => 'Serie';

  @override
  String get gamification_badges => 'Insigne';

  @override
  String get gamification_earnedBadge => 'Ai câștigat o insignă!';

  @override
  String get gamification_claimReward => 'Revendică Recompensa';

  @override
  String get gamification_completed => 'Completat';

  @override
  String get common_copy => 'Copiază';

  @override
  String get share_myShares => 'Distribuirile Mele';

  @override
  String get share_createNew => 'Creează Nou';

  @override
  String get share_newLink => 'Link Nou';

  @override
  String get share_noShares => 'Niciun Link Distribuit';

  @override
  String get share_noSharesMessage =>
      'Creează linkuri de distribuire pentru a permite altora să vadă harta ta fără a fi nevoie de cont.';

  @override
  String get share_createFirst => 'Creează Primul Tău Link';

  @override
  String share_activeLinks(int count) {
    return '$count Linkuri Active';
  }

  @override
  String share_expiredLinks(int count) {
    return '$count Expirate';
  }

  @override
  String get share_clearExpired => 'Șterge';

  @override
  String get share_clearExpiredTitle => 'Șterge Linkurile Expirate';

  @override
  String share_clearExpiredMessage(int count) {
    return 'Aceasta va elimina $count linkuri expirate din istoricul tău.';
  }

  @override
  String get share_clearAll => 'Șterge Tot';

  @override
  String get share_expiredCleared => 'Linkuri expirate șterse';

  @override
  String get share_linkCopied => 'Link copiat în clipboard';

  @override
  String get share_revokeTitle => 'Revocă Link';

  @override
  String get share_revokeMessage =>
      'Aceasta va dezactiva permanent acest link de distribuire. Oricine are linkul nu va mai putea vedea harta ta.';

  @override
  String get share_revoke => 'Revocă';

  @override
  String get share_linkRevoked => 'Link revocat';

  @override
  String get share_totalLinks => 'Total';

  @override
  String get share_active => 'Active';

  @override
  String get share_totalViews => 'Vizualizări';

  @override
  String get share_chartLink => 'Distribuire Hartă';

  @override
  String get share_transitLink => 'Distribuire Tranzit';

  @override
  String get share_compatibilityLink => 'Raport de Compatibilitate';

  @override
  String get share_link => 'Link de Distribuire';

  @override
  String share_views(int count) {
    return '$count vizualizări';
  }

  @override
  String get share_expired => 'Expirat';

  @override
  String get share_activeLabel => 'Activ';

  @override
  String share_expiredOn(String date) {
    return 'Expirat $date';
  }

  @override
  String share_expiresIn(String time) {
    return 'Expiră în $time';
  }

  @override
  String get auth_emailNotConfirmed => 'Te rugăm să confirmați email-ul';

  @override
  String get auth_resendConfirmation => 'Retrimite Email de Confirmare';

  @override
  String get auth_confirmationSent => 'Email de confirmare trimis';

  @override
  String get auth_checkEmail => 'Verifică email-ul pentru linkul de confirmare';

  @override
  String get auth_checkYourEmail => 'Verifică Email-ul';

  @override
  String get auth_confirmationLinkSent => 'Am trimis un link de confirmare la:';

  @override
  String get auth_clickLinkToActivate =>
      'Te rugăm să apeși pe linkul din email pentru a-ți activa contul.';

  @override
  String get auth_goToSignIn => 'Mergi la Conectare';

  @override
  String get auth_returnToHome => 'Înapoi la Pagina Principală';

  @override
  String get hashtags_explore => 'Explorează Hashtag-uri';

  @override
  String get hashtags_trending => 'În Tendințe';

  @override
  String get hashtags_popular => 'Populare';

  @override
  String get hashtags_hdTopics => 'Subiecte HD';

  @override
  String get hashtags_noTrending => 'Încă fără hashtag-uri în tendințe';

  @override
  String get hashtags_noPopular => 'Încă fără hashtag-uri populare';

  @override
  String get hashtags_noHdTopics => 'Încă fără subiecte HD';

  @override
  String get hashtag_noPosts => 'Încă fără postări';

  @override
  String get hashtag_beFirst => 'Fii primul care postează cu acest hashtag!';

  @override
  String hashtag_postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postări',
      one: '1 postare',
    );
    return '$_temp0';
  }

  @override
  String hashtag_recentPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postări astăzi',
      one: '1 postare astăzi',
    );
    return '$_temp0';
  }

  @override
  String get feed_forYou => 'Pentru Tine';

  @override
  String get feed_trending => 'În Tendințe';

  @override
  String get feed_hdTopics => 'Subiecte HD';

  @override
  String feed_gateTitle(int number) {
    return 'Poarta $number';
  }

  @override
  String feed_gatePosts(int number) {
    return 'Postări despre Poarta $number';
  }

  @override
  String get transit_events_title => 'Evenimente de Tranzit';

  @override
  String get transit_events_happening => 'Acum';

  @override
  String get transit_events_upcoming => 'Viitoare';

  @override
  String get transit_events_past => 'Evenimente Trecute';

  @override
  String get transit_events_noCurrentEvents =>
      'Niciun eveniment în desfășurare acum';

  @override
  String get transit_events_noUpcomingEvents =>
      'Niciun eveniment viitor programat';

  @override
  String get transit_events_noPastEvents => 'Niciun eveniment trecut';

  @override
  String get transit_events_live => 'LIVE';

  @override
  String get transit_events_join => 'Alătură-te';

  @override
  String get transit_events_joined => 'Alăturat';

  @override
  String get transit_events_leave => 'Pleacă';

  @override
  String get transit_events_participating => 'participă';

  @override
  String get transit_events_posts => 'postări';

  @override
  String get transit_events_viewInsights => 'Vezi Perspective';

  @override
  String transit_events_endsIn(String time) {
    return 'Se termină în $time';
  }

  @override
  String transit_events_startsIn(String time) {
    return 'Începe în $time';
  }

  @override
  String get transit_events_notFound => 'Eveniment negăsit';

  @override
  String get transit_events_communityPosts => 'Postări din Comunitate';

  @override
  String get transit_events_noPosts =>
      'Încă fără postări pentru acest eveniment';

  @override
  String get transit_events_shareExperience => 'Distribuie Experiența';

  @override
  String get transit_events_participants => 'Participanți';

  @override
  String get transit_events_duration => 'Durată';

  @override
  String get transit_events_eventEnded => 'Acest eveniment s-a încheiat';

  @override
  String get transit_events_youreParticipating => 'Participi!';

  @override
  String transit_events_experiencingWith(int count) {
    return 'Experimentezi acest tranzit cu $count alții';
  }

  @override
  String get transit_events_joinCommunity => 'Alătură-te Comunității';

  @override
  String get transit_events_shareYourExperience =>
      'Distribuie experiența ta și conectează-te cu alții';

  @override
  String get activity_title => 'Activitatea Prietenilor';

  @override
  String get activity_noActivities => 'Încă fără activitate a prietenilor';

  @override
  String get activity_followFriends =>
      'Urmărește prieteni pentru a le vedea realizările și obiectivele aici!';

  @override
  String get activity_findFriends => 'Găsește Prieteni';

  @override
  String get activity_celebrate => 'Celebrează';

  @override
  String get activity_celebrated => 'Celebrat';

  @override
  String get cancel => 'Anulează';

  @override
  String get create => 'Creează';

  @override
  String get groupChallenges_title => 'Provocări de Grup';

  @override
  String get groupChallenges_myTeams => 'Echipele Mele';

  @override
  String get groupChallenges_challenges => 'Provocări';

  @override
  String get groupChallenges_leaderboard => 'Clasament';

  @override
  String get groupChallenges_createTeam => 'Creează Echipă';

  @override
  String get groupChallenges_teamName => 'Nume Echipă';

  @override
  String get groupChallenges_teamNameHint => 'Introdu un nume pentru echipă';

  @override
  String get groupChallenges_teamDescription => 'Descriere';

  @override
  String get groupChallenges_teamDescriptionHint => 'Despre ce este echipa ta?';

  @override
  String get groupChallenges_teamCreated => 'Echipă creată cu succes!';

  @override
  String get groupChallenges_noTeams => 'Încă Fără Echipe';

  @override
  String get groupChallenges_noTeamsDescription =>
      'Creează sau alătură-te unei echipe pentru a concura în provocări de grup!';

  @override
  String groupChallenges_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membri',
      one: '1 membru',
    );
    return '$_temp0';
  }

  @override
  String groupChallenges_points(int points) {
    return '$points pct';
  }

  @override
  String get groupChallenges_noChallenges => 'Nicio Provocare Activă';

  @override
  String get groupChallenges_active => 'Active';

  @override
  String get groupChallenges_upcoming => 'Viitoare';

  @override
  String groupChallenges_reward(int points) {
    return '$points pct recompensă';
  }

  @override
  String groupChallenges_teamsEnrolled(String count) {
    return '$count echipe';
  }

  @override
  String groupChallenges_participants(String count) {
    return '$count participanți';
  }

  @override
  String groupChallenges_endsIn(String time) {
    return 'Se termină în $time';
  }

  @override
  String get groupChallenges_weekly => 'Săptămânal';

  @override
  String get groupChallenges_monthly => 'Lunar';

  @override
  String get groupChallenges_allTime => 'Tot Timpul';

  @override
  String get groupChallenges_noTeamsOnLeaderboard =>
      'Încă fără echipe în clasament';

  @override
  String get groupChallenges_pts => 'pct';

  @override
  String get groupChallenges_teamNotFound => 'Echipă negăsită';

  @override
  String get groupChallenges_members => 'Membri';

  @override
  String get groupChallenges_totalPoints => 'Puncte Totale';

  @override
  String get groupChallenges_joined => 'Alăturat';

  @override
  String get groupChallenges_join => 'Alătură-te';

  @override
  String get groupChallenges_status => 'Stare';

  @override
  String get groupChallenges_about => 'Despre';

  @override
  String get groupChallenges_noMembers => 'Încă fără membri';

  @override
  String get groupChallenges_admin => 'Administrator';

  @override
  String groupChallenges_contributed(int points) {
    return '$points pct contribuite';
  }

  @override
  String get groupChallenges_joinedTeam => 'Te-ai alăturat echipei cu succes!';

  @override
  String get groupChallenges_leaveTeam => 'Părăsește Echipa';

  @override
  String get groupChallenges_leaveConfirmation =>
      'Ești sigur că vrei să părăsești această echipă? Punctele tale contribuite vor rămâne la echipă.';

  @override
  String get groupChallenges_leave => 'Pleacă';

  @override
  String get groupChallenges_leftTeam => 'Ai părăsit echipa';

  @override
  String get groupChallenges_challengeDetails => 'Detalii Provocare';

  @override
  String get groupChallenges_challengeNotFound => 'Provocare negăsită';

  @override
  String get groupChallenges_target => 'Obiectiv';

  @override
  String get groupChallenges_starts => 'Începe';

  @override
  String get groupChallenges_ends => 'Se Termină';

  @override
  String get groupChallenges_hdTypes => 'Tipuri HD';

  @override
  String get groupChallenges_noTeamsToEnroll => 'Nicio Echipă de Înscris';

  @override
  String get groupChallenges_createTeamToJoin =>
      'Creează mai întâi o echipă pentru a te înscrie în provocări';

  @override
  String get groupChallenges_enrollTeam => 'Înscrie o Echipă';

  @override
  String get groupChallenges_enrolled => 'Înscris';

  @override
  String get groupChallenges_enroll => 'Înscrie-te';

  @override
  String get groupChallenges_teamEnrolled => 'Echipă înscrisă cu succes!';

  @override
  String get groupChallenges_noTeamsEnrolled => 'Încă fără echipe înscrise';

  @override
  String get circles_title => 'Cercuri de Compatibilitate';

  @override
  String get circles_myCircles => 'Cercurile Mele';

  @override
  String get circles_invitations => 'Invitații';

  @override
  String get circles_create => 'Creează Cerc';

  @override
  String get circles_selectIcon => 'Selectează o pictogramă';

  @override
  String get circles_name => 'Nume Cerc';

  @override
  String get circles_nameHint => 'Familie, Echipă, Prieteni...';

  @override
  String get circles_description => 'Descriere';

  @override
  String get circles_descriptionHint => 'Pentru ce este acest cerc?';

  @override
  String get circles_created => 'Cerc creat cu succes!';

  @override
  String get circles_noCircles => 'Încă Fără Cercuri';

  @override
  String get circles_noCirclesDescription =>
      'Creează un cerc pentru a analiza compatibilitatea cu prieteni, familie sau membri echipei.';

  @override
  String get circles_suggestions => 'Start Rapid';

  @override
  String circles_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membri',
      one: '1 membru',
    );
    return '$_temp0';
  }

  @override
  String get circles_private => 'Privat';

  @override
  String get circles_noInvitations => 'Fără Invitații';

  @override
  String get circles_noInvitationsDescription =>
      'Invitațiile la cercuri pe care le primești vor apărea aici.';

  @override
  String circles_invitedBy(String name) {
    return 'Invitat de $name';
  }

  @override
  String get circles_decline => 'Refuză';

  @override
  String get circles_accept => 'Acceptă';

  @override
  String get circles_invitationDeclined => 'Invitație refuzată';

  @override
  String get circles_invitationAccepted => 'Te-ai alăturat cercului!';

  @override
  String get circles_notFound => 'Cerc negăsit';

  @override
  String get circles_invite => 'Invită Membru';

  @override
  String get circles_members => 'Membri';

  @override
  String get circles_analysis => 'Analiză';

  @override
  String get circles_feed => 'Feed';

  @override
  String get circles_inviteMember => 'Invită Membru';

  @override
  String get circles_sendInvite => 'Trimite Invitația';

  @override
  String get circles_invitationSent => 'Invitație trimisă!';

  @override
  String get circles_invitationFailed => 'Trimiterea invitației a eșuat';

  @override
  String get circles_deleteTitle => 'Șterge Cercul';

  @override
  String circles_deleteConfirmation(String name) {
    return 'Ești sigur că vrei să ștergi \"$name\"? Această acțiune nu poate fi anulată.';
  }

  @override
  String get circles_deleted => 'Cerc șters';

  @override
  String get circles_noMembers => 'Încă fără membri';

  @override
  String get circles_noAnalysis => 'Încă Fără Analiză';

  @override
  String get circles_runAnalysis =>
      'Rulează o analiză de compatibilitate pentru a vedea cum interacționează membrii cercului tău.';

  @override
  String get circles_needMoreMembers =>
      'Adaugă cel puțin 2 membri pentru a rula o analiză.';

  @override
  String get circles_analyzeCompatibility => 'Analizează Compatibilitatea';

  @override
  String get circles_harmonyScore => 'Scor de Armonie';

  @override
  String get circles_typeDistribution => 'Distribuția Tipurilor';

  @override
  String get circles_electromagneticConnections => 'Conexiuni Electromagnetice';

  @override
  String get circles_electromagneticDesc =>
      'Atracție intensă - vă completați unul pe celălalt';

  @override
  String get circles_companionshipConnections => 'Conexiuni de Tovărășie';

  @override
  String get circles_companionshipDesc =>
      'Confort și stabilitate - înțelegere partajată';

  @override
  String get circles_groupStrengths => 'Puncte Forte ale Grupului';

  @override
  String get circles_areasForGrowth => 'Zone de Creștere';

  @override
  String get circles_writePost => 'Distribuie ceva cu cercul tău...';

  @override
  String get circles_noPosts => 'Încă Fără Postări';

  @override
  String get circles_beFirstToPost =>
      'Fii primul care distribuie ceva cu cercul tău!';

  @override
  String get experts_title => 'Experți HD';

  @override
  String get experts_becomeExpert => 'Devino Expert';

  @override
  String get experts_filterBySpecialization => 'Filtrează după Specializare';

  @override
  String get experts_allExperts => 'Toți Experții';

  @override
  String get experts_experts => 'Experți';

  @override
  String get experts_noExperts => 'Niciun expert găsit';

  @override
  String get experts_featured => 'Experți Remarcabili';

  @override
  String experts_followers(int count) {
    return '$count urmăritori';
  }

  @override
  String get experts_notFound => 'Expert negăsit';

  @override
  String get experts_following => 'Urmărești';

  @override
  String get experts_follow => 'Urmărește';

  @override
  String get experts_about => 'Despre';

  @override
  String get experts_specializations => 'Specializări';

  @override
  String get experts_credentials => 'Credențiale';

  @override
  String get experts_reviews => 'Recenzii';

  @override
  String get experts_writeReview => 'Scrie Recenzie';

  @override
  String get experts_reviewContent => 'Recenzia Ta';

  @override
  String get experts_reviewHint =>
      'Distribuie experiența ta de lucru cu acest expert...';

  @override
  String get experts_submitReview => 'Trimite Recenzia';

  @override
  String get experts_reviewSubmitted => 'Recenzie trimisă cu succes!';

  @override
  String get experts_noReviews => 'Încă fără recenzii';

  @override
  String get experts_followersLabel => 'Urmăritori';

  @override
  String get experts_rating => 'Evaluare';

  @override
  String get experts_years => 'Ani';

  @override
  String get learningPaths_title => 'Trasee de Învățare';

  @override
  String get learningPaths_explore => 'Explorează';

  @override
  String get learningPaths_inProgress => 'În Progres';

  @override
  String get learningPaths_completed => 'Completate';

  @override
  String get learningPaths_featured => 'Trasee Recomandate';

  @override
  String get learningPaths_allPaths => 'Toate Traseele';

  @override
  String get learningPaths_noPathsExplore =>
      'Niciun traseu de învățare disponibil';

  @override
  String get learningPaths_noPathsInProgress => 'Niciun Traseu În Progres';

  @override
  String get learningPaths_noPathsInProgressDescription =>
      'Înscrie-te într-un traseu de învățare pentru a-ți începe călătoria!';

  @override
  String get learningPaths_browsePaths => 'Răsfoiește Traseele';

  @override
  String get learningPaths_noPathsCompleted => 'Niciun Traseu Completat';

  @override
  String get learningPaths_noPathsCompletedDescription =>
      'Completează trasee de învățare pentru a le vedea aici!';

  @override
  String learningPaths_enrolled(int count) {
    return '$count înscriși';
  }

  @override
  String learningPaths_stepsCount(int count) {
    return '$count pași';
  }

  @override
  String learningPaths_progress(int completed, int total) {
    return '$completed din $total pași';
  }

  @override
  String get learningPaths_resume => 'Continuă';

  @override
  String learningPaths_completedOn(String date) {
    return 'Completat pe $date';
  }

  @override
  String get learningPathNotFound => 'Traseu de învățare negăsit';

  @override
  String learningPathMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String learningPathSteps(int count) {
    return '$count pași';
  }

  @override
  String learningPathBy(String author) {
    return 'De $author';
  }

  @override
  String learningPathEnrolled(int count) {
    return '$count înscriși';
  }

  @override
  String learningPathCompleted(int count) {
    return '$count completați';
  }

  @override
  String get learningPathEnroll => 'Începe Învățarea';

  @override
  String get learningPathYourProgress => 'Progresul Tău';

  @override
  String get learningPathCompletedBadge => 'Completat';

  @override
  String learningPathProgressText(int completed, int total) {
    return '$completed din $total pași completați';
  }

  @override
  String get learningPathStepsTitle => 'Pași de Învățare';

  @override
  String get learningPathEnrollTitle => 'Începi Acest Traseu?';

  @override
  String learningPathEnrollMessage(String title) {
    return 'Vei fi înscris în \"$title\" și poți urmări progresul pe măsură ce completezi fiecare pas.';
  }

  @override
  String get learningPathViewContent => 'Vezi Conținutul';

  @override
  String get learningPathMarkComplete => 'Marchează ca Completat';

  @override
  String get learningPathStepCompleted => 'Pas completat!';

  @override
  String get thought_title => 'Gânduri';

  @override
  String get thought_feedTitle => 'Gânduri';

  @override
  String get thought_createNew => 'Distribuie un Gând';

  @override
  String get thought_emptyFeed => 'Feed-ul tău de gânduri este gol';

  @override
  String get thought_emptyFeedMessage =>
      'Urmărește oameni sau distribuie un gând pentru a începe';

  @override
  String get thought_regenerate => 'Regenerează';

  @override
  String thought_regeneratedFrom(String username) {
    return 'Regenerat de la @$username';
  }

  @override
  String get thought_regenerateSuccess => 'Gând regenerat pe peretele tău!';

  @override
  String get thought_regenerateConfirm => 'Regenerezi acest gând?';

  @override
  String get thought_regenerateDescription =>
      'Aceasta va distribui acest gând pe peretele tău, creditând autorul original.';

  @override
  String get thought_addComment => 'Adaugă un comentariu (opțional)';

  @override
  String thought_regenerateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count regenerări',
      one: '1 regenerare',
    );
    return '$_temp0';
  }

  @override
  String get thought_cannotRegenerateOwn => 'Nu poți regenera propriul gând';

  @override
  String get thought_alreadyRegenerated => 'Ai regenerat deja acest gând';

  @override
  String get thought_postDetail => 'Gând';

  @override
  String get thought_noComments =>
      'Încă fără comentarii. Fii primul care comentează!';

  @override
  String thought_replyingTo(String username) {
    return 'Răspunzi lui $username';
  }

  @override
  String get thought_writeReply => 'Scrie un răspuns...';

  @override
  String get thought_commentPlaceholder => 'Adaugă un comentariu...';

  @override
  String get messages_title => 'Mesaje';

  @override
  String get messages_conversation => 'Conversație';

  @override
  String get messages_loading => 'Se încarcă...';

  @override
  String get messages_muteNotifications => 'Dezactivează Notificările';

  @override
  String get messages_notificationsMuted => 'Notificări dezactivate';

  @override
  String get messages_blockUser => 'Blochează Utilizatorul';

  @override
  String get messages_blockUserConfirm =>
      'Ești sigur că vrei să blochezi acest utilizator? Nu vei mai primi mesaje de la el.';

  @override
  String get messages_userBlocked => 'Utilizator blocat';

  @override
  String get messages_block => 'Blochează';

  @override
  String get messages_deleteConversation => 'Șterge Conversația';

  @override
  String get messages_deleteConversationConfirm =>
      'Ești sigur că vrei să ștergi această conversație? Această acțiune nu poate fi anulată.';

  @override
  String get messages_conversationDeleted => 'Conversație ștearsă';

  @override
  String get messages_startConversation => 'Începe conversația!';

  @override
  String get profile_takePhoto => 'Fă o Fotografie';

  @override
  String get profile_chooseFromGallery => 'Alege din Galerie';

  @override
  String get profile_avatarUpdated => 'Avatar actualizat cu succes';

  @override
  String get profile_profileUpdated => 'Profil actualizat cu succes';

  @override
  String get profile_noProfileFound => 'Niciun profil găsit';

  @override
  String get discovery_title => 'Descoperă';

  @override
  String get discovery_searchUsers => 'Caută utilizatori...';

  @override
  String get discovery_discoverTab => 'Descoperă';

  @override
  String get discovery_followingTab => 'Urmărești';

  @override
  String get discovery_followersTab => 'Urmăritori';

  @override
  String get discovery_noUsersFound => 'Niciun utilizator găsit';

  @override
  String get discovery_tryAdjustingFilters => 'Încearcă să ajustezi filtrele';

  @override
  String get discovery_notFollowingAnyone => 'Nu urmărești pe nimeni';

  @override
  String get discovery_discoverPeople => 'Descoperă oameni de urmărit';

  @override
  String get discovery_noFollowersYet => 'Încă fără urmăritori';

  @override
  String get discovery_shareInsights =>
      'Distribuie perspectivele tale pentru a câștiga urmăritori';

  @override
  String get discovery_clearAll => 'Șterge tot';

  @override
  String chart_gate(int number) {
    return 'Poarta $number';
  }

  @override
  String chart_channel(String id) {
    return 'Canalul $id';
  }

  @override
  String get chart_center => 'Centru';

  @override
  String get chart_keynote => 'Notă Cheie';

  @override
  String get chart_element => 'Element';

  @override
  String get chart_location => 'Locație';

  @override
  String get chart_hdCenters => 'Centre HD';

  @override
  String get reaction_comment => 'Comentează';

  @override
  String get reaction_react => 'Reacționează';

  @override
  String get reaction_standard => 'Standard';

  @override
  String get reaction_humanDesign => 'Design Uman';

  @override
  String get share_shareChart => 'Distribuie Harta';

  @override
  String get share_createShareLink => 'Creează Link de Distribuire';

  @override
  String get share_shareViaUrl => 'Distribuie prin URL';

  @override
  String get share_exportAsPng => 'Exportă ca PNG';

  @override
  String get share_fullReport => 'Raport complet';

  @override
  String get share_linkExpiration => 'Expirare Link';

  @override
  String get share_neverExpires => 'Nu expiră niciodată';

  @override
  String get share_oneHour => '1 oră';

  @override
  String get share_twentyFourHours => '24 de ore';

  @override
  String get share_sevenDays => '7 zile';

  @override
  String get share_thirtyDays => '30 de zile';

  @override
  String get share_creating => 'Se creează...';

  @override
  String get share_signInToShare => 'Conectează-te pentru a distribui harta ta';

  @override
  String get share_createShareableLinks =>
      'Creează linkuri partajabile către harta ta de Design Uman';

  @override
  String get share_linkImage => 'Imagine';

  @override
  String get share_pdf => 'PDF';

  @override
  String get post_share => 'Distribuie';

  @override
  String get post_edit => 'Editează';

  @override
  String get post_report => 'Raportează';

  @override
  String get mentorship_title => 'Mentorat';

  @override
  String get mentorship_pendingRequests => 'Cereri în Așteptare';

  @override
  String get mentorship_availableMentors => 'Mentori Disponibili';

  @override
  String get mentorship_noMentorsAvailable => 'Niciun mentor disponibil';

  @override
  String mentorship_requestMentorship(String name) {
    return 'Cere Mentorat de la $name';
  }

  @override
  String get mentorship_sendMessage =>
      'Trimite un mesaj explicând ce ai dori să înveți:';

  @override
  String get mentorship_learnPrompt => 'Aș dori să învăț mai multe despre...';

  @override
  String get mentorship_requestSent => 'Cerere trimisă!';

  @override
  String get mentorship_sendRequest => 'Trimite Cererea';

  @override
  String get mentorship_becomeAMentor => 'Devino Mentor';

  @override
  String get mentorship_shareKnowledge =>
      'Distribuie cunoștințele tale despre Design Uman';

  @override
  String get story_cancel => 'Anulează';

  @override
  String get story_createStory => 'Creează Poveste';

  @override
  String get story_share => 'Distribuie';

  @override
  String get story_typeYourStory => 'Scrie povestea ta...';

  @override
  String get story_background => 'Fundal';

  @override
  String get story_attachTransitGate => 'Atașează Poartă de Tranzit (opțional)';

  @override
  String get story_none => 'Niciuna';

  @override
  String story_gateNumber(int number) {
    return 'Poarta $number';
  }

  @override
  String get story_whoCanSee => 'Cine poate vedea asta?';

  @override
  String get story_followers => 'Urmăritori';

  @override
  String get story_everyone => 'Toată Lumea';

  @override
  String get challenges_title => 'Provocări';

  @override
  String get challenges_daily => 'Zilnice';

  @override
  String get challenges_weekly => 'Săptămânale';

  @override
  String get challenges_monthly => 'Lunare';

  @override
  String get challenges_noDailyChallenges =>
      'Nicio provocare zilnică disponibilă';

  @override
  String get challenges_noWeeklyChallenges =>
      'Nicio provocare săptămânală disponibilă';

  @override
  String get challenges_noMonthlyChallenges =>
      'Nicio provocare lunară disponibilă';

  @override
  String get challenges_errorLoading => 'Eroare la încărcarea provocărilor';

  @override
  String challenges_claimedPoints(int points) {
    return 'Ai revendicat $points puncte!';
  }

  @override
  String get challenges_totalPoints => 'Puncte Totale';

  @override
  String get challenges_level => 'Nivel';

  @override
  String get learning_all => 'Toate';

  @override
  String get learning_types => 'Tipuri';

  @override
  String get learning_gates => 'Porți';

  @override
  String get learning_centers => 'Centre';

  @override
  String get learning_liveSessions => 'Sesiuni Live';

  @override
  String get quiz_noActiveSession => 'Nicio sesiune de chestionar activă';

  @override
  String get quiz_noQuestionsAvailable => 'Nicio întrebare disponibilă';

  @override
  String get quiz_ok => 'OK';

  @override
  String get liveSessions_title => 'Sesiuni Live';

  @override
  String get liveSessions_upcoming => 'Viitoare';

  @override
  String get liveSessions_mySessions => 'Sesiunile Mele';

  @override
  String get liveSessions_errorLoading => 'Eroare la încărcarea sesiunilor';

  @override
  String get liveSessions_registeredSuccessfully => 'Înregistrat cu succes!';

  @override
  String get liveSessions_cancelRegistration => 'Anulează Înregistrarea';

  @override
  String get liveSessions_cancelRegistrationConfirm =>
      'Ești sigur că vrei să anulezi înregistrarea?';

  @override
  String get liveSessions_no => 'Nu';

  @override
  String get liveSessions_yesCancel => 'Da, Anulează';

  @override
  String get liveSessions_registrationCancelled => 'Înregistrare anulată';

  @override
  String get gateChannelPicker_gates => 'Porți (64)';

  @override
  String get gateChannelPicker_channels => 'Canale (36)';

  @override
  String get gateChannelPicker_search => 'Caută porți sau canale...';

  @override
  String get leaderboard_weekly => 'Săptămânal';

  @override
  String get leaderboard_monthly => 'Lunar';

  @override
  String get leaderboard_allTime => 'Tot Timpul';

  @override
  String get ai_chatTitle => 'Asistent AI';

  @override
  String get ai_askAi => 'Întreabă AI';

  @override
  String get ai_askAboutChart => 'Întreabă AI despre Harta Ta';

  @override
  String get ai_miniDescription =>
      'Obține perspective personalizate despre Design-ul tău Uman';

  @override
  String get ai_startChatting => 'Începe conversația';

  @override
  String get ai_welcomeTitle => 'Asistentul Tău HD';

  @override
  String get ai_welcomeSubtitle =>
      'Întreabă-mă orice despre harta ta de Design Uman. Pot explica tipul, strategia, autoritatea, porțile, canalele tale și multe altele.';

  @override
  String get ai_inputPlaceholder => 'Întreabă despre harta ta...';

  @override
  String get ai_newConversation => 'Conversație Nouă';

  @override
  String get ai_conversations => 'Conversații';

  @override
  String get ai_noConversations => 'Încă fără conversații';

  @override
  String get ai_noConversationsMessage =>
      'Începe o conversație cu AI pentru a obține perspective personalizate despre hartă.';

  @override
  String get ai_deleteConversation => 'Șterge Conversația';

  @override
  String get ai_deleteConversationConfirm =>
      'Ești sigur că vrei să ștergi această conversație?';

  @override
  String get ai_messagesExhausted => 'Mesaje Gratuite Epuizate';

  @override
  String get ai_upgradeForUnlimited =>
      'Actualizează la Premium pentru conversații AI nelimitate despre harta ta de Design Uman.';

  @override
  String ai_usageCount(int used, int limit) {
    return '$used din $limit mesaje gratuite folosite';
  }

  @override
  String get ai_errorGeneric =>
      'Ceva nu a mers bine. Te rugăm să încerci din nou.';

  @override
  String get ai_errorNetwork =>
      'Nu s-a putut contacta serviciul AI. Verifică conexiunea.';

  @override
  String get events_title => 'Evenimente din Comunitate';

  @override
  String get events_upcoming => 'Viitoare';

  @override
  String get events_past => 'Trecute';

  @override
  String get events_create => 'Creează Eveniment';

  @override
  String get events_noUpcoming => 'Niciun eveniment viitor';

  @override
  String get events_noUpcomingMessage =>
      'Creează un eveniment pentru a te conecta cu comunitatea HD!';

  @override
  String get events_online => 'Online';

  @override
  String get events_inPerson => 'Fizic';

  @override
  String get events_hybrid => 'Hibrid';

  @override
  String events_participants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participanți',
      one: '1 participant',
    );
    return '$_temp0';
  }

  @override
  String get events_register => 'Înregistrează-te';

  @override
  String get events_registered => 'Înregistrat';

  @override
  String get events_cancelRegistration => 'Anulează Înregistrarea';

  @override
  String get events_registrationFull => 'Eveniment Complet';

  @override
  String get events_eventTitle => 'Titlu Eveniment';

  @override
  String get events_eventDescription => 'Descriere';

  @override
  String get events_eventType => 'Tip Eveniment';

  @override
  String get events_startDate => 'Data & Ora de Început';

  @override
  String get events_endDate => 'Data & Ora de Sfârșit';

  @override
  String get events_location => 'Locație';

  @override
  String get events_virtualLink => 'Link Întâlnire Virtuală';

  @override
  String get events_maxParticipants => 'Participanți Maximi';

  @override
  String get events_hdTypeFilter => 'Filtru Tip HD';

  @override
  String get events_allTypes => 'Deschis pentru Toate Tipurile';

  @override
  String get events_created => 'Eveniment creat!';

  @override
  String get events_deleted => 'Eveniment șters';

  @override
  String get events_notFound => 'Eveniment negăsit';

  @override
  String get chartOfDay_title => 'Harta Zilei';

  @override
  String get chartOfDay_featured => 'Hartă Remarcabilă';

  @override
  String get chartOfDay_viewChart => 'Vezi Harta';

  @override
  String get discussion_typeDiscussion => 'Discuție despre Tip';

  @override
  String get discussion_channelDiscussion => 'Discuție despre Canal';

  @override
  String get ai_wantMoreInsights => 'Vrei mai multe analize AI?';

  @override
  String ai_messagesPackTitle(int count) {
    return '$count Mesaje';
  }

  @override
  String get ai_orSubscribe => 'sau abonează-te pentru nelimitat';

  @override
  String get ai_bestValue => 'Cea mai bună valoare';

  @override
  String get ai_getMoreMessages => 'Obține mai multe mesaje';

  @override
  String ai_fromPrice(String price) {
    return 'De la $price';
  }

  @override
  String ai_perMessage(String price) {
    return '$price/mesaj';
  }

  @override
  String get ai_transitInsightTitle => 'Perspectiva Tranzitului de Azi';

  @override
  String get ai_transitInsightDesc =>
      'Obține o interpretare personalizată AI despre cum tranzitele de azi afectează harta ta.';

  @override
  String get ai_chartReadingTitle => 'Citire AI a Hărții';

  @override
  String get ai_chartReadingDesc =>
      'Generează o citire AI cuprinzătoare a hărții tale de Design Uman.';

  @override
  String get ai_chartReadingCost =>
      'Această citire folosește 3 mesaje AI din cota ta.';

  @override
  String get ai_compatibilityTitle => 'Citire AI de Compatibilitate';

  @override
  String get ai_compatibilityReading => 'Analiză AI de Compatibilitate';

  @override
  String get ai_dreamJournalTitle => 'Jurnal de Vise';

  @override
  String get ai_dreamEntryHint =>
      'Înregistrează visele pentru a descoperi perspective ascunse din designul tău...';

  @override
  String get ai_interpretDream => 'Interpretează Visul';

  @override
  String get ai_journalPromptsTitle => 'Subiecte pentru Jurnal';

  @override
  String get ai_journalPromptsDesc =>
      'Obține subiecte personalizate pentru jurnal bazate pe harta ta și tranzitele de azi.';

  @override
  String get ai_generating => 'Se generează...';

  @override
  String get ai_askFollowUp => 'Întreabă în Continuare';

  @override
  String get ai_regenerate => 'Regenerează';

  @override
  String get ai_exportPdf => 'Exportă PDF';

  @override
  String get ai_shareReading => 'Distribuie Citirea';

  @override
  String get group_notFound => 'Grupul nu a fost găsit';

  @override
  String get group_members => 'Membri';

  @override
  String get group_sharedCharts => 'Hărți Partajate';

  @override
  String get group_feed => 'Flux';

  @override
  String get group_invite => 'Invită';

  @override
  String get group_inviteMembers => 'Invită Membri';

  @override
  String get group_searchUsers => 'Caută după nume...';

  @override
  String get group_searchHint => 'Tastați cel puțin 2 caractere pentru a căuta';

  @override
  String get group_noUsersFound => 'Nu au fost găsiți utilizatori';

  @override
  String group_memberAdded(String name) {
    return '$name a fost adăugat în grup';
  }

  @override
  String get group_addMemberFailed => 'Nu s-a putut adăuga membrul';

  @override
  String get group_noMembers => 'Încă nu există membri';

  @override
  String get group_promote => 'Promovați la Administrator';

  @override
  String get group_demote => 'Retrogradați la Membru';

  @override
  String get group_removeMember => 'Eliminați';

  @override
  String get group_promoteTitle => 'Promovați Membrul';

  @override
  String group_promoteConfirmation(String name) {
    return 'Faceți din $name un administrator al acestui grup?';
  }

  @override
  String get group_demoteTitle => 'Retrogradați Membrul';

  @override
  String group_demoteConfirmation(String name) {
    return 'Eliminați rolul de administrator al lui $name?';
  }

  @override
  String get group_removeMemberTitle => 'Eliminați Membrul';

  @override
  String group_removeMemberConfirmation(String name) {
    return 'Eliminați $name din acest grup?';
  }

  @override
  String get group_editName => 'Editați Numele';

  @override
  String get group_editDescription => 'Editați Descrierea';

  @override
  String get group_delete => 'Ștergeți Grupul';

  @override
  String get group_deleteTitle => 'Ștergeți Grupul';

  @override
  String group_deleteConfirmation(String name) {
    return 'Sigur doriți să ștergeți \"$name\"? Această acțiune nu poate fi anulată.';
  }

  @override
  String get group_deleted => 'Grupul a fost șters';

  @override
  String get group_leave => 'Părăsiți Grupul';

  @override
  String get group_leaveTitle => 'Părăsiți Grupul';

  @override
  String group_leaveConfirmation(String name) {
    return 'Sigur doriți să părăsiți \"$name\"?';
  }

  @override
  String get group_left => 'Ați părăsit grupul';

  @override
  String get group_updated => 'Grupul a fost actualizat';

  @override
  String get group_noSharedCharts => 'Fără Hărți Partajate';

  @override
  String get group_noSharedChartsMessage =>
      'Partajați harta dvs. cu grupul din ecranul hărții.';

  @override
  String get group_writePost => 'Scrieți ceva...';

  @override
  String get group_noPosts => 'Încă Nu Există Postări';

  @override
  String get group_beFirstToPost => 'Începeți conversația!';

  @override
  String get group_deletePostConfirmation => 'Ștergeți această postare?';

  @override
  String get group_shareChart => 'Distribuiți harta';

  @override
  String get group_share => 'Distribuiți';

  @override
  String get group_chartShared => 'Harta a fost distribuită grupului';

  @override
  String get group_noChartsToShare =>
      'Nu există hărți salvate de distribuit. Creați mai întâi o hartă.';
}
