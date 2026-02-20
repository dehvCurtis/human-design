// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Belarusian (`be`).
class AppLocalizationsBe extends AppLocalizations {
  AppLocalizationsBe([String locale = 'be']) : super(locale);

  @override
  String get appName => 'Inside Me';

  @override
  String get common_save => 'Захаваць';

  @override
  String get common_cancel => 'Адмяніць';

  @override
  String get common_delete => 'Выдаліць';

  @override
  String get common_edit => 'Рэдагаваць';

  @override
  String get common_done => 'Гатова';

  @override
  String get common_next => 'Далей';

  @override
  String get common_back => 'Назад';

  @override
  String get common_skip => 'Прапусціць';

  @override
  String get common_continue => 'Працягнуць';

  @override
  String get common_loading => 'Загрузка...';

  @override
  String get common_error => 'Памылка';

  @override
  String get common_retry => 'Паўтарыць';

  @override
  String get common_close => 'Зачыніць';

  @override
  String get common_search => 'Пошук';

  @override
  String get common_share => 'Падзяліцца';

  @override
  String get common_settings => 'Налады';

  @override
  String get common_logout => 'Выйсці';

  @override
  String get common_profile => 'Профіль';

  @override
  String get common_type => 'Тып';

  @override
  String get common_strategy => 'Стратэгія';

  @override
  String get common_authority => 'Аўтарытэт';

  @override
  String get common_definition => 'Азначанасць';

  @override
  String get common_create => 'Стварыць';

  @override
  String get common_viewFull => 'Падрабязней';

  @override
  String get common_send => 'Адправіць';

  @override
  String get common_like => 'Падабаецца';

  @override
  String get common_reply => 'Адказаць';

  @override
  String get common_deleteConfirmation =>
      'Вы ўпэўнены, що хочаце выдаліць? Гэтае дзеянне нельга адмяніць.';

  @override
  String get common_comingSoon => 'Хутка!';

  @override
  String get nav_home => 'Галоўная';

  @override
  String get nav_chart => 'Карта';

  @override
  String get nav_today => 'Дзень';

  @override
  String get nav_social => 'Сацыяльнае';

  @override
  String get nav_profile => 'Профіль';

  @override
  String get nav_ai => 'ШІ';

  @override
  String get nav_more => 'Яшчэ';

  @override
  String get nav_learn => 'Навучанне';

  @override
  String get affirmation_savedSuccess => 'Афірмацыя захавана!';

  @override
  String get affirmation_alreadySaved => 'Афірмацыя ўжо захавана';

  @override
  String get home_goodMorning => 'Добрай раніцы';

  @override
  String get home_goodAfternoon => 'Добры дзень';

  @override
  String get home_goodEvening => 'Добры вечар';

  @override
  String get home_yourDesign => 'Ваш дызайн';

  @override
  String get home_completeProfile => 'Запоўніце профіль';

  @override
  String get home_enterBirthData => 'Увядзіце дадзеныя нараджэння';

  @override
  String get home_myChart => 'Мая карта';

  @override
  String get home_savedCharts => 'Захаваныя';

  @override
  String get home_composite => 'Кампазіт';

  @override
  String get home_penta => 'Пента';

  @override
  String get home_friends => 'Сябры';

  @override
  String get home_myBodygraph => 'Мой бодыграф';

  @override
  String get home_definedCenters => 'Азначаныя цэнтры';

  @override
  String get home_activeChannels => 'Актыўныя каналы';

  @override
  String get home_activeGates => 'Актыўныя вароты';

  @override
  String get transit_today => 'Транзіты сёння';

  @override
  String get transit_sun => 'Сонца';

  @override
  String get transit_earth => 'Зямля';

  @override
  String get transit_moon => 'Месяц';

  @override
  String transit_gate(int number) {
    return 'Вароты $number';
  }

  @override
  String transit_newChannelsActivated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count новых каналаў актывавана',
      few: '$count новыя каналы актываваны',
      one: '1 новы канал актываваны',
    );
    return '$_temp0';
  }

  @override
  String transit_gatesHighlighted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count варот вылучана',
      few: '$count вароты вылучаны',
      one: '1 вароты вылучаны',
    );
    return '$_temp0';
  }

  @override
  String get transit_noConnections => 'Няма прамых транзітных сувязяў сёння';

  @override
  String get auth_signIn => 'Увайсці';

  @override
  String get auth_signUp => 'Рэгістрацыя';

  @override
  String get auth_signInWithApple => 'Увайсці праз Apple';

  @override
  String get auth_signInWithGoogle => 'Увайсці праз Google';

  @override
  String get auth_signInWithEmail => 'Увайсці па Email';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Пароль';

  @override
  String get auth_confirmPassword => 'Пацвердзіце пароль';

  @override
  String get auth_forgotPassword => 'Забылі пароль?';

  @override
  String get auth_noAccount => 'Няма акаўнта?';

  @override
  String get auth_hasAccount => 'Ужо ёсць акаўнт?';

  @override
  String get auth_termsAgree =>
      'Рэгіструючыся, вы згаджаецеся з Умовамі выкарыстання і Палітыкай канфідэнцыяльнасці';

  @override
  String get auth_welcomeBack => 'З вяртаннем';

  @override
  String get auth_signInSubtitle =>
      'Увайдзіце, каб працягнуць падарожжа па Дызайну Чалавека';

  @override
  String get auth_signInRequired => 'Патрабуецца аўтарызацыя';

  @override
  String get auth_signInToCalculateChart =>
      'Увайдзіце, каб разлічыць і захаваць вашу карту Дызайну Чалавека.';

  @override
  String get auth_signInToCreateStory =>
      'Увайдзіце, каб дзяліцца гісторыямі са супольнасцю.';

  @override
  String get auth_signUpSubtitle =>
      'Пачніце сваё падарожжа па Дызайну Чалавека сёння';

  @override
  String get auth_signUpWithApple => 'Рэгістрацыя праз Apple';

  @override
  String get auth_signUpWithGoogle => 'Рэгістрацыя праз Google';

  @override
  String get auth_enterName => 'Увядзіце ваша імя';

  @override
  String get auth_nameRequired => 'Імя абавязковае';

  @override
  String get auth_termsOfService => 'Умовы выкарыстання';

  @override
  String get auth_privacyPolicy => 'Палітыка канфідэнцыяльнасці';

  @override
  String get auth_acceptTerms =>
      'Калі ласка, прыміце Умовы выкарыстання для працягу';

  @override
  String get auth_resetPasswordTitle => 'Скід пароля';

  @override
  String get auth_resetPasswordPrompt =>
      'Увядзіце email і мы адправім вам спасылку для скіду пароля.';

  @override
  String get auth_enterEmail => 'Увядзіце email';

  @override
  String get auth_resetEmailSent => 'Ліст для скіду пароля адпраўлены!';

  @override
  String get auth_name => 'Імя';

  @override
  String get auth_createAccount => 'Стварыць акаўнт';

  @override
  String get auth_iAgreeTo => 'Я прымаю ';

  @override
  String get auth_and => ' і ';

  @override
  String get auth_birthInformation => 'Дадзеныя нараджэння';

  @override
  String get auth_calculateMyChart => 'Разлічыць маю карту';

  @override
  String get onboarding_welcome => 'Вітаем у Дызайне Чалавека';

  @override
  String get onboarding_welcomeSubtitle =>
      'Адкрыйце свой унікальны энергетычны чарцёж';

  @override
  String get onboarding_birthData => 'Увядзіце дадзеныя нараджэння';

  @override
  String get onboarding_birthDataSubtitle =>
      'Гэта неабходна для разліку вашай карты';

  @override
  String get onboarding_birthDate => 'Дата нараджэння';

  @override
  String get onboarding_birthTime => 'Час нараджэння';

  @override
  String get onboarding_birthLocation => 'Месца нараджэння';

  @override
  String get onboarding_searchLocation => 'Увядзіце назву горада...';

  @override
  String get onboarding_unknownTime => 'Я не ведаю часу нараджэння';

  @override
  String get onboarding_timeImportance =>
      'Дакладны час нараджэння важны для дакладнай карты';

  @override
  String get onboarding_birthDataExplanation =>
      'Вашы дадзеныя нараджэння выкарыстоўваюцца для разліку унікальнай карты Дызайну Чалавека. Чым дакладней інфармацыя, тым дакладней будзе карта.';

  @override
  String get onboarding_noTimeWarning =>
      'Без дакладнага часу нараджэння некаторыя дэталі карты (узыходны знак і лініі варот) могуць быць недакладнымі. Па змаўчанні будзе выкарыстоўвацца поўдзень.';

  @override
  String get onboarding_enterBirthTimeInstead => 'Увесці час нараджэння';

  @override
  String get onboarding_birthDataPrivacy =>
      'Вашы дадзеныя нараджэння зашыфраваны і захоўваюцца бяспечна. Вы можаце абнавіць або выдаліць іх у любы час у наладах профілю.';

  @override
  String get onboarding_saveFailed => 'Не ўдалося захаваць дадзеныя нараджэння';

  @override
  String get onboarding_fillAllFields =>
      'Калі ласка, запоўніце ўсе абавязковыя палі';

  @override
  String get onboarding_selectLanguage => 'Выберыце мову';

  @override
  String get onboarding_getStarted => 'Пачаць';

  @override
  String get onboarding_alreadyHaveAccount => 'У мяне ўжо ёсць акаўнт';

  @override
  String get onboarding_liveInAlignment =>
      'Адкрыйце свой унікальны энергетычны адбітак і жывіце ў гармоніі са сваёй сапраўднай прыродай.';

  @override
  String get chart_myChart => 'Мая карта';

  @override
  String get chart_viewChart => 'Паказаць карту';

  @override
  String get chart_calculate => 'Разлічыць карту';

  @override
  String get chart_recalculate => 'Перазлічыць';

  @override
  String get chart_share => 'Падзяліцца картай';

  @override
  String get chart_createChart => 'Стварыць карту';

  @override
  String get chart_composite => 'Кампазітная карта';

  @override
  String get chart_transit => 'Транзіты сёння';

  @override
  String get chart_bodygraph => 'Бодыграф';

  @override
  String get chart_planets => 'Планеты';

  @override
  String get chart_details => 'Дэталі карты';

  @override
  String get chart_properties => 'Уласцівасці';

  @override
  String get chart_gates => 'Вароты';

  @override
  String get chart_channels => 'Каналы';

  @override
  String get chart_noChartYet => 'Пакуль няма карты';

  @override
  String get chart_addBirthDataPrompt =>
      'Дадайце дадзеныя нараджэння для стварэння вашай унікальнай карты Дызайну Чалавека.';

  @override
  String get chart_addBirthData => 'Дадаць дадзеныя нараджэння';

  @override
  String get chart_noActiveChannels => 'Няма актыўных каналаў';

  @override
  String get chart_channelsFormedBothGates =>
      'Каналы ўтвараюцца, калі азначаны абодва вароты.';

  @override
  String get chart_savedCharts => 'Захаваныя карты';

  @override
  String get chart_addChart => 'Дадаць карту';

  @override
  String get chart_noSavedCharts => 'Няма захаваных карт';

  @override
  String get chart_noSavedChartsMessage =>
      'Стварыце карты для сябе і іншых, каб захаваць іх тут.';

  @override
  String get chart_loadFailed => 'Не ўдалося загрузіць карты';

  @override
  String get chart_renameChart => 'Перайменаваць карту';

  @override
  String get chart_rename => 'Перайменаваць';

  @override
  String get chart_renameFailed => 'Не ўдалося перайменаваць карту';

  @override
  String get chart_deleteChart => 'Выдаліць карту';

  @override
  String chart_deleteConfirm(String name) {
    return 'Вы ўпэўнены, што хочаце выдаліць \"$name\"? Гэтае дзеянне нельга адмяніць.';
  }

  @override
  String get chart_deleteFailed => 'Не ўдалося выдаліць карту';

  @override
  String get chart_you => 'Вы';

  @override
  String get chart_personName => 'Імя';

  @override
  String get chart_enterPersonName => 'Увядзіце імя чалавека';

  @override
  String get chart_addChartDescription =>
      'Стварыце карту для іншага чалавека, увёўшы яго дадзеныя нараджэння.';

  @override
  String get chart_calculateAndSave => 'Разлічыць і захаваць карту';

  @override
  String get chart_saved => 'Карта паспяхова захавана';

  @override
  String get chart_consciousGates => 'Свядомыя вароты';

  @override
  String get chart_unconsciousGates => 'Несвядомыя вароты';

  @override
  String get chart_personalitySide => 'Бок асобы - тое, што вы ўсведамляеце';

  @override
  String get chart_designSide => 'Бок дызайну - тое, што бачаць у вас іншыя';

  @override
  String get type_manifestor => 'Маніфестар';

  @override
  String get type_generator => 'Генератар';

  @override
  String get type_manifestingGenerator => 'Маніфесціруючы Генератар';

  @override
  String get type_projector => 'Праектар';

  @override
  String get type_reflector => 'Рэфлектар';

  @override
  String get type_manifestor_strategy => 'Інфармаваць';

  @override
  String get type_generator_strategy => 'Адгукацца';

  @override
  String get type_manifestingGenerator_strategy => 'Адгукацца';

  @override
  String get type_projector_strategy => 'Чакаць запрашэння';

  @override
  String get type_reflector_strategy => 'Чакаць месячны цыкл';

  @override
  String get authority_emotional => 'Эмацыйны';

  @override
  String get authority_sacral => 'Сакральны';

  @override
  String get authority_splenic => 'Селязёначны';

  @override
  String get authority_ego => 'Эга/Сэрца';

  @override
  String get authority_self => 'Сама-праецыраваны';

  @override
  String get authority_environment => 'Ментальны/Асяроддзе';

  @override
  String get authority_lunar => 'Месячны';

  @override
  String get definition_none => 'Без азначанасці';

  @override
  String get definition_single => 'Адзінкавая азначанасць';

  @override
  String get definition_split => 'Расшчэпленая азначанасць';

  @override
  String get definition_tripleSplit => 'Тройнае расшчэпленне';

  @override
  String get definition_quadrupleSplit => 'Чацвярное расшчэпленне';

  @override
  String get profile_1_3 => '1/3 Даследчык/Мучанік';

  @override
  String get profile_1_4 => '1/4 Даследчык/Апартуніст';

  @override
  String get profile_2_4 => '2/4 Адшэльнік/Апартуніст';

  @override
  String get profile_2_5 => '2/5 Адшэльнік/Ерэтык';

  @override
  String get profile_3_5 => '3/5 Мучанік/Ерэтык';

  @override
  String get profile_3_6 => '3/6 Мучанік/Ролевая мадэль';

  @override
  String get profile_4_6 => '4/6 Апартуніст/Ролевая мадэль';

  @override
  String get profile_4_1 => '4/1 Апартуніст/Даследчык';

  @override
  String get profile_5_1 => '5/1 Ерэтык/Даследчык';

  @override
  String get profile_5_2 => '5/2 Ерэтык/Адшэльнік';

  @override
  String get profile_6_2 => '6/2 Ролевая мадэль/Адшэльнік';

  @override
  String get profile_6_3 => '6/3 Ролевая мадэль/Мучанік';

  @override
  String get center_head => 'Галаўны';

  @override
  String get center_ajna => 'Аджна';

  @override
  String get center_throat => 'Горлавы';

  @override
  String get center_g => 'G-цэнтр';

  @override
  String get center_heart => 'Сардэчны/Эга';

  @override
  String get center_sacral => 'Сакральны';

  @override
  String get center_solarPlexus => 'Сонечнае сплятэнне';

  @override
  String get center_spleen => 'Селязёначны';

  @override
  String get center_root => 'Каранёвы';

  @override
  String get center_defined => 'Азначаны';

  @override
  String get center_undefined => 'Неазначаны';

  @override
  String get section_type => 'Тып';

  @override
  String get section_strategy => 'Стратэгія';

  @override
  String get section_authority => 'Аўтарытэт';

  @override
  String get section_profile => 'Профіль';

  @override
  String get section_definition => 'Азначанасць';

  @override
  String get section_centers => 'Цэнтры';

  @override
  String get section_channels => 'Каналы';

  @override
  String get section_gates => 'Вароты';

  @override
  String get section_conscious => 'Свядомае (Асоба)';

  @override
  String get section_unconscious => 'Несвядомае (Дызайн)';

  @override
  String get social_title => 'Сацыяльнае';

  @override
  String get social_thoughts => 'Думкі';

  @override
  String get social_discover => 'Пошук';

  @override
  String get social_groups => 'Групы';

  @override
  String get social_invite => 'Запрасіць';

  @override
  String get social_createPost => 'Падзяліцеся думкай...';

  @override
  String get social_noThoughtsYet => 'Пакуль няма запісаў';

  @override
  String get social_noThoughtsMessage =>
      'Будзьце першым, хто падзеліцца сваімі адкрыццямі пра Дызайн Чалавека!';

  @override
  String get social_createGroup => 'Стварыць групу';

  @override
  String get social_members => 'Удзельнікі';

  @override
  String get social_comments => 'Каментарыі';

  @override
  String get social_addComment => 'Дадаць каментарый...';

  @override
  String get social_noComments => 'Пакуль няма каментарыяў';

  @override
  String social_shareLimit(int remaining) {
    return 'У вас засталося $remaining публікацый у гэтым месяцы';
  }

  @override
  String get social_visibility => 'Бачнасць';

  @override
  String get social_private => 'Прыватна';

  @override
  String get social_friendsOnly => 'Толькі сябры';

  @override
  String get social_public => 'Публічна';

  @override
  String get social_shared => 'Агульныя';

  @override
  String get social_noGroupsYet => 'Пакуль няма груп';

  @override
  String get social_noGroupsMessage =>
      'Стварыце групы для аналізу каманднай дынамікі з дапамогай Пента-аналізу.';

  @override
  String get social_noSharedCharts => 'Няма агульных карт';

  @override
  String get social_noSharedChartsMessage =>
      'Тут з\'явяцца карты, якімі з вамі падзяліліся.';

  @override
  String get social_createGroupPrompt =>
      'Стварыце групу для аналізу каманднай дынамікі.';

  @override
  String get social_groupName => 'Назва групы';

  @override
  String get social_groupNameHint => 'Сям\'я, Каманда і г.д.';

  @override
  String get social_groupDescription => 'Апісанне (неабавязкова)';

  @override
  String get social_groupDescriptionHint => 'Для чаго гэтая група?';

  @override
  String social_groupCreated(String name) {
    return 'Група \"$name\" створана!';
  }

  @override
  String get social_groupNameRequired => 'Калі ласка, увядзіце назву групы';

  @override
  String get social_createGroupFailed =>
      'Не ўдалося стварыць групу. Паспрабуйце зноў.';

  @override
  String get social_noDescription => 'Без апісання';

  @override
  String get social_admin => 'Адмін';

  @override
  String social_sharedBy(String name) {
    return 'Падзяліўся $name';
  }

  @override
  String get social_loadGroupsFailed => 'Не ўдалося загрузіць групы';

  @override
  String get social_loadSharedFailed => 'Не ўдалося загрузіць агульныя карты';

  @override
  String get social_userNotFound => 'Карыстальнік не знойдзены';

  @override
  String get discovery_userNotFound => 'Карыстальнік не знойдзены';

  @override
  String get discovery_following => 'Падпісаны';

  @override
  String get discovery_follow => 'Падпісацца';

  @override
  String get discovery_sendMessage => 'Напісаць';

  @override
  String get discovery_about => 'Пра сябе';

  @override
  String get discovery_humanDesign => 'Дызайн Чалавека';

  @override
  String get discovery_type => 'Тып';

  @override
  String get discovery_profile => 'Профіль';

  @override
  String get discovery_authority => 'Аўтарытэт';

  @override
  String get discovery_compatibility => 'Сумяшчальнасць';

  @override
  String get discovery_compatible => 'сумяшчальныя';

  @override
  String get discovery_followers => 'Падпісчыкі';

  @override
  String get discovery_followingLabel => 'Падпіскі';

  @override
  String get discovery_noResults => 'Карыстальнікі не знойдзены';

  @override
  String get discovery_noResultsMessage =>
      'Паспрабуйце змяніць фільтры або зайдзіце пазней';

  @override
  String get userProfile_viewChart => 'Бодыграф';

  @override
  String get userProfile_chartPrivate => 'Гэтая карта прыватная';

  @override
  String get userProfile_chartFriendsOnly =>
      'Станьце ўзаемнымі падпісчыкамі, каб убачыць гэтую карту';

  @override
  String get userProfile_chartFollowToView =>
      'Падпішыцеся, каб убачыць гэтую карту';

  @override
  String get userProfile_publicProfile => 'Адкрыты профіль';

  @override
  String get userProfile_privateProfile => 'Закрыты профіль';

  @override
  String get userProfile_friendsOnlyProfile => 'Толькі для сяброў';

  @override
  String get userProfile_followersList => 'Падпісчыкі';

  @override
  String get userProfile_followingList => 'Падпіскі';

  @override
  String get userProfile_noFollowers => 'Пакуль няма падпісчыкаў';

  @override
  String get userProfile_noFollowing => 'Пакуль ні на каго не падпісаны';

  @override
  String get userProfile_thoughts => 'Думкі';

  @override
  String get userProfile_noThoughts => 'Пакуль няма апублікаваных думак';

  @override
  String get userProfile_showAll => 'Паказаць усё';

  @override
  String get popularCharts_title => 'Папулярныя карты';

  @override
  String get popularCharts_subtitle => 'Самыя папулярныя публічныя карты';

  @override
  String time_minutesAgo(int minutes) {
    return '$minutes хв. таму';
  }

  @override
  String time_hoursAgo(int hours) {
    return '$hours гадз. таму';
  }

  @override
  String time_daysAgo(int days) {
    return '$days дз. таму';
  }

  @override
  String get transit_title => 'Транзіты сёння';

  @override
  String get transit_currentEnergies => 'Бягучыя энергіі';

  @override
  String get transit_sunGate => 'Вароты Сонца';

  @override
  String get transit_earthGate => 'Вароты Зямлі';

  @override
  String get transit_moonGate => 'Вароты Месяца';

  @override
  String get transit_activeGates => 'Актыўныя транзітныя вароты';

  @override
  String get transit_activeChannels => 'Актыўныя транзітныя каналы';

  @override
  String get transit_personalImpact => 'Асабісты ўплыў';

  @override
  String transit_gateActivated(int gate) {
    return 'Вароты $gate актываваны транзітам';
  }

  @override
  String transit_channelFormed(String channel) {
    return 'Канал $channel утвораны з вашай картай';
  }

  @override
  String get transit_noPersonalImpact => 'Няма прямых транзітных сувязяў сёння';

  @override
  String get transit_viewFullTransit => 'Паказаць поўную карту транзітаў';

  @override
  String get affirmation_title => 'Штодзённая афірмацыя';

  @override
  String affirmation_forYourType(String type) {
    return 'Для вашага тыпу $type';
  }

  @override
  String affirmation_basedOnGate(int gate) {
    return 'На аснове варот $gate';
  }

  @override
  String get affirmation_refresh => 'Новая афірмацыя';

  @override
  String get affirmation_save => 'Захаваць афірмацыю';

  @override
  String get affirmation_saved => 'Захаваныя афірмацыі';

  @override
  String get affirmation_share => 'Падзяліцца афірмацыяй';

  @override
  String get affirmation_notifications => 'Апавяшчэнні аб афірмацыях';

  @override
  String get affirmation_notificationTime => 'Час апавяшчэння';

  @override
  String get lifestyle_today => 'Сёння';

  @override
  String get lifestyle_insights => 'Інсайты';

  @override
  String get lifestyle_journal => 'Дзённік';

  @override
  String get lifestyle_addJournalEntry => 'Дадаць запіс';

  @override
  String get lifestyle_journalPrompt => 'Як вы перажываеце свой дызайн сёння?';

  @override
  String get lifestyle_noJournalEntries => 'Пакуль няма запісаў';

  @override
  String get lifestyle_mood => 'Настрой';

  @override
  String get lifestyle_energy => 'Узровень энергіі';

  @override
  String get lifestyle_reflection => 'Разважанне';

  @override
  String get penta_title => 'Пента';

  @override
  String get penta_description => 'Групавы аналіз для 3-5 чалавек';

  @override
  String get penta_createNew => 'Стварыць Пенту';

  @override
  String get penta_selectMembers => 'Выберыце ўдзельнікаў';

  @override
  String get penta_minMembers => 'Мінімум 3 удзельнікі';

  @override
  String get penta_maxMembers => 'Максімум 5 удзельнікаў';

  @override
  String get penta_groupDynamics => 'Групавая дынаміка';

  @override
  String get penta_missingRoles => 'Адсутныя ролі';

  @override
  String get penta_strengths => 'Моцныя бакі групы';

  @override
  String get penta_analysis => 'Аналіз Пента';

  @override
  String get penta_clearAnalysis => 'Ачысціць аналіз';

  @override
  String get penta_infoText =>
      'Аналіз Пента раскрывае натуральныя ролі, што ўзнікаюць у малых групах з 3-5 чалавек, паказваючы, як кожны ўдзельнік уплывае на дынаміку каманды.';

  @override
  String get penta_calculating => 'Разлік...';

  @override
  String get penta_calculate => 'Разлічыць Пенту';

  @override
  String get penta_groupRoles => 'Ролі ў групе';

  @override
  String get penta_electromagneticConnections => 'Электрамагнітныя сувязі';

  @override
  String get penta_connectionsDescription =>
      'Асаблівыя энергетычныя сувязі паміж удзельнікамі, якія ствараюць прыцягненне і хімію.';

  @override
  String get penta_areasForAttention => 'Вобласці для ўвагі';

  @override
  String get composite_title => 'Кампазітная карта';

  @override
  String get composite_infoText =>
      'Кампазітная карта паказвае дынаміку адносін паміж двума людзьмі, раскрываючы, як вашы карты ўзаемадзейнічаюць і дапаўняюць адзін аднаго.';

  @override
  String get composite_selectTwoCharts => 'Выберыце 2 карты';

  @override
  String get composite_calculate => 'Аналізаваць сувязь';

  @override
  String get composite_calculating => 'Аналізуем...';

  @override
  String get composite_clearAnalysis => 'Ачысціць аналіз';

  @override
  String get composite_connectionTheme => 'Тэма сувязі';

  @override
  String get composite_definedCenters => 'Азначана';

  @override
  String get composite_undefinedCenters => 'Адкрыта';

  @override
  String get composite_score => 'Ацэнка';

  @override
  String get composite_themeVeryBonded =>
      'Вельмі звязаныя адносіны - вы можаце адчуваць глыбокае пераплятанне';

  @override
  String get composite_themeBonded =>
      'Звязаныя адносіны - моцнае пачуццё адзінства і агульнай энергіі';

  @override
  String get composite_themeBalanced =>
      'Збалансаваныя адносіны - здаровая спалучэнне адзінства і незалежнасці';

  @override
  String get composite_themeIndependent =>
      'Незалежныя адносіны - больш прасторы для асабістага росту';

  @override
  String get composite_themeVeryIndependent =>
      'Вельмі незалежныя адносіны - усведамлены час разам умацоўвае сувязь';

  @override
  String get composite_electromagnetic => 'Електрамагнітныя каналы';

  @override
  String get composite_electromagneticDesc =>
      'Інтэнсіўнае прыцягненне - вы дапаўняеце адзін аднаго';

  @override
  String get composite_companionship => 'Каналы таварыства';

  @override
  String get composite_companionshipDesc =>
      'Камфорт і стабільнасць - агульнае разуменне';

  @override
  String get composite_dominance => 'Каналы дамінавання';

  @override
  String get composite_dominanceDesc => 'Адзін вучыць/уплывае на другога';

  @override
  String get composite_compromise => 'Каналы кампрамісу';

  @override
  String get composite_compromiseDesc =>
      'Натуральная напружанасць - патрабуе ўсведамленасці';

  @override
  String get composite_noConnections => 'Няма сувязяў каналаў';

  @override
  String get composite_noConnectionsDesc =>
      'Гэтыя карты не ўтвараюць прамых сувязяў каналаў, але могуць быць цікавыя ўзаемадзеянні варот.';

  @override
  String get composite_noChartsTitle => 'Няма даступных карт';

  @override
  String get composite_noChartsDesc =>
      'Стварыце карты для сябе і іншых, каб параўнаць дынаміку адносін.';

  @override
  String get composite_needMoreCharts => 'Трэба больш карт';

  @override
  String get composite_needMoreChartsDesc =>
      'Для аналізу адносін трэба мінімум 2 карты. Дадайце яшчэ адну карту.';

  @override
  String get composite_selectTwoHint => 'Выберыце 2 карты для аналізу сувязі';

  @override
  String get composite_selectOneMore => 'Выберыце яшчэ 1 карту';

  @override
  String get premium_upgrade => 'Перайсці на Premium';

  @override
  String get premium_subscribe => 'Падпісацца';

  @override
  String get premium_restore => 'Аднавіць пакупкі';

  @override
  String get premium_features => 'Магчымасці Premium';

  @override
  String get premium_unlimitedShares => 'Бязлімітны абмен картамі';

  @override
  String get premium_groupCharts => 'Групавыя карты';

  @override
  String get premium_advancedTransits => 'Пашыраны аналіз транзітаў';

  @override
  String get premium_personalizedAffirmations => 'Персаналізаваныя афірмацыі';

  @override
  String get premium_journalInsights => 'Інсайты дзённіка';

  @override
  String get premium_adFree => 'Без рэкламы';

  @override
  String get premium_monthly => 'Штомесячна';

  @override
  String get premium_yearly => 'Штогадова';

  @override
  String get premium_perMonth => '/месяц';

  @override
  String get premium_perYear => '/год';

  @override
  String get premium_bestValue => 'Лепшая прапанова';

  @override
  String get settings_appearance => 'Знешні выгляд';

  @override
  String get settings_language => 'Мова';

  @override
  String get settings_selectLanguage => 'Выбар мовы';

  @override
  String get settings_changeLanguage => 'Змяніць мову';

  @override
  String get settings_theme => 'Тэма';

  @override
  String get settings_selectTheme => 'Выбар тэмы';

  @override
  String get settings_chartDisplay => 'Адлюстраванне карты';

  @override
  String get settings_showGateNumbers => 'Паказваць нумары варот';

  @override
  String get settings_showGateNumbersSubtitle =>
      'Адлюстроўваць нумары варот на бодыграфе';

  @override
  String get settings_use24HourTime => '24-гадзінны фармат';

  @override
  String get settings_use24HourTimeSubtitle =>
      'Адлюстроўваць час у 24-гадзінным фармаце';

  @override
  String get settings_feedback => 'Зваротная сувязь';

  @override
  String get settings_hapticFeedback => 'Тактыльны водгук';

  @override
  String get settings_hapticFeedbackSubtitle => 'Вібрацыя пры ўзаемадзеянні';

  @override
  String get settings_account => 'Акаўнт';

  @override
  String get settings_changePassword => 'Змяніць пароль';

  @override
  String get settings_deleteAccount => 'Выдаліць акаўнт';

  @override
  String get settings_deleteAccountConfirm =>
      'Вы ўпэўнены, што хочаце выдаліць акаўнт? Гэтае дзеянне незваротнае, і ўсе вашы дадзеныя будуць выдалены назаўсёды.';

  @override
  String get settings_appVersion => 'Версія прыкладання';

  @override
  String get settings_rateApp => 'Ацаніць прыкладанне';

  @override
  String get settings_sendFeedback => 'Адправіць водгук';

  @override
  String get settings_themeLight => 'Светлая';

  @override
  String get settings_themeDark => 'Цёмная';

  @override
  String get settings_themeSystem => 'Сістэмная';

  @override
  String get settings_notifications => 'Апавяшчэнні';

  @override
  String get settings_privacy => 'Канфідэнцыяльнасць';

  @override
  String get settings_chartVisibility => 'Бачнасць карты';

  @override
  String get settings_chartVisibilitySubtitle => 'Хто можа бачыць вашу карту';

  @override
  String get settings_chartPrivate => 'Прыватная';

  @override
  String get settings_chartPrivateDesc => 'Толькі вы бачыце сваю карту';

  @override
  String get settings_chartFriends => 'Сябры';

  @override
  String get settings_chartFriendsDesc =>
      'Узаемныя падпісчыкі могуць бачыць вашу карту';

  @override
  String get settings_chartPublic => 'Публічная';

  @override
  String get settings_chartPublicDesc =>
      'Вашы падпісчыкі могуць бачыць вашу карту';

  @override
  String get settings_about => 'Пра прыкладанне';

  @override
  String get settings_help => 'Дапамога і падтрымка';

  @override
  String get settings_terms => 'Умовы выкарыстання';

  @override
  String get settings_privacyPolicy => 'Палітыка канфідэнцыяльнасці';

  @override
  String get settings_version => 'Версія';

  @override
  String get settings_dailyTransits => 'Штодзённыя транзіты';

  @override
  String get settings_dailyTransitsSubtitle =>
      'Атрымліваць штодзённыя абнаўленні транзітаў';

  @override
  String get settings_gateChanges => 'Змена варот';

  @override
  String get settings_gateChangesSubtitle => 'Апавяшчаць пры змене варот Сонца';

  @override
  String get settings_socialActivity => 'Сацыяльная актыўнасць';

  @override
  String get settings_socialActivitySubtitle => 'Запыты ў сябры і публікацыі';

  @override
  String get settings_achievements => 'Дасягненні';

  @override
  String get settings_achievementsSubtitle => 'Новыя значкі і ўзнагароды';

  @override
  String get settings_deleteAccountWarning =>
      'Усе вашы дадзеныя, уключаючы карты, посты і паведамленні, будуць назаўсёды выдалены.';

  @override
  String get settings_deleteAccountFailed =>
      'Не ўдалося выдаліць акаўнт. Паспрабуйце яшчэ раз.';

  @override
  String get settings_passwordChanged => 'Пароль паспяхова зменены';

  @override
  String get settings_passwordChangeFailed =>
      'Не ўдалося змяніць пароль. Паспрабуйце яшчэ раз.';

  @override
  String get settings_feedbackSubject => 'Водгук аб прыкладанні Inside Me';

  @override
  String get settings_feedbackBody =>
      'Добры дзень,\n\nХачу падзяліцца водгукам аб прыкладанні Inside Me:\n\n';

  @override
  String get auth_newPassword => 'Новы пароль';

  @override
  String get auth_passwordRequired => 'Увядзіце пароль';

  @override
  String get auth_passwordTooShort => 'Пароль павінен быць не менш 8 сімвалаў';

  @override
  String get auth_passwordsDoNotMatch => 'Паролі не супадаюць';

  @override
  String get settings_exportData => 'Экспарт маіх дадзеных';

  @override
  String get settings_exportDataSubtitle =>
      'Спампаваць копію ўсіх вашых дадзеных (GDPR)';

  @override
  String get settings_exportingData => 'Падрыхтоўка экспарту дадзеных...';

  @override
  String get settings_exportDataSubject => 'Inside Me - Экспарт дадзеных';

  @override
  String get settings_exportDataFailed =>
      'Не ўдалося экспартаваць дадзеныя. Паспрабуйце яшчэ раз.';

  @override
  String get error_generic => 'Нешта пайшло не так';

  @override
  String get error_network => 'Няма падключэння да інтэрнэту';

  @override
  String get error_invalidEmail => 'Увядзіце карэктны email';

  @override
  String get error_invalidPassword => 'Пароль павінен быць не менш 8 сімвалаў';

  @override
  String get error_passwordMismatch => 'Паролі не супадаюць';

  @override
  String get error_birthDataRequired => 'Увядзіце дадзеныя нараджэння';

  @override
  String get error_locationRequired => 'Выберыце месца нараджэння';

  @override
  String get error_chartCalculation => 'Не ўдалося разлічыць карту';

  @override
  String get profile_editProfile => 'Рэдагаваць профіль';

  @override
  String get profile_shareChart => 'Падзяліцца картай';

  @override
  String get profile_exportPdf => 'Экспарт у PDF';

  @override
  String get profile_upgradePremium => 'Перайсці на Premium';

  @override
  String get profile_birthData => 'Дадзеныя нараджэння';

  @override
  String get profile_chartSummary => 'Зводка карты';

  @override
  String get profile_viewFullChart => 'Глядзець поўную карту';

  @override
  String get profile_signOut => 'Выйсці';

  @override
  String get profile_signOutConfirm => 'Вы ўпэўнены, што хочаце выйсці?';

  @override
  String get profile_addBirthDataPrompt =>
      'Дадайце дадзеныя нараджэння для стварэння вашай карты Дызайну Чалавека.';

  @override
  String get profile_addBirthDataToShare =>
      'Дадайце дадзеныя нараджэння, каб падзяліцца картай';

  @override
  String get profile_addBirthDataToExport =>
      'Дадайце дадзеныя нараджэння для экспарту карты';

  @override
  String get profile_exportFailed => 'Не ўдалося экспартаваць PDF';

  @override
  String get profile_signOutConfirmTitle => 'Выхад';

  @override
  String get profile_loadFailed => 'Не ўдалося загрузіць профіль';

  @override
  String get profile_defaultUserName => 'Карыстальнік Inside Me';

  @override
  String get profile_birthDate => 'Дата';

  @override
  String get profile_birthTime => 'Час';

  @override
  String get profile_birthLocation => 'Месца';

  @override
  String get profile_birthTimezone => 'Часавы пояс';

  @override
  String get chart_chakras => 'Чакры';

  @override
  String get chakra_title => 'Энергія чакр';

  @override
  String get chakra_activated => 'Актывавана';

  @override
  String get chakra_inactive => 'Неактыўная';

  @override
  String chakra_activatedCount(int count) {
    return '$count з 7 чакр актывавана';
  }

  @override
  String get chakra_hdMapping => 'Адпаведнасць цэнтрам HD';

  @override
  String get chakra_element => 'Элемент';

  @override
  String get chakra_location => 'Размяшчэнне';

  @override
  String get chakra_root => 'Муладхара';

  @override
  String get chakra_root_sanskrit => 'Muladhara';

  @override
  String get chakra_root_description => 'Зямля, выжыванне і стабільнасць';

  @override
  String get chakra_sacral => 'Свадхістхана';

  @override
  String get chakra_sacral_sanskrit => 'Svadhisthana';

  @override
  String get chakra_sacral_description => 'Творчасць, сексуальнасць і эмоцыі';

  @override
  String get chakra_solarPlexus => 'Маніпура';

  @override
  String get chakra_solarPlexus_sanskrit => 'Manipura';

  @override
  String get chakra_solarPlexus_description =>
      'Асабістая сіла, упэўненасць і воля';

  @override
  String get chakra_heart => 'Анахата';

  @override
  String get chakra_heart_sanskrit => 'Anahata';

  @override
  String get chakra_heart_description => 'Любоў, спагада і сувязь';

  @override
  String get chakra_throat => 'Вішуддха';

  @override
  String get chakra_throat_sanskrit => 'Vishuddha';

  @override
  String get chakra_throat_description => 'Зносіны, выражэнне і праўда';

  @override
  String get chakra_thirdEye => 'Аджна';

  @override
  String get chakra_thirdEye_sanskrit => 'Ajna';

  @override
  String get chakra_thirdEye_description => 'Інтуіцыя, прадбачанне і ўяўленне';

  @override
  String get chakra_crown => 'Сахасрара';

  @override
  String get chakra_crown_sanskrit => 'Sahasrara';

  @override
  String get chakra_crown_description => 'Духоўная сувязь і свядомасць';

  @override
  String get quiz_title => 'Тэсты';

  @override
  String get quiz_yourProgress => 'Ваш прагрэс';

  @override
  String quiz_quizzesCompleted(int count) {
    return '$count тэстаў завершана';
  }

  @override
  String get quiz_accuracy => 'Дакладнасць';

  @override
  String get quiz_streak => 'Серыя';

  @override
  String get quiz_all => 'Усе';

  @override
  String get quiz_difficulty => 'Складанасць';

  @override
  String get quiz_beginner => 'Пачатковы';

  @override
  String get quiz_intermediate => 'Сярэдні';

  @override
  String get quiz_advanced => 'Прасунуты';

  @override
  String quiz_questions(int count) {
    return '$count пытанняў';
  }

  @override
  String quiz_points(int points) {
    return '+$points бал.';
  }

  @override
  String get quiz_completed => 'Завершаны';

  @override
  String get quiz_noQuizzes => 'Няма даступных тэстаў';

  @override
  String get quiz_checkBackLater => 'Зазірніце пазней за новым кантэнтам';

  @override
  String get quiz_startQuiz => 'Пачаць тэст';

  @override
  String get quiz_tryAgain => 'Паспрабаваць зноў';

  @override
  String get quiz_backToQuizzes => 'Да тэстаў';

  @override
  String get quiz_shareResults => 'Падзяліцца вынікамі';

  @override
  String get quiz_yourBest => 'Ваш лепшы';

  @override
  String get quiz_perfectScore => 'Ідэальны вынік!';

  @override
  String get quiz_newBest => 'Новы рэкорд!';

  @override
  String get quiz_streakExtended => 'Серыя працягнута!';

  @override
  String quiz_questionOf(int current, int total) {
    return 'Пытанне $current з $total';
  }

  @override
  String quiz_correct(int count) {
    return '$count правільна';
  }

  @override
  String get quiz_submitAnswer => 'Адказаць';

  @override
  String get quiz_nextQuestion => 'Наступнае пытанне';

  @override
  String get quiz_seeResults => 'Вынікі';

  @override
  String get quiz_exitQuiz => 'Выйсці з тэста?';

  @override
  String get quiz_exitWarning => 'Ваш прагрэс будзе страчаны.';

  @override
  String get quiz_exit => 'Выйсці';

  @override
  String get quiz_timesUp => 'Час скончыўся!';

  @override
  String get quiz_timesUpMessage =>
      'Час скончыўся. Ваш прагрэс будзе захаваны.';

  @override
  String get quiz_excellent => 'Выдатна!';

  @override
  String get quiz_goodJob => 'Добрая праца!';

  @override
  String get quiz_keepLearning => 'Працягвайце вучыцца!';

  @override
  String get quiz_keepPracticing => 'Працягвайце практыкавацца!';

  @override
  String get quiz_masteredTopic => 'Вы асвоілі гэтую тэму!';

  @override
  String get quiz_strongUnderstanding => 'У вас добрае разуменне.';

  @override
  String get quiz_onRightTrack => 'Вы на правільным шляху.';

  @override
  String get quiz_reviewExplanations => 'Вывучыце тлумачэнні для паляпшэння.';

  @override
  String get quiz_studyMaterial => 'Вывучыце матэрыял і паспрабуйце зноў.';

  @override
  String get quiz_attemptHistory => 'Гісторыя спроб';

  @override
  String get quiz_statistics => 'Статыстыка тэстаў';

  @override
  String get quiz_totalQuizzes => 'Тэстаў';

  @override
  String get quiz_totalQuestions => 'Пытанняў';

  @override
  String get quiz_bestStreak => 'Лепшая серыя';

  @override
  String quiz_strongest(String category) {
    return 'Найбольш моцная: $category';
  }

  @override
  String quiz_needsWork(String category) {
    return 'Патрабуе працы: $category';
  }

  @override
  String get quiz_category_types => 'Тыпы';

  @override
  String get quiz_category_centers => 'Цэнтры';

  @override
  String get quiz_category_authorities => 'Аўтарытэты';

  @override
  String get quiz_category_profiles => 'Профілі';

  @override
  String get quiz_category_gates => 'Вароты';

  @override
  String get quiz_category_channels => 'Каналы';

  @override
  String get quiz_category_definitions => 'Азначанасці';

  @override
  String get quiz_category_general => 'Агульнае';

  @override
  String get quiz_explanation => 'Тлумачэнне';

  @override
  String get quiz_quizzes => 'Тэсты';

  @override
  String get quiz_questionsLabel => 'Пытанні';

  @override
  String get quiz_shareProgress => 'Падзяліцца прагрэсам';

  @override
  String get quiz_shareProgressSubject =>
      'Мой прагрэс у вывучэнні Дызайну Чалавека';

  @override
  String get quiz_sharePerfect =>
      'Я дасягнуў ідэальнага вынікуl! Асвойваю Дызайн Чалавека.';

  @override
  String get quiz_shareExcellent =>
      'Выдатна прасоўваюся ў вывучэнні Дызайну Чалавека!';

  @override
  String get quiz_shareGoodJob =>
      'Вывучаю Дызайн Чалавека. Кожны тэст дапамагае расці!';

  @override
  String quiz_shareSubject(String quizTitle, int score) {
    return 'Мой вынік $score% у \"$quizTitle\" - Тэст Дызайну Чалавека';
  }

  @override
  String get quiz_failedToLoadStats => 'Не ўдалося загрузіць статыстыку';

  @override
  String get planetary_personality => 'Асоба';

  @override
  String get planetary_design => 'Дызайн';

  @override
  String get planetary_consciousBirth => 'Свядомае · Нараджэнне';

  @override
  String get planetary_unconsciousPrenatal => 'Несвядомае · 88° Прэнатальна';

  @override
  String get gamification_yourProgress => 'Ваш прагрэс';

  @override
  String get gamification_level => 'Узровень';

  @override
  String get gamification_points => 'балаў';

  @override
  String get gamification_viewAll => 'Паказаць усе';

  @override
  String get gamification_allChallengesComplete =>
      'Усе штодзённыя заданні выкананы!';

  @override
  String get gamification_dailyChallenge => 'Штодзённае заданне';

  @override
  String get gamification_achievements => 'Дасягненні';

  @override
  String get gamification_challenges => 'Заданні';

  @override
  String get gamification_leaderboard => 'Рэйтынг';

  @override
  String get gamification_streak => 'Серыя';

  @override
  String get gamification_badges => 'Значкі';

  @override
  String get gamification_earnedBadge => 'Вы атрымалі значок!';

  @override
  String get gamification_claimReward => 'Атрымаць узнагароду';

  @override
  String get gamification_completed => 'Выканана';

  @override
  String get common_copy => 'Капіяваць';

  @override
  String get share_myShares => 'Мае спасылкі';

  @override
  String get share_createNew => 'Стварыць';

  @override
  String get share_newLink => 'Новая спасылка';

  @override
  String get share_noShares => 'Няма спасылак';

  @override
  String get share_noSharesMessage =>
      'Стварыце спасылкі, каб іншыя маглі праглядаць вашу карту без рэгістрацыі.';

  @override
  String get share_createFirst => 'Стварыць першую спасылку';

  @override
  String share_activeLinks(int count) {
    return '$count актыўных';
  }

  @override
  String share_expiredLinks(int count) {
    return '$count пратэрмінаваных';
  }

  @override
  String get share_clearExpired => 'Ачысціць';

  @override
  String get share_clearExpiredTitle => 'Выдаліць пратэрмінаваныя спасылкі';

  @override
  String share_clearExpiredMessage(int count) {
    return 'Будзе выдалена $count пратэрмінаваных спасылак з гісторыі.';
  }

  @override
  String get share_clearAll => 'Выдаліць усё';

  @override
  String get share_expiredCleared => 'Пратэрмінаваныя спасылкі выдалены';

  @override
  String get share_linkCopied => 'Спасылка скапіявана';

  @override
  String get share_revokeTitle => 'Адклікаць спасылку';

  @override
  String get share_revokeMessage =>
      'Спасылка будзе дэактывавана. Тыя, хто мае гэтую спасылку, больш не змогуць праглядаць вашу карту.';

  @override
  String get share_revoke => 'Адклікаць';

  @override
  String get share_linkRevoked => 'Спасылка адклікана';

  @override
  String get share_totalLinks => 'Усяго';

  @override
  String get share_active => 'Актыўныя';

  @override
  String get share_totalViews => 'Праглядаў';

  @override
  String get share_chartLink => 'Спасылка на карту';

  @override
  String get share_transitLink => 'Спасылка на транзіт';

  @override
  String get share_compatibilityLink => 'Справаздача сумяшчальнасці';

  @override
  String get share_link => 'Спасылка';

  @override
  String share_views(int count) {
    return '$count прагл.';
  }

  @override
  String get share_expired => 'Пратэрмінавана';

  @override
  String get share_activeLabel => 'Актыўная';

  @override
  String share_expiredOn(String date) {
    return 'Пратэрмінавана $date';
  }

  @override
  String share_expiresIn(String time) {
    return 'Пратэрмінуецца праз $time';
  }

  @override
  String get auth_emailNotConfirmed => 'Пацвердзіце email';

  @override
  String get auth_resendConfirmation => 'Адправіць паўторна';

  @override
  String get auth_confirmationSent => 'Ліст адпраўлены';

  @override
  String get auth_checkEmail => 'Праверце пошту для пацверджання';

  @override
  String get auth_checkYourEmail => 'Праверце пошту';

  @override
  String get auth_confirmationLinkSent =>
      'Мы адправілі спасылку для пацверджання на:';

  @override
  String get auth_clickLinkToActivate =>
      'Калі ласка, націсніце на спасылку ў лісце для актывацыі акаўнта.';

  @override
  String get auth_goToSignIn => 'Перайсці да ўваходу';

  @override
  String get auth_returnToHome => 'Вярнуцца на галоўную';

  @override
  String get hashtags_explore => 'Хэштэгі';

  @override
  String get hashtags_trending => 'У трэндзе';

  @override
  String get hashtags_popular => 'Папулярныя';

  @override
  String get hashtags_hdTopics => 'Тэмы HD';

  @override
  String get hashtags_noTrending => 'Пакуль няма трэндавых хэштэгаў';

  @override
  String get hashtags_noPopular => 'Пакуль няма папулярных хэштэгаў';

  @override
  String get hashtags_noHdTopics => 'Пакуль няма тэм HD';

  @override
  String get hashtag_noPosts => 'Пакуль няма постаў';

  @override
  String get hashtag_beFirst => 'Будзьце першым, хто напіша з гэтым хэштэгам!';

  @override
  String hashtag_postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count постаў',
      few: '$count посты',
      one: '1 пост',
    );
    return '$_temp0';
  }

  @override
  String hashtag_recentPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count постаў сёння',
      few: '$count посты сёння',
      one: '1 пост сёння',
    );
    return '$_temp0';
  }

  @override
  String get feed_forYou => 'Для вас';

  @override
  String get feed_trending => 'У трэндзе';

  @override
  String get feed_hdTopics => 'Тэмы HD';

  @override
  String feed_gateTitle(int number) {
    return 'Вароты $number';
  }

  @override
  String feed_gatePosts(int number) {
    return 'Посты аб варотах $number';
  }

  @override
  String get transit_events_title => 'Падзеі транзітаў';

  @override
  String get transit_events_happening => 'Зараз';

  @override
  String get transit_events_upcoming => 'Будучыя';

  @override
  String get transit_events_past => 'Мінулыя';

  @override
  String get transit_events_noCurrentEvents => 'Зараз няма актыўных падзей';

  @override
  String get transit_events_noUpcomingEvents => 'Няма запланаваных падзей';

  @override
  String get transit_events_noPastEvents => 'Няма мінулых падзей';

  @override
  String get transit_events_live => 'LIVE';

  @override
  String get transit_events_join => 'Удзельнічаць';

  @override
  String get transit_events_joined => 'Удзельнічаю';

  @override
  String get transit_events_leave => 'Пакінуць';

  @override
  String get transit_events_participating => 'удзельнічаюць';

  @override
  String get transit_events_posts => 'постаў';

  @override
  String get transit_events_viewInsights => 'Глядзець інсайты';

  @override
  String transit_events_endsIn(String time) {
    return 'Заканчваецца праз $time';
  }

  @override
  String transit_events_startsIn(String time) {
    return 'Пачнецца праз $time';
  }

  @override
  String get transit_events_notFound => 'Падзея не знойдзена';

  @override
  String get transit_events_communityPosts => 'Посты супольнасці';

  @override
  String get transit_events_noPosts => 'Пакуль няма постаў для гэтай падзеі';

  @override
  String get transit_events_shareExperience => 'Падзяліцца вопытам';

  @override
  String get transit_events_participants => 'Удзельнікі';

  @override
  String get transit_events_duration => 'Працягласць';

  @override
  String get transit_events_eventEnded => 'Падзея завяршылася';

  @override
  String get transit_events_youreParticipating => 'Вы ўдзельнічаеце!';

  @override
  String transit_events_experiencingWith(int count) {
    return 'Перажываюць гэты транзіт з $count іншымі';
  }

  @override
  String get transit_events_joinCommunity => 'Далучыцца да супольнасці';

  @override
  String get transit_events_shareYourExperience =>
      'Падзяліцеся вопытам і звяжыцеся з іншымі';

  @override
  String get activity_title => 'Актыўнасць сяброў';

  @override
  String get activity_noActivities => 'Пакуль няма актыўнасці сяброў';

  @override
  String get activity_followFriends =>
      'Падпішыцеся на сяброў, каб бачыць іх дасягненні тут!';

  @override
  String get activity_findFriends => 'Знайсці сяброў';

  @override
  String get activity_celebrate => 'Павіншаваць';

  @override
  String get activity_celebrated => 'Павіншавалі';

  @override
  String get cancel => 'Адмяніць';

  @override
  String get create => 'Стварыць';

  @override
  String get groupChallenges_title => 'Групавыя выклікі';

  @override
  String get groupChallenges_myTeams => 'Мае каманды';

  @override
  String get groupChallenges_challenges => 'Выклікі';

  @override
  String get groupChallenges_leaderboard => 'Рэйтынг';

  @override
  String get groupChallenges_createTeam => 'Стварыць каманду';

  @override
  String get groupChallenges_teamName => 'Назва каманды';

  @override
  String get groupChallenges_teamNameHint => 'Увядзіце назву каманды';

  @override
  String get groupChallenges_teamDescription => 'Апісанне';

  @override
  String get groupChallenges_teamDescriptionHint => 'Пра што ваша каманда?';

  @override
  String get groupChallenges_teamCreated => 'Каманда створана!';

  @override
  String get groupChallenges_noTeams => 'Пакуль няма каманд';

  @override
  String get groupChallenges_noTeamsDescription =>
      'Стварыце або далучыцеся да каманды для ўдзелу ў групавых выкліках!';

  @override
  String groupChallenges_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count удзельнікаў',
      few: '$count удзельнікі',
      one: '1 удзельнік',
    );
    return '$_temp0';
  }

  @override
  String groupChallenges_points(int points) {
    return '$points бал.';
  }

  @override
  String get groupChallenges_noChallenges => 'Няма актыўных выклікаў';

  @override
  String get groupChallenges_active => 'Актыўныя';

  @override
  String get groupChallenges_upcoming => 'Будучыя';

  @override
  String groupChallenges_reward(int points) {
    return '$points бал. узнагарода';
  }

  @override
  String groupChallenges_teamsEnrolled(String count) {
    return '$count каманд';
  }

  @override
  String groupChallenges_participants(String count) {
    return '$count удзельнікаў';
  }

  @override
  String groupChallenges_endsIn(String time) {
    return 'Заканчваецца праз $time';
  }

  @override
  String get groupChallenges_weekly => 'Тыдзень';

  @override
  String get groupChallenges_monthly => 'Месяц';

  @override
  String get groupChallenges_allTime => 'Увесь час';

  @override
  String get groupChallenges_noTeamsOnLeaderboard =>
      'Пакуль няма каманд у рэйтынгу';

  @override
  String get groupChallenges_pts => 'бал.';

  @override
  String get groupChallenges_teamNotFound => 'Каманда не знойдзена';

  @override
  String get groupChallenges_members => 'Удзельнікі';

  @override
  String get groupChallenges_totalPoints => 'Усяго балаў';

  @override
  String get groupChallenges_joined => 'Удзельнічаю';

  @override
  String get groupChallenges_join => 'Уступіць';

  @override
  String get groupChallenges_status => 'Статус';

  @override
  String get groupChallenges_about => 'Пра каманду';

  @override
  String get groupChallenges_noMembers => 'Пакуль няма удзельнікаў';

  @override
  String get groupChallenges_admin => 'Адмін';

  @override
  String groupChallenges_contributed(int points) {
    return '$points бал. унесена';
  }

  @override
  String get groupChallenges_joinedTeam => 'Вы ўступілі ў каманду!';

  @override
  String get groupChallenges_leaveTeam => 'Пакінуць каманду';

  @override
  String get groupChallenges_leaveConfirmation =>
      'Вы ўпэўнены, што хочаце пакінуць каманду? Вашы балы застануцца з камандай.';

  @override
  String get groupChallenges_leave => 'Пакінуць';

  @override
  String get groupChallenges_leftTeam => 'Вы пакінулі каманду';

  @override
  String get groupChallenges_challengeDetails => 'Дэталі выкліку';

  @override
  String get groupChallenges_challengeNotFound => 'Выклік не знойдзены';

  @override
  String get groupChallenges_target => 'Мэта';

  @override
  String get groupChallenges_starts => 'Пачатак';

  @override
  String get groupChallenges_ends => 'Канец';

  @override
  String get groupChallenges_hdTypes => 'Тыпы HD';

  @override
  String get groupChallenges_noTeamsToEnroll => 'Няма каманд для запісу';

  @override
  String get groupChallenges_createTeamToJoin =>
      'Спачатку стварыце каманду для ўдзелу ў выкліках';

  @override
  String get groupChallenges_enrollTeam => 'Запісаць каманду';

  @override
  String get groupChallenges_enrolled => 'Запісаны';

  @override
  String get groupChallenges_enroll => 'Запісаць';

  @override
  String get groupChallenges_teamEnrolled => 'Каманда паспяхова запісана!';

  @override
  String get groupChallenges_noTeamsEnrolled => 'Пакуль няма запісаных каманд';

  @override
  String get circles_title => 'Кругі сумяшчальнасці';

  @override
  String get circles_myCircles => 'Мае кругі';

  @override
  String get circles_invitations => 'Запрашэнні';

  @override
  String get circles_create => 'Стварыць круг';

  @override
  String get circles_selectIcon => 'Выберыце іконку';

  @override
  String get circles_name => 'Назва круга';

  @override
  String get circles_nameHint => 'Сям\'я, Каманда, Сябры...';

  @override
  String get circles_description => 'Апісанне';

  @override
  String get circles_descriptionHint => 'Для чаго гэты круг?';

  @override
  String get circles_created => 'Круг паспяхова створаны!';

  @override
  String get circles_noCircles => 'Пакуль няма кругоў';

  @override
  String get circles_noCirclesDescription =>
      'Стварыце круг для аналізу сумяшчальнасці з сябрамі, сям\'ёй або калегамі.';

  @override
  String get circles_suggestions => 'Хуткі старт';

  @override
  String circles_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count удзельнікаў',
      few: '$count удзельнікі',
      one: '1 удзельнік',
    );
    return '$_temp0';
  }

  @override
  String get circles_private => 'Прыватны';

  @override
  String get circles_noInvitations => 'Няма запрашэнняў';

  @override
  String get circles_noInvitationsDescription =>
      'Тут з\'явяцца запрашэнні ў кругі.';

  @override
  String circles_invitedBy(String name) {
    return 'Запрасіў $name';
  }

  @override
  String get circles_decline => 'Адхіліць';

  @override
  String get circles_accept => 'Прыняць';

  @override
  String get circles_invitationDeclined => 'Запрашэнне адхілена';

  @override
  String get circles_invitationAccepted => 'Вы далучыліся да круга!';

  @override
  String get circles_notFound => 'Круг не знойдзены';

  @override
  String get circles_invite => 'Запрасіць';

  @override
  String get circles_members => 'Удзельнікі';

  @override
  String get circles_analysis => 'Аналіз';

  @override
  String get circles_feed => 'Стужка';

  @override
  String get circles_inviteMember => 'Запрасіць удзельніка';

  @override
  String get circles_sendInvite => 'Адправіць запрашэнне';

  @override
  String get circles_invitationSent => 'Запрашэнне адпраўлена!';

  @override
  String get circles_invitationFailed => 'Не ўдалося адправіць запрашэнне';

  @override
  String get circles_deleteTitle => 'Выдаліць круг';

  @override
  String circles_deleteConfirmation(String name) {
    return 'Вы ўпэўнены, што хочаце выдаліць \"$name\"? Гэтае дзеянне нельга адмяніць.';
  }

  @override
  String get circles_deleted => 'Круг выдалены';

  @override
  String get circles_noMembers => 'Пакуль няма удзельнікаў';

  @override
  String get circles_noAnalysis => 'Пакуль няма аналізу';

  @override
  String get circles_runAnalysis =>
      'Запусціце аналіз сумяшчальнасці, каб убачыць, як узаемадзейнічаюць удзельнікі круга.';

  @override
  String get circles_needMoreMembers =>
      'Дадайце мінімум 2 удзельнікі для аналізу.';

  @override
  String get circles_analyzeCompatibility => 'Аналізаваць сумяшчальнасць';

  @override
  String get circles_harmonyScore => 'Ацэнка гармоніі';

  @override
  String get circles_typeDistribution => 'Размеркаванне тыпаў';

  @override
  String get circles_electromagneticConnections => 'Електрамагнітныя сувязі';

  @override
  String get circles_electromagneticDesc =>
      'Інтэнсіўнае прыцягненне - вы дапаўняеце адзін аднаго';

  @override
  String get circles_companionshipConnections => 'Сувязі таварыства';

  @override
  String get circles_companionshipDesc =>
      'Камфорт і стабільнасць - агульнае разуменне';

  @override
  String get circles_groupStrengths => 'Моцныя бакі групы';

  @override
  String get circles_areasForGrowth => 'Вобласці для росту';

  @override
  String get circles_writePost => 'Падзяліцеся чымсьці з вашым кругам...';

  @override
  String get circles_noPosts => 'Пакуль няма постаў';

  @override
  String get circles_beFirstToPost =>
      'Будзьце першым, хто падзеліцца чымсьці з вашым кругам!';

  @override
  String get experts_title => 'Эксперты HD';

  @override
  String get experts_becomeExpert => 'Стаць экспертам';

  @override
  String get experts_filterBySpecialization => 'Фільтр па спецыялізацыі';

  @override
  String get experts_allExperts => 'Усе эксперты';

  @override
  String get experts_experts => 'Эксперты';

  @override
  String get experts_noExperts => 'Эксперты не знойдзены';

  @override
  String get experts_featured => 'Рэкамендаваныя эксперты';

  @override
  String experts_followers(int count) {
    return '$count падпісчыкаў';
  }

  @override
  String get experts_notFound => 'Эксперт не знойдзены';

  @override
  String get experts_following => 'Падпісаны';

  @override
  String get experts_follow => 'Падпісацца';

  @override
  String get experts_about => 'Пра сябе';

  @override
  String get experts_specializations => 'Спецыялізацыі';

  @override
  String get experts_credentials => 'Кваліфікацыі';

  @override
  String get experts_reviews => 'Водгукі';

  @override
  String get experts_writeReview => 'Напісаць водгук';

  @override
  String get experts_reviewContent => 'Ваш водгук';

  @override
  String get experts_reviewHint =>
      'Падзяліцеся вопытам працы з гэтым экспертам...';

  @override
  String get experts_submitReview => 'Адправіць водгук';

  @override
  String get experts_reviewSubmitted => 'Водгук паспяхова адпраўлены!';

  @override
  String get experts_noReviews => 'Пакуль няма водгукаў';

  @override
  String get experts_followersLabel => 'Падпісчыкі';

  @override
  String get experts_rating => 'Рэйтынг';

  @override
  String get experts_years => 'Гадоў';

  @override
  String get learningPaths_title => 'Навучальныя шляхі';

  @override
  String get learningPaths_explore => 'Агляд';

  @override
  String get learningPaths_inProgress => 'У працэсе';

  @override
  String get learningPaths_completed => 'Завершаныя';

  @override
  String get learningPaths_featured => 'Рэкамендаваныя шляхі';

  @override
  String get learningPaths_allPaths => 'Усе шляхі';

  @override
  String get learningPaths_noPathsExplore =>
      'Няма даступных навучальных шляхоў';

  @override
  String get learningPaths_noPathsInProgress => 'Няма шляхоў у працэсе';

  @override
  String get learningPaths_noPathsInProgressDescription =>
      'Запішыцеся на навучальны шлях, каб пачаць!';

  @override
  String get learningPaths_browsePaths => 'Агляд шляхоў';

  @override
  String get learningPaths_noPathsCompleted => 'Няма завершаных шляхоў';

  @override
  String get learningPaths_noPathsCompletedDescription =>
      'Завершаныя навучальныя шляхі з\'явяцца тут!';

  @override
  String learningPaths_enrolled(int count) {
    return '$count запісана';
  }

  @override
  String learningPaths_stepsCount(int count) {
    return '$count крокаў';
  }

  @override
  String learningPaths_progress(int completed, int total) {
    return '$completed з $total крокаў';
  }

  @override
  String get learningPaths_resume => 'Працягнуць';

  @override
  String learningPaths_completedOn(String date) {
    return 'Завершаны $date';
  }

  @override
  String get learningPathNotFound => 'Навучальны шлях не знойдзены';

  @override
  String learningPathMinutes(int minutes) {
    return '$minutes хв';
  }

  @override
  String learningPathSteps(int count) {
    return '$count крокаў';
  }

  @override
  String learningPathBy(String author) {
    return 'Ад $author';
  }

  @override
  String learningPathEnrolled(int count) {
    return '$count запісана';
  }

  @override
  String learningPathCompleted(int count) {
    return '$count завершана';
  }

  @override
  String get learningPathEnroll => 'Пачаць навучанне';

  @override
  String get learningPathYourProgress => 'Ваш прагрэс';

  @override
  String get learningPathCompletedBadge => 'Завершаны';

  @override
  String learningPathProgressText(int completed, int total) {
    return '$completed з $total крокаў завершана';
  }

  @override
  String get learningPathStepsTitle => 'Крокі навучання';

  @override
  String get learningPathEnrollTitle => 'Пачаць гэты шлях?';

  @override
  String learningPathEnrollMessage(String title) {
    return 'Вы будзеце запісаны на \"$title\" і зможаце адсочваць прагрэс.';
  }

  @override
  String get learningPathViewContent => 'Прагледзець кантэнт';

  @override
  String get learningPathMarkComplete => 'Адзначыць як завершанае';

  @override
  String get learningPathStepCompleted => 'Крок завершаны!';

  @override
  String get thought_title => 'Думкі';

  @override
  String get thought_feedTitle => 'Думкі';

  @override
  String get thought_createNew => 'Падзяліцца думкай';

  @override
  String get thought_emptyFeed => 'Стужка думак пустая';

  @override
  String get thought_emptyFeedMessage =>
      'Падпішыцеся на людзей або падзяліцеся думкай';

  @override
  String get thought_regenerate => 'Рэпост';

  @override
  String thought_regeneratedFrom(String username) {
    return 'Рэпост ад @$username';
  }

  @override
  String get thought_regenerateSuccess => 'Думка дададзена на вашу сцяну!';

  @override
  String get thought_regenerateConfirm => 'Зрабіць рэпост?';

  @override
  String get thought_regenerateDescription =>
      'Думка з\'явіцца на вашай сцяне са спасылкай на аўтара.';

  @override
  String get thought_addComment => 'Дадаць каментарый (неабавязкова)';

  @override
  String thought_regenerateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рэпостаў',
      few: '$count рэпосты',
      one: '1 рэпост',
    );
    return '$_temp0';
  }

  @override
  String get thought_cannotRegenerateOwn => 'Нельга зрабіць рэпост сваёй думкі';

  @override
  String get thought_alreadyRegenerated => 'Вы ўжо зрабілі рэпост гэтай думкі';

  @override
  String get thought_postDetail => 'Думка';

  @override
  String get thought_noComments => 'Каментарыяў пакуль няма. Будзьце першым!';

  @override
  String thought_replyingTo(String username) {
    return 'Адказ для $username';
  }

  @override
  String get thought_writeReply => 'Напішыце адказ...';

  @override
  String get thought_commentPlaceholder => 'Дадаць каментарый...';

  @override
  String get messages_title => 'Паведамленні';

  @override
  String get messages_conversation => 'Размова';

  @override
  String get messages_loading => 'Загрузка...';

  @override
  String get messages_muteNotifications => 'Адключыць апавяшчэнні';

  @override
  String get messages_notificationsMuted => 'Апавяшчэнні адключаны';

  @override
  String get messages_blockUser => 'Заблакаваць';

  @override
  String get messages_blockUserConfirm =>
      'Вы ўпэўнены, што хочаце заблакаваць гэтага карыстальніка? Вы больш не будзеце атрымліваць ад яго паведамленні.';

  @override
  String get messages_userBlocked => 'Карыстальнік заблакаваны';

  @override
  String get messages_block => 'Заблакаваць';

  @override
  String get messages_deleteConversation => 'Выдаліць размову';

  @override
  String get messages_deleteConversationConfirm =>
      'Вы ўпэўнены, што хочаце выдаліць гэтую размову? Гэтае дзеянне нельга адмяніць.';

  @override
  String get messages_conversationDeleted => 'Размова выдалена';

  @override
  String get messages_startConversation => 'Пачніце размову!';

  @override
  String get profile_takePhoto => 'Зрабіць фота';

  @override
  String get profile_chooseFromGallery => 'Выбраць з галерэі';

  @override
  String get profile_avatarUpdated => 'Аватар паспяхова абноўлены';

  @override
  String get profile_profileUpdated => 'Профіль паспяхова абноўлены';

  @override
  String get profile_noProfileFound => 'Профіль не знойдзены';

  @override
  String get discovery_title => 'Пошук';

  @override
  String get discovery_searchUsers => 'Пошук карыстальнікаў...';

  @override
  String get discovery_discoverTab => 'Пошук';

  @override
  String get discovery_followingTab => 'Падпіскі';

  @override
  String get discovery_followersTab => 'Падпісчыкі';

  @override
  String get discovery_noUsersFound => 'Карыстальнікі не знойдзены';

  @override
  String get discovery_tryAdjustingFilters => 'Паспрабуйце змяніць фільтры';

  @override
  String get discovery_notFollowingAnyone => 'Не падпісаны ні на каго';

  @override
  String get discovery_discoverPeople => 'Знайдзіце людзей для падпіскі';

  @override
  String get discovery_noFollowersYet => 'Пакуль няма падпісчыкаў';

  @override
  String get discovery_shareInsights =>
      'Дзяліцеся інсайтамі, каб атрымаць падпісчыкаў';

  @override
  String get discovery_clearAll => 'Ачысціць усё';

  @override
  String chart_gate(int number) {
    return 'Вароты $number';
  }

  @override
  String chart_channel(String id) {
    return 'Канал $id';
  }

  @override
  String get chart_center => 'Цэнтр';

  @override
  String get chart_keynote => 'Ключавая нота';

  @override
  String get chart_element => 'Элемент';

  @override
  String get chart_location => 'Размяшчэнне';

  @override
  String get chart_hdCenters => 'Цэнтры HD';

  @override
  String get reaction_comment => 'Каментарый';

  @override
  String get reaction_react => 'Рэакцыя';

  @override
  String get reaction_standard => 'Стандартныя';

  @override
  String get reaction_humanDesign => 'Human Design';

  @override
  String get share_shareChart => 'Падзяліцца картай';

  @override
  String get share_createShareLink => 'Стварыць спасылку';

  @override
  String get share_shareViaUrl => 'Падзяліцца спасылкай';

  @override
  String get share_exportAsPng => 'Экспарт у PNG';

  @override
  String get share_fullReport => 'Поўная справаздача';

  @override
  String get share_linkExpiration => 'Тэрмін дзеяння спасылкі';

  @override
  String get share_neverExpires => 'Бестэрмінова';

  @override
  String get share_oneHour => '1 гадзіна';

  @override
  String get share_twentyFourHours => '24 гадзіны';

  @override
  String get share_sevenDays => '7 дзён';

  @override
  String get share_thirtyDays => '30 дзён';

  @override
  String get share_creating => 'Ствараем...';

  @override
  String get share_signInToShare => 'Увайдзіце, каб падзяліцца картай';

  @override
  String get share_createShareableLinks =>
      'Стварайце спасылкі на вашу карту Дызайну Чалавека';

  @override
  String get share_linkImage => 'Выява';

  @override
  String get share_pdf => 'PDF';

  @override
  String get post_share => 'Падзяліцца';

  @override
  String get post_edit => 'Рэдагаваць';

  @override
  String get post_report => 'Паскардзіцца';

  @override
  String get mentorship_title => 'Настаўніцтва';

  @override
  String get mentorship_pendingRequests => 'Чакаючыя запыты';

  @override
  String get mentorship_availableMentors => 'Даступныя настаўнікі';

  @override
  String get mentorship_noMentorsAvailable => 'Няма даступных настаўнікаў';

  @override
  String mentorship_requestMentorship(String name) {
    return 'Запытаць настаўніцтва ў $name';
  }

  @override
  String get mentorship_sendMessage => 'Напішыце, чаму хочаце навучыцца:';

  @override
  String get mentorship_learnPrompt => 'Я хацеў бы даведацца больш пра...';

  @override
  String get mentorship_requestSent => 'Запыт адпраўлены!';

  @override
  String get mentorship_sendRequest => 'Адправіць запыт';

  @override
  String get mentorship_becomeAMentor => 'Стаць настаўнікам';

  @override
  String get mentorship_shareKnowledge =>
      'Дзяліцеся ведамі пра Дызайн Чалавека';

  @override
  String get story_cancel => 'Адмяніць';

  @override
  String get story_createStory => 'Стварыць гісторыю';

  @override
  String get story_share => 'Падзяліцца';

  @override
  String get story_typeYourStory => 'Увядзіце вашу гісторыю...';

  @override
  String get story_background => 'Фон';

  @override
  String get story_attachTransitGate =>
      'Прымацаваць транзітныя вароты (неабавязкова)';

  @override
  String get story_none => 'Няма';

  @override
  String story_gateNumber(int number) {
    return 'Вароты $number';
  }

  @override
  String get story_whoCanSee => 'Хто можа бачыць?';

  @override
  String get story_followers => 'Падпісчыкі';

  @override
  String get story_everyone => 'Усе';

  @override
  String get challenges_title => 'Заданні';

  @override
  String get challenges_daily => 'Дзённыя';

  @override
  String get challenges_weekly => 'Тыднёвыя';

  @override
  String get challenges_monthly => 'Месячныя';

  @override
  String get challenges_noDailyChallenges => 'Няма дзённых заданняў';

  @override
  String get challenges_noWeeklyChallenges => 'Няма тыднёвых заданняў';

  @override
  String get challenges_noMonthlyChallenges => 'Няма месячных заданняў';

  @override
  String get challenges_errorLoading => 'Памылка загрузкі заданняў';

  @override
  String challenges_claimedPoints(int points) {
    return 'Атрымана $points балаў!';
  }

  @override
  String get challenges_totalPoints => 'Усяго балаў';

  @override
  String get challenges_level => 'Узровень';

  @override
  String get learning_all => 'Усе';

  @override
  String get learning_types => 'Тыпы';

  @override
  String get learning_gates => 'Вароты';

  @override
  String get learning_centers => 'Цэнтры';

  @override
  String get learning_liveSessions => 'Прамыя эфіры';

  @override
  String get quiz_noActiveSession => 'Няма актыўнай сесіі тэста';

  @override
  String get quiz_noQuestionsAvailable => 'Няма даступных пытанняў';

  @override
  String get quiz_ok => 'ОК';

  @override
  String get liveSessions_title => 'Прамыя эфіры';

  @override
  String get liveSessions_upcoming => 'Будучыя';

  @override
  String get liveSessions_mySessions => 'Мае сесіі';

  @override
  String get liveSessions_errorLoading => 'Памылка загрузкі сесій';

  @override
  String get liveSessions_registeredSuccessfully => 'Рэгістрацыя паспяховая!';

  @override
  String get liveSessions_cancelRegistration => 'Адмяніць рэгістрацыю';

  @override
  String get liveSessions_cancelRegistrationConfirm =>
      'Вы ўпэўнены, што хочаце адмяніць рэгістрацыю?';

  @override
  String get liveSessions_no => 'Не';

  @override
  String get liveSessions_yesCancel => 'Так, адмяніць';

  @override
  String get liveSessions_registrationCancelled => 'Рэгістрацыя адменена';

  @override
  String get gateChannelPicker_gates => 'Вароты (64)';

  @override
  String get gateChannelPicker_channels => 'Каналы (36)';

  @override
  String get gateChannelPicker_search => 'Пошук варот або каналаў...';

  @override
  String get leaderboard_weekly => 'Тыдзень';

  @override
  String get leaderboard_monthly => 'Месяц';

  @override
  String get leaderboard_allTime => 'Увесь час';

  @override
  String get ai_chatTitle => 'AI Асістэнт';

  @override
  String get ai_askAi => 'Спытаць AI';

  @override
  String get ai_askAboutChart => 'Спытаць AI пра вашу карту';

  @override
  String get ai_miniDescription =>
      'Атрымайце персанальныя інсайты пра ваш Дызайн Чалавека';

  @override
  String get ai_startChatting => 'Пачаць чат';

  @override
  String get ai_welcomeTitle => 'Ваш HD Асістэнт';

  @override
  String get ai_welcomeSubtitle =>
      'Задайце мне любое пытанне пра вашу карту Дызайну Чалавека. Я магу растлумачыць ваш тып, стратэгію, аўтарытэт, вароты, каналы і шмат іншага.';

  @override
  String get ai_inputPlaceholder => 'Спытайце пра вашу карту...';

  @override
  String get ai_newConversation => 'Новая размова';

  @override
  String get ai_conversations => 'Размовы';

  @override
  String get ai_noConversations => 'Размоў пакуль няма';

  @override
  String get ai_noConversationsMessage =>
      'Пачніце размову з AI, каб атрымаць персанальныя інсайты па карце.';

  @override
  String get ai_deleteConversation => 'Выдаліць размову';

  @override
  String get ai_deleteConversationConfirm =>
      'Вы ўпэўнены, што хочаце выдаліць гэтую размову?';

  @override
  String get ai_messagesExhausted => 'Бясплатныя паведамленні выкарыстаны';

  @override
  String get ai_upgradeForUnlimited =>
      'Абнавіцеся да Прэміум для бязлімітных AI размоў пра вашу карту Дызайну Чалавека.';

  @override
  String ai_usageCount(int used, int limit) {
    return '$used з $limit бясплатных паведамленняў выкарыстана';
  }

  @override
  String get ai_errorGeneric => 'Нешта пайшло не так. Паспрабуйце зноў.';

  @override
  String get ai_errorNetwork =>
      'Не ўдалося падключыцца да AI сэрвісу. Праверце злучэнне.';

  @override
  String get events_title => 'Мерапрыемствы супольнасці';

  @override
  String get events_upcoming => 'Будучыя';

  @override
  String get events_past => 'Мінулыя';

  @override
  String get events_create => 'Стварыць мерапрыемства';

  @override
  String get events_noUpcoming => 'Будучых мерапрыемстваў няма';

  @override
  String get events_noUpcomingMessage =>
      'Стварыце мерапрыемства, каб аб\'яднаць HD супольнасць!';

  @override
  String get events_online => 'Анлайн';

  @override
  String get events_inPerson => 'Ачна';

  @override
  String get events_hybrid => 'Гібрыд';

  @override
  String events_participants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count удзельнікаў',
      few: '$count удзельнікі',
      one: '1 удзельнік',
    );
    return '$_temp0';
  }

  @override
  String get events_register => 'Зарэгістравацца';

  @override
  String get events_registered => 'Зарэгістраваны';

  @override
  String get events_cancelRegistration => 'Адмяніць рэгістрацыю';

  @override
  String get events_registrationFull => 'Мерапрыемства запоўнена';

  @override
  String get events_eventTitle => 'Назва мерапрыемства';

  @override
  String get events_eventDescription => 'Апісанне';

  @override
  String get events_eventType => 'Тып мерапрыемства';

  @override
  String get events_startDate => 'Дата і час пачатку';

  @override
  String get events_endDate => 'Дата і час заканчэння';

  @override
  String get events_location => 'Месца правядзення';

  @override
  String get events_virtualLink => 'Спасылка на анлайн-сустрэчу';

  @override
  String get events_maxParticipants => 'Максімум удзельнікаў';

  @override
  String get events_hdTypeFilter => 'Фільтр па тыпу HD';

  @override
  String get events_allTypes => 'Для ўсіх тыпаў';

  @override
  String get events_created => 'Мерапрыемства створана!';

  @override
  String get events_deleted => 'Мерапрыемства выдалена';

  @override
  String get events_notFound => 'Мерапрыемства не знойдзена';

  @override
  String get chartOfDay_title => 'Карта дня';

  @override
  String get chartOfDay_featured => 'Рэкамендаваная карта';

  @override
  String get chartOfDay_viewChart => 'Прагледзець карту';

  @override
  String get discussion_typeDiscussion => 'Абмеркаванне тыпаў';

  @override
  String get discussion_channelDiscussion => 'Абмеркаванне каналаў';

  @override
  String get ai_wantMoreInsights => 'Жадаеце больш AI-інсайтаў?';

  @override
  String ai_messagesPackTitle(int count) {
    return '$count паведамленняў';
  }

  @override
  String get ai_orSubscribe => 'або падпішыцеся на бязлімітны доступ';

  @override
  String get ai_bestValue => 'Лепшая цана';

  @override
  String get ai_getMoreMessages => 'Атрымаць больш паведамленняў';

  @override
  String ai_fromPrice(String price) {
    return 'Ад $price';
  }

  @override
  String ai_perMessage(String price) {
    return '$price/паведамленне';
  }

  @override
  String get ai_transitInsightTitle => 'Транзітны інсайт дня';

  @override
  String get ai_transitInsightDesc =>
      'Атрымайце персанальную AI-інтэрпрэтацыю ўплыву сённяшніх транзітаў на вашу карту.';

  @override
  String get ai_chartReadingTitle => 'AI Чытанне карты';

  @override
  String get ai_chartReadingDesc =>
      'Стварыце падрабязнае AI-чытанне вашай карты Дызайну Чалавека.';

  @override
  String get ai_chartReadingCost =>
      'Гэта чытанне выкарыстоўвае 3 AI паведамленні з вашай квоты.';

  @override
  String get ai_compatibilityTitle => 'AI Чытанне сумяшчальнасці';

  @override
  String get ai_compatibilityReading => 'AI Аналіз сумяшчальнасці';

  @override
  String get ai_dreamJournalTitle => 'Дзённік сноў';

  @override
  String get ai_dreamEntryHint =>
      'Запісвайце сны, каб раскрыць схаваныя інсайты вашага дызайну...';

  @override
  String get ai_interpretDream => 'Інтэрпрэтаваць сон';

  @override
  String get ai_journalPromptsTitle => 'Тэмы для дзённіка';

  @override
  String get ai_journalPromptsDesc =>
      'Атрымайце персанальныя тэмы для дзённіка на аснове вашай карты і сённяшніх транзітаў.';

  @override
  String get ai_generating => 'Генерацыя...';

  @override
  String get ai_askFollowUp => 'Задаць удакладненне';

  @override
  String get ai_regenerate => 'Згенераваць нанова';

  @override
  String get ai_exportPdf => 'Экспарт у PDF';

  @override
  String get ai_shareReading => 'Падзяліцца чытаннем';
}
