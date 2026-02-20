// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Inside Me';

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
  String get common_like => 'Нравится';

  @override
  String get common_reply => 'Ответить';

  @override
  String get common_deleteConfirmation =>
      'Вы уверены, что хотите удалить? Это действие нельзя отменить.';

  @override
  String get common_comingSoon => 'Скоро!';

  @override
  String get nav_home => 'Главная';

  @override
  String get nav_chart => 'Карта';

  @override
  String get nav_today => 'День';

  @override
  String get nav_social => 'Социум';

  @override
  String get nav_profile => 'Профиль';

  @override
  String get nav_ai => 'ИИ';

  @override
  String get nav_more => 'Ещё';

  @override
  String get nav_learn => 'Обучение';

  @override
  String get affirmation_savedSuccess => 'Аффирмация сохранена!';

  @override
  String get affirmation_alreadySaved => 'Аффирмация уже сохранена';

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
  String get home_savedCharts => 'Сохранённые';

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
  String get chart_planets => 'Планеты';

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
  String get social_thoughts => 'Мысли';

  @override
  String get social_discover => 'Поиск';

  @override
  String get social_groups => 'Группы';

  @override
  String get social_invite => 'Пригласить';

  @override
  String get social_createPost => 'Поделитесь мыслью...';

  @override
  String get social_noThoughtsYet => 'Пока нет записей';

  @override
  String get social_noThoughtsMessage =>
      'Будьте первым, кто поделится своими открытиями о Дизайне Человека!';

  @override
  String get social_createGroup => 'Создать группу';

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
  String get social_noGroupsYet => 'Пока нет групп';

  @override
  String get social_noGroupsMessage =>
      'Создайте группы для анализа командной динамики с помощью Пента-анализа.';

  @override
  String get social_noSharedCharts => 'Нет общих карт';

  @override
  String get social_noSharedChartsMessage =>
      'Здесь появятся карты, которыми с вами поделились.';

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
  String get social_groupNameRequired => 'Пожалуйста, введите название группы';

  @override
  String get social_createGroupFailed =>
      'Не удалось создать группу. Попробуйте снова.';

  @override
  String get social_noDescription => 'Без описания';

  @override
  String get social_admin => 'Админ';

  @override
  String social_sharedBy(String name) {
    return 'Поделился $name';
  }

  @override
  String get social_loadGroupsFailed => 'Не удалось загрузить группы';

  @override
  String get social_loadSharedFailed => 'Не удалось загрузить общие карты';

  @override
  String get social_userNotFound => 'Пользователь не найден';

  @override
  String get discovery_userNotFound => 'Пользователь не найден';

  @override
  String get discovery_following => 'Подписан';

  @override
  String get discovery_follow => 'Подписаться';

  @override
  String get discovery_sendMessage => 'Написать';

  @override
  String get discovery_about => 'О себе';

  @override
  String get discovery_humanDesign => 'Дизайн Человека';

  @override
  String get discovery_type => 'Тип';

  @override
  String get discovery_profile => 'Профиль';

  @override
  String get discovery_authority => 'Авторитет';

  @override
  String get discovery_compatibility => 'Совместимость';

  @override
  String get discovery_compatible => 'совместимы';

  @override
  String get discovery_followers => 'Подписчики';

  @override
  String get discovery_followingLabel => 'Подписки';

  @override
  String get discovery_noResults => 'Пользователи не найдены';

  @override
  String get discovery_noResultsMessage =>
      'Попробуйте изменить фильтры или зайдите позже';

  @override
  String get userProfile_viewChart => 'Бодиграф';

  @override
  String get userProfile_chartPrivate => 'Эта карта приватная';

  @override
  String get userProfile_chartFriendsOnly =>
      'Станьте взаимными подписчиками, чтобы увидеть эту карту';

  @override
  String get userProfile_chartFollowToView =>
      'Подпишитесь, чтобы увидеть эту карту';

  @override
  String get userProfile_publicProfile => 'Открытый профиль';

  @override
  String get userProfile_privateProfile => 'Закрытый профиль';

  @override
  String get userProfile_friendsOnlyProfile => 'Только для друзей';

  @override
  String get userProfile_followersList => 'Подписчики';

  @override
  String get userProfile_followingList => 'Подписки';

  @override
  String get userProfile_noFollowers => 'Пока нет подписчиков';

  @override
  String get userProfile_noFollowing => 'Пока ни на кого не подписан';

  @override
  String get userProfile_thoughts => 'Мысли';

  @override
  String get userProfile_noThoughts => 'Пока нет опубликованных мыслей';

  @override
  String get userProfile_showAll => 'Показать все';

  @override
  String get popularCharts_title => 'Популярные карты';

  @override
  String get popularCharts_subtitle => 'Самые популярные публичные карты';

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
  String get settings_telegramSupport => 'Поддержка в Telegram';

  @override
  String get settings_telegramSupportSubtitle =>
      'Получите помощь в нашей группе Telegram';

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
  String get settings_feedbackSubject => 'Отзыв о приложении Inside Me';

  @override
  String get settings_feedbackBody =>
      'Здравствуйте,\n\nХочу поделиться отзывом о приложении Inside Me:\n\n';

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
  String get settings_exportDataSubject => 'Inside Me - Экспорт данных';

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
  String get profile_defaultUserName => 'Пользователь Inside Me';

  @override
  String get profile_birthDate => 'Дата';

  @override
  String get profile_birthTime => 'Время';

  @override
  String get profile_birthLocation => 'Место';

  @override
  String get profile_birthTimezone => 'Часовой пояс';

  @override
  String get chart_chakras => 'Чакры';

  @override
  String get chakra_title => 'Энергия чакр';

  @override
  String get chakra_activated => 'Активирована';

  @override
  String get chakra_inactive => 'Неактивна';

  @override
  String chakra_activatedCount(int count) {
    return '$count из 7 чакр активировано';
  }

  @override
  String get chakra_hdMapping => 'Соответствие центрам HD';

  @override
  String get chakra_element => 'Элемент';

  @override
  String get chakra_location => 'Расположение';

  @override
  String get chakra_root => 'Муладхара';

  @override
  String get chakra_root_sanskrit => 'Muladhara';

  @override
  String get chakra_root_description => 'Заземление, выживание и стабильность';

  @override
  String get chakra_sacral => 'Свадхистхана';

  @override
  String get chakra_sacral_sanskrit => 'Svadhisthana';

  @override
  String get chakra_sacral_description => 'Творчество, сексуальность и эмоции';

  @override
  String get chakra_solarPlexus => 'Манипура';

  @override
  String get chakra_solarPlexus_sanskrit => 'Manipura';

  @override
  String get chakra_solarPlexus_description =>
      'Личная сила, уверенность и воля';

  @override
  String get chakra_heart => 'Анахата';

  @override
  String get chakra_heart_sanskrit => 'Anahata';

  @override
  String get chakra_heart_description => 'Любовь, сострадание и связь';

  @override
  String get chakra_throat => 'Вишуддха';

  @override
  String get chakra_throat_sanskrit => 'Vishuddha';

  @override
  String get chakra_throat_description => 'Общение, выражение и правда';

  @override
  String get chakra_thirdEye => 'Аджна';

  @override
  String get chakra_thirdEye_sanskrit => 'Ajna';

  @override
  String get chakra_thirdEye_description => 'Интуиция, прозрение и воображение';

  @override
  String get chakra_crown => 'Сахасрара';

  @override
  String get chakra_crown_sanskrit => 'Sahasrara';

  @override
  String get chakra_crown_description => 'Духовная связь и сознание';

  @override
  String get quiz_title => 'Тесты';

  @override
  String get quiz_yourProgress => 'Ваш прогресс';

  @override
  String quiz_quizzesCompleted(int count) {
    return '$count тестов завершено';
  }

  @override
  String get quiz_accuracy => 'Точность';

  @override
  String get quiz_streak => 'Серия';

  @override
  String get quiz_all => 'Все';

  @override
  String get quiz_difficulty => 'Сложность';

  @override
  String get quiz_beginner => 'Начинающий';

  @override
  String get quiz_intermediate => 'Средний';

  @override
  String get quiz_advanced => 'Продвинутый';

  @override
  String quiz_questions(int count) {
    return '$count вопросов';
  }

  @override
  String quiz_points(int points) {
    return '+$points очк.';
  }

  @override
  String get quiz_completed => 'Завершён';

  @override
  String get quiz_noQuizzes => 'Нет доступных тестов';

  @override
  String get quiz_checkBackLater => 'Загляните позже за новым контентом';

  @override
  String get quiz_startQuiz => 'Начать тест';

  @override
  String get quiz_tryAgain => 'Попробовать снова';

  @override
  String get quiz_backToQuizzes => 'К тестам';

  @override
  String get quiz_shareResults => 'Поделиться результатами';

  @override
  String get quiz_yourBest => 'Ваш лучший';

  @override
  String get quiz_perfectScore => 'Идеальный результат!';

  @override
  String get quiz_newBest => 'Новый рекорд!';

  @override
  String get quiz_streakExtended => 'Серия продлена!';

  @override
  String quiz_questionOf(int current, int total) {
    return 'Вопрос $current из $total';
  }

  @override
  String quiz_correct(int count) {
    return '$count правильно';
  }

  @override
  String get quiz_submitAnswer => 'Ответить';

  @override
  String get quiz_nextQuestion => 'Следующий вопрос';

  @override
  String get quiz_seeResults => 'Результаты';

  @override
  String get quiz_exitQuiz => 'Выйти из теста?';

  @override
  String get quiz_exitWarning => 'Ваш прогресс будет потерян.';

  @override
  String get quiz_exit => 'Выйти';

  @override
  String get quiz_timesUp => 'Время вышло!';

  @override
  String get quiz_timesUpMessage =>
      'Время закончилось. Ваш прогресс будет сохранён.';

  @override
  String get quiz_excellent => 'Отлично!';

  @override
  String get quiz_goodJob => 'Хорошая работа!';

  @override
  String get quiz_keepLearning => 'Продолжайте учиться!';

  @override
  String get quiz_keepPracticing => 'Продолжайте практиковаться!';

  @override
  String get quiz_masteredTopic => 'Вы освоили эту тему!';

  @override
  String get quiz_strongUnderstanding => 'У вас хорошее понимание.';

  @override
  String get quiz_onRightTrack => 'Вы на правильном пути.';

  @override
  String get quiz_reviewExplanations => 'Изучите объяснения для улучшения.';

  @override
  String get quiz_studyMaterial => 'Изучите материал и попробуйте снова.';

  @override
  String get quiz_attemptHistory => 'История попыток';

  @override
  String get quiz_statistics => 'Статистика тестов';

  @override
  String get quiz_totalQuizzes => 'Тестов';

  @override
  String get quiz_totalQuestions => 'Вопросов';

  @override
  String get quiz_bestStreak => 'Лучшая серия';

  @override
  String quiz_strongest(String category) {
    return 'Сильнейшая: $category';
  }

  @override
  String quiz_needsWork(String category) {
    return 'Требует работы: $category';
  }

  @override
  String get quiz_category_types => 'Типы';

  @override
  String get quiz_category_centers => 'Центры';

  @override
  String get quiz_category_authorities => 'Авторитеты';

  @override
  String get quiz_category_profiles => 'Профили';

  @override
  String get quiz_category_gates => 'Ворота';

  @override
  String get quiz_category_channels => 'Каналы';

  @override
  String get quiz_category_definitions => 'Определённости';

  @override
  String get quiz_category_general => 'Общее';

  @override
  String get quiz_explanation => 'Объяснение';

  @override
  String get quiz_quizzes => 'Тесты';

  @override
  String get quiz_questionsLabel => 'Вопросы';

  @override
  String get quiz_shareProgress => 'Поделиться прогрессом';

  @override
  String get quiz_shareProgressSubject =>
      'Мой прогресс в изучении Дизайна Человека';

  @override
  String get quiz_sharePerfect =>
      'Я достиг идеального результата! Осваиваю Дизайн Человека.';

  @override
  String get quiz_shareExcellent =>
      'Отлично продвигаюсь в изучении Дизайна Человека!';

  @override
  String get quiz_shareGoodJob =>
      'Изучаю Дизайн Человека. Каждый тест помогает расти!';

  @override
  String quiz_shareSubject(String quizTitle, int score) {
    return 'Мой результат $score% в \"$quizTitle\" - Тест Дизайна Человека';
  }

  @override
  String get quiz_failedToLoadStats => 'Не удалось загрузить статистику';

  @override
  String get planetary_personality => 'Личность';

  @override
  String get planetary_design => 'Дизайн';

  @override
  String get planetary_consciousBirth => 'Сознательное · Рождение';

  @override
  String get planetary_unconsciousPrenatal =>
      'Бессознательное · 88° Пренатально';

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
  String get hashtags_explore => 'Хэштеги';

  @override
  String get hashtags_trending => 'В тренде';

  @override
  String get hashtags_popular => 'Популярные';

  @override
  String get hashtags_hdTopics => 'Темы HD';

  @override
  String get hashtags_noTrending => 'Пока нет трендовых хэштегов';

  @override
  String get hashtags_noPopular => 'Пока нет популярных хэштегов';

  @override
  String get hashtags_noHdTopics => 'Пока нет тем HD';

  @override
  String get hashtag_noPosts => 'Пока нет постов';

  @override
  String get hashtag_beFirst => 'Будьте первым, кто напишет с этим хэштегом!';

  @override
  String hashtag_postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count постов',
      few: '$count поста',
      one: '1 пост',
    );
    return '$_temp0';
  }

  @override
  String hashtag_recentPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count постов сегодня',
      few: '$count поста сегодня',
      one: '1 пост сегодня',
    );
    return '$_temp0';
  }

  @override
  String get feed_forYou => 'Для вас';

  @override
  String get feed_trending => 'В тренде';

  @override
  String get feed_hdTopics => 'Темы HD';

  @override
  String feed_gateTitle(int number) {
    return 'Ворота $number';
  }

  @override
  String feed_gatePosts(int number) {
    return 'Посты о воротах $number';
  }

  @override
  String get transit_events_title => 'События транзитов';

  @override
  String get transit_events_happening => 'Сейчас';

  @override
  String get transit_events_upcoming => 'Предстоящие';

  @override
  String get transit_events_past => 'Прошедшие';

  @override
  String get transit_events_noCurrentEvents => 'Сейчас нет активных событий';

  @override
  String get transit_events_noUpcomingEvents => 'Нет запланированных событий';

  @override
  String get transit_events_noPastEvents => 'Нет прошедших событий';

  @override
  String get transit_events_live => 'LIVE';

  @override
  String get transit_events_join => 'Участвовать';

  @override
  String get transit_events_joined => 'Участвую';

  @override
  String get transit_events_leave => 'Покинуть';

  @override
  String get transit_events_participating => 'участвуют';

  @override
  String get transit_events_posts => 'постов';

  @override
  String get transit_events_viewInsights => 'Смотреть инсайты';

  @override
  String transit_events_endsIn(String time) {
    return 'Заканчивается через $time';
  }

  @override
  String transit_events_startsIn(String time) {
    return 'Начнётся через $time';
  }

  @override
  String get transit_events_notFound => 'Событие не найдено';

  @override
  String get transit_events_communityPosts => 'Посты сообщества';

  @override
  String get transit_events_noPosts => 'Пока нет постов для этого события';

  @override
  String get transit_events_shareExperience => 'Поделиться опытом';

  @override
  String get transit_events_participants => 'Участники';

  @override
  String get transit_events_duration => 'Длительность';

  @override
  String get transit_events_eventEnded => 'Событие завершилось';

  @override
  String get transit_events_youreParticipating => 'Вы участвуете!';

  @override
  String transit_events_experiencingWith(int count) {
    return 'Переживают этот транзит с $count другими';
  }

  @override
  String get transit_events_joinCommunity => 'Присоединиться к сообществу';

  @override
  String get transit_events_shareYourExperience =>
      'Поделитесь опытом и свяжитесь с другими';

  @override
  String get activity_title => 'Активность друзей';

  @override
  String get activity_noActivities => 'Пока нет активности друзей';

  @override
  String get activity_followFriends =>
      'Подпишитесь на друзей, чтобы видеть их достижения здесь!';

  @override
  String get activity_findFriends => 'Найти друзей';

  @override
  String get activity_celebrate => 'Поздравить';

  @override
  String get activity_celebrated => 'Поздравили';

  @override
  String get cancel => 'Отмена';

  @override
  String get create => 'Создать';

  @override
  String get groupChallenges_title => 'Групповые челленджи';

  @override
  String get groupChallenges_myTeams => 'Мои команды';

  @override
  String get groupChallenges_challenges => 'Челленджи';

  @override
  String get groupChallenges_leaderboard => 'Рейтинг';

  @override
  String get groupChallenges_createTeam => 'Создать команду';

  @override
  String get groupChallenges_teamName => 'Название команды';

  @override
  String get groupChallenges_teamNameHint => 'Введите название команды';

  @override
  String get groupChallenges_teamDescription => 'Описание';

  @override
  String get groupChallenges_teamDescriptionHint => 'О чём ваша команда?';

  @override
  String get groupChallenges_teamCreated => 'Команда создана!';

  @override
  String get groupChallenges_noTeams => 'Пока нет команд';

  @override
  String get groupChallenges_noTeamsDescription =>
      'Создайте или присоединитесь к команде для участия в групповых челленджах!';

  @override
  String groupChallenges_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников',
      few: '$count участника',
      one: '1 участник',
    );
    return '$_temp0';
  }

  @override
  String groupChallenges_points(int points) {
    return '$points очк.';
  }

  @override
  String get groupChallenges_noChallenges => 'Нет активных челленджей';

  @override
  String get groupChallenges_active => 'Активные';

  @override
  String get groupChallenges_upcoming => 'Предстоящие';

  @override
  String groupChallenges_reward(int points) {
    return '$points очк. награда';
  }

  @override
  String groupChallenges_teamsEnrolled(String count) {
    return '$count команд';
  }

  @override
  String groupChallenges_participants(String count) {
    return '$count участников';
  }

  @override
  String groupChallenges_endsIn(String time) {
    return 'Заканчивается через $time';
  }

  @override
  String get groupChallenges_weekly => 'Неделя';

  @override
  String get groupChallenges_monthly => 'Месяц';

  @override
  String get groupChallenges_allTime => 'Всё время';

  @override
  String get groupChallenges_noTeamsOnLeaderboard =>
      'Пока нет команд в рейтинге';

  @override
  String get groupChallenges_pts => 'очк.';

  @override
  String get groupChallenges_teamNotFound => 'Команда не найдена';

  @override
  String get groupChallenges_members => 'Участники';

  @override
  String get groupChallenges_totalPoints => 'Всего очков';

  @override
  String get groupChallenges_joined => 'Участвую';

  @override
  String get groupChallenges_join => 'Вступить';

  @override
  String get groupChallenges_status => 'Статус';

  @override
  String get groupChallenges_about => 'О команде';

  @override
  String get groupChallenges_noMembers => 'Пока нет участников';

  @override
  String get groupChallenges_admin => 'Админ';

  @override
  String groupChallenges_contributed(int points) {
    return '$points очк. внесено';
  }

  @override
  String get groupChallenges_joinedTeam => 'Вы вступили в команду!';

  @override
  String get groupChallenges_leaveTeam => 'Покинуть команду';

  @override
  String get groupChallenges_leaveConfirmation =>
      'Вы уверены, что хотите покинуть команду? Ваши очки останутся с командой.';

  @override
  String get groupChallenges_leave => 'Покинуть';

  @override
  String get groupChallenges_leftTeam => 'Вы покинули команду';

  @override
  String get groupChallenges_challengeDetails => 'Детали челленджа';

  @override
  String get groupChallenges_challengeNotFound => 'Челлендж не найден';

  @override
  String get groupChallenges_target => 'Цель';

  @override
  String get groupChallenges_starts => 'Начало';

  @override
  String get groupChallenges_ends => 'Конец';

  @override
  String get groupChallenges_hdTypes => 'Типы HD';

  @override
  String get groupChallenges_noTeamsToEnroll => 'Нет команд для записи';

  @override
  String get groupChallenges_createTeamToJoin =>
      'Сначала создайте команду для участия в челленджах';

  @override
  String get groupChallenges_enrollTeam => 'Записать команду';

  @override
  String get groupChallenges_enrolled => 'Записаны';

  @override
  String get groupChallenges_enroll => 'Записать';

  @override
  String get groupChallenges_teamEnrolled => 'Команда успешно записана!';

  @override
  String get groupChallenges_noTeamsEnrolled => 'Пока нет записанных команд';

  @override
  String get circles_title => 'Круги совместимости';

  @override
  String get circles_myCircles => 'Мои круги';

  @override
  String get circles_invitations => 'Приглашения';

  @override
  String get circles_create => 'Создать круг';

  @override
  String get circles_selectIcon => 'Выберите иконку';

  @override
  String get circles_name => 'Название круга';

  @override
  String get circles_nameHint => 'Семья, Команда, Друзья...';

  @override
  String get circles_description => 'Описание';

  @override
  String get circles_descriptionHint => 'Для чего этот круг?';

  @override
  String get circles_created => 'Круг успешно создан!';

  @override
  String get circles_noCircles => 'Пока нет кругов';

  @override
  String get circles_noCirclesDescription =>
      'Создайте круг для анализа совместимости с друзьями, семьёй или коллегами.';

  @override
  String get circles_suggestions => 'Быстрый старт';

  @override
  String circles_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников',
      few: '$count участника',
      one: '1 участник',
    );
    return '$_temp0';
  }

  @override
  String get circles_private => 'Приватный';

  @override
  String get circles_noInvitations => 'Нет приглашений';

  @override
  String get circles_noInvitationsDescription =>
      'Здесь появятся приглашения в круги.';

  @override
  String circles_invitedBy(String name) {
    return 'Пригласил $name';
  }

  @override
  String get circles_decline => 'Отклонить';

  @override
  String get circles_accept => 'Принять';

  @override
  String get circles_invitationDeclined => 'Приглашение отклонено';

  @override
  String get circles_invitationAccepted => 'Вы присоединились к кругу!';

  @override
  String get circles_notFound => 'Круг не найден';

  @override
  String get circles_invite => 'Пригласить';

  @override
  String get circles_members => 'Участники';

  @override
  String get circles_analysis => 'Анализ';

  @override
  String get circles_feed => 'Лента';

  @override
  String get circles_inviteMember => 'Пригласить участника';

  @override
  String get circles_sendInvite => 'Отправить приглашение';

  @override
  String get circles_invitationSent => 'Приглашение отправлено!';

  @override
  String get circles_invitationFailed => 'Не удалось отправить приглашение';

  @override
  String get circles_deleteTitle => 'Удалить круг';

  @override
  String circles_deleteConfirmation(String name) {
    return 'Вы уверены, что хотите удалить \"$name\"? Это действие нельзя отменить.';
  }

  @override
  String get circles_deleted => 'Круг удалён';

  @override
  String get circles_noMembers => 'Пока нет участников';

  @override
  String get circles_noAnalysis => 'Пока нет анализа';

  @override
  String get circles_runAnalysis =>
      'Запустите анализ совместимости, чтобы увидеть, как взаимодействуют участники круга.';

  @override
  String get circles_needMoreMembers =>
      'Добавьте минимум 2 участников для анализа.';

  @override
  String get circles_analyzeCompatibility => 'Анализировать совместимость';

  @override
  String get circles_harmonyScore => 'Оценка гармонии';

  @override
  String get circles_typeDistribution => 'Распределение типов';

  @override
  String get circles_electromagneticConnections => 'Электромагнитные связи';

  @override
  String get circles_electromagneticDesc =>
      'Интенсивное притяжение - вы дополняете друг друга';

  @override
  String get circles_companionshipConnections => 'Связи товарищества';

  @override
  String get circles_companionshipDesc =>
      'Комфорт и стабильность - общее понимание';

  @override
  String get circles_groupStrengths => 'Сильные стороны группы';

  @override
  String get circles_areasForGrowth => 'Области для роста';

  @override
  String get circles_writePost => 'Поделитесь чем-то с вашим кругом...';

  @override
  String get circles_noPosts => 'Пока нет постов';

  @override
  String get circles_beFirstToPost =>
      'Будьте первым, кто поделится чем-то с вашим кругом!';

  @override
  String get experts_title => 'Эксперты HD';

  @override
  String get experts_becomeExpert => 'Стать экспертом';

  @override
  String get experts_filterBySpecialization => 'Фильтр по специализации';

  @override
  String get experts_allExperts => 'Все эксперты';

  @override
  String get experts_experts => 'Эксперты';

  @override
  String get experts_noExperts => 'Эксперты не найдены';

  @override
  String get experts_featured => 'Рекомендуемые эксперты';

  @override
  String experts_followers(int count) {
    return '$count подписчиков';
  }

  @override
  String get experts_notFound => 'Эксперт не найден';

  @override
  String get experts_following => 'Подписан';

  @override
  String get experts_follow => 'Подписаться';

  @override
  String get experts_about => 'О себе';

  @override
  String get experts_specializations => 'Специализации';

  @override
  String get experts_credentials => 'Квалификации';

  @override
  String get experts_reviews => 'Отзывы';

  @override
  String get experts_writeReview => 'Написать отзыв';

  @override
  String get experts_reviewContent => 'Ваш отзыв';

  @override
  String get experts_reviewHint =>
      'Поделитесь опытом работы с этим экспертом...';

  @override
  String get experts_submitReview => 'Отправить отзыв';

  @override
  String get experts_reviewSubmitted => 'Отзыв успешно отправлен!';

  @override
  String get experts_noReviews => 'Пока нет отзывов';

  @override
  String get experts_followersLabel => 'Подписчики';

  @override
  String get experts_rating => 'Рейтинг';

  @override
  String get experts_years => 'Лет';

  @override
  String get learningPaths_title => 'Учебные пути';

  @override
  String get learningPaths_explore => 'Обзор';

  @override
  String get learningPaths_inProgress => 'В процессе';

  @override
  String get learningPaths_completed => 'Завершённые';

  @override
  String get learningPaths_featured => 'Рекомендуемые пути';

  @override
  String get learningPaths_allPaths => 'Все пути';

  @override
  String get learningPaths_noPathsExplore => 'Нет доступных учебных путей';

  @override
  String get learningPaths_noPathsInProgress => 'Нет путей в процессе';

  @override
  String get learningPaths_noPathsInProgressDescription =>
      'Запишитесь на учебный путь, чтобы начать!';

  @override
  String get learningPaths_browsePaths => 'Обзор путей';

  @override
  String get learningPaths_noPathsCompleted => 'Нет завершённых путей';

  @override
  String get learningPaths_noPathsCompletedDescription =>
      'Завершённые учебные пути появятся здесь!';

  @override
  String learningPaths_enrolled(int count) {
    return '$count записано';
  }

  @override
  String learningPaths_stepsCount(int count) {
    return '$count шагов';
  }

  @override
  String learningPaths_progress(int completed, int total) {
    return '$completed из $total шагов';
  }

  @override
  String get learningPaths_resume => 'Продолжить';

  @override
  String learningPaths_completedOn(String date) {
    return 'Завершён $date';
  }

  @override
  String get learningPathNotFound => 'Учебный путь не найден';

  @override
  String learningPathMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String learningPathSteps(int count) {
    return '$count шагов';
  }

  @override
  String learningPathBy(String author) {
    return 'От $author';
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
  String get learningPathEnroll => 'Начать обучение';

  @override
  String get learningPathYourProgress => 'Ваш прогресс';

  @override
  String get learningPathCompletedBadge => 'Завершён';

  @override
  String learningPathProgressText(int completed, int total) {
    return '$completed из $total шагов завершено';
  }

  @override
  String get learningPathStepsTitle => 'Шаги обучения';

  @override
  String get learningPathEnrollTitle => 'Начать этот путь?';

  @override
  String learningPathEnrollMessage(String title) {
    return 'Вы будете записаны на \"$title\" и сможете отслеживать прогресс.';
  }

  @override
  String get learningPathViewContent => 'Просмотреть контент';

  @override
  String get learningPathMarkComplete => 'Отметить как завершённое';

  @override
  String get learningPathStepCompleted => 'Шаг завершён!';

  @override
  String get thought_title => 'Мысли';

  @override
  String get thought_feedTitle => 'Мысли';

  @override
  String get thought_createNew => 'Поделиться мыслью';

  @override
  String get thought_emptyFeed => 'Лента мыслей пуста';

  @override
  String get thought_emptyFeedMessage =>
      'Подпишитесь на людей или поделитесь мыслью';

  @override
  String get thought_regenerate => 'Репост';

  @override
  String thought_regeneratedFrom(String username) {
    return 'Репост от @$username';
  }

  @override
  String get thought_regenerateSuccess => 'Мысль добавлена на вашу стену!';

  @override
  String get thought_regenerateConfirm => 'Сделать репост?';

  @override
  String get thought_regenerateDescription =>
      'Мысль появится на вашей стене со ссылкой на автора.';

  @override
  String get thought_addComment => 'Добавить комментарий (необязательно)';

  @override
  String thought_regenerateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count репостов',
      few: '$count репоста',
      one: '1 репост',
    );
    return '$_temp0';
  }

  @override
  String get thought_cannotRegenerateOwn => 'Нельзя сделать репост своей мысли';

  @override
  String get thought_alreadyRegenerated => 'Вы уже сделали репост этой мысли';

  @override
  String get thought_postDetail => 'Мысль';

  @override
  String get thought_noComments => 'Комментариев пока нет. Будьте первым!';

  @override
  String thought_replyingTo(String username) {
    return 'Ответ для $username';
  }

  @override
  String get thought_writeReply => 'Напишите ответ...';

  @override
  String get thought_commentPlaceholder => 'Добавить комментарий...';

  @override
  String get messages_title => 'Сообщения';

  @override
  String get messages_conversation => 'Беседа';

  @override
  String get messages_loading => 'Загрузка...';

  @override
  String get messages_muteNotifications => 'Отключить уведомления';

  @override
  String get messages_notificationsMuted => 'Уведомления отключены';

  @override
  String get messages_blockUser => 'Заблокировать';

  @override
  String get messages_blockUserConfirm =>
      'Вы уверены, что хотите заблокировать этого пользователя? Вы больше не будете получать от него сообщения.';

  @override
  String get messages_userBlocked => 'Пользователь заблокирован';

  @override
  String get messages_block => 'Заблокировать';

  @override
  String get messages_deleteConversation => 'Удалить беседу';

  @override
  String get messages_deleteConversationConfirm =>
      'Вы уверены, что хотите удалить эту беседу? Это действие нельзя отменить.';

  @override
  String get messages_conversationDeleted => 'Беседа удалена';

  @override
  String get messages_startConversation => 'Начните беседу!';

  @override
  String get profile_takePhoto => 'Сделать фото';

  @override
  String get profile_chooseFromGallery => 'Выбрать из галереи';

  @override
  String get profile_avatarUpdated => 'Аватар успешно обновлён';

  @override
  String get profile_profileUpdated => 'Профиль успешно обновлён';

  @override
  String get profile_noProfileFound => 'Профиль не найден';

  @override
  String get discovery_title => 'Поиск';

  @override
  String get discovery_searchUsers => 'Поиск пользователей...';

  @override
  String get discovery_discoverTab => 'Поиск';

  @override
  String get discovery_followingTab => 'Подписки';

  @override
  String get discovery_followersTab => 'Подписчики';

  @override
  String get discovery_noUsersFound => 'Пользователи не найдены';

  @override
  String get discovery_tryAdjustingFilters => 'Попробуйте изменить фильтры';

  @override
  String get discovery_notFollowingAnyone => 'Не подписан ни на кого';

  @override
  String get discovery_discoverPeople => 'Найдите людей для подписки';

  @override
  String get discovery_noFollowersYet => 'Пока нет подписчиков';

  @override
  String get discovery_shareInsights =>
      'Делитесь инсайтами, чтобы получить подписчиков';

  @override
  String get discovery_clearAll => 'Очистить всё';

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
  String get chart_keynote => 'Ключевая нота';

  @override
  String get chart_element => 'Элемент';

  @override
  String get chart_location => 'Расположение';

  @override
  String get chart_hdCenters => 'Центры HD';

  @override
  String get reaction_comment => 'Комментарий';

  @override
  String get reaction_react => 'Реакция';

  @override
  String get reaction_standard => 'Стандартные';

  @override
  String get reaction_humanDesign => 'Human Design';

  @override
  String get share_shareChart => 'Поделиться картой';

  @override
  String get share_createShareLink => 'Создать ссылку';

  @override
  String get share_shareViaUrl => 'Поделиться ссылкой';

  @override
  String get share_exportAsPng => 'Экспорт в PNG';

  @override
  String get share_fullReport => 'Полный отчёт';

  @override
  String get share_linkExpiration => 'Срок действия ссылки';

  @override
  String get share_neverExpires => 'Бессрочно';

  @override
  String get share_oneHour => '1 час';

  @override
  String get share_twentyFourHours => '24 часа';

  @override
  String get share_sevenDays => '7 дней';

  @override
  String get share_thirtyDays => '30 дней';

  @override
  String get share_creating => 'Создаём...';

  @override
  String get share_signInToShare => 'Войдите, чтобы поделиться картой';

  @override
  String get share_createShareableLinks =>
      'Создавайте ссылки на вашу карту Дизайна Человека';

  @override
  String get share_linkImage => 'Изображение';

  @override
  String get share_pdf => 'PDF';

  @override
  String get post_share => 'Поделиться';

  @override
  String get post_edit => 'Редактировать';

  @override
  String get post_report => 'Пожаловаться';

  @override
  String get mentorship_title => 'Наставничество';

  @override
  String get mentorship_pendingRequests => 'Ожидающие запросы';

  @override
  String get mentorship_availableMentors => 'Доступные наставники';

  @override
  String get mentorship_noMentorsAvailable => 'Нет доступных наставников';

  @override
  String mentorship_requestMentorship(String name) {
    return 'Запросить наставничество у $name';
  }

  @override
  String get mentorship_sendMessage => 'Напишите, чему хотите научиться:';

  @override
  String get mentorship_learnPrompt => 'Я хотел бы узнать больше о...';

  @override
  String get mentorship_requestSent => 'Запрос отправлен!';

  @override
  String get mentorship_sendRequest => 'Отправить запрос';

  @override
  String get mentorship_becomeAMentor => 'Стать наставником';

  @override
  String get mentorship_shareKnowledge =>
      'Делитесь знаниями о Дизайне Человека';

  @override
  String get story_cancel => 'Отмена';

  @override
  String get story_createStory => 'Создать историю';

  @override
  String get story_share => 'Поделиться';

  @override
  String get story_typeYourStory => 'Введите вашу историю...';

  @override
  String get story_background => 'Фон';

  @override
  String get story_attachTransitGate =>
      'Прикрепить транзитные ворота (необязательно)';

  @override
  String get story_none => 'Нет';

  @override
  String story_gateNumber(int number) {
    return 'Ворота $number';
  }

  @override
  String get story_whoCanSee => 'Кто может видеть?';

  @override
  String get story_followers => 'Подписчики';

  @override
  String get story_everyone => 'Все';

  @override
  String get challenges_title => 'Задания';

  @override
  String get challenges_daily => 'Дневные';

  @override
  String get challenges_weekly => 'Недельные';

  @override
  String get challenges_monthly => 'Месячные';

  @override
  String get challenges_noDailyChallenges => 'Нет дневных заданий';

  @override
  String get challenges_noWeeklyChallenges => 'Нет недельных заданий';

  @override
  String get challenges_noMonthlyChallenges => 'Нет месячных заданий';

  @override
  String get challenges_errorLoading => 'Ошибка загрузки заданий';

  @override
  String challenges_claimedPoints(int points) {
    return 'Получено $points очков!';
  }

  @override
  String get challenges_totalPoints => 'Всего очков';

  @override
  String get challenges_level => 'Уровень';

  @override
  String get learning_all => 'Все';

  @override
  String get learning_types => 'Типы';

  @override
  String get learning_gates => 'Ворота';

  @override
  String get learning_centers => 'Центры';

  @override
  String get learning_liveSessions => 'Прямые эфиры';

  @override
  String get quiz_noActiveSession => 'Нет активной сессии теста';

  @override
  String get quiz_noQuestionsAvailable => 'Нет доступных вопросов';

  @override
  String get quiz_ok => 'ОК';

  @override
  String get liveSessions_title => 'Прямые эфиры';

  @override
  String get liveSessions_upcoming => 'Предстоящие';

  @override
  String get liveSessions_mySessions => 'Мои сессии';

  @override
  String get liveSessions_errorLoading => 'Ошибка загрузки сессий';

  @override
  String get liveSessions_registeredSuccessfully => 'Регистрация успешна!';

  @override
  String get liveSessions_cancelRegistration => 'Отменить регистрацию';

  @override
  String get liveSessions_cancelRegistrationConfirm =>
      'Вы уверены, что хотите отменить регистрацию?';

  @override
  String get liveSessions_no => 'Нет';

  @override
  String get liveSessions_yesCancel => 'Да, отменить';

  @override
  String get liveSessions_registrationCancelled => 'Регистрация отменена';

  @override
  String get gateChannelPicker_gates => 'Ворота (64)';

  @override
  String get gateChannelPicker_channels => 'Каналы (36)';

  @override
  String get gateChannelPicker_search => 'Поиск ворот или каналов...';

  @override
  String get leaderboard_weekly => 'Неделя';

  @override
  String get leaderboard_monthly => 'Месяц';

  @override
  String get leaderboard_allTime => 'Всё время';

  @override
  String get ai_chatTitle => 'AI Ассистент';

  @override
  String get ai_askAi => 'Спросить AI';

  @override
  String get ai_askAboutChart => 'Спросить AI о вашей карте';

  @override
  String get ai_miniDescription =>
      'Получите персональные инсайты о вашем Дизайне Человека';

  @override
  String get ai_startChatting => 'Начать чат';

  @override
  String get ai_welcomeTitle => 'Ваш HD Ассистент';

  @override
  String get ai_welcomeSubtitle =>
      'Задайте мне любой вопрос о вашей карте Дизайна Человека. Я могу объяснить ваш тип, стратегию, авторитет, ворота, каналы и многое другое.';

  @override
  String get ai_inputPlaceholder => 'Спросите о вашей карте...';

  @override
  String get ai_newConversation => 'Новый разговор';

  @override
  String get ai_conversations => 'Разговоры';

  @override
  String get ai_noConversations => 'Разговоров пока нет';

  @override
  String get ai_noConversationsMessage =>
      'Начните разговор с AI, чтобы получить персональные инсайты по карте.';

  @override
  String get ai_deleteConversation => 'Удалить разговор';

  @override
  String get ai_deleteConversationConfirm =>
      'Вы уверены, что хотите удалить этот разговор?';

  @override
  String get ai_messagesExhausted => 'Бесплатные сообщения израсходованы';

  @override
  String get ai_upgradeForUnlimited =>
      'Обновитесь до Премиум для безлимитных AI разговоров о вашей карте Дизайна Человека.';

  @override
  String ai_usageCount(int used, int limit) {
    return '$used из $limit бесплатных сообщений использовано';
  }

  @override
  String get ai_errorGeneric => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get ai_errorNetwork =>
      'Не удалось подключиться к AI сервису. Проверьте соединение.';

  @override
  String get events_title => 'Мероприятия сообщества';

  @override
  String get events_upcoming => 'Предстоящие';

  @override
  String get events_past => 'Прошедшие';

  @override
  String get events_create => 'Создать мероприятие';

  @override
  String get events_noUpcoming => 'Предстоящих мероприятий нет';

  @override
  String get events_noUpcomingMessage =>
      'Создайте мероприятие, чтобы объединить HD сообщество!';

  @override
  String get events_online => 'Онлайн';

  @override
  String get events_inPerson => 'Очно';

  @override
  String get events_hybrid => 'Гибрид';

  @override
  String events_participants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников',
      many: '$count участников',
      few: '$count участника',
      one: '1 участник',
    );
    return '$_temp0';
  }

  @override
  String get events_register => 'Зарегистрироваться';

  @override
  String get events_registered => 'Зарегистрирован';

  @override
  String get events_cancelRegistration => 'Отменить регистрацию';

  @override
  String get events_registrationFull => 'Мероприятие заполнено';

  @override
  String get events_eventTitle => 'Название мероприятия';

  @override
  String get events_eventDescription => 'Описание';

  @override
  String get events_eventType => 'Тип мероприятия';

  @override
  String get events_startDate => 'Дата и время начала';

  @override
  String get events_endDate => 'Дата и время окончания';

  @override
  String get events_location => 'Место проведения';

  @override
  String get events_virtualLink => 'Ссылка на онлайн-встречу';

  @override
  String get events_maxParticipants => 'Максимум участников';

  @override
  String get events_hdTypeFilter => 'Фильтр по типу HD';

  @override
  String get events_allTypes => 'Для всех типов';

  @override
  String get events_created => 'Мероприятие создано!';

  @override
  String get events_deleted => 'Мероприятие удалено';

  @override
  String get events_notFound => 'Мероприятие не найдено';

  @override
  String get chartOfDay_title => 'Карта дня';

  @override
  String get chartOfDay_featured => 'Рекомендованная карта';

  @override
  String get chartOfDay_viewChart => 'Посмотреть карту';

  @override
  String get discussion_typeDiscussion => 'Обсуждение типов';

  @override
  String get discussion_channelDiscussion => 'Обсуждение каналов';

  @override
  String get ai_wantMoreInsights => 'Хотите больше AI-инсайтов?';

  @override
  String ai_messagesPackTitle(int count) {
    return '$count сообщений';
  }

  @override
  String get ai_orSubscribe => 'или подпишитесь на безлимит';

  @override
  String get ai_bestValue => 'Лучшая цена';

  @override
  String get ai_getMoreMessages => 'Получить ещё сообщения';

  @override
  String ai_fromPrice(String price) {
    return 'От $price';
  }

  @override
  String ai_perMessage(String price) {
    return '$price/сообщение';
  }

  @override
  String get ai_transitInsightTitle => 'Транзитный инсайт дня';

  @override
  String get ai_transitInsightDesc =>
      'Получите персональную AI-интерпретацию влияния сегодняшних транзитов на вашу карту.';

  @override
  String get ai_chartReadingTitle => 'AI Чтение карты';

  @override
  String get ai_chartReadingDesc =>
      'Создайте подробное AI-чтение вашей карты Дизайна Человека.';

  @override
  String get ai_chartReadingCost =>
      'Это чтение использует 3 AI сообщения из вашей квоты.';

  @override
  String get ai_compatibilityTitle => 'AI Чтение совместимости';

  @override
  String get ai_compatibilityReading => 'AI Анализ совместимости';

  @override
  String get ai_dreamJournalTitle => 'Дневник снов';

  @override
  String get ai_dreamEntryHint =>
      'Записывайте сны, чтобы раскрыть скрытые инсайты вашего дизайна...';

  @override
  String get ai_interpretDream => 'Интерпретировать сон';

  @override
  String get ai_journalPromptsTitle => 'Темы для дневника';

  @override
  String get ai_journalPromptsDesc =>
      'Получите персональные темы для дневника на основе вашей карты и сегодняшних транзитов.';

  @override
  String get ai_generating => 'Генерация...';

  @override
  String get ai_askFollowUp => 'Задать уточняющий вопрос';

  @override
  String get ai_regenerate => 'Сгенерировать заново';

  @override
  String get ai_exportPdf => 'Экспорт в PDF';

  @override
  String get ai_shareReading => 'Поделиться чтением';

  @override
  String get group_notFound => 'Группа не найдена';

  @override
  String get group_members => 'Участники';

  @override
  String get group_sharedCharts => 'Общие карты';

  @override
  String get group_feed => 'Лента';

  @override
  String get group_invite => 'Пригласить';

  @override
  String get group_inviteMembers => 'Пригласить участников';

  @override
  String get group_searchUsers => 'Поиск по имени...';

  @override
  String get group_searchHint => 'Введите не менее 2 символов для поиска';

  @override
  String get group_noUsersFound => 'Пользователи не найдены';

  @override
  String group_memberAdded(String name) {
    return '$name добавлен в группу';
  }

  @override
  String get group_addMemberFailed => 'Не удалось добавить участника';

  @override
  String get group_noMembers => 'Участников пока нет';

  @override
  String get group_promote => 'Назначить администратором';

  @override
  String get group_demote => 'Снять права администратора';

  @override
  String get group_removeMember => 'Удалить';

  @override
  String get group_promoteTitle => 'Назначить администратора';

  @override
  String group_promoteConfirmation(String name) {
    return 'Сделать $name администратором этой группы?';
  }

  @override
  String get group_demoteTitle => 'Снять права администратора';

  @override
  String group_demoteConfirmation(String name) {
    return 'Снять роль администратора с $name?';
  }

  @override
  String get group_removeMemberTitle => 'Удалить участника';

  @override
  String group_removeMemberConfirmation(String name) {
    return 'Удалить $name из этой группы?';
  }

  @override
  String get group_editName => 'Изменить название';

  @override
  String get group_editDescription => 'Изменить описание';

  @override
  String get group_delete => 'Удалить группу';

  @override
  String get group_deleteTitle => 'Удалить группу';

  @override
  String group_deleteConfirmation(String name) {
    return 'Вы уверены, что хотите удалить \"$name\"? Это действие нельзя отменить.';
  }

  @override
  String get group_deleted => 'Группа удалена';

  @override
  String get group_leave => 'Покинуть группу';

  @override
  String get group_leaveTitle => 'Покинуть группу';

  @override
  String group_leaveConfirmation(String name) {
    return 'Вы уверены, что хотите покинуть \"$name\"?';
  }

  @override
  String get group_left => 'Вы покинули группу';

  @override
  String get group_updated => 'Группа обновлена';

  @override
  String get group_noSharedCharts => 'Нет общих карт';

  @override
  String get group_noSharedChartsMessage =>
      'Поделитесь своей картой с группой через экран карты.';

  @override
  String get group_writePost => 'Напишите что-нибудь...';

  @override
  String get group_noPosts => 'Публикаций пока нет';

  @override
  String get group_beFirstToPost => 'Начните разговор!';

  @override
  String get group_deletePostConfirmation => 'Удалить эту публикацию?';

  @override
  String get group_shareChart => 'Поделиться чартом';

  @override
  String get group_share => 'Поделиться';

  @override
  String get group_chartShared => 'Чарт поделён с группой';

  @override
  String get group_noChartsToShare =>
      'Нет сохранённых чартов для публикации. Сначала создайте чарт.';
}
