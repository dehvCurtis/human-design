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
  String get auth_signInRequired => 'Sign In Required';

  @override
  String get auth_signInToCalculateChart =>
      'Please sign in to calculate and save your Human Design chart.';

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
  String get chart_composite => 'Композитная карта';

  @override
  String get chart_transit => 'Транзиты сегодня';

  @override
  String get chart_bodygraph => 'Бодиграф';

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
}
