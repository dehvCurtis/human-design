// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'Дизайн Людини';

  @override
  String get common_save => 'Зберегти';

  @override
  String get common_cancel => 'Скасувати';

  @override
  String get common_delete => 'Видалити';

  @override
  String get common_edit => 'Редагувати';

  @override
  String get common_done => 'Готово';

  @override
  String get common_next => 'Далі';

  @override
  String get common_back => 'Назад';

  @override
  String get common_skip => 'Пропустити';

  @override
  String get common_continue => 'Продовжити';

  @override
  String get common_loading => 'Завантаження...';

  @override
  String get common_error => 'Помилка';

  @override
  String get common_retry => 'Повторити';

  @override
  String get common_close => 'Закрити';

  @override
  String get common_search => 'Пошук';

  @override
  String get common_share => 'Поділитися';

  @override
  String get common_settings => 'Налаштування';

  @override
  String get common_logout => 'Вийти';

  @override
  String get common_profile => 'Профіль';

  @override
  String get common_type => 'Тип';

  @override
  String get common_strategy => 'Стратегія';

  @override
  String get common_authority => 'Авторитет';

  @override
  String get common_definition => 'Визначеність';

  @override
  String get common_create => 'Створити';

  @override
  String get common_viewFull => 'Детальніше';

  @override
  String get common_send => 'Надіслати';

  @override
  String get nav_home => 'Головна';

  @override
  String get nav_chart => 'Карта';

  @override
  String get nav_today => 'Сьогодні';

  @override
  String get nav_social => 'Соціум';

  @override
  String get nav_profile => 'Профіль';

  @override
  String get home_goodMorning => 'Доброго ранку';

  @override
  String get home_goodAfternoon => 'Доброго дня';

  @override
  String get home_goodEvening => 'Доброго вечора';

  @override
  String get home_yourDesign => 'Ваш дизайн';

  @override
  String get home_completeProfile => 'Заповніть профіль';

  @override
  String get home_enterBirthData => 'Введіть дані народження';

  @override
  String get home_myChart => 'Моя карта';

  @override
  String get home_savedCharts => 'Saved';

  @override
  String get home_composite => 'Композит';

  @override
  String get home_penta => 'Пента';

  @override
  String get home_friends => 'Друзі';

  @override
  String get home_myBodygraph => 'Мій бодіграф';

  @override
  String get home_definedCenters => 'Визначені центри';

  @override
  String get home_activeChannels => 'Активні канали';

  @override
  String get home_activeGates => 'Активні ворота';

  @override
  String get transit_today => 'Транзити сьогодні';

  @override
  String get transit_sun => 'Сонце';

  @override
  String get transit_earth => 'Земля';

  @override
  String get transit_moon => 'Місяць';

  @override
  String transit_gate(int number) {
    return 'Ворота $number';
  }

  @override
  String transit_newChannelsActivated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нових каналів активовано',
      few: '$count нових канали активовано',
      one: '1 новий канал активовано',
    );
    return '$_temp0';
  }

  @override
  String transit_gatesHighlighted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воріт виділено',
      few: '$count ворот виділено',
      one: '1 ворота виділено',
    );
    return '$_temp0';
  }

  @override
  String get transit_noConnections =>
      'Немає прямих транзитних зв\'язків сьогодні';

  @override
  String get auth_signIn => 'Увійти';

  @override
  String get auth_signUp => 'Реєстрація';

  @override
  String get auth_signInWithApple => 'Увійти через Apple';

  @override
  String get auth_signInWithGoogle => 'Увійти через Google';

  @override
  String get auth_signInWithEmail => 'Увійти за Email';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Пароль';

  @override
  String get auth_confirmPassword => 'Підтвердіть пароль';

  @override
  String get auth_forgotPassword => 'Забули пароль?';

  @override
  String get auth_noAccount => 'Немає акаунту?';

  @override
  String get auth_hasAccount => 'Вже є акаунт?';

  @override
  String get auth_termsAgree =>
      'Реєструючись, ви погоджуєтесь з Умовами використання та Політикою конфіденційності';

  @override
  String get auth_welcomeBack => 'З поверненням';

  @override
  String get auth_signInSubtitle =>
      'Увійдіть, щоб продовжити подорож Дизайном Людини';

  @override
  String get auth_signInRequired => 'Sign In Required';

  @override
  String get auth_signInToCalculateChart =>
      'Please sign in to calculate and save your Human Design chart.';

  @override
  String get auth_signUpSubtitle =>
      'Розпочніть свою подорож Дизайном Людини сьогодні';

  @override
  String get auth_signUpWithApple => 'Реєстрація через Apple';

  @override
  String get auth_signUpWithGoogle => 'Реєстрація через Google';

  @override
  String get auth_enterName => 'Введіть ваше ім\'я';

  @override
  String get auth_nameRequired => 'Ім\'я обов\'язкове';

  @override
  String get auth_termsOfService => 'Умови використання';

  @override
  String get auth_privacyPolicy => 'Політика конфіденційності';

  @override
  String get auth_acceptTerms =>
      'Будь ласка, прийміть Умови використання для продовження';

  @override
  String get auth_resetPasswordTitle => 'Скидання пароля';

  @override
  String get auth_resetPasswordPrompt =>
      'Введіть email і ми надішлемо вам посилання для скидання пароля.';

  @override
  String get auth_enterEmail => 'Введіть email';

  @override
  String get auth_resetEmailSent => 'Лист для скидання пароля надіслано!';

  @override
  String get auth_name => 'Ім\'я';

  @override
  String get auth_createAccount => 'Створити акаунт';

  @override
  String get auth_iAgreeTo => 'Я приймаю ';

  @override
  String get auth_and => ' та ';

  @override
  String get auth_birthInformation => 'Дані народження';

  @override
  String get auth_calculateMyChart => 'Розрахувати мою карту';

  @override
  String get onboarding_welcome => 'Ласкаво просимо до Дизайну Людини';

  @override
  String get onboarding_welcomeSubtitle =>
      'Відкрийте свій унікальний енергетичний план';

  @override
  String get onboarding_birthData => 'Введіть дані народження';

  @override
  String get onboarding_birthDataSubtitle =>
      'Це потрібно для розрахунку вашої карти';

  @override
  String get onboarding_birthDate => 'Дата народження';

  @override
  String get onboarding_birthTime => 'Час народження';

  @override
  String get onboarding_birthLocation => 'Місце народження';

  @override
  String get onboarding_searchLocation => 'Введіть назву міста...';

  @override
  String get onboarding_unknownTime => 'Я не знаю час народження';

  @override
  String get onboarding_timeImportance =>
      'Точний час народження важливий для точної карти';

  @override
  String get onboarding_birthDataExplanation =>
      'Ваші дані народження використовуються для розрахунку унікальної карти Дизайну Людини. Чим точніша інформація, тим точнішою буде карта.';

  @override
  String get onboarding_noTimeWarning =>
      'Без точного часу народження деякі деталі карти (висхідний знак та лінії воріт) можуть бути неточними. За замовчуванням буде використано полудень.';

  @override
  String get onboarding_enterBirthTimeInstead => 'Ввести час народження';

  @override
  String get onboarding_birthDataPrivacy =>
      'Ваші дані народження зашифровані та зберігаються безпечно. Ви можете оновити або видалити їх будь-коли в налаштуваннях профілю.';

  @override
  String get onboarding_saveFailed => 'Не вдалося зберегти дані народження';

  @override
  String get onboarding_fillAllFields =>
      'Будь ласка, заповніть усі обов\'язкові поля';

  @override
  String get onboarding_selectLanguage => 'Оберіть мову';

  @override
  String get onboarding_getStarted => 'Почати';

  @override
  String get onboarding_alreadyHaveAccount => 'У мене вже є акаунт';

  @override
  String get onboarding_liveInAlignment =>
      'Відкрийте свій унікальний енергетичний відбиток та живіть у гармонії зі своєю справжньою природою.';

  @override
  String get chart_myChart => 'Моя карта';

  @override
  String get chart_viewChart => 'Переглянути карту';

  @override
  String get chart_calculate => 'Розрахувати карту';

  @override
  String get chart_recalculate => 'Перерахувати';

  @override
  String get chart_share => 'Поділитися картою';

  @override
  String get chart_createChart => 'Створити карту';

  @override
  String get chart_composite => 'Композитна карта';

  @override
  String get chart_transit => 'Транзити сьогодні';

  @override
  String get chart_bodygraph => 'Бодіграф';

  @override
  String get chart_planets => 'Planets';

  @override
  String get chart_details => 'Деталі карти';

  @override
  String get chart_properties => 'Властивості';

  @override
  String get chart_gates => 'Ворота';

  @override
  String get chart_channels => 'Канали';

  @override
  String get chart_noChartYet => 'Поки немає карти';

  @override
  String get chart_addBirthDataPrompt =>
      'Додайте дані народження для створення вашої унікальної карти Дизайну Людини.';

  @override
  String get chart_addBirthData => 'Додати дані народження';

  @override
  String get chart_noActiveChannels => 'Немає активних каналів';

  @override
  String get chart_channelsFormedBothGates =>
      'Канали утворюються, коли визначені обидва ворота.';

  @override
  String get chart_savedCharts => 'Збережені карти';

  @override
  String get chart_addChart => 'Додати карту';

  @override
  String get chart_noSavedCharts => 'Немає збережених карт';

  @override
  String get chart_noSavedChartsMessage =>
      'Створіть карти для себе та інших, щоб зберегти їх тут.';

  @override
  String get chart_loadFailed => 'Не вдалося завантажити карти';

  @override
  String get chart_renameChart => 'Перейменувати карту';

  @override
  String get chart_rename => 'Перейменувати';

  @override
  String get chart_renameFailed => 'Не вдалося перейменувати карту';

  @override
  String get chart_deleteChart => 'Видалити карту';

  @override
  String chart_deleteConfirm(String name) {
    return 'Ви впевнені, що хочете видалити \"$name\"? Цю дію не можна скасувати.';
  }

  @override
  String get chart_deleteFailed => 'Не вдалося видалити карту';

  @override
  String get chart_you => 'Ви';

  @override
  String get chart_personName => 'Ім\'я';

  @override
  String get chart_enterPersonName => 'Введіть ім\'я людини';

  @override
  String get chart_addChartDescription =>
      'Створіть карту для іншої людини, ввівши її дані народження.';

  @override
  String get chart_calculateAndSave => 'Розрахувати та зберегти карту';

  @override
  String get chart_saved => 'Карту успішно збережено';

  @override
  String get chart_consciousGates => 'Свідомі ворота';

  @override
  String get chart_unconsciousGates => 'Несвідомі ворота';

  @override
  String get chart_personalitySide =>
      'Сторона особистості - те, що ви усвідомлюєте';

  @override
  String get chart_designSide => 'Сторона дизайну - те, що бачать у вас інші';

  @override
  String get type_manifestor => 'Маніфестор';

  @override
  String get type_generator => 'Генератор';

  @override
  String get type_manifestingGenerator => 'Маніфестуючий Генератор';

  @override
  String get type_projector => 'Проектор';

  @override
  String get type_reflector => 'Рефлектор';

  @override
  String get type_manifestor_strategy => 'Інформувати';

  @override
  String get type_generator_strategy => 'Відгукуватися';

  @override
  String get type_manifestingGenerator_strategy => 'Відгукуватися';

  @override
  String get type_projector_strategy => 'Чекати на запрошення';

  @override
  String get type_reflector_strategy => 'Чекати місячний цикл';

  @override
  String get authority_emotional => 'Емоційний';

  @override
  String get authority_sacral => 'Сакральний';

  @override
  String get authority_splenic => 'Селезінковий';

  @override
  String get authority_ego => 'Его/Серце';

  @override
  String get authority_self => 'Само-проектований';

  @override
  String get authority_environment => 'Ментальний/Оточення';

  @override
  String get authority_lunar => 'Місячний';

  @override
  String get definition_none => 'Без визначеності';

  @override
  String get definition_single => 'Одинарна визначеність';

  @override
  String get definition_split => 'Розщеплена визначеність';

  @override
  String get definition_tripleSplit => 'Потрійне розщеплення';

  @override
  String get definition_quadrupleSplit => 'Четвертне розщеплення';

  @override
  String get profile_1_3 => '1/3 Дослідник/Мученик';

  @override
  String get profile_1_4 => '1/4 Дослідник/Опортуніст';

  @override
  String get profile_2_4 => '2/4 Відлюдник/Опортуніст';

  @override
  String get profile_2_5 => '2/5 Відлюдник/Єретик';

  @override
  String get profile_3_5 => '3/5 Мученик/Єретик';

  @override
  String get profile_3_6 => '3/6 Мученик/Рольова модель';

  @override
  String get profile_4_6 => '4/6 Опортуніст/Рольова модель';

  @override
  String get profile_4_1 => '4/1 Опортуніст/Дослідник';

  @override
  String get profile_5_1 => '5/1 Єретик/Дослідник';

  @override
  String get profile_5_2 => '5/2 Єретик/Відлюдник';

  @override
  String get profile_6_2 => '6/2 Рольова модель/Відлюдник';

  @override
  String get profile_6_3 => '6/3 Рольова модель/Мученик';

  @override
  String get center_head => 'Головний';

  @override
  String get center_ajna => 'Аджна';

  @override
  String get center_throat => 'Горловий';

  @override
  String get center_g => 'G-центр';

  @override
  String get center_heart => 'Серцевий/Его';

  @override
  String get center_sacral => 'Сакральний';

  @override
  String get center_solarPlexus => 'Сонячне сплетіння';

  @override
  String get center_spleen => 'Селезінковий';

  @override
  String get center_root => 'Кореневий';

  @override
  String get center_defined => 'Визначений';

  @override
  String get center_undefined => 'Невизначений';

  @override
  String get section_type => 'Тип';

  @override
  String get section_strategy => 'Стратегія';

  @override
  String get section_authority => 'Авторитет';

  @override
  String get section_profile => 'Профіль';

  @override
  String get section_definition => 'Визначеність';

  @override
  String get section_centers => 'Центри';

  @override
  String get section_channels => 'Канали';

  @override
  String get section_gates => 'Ворота';

  @override
  String get section_conscious => 'Свідоме (Особистість)';

  @override
  String get section_unconscious => 'Несвідоме (Дизайн)';

  @override
  String get social_title => 'Соціальне';

  @override
  String get social_friends => 'Друзі';

  @override
  String get social_groups => 'Групи';

  @override
  String get social_addFriend => 'Додати друга';

  @override
  String get social_sendRequest => 'Надіслати запит';

  @override
  String get social_createGroup => 'Створити групу';

  @override
  String get social_invite => 'Запросити';

  @override
  String get social_members => 'Учасники';

  @override
  String get social_comments => 'Коментарі';

  @override
  String get social_addComment => 'Додати коментар...';

  @override
  String get social_noComments => 'Поки немає коментарів';

  @override
  String social_shareLimit(int remaining) {
    return 'У вас залишилось $remaining публікацій цього місяця';
  }

  @override
  String get social_visibility => 'Видимість';

  @override
  String get social_private => 'Приватно';

  @override
  String get social_friendsOnly => 'Тільки друзі';

  @override
  String get social_public => 'Публічно';

  @override
  String get social_shared => 'Спільні';

  @override
  String get social_noFriendsYet => 'Поки немає друзів';

  @override
  String get social_noFriendsMessage =>
      'Додайте друзів для порівняння карт і вивчення ваших зв\'язків.';

  @override
  String get social_noGroupsYet => 'Поки немає груп';

  @override
  String get social_noGroupsMessage =>
      'Створіть групи для аналізу командної динаміки з Пента-аналізом.';

  @override
  String get social_noSharedCharts => 'Немає спільних карт';

  @override
  String get social_noSharedChartsMessage =>
      'Тут з\'являться карти, якими поділились з вами друзі.';

  @override
  String get social_pendingRequests => 'Очікуючі запити';

  @override
  String get social_friendRequests => 'Запити в друзі';

  @override
  String get social_noPendingRequests => 'Немає очікуючих запитів';

  @override
  String get social_addFriendPrompt =>
      'Введіть email друга, щоб надіслати запит.';

  @override
  String get social_emailLabel => 'Email';

  @override
  String get social_emailHint => 'friend@example.com';

  @override
  String get social_userNotFound => 'Користувача з таким email не знайдено';

  @override
  String social_requestSent(String name) {
    return 'Запит дружби надіслано $name!';
  }

  @override
  String get social_createGroupPrompt =>
      'Створіть групу для аналізу командної динаміки.';

  @override
  String get social_groupName => 'Назва групи';

  @override
  String get social_groupNameHint => 'Сім\'я, Команда тощо';

  @override
  String get social_groupDescription => 'Опис (необов\'язково)';

  @override
  String get social_groupDescriptionHint => 'Для чого ця група?';

  @override
  String social_groupCreated(String name) {
    return 'Групу \"$name\" створено!';
  }

  @override
  String social_friendsSince(String date) {
    return 'Друзі з $date';
  }

  @override
  String get social_compareCharts => 'Порівняти карти';

  @override
  String get social_noDescription => 'Без опису';

  @override
  String get social_admin => 'Адмін';

  @override
  String social_sharedBy(String name) {
    return 'Поділився $name';
  }

  @override
  String get social_loadFriendsFailed => 'Не вдалося завантажити друзів';

  @override
  String get social_loadGroupsFailed => 'Не вдалося завантажити групи';

  @override
  String get social_loadSharedFailed => 'Не вдалося завантажити спільні карти';

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
  String get userProfile_viewChart => 'Bodygraph';

  @override
  String get userProfile_chartPrivate => 'This chart is private';

  @override
  String get userProfile_chartFriendsOnly =>
      'Become mutual followers to view this chart';

  @override
  String get userProfile_chartFollowToView => 'Follow to view this chart';

  @override
  String get popularCharts_title => 'Popular Charts';

  @override
  String get popularCharts_subtitle => 'Most followed public charts';

  @override
  String social_sentAgo(String time) {
    return 'Надіслано $time';
  }

  @override
  String time_minutesAgo(int minutes) {
    return '$minutes хв. тому';
  }

  @override
  String time_hoursAgo(int hours) {
    return '$hours год. тому';
  }

  @override
  String time_daysAgo(int days) {
    return '$days дн. тому';
  }

  @override
  String get transit_title => 'Транзити сьогодні';

  @override
  String get transit_currentEnergies => 'Поточні енергії';

  @override
  String get transit_sunGate => 'Ворота Сонця';

  @override
  String get transit_earthGate => 'Ворота Землі';

  @override
  String get transit_moonGate => 'Ворота Місяця';

  @override
  String get transit_activeGates => 'Активні транзитні ворота';

  @override
  String get transit_activeChannels => 'Активні транзитні канали';

  @override
  String get transit_personalImpact => 'Особистий вплив';

  @override
  String transit_gateActivated(int gate) {
    return 'Ворота $gate активовані транзитом';
  }

  @override
  String transit_channelFormed(String channel) {
    return 'Канал $channel утворений з вашою картою';
  }

  @override
  String get transit_noPersonalImpact =>
      'Немає прямих транзитних зв\'язків сьогодні';

  @override
  String get transit_viewFullTransit => 'Переглянути повну карту транзитів';

  @override
  String get affirmation_title => 'Щоденна афірмація';

  @override
  String affirmation_forYourType(String type) {
    return 'Для вашого типу $type';
  }

  @override
  String affirmation_basedOnGate(int gate) {
    return 'На основі воріт $gate';
  }

  @override
  String get affirmation_refresh => 'Нова афірмація';

  @override
  String get affirmation_save => 'Зберегти афірмацію';

  @override
  String get affirmation_saved => 'Збережені афірмації';

  @override
  String get affirmation_share => 'Поділитися афірмацією';

  @override
  String get affirmation_notifications => 'Сповіщення про афірмації';

  @override
  String get affirmation_notificationTime => 'Час сповіщення';

  @override
  String get lifestyle_today => 'Сьогодні';

  @override
  String get lifestyle_insights => 'Інсайти';

  @override
  String get lifestyle_journal => 'Щоденник';

  @override
  String get lifestyle_addJournalEntry => 'Додати запис';

  @override
  String get lifestyle_journalPrompt =>
      'Як ви переживаєте свій дизайн сьогодні?';

  @override
  String get lifestyle_noJournalEntries => 'Поки немає записів';

  @override
  String get lifestyle_mood => 'Настрій';

  @override
  String get lifestyle_energy => 'Рівень енергії';

  @override
  String get lifestyle_reflection => 'Роздуми';

  @override
  String get penta_title => 'Пента';

  @override
  String get penta_description => 'Груповий аналіз для 3-5 людей';

  @override
  String get penta_createNew => 'Створити Пенту';

  @override
  String get penta_selectMembers => 'Оберіть учасників';

  @override
  String get penta_minMembers => 'Потрібно мінімум 3 учасники';

  @override
  String get penta_maxMembers => 'Максимум 5 учасників';

  @override
  String get penta_groupDynamics => 'Групова динаміка';

  @override
  String get penta_missingRoles => 'Відсутні ролі';

  @override
  String get penta_strengths => 'Сильні сторони групи';

  @override
  String get penta_analysis => 'Аналіз Пента';

  @override
  String get penta_clearAnalysis => 'Очистити аналіз';

  @override
  String get penta_infoText =>
      'Аналіз Пента розкриває природні ролі, що виникають у малих групах з 3-5 осіб, показуючи, як кожен учасник впливає на динаміку команди.';

  @override
  String get penta_calculating => 'Розрахунок...';

  @override
  String get penta_calculate => 'Розрахувати Пента';

  @override
  String get penta_groupRoles => 'Ролі в групі';

  @override
  String get penta_electromagneticConnections => 'Електромагнітні зв\'язки';

  @override
  String get penta_connectionsDescription =>
      'Особливі енергетичні зв\'язки між учасниками, що створюють притягання та хімію.';

  @override
  String get penta_areasForAttention => 'Області для уваги';

  @override
  String get composite_title => 'Композитна карта';

  @override
  String get composite_infoText =>
      'Композитна карта показує динаміку відносин між двома людьми, розкриваючи, як ваші карти взаємодіють та доповнюють одна одну.';

  @override
  String get composite_selectTwoCharts => 'Виберіть 2 карти';

  @override
  String get composite_calculate => 'Аналізувати зв\'язок';

  @override
  String get composite_calculating => 'Аналізуємо...';

  @override
  String get composite_clearAnalysis => 'Очистити аналіз';

  @override
  String get composite_connectionTheme => 'Тема зв\'язку';

  @override
  String get composite_definedCenters => 'Визначено';

  @override
  String get composite_undefinedCenters => 'Відкрито';

  @override
  String get composite_score => 'Оцінка';

  @override
  String get composite_themeVeryBonded =>
      'Дуже пов\'язані відносини - ви можете відчувати глибоку переплетеність';

  @override
  String get composite_themeBonded =>
      'Пов\'язані відносини - сильне відчуття єдності та спільної енергії';

  @override
  String get composite_themeBalanced =>
      'Збалансовані відносини - здорове поєднання єдності та незалежності';

  @override
  String get composite_themeIndependent =>
      'Незалежні відносини - більше простору для особистого зростання';

  @override
  String get composite_themeVeryIndependent =>
      'Дуже незалежні відносини - усвідомлений час разом зміцнює зв\'язок';

  @override
  String get composite_electromagnetic => 'Електромагнітні канали';

  @override
  String get composite_electromagneticDesc =>
      'Інтенсивне притягання - ви доповнюєте одне одного';

  @override
  String get composite_companionship => 'Канали товариства';

  @override
  String get composite_companionshipDesc =>
      'Комфорт і стабільність - спільне розуміння';

  @override
  String get composite_dominance => 'Канали домінування';

  @override
  String get composite_dominanceDesc => 'Один вчить/впливає на іншого';

  @override
  String get composite_compromise => 'Канали компромісу';

  @override
  String get composite_compromiseDesc =>
      'Природне напруження - потребує усвідомленості';

  @override
  String get composite_noConnections => 'Немає зв\'язків каналів';

  @override
  String get composite_noConnectionsDesc =>
      'Ці карти не утворюють прямих зв\'язків каналів, але можуть бути цікаві взаємодії воріт.';

  @override
  String get composite_noChartsTitle => 'Немає доступних карт';

  @override
  String get composite_noChartsDesc =>
      'Створіть карти для себе та інших, щоб порівняти динаміку відносин.';

  @override
  String get composite_needMoreCharts => 'Потрібно більше карт';

  @override
  String get composite_needMoreChartsDesc =>
      'Для аналізу відносин потрібні мінімум 2 карти. Додайте ще одну карту.';

  @override
  String get composite_selectTwoHint => 'Виберіть 2 карти для аналізу зв\'язку';

  @override
  String get composite_selectOneMore => 'Виберіть ще 1 карту';

  @override
  String get premium_upgrade => 'Перейти на Premium';

  @override
  String get premium_subscribe => 'Підписатися';

  @override
  String get premium_restore => 'Відновити покупки';

  @override
  String get premium_features => 'Можливості Premium';

  @override
  String get premium_unlimitedShares => 'Безлімітний обмін картами';

  @override
  String get premium_groupCharts => 'Групові карти';

  @override
  String get premium_advancedTransits => 'Розширений аналіз транзитів';

  @override
  String get premium_personalizedAffirmations => 'Персоналізовані афірмації';

  @override
  String get premium_journalInsights => 'Інсайти щоденника';

  @override
  String get premium_adFree => 'Без реклами';

  @override
  String get premium_monthly => 'Щомісяця';

  @override
  String get premium_yearly => 'Щорічно';

  @override
  String get premium_perMonth => '/місяць';

  @override
  String get premium_perYear => '/рік';

  @override
  String get premium_bestValue => 'Найкраща пропозиція';

  @override
  String get settings_appearance => 'Зовнішній вигляд';

  @override
  String get settings_language => 'Мова';

  @override
  String get settings_selectLanguage => 'Вибір мови';

  @override
  String get settings_changeLanguage => 'Змінити мову';

  @override
  String get settings_theme => 'Тема';

  @override
  String get settings_selectTheme => 'Вибір теми';

  @override
  String get settings_chartDisplay => 'Відображення карти';

  @override
  String get settings_showGateNumbers => 'Показувати номери воріт';

  @override
  String get settings_showGateNumbersSubtitle =>
      'Відображати номери воріт на бодіграфі';

  @override
  String get settings_use24HourTime => '24-годинний формат';

  @override
  String get settings_use24HourTimeSubtitle =>
      'Відображати час у 24-годинному форматі';

  @override
  String get settings_feedback => 'Зворотній зв\'язок';

  @override
  String get settings_hapticFeedback => 'Тактильний відгук';

  @override
  String get settings_hapticFeedbackSubtitle => 'Вібрація при взаємодії';

  @override
  String get settings_account => 'Акаунт';

  @override
  String get settings_changePassword => 'Змінити пароль';

  @override
  String get settings_deleteAccount => 'Видалити акаунт';

  @override
  String get settings_deleteAccountConfirm =>
      'Ви впевнені, що хочете видалити акаунт? Цю дію неможливо скасувати, і всі ваші дані будуть видалені назавжди.';

  @override
  String get settings_appVersion => 'Версія додатку';

  @override
  String get settings_rateApp => 'Оцінити додаток';

  @override
  String get settings_sendFeedback => 'Надіслати відгук';

  @override
  String get settings_themeLight => 'Світла';

  @override
  String get settings_themeDark => 'Темна';

  @override
  String get settings_themeSystem => 'Системна';

  @override
  String get settings_notifications => 'Сповіщення';

  @override
  String get settings_privacy => 'Конфіденційність';

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
  String get settings_about => 'Про додаток';

  @override
  String get settings_help => 'Допомога та підтримка';

  @override
  String get settings_terms => 'Умови використання';

  @override
  String get settings_privacyPolicy => 'Політика конфіденційності';

  @override
  String get settings_version => 'Версія';

  @override
  String get error_generic => 'Щось пішло не так';

  @override
  String get error_network => 'Немає підключення до інтернету';

  @override
  String get error_invalidEmail => 'Введіть коректний email';

  @override
  String get error_invalidPassword => 'Пароль має бути не менше 8 символів';

  @override
  String get error_passwordMismatch => 'Паролі не співпадають';

  @override
  String get error_birthDataRequired => 'Введіть дані народження';

  @override
  String get error_locationRequired => 'Оберіть місце народження';

  @override
  String get error_chartCalculation => 'Не вдалося розрахувати карту';

  @override
  String get profile_editProfile => 'Редагувати профіль';

  @override
  String get profile_shareChart => 'Поділитися картою';

  @override
  String get profile_exportPdf => 'Експорт у PDF';

  @override
  String get profile_upgradePremium => 'Перейти на Premium';

  @override
  String get profile_birthData => 'Дані народження';

  @override
  String get profile_chartSummary => 'Зведення карти';

  @override
  String get profile_viewFullChart => 'Переглянути повну карту';

  @override
  String get profile_signOut => 'Вийти';

  @override
  String get profile_signOutConfirm => 'Ви впевнені, що хочете вийти?';

  @override
  String get profile_addBirthDataPrompt =>
      'Додайте дані народження для створення вашої карти Дизайну Людини.';

  @override
  String get profile_addBirthDataToShare =>
      'Додайте дані народження, щоб поділитися картою';

  @override
  String get profile_addBirthDataToExport =>
      'Додайте дані народження для експорту карти';

  @override
  String get profile_exportFailed => 'Не вдалося експортувати PDF';

  @override
  String get profile_signOutConfirmTitle => 'Вихід';

  @override
  String get profile_loadFailed => 'Не вдалося завантажити профіль';

  @override
  String get profile_defaultUserName => 'Користувач Human Design';

  @override
  String get profile_birthDate => 'Дата';

  @override
  String get profile_birthTime => 'Час';

  @override
  String get profile_birthLocation => 'Місце';

  @override
  String get profile_birthTimezone => 'Часовий пояс';

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
  String get gamification_yourProgress => 'Ваш прогрес';

  @override
  String get gamification_level => 'Рівень';

  @override
  String get gamification_points => 'очків';

  @override
  String get gamification_viewAll => 'Переглянути все';

  @override
  String get gamification_allChallengesComplete =>
      'Всі щоденні завдання виконано!';

  @override
  String get gamification_dailyChallenge => 'Щоденне завдання';

  @override
  String get gamification_achievements => 'Досягнення';

  @override
  String get gamification_challenges => 'Завдання';

  @override
  String get gamification_leaderboard => 'Рейтинг';

  @override
  String get gamification_streak => 'Серія';

  @override
  String get gamification_badges => 'Значки';

  @override
  String get gamification_earnedBadge => 'Ви отримали значок!';

  @override
  String get gamification_claimReward => 'Отримати нагороду';

  @override
  String get gamification_completed => 'Виконано';

  @override
  String get common_copy => 'Копіювати';

  @override
  String get share_myShares => 'Мої посилання';

  @override
  String get share_createNew => 'Створити';

  @override
  String get share_newLink => 'Нове посилання';

  @override
  String get share_noShares => 'Немає посилань';

  @override
  String get share_noSharesMessage =>
      'Створіть посилання, щоб інші могли переглядати вашу карту без реєстрації.';

  @override
  String get share_createFirst => 'Створити перше посилання';

  @override
  String share_activeLinks(int count) {
    return '$count активних';
  }

  @override
  String share_expiredLinks(int count) {
    return '$count прострочених';
  }

  @override
  String get share_clearExpired => 'Очистити';

  @override
  String get share_clearExpiredTitle => 'Видалити прострочені посилання';

  @override
  String share_clearExpiredMessage(int count) {
    return 'Буде видалено $count прострочених посилань з історії.';
  }

  @override
  String get share_clearAll => 'Видалити все';

  @override
  String get share_expiredCleared => 'Прострочені посилання видалено';

  @override
  String get share_linkCopied => 'Посилання скопійовано';

  @override
  String get share_revokeTitle => 'Відкликати посилання';

  @override
  String get share_revokeMessage =>
      'Посилання буде деактивовано. Ті, хто має це посилання, більше не зможуть переглядати вашу карту.';

  @override
  String get share_revoke => 'Відкликати';

  @override
  String get share_linkRevoked => 'Посилання відкликано';

  @override
  String get share_totalLinks => 'Всього';

  @override
  String get share_active => 'Активні';

  @override
  String get share_totalViews => 'Перегляди';

  @override
  String get share_chartLink => 'Посилання на карту';

  @override
  String get share_transitLink => 'Посилання на транзит';

  @override
  String get share_compatibilityLink => 'Звіт сумісності';

  @override
  String get share_link => 'Посилання';

  @override
  String share_views(int count) {
    return '$count перегл.';
  }

  @override
  String get share_expired => 'Прострочено';

  @override
  String get share_activeLabel => 'Активне';

  @override
  String share_expiredOn(String date) {
    return 'Прострочено $date';
  }

  @override
  String share_expiresIn(String time) {
    return 'Закінчується через $time';
  }

  @override
  String get auth_emailNotConfirmed => 'Підтвердіть email';

  @override
  String get auth_resendConfirmation => 'Надіслати повторно';

  @override
  String get auth_confirmationSent => 'Лист надіслано';

  @override
  String get auth_checkEmail => 'Перевірте пошту для підтвердження';

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
}
