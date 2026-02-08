// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'AuraMap';

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
  String get common_like => 'Подобається';

  @override
  String get common_reply => 'Відповісти';

  @override
  String get common_deleteConfirmation =>
      'Ви впевнені, що хочете видалити? Цю дію не можна скасувати.';

  @override
  String get common_comingSoon => 'Незабаром!';

  @override
  String get nav_home => 'Головна';

  @override
  String get nav_chart => 'Карта';

  @override
  String get nav_today => 'День';

  @override
  String get nav_social => 'Соціум';

  @override
  String get nav_profile => 'Профіль';

  @override
  String get nav_more => 'Більше';

  @override
  String get nav_learn => 'Навчання';

  @override
  String get affirmation_savedSuccess => 'Афірмацію збережено!';

  @override
  String get affirmation_alreadySaved => 'Афірмацію вже збережено';

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
  String get home_savedCharts => 'Збережені';

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
  String get auth_signInRequired => 'Потрібна авторизація';

  @override
  String get auth_signInToCalculateChart =>
      'Увійдіть, щоб розрахувати та зберегти вашу карту Дизайну Людини.';

  @override
  String get auth_signInToCreateStory =>
      'Увійдіть, щоб ділитися історіями зі спільнотою.';

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
  String get chart_planets => 'Планети';

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
  String get social_thoughts => 'Думки';

  @override
  String get social_discover => 'Пошук';

  @override
  String get social_groups => 'Групи';

  @override
  String get social_invite => 'Запросити';

  @override
  String get social_createPost => 'Поділіться думкою...';

  @override
  String get social_noThoughtsYet => 'Поки немає записів';

  @override
  String get social_noThoughtsMessage =>
      'Будьте першим, хто поділиться своїми відкриттями про Дизайн Людини!';

  @override
  String get social_createGroup => 'Створити групу';

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
  String get social_noGroupsYet => 'Поки немає груп';

  @override
  String get social_noGroupsMessage =>
      'Створіть групи для аналізу командної динаміки з Пента-аналізом.';

  @override
  String get social_noSharedCharts => 'Немає спільних карт';

  @override
  String get social_noSharedChartsMessage =>
      'Тут з\'являться карти, якими з вами поділились.';

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
  String get social_groupNameRequired => 'Будь ласка, введіть назву групи';

  @override
  String get social_createGroupFailed =>
      'Не вдалося створити групу. Спробуйте ще раз.';

  @override
  String get social_noDescription => 'Без опису';

  @override
  String get social_admin => 'Адмін';

  @override
  String social_sharedBy(String name) {
    return 'Поділився $name';
  }

  @override
  String get social_loadGroupsFailed => 'Не вдалося завантажити групи';

  @override
  String get social_loadSharedFailed => 'Не вдалося завантажити спільні карти';

  @override
  String get social_userNotFound => 'Користувача не знайдено';

  @override
  String get discovery_userNotFound => 'Користувача не знайдено';

  @override
  String get discovery_following => 'Підписаний';

  @override
  String get discovery_follow => 'Підписатися';

  @override
  String get discovery_sendMessage => 'Написати';

  @override
  String get discovery_about => 'Про себе';

  @override
  String get discovery_humanDesign => 'Дизайн Людини';

  @override
  String get discovery_type => 'Тип';

  @override
  String get discovery_profile => 'Профіль';

  @override
  String get discovery_authority => 'Авторитет';

  @override
  String get discovery_compatibility => 'Сумісність';

  @override
  String get discovery_compatible => 'сумісні';

  @override
  String get discovery_followers => 'Підписники';

  @override
  String get discovery_followingLabel => 'Підписки';

  @override
  String get discovery_noResults => 'Користувачів не знайдено';

  @override
  String get discovery_noResultsMessage =>
      'Спробуйте змінити фільтри або зайдіть пізніше';

  @override
  String get userProfile_viewChart => 'Бодіграф';

  @override
  String get userProfile_chartPrivate => 'Ця карта приватна';

  @override
  String get userProfile_chartFriendsOnly =>
      'Станьте взаємними підписниками, щоб побачити цю карту';

  @override
  String get userProfile_chartFollowToView =>
      'Підпишіться, щоб побачити цю карту';

  @override
  String get userProfile_publicProfile => 'Публічний профіль';

  @override
  String get userProfile_privateProfile => 'Приватний профіль';

  @override
  String get userProfile_friendsOnlyProfile => 'Тільки для друзів';

  @override
  String get userProfile_followersList => 'Підписники';

  @override
  String get userProfile_followingList => 'Підписки';

  @override
  String get userProfile_noFollowers => 'Поки немає підписників';

  @override
  String get userProfile_noFollowing => 'Поки ні на кого не підписаний';

  @override
  String get userProfile_thoughts => 'Думки';

  @override
  String get userProfile_noThoughts => 'Поки немає опублікованих думок';

  @override
  String get userProfile_showAll => 'Показати все';

  @override
  String get popularCharts_title => 'Популярні карти';

  @override
  String get popularCharts_subtitle => 'Найпопулярніші публічні карти';

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
  String get settings_chartVisibility => 'Видимість карти';

  @override
  String get settings_chartVisibilitySubtitle => 'Хто може бачити вашу карту';

  @override
  String get settings_chartPrivate => 'Приватна';

  @override
  String get settings_chartPrivateDesc => 'Тільки ви бачите свою карту';

  @override
  String get settings_chartFriends => 'Друзі';

  @override
  String get settings_chartFriendsDesc =>
      'Взаємні підписники можуть бачити вашу карту';

  @override
  String get settings_chartPublic => 'Публічна';

  @override
  String get settings_chartPublicDesc =>
      'Ваші підписники можуть бачити вашу карту';

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
  String get settings_dailyTransits => 'Щоденні транзити';

  @override
  String get settings_dailyTransitsSubtitle =>
      'Отримувати щоденні оновлення транзитів';

  @override
  String get settings_gateChanges => 'Зміна воріт';

  @override
  String get settings_gateChangesSubtitle => 'Сповіщати про зміну воріт Сонця';

  @override
  String get settings_socialActivity => 'Соціальна активність';

  @override
  String get settings_socialActivitySubtitle => 'Запити в друзі та публікації';

  @override
  String get settings_achievements => 'Досягнення';

  @override
  String get settings_achievementsSubtitle => 'Нові значки та нагороди';

  @override
  String get settings_deleteAccountWarning =>
      'Усі ваші дані, включаючи карти, пости та повідомлення, будуть безповоротно видалені.';

  @override
  String get settings_deleteAccountFailed =>
      'Не вдалося видалити акаунт. Спробуйте ще раз.';

  @override
  String get settings_passwordChanged => 'Пароль успішно змінено';

  @override
  String get settings_passwordChangeFailed =>
      'Не вдалося змінити пароль. Спробуйте ще раз.';

  @override
  String get settings_feedbackSubject => 'Відгук про додаток AuraMap';

  @override
  String get settings_feedbackBody =>
      'Вітаю,\n\nХочу поділитися відгуком про додаток AuraMap:\n\n';

  @override
  String get auth_newPassword => 'Новий пароль';

  @override
  String get auth_passwordRequired => 'Введіть пароль';

  @override
  String get auth_passwordTooShort => 'Пароль має бути не менше 8 символів';

  @override
  String get auth_passwordsDoNotMatch => 'Паролі не співпадають';

  @override
  String get settings_exportData => 'Експорт моїх даних';

  @override
  String get settings_exportDataSubtitle =>
      'Завантажити копію всіх ваших даних (GDPR)';

  @override
  String get settings_exportingData => 'Підготовка експорту даних...';

  @override
  String get settings_exportDataSubject => 'AuraMap - Експорт даних';

  @override
  String get settings_exportDataFailed =>
      'Не вдалося експортувати дані. Спробуйте ще раз.';

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
  String get profile_defaultUserName => 'Користувач AuraMap';

  @override
  String get profile_birthDate => 'Дата';

  @override
  String get profile_birthTime => 'Час';

  @override
  String get profile_birthLocation => 'Місце';

  @override
  String get profile_birthTimezone => 'Часовий пояс';

  @override
  String get chart_chakras => 'Чакри';

  @override
  String get chakra_title => 'Енергія чакр';

  @override
  String get chakra_activated => 'Активована';

  @override
  String get chakra_inactive => 'Неактивна';

  @override
  String chakra_activatedCount(int count) {
    return '$count з 7 чакр активовано';
  }

  @override
  String get chakra_hdMapping => 'Відповідність центрам HD';

  @override
  String get chakra_element => 'Елемент';

  @override
  String get chakra_location => 'Розташування';

  @override
  String get chakra_root => 'Муладхара';

  @override
  String get chakra_root_sanskrit => 'Muladhara';

  @override
  String get chakra_root_description => 'Заземлення, виживання та стабільність';

  @override
  String get chakra_sacral => 'Свадхістхана';

  @override
  String get chakra_sacral_sanskrit => 'Svadhisthana';

  @override
  String get chakra_sacral_description => 'Творчість, сексуальність та емоції';

  @override
  String get chakra_solarPlexus => 'Маніпура';

  @override
  String get chakra_solarPlexus_sanskrit => 'Manipura';

  @override
  String get chakra_solarPlexus_description =>
      'Особиста сила, впевненість та воля';

  @override
  String get chakra_heart => 'Анахата';

  @override
  String get chakra_heart_sanskrit => 'Anahata';

  @override
  String get chakra_heart_description => 'Любов, співчуття та зв\'язок';

  @override
  String get chakra_throat => 'Вішуддха';

  @override
  String get chakra_throat_sanskrit => 'Vishuddha';

  @override
  String get chakra_throat_description => 'Спілкування, вираження та правда';

  @override
  String get chakra_thirdEye => 'Аджна';

  @override
  String get chakra_thirdEye_sanskrit => 'Ajna';

  @override
  String get chakra_thirdEye_description => 'Інтуїція, прозріння та уява';

  @override
  String get chakra_crown => 'Сахасрара';

  @override
  String get chakra_crown_sanskrit => 'Sahasrara';

  @override
  String get chakra_crown_description => 'Духовний зв\'язок та свідомість';

  @override
  String get quiz_title => 'Тести';

  @override
  String get quiz_yourProgress => 'Ваш прогрес';

  @override
  String quiz_quizzesCompleted(int count) {
    return '$count тестів завершено';
  }

  @override
  String get quiz_accuracy => 'Точність';

  @override
  String get quiz_streak => 'Серія';

  @override
  String get quiz_all => 'Усі';

  @override
  String get quiz_difficulty => 'Складність';

  @override
  String get quiz_beginner => 'Початківець';

  @override
  String get quiz_intermediate => 'Середній';

  @override
  String get quiz_advanced => 'Просунутий';

  @override
  String quiz_questions(int count) {
    return '$count питань';
  }

  @override
  String quiz_points(int points) {
    return '+$points очк.';
  }

  @override
  String get quiz_completed => 'Завершено';

  @override
  String get quiz_noQuizzes => 'Немає доступних тестів';

  @override
  String get quiz_checkBackLater => 'Загляньте пізніше за новим контентом';

  @override
  String get quiz_startQuiz => 'Почати тест';

  @override
  String get quiz_tryAgain => 'Спробувати знову';

  @override
  String get quiz_backToQuizzes => 'До тестів';

  @override
  String get quiz_shareResults => 'Поділитися результатами';

  @override
  String get quiz_yourBest => 'Ваш найкращий';

  @override
  String get quiz_perfectScore => 'Ідеальний результат!';

  @override
  String get quiz_newBest => 'Новий рекорд!';

  @override
  String get quiz_streakExtended => 'Серію продовжено!';

  @override
  String quiz_questionOf(int current, int total) {
    return 'Питання $current з $total';
  }

  @override
  String quiz_correct(int count) {
    return '$count правильно';
  }

  @override
  String get quiz_submitAnswer => 'Відповісти';

  @override
  String get quiz_nextQuestion => 'Наступне питання';

  @override
  String get quiz_seeResults => 'Результати';

  @override
  String get quiz_exitQuiz => 'Вийти з тесту?';

  @override
  String get quiz_exitWarning => 'Ваш прогрес буде втрачено.';

  @override
  String get quiz_exit => 'Вийти';

  @override
  String get quiz_timesUp => 'Час вийшов!';

  @override
  String get quiz_timesUpMessage =>
      'Час закінчився. Ваш прогрес буде збережено.';

  @override
  String get quiz_excellent => 'Чудово!';

  @override
  String get quiz_goodJob => 'Гарна робота!';

  @override
  String get quiz_keepLearning => 'Продовжуйте вчитися!';

  @override
  String get quiz_keepPracticing => 'Продовжуйте практикуватися!';

  @override
  String get quiz_masteredTopic => 'Ви освоїли цю тему!';

  @override
  String get quiz_strongUnderstanding => 'У вас гарне розуміння.';

  @override
  String get quiz_onRightTrack => 'Ви на правильному шляху.';

  @override
  String get quiz_reviewExplanations => 'Вивчіть пояснення для покращення.';

  @override
  String get quiz_studyMaterial => 'Вивчіть матеріал і спробуйте знову.';

  @override
  String get quiz_attemptHistory => 'Історія спроб';

  @override
  String get quiz_statistics => 'Статистика тестів';

  @override
  String get quiz_totalQuizzes => 'Тестів';

  @override
  String get quiz_totalQuestions => 'Питань';

  @override
  String get quiz_bestStreak => 'Найкраща серія';

  @override
  String quiz_strongest(String category) {
    return 'Найсильніша: $category';
  }

  @override
  String quiz_needsWork(String category) {
    return 'Потребує роботи: $category';
  }

  @override
  String get quiz_category_types => 'Типи';

  @override
  String get quiz_category_centers => 'Центри';

  @override
  String get quiz_category_authorities => 'Авторитети';

  @override
  String get quiz_category_profiles => 'Профілі';

  @override
  String get quiz_category_gates => 'Ворота';

  @override
  String get quiz_category_channels => 'Канали';

  @override
  String get quiz_category_definitions => 'Визначеності';

  @override
  String get quiz_category_general => 'Загальне';

  @override
  String get quiz_explanation => 'Пояснення';

  @override
  String get quiz_quizzes => 'Тести';

  @override
  String get quiz_questionsLabel => 'Питання';

  @override
  String get quiz_shareProgress => 'Поділитися прогресом';

  @override
  String get quiz_shareProgressSubject =>
      'Мій прогрес у вивченні Дизайну Людини';

  @override
  String get quiz_sharePerfect =>
      'Я досяг ідеального результату! Освоюю Дизайн Людини.';

  @override
  String get quiz_shareExcellent =>
      'Чудово просуваюся у вивченні Дизайну Людини!';

  @override
  String get quiz_shareGoodJob =>
      'Вивчаю Дизайн Людини. Кожен тест допомагає рости!';

  @override
  String quiz_shareSubject(String quizTitle, int score) {
    return 'Мій результат $score% у \"$quizTitle\" - Тест Дизайну Людини';
  }

  @override
  String get quiz_failedToLoadStats => 'Не вдалося завантажити статистику';

  @override
  String get planetary_personality => 'Особистість';

  @override
  String get planetary_design => 'Дизайн';

  @override
  String get planetary_consciousBirth => 'Свідоме · Народження';

  @override
  String get planetary_unconsciousPrenatal => 'Несвідоме · 88° Пренатально';

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
  String get auth_checkYourEmail => 'Перевірте пошту';

  @override
  String get auth_confirmationLinkSent =>
      'Ми надіслали посилання для підтвердження на:';

  @override
  String get auth_clickLinkToActivate =>
      'Будь ласка, натисніть на посилання в листі для активації акаунту.';

  @override
  String get auth_goToSignIn => 'Перейти до входу';

  @override
  String get auth_returnToHome => 'Повернутися на головну';

  @override
  String get hashtags_explore => 'Хештеги';

  @override
  String get hashtags_trending => 'У тренді';

  @override
  String get hashtags_popular => 'Популярні';

  @override
  String get hashtags_hdTopics => 'Теми HD';

  @override
  String get hashtags_noTrending => 'Поки немає трендових хештегів';

  @override
  String get hashtags_noPopular => 'Поки немає популярних хештегів';

  @override
  String get hashtags_noHdTopics => 'Поки немає тем HD';

  @override
  String get hashtag_noPosts => 'Поки немає постів';

  @override
  String get hashtag_beFirst => 'Будьте першим, хто напише з цим хештегом!';

  @override
  String hashtag_postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count постів',
      few: '$count пости',
      one: '1 пост',
    );
    return '$_temp0';
  }

  @override
  String hashtag_recentPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count постів сьогодні',
      few: '$count пости сьогодні',
      one: '1 пост сьогодні',
    );
    return '$_temp0';
  }

  @override
  String get feed_forYou => 'Для вас';

  @override
  String get feed_trending => 'У тренді';

  @override
  String get feed_hdTopics => 'Теми HD';

  @override
  String feed_gateTitle(int number) {
    return 'Ворота $number';
  }

  @override
  String feed_gatePosts(int number) {
    return 'Пости про ворота $number';
  }

  @override
  String get transit_events_title => 'Події транзитів';

  @override
  String get transit_events_happening => 'Зараз';

  @override
  String get transit_events_upcoming => 'Майбутні';

  @override
  String get transit_events_past => 'Минулі';

  @override
  String get transit_events_noCurrentEvents => 'Зараз немає активних подій';

  @override
  String get transit_events_noUpcomingEvents => 'Немає запланованих подій';

  @override
  String get transit_events_noPastEvents => 'Немає минулих подій';

  @override
  String get transit_events_live => 'LIVE';

  @override
  String get transit_events_join => 'Приєднатися';

  @override
  String get transit_events_joined => 'Приєднався';

  @override
  String get transit_events_leave => 'Покинути';

  @override
  String get transit_events_participating => 'беруть участь';

  @override
  String get transit_events_posts => 'постів';

  @override
  String get transit_events_viewInsights => 'Переглянути інсайти';

  @override
  String transit_events_endsIn(String time) {
    return 'Закінчується через $time';
  }

  @override
  String transit_events_startsIn(String time) {
    return 'Почнеться через $time';
  }

  @override
  String get transit_events_notFound => 'Подію не знайдено';

  @override
  String get transit_events_communityPosts => 'Пости спільноти';

  @override
  String get transit_events_noPosts => 'Поки немає постів для цієї події';

  @override
  String get transit_events_shareExperience => 'Поділитися досвідом';

  @override
  String get transit_events_participants => 'Учасники';

  @override
  String get transit_events_duration => 'Тривалість';

  @override
  String get transit_events_eventEnded => 'Подія завершилася';

  @override
  String get transit_events_youreParticipating => 'Ви берете участь!';

  @override
  String transit_events_experiencingWith(int count) {
    return 'Переживають цей транзит з $count іншими';
  }

  @override
  String get transit_events_joinCommunity => 'Приєднатися до спільноти';

  @override
  String get transit_events_shareYourExperience =>
      'Поділіться досвідом та зв\'яжіться з іншими';

  @override
  String get activity_title => 'Активність друзів';

  @override
  String get activity_noActivities => 'Поки немає активності друзів';

  @override
  String get activity_followFriends =>
      'Підпишіться на друзів, щоб бачити їхні досягнення тут!';

  @override
  String get activity_findFriends => 'Знайти друзів';

  @override
  String get activity_celebrate => 'Привітати';

  @override
  String get activity_celebrated => 'Привітали';

  @override
  String get cancel => 'Скасувати';

  @override
  String get create => 'Створити';

  @override
  String get groupChallenges_title => 'Групові челенджі';

  @override
  String get groupChallenges_myTeams => 'Мої команди';

  @override
  String get groupChallenges_challenges => 'Челенджі';

  @override
  String get groupChallenges_leaderboard => 'Рейтинг';

  @override
  String get groupChallenges_createTeam => 'Створити команду';

  @override
  String get groupChallenges_teamName => 'Назва команди';

  @override
  String get groupChallenges_teamNameHint => 'Введіть назву команди';

  @override
  String get groupChallenges_teamDescription => 'Опис';

  @override
  String get groupChallenges_teamDescriptionHint => 'Про що ваша команда?';

  @override
  String get groupChallenges_teamCreated => 'Команду створено!';

  @override
  String get groupChallenges_noTeams => 'Поки немає команд';

  @override
  String get groupChallenges_noTeamsDescription =>
      'Створіть або приєднайтеся до команди для участі в групових челенджах!';

  @override
  String groupChallenges_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count учасників',
      few: '$count учасники',
      one: '1 учасник',
    );
    return '$_temp0';
  }

  @override
  String groupChallenges_points(int points) {
    return '$points очк.';
  }

  @override
  String get groupChallenges_noChallenges => 'Немає активних челенджів';

  @override
  String get groupChallenges_active => 'Активні';

  @override
  String get groupChallenges_upcoming => 'Майбутні';

  @override
  String groupChallenges_reward(int points) {
    return '$points очк. нагорода';
  }

  @override
  String groupChallenges_teamsEnrolled(String count) {
    return '$count команд';
  }

  @override
  String groupChallenges_participants(String count) {
    return '$count учасників';
  }

  @override
  String groupChallenges_endsIn(String time) {
    return 'Закінчується через $time';
  }

  @override
  String get groupChallenges_weekly => 'Тиждень';

  @override
  String get groupChallenges_monthly => 'Місяць';

  @override
  String get groupChallenges_allTime => 'Весь час';

  @override
  String get groupChallenges_noTeamsOnLeaderboard =>
      'Поки немає команд у рейтингу';

  @override
  String get groupChallenges_pts => 'очк.';

  @override
  String get groupChallenges_teamNotFound => 'Команду не знайдено';

  @override
  String get groupChallenges_members => 'Учасники';

  @override
  String get groupChallenges_totalPoints => 'Всього очків';

  @override
  String get groupChallenges_joined => 'Приєднався';

  @override
  String get groupChallenges_join => 'Вступити';

  @override
  String get groupChallenges_status => 'Статус';

  @override
  String get groupChallenges_about => 'Про команду';

  @override
  String get groupChallenges_noMembers => 'Поки немає учасників';

  @override
  String get groupChallenges_admin => 'Адмін';

  @override
  String groupChallenges_contributed(int points) {
    return '$points очк. внесено';
  }

  @override
  String get groupChallenges_joinedTeam => 'Ви вступили до команди!';

  @override
  String get groupChallenges_leaveTeam => 'Покинути команду';

  @override
  String get groupChallenges_leaveConfirmation =>
      'Ви впевнені, що хочете покинути команду? Ваші очки залишаться з командою.';

  @override
  String get groupChallenges_leave => 'Покинути';

  @override
  String get groupChallenges_leftTeam => 'Ви покинули команду';

  @override
  String get groupChallenges_challengeDetails => 'Деталі челенджу';

  @override
  String get groupChallenges_challengeNotFound => 'Челендж не знайдено';

  @override
  String get groupChallenges_target => 'Ціль';

  @override
  String get groupChallenges_starts => 'Початок';

  @override
  String get groupChallenges_ends => 'Кінець';

  @override
  String get groupChallenges_hdTypes => 'Типи HD';

  @override
  String get groupChallenges_noTeamsToEnroll => 'Немає команд для запису';

  @override
  String get groupChallenges_createTeamToJoin =>
      'Спочатку створіть команду для участі в челенджах';

  @override
  String get groupChallenges_enrollTeam => 'Записати команду';

  @override
  String get groupChallenges_enrolled => 'Записані';

  @override
  String get groupChallenges_enroll => 'Записати';

  @override
  String get groupChallenges_teamEnrolled => 'Команду успішно записано!';

  @override
  String get groupChallenges_noTeamsEnrolled => 'Поки немає записаних команд';

  @override
  String get circles_title => 'Кола сумісності';

  @override
  String get circles_myCircles => 'Мої кола';

  @override
  String get circles_invitations => 'Запрошення';

  @override
  String get circles_create => 'Створити коло';

  @override
  String get circles_selectIcon => 'Оберіть іконку';

  @override
  String get circles_name => 'Назва кола';

  @override
  String get circles_nameHint => 'Сім\'я, Команда, Друзі...';

  @override
  String get circles_description => 'Опис';

  @override
  String get circles_descriptionHint => 'Для чого це коло?';

  @override
  String get circles_created => 'Коло успішно створено!';

  @override
  String get circles_noCircles => 'Поки немає кіл';

  @override
  String get circles_noCirclesDescription =>
      'Створіть коло для аналізу сумісності з друзями, сім\'єю або колегами.';

  @override
  String get circles_suggestions => 'Швидкий старт';

  @override
  String circles_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count учасників',
      few: '$count учасники',
      one: '1 учасник',
    );
    return '$_temp0';
  }

  @override
  String get circles_private => 'Приватне';

  @override
  String get circles_noInvitations => 'Немає запрошень';

  @override
  String get circles_noInvitationsDescription =>
      'Тут з\'являться запрошення в кола.';

  @override
  String circles_invitedBy(String name) {
    return 'Запросив $name';
  }

  @override
  String get circles_decline => 'Відхилити';

  @override
  String get circles_accept => 'Прийняти';

  @override
  String get circles_invitationDeclined => 'Запрошення відхилено';

  @override
  String get circles_invitationAccepted => 'Ви приєдналися до кола!';

  @override
  String get circles_notFound => 'Коло не знайдено';

  @override
  String get circles_invite => 'Запросити';

  @override
  String get circles_members => 'Учасники';

  @override
  String get circles_analysis => 'Аналіз';

  @override
  String get circles_feed => 'Стрічка';

  @override
  String get circles_inviteMember => 'Запросити учасника';

  @override
  String get circles_sendInvite => 'Надіслати запрошення';

  @override
  String get circles_invitationSent => 'Запрошення надіслано!';

  @override
  String get circles_invitationFailed => 'Не вдалося надіслати запрошення';

  @override
  String get circles_deleteTitle => 'Видалити коло';

  @override
  String circles_deleteConfirmation(String name) {
    return 'Ви впевнені, що хочете видалити \"$name\"? Цю дію не можна скасувати.';
  }

  @override
  String get circles_deleted => 'Коло видалено';

  @override
  String get circles_noMembers => 'Поки немає учасників';

  @override
  String get circles_noAnalysis => 'Поки немає аналізу';

  @override
  String get circles_runAnalysis =>
      'Запустіть аналіз сумісності, щоб побачити, як взаємодіють учасники кола.';

  @override
  String get circles_needMoreMembers =>
      'Додайте мінімум 2 учасників для аналізу.';

  @override
  String get circles_analyzeCompatibility => 'Аналізувати сумісність';

  @override
  String get circles_harmonyScore => 'Оцінка гармонії';

  @override
  String get circles_typeDistribution => 'Розподіл типів';

  @override
  String get circles_electromagneticConnections => 'Електромагнітні зв\'язки';

  @override
  String get circles_electromagneticDesc =>
      'Інтенсивне притягання - ви доповнюєте одне одного';

  @override
  String get circles_companionshipConnections => 'Зв\'язки товариства';

  @override
  String get circles_companionshipDesc =>
      'Комфорт і стабільність - спільне розуміння';

  @override
  String get circles_groupStrengths => 'Сильні сторони групи';

  @override
  String get circles_areasForGrowth => 'Області для зростання';

  @override
  String get circles_writePost => 'Поділіться чимось з вашим колом...';

  @override
  String get circles_noPosts => 'Поки немає постів';

  @override
  String get circles_beFirstToPost =>
      'Будьте першим, хто поділиться чимось з вашим колом!';

  @override
  String get experts_title => 'Експерти HD';

  @override
  String get experts_becomeExpert => 'Стати експертом';

  @override
  String get experts_filterBySpecialization => 'Фільтр за спеціалізацією';

  @override
  String get experts_allExperts => 'Усі експерти';

  @override
  String get experts_experts => 'Експерти';

  @override
  String get experts_noExperts => 'Експертів не знайдено';

  @override
  String get experts_featured => 'Рекомендовані експерти';

  @override
  String experts_followers(int count) {
    return '$count підписників';
  }

  @override
  String get experts_notFound => 'Експерта не знайдено';

  @override
  String get experts_following => 'Підписаний';

  @override
  String get experts_follow => 'Підписатися';

  @override
  String get experts_about => 'Про себе';

  @override
  String get experts_specializations => 'Спеціалізації';

  @override
  String get experts_credentials => 'Кваліфікації';

  @override
  String get experts_reviews => 'Відгуки';

  @override
  String get experts_writeReview => 'Написати відгук';

  @override
  String get experts_reviewContent => 'Ваш відгук';

  @override
  String get experts_reviewHint =>
      'Поділіться досвідом роботи з цим експертом...';

  @override
  String get experts_submitReview => 'Надіслати відгук';

  @override
  String get experts_reviewSubmitted => 'Відгук успішно надіслано!';

  @override
  String get experts_noReviews => 'Поки немає відгуків';

  @override
  String get experts_followersLabel => 'Підписники';

  @override
  String get experts_rating => 'Рейтинг';

  @override
  String get experts_years => 'Років';

  @override
  String get learningPaths_title => 'Навчальні шляхи';

  @override
  String get learningPaths_explore => 'Огляд';

  @override
  String get learningPaths_inProgress => 'У процесі';

  @override
  String get learningPaths_completed => 'Завершені';

  @override
  String get learningPaths_featured => 'Рекомендовані шляхи';

  @override
  String get learningPaths_allPaths => 'Усі шляхи';

  @override
  String get learningPaths_noPathsExplore =>
      'Немає доступних навчальних шляхів';

  @override
  String get learningPaths_noPathsInProgress => 'Немає шляхів у процесі';

  @override
  String get learningPaths_noPathsInProgressDescription =>
      'Запишіться на навчальний шлях, щоб почати!';

  @override
  String get learningPaths_browsePaths => 'Огляд шляхів';

  @override
  String get learningPaths_noPathsCompleted => 'Немає завершених шляхів';

  @override
  String get learningPaths_noPathsCompletedDescription =>
      'Завершені навчальні шляхи з\'являться тут!';

  @override
  String learningPaths_enrolled(int count) {
    return '$count записано';
  }

  @override
  String learningPaths_stepsCount(int count) {
    return '$count кроків';
  }

  @override
  String learningPaths_progress(int completed, int total) {
    return '$completed з $total кроків';
  }

  @override
  String get learningPaths_resume => 'Продовжити';

  @override
  String learningPaths_completedOn(String date) {
    return 'Завершено $date';
  }

  @override
  String get learningPathNotFound => 'Навчальний шлях не знайдено';

  @override
  String learningPathMinutes(int minutes) {
    return '$minutes хв';
  }

  @override
  String learningPathSteps(int count) {
    return '$count кроків';
  }

  @override
  String learningPathBy(String author) {
    return 'Від $author';
  }

  @override
  String learningPathEnrolled(int count) {
    return '$count записано';
  }

  @override
  String learningPathCompleted(int count) {
    return '$count завершено';
  }

  @override
  String get learningPathEnroll => 'Почати навчання';

  @override
  String get learningPathYourProgress => 'Ваш прогрес';

  @override
  String get learningPathCompletedBadge => 'Завершено';

  @override
  String learningPathProgressText(int completed, int total) {
    return '$completed з $total кроків завершено';
  }

  @override
  String get learningPathStepsTitle => 'Кроки навчання';

  @override
  String get learningPathEnrollTitle => 'Почати цей шлях?';

  @override
  String learningPathEnrollMessage(String title) {
    return 'Ви будете записані на \"$title\" і зможете відстежувати прогрес.';
  }

  @override
  String get learningPathViewContent => 'Переглянути контент';

  @override
  String get learningPathMarkComplete => 'Позначити як завершене';

  @override
  String get learningPathStepCompleted => 'Крок завершено!';

  @override
  String get thought_title => 'Думки';

  @override
  String get thought_feedTitle => 'Думки';

  @override
  String get thought_createNew => 'Поділитися думкою';

  @override
  String get thought_emptyFeed => 'Стрічка думок порожня';

  @override
  String get thought_emptyFeedMessage =>
      'Підпишіться на людей або поділіться думкою';

  @override
  String get thought_regenerate => 'Репост';

  @override
  String thought_regeneratedFrom(String username) {
    return 'Репост від @$username';
  }

  @override
  String get thought_regenerateSuccess => 'Думку додано на вашу стіну!';

  @override
  String get thought_regenerateConfirm => 'Зробити репост?';

  @override
  String get thought_regenerateDescription =>
      'Думка з\'явиться на вашій стіні з посиланням на автора.';

  @override
  String get thought_addComment => 'Додати коментар (необов\'язково)';

  @override
  String thought_regenerateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count репостів',
      few: '$count репости',
      one: '1 репост',
    );
    return '$_temp0';
  }

  @override
  String get thought_cannotRegenerateOwn =>
      'Не можна зробити репост своєї думки';

  @override
  String get thought_alreadyRegenerated => 'Ви вже зробили репост цієї думки';

  @override
  String get thought_postDetail => 'Думка';

  @override
  String get thought_noComments => 'Коментарів поки немає. Будьте першим!';

  @override
  String thought_replyingTo(String username) {
    return 'Відповідь для $username';
  }

  @override
  String get thought_writeReply => 'Напишіть відповідь...';

  @override
  String get thought_commentPlaceholder => 'Додати коментар...';

  @override
  String get messages_title => 'Повідомлення';

  @override
  String get messages_conversation => 'Бесіда';

  @override
  String get messages_loading => 'Завантаження...';

  @override
  String get messages_muteNotifications => 'Вимкнути сповіщення';

  @override
  String get messages_notificationsMuted => 'Сповіщення вимкнено';

  @override
  String get messages_blockUser => 'Заблокувати';

  @override
  String get messages_blockUserConfirm =>
      'Ви впевнені, що хочете заблокувати цього користувача? Ви більше не отримуватимете від нього повідомлень.';

  @override
  String get messages_userBlocked => 'Користувача заблоковано';

  @override
  String get messages_block => 'Заблокувати';

  @override
  String get messages_deleteConversation => 'Видалити бесіду';

  @override
  String get messages_deleteConversationConfirm =>
      'Ви впевнені, що хочете видалити цю бесіду? Цю дію не можна скасувати.';

  @override
  String get messages_conversationDeleted => 'Бесіду видалено';

  @override
  String get messages_startConversation => 'Почніть бесіду!';

  @override
  String get profile_takePhoto => 'Зробити фото';

  @override
  String get profile_chooseFromGallery => 'Обрати з галереї';

  @override
  String get profile_avatarUpdated => 'Аватар успішно оновлено';

  @override
  String get profile_profileUpdated => 'Профіль успішно оновлено';

  @override
  String get profile_noProfileFound => 'Профіль не знайдено';

  @override
  String get discovery_title => 'Пошук';

  @override
  String get discovery_searchUsers => 'Пошук користувачів...';

  @override
  String get discovery_discoverTab => 'Пошук';

  @override
  String get discovery_followingTab => 'Підписки';

  @override
  String get discovery_followersTab => 'Підписники';

  @override
  String get discovery_noUsersFound => 'Користувачів не знайдено';

  @override
  String get discovery_tryAdjustingFilters => 'Спробуйте змінити фільтри';

  @override
  String get discovery_notFollowingAnyone => 'Не підписаний ні на кого';

  @override
  String get discovery_discoverPeople => 'Знайдіть людей для підписки';

  @override
  String get discovery_noFollowersYet => 'Поки немає підписників';

  @override
  String get discovery_shareInsights =>
      'Діліться інсайтами, щоб отримати підписників';

  @override
  String get discovery_clearAll => 'Очистити все';

  @override
  String chart_gate(int number) {
    return 'Ворота $number';
  }

  @override
  String chart_channel(String id) {
    return 'Канал $id';
  }

  @override
  String get chart_center => 'Центр';

  @override
  String get chart_keynote => 'Ключова нота';

  @override
  String get chart_element => 'Елемент';

  @override
  String get chart_location => 'Розташування';

  @override
  String get chart_hdCenters => 'Центри HD';

  @override
  String get reaction_comment => 'Коментар';

  @override
  String get reaction_react => 'Реакція';

  @override
  String get reaction_standard => 'Стандартні';

  @override
  String get reaction_humanDesign => 'Human Design';

  @override
  String get share_shareChart => 'Поділитися картою';

  @override
  String get share_createShareLink => 'Створити посилання';

  @override
  String get share_shareViaUrl => 'Поділитися посиланням';

  @override
  String get share_exportAsPng => 'Експорт у PNG';

  @override
  String get share_fullReport => 'Повний звіт';

  @override
  String get share_linkExpiration => 'Термін дії посилання';

  @override
  String get share_neverExpires => 'Безстроково';

  @override
  String get share_oneHour => '1 година';

  @override
  String get share_twentyFourHours => '24 години';

  @override
  String get share_sevenDays => '7 днів';

  @override
  String get share_thirtyDays => '30 днів';

  @override
  String get share_creating => 'Створюємо...';

  @override
  String get share_signInToShare => 'Увійдіть, щоб поділитися картою';

  @override
  String get share_createShareableLinks =>
      'Створюйте посилання на вашу карту Дизайну Людини';

  @override
  String get share_linkImage => 'Зображення';

  @override
  String get share_pdf => 'PDF';

  @override
  String get post_share => 'Поділитися';

  @override
  String get post_edit => 'Редагувати';

  @override
  String get post_report => 'Поскаржитися';

  @override
  String get mentorship_title => 'Наставництво';

  @override
  String get mentorship_pendingRequests => 'Очікувані запити';

  @override
  String get mentorship_availableMentors => 'Доступні наставники';

  @override
  String get mentorship_noMentorsAvailable => 'Немає доступних наставників';

  @override
  String mentorship_requestMentorship(String name) {
    return 'Запросити наставництво у $name';
  }

  @override
  String get mentorship_sendMessage => 'Напишіть, чому хочете навчитися:';

  @override
  String get mentorship_learnPrompt => 'Я хотів би дізнатися більше про...';

  @override
  String get mentorship_requestSent => 'Запит надіслано!';

  @override
  String get mentorship_sendRequest => 'Надіслати запит';

  @override
  String get mentorship_becomeAMentor => 'Стати наставником';

  @override
  String get mentorship_shareKnowledge => 'Діліться знаннями про Дизайн Людини';

  @override
  String get story_cancel => 'Скасувати';

  @override
  String get story_createStory => 'Створити історію';

  @override
  String get story_share => 'Поділитися';

  @override
  String get story_typeYourStory => 'Введіть вашу історію...';

  @override
  String get story_background => 'Фон';

  @override
  String get story_attachTransitGate =>
      'Прикріпити транзитні ворота (необов\'язково)';

  @override
  String get story_none => 'Немає';

  @override
  String story_gateNumber(int number) {
    return 'Ворота $number';
  }

  @override
  String get story_whoCanSee => 'Хто може бачити?';

  @override
  String get story_followers => 'Підписники';

  @override
  String get story_everyone => 'Усі';

  @override
  String get challenges_title => 'Завдання';

  @override
  String get challenges_daily => 'Денні';

  @override
  String get challenges_weekly => 'Тижневі';

  @override
  String get challenges_monthly => 'Місячні';

  @override
  String get challenges_noDailyChallenges => 'Немає денних завдань';

  @override
  String get challenges_noWeeklyChallenges => 'Немає тижневих завдань';

  @override
  String get challenges_noMonthlyChallenges => 'Немає місячних завдань';

  @override
  String get challenges_errorLoading => 'Помилка завантаження завдань';

  @override
  String challenges_claimedPoints(int points) {
    return 'Отримано $points очків!';
  }

  @override
  String get challenges_totalPoints => 'Всього очків';

  @override
  String get challenges_level => 'Рівень';

  @override
  String get learning_all => 'Усі';

  @override
  String get learning_types => 'Типи';

  @override
  String get learning_gates => 'Ворота';

  @override
  String get learning_centers => 'Центри';

  @override
  String get learning_liveSessions => 'Прямі ефіри';

  @override
  String get quiz_noActiveSession => 'Немає активної сесії тесту';

  @override
  String get quiz_noQuestionsAvailable => 'Немає доступних питань';

  @override
  String get quiz_ok => 'ОК';

  @override
  String get liveSessions_title => 'Прямі ефіри';

  @override
  String get liveSessions_upcoming => 'Майбутні';

  @override
  String get liveSessions_mySessions => 'Мої сесії';

  @override
  String get liveSessions_errorLoading => 'Помилка завантаження сесій';

  @override
  String get liveSessions_registeredSuccessfully => 'Реєстрація успішна!';

  @override
  String get liveSessions_cancelRegistration => 'Скасувати реєстрацію';

  @override
  String get liveSessions_cancelRegistrationConfirm =>
      'Ви впевнені, що хочете скасувати реєстрацію?';

  @override
  String get liveSessions_no => 'Ні';

  @override
  String get liveSessions_yesCancel => 'Так, скасувати';

  @override
  String get liveSessions_registrationCancelled => 'Реєстрацію скасовано';

  @override
  String get gateChannelPicker_gates => 'Ворота (64)';

  @override
  String get gateChannelPicker_channels => 'Канали (36)';

  @override
  String get gateChannelPicker_search => 'Пошук воріт або каналів...';

  @override
  String get leaderboard_weekly => 'Тиждень';

  @override
  String get leaderboard_monthly => 'Місяць';

  @override
  String get leaderboard_allTime => 'Весь час';

  @override
  String get ai_chatTitle => 'AI Асистент';

  @override
  String get ai_askAi => 'Запитати AI';

  @override
  String get ai_askAboutChart => 'Запитати AI про вашу карту';

  @override
  String get ai_miniDescription =>
      'Отримайте персональні інсайти про ваш Дизайн Людини';

  @override
  String get ai_startChatting => 'Почати чат';

  @override
  String get ai_welcomeTitle => 'Ваш HD Асистент';

  @override
  String get ai_welcomeSubtitle =>
      'Запитайте мене будь-що про вашу карту Дизайну Людини. Я можу пояснити ваш тип, стратегію, авторитет, ворота, канали та багато іншого.';

  @override
  String get ai_inputPlaceholder => 'Запитайте про вашу карту...';

  @override
  String get ai_newConversation => 'Нова розмова';

  @override
  String get ai_conversations => 'Розмови';

  @override
  String get ai_noConversations => 'Розмов поки немає';

  @override
  String get ai_noConversationsMessage =>
      'Почніть розмову з AI, щоб отримати персональні інсайти по карті.';

  @override
  String get ai_deleteConversation => 'Видалити розмову';

  @override
  String get ai_deleteConversationConfirm =>
      'Ви впевнені, що хочете видалити цю розмову?';

  @override
  String get ai_messagesExhausted => 'Безкоштовні повідомлення вичерпано';

  @override
  String get ai_upgradeForUnlimited =>
      'Оновіться до Преміум для безлімітних AI розмов про вашу карту Дизайну Людини.';

  @override
  String ai_usageCount(int used, int limit) {
    return '$used з $limit безкоштовних повідомлень використано';
  }

  @override
  String get ai_errorGeneric => 'Щось пішло не так. Спробуйте ще раз.';

  @override
  String get ai_errorNetwork =>
      'Не вдалося підключитися до AI сервісу. Перевірте з\'єднання.';

  @override
  String get events_title => 'Події спільноти';

  @override
  String get events_upcoming => 'Майбутні';

  @override
  String get events_past => 'Минулі';

  @override
  String get events_create => 'Створити подію';

  @override
  String get events_noUpcoming => 'Немає майбутніх подій';

  @override
  String get events_noUpcomingMessage =>
      'Створіть подію, щоб об\'єднати HD спільноту!';

  @override
  String get events_online => 'Онлайн';

  @override
  String get events_inPerson => 'Очно';

  @override
  String get events_hybrid => 'Гібрид';

  @override
  String events_participants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count учасників',
      many: '$count учасників',
      few: '$count учасники',
      one: '1 учасник',
    );
    return '$_temp0';
  }

  @override
  String get events_register => 'Зареєструватися';

  @override
  String get events_registered => 'Зареєстрований';

  @override
  String get events_cancelRegistration => 'Скасувати реєстрацію';

  @override
  String get events_registrationFull => 'Подію заповнено';

  @override
  String get events_eventTitle => 'Назва події';

  @override
  String get events_eventDescription => 'Опис';

  @override
  String get events_eventType => 'Тип події';

  @override
  String get events_startDate => 'Дата та час початку';

  @override
  String get events_endDate => 'Дата та час закінчення';

  @override
  String get events_location => 'Місце проведення';

  @override
  String get events_virtualLink => 'Посилання на онлайн-зустріч';

  @override
  String get events_maxParticipants => 'Максимум учасників';

  @override
  String get events_hdTypeFilter => 'Фільтр за типом HD';

  @override
  String get events_allTypes => 'Для всіх типів';

  @override
  String get events_created => 'Подію створено!';

  @override
  String get events_deleted => 'Подію видалено';

  @override
  String get events_notFound => 'Подію не знайдено';

  @override
  String get chartOfDay_title => 'Карта дня';

  @override
  String get chartOfDay_featured => 'Рекомендована карта';

  @override
  String get chartOfDay_viewChart => 'Переглянути карту';

  @override
  String get discussion_typeDiscussion => 'Обговорення типів';

  @override
  String get discussion_channelDiscussion => 'Обговорення каналів';

  @override
  String get ai_wantMoreInsights => 'Бажаєте більше AI-інсайтів?';

  @override
  String ai_messagesPackTitle(int count) {
    return '$count повідомлень';
  }

  @override
  String get ai_orSubscribe => 'або підпишіться на безлімітний доступ';

  @override
  String get ai_bestValue => 'Найкраща ціна';

  @override
  String get ai_getMoreMessages => 'Отримати більше повідомлень';

  @override
  String ai_fromPrice(String price) {
    return 'Від $price';
  }

  @override
  String ai_perMessage(String price) {
    return '$price/повідомлення';
  }
}
