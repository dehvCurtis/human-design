// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Дизайн Человека';

  @override
  String get common_save => 'Сохранить';

  @override
  String get common_cancel => 'Отмена';

  @override
  String get common_delete => 'Удалить';

  @override
  String get common_edit => 'Редактировать';

  @override
  String get common_done => 'Готово';

  @override
  String get common_next => 'Далее';

  @override
  String get common_back => 'Назад';

  @override
  String get common_skip => 'Пропустить';

  @override
  String get common_continue => 'Продолжить';

  @override
  String get common_loading => 'Загрузка...';

  @override
  String get common_error => 'Ошибка';

  @override
  String get common_retry => 'Повторить';

  @override
  String get common_close => 'Закрыть';

  @override
  String get common_search => 'Поиск';

  @override
  String get common_share => 'Поделиться';

  @override
  String get common_settings => 'Настройки';

  @override
  String get common_logout => 'Выйти';

  @override
  String get common_profile => 'Профиль';

  @override
  String get common_type => 'Тип';

  @override
  String get common_strategy => 'Стратегия';

  @override
  String get common_authority => 'Авторитет';

  @override
  String get common_definition => 'Определённость';

  @override
  String get common_create => 'Создать';

  @override
  String get common_viewFull => 'Подробнее';

  @override
  String get common_send => 'Отправить';

  @override
  String get nav_home => 'Главная';

  @override
  String get nav_chart => 'Карта';

  @override
  String get nav_today => 'Сегодня';

  @override
  String get nav_social => 'Социум';

  @override
  String get nav_profile => 'Профиль';

  @override
  String get home_goodMorning => 'Доброе утро';

  @override
  String get home_goodAfternoon => 'Добрый день';

  @override
  String get home_goodEvening => 'Добрый вечер';

  @override
  String get home_yourDesign => 'Ваш дизайн';

  @override
  String get home_completeProfile => 'Заполните профиль';

  @override
  String get home_enterBirthData => 'Введите данные рождения';

  @override
  String get home_myChart => 'Моя карта';

  @override
  String get home_savedCharts => 'Saved';

  @override
  String get home_composite => 'Композит';

  @override
  String get home_penta => 'Пента';

  @override
  String get home_friends => 'Друзья';

  @override
  String get home_myBodygraph => 'Мой бодиграф';

  @override
  String get home_definedCenters => 'Определённые центры';

  @override
  String get home_activeChannels => 'Активные каналы';

  @override
  String get home_activeGates => 'Активные ворота';

  @override
  String get transit_today => 'Транзиты сегодня';

  @override
  String get transit_sun => 'Солнце';

  @override
  String get transit_earth => 'Земля';

  @override
  String get transit_moon => 'Луна';

  @override
  String transit_gate(int number) {
    return 'Ворота $number';
  }

  @override
  String transit_newChannelsActivated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count новых каналов активировано',
      few: '$count новых канала активировано',
      one: '1 новый канал активирован',
    );
    return '$_temp0';
  }

  @override
  String transit_gatesHighlighted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ворот выделено',
      few: '$count ворот выделено',
      one: '1 ворота выделены',
    );
    return '$_temp0';
  }

  @override
  String get transit_noConnections => 'Нет прямых транзитных связей сегодня';

  @override
  String get auth_signIn => 'Войти';

  @override
  String get auth_signUp => 'Регистрация';

  @override
  String get auth_signInWithApple => 'Войти через Apple';

  @override
  String get auth_signInWithGoogle => 'Войти через Google';

  @override
  String get auth_signInWithEmail => 'Войти по Email';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Пароль';

  @override
  String get auth_confirmPassword => 'Подтвердите пароль';

  @override
  String get auth_forgotPassword => 'Забыли пароль?';

  @override
  String get auth_noAccount => 'Нет аккаунта?';

  @override
  String get auth_hasAccount => 'Уже есть аккаунт?';

  @override
  String get auth_termsAgree =>
      'Регистрируясь, вы соглашаетесь с Условиями использования и Политикой конфиденциальности';

  @override
  String get auth_welcomeBack => 'С возвращением';

  @override
  String get auth_signInSubtitle =>
      'Войдите, чтобы продолжить путешествие по Дизайну Человека';

  @override
  String get auth_signInRequired => 'Требуется авторизация';

  @override
  String get auth_signInToCalculateChart =>
      'Войдите, чтобы рассчитать и сохранить вашу карту Дизайна Человека.';

  @override
  String get auth_signInToCreateStory =>
      'Войдите, чтобы делиться историями с сообществом.';

  @override
  String get auth_signUpSubtitle =>
      'Начните своё путешествие по Дизайну Человека сегодня';

  @override
  String get auth_signUpWithApple => 'Регистрация через Apple';

  @override
  String get auth_signUpWithGoogle => 'Регистрация через Google';

  @override
  String get auth_enterName => 'Введите ваше имя';

  @override
  String get auth_nameRequired => 'Имя обязательно';

  @override
  String get auth_termsOfService => 'Условия использования';

  @override
  String get auth_privacyPolicy => 'Политика конфиденциальности';

  @override
  String get auth_acceptTerms =>
      'Пожалуйста, примите Условия использования для продолжения';

  @override
  String get auth_resetPasswordTitle => 'Сброс пароля';

  @override
  String get auth_resetPasswordPrompt =>
      'Введите email и мы отправим вам ссылку для сброса пароля.';

  @override
  String get auth_enterEmail => 'Введите email';

  @override
  String get auth_resetEmailSent => 'Письмо для сброса пароля отправлено!';

  @override
  String get auth_name => 'Имя';

  @override
  String get auth_createAccount => 'Создать аккаунт';

  @override
  String get auth_iAgreeTo => 'Я принимаю ';

  @override
  String get auth_and => ' и ';

  @override
  String get auth_birthInformation => 'Данные рождения';

  @override
  String get auth_calculateMyChart => 'Рассчитать мою карту';

  @override
  String get onboarding_welcome => 'Добро пожаловать в Дизайн Человека';

  @override
  String get onboarding_welcomeSubtitle =>
      'Откройте свой уникальный энергетический чертёж';

  @override
  String get onboarding_birthData => 'Введите данные рождения';

  @override
  String get onboarding_birthDataSubtitle =>
      'Это необходимо для расчёта вашей карты';

  @override
  String get onboarding_birthDate => 'Дата рождения';

  @override
  String get onboarding_birthTime => 'Время рождения';

  @override
  String get onboarding_birthLocation => 'Место рождения';

  @override
  String get onboarding_searchLocation => 'Введите название города...';

  @override
  String get onboarding_unknownTime => 'Я не знаю время рождения';

  @override
  String get onboarding_timeImportance =>
      'Точное время рождения важно для точной карты';

  @override
  String get onboarding_birthDataExplanation =>
      'Ваши данные рождения используются для расчёта уникальной карты Дизайна Человека. Чем точнее информация, тем точнее будет карта.';

  @override
  String get onboarding_noTimeWarning =>
      'Без точного времени рождения некоторые детали карты (восходящий знак и линии ворот) могут быть неточными. По умолчанию будет использоваться полдень.';

  @override
  String get onboarding_enterBirthTimeInstead => 'Ввести время рождения';

  @override
  String get onboarding_birthDataPrivacy =>
      'Ваши данные рождения зашифрованы и хранятся безопасно. Вы можете обновить или удалить их в любое время в настройках профиля.';

  @override
  String get onboarding_saveFailed => 'Не удалось сохранить данные рождения';

  @override
  String get onboarding_fillAllFields =>
      'Пожалуйста, заполните все обязательные поля';

  @override
  String get onboarding_selectLanguage => 'Выберите язык';

  @override
  String get onboarding_getStarted => 'Начать';

  @override
  String get onboarding_alreadyHaveAccount => 'У меня уже есть аккаунт';

  @override
  String get onboarding_liveInAlignment =>
      'Откройте свой уникальный энергетический отпечаток и живите в гармонии со своей истинной природой.';

  @override
  String get chart_myChart => 'Моя карта';

  @override
  String get chart_viewChart => 'Показать карту';

  @override
  String get chart_calculate => 'Рассчитать карту';

  @override
  String get chart_recalculate => 'Пересчитать';

  @override
  String get chart_share => 'Поделиться картой';

  @override
  String get chart_createChart => 'Создать карту';

  @override
  String get chart_composite => 'Композитная карта';

  @override
  String get chart_transit => 'Транзиты сегодня';

  @override
  String get chart_bodygraph => 'Бодиграф';

  @override
  String get chart_planets => 'Planets';

  @override
  String get chart_details => 'Детали карты';

  @override
  String get chart_properties => 'Свойства';

  @override
  String get chart_gates => 'Ворота';

  @override
  String get chart_channels => 'Каналы';

  @override
  String get chart_noChartYet => 'Пока нет карты';

  @override
  String get chart_addBirthDataPrompt =>
      'Добавьте данные рождения для создания вашей уникальной карты Дизайна Человека.';

  @override
  String get chart_addBirthData => 'Добавить данные рождения';

  @override
  String get chart_noActiveChannels => 'Нет активных каналов';

  @override
  String get chart_channelsFormedBothGates =>
      'Каналы образуются, когда определены оба ворота.';

  @override
  String get chart_savedCharts => 'Сохранённые карты';

  @override
  String get chart_addChart => 'Добавить карту';

  @override
  String get chart_noSavedCharts => 'Нет сохранённых карт';

  @override
  String get chart_noSavedChartsMessage =>
      'Создайте карты для себя и других, чтобы сохранить их здесь.';

  @override
  String get chart_loadFailed => 'Не удалось загрузить карты';

  @override
  String get chart_renameChart => 'Переименовать карту';

  @override
  String get chart_rename => 'Переименовать';

  @override
  String get chart_renameFailed => 'Не удалось переименовать карту';

  @override
  String get chart_deleteChart => 'Удалить карту';

  @override
  String chart_deleteConfirm(String name) {
    return 'Вы уверены, что хотите удалить \"$name\"? Это действие нельзя отменить.';
  }

  @override
  String get chart_deleteFailed => 'Не удалось удалить карту';

  @override
  String get chart_you => 'Вы';

  @override
  String get chart_personName => 'Имя';

  @override
  String get chart_enterPersonName => 'Введите имя человека';

  @override
  String get chart_addChartDescription =>
      'Создайте карту для другого человека, введя его данные рождения.';

  @override
  String get chart_calculateAndSave => 'Рассчитать и сохранить карту';

  @override
  String get chart_saved => 'Карта успешно сохранена';

  @override
  String get chart_consciousGates => 'Сознательные ворота';

  @override
  String get chart_unconsciousGates => 'Бессознательные ворота';

  @override
  String get chart_personalitySide => 'Сторона личности - то, что вы осознаёте';

  @override
  String get chart_designSide => 'Сторона дизайна - то, что видят в вас другие';

  @override
  String get type_manifestor => 'Манифестор';

  @override
  String get type_generator => 'Генератор';

  @override
  String get type_manifestingGenerator => 'Манифестирующий Генератор';

  @override
  String get type_projector => 'Проектор';

  @override
  String get type_reflector => 'Рефлектор';

  @override
  String get type_manifestor_strategy => 'Информировать';

  @override
  String get type_generator_strategy => 'Откликаться';

  @override
  String get type_manifestingGenerator_strategy => 'Откликаться';

  @override
  String get type_projector_strategy => 'Ждать приглашения';

  @override
  String get type_reflector_strategy => 'Ждать лунный цикл';

  @override
  String get authority_emotional => 'Эмоциональный';

  @override
  String get authority_sacral => 'Сакральный';

  @override
  String get authority_splenic => 'Селезёночный';

  @override
  String get authority_ego => 'Эго/Сердце';

  @override
  String get authority_self => 'Само-проецируемый';

  @override
  String get authority_environment => 'Ментальный/Окружение';

  @override
  String get authority_lunar => 'Лунный';

  @override
  String get definition_none => 'Без определённости';

  @override
  String get definition_single => 'Одинарная определённость';

  @override
  String get definition_split => 'Расщеплённая определённость';

  @override
  String get definition_tripleSplit => 'Тройное расщепление';

  @override
  String get definition_quadrupleSplit => 'Четверное расщепление';

  @override
  String get profile_1_3 => '1/3 Исследователь/Мученик';

  @override
  String get profile_1_4 => '1/4 Исследователь/Оппортунист';

  @override
  String get profile_2_4 => '2/4 Отшельник/Оппортунист';

  @override
  String get profile_2_5 => '2/5 Отшельник/Еретик';

  @override
  String get profile_3_5 => '3/5 Мученик/Еретик';

  @override
  String get profile_3_6 => '3/6 Мученик/Ролевая модель';

  @override
  String get profile_4_6 => '4/6 Оппортунист/Ролевая модель';

  @override
  String get profile_4_1 => '4/1 Оппортунист/Исследователь';

  @override
  String get profile_5_1 => '5/1 Еретик/Исследователь';

  @override
  String get profile_5_2 => '5/2 Еретик/Отшельник';

  @override
  String get profile_6_2 => '6/2 Ролевая модель/Отшельник';

  @override
  String get profile_6_3 => '6/3 Ролевая модель/Мученик';

  @override
  String get center_head => 'Головной';

  @override
  String get center_ajna => 'Аджна';

  @override
  String get center_throat => 'Горловой';

  @override
  String get center_g => 'G-центр';

  @override
  String get center_heart => 'Сердечный/Эго';

  @override
  String get center_sacral => 'Сакральный';

  @override
  String get center_solarPlexus => 'Солнечное сплетение';

  @override
  String get center_spleen => 'Селезёночный';

  @override
  String get center_root => 'Корневой';

  @override
  String get center_defined => 'Определённый';

  @override
  String get center_undefined => 'Неопределённый';

  @override
  String get section_type => 'Тип';

  @override
  String get section_strategy => 'Стратегия';

  @override
  String get section_authority => 'Авторитет';

  @override
  String get section_profile => 'Профиль';

  @override
  String get section_definition => 'Определённость';

  @override
  String get section_centers => 'Центры';

  @override
  String get section_channels => 'Каналы';

  @override
  String get section_gates => 'Ворота';

  @override
  String get section_conscious => 'Сознательное (Личность)';

  @override
  String get section_unconscious => 'Бессознательное (Дизайн)';

  @override
  String get social_title => 'Социальное';

  @override
  String get social_friends => 'Друзья';

  @override
  String get social_groups => 'Группы';

  @override
  String get social_addFriend => 'Добавить друга';

  @override
  String get social_sendRequest => 'Отправить запрос';

  @override
  String get social_createGroup => 'Создать группу';

  @override
  String get social_invite => 'Пригласить';

  @override
  String get social_members => 'Участники';

  @override
  String get social_comments => 'Комментарии';

  @override
  String get social_addComment => 'Добавить комментарий...';

  @override
  String get social_noComments => 'Пока нет комментариев';

  @override
  String social_shareLimit(int remaining) {
    return 'У вас осталось $remaining публикаций в этом месяце';
  }

  @override
  String get social_visibility => 'Видимость';

  @override
  String get social_private => 'Приватно';

  @override
  String get social_friendsOnly => 'Только друзья';

  @override
  String get social_public => 'Публично';

  @override
  String get social_shared => 'Общие';

  @override
  String get social_noFriendsYet => 'Пока нет друзей';

  @override
  String get social_noFriendsMessage =>
      'Добавьте друзей для сравнения карт и изучения ваших связей.';

  @override
  String get social_noGroupsYet => 'Пока нет групп';

  @override
  String get social_noGroupsMessage =>
      'Создайте группы для анализа командной динамики с помощью Пента-анализа.';

  @override
  String get social_noSharedCharts => 'Нет общих карт';

  @override
  String get social_noSharedChartsMessage =>
      'Здесь появятся карты, которыми поделились с вами друзья.';

  @override
  String get social_pendingRequests => 'Ожидающие запросы';

  @override
  String get social_friendRequests => 'Запросы в друзья';

  @override
  String get social_noPendingRequests => 'Нет ожидающих запросов';

  @override
  String get social_addFriendPrompt =>
      'Введите email друга, чтобы отправить запрос.';

  @override
  String get social_emailLabel => 'Email';

  @override
  String get social_emailHint => 'friend@example.com';

  @override
  String get social_userNotFound => 'Пользователь с таким email не найден';

  @override
  String social_requestSent(String name) {
    return 'Запрос дружбы отправлен $name!';
  }

  @override
  String get social_createGroupPrompt =>
      'Создайте группу для анализа командной динамики.';

  @override
  String get social_groupName => 'Название группы';

  @override
  String get social_groupNameHint => 'Семья, Команда и т.д.';

  @override
  String get social_groupDescription => 'Описание (необязательно)';

  @override
  String get social_groupDescriptionHint => 'Для чего эта группа?';

  @override
  String social_groupCreated(String name) {
    return 'Группа \"$name\" создана!';
  }

  @override
  String social_friendsSince(String date) {
    return 'Друзья с $date';
  }

  @override
  String get social_compareCharts => 'Сравнить карты';

  @override
  String get social_noDescription => 'Без описания';

  @override
  String get social_admin => 'Админ';

  @override
  String social_sharedBy(String name) {
    return 'Поделился $name';
  }

  @override
  String get social_loadFriendsFailed => 'Не удалось загрузить друзей';

  @override
  String get social_loadGroupsFailed => 'Не удалось загрузить группы';

  @override
  String get social_loadSharedFailed => 'Не удалось загрузить общие карты';

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
    return 'Отправлено $time';
  }

  @override
  String time_minutesAgo(int minutes) {
    return '$minutes мин. назад';
  }

  @override
  String time_hoursAgo(int hours) {
    return '$hours ч. назад';
  }

  @override
  String time_daysAgo(int days) {
    return '$days дн. назад';
  }

  @override
  String get transit_title => 'Транзиты сегодня';

  @override
  String get transit_currentEnergies => 'Текущие энергии';

  @override
  String get transit_sunGate => 'Ворота Солнца';

  @override
  String get transit_earthGate => 'Ворота Земли';

  @override
  String get transit_moonGate => 'Ворота Луны';

  @override
  String get transit_activeGates => 'Активные транзитные ворота';

  @override
  String get transit_activeChannels => 'Активные транзитные каналы';

  @override
  String get transit_personalImpact => 'Личное влияние';

  @override
  String transit_gateActivated(int gate) {
    return 'Ворота $gate активированы транзитом';
  }

  @override
  String transit_channelFormed(String channel) {
    return 'Канал $channel образован с вашей картой';
  }

  @override
  String get transit_noPersonalImpact => 'Нет прямых транзитных связей сегодня';

  @override
  String get transit_viewFullTransit => 'Показать полную карту транзитов';

  @override
  String get affirmation_title => 'Ежедневная аффирмация';

  @override
  String affirmation_forYourType(String type) {
    return 'Для вашего типа $type';
  }

  @override
  String affirmation_basedOnGate(int gate) {
    return 'На основе ворот $gate';
  }

  @override
  String get affirmation_refresh => 'Новая аффирмация';

  @override
  String get affirmation_save => 'Сохранить аффирмацию';

  @override
  String get affirmation_saved => 'Сохранённые аффирмации';

  @override
  String get affirmation_share => 'Поделиться аффирмацией';

  @override
  String get affirmation_notifications => 'Уведомления об аффирмациях';

  @override
  String get affirmation_notificationTime => 'Время уведомления';

  @override
  String get lifestyle_today => 'Сегодня';

  @override
  String get lifestyle_insights => 'Инсайты';

  @override
  String get lifestyle_journal => 'Дневник';

  @override
  String get lifestyle_addJournalEntry => 'Добавить запись';

  @override
  String get lifestyle_journalPrompt =>
      'Как вы переживаете свой дизайн сегодня?';

  @override
  String get lifestyle_noJournalEntries => 'Пока нет записей';

  @override
  String get lifestyle_mood => 'Настроение';

  @override
  String get lifestyle_energy => 'Уровень энергии';

  @override
  String get lifestyle_reflection => 'Размышление';

  @override
  String get penta_title => 'Пента';

  @override
  String get penta_description => 'Групповой анализ для 3-5 человек';

  @override
  String get penta_createNew => 'Создать Пенту';

  @override
  String get penta_selectMembers => 'Выберите участников';

  @override
  String get penta_minMembers => 'Минимум 3 участника';

  @override
  String get penta_maxMembers => 'Максимум 5 участников';

  @override
  String get penta_groupDynamics => 'Групповая динамика';

  @override
  String get penta_missingRoles => 'Отсутствующие роли';

  @override
  String get penta_strengths => 'Сильные стороны группы';

  @override
  String get penta_analysis => 'Анализ Пента';

  @override
  String get penta_clearAnalysis => 'Очистить анализ';

  @override
  String get penta_infoText =>
      'Анализ Пента раскрывает естественные роли, возникающие в малых группах из 3-5 человек, показывая, как каждый участник влияет на динамику команды.';

  @override
  String get penta_calculating => 'Расчёт...';

  @override
  String get penta_calculate => 'Рассчитать Пента';

  @override
  String get penta_groupRoles => 'Роли в группе';

  @override
  String get penta_electromagneticConnections => 'Электромагнитные связи';

  @override
  String get penta_connectionsDescription =>
      'Особые энергетические связи между участниками, создающие притяжение и химию.';

  @override
  String get penta_areasForAttention => 'Области для внимания';

  @override
  String get composite_title => 'Композитная карта';

  @override
  String get composite_infoText =>
      'Композитная карта показывает динамику отношений между двумя людьми, раскрывая, как ваши карты взаимодействуют и дополняют друг друга.';

  @override
  String get composite_selectTwoCharts => 'Выберите 2 карты';

  @override
  String get composite_calculate => 'Анализировать связь';

  @override
  String get composite_calculating => 'Анализируем...';

  @override
  String get composite_clearAnalysis => 'Очистить анализ';

  @override
  String get composite_connectionTheme => 'Тема связи';

  @override
  String get composite_definedCenters => 'Определено';

  @override
  String get composite_undefinedCenters => 'Открыто';

  @override
  String get composite_score => 'Оценка';

  @override
  String get composite_themeVeryBonded =>
      'Очень связанные отношения - вы можете чувствовать глубокую переплетённость';

  @override
  String get composite_themeBonded =>
      'Связанные отношения - сильное чувство единства и общей энергии';

  @override
  String get composite_themeBalanced =>
      'Сбалансированные отношения - здоровое сочетание единства и независимости';

  @override
  String get composite_themeIndependent =>
      'Независимые отношения - больше пространства для личного роста';

  @override
  String get composite_themeVeryIndependent =>
      'Очень независимые отношения - осознанное время вместе укрепляет связь';

  @override
  String get composite_electromagnetic => 'Электромагнитные каналы';

  @override
  String get composite_electromagneticDesc =>
      'Интенсивное притяжение - вы дополняете друг друга';

  @override
  String get composite_companionship => 'Каналы товарищества';

  @override
  String get composite_companionshipDesc =>
      'Комфорт и стабильность - общее понимание';

  @override
  String get composite_dominance => 'Каналы доминирования';

  @override
  String get composite_dominanceDesc => 'Один учит/влияет на другого';

  @override
  String get composite_compromise => 'Каналы компромисса';

  @override
  String get composite_compromiseDesc =>
      'Естественное напряжение - требует осознанности';

  @override
  String get composite_noConnections => 'Нет связей каналов';

  @override
  String get composite_noConnectionsDesc =>
      'Эти карты не образуют прямых связей каналов, но могут быть интересные взаимодействия ворот.';

  @override
  String get composite_noChartsTitle => 'Нет доступных карт';

  @override
  String get composite_noChartsDesc =>
      'Создайте карты для себя и других, чтобы сравнить динамику отношений.';

  @override
  String get composite_needMoreCharts => 'Нужно больше карт';

  @override
  String get composite_needMoreChartsDesc =>
      'Для анализа отношений нужны минимум 2 карты. Добавьте ещё одну карту.';

  @override
  String get composite_selectTwoHint => 'Выберите 2 карты для анализа связи';

  @override
  String get composite_selectOneMore => 'Выберите ещё 1 карту';

  @override
  String get premium_upgrade => 'Перейти на Premium';

  @override
  String get premium_subscribe => 'Подписаться';

  @override
  String get premium_restore => 'Восстановить покупки';

  @override
  String get premium_features => 'Возможности Premium';

  @override
  String get premium_unlimitedShares => 'Безлимитный обмен картами';

  @override
  String get premium_groupCharts => 'Групповые карты';

  @override
  String get premium_advancedTransits => 'Расширенный анализ транзитов';

  @override
  String get premium_personalizedAffirmations =>
      'Персонализированные аффирмации';

  @override
  String get premium_journalInsights => 'Инсайты дневника';

  @override
  String get premium_adFree => 'Без рекламы';

  @override
  String get premium_monthly => 'Ежемесячно';

  @override
  String get premium_yearly => 'Ежегодно';

  @override
  String get premium_perMonth => '/месяц';

  @override
  String get premium_perYear => '/год';

  @override
  String get premium_bestValue => 'Лучшее предложение';

  @override
  String get settings_appearance => 'Внешний вид';

  @override
  String get settings_language => 'Язык';

  @override
  String get settings_selectLanguage => 'Выбор языка';

  @override
  String get settings_changeLanguage => 'Изменить язык';

  @override
  String get settings_theme => 'Тема';

  @override
  String get settings_selectTheme => 'Выбор темы';

  @override
  String get settings_chartDisplay => 'Отображение карты';

  @override
  String get settings_showGateNumbers => 'Показывать номера ворот';

  @override
  String get settings_showGateNumbersSubtitle =>
      'Отображать номера ворот на бодиграфе';

  @override
  String get settings_use24HourTime => '24-часовой формат';

  @override
  String get settings_use24HourTimeSubtitle =>
      'Отображать время в 24-часовом формате';

  @override
  String get settings_feedback => 'Обратная связь';

  @override
  String get settings_hapticFeedback => 'Тактильный отклик';

  @override
  String get settings_hapticFeedbackSubtitle => 'Вибрация при взаимодействии';

  @override
  String get settings_account => 'Аккаунт';

  @override
  String get settings_changePassword => 'Изменить пароль';

  @override
  String get settings_deleteAccount => 'Удалить аккаунт';

  @override
  String get settings_deleteAccountConfirm =>
      'Вы уверены, что хотите удалить аккаунт? Это действие необратимо, и все ваши данные будут удалены безвозвратно.';

  @override
  String get settings_appVersion => 'Версия приложения';

  @override
  String get settings_rateApp => 'Оценить приложение';

  @override
  String get settings_sendFeedback => 'Отправить отзыв';

  @override
  String get settings_themeLight => 'Светлая';

  @override
  String get settings_themeDark => 'Тёмная';

  @override
  String get settings_themeSystem => 'Системная';

  @override
  String get settings_notifications => 'Уведомления';

  @override
  String get settings_privacy => 'Конфиденциальность';

  @override
  String get settings_chartVisibility => 'Видимость карты';

  @override
  String get settings_chartVisibilitySubtitle => 'Кто может видеть вашу карту';

  @override
  String get settings_chartPrivate => 'Приватная';

  @override
  String get settings_chartPrivateDesc => 'Только вы видите свою карту';

  @override
  String get settings_chartFriends => 'Друзья';

  @override
  String get settings_chartFriendsDesc =>
      'Взаимные подписчики могут видеть вашу карту';

  @override
  String get settings_chartPublic => 'Публичная';

  @override
  String get settings_chartPublicDesc =>
      'Ваши подписчики могут видеть вашу карту';

  @override
  String get settings_about => 'О приложении';

  @override
  String get settings_help => 'Помощь и поддержка';

  @override
  String get settings_terms => 'Условия использования';

  @override
  String get settings_privacyPolicy => 'Политика конфиденциальности';

  @override
  String get settings_version => 'Версия';

  @override
  String get settings_dailyTransits => 'Ежедневные транзиты';

  @override
  String get settings_dailyTransitsSubtitle =>
      'Получать ежедневные обновления транзитов';

  @override
  String get settings_gateChanges => 'Смена ворот';

  @override
  String get settings_gateChangesSubtitle =>
      'Уведомлять при смене ворот Солнца';

  @override
  String get settings_socialActivity => 'Социальная активность';

  @override
  String get settings_socialActivitySubtitle => 'Запросы в друзья и публикации';

  @override
  String get settings_achievements => 'Достижения';

  @override
  String get settings_achievementsSubtitle => 'Новые значки и награды';

  @override
  String get settings_deleteAccountWarning =>
      'Все ваши данные, включая карты, посты и сообщения, будут безвозвратно удалены.';

  @override
  String get settings_deleteAccountFailed =>
      'Не удалось удалить аккаунт. Попробуйте ещё раз.';

  @override
  String get settings_passwordChanged => 'Пароль успешно изменён';

  @override
  String get settings_passwordChangeFailed =>
      'Не удалось изменить пароль. Попробуйте ещё раз.';

  @override
  String get settings_feedbackSubject => 'Отзыв о приложении Human Design';

  @override
  String get settings_feedbackBody =>
      'Здравствуйте,\n\nХочу поделиться отзывом о приложении Human Design:\n\n';

  @override
  String get auth_newPassword => 'Новый пароль';

  @override
  String get auth_passwordRequired => 'Введите пароль';

  @override
  String get auth_passwordTooShort => 'Пароль должен быть не менее 8 символов';

  @override
  String get auth_passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get settings_exportData => 'Экспорт моих данных';

  @override
  String get settings_exportDataSubtitle =>
      'Скачать копию всех ваших данных (GDPR)';

  @override
  String get settings_exportingData => 'Подготовка экспорта данных...';

  @override
  String get settings_exportDataSubject =>
      'Приложение Human Design - Экспорт данных';

  @override
  String get settings_exportDataFailed =>
      'Не удалось экспортировать данные. Попробуйте ещё раз.';

  @override
  String get error_generic => 'Что-то пошло не так';

  @override
  String get error_network => 'Нет подключения к интернету';

  @override
  String get error_invalidEmail => 'Введите корректный email';

  @override
  String get error_invalidPassword => 'Пароль должен быть не менее 8 символов';

  @override
  String get error_passwordMismatch => 'Пароли не совпадают';

  @override
  String get error_birthDataRequired => 'Введите данные рождения';

  @override
  String get error_locationRequired => 'Выберите место рождения';

  @override
  String get error_chartCalculation => 'Не удалось рассчитать карту';

  @override
  String get profile_editProfile => 'Редактировать профиль';

  @override
  String get profile_shareChart => 'Поделиться картой';

  @override
  String get profile_exportPdf => 'Экспорт в PDF';

  @override
  String get profile_upgradePremium => 'Перейти на Premium';

  @override
  String get profile_birthData => 'Данные рождения';

  @override
  String get profile_chartSummary => 'Сводка карты';

  @override
  String get profile_viewFullChart => 'Смотреть полную карту';

  @override
  String get profile_signOut => 'Выйти';

  @override
  String get profile_signOutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get profile_addBirthDataPrompt =>
      'Добавьте данные рождения для создания вашей карты Дизайна Человека.';

  @override
  String get profile_addBirthDataToShare =>
      'Добавьте данные рождения, чтобы поделиться картой';

  @override
  String get profile_addBirthDataToExport =>
      'Добавьте данные рождения для экспорта карты';

  @override
  String get profile_exportFailed => 'Не удалось экспортировать PDF';

  @override
  String get profile_signOutConfirmTitle => 'Выход';

  @override
  String get profile_loadFailed => 'Не удалось загрузить профиль';

  @override
  String get profile_defaultUserName => 'Пользователь Human Design';

  @override
  String get profile_birthDate => 'Дата';

  @override
  String get profile_birthTime => 'Время';

  @override
  String get profile_birthLocation => 'Место';

  @override
  String get profile_birthTimezone => 'Часовой пояс';

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
  String get gamification_yourProgress => 'Ваш прогресс';

  @override
  String get gamification_level => 'Уровень';

  @override
  String get gamification_points => 'очков';

  @override
  String get gamification_viewAll => 'Показать все';

  @override
  String get gamification_allChallengesComplete =>
      'Все ежедневные задания выполнены!';

  @override
  String get gamification_dailyChallenge => 'Ежедневное задание';

  @override
  String get gamification_achievements => 'Достижения';

  @override
  String get gamification_challenges => 'Задания';

  @override
  String get gamification_leaderboard => 'Рейтинг';

  @override
  String get gamification_streak => 'Серия';

  @override
  String get gamification_badges => 'Значки';

  @override
  String get gamification_earnedBadge => 'Вы получили значок!';

  @override
  String get gamification_claimReward => 'Получить награду';

  @override
  String get gamification_completed => 'Выполнено';

  @override
  String get common_copy => 'Копировать';

  @override
  String get share_myShares => 'Мои ссылки';

  @override
  String get share_createNew => 'Создать';

  @override
  String get share_newLink => 'Новая ссылка';

  @override
  String get share_noShares => 'Нет ссылок';

  @override
  String get share_noSharesMessage =>
      'Создайте ссылки, чтобы другие могли просматривать вашу карту без регистрации.';

  @override
  String get share_createFirst => 'Создать первую ссылку';

  @override
  String share_activeLinks(int count) {
    return '$count активных';
  }

  @override
  String share_expiredLinks(int count) {
    return '$count истекших';
  }

  @override
  String get share_clearExpired => 'Очистить';

  @override
  String get share_clearExpiredTitle => 'Удалить истекшие ссылки';

  @override
  String share_clearExpiredMessage(int count) {
    return 'Будет удалено $count истекших ссылок из истории.';
  }

  @override
  String get share_clearAll => 'Удалить все';

  @override
  String get share_expiredCleared => 'Истекшие ссылки удалены';

  @override
  String get share_linkCopied => 'Ссылка скопирована';

  @override
  String get share_revokeTitle => 'Отозвать ссылку';

  @override
  String get share_revokeMessage =>
      'Ссылка будет деактивирована. Те, у кого есть эта ссылка, больше не смогут просматривать вашу карту.';

  @override
  String get share_revoke => 'Отозвать';

  @override
  String get share_linkRevoked => 'Ссылка отозвана';

  @override
  String get share_totalLinks => 'Всего';

  @override
  String get share_active => 'Активные';

  @override
  String get share_totalViews => 'Просмотры';

  @override
  String get share_chartLink => 'Ссылка на карту';

  @override
  String get share_transitLink => 'Ссылка на транзит';

  @override
  String get share_compatibilityLink => 'Отчёт совместимости';

  @override
  String get share_link => 'Ссылка';

  @override
  String share_views(int count) {
    return '$count просм.';
  }

  @override
  String get share_expired => 'Истекла';

  @override
  String get share_activeLabel => 'Активна';

  @override
  String share_expiredOn(String date) {
    return 'Истекла $date';
  }

  @override
  String share_expiresIn(String time) {
    return 'Истекает через $time';
  }

  @override
  String get auth_emailNotConfirmed => 'Подтвердите email';

  @override
  String get auth_resendConfirmation => 'Отправить повторно';

  @override
  String get auth_confirmationSent => 'Письмо отправлено';

  @override
  String get auth_checkEmail => 'Проверьте почту для подтверждения';

  @override
  String get auth_checkYourEmail => 'Проверьте почту';

  @override
  String get auth_confirmationLinkSent =>
      'Мы отправили ссылку для подтверждения на:';

  @override
  String get auth_clickLinkToActivate =>
      'Пожалуйста, нажмите на ссылку в письме для активации аккаунта.';

  @override
  String get auth_goToSignIn => 'Перейти к входу';

  @override
  String get auth_returnToHome => 'Вернуться на главную';

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
