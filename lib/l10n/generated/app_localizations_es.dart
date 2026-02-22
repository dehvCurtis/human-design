// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Inside Me';

  @override
  String get common_save => 'Guardar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_delete => 'Eliminar';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_done => 'Listo';

  @override
  String get common_next => 'Siguiente';

  @override
  String get common_back => 'Atrás';

  @override
  String get common_skip => 'Omitir';

  @override
  String get common_continue => 'Continuar';

  @override
  String get common_loading => 'Cargando...';

  @override
  String get common_error => 'Error';

  @override
  String get common_retry => 'Reintentar';

  @override
  String get common_close => 'Cerrar';

  @override
  String get common_search => 'Buscar';

  @override
  String get common_share => 'Compartir';

  @override
  String get common_settings => 'Configuración';

  @override
  String get common_logout => 'Cerrar Sesión';

  @override
  String get common_profile => 'Perfil';

  @override
  String get common_type => 'Tipo';

  @override
  String get common_strategy => 'Estrategia';

  @override
  String get common_authority => 'Autoridad';

  @override
  String get common_definition => 'Definición';

  @override
  String get common_create => 'Crear';

  @override
  String get common_viewFull => 'Ver Completo';

  @override
  String get common_send => 'Enviar';

  @override
  String get common_like => 'Me gusta';

  @override
  String get common_reply => 'Responder';

  @override
  String get common_deleteConfirmation =>
      '¿Estás seguro de que quieres eliminar esto? Esta acción no se puede deshacer.';

  @override
  String get common_comingSoon => '¡Próximamente!';

  @override
  String get nav_home => 'Inicio';

  @override
  String get nav_chart => 'Carta';

  @override
  String get nav_today => 'Diario';

  @override
  String get nav_social => 'Social';

  @override
  String get nav_profile => 'Perfil';

  @override
  String get nav_ai => 'IA';

  @override
  String get nav_more => 'Más';

  @override
  String get nav_learn => 'Aprender';

  @override
  String get affirmation_savedSuccess => '¡Afirmación guardada!';

  @override
  String get affirmation_alreadySaved => 'Afirmación ya guardada';

  @override
  String get home_goodMorning => 'Buenos días';

  @override
  String get home_goodAfternoon => 'Buenas tardes';

  @override
  String get home_goodEvening => 'Buenas noches';

  @override
  String get home_yourDesign => 'Tu Diseño';

  @override
  String get home_completeProfile => 'Completa Tu Perfil';

  @override
  String get home_enterBirthData => 'Ingresar Datos de Nacimiento';

  @override
  String get home_myChart => 'Mi Carta';

  @override
  String get home_savedCharts => 'Guardadas';

  @override
  String get home_composite => 'Compuesto';

  @override
  String get home_penta => 'Penta';

  @override
  String get home_friends => 'Amigos';

  @override
  String get home_myBodygraph => 'Mi Bodygraph';

  @override
  String get home_definedCenters => 'Centros Definidos';

  @override
  String get home_activeChannels => 'Canales Activos';

  @override
  String get home_activeGates => 'Puertas Activas';

  @override
  String get transit_today => 'Tránsitos de Hoy';

  @override
  String get transit_sun => 'Sol';

  @override
  String get transit_earth => 'Tierra';

  @override
  String get transit_moon => 'Luna';

  @override
  String transit_gate(int number) {
    return 'Puerta $number';
  }

  @override
  String transit_newChannelsActivated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nuevos canales activados',
      one: '1 nuevo canal activado',
    );
    return '$_temp0';
  }

  @override
  String transit_gatesHighlighted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puertas resaltadas',
      one: '1 puerta resaltada',
    );
    return '$_temp0';
  }

  @override
  String get transit_noConnections =>
      'No hay conexiones de tránsito directas hoy';

  @override
  String get auth_signIn => 'Iniciar Sesión';

  @override
  String get auth_signUp => 'Registrarse';

  @override
  String get auth_signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get auth_signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get auth_signInWithEmail => 'Iniciar sesión con Email';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Contraseña';

  @override
  String get auth_confirmPassword => 'Confirmar Contraseña';

  @override
  String get auth_forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get auth_noAccount => '¿No tienes una cuenta?';

  @override
  String get auth_hasAccount => '¿Ya tienes una cuenta?';

  @override
  String get auth_termsAgree =>
      'Al registrarte, aceptas nuestros Términos de Servicio y Política de Privacidad';

  @override
  String get auth_welcomeBack => 'Bienvenido de nuevo';

  @override
  String get auth_signInSubtitle =>
      'Inicia sesión para continuar tu viaje de Diseño Humano';

  @override
  String get auth_signInRequired => 'Inicio de Sesión Requerido';

  @override
  String get auth_signInToCalculateChart =>
      'Por favor inicia sesión para calcular y guardar tu carta de Diseño Humano.';

  @override
  String get auth_signInToCreateStory =>
      'Por favor inicia sesión para compartir historias con la comunidad.';

  @override
  String get auth_signUpSubtitle => 'Comienza tu viaje de Diseño Humano hoy';

  @override
  String get auth_signUpWithApple => 'Registrarse con Apple';

  @override
  String get auth_signUpWithGoogle => 'Registrarse con Google';

  @override
  String get auth_signUpWithMicrosoft => 'Registrarse con Microsoft';

  @override
  String get auth_signUpWithFacebook => 'Registrarse con Facebook';

  @override
  String get auth_signInWithMicrosoft => 'Iniciar sesión con Microsoft';

  @override
  String get auth_signInWithFacebook => 'Iniciar sesión con Facebook';

  @override
  String get auth_oauthTermsNotice =>
      'Al continuar, aceptas nuestros Términos de servicio y Política de privacidad.';

  @override
  String get auth_enterName => 'Ingresa tu nombre';

  @override
  String get auth_nameRequired => 'El nombre es obligatorio';

  @override
  String get auth_termsOfService => 'Términos de Servicio';

  @override
  String get auth_privacyPolicy => 'Política de Privacidad';

  @override
  String get auth_acceptTerms =>
      'Por favor acepta los Términos de Servicio para continuar';

  @override
  String get auth_resetPasswordTitle => 'Restablecer Contraseña';

  @override
  String get auth_resetPasswordPrompt =>
      'Ingresa tu dirección de email y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get auth_enterEmail => 'Ingresa tu email';

  @override
  String get auth_resetEmailSent =>
      '¡Email de restablecimiento de contraseña enviado!';

  @override
  String get auth_name => 'Nombre';

  @override
  String get auth_createAccount => 'Crear Cuenta';

  @override
  String get auth_iAgreeTo => 'Acepto los ';

  @override
  String get auth_and => ' y ';

  @override
  String get auth_birthInformation => 'Información de Nacimiento';

  @override
  String get auth_calculateMyChart => 'Calcular Mi Carta';

  @override
  String get onboarding_welcome => 'Bienvenido a Inside Me';

  @override
  String get onboarding_welcomeSubtitle => 'Descubre tu plano energético único';

  @override
  String get onboarding_birthData => 'Ingresa Tus Datos de Nacimiento';

  @override
  String get onboarding_birthDataSubtitle =>
      'Necesitamos esto para calcular tu carta';

  @override
  String get onboarding_birthDate => 'Fecha de Nacimiento';

  @override
  String get onboarding_birthTime => 'Hora de Nacimiento';

  @override
  String get onboarding_birthLocation => 'Lugar de Nacimiento';

  @override
  String get onboarding_searchLocation => 'Buscar una ciudad...';

  @override
  String get onboarding_unknownTime => 'No conozco mi hora de nacimiento';

  @override
  String get onboarding_timeImportance =>
      'Conocer tu hora exacta de nacimiento es importante para una carta precisa';

  @override
  String get onboarding_birthDataExplanation =>
      'Tus datos de nacimiento se utilizan para calcular tu carta única de Diseño Humano. Cuanto más precisa sea la información, más exacta será tu carta.';

  @override
  String get onboarding_noTimeWarning =>
      'Sin una hora de nacimiento precisa, algunos detalles de la carta (como tu signo ascendente y las líneas exactas de las puertas) pueden no ser precisos. Usaremos el mediodía como valor predeterminado.';

  @override
  String get onboarding_enterBirthTimeInstead =>
      'Ingresar hora de nacimiento en su lugar';

  @override
  String get onboarding_birthDataPrivacy =>
      'Tus datos de nacimiento están encriptados y almacenados de forma segura. Puedes actualizarlos o eliminarlos en cualquier momento desde la configuración de tu perfil.';

  @override
  String get onboarding_saveFailed => 'Error al guardar datos de nacimiento';

  @override
  String get onboarding_fillAllFields =>
      'Por favor completa todos los campos requeridos';

  @override
  String get onboarding_selectLanguage => 'Seleccionar Idioma';

  @override
  String get onboarding_getStarted => 'Comenzar';

  @override
  String get onboarding_alreadyHaveAccount => 'Ya tengo una cuenta';

  @override
  String get onboarding_liveInAlignment =>
      'Descubre tu plano energético único y vive en alineación con tu verdadera naturaleza.';

  @override
  String get chart_myChart => 'Mi Carta';

  @override
  String get chart_viewChart => 'Ver Carta';

  @override
  String get chart_calculate => 'Calcular Carta';

  @override
  String get chart_recalculate => 'Recalcular';

  @override
  String get chart_share => 'Compartir Carta';

  @override
  String get chart_createChart => 'Crear Carta';

  @override
  String get chart_composite => 'Carta Compuesta';

  @override
  String get chart_transit => 'Tránsitos de Hoy';

  @override
  String get chart_bodygraph => 'Bodygraph';

  @override
  String get chart_planets => 'Planetas';

  @override
  String get chart_details => 'Detalles de Carta';

  @override
  String get chart_properties => 'Propiedades';

  @override
  String get chart_gates => 'Puertas';

  @override
  String get chart_channels => 'Canales';

  @override
  String get chart_noChartYet => 'Aún No Hay Carta';

  @override
  String get chart_addBirthDataPrompt =>
      'Agrega tus datos de nacimiento para generar tu carta única de Diseño Humano.';

  @override
  String get chart_addBirthData => 'Agregar Datos de Nacimiento';

  @override
  String get chart_noActiveChannels => 'No Hay Canales Activos';

  @override
  String get chart_channelsFormedBothGates =>
      'Los canales se forman cuando ambas puertas están definidas.';

  @override
  String get chart_savedCharts => 'Cartas Guardadas';

  @override
  String get chart_addChart => 'Agregar Carta';

  @override
  String get chart_noSavedCharts => 'No Hay Cartas Guardadas';

  @override
  String get chart_noSavedChartsMessage =>
      'Crea cartas para ti y otros para guardarlas aquí.';

  @override
  String get chart_loadFailed => 'Error al cargar cartas';

  @override
  String get chart_renameChart => 'Renombrar Carta';

  @override
  String get chart_rename => 'Renombrar';

  @override
  String get chart_renameFailed => 'Error al renombrar carta';

  @override
  String get chart_deleteChart => 'Eliminar Carta';

  @override
  String chart_deleteConfirm(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get chart_deleteFailed => 'Error al eliminar carta';

  @override
  String get chart_you => 'Tú';

  @override
  String get chart_personName => 'Nombre';

  @override
  String get chart_enterPersonName => 'Ingresar nombre de la persona';

  @override
  String get chart_addChartDescription =>
      'Crea una carta para otra persona ingresando su información de nacimiento.';

  @override
  String get chart_calculateAndSave => 'Calcular y Guardar Carta';

  @override
  String get chart_saved => 'Carta guardada exitosamente';

  @override
  String get chart_consciousGates => 'Puertas Conscientes';

  @override
  String get chart_unconsciousGates => 'Puertas Inconscientes';

  @override
  String get chart_personalitySide =>
      'Lado de la Personalidad - de lo que eres consciente';

  @override
  String get chart_designSide => 'Lado del Diseño - lo que otros ven en ti';

  @override
  String get type_manifestor => 'Manifestador';

  @override
  String get type_generator => 'Generador';

  @override
  String get type_manifestingGenerator => 'Generador Manifestante';

  @override
  String get type_projector => 'Proyector';

  @override
  String get type_reflector => 'Reflector';

  @override
  String get type_manifestor_strategy => 'Informar';

  @override
  String get type_generator_strategy => 'Responder';

  @override
  String get type_manifestingGenerator_strategy => 'Responder';

  @override
  String get type_projector_strategy => 'Esperar la Invitación';

  @override
  String get type_reflector_strategy => 'Esperar un Ciclo Lunar';

  @override
  String get authority_emotional => 'Emocional';

  @override
  String get authority_sacral => 'Sacral';

  @override
  String get authority_splenic => 'Esplénica';

  @override
  String get authority_ego => 'Ego/Corazón';

  @override
  String get authority_self => 'Auto-Proyectada';

  @override
  String get authority_environment => 'Mental/Ambiental';

  @override
  String get authority_lunar => 'Lunar';

  @override
  String get definition_none => 'Sin Definición';

  @override
  String get definition_single => 'Definición Simple';

  @override
  String get definition_split => 'Definición Dividida';

  @override
  String get definition_tripleSplit => 'División Triple';

  @override
  String get definition_quadrupleSplit => 'División Cuádruple';

  @override
  String get profile_1_3 => '1/3 Investigador/Mártir';

  @override
  String get profile_1_4 => '1/4 Investigador/Oportunista';

  @override
  String get profile_2_4 => '2/4 Ermitaño/Oportunista';

  @override
  String get profile_2_5 => '2/5 Ermitaño/Hereje';

  @override
  String get profile_3_5 => '3/5 Mártir/Hereje';

  @override
  String get profile_3_6 => '3/6 Mártir/Modelo a Seguir';

  @override
  String get profile_4_6 => '4/6 Oportunista/Modelo a Seguir';

  @override
  String get profile_4_1 => '4/1 Oportunista/Investigador';

  @override
  String get profile_5_1 => '5/1 Hereje/Investigador';

  @override
  String get profile_5_2 => '5/2 Hereje/Ermitaño';

  @override
  String get profile_6_2 => '6/2 Modelo a Seguir/Ermitaño';

  @override
  String get profile_6_3 => '6/3 Modelo a Seguir/Mártir';

  @override
  String get center_head => 'Cabeza';

  @override
  String get center_ajna => 'Ajna';

  @override
  String get center_throat => 'Garganta';

  @override
  String get center_g => 'G/Yo';

  @override
  String get center_heart => 'Corazón/Ego';

  @override
  String get center_sacral => 'Sacral';

  @override
  String get center_solarPlexus => 'Plexo Solar';

  @override
  String get center_spleen => 'Bazo';

  @override
  String get center_root => 'Raíz';

  @override
  String get center_defined => 'Definido';

  @override
  String get center_undefined => 'Indefinido';

  @override
  String get section_type => 'Tipo';

  @override
  String get section_strategy => 'Estrategia';

  @override
  String get section_authority => 'Autoridad';

  @override
  String get section_profile => 'Perfil';

  @override
  String get section_definition => 'Definición';

  @override
  String get section_centers => 'Centros';

  @override
  String get section_channels => 'Canales';

  @override
  String get section_gates => 'Puertas';

  @override
  String get section_conscious => 'Consciente (Personalidad)';

  @override
  String get section_unconscious => 'Inconsciente (Diseño)';

  @override
  String get social_title => 'Social';

  @override
  String get social_thoughts => 'Pensamientos';

  @override
  String get social_discover => 'Descubrir';

  @override
  String get social_groups => 'Grupos';

  @override
  String get social_invite => 'Invitar';

  @override
  String get social_createPost => 'Comparte un pensamiento...';

  @override
  String get social_noThoughtsYet => 'Aún no hay pensamientos';

  @override
  String get social_noThoughtsMessage =>
      '¡Sé el primero en compartir tus conocimientos de Diseño Humano!';

  @override
  String get social_createGroup => 'Crear Grupo';

  @override
  String get social_members => 'Miembros';

  @override
  String get social_comments => 'Comentarios';

  @override
  String get social_addComment => 'Agregar un comentario...';

  @override
  String get social_noComments => 'Aún no hay comentarios';

  @override
  String social_shareLimit(int remaining) {
    return 'Te quedan $remaining compartidos este mes';
  }

  @override
  String get social_visibility => 'Visibilidad';

  @override
  String get social_private => 'Privado';

  @override
  String get social_friendsOnly => 'Solo Amigos';

  @override
  String get social_public => 'Público';

  @override
  String get social_shared => 'Compartido';

  @override
  String get social_noGroupsYet => 'Aún No Hay Grupos';

  @override
  String get social_noGroupsMessage =>
      'Crea grupos para analizar la dinámica del equipo con análisis Penta.';

  @override
  String get social_noSharedCharts => 'No Hay Cartas Compartidas';

  @override
  String get social_noSharedChartsMessage =>
      'Las cartas compartidas contigo aparecerán aquí.';

  @override
  String get social_createGroupPrompt =>
      'Crea un grupo para analizar la dinámica del equipo.';

  @override
  String get social_groupName => 'Nombre del Grupo';

  @override
  String get social_groupNameHint => 'Familia, Equipo, etc.';

  @override
  String get social_groupDescription => 'Descripción (opcional)';

  @override
  String get social_groupDescriptionHint => '¿Para qué es este grupo?';

  @override
  String social_groupCreated(String name) {
    return '¡Grupo \"$name\" creado!';
  }

  @override
  String get social_groupNameRequired => 'Por favor ingresa un nombre de grupo';

  @override
  String get social_createGroupFailed =>
      'Error al crear grupo. Por favor intenta de nuevo.';

  @override
  String get social_noDescription => 'Sin descripción';

  @override
  String get social_admin => 'Administrador';

  @override
  String social_sharedBy(String name) {
    return 'Compartido por $name';
  }

  @override
  String get social_loadGroupsFailed => 'Error al cargar grupos';

  @override
  String get social_loadSharedFailed => 'Error al cargar cartas compartidas';

  @override
  String get social_userNotFound => 'Usuario no encontrado';

  @override
  String get discovery_userNotFound => 'Usuario no encontrado';

  @override
  String get discovery_following => 'Siguiendo';

  @override
  String get discovery_follow => 'Seguir';

  @override
  String get discovery_sendMessage => 'Enviar Mensaje';

  @override
  String get discovery_about => 'Acerca de';

  @override
  String get discovery_humanDesign => 'Diseño Humano';

  @override
  String get discovery_type => 'Tipo';

  @override
  String get discovery_profile => 'Perfil';

  @override
  String get discovery_authority => 'Autoridad';

  @override
  String get discovery_compatibility => 'Compatibilidad';

  @override
  String get discovery_compatible => 'compatible';

  @override
  String get discovery_followers => 'Seguidores';

  @override
  String get discovery_followingLabel => 'Siguiendo';

  @override
  String get discovery_noResults => 'No se encontraron usuarios';

  @override
  String get discovery_noResultsMessage =>
      'Intenta ajustar tus filtros o vuelve más tarde';

  @override
  String get userProfile_viewChart => 'Bodygraph';

  @override
  String get userProfile_chartPrivate => 'Esta carta es privada';

  @override
  String get userProfile_chartFriendsOnly =>
      'Conviértanse en seguidores mutuos para ver esta carta';

  @override
  String get userProfile_chartFollowToView => 'Sigue para ver esta carta';

  @override
  String get userProfile_publicProfile => 'Perfil Público';

  @override
  String get userProfile_privateProfile => 'Perfil Privado';

  @override
  String get userProfile_friendsOnlyProfile => 'Solo Amigos';

  @override
  String get userProfile_followersList => 'Seguidores';

  @override
  String get userProfile_followingList => 'Siguiendo';

  @override
  String get userProfile_noFollowers => 'Aún no hay seguidores';

  @override
  String get userProfile_noFollowing => 'Aún no sigue a nadie';

  @override
  String get userProfile_thoughts => 'Pensamientos';

  @override
  String get userProfile_noThoughts => 'Aún no ha compartido pensamientos';

  @override
  String get userProfile_showAll => 'Mostrar Todo';

  @override
  String get popularCharts_title => 'Cartas Populares';

  @override
  String get popularCharts_subtitle => 'Cartas públicas más seguidas';

  @override
  String time_minutesAgo(int minutes) {
    return 'hace ${minutes}m';
  }

  @override
  String time_hoursAgo(int hours) {
    return 'hace ${hours}h';
  }

  @override
  String time_daysAgo(int days) {
    return 'hace ${days}d';
  }

  @override
  String get transit_title => 'Tránsitos de Hoy';

  @override
  String get transit_currentEnergies => 'Energías Actuales';

  @override
  String get transit_sunGate => 'Puerta del Sol';

  @override
  String get transit_earthGate => 'Puerta de la Tierra';

  @override
  String get transit_moonGate => 'Puerta de la Luna';

  @override
  String get transit_activeGates => 'Puertas de Tránsito Activas';

  @override
  String get transit_activeChannels => 'Canales de Tránsito Activos';

  @override
  String get transit_personalImpact => 'Impacto Personal';

  @override
  String transit_gateActivated(int gate) {
    return 'Puerta $gate activada por tránsito';
  }

  @override
  String transit_channelFormed(String channel) {
    return 'Canal $channel formado con tu carta';
  }

  @override
  String get transit_noPersonalImpact =>
      'No hay conexiones de tránsito directas hoy';

  @override
  String get transit_viewFullTransit => 'Ver Carta de Tránsito Completa';

  @override
  String get affirmation_title => 'Afirmación Diaria';

  @override
  String affirmation_forYourType(String type) {
    return 'Para Tu $type';
  }

  @override
  String affirmation_basedOnGate(int gate) {
    return 'Basada en Puerta $gate';
  }

  @override
  String get affirmation_refresh => 'Nueva Afirmación';

  @override
  String get affirmation_save => 'Guardar Afirmación';

  @override
  String get affirmation_saved => 'Afirmaciones Guardadas';

  @override
  String get affirmation_share => 'Compartir Afirmación';

  @override
  String get affirmation_notifications => 'Notificaciones de Afirmación Diaria';

  @override
  String get affirmation_notificationTime => 'Hora de Notificación';

  @override
  String get lifestyle_today => 'Hoy';

  @override
  String get lifestyle_insights => 'Percepciones';

  @override
  String get lifestyle_journal => 'Diario';

  @override
  String get lifestyle_addJournalEntry => 'Agregar Entrada de Diario';

  @override
  String get lifestyle_journalPrompt =>
      '¿Cómo estás experimentando tu diseño hoy?';

  @override
  String get lifestyle_noJournalEntries => 'Aún no hay entradas de diario';

  @override
  String get lifestyle_mood => 'Estado de Ánimo';

  @override
  String get lifestyle_energy => 'Nivel de Energía';

  @override
  String get lifestyle_reflection => 'Reflexión';

  @override
  String get penta_title => 'Penta';

  @override
  String get penta_description => 'Análisis de grupo para 3-5 personas';

  @override
  String get penta_createNew => 'Crear Penta';

  @override
  String get penta_selectMembers => 'Seleccionar Miembros';

  @override
  String get penta_minMembers => 'Se requieren mínimo 3 miembros';

  @override
  String get penta_maxMembers => 'Máximo 5 miembros';

  @override
  String get penta_groupDynamics => 'Dinámica de Grupo';

  @override
  String get penta_missingRoles => 'Roles Faltantes';

  @override
  String get penta_strengths => 'Fortalezas del Grupo';

  @override
  String get penta_analysis => 'Análisis Penta';

  @override
  String get penta_clearAnalysis => 'Limpiar Análisis';

  @override
  String get penta_infoText =>
      'El análisis Penta revela los roles naturales que emergen en grupos pequeños de 3-5 personas, mostrando cómo cada miembro contribuye a la dinámica del equipo.';

  @override
  String get penta_calculating => 'Calculando...';

  @override
  String get penta_calculate => 'Calcular Penta';

  @override
  String get penta_groupRoles => 'Roles de Grupo';

  @override
  String get penta_electromagneticConnections => 'Conexiones Electromagnéticas';

  @override
  String get penta_connectionsDescription =>
      'Conexiones energéticas especiales entre miembros que crean atracción y química.';

  @override
  String get penta_areasForAttention => 'Áreas de Atención';

  @override
  String get composite_title => 'Carta Compuesta';

  @override
  String get composite_infoText =>
      'Una carta compuesta muestra la dinámica de relación entre dos personas, revelando cómo tus cartas interactúan y se complementan.';

  @override
  String get composite_selectTwoCharts => 'Seleccionar 2 Cartas';

  @override
  String get composite_calculate => 'Analizar Conexión';

  @override
  String get composite_calculating => 'Analizando...';

  @override
  String get composite_clearAnalysis => 'Limpiar Análisis';

  @override
  String get composite_connectionTheme => 'Tema de Conexión';

  @override
  String get composite_definedCenters => 'Definidos';

  @override
  String get composite_undefinedCenters => 'Abiertos';

  @override
  String get composite_score => 'Puntuación';

  @override
  String get composite_themeVeryBonded =>
      'Conexión muy unida - pueden sentirse profundamente entrelazados, lo cual puede ser intenso';

  @override
  String get composite_themeBonded =>
      'Conexión unida - fuerte sentido de unión y energía compartida';

  @override
  String get composite_themeBalanced =>
      'Conexión equilibrada - mezcla saludable de unión e independencia';

  @override
  String get composite_themeIndependent =>
      'Conexión independiente - más espacio para crecimiento individual';

  @override
  String get composite_themeVeryIndependent =>
      'Conexión muy independiente - tiempo de conexión intencional ayuda a fortalecer el vínculo';

  @override
  String get composite_electromagnetic => 'Canales Electromagnéticos';

  @override
  String get composite_electromagneticDesc =>
      'Atracción intensa - se completan mutuamente';

  @override
  String get composite_companionship => 'Canales de Compañía';

  @override
  String get composite_companionshipDesc =>
      'Comodidad y estabilidad - entendimiento compartido';

  @override
  String get composite_dominance => 'Canales de Dominancia';

  @override
  String get composite_dominanceDesc => 'Uno enseña/condiciona al otro';

  @override
  String get composite_compromise => 'Canales de Compromiso';

  @override
  String get composite_compromiseDesc =>
      'Tensión natural - requiere conciencia';

  @override
  String get composite_noConnections => 'Sin Conexiones de Canal';

  @override
  String get composite_noConnectionsDesc =>
      'Estas cartas no forman conexiones directas de canal, pero aún puede haber interacciones de puertas interesantes.';

  @override
  String get composite_noChartsTitle => 'No Hay Cartas Disponibles';

  @override
  String get composite_noChartsDesc =>
      'Crea cartas para ti y otros para comparar tus dinámicas de relación.';

  @override
  String get composite_needMoreCharts => 'Se Necesitan Más Cartas';

  @override
  String get composite_needMoreChartsDesc =>
      'Necesitas al menos 2 cartas para analizar una relación. Agrega otra carta para continuar.';

  @override
  String get composite_selectTwoHint =>
      'Selecciona 2 cartas para analizar su conexión';

  @override
  String get composite_selectOneMore => 'Selecciona 1 carta más';

  @override
  String get premium_upgrade => 'Mejorar a Premium';

  @override
  String get premium_subscribe => 'Suscribirse';

  @override
  String get premium_restore => 'Restaurar Compras';

  @override
  String get premium_features => 'Características Premium';

  @override
  String get premium_unlimitedShares => 'Compartir Cartas Ilimitado';

  @override
  String get premium_groupCharts => 'Cartas de Grupo';

  @override
  String get premium_advancedTransits => 'Análisis Avanzado de Tránsitos';

  @override
  String get premium_personalizedAffirmations => 'Afirmaciones Personalizadas';

  @override
  String get premium_journalInsights => 'Percepciones de Diario';

  @override
  String get premium_adFree => 'Experiencia Sin Anuncios';

  @override
  String get premium_monthly => 'Mensual';

  @override
  String get premium_yearly => 'Anual';

  @override
  String get premium_perMonth => '/mes';

  @override
  String get premium_perYear => '/año';

  @override
  String get premium_bestValue => 'Mejor Valor';

  @override
  String get settings_appearance => 'Apariencia';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_selectLanguage => 'Seleccionar Idioma';

  @override
  String get settings_changeLanguage => 'Cambiar Idioma';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_selectTheme => 'Seleccionar Tema';

  @override
  String get settings_chartDisplay => 'Visualización de Carta';

  @override
  String get settings_showGateNumbers => 'Mostrar Números de Puertas';

  @override
  String get settings_showGateNumbersSubtitle =>
      'Mostrar números de puertas en el bodygraph';

  @override
  String get settings_use24HourTime => 'Usar Formato de 24 Horas';

  @override
  String get settings_use24HourTimeSubtitle =>
      'Mostrar hora en formato de 24 horas';

  @override
  String get settings_feedback => 'Retroalimentación';

  @override
  String get settings_hapticFeedback => 'Retroalimentación Háptica';

  @override
  String get settings_hapticFeedbackSubtitle => 'Vibración en interacciones';

  @override
  String get settings_account => 'Cuenta';

  @override
  String get settings_changePassword => 'Cambiar Contraseña';

  @override
  String get settings_deleteAccount => 'Eliminar Cuenta';

  @override
  String get settings_deleteAccountConfirm =>
      '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer y todos tus datos serán eliminados permanentemente.';

  @override
  String get settings_appVersion => 'Versión de la Aplicación';

  @override
  String get settings_rateApp => 'Calificar la Aplicación';

  @override
  String get settings_sendFeedback => 'Enviar Retroalimentación';

  @override
  String get settings_telegramSupport => 'Soporte en Telegram';

  @override
  String get settings_telegramSupportSubtitle =>
      'Obtén ayuda en nuestro grupo de Telegram';

  @override
  String get settings_themeLight => 'Claro';

  @override
  String get settings_themeDark => 'Oscuro';

  @override
  String get settings_themeSystem => 'Sistema';

  @override
  String get settings_notifications => 'Notificaciones';

  @override
  String get settings_privacy => 'Privacidad';

  @override
  String get settings_chartVisibility => 'Visibilidad de Carta';

  @override
  String get settings_chartVisibilitySubtitle =>
      'Controla quién puede ver tu carta de Diseño Humano';

  @override
  String get settings_chartPrivate => 'Privada';

  @override
  String get settings_chartPrivateDesc => 'Solo tú puedes ver tu carta';

  @override
  String get settings_chartFriends => 'Amigos';

  @override
  String get settings_chartFriendsDesc =>
      'Los seguidores mutuos pueden ver tu carta';

  @override
  String get settings_chartPublic => 'Pública';

  @override
  String get settings_chartPublicDesc => 'Tus seguidores pueden ver tu carta';

  @override
  String get settings_about => 'Acerca de';

  @override
  String get settings_help => 'Ayuda y Soporte';

  @override
  String get settings_terms => 'Términos de Servicio';

  @override
  String get settings_privacyPolicy => 'Política de Privacidad';

  @override
  String get settings_version => 'Versión';

  @override
  String get settings_dailyTransits => 'Tránsitos Diarios';

  @override
  String get settings_dailyTransitsSubtitle =>
      'Recibir actualizaciones diarias de tránsitos';

  @override
  String get settings_gateChanges => 'Cambios de Puertas';

  @override
  String get settings_gateChangesSubtitle =>
      'Notificar cuando el Sol cambie de puertas';

  @override
  String get settings_socialActivity => 'Actividad Social';

  @override
  String get settings_socialActivitySubtitle =>
      'Solicitudes de amistad y cartas compartidas';

  @override
  String get settings_achievements => 'Logros';

  @override
  String get settings_achievementsSubtitle => 'Desbloqueo de medallas y hitos';

  @override
  String get settings_deleteAccountWarning =>
      'Esto eliminará permanentemente todos tus datos incluyendo cartas, publicaciones y mensajes.';

  @override
  String get settings_deleteAccountFailed =>
      'Error al eliminar cuenta. Por favor intenta de nuevo.';

  @override
  String get settings_passwordChanged => 'Contraseña cambiada exitosamente';

  @override
  String get settings_passwordChangeFailed =>
      'Error al cambiar contraseña. Por favor intenta de nuevo.';

  @override
  String get settings_feedbackSubject =>
      'Retroalimentación de la Aplicación Inside Me';

  @override
  String get settings_feedbackBody =>
      'Hola,\n\nMe gustaría compartir la siguiente retroalimentación sobre Inside Me:\n\n';

  @override
  String get auth_newPassword => 'Nueva Contraseña';

  @override
  String get auth_passwordRequired => 'La contraseña es obligatoria';

  @override
  String get auth_passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get auth_passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get settings_exportData => 'Exportar Mis Datos';

  @override
  String get settings_exportDataSubtitle =>
      'Descargar una copia de todos tus datos (RGPD)';

  @override
  String get settings_exportingData => 'Preparando tu exportación de datos...';

  @override
  String get settings_exportDataSubject =>
      'Inside Me - Exportación de Mis Datos';

  @override
  String get settings_exportDataFailed =>
      'Error al exportar datos. Por favor intenta de nuevo.';

  @override
  String get error_generic => 'Algo salió mal';

  @override
  String get error_network => 'Sin conexión a internet';

  @override
  String get error_invalidEmail => 'Por favor ingresa un email válido';

  @override
  String get error_invalidPassword =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get error_passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get error_birthDataRequired =>
      'Por favor ingresa tus datos de nacimiento';

  @override
  String get error_locationRequired =>
      'Por favor selecciona tu lugar de nacimiento';

  @override
  String get error_chartCalculation => 'No se pudo calcular tu carta';

  @override
  String get profile_editProfile => 'Editar Perfil';

  @override
  String get profile_shareChart => 'Compartir Mi Carta';

  @override
  String get profile_exportPdf => 'Exportar Carta PDF';

  @override
  String get profile_upgradePremium => 'Mejorar a Premium';

  @override
  String get profile_birthData => 'Datos de Nacimiento';

  @override
  String get profile_chartSummary => 'Resumen de Carta';

  @override
  String get profile_viewFullChart => 'Ver Carta Completa';

  @override
  String get profile_signOut => 'Cerrar Sesión';

  @override
  String get profile_signOutConfirm =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get profile_addBirthDataPrompt =>
      'Agrega tus datos de nacimiento para generar tu carta de Diseño Humano.';

  @override
  String get profile_addBirthDataToShare =>
      'Agrega datos de nacimiento para compartir tu carta';

  @override
  String get profile_addBirthDataToExport =>
      'Agrega datos de nacimiento para exportar tu carta';

  @override
  String get profile_exportFailed => 'Error al exportar PDF';

  @override
  String get profile_signOutConfirmTitle => 'Cerrar Sesión';

  @override
  String get profile_loadFailed => 'Error al cargar perfil';

  @override
  String get profile_defaultUserName => 'Usuario de Inside Me';

  @override
  String get profile_birthDate => 'Fecha';

  @override
  String get profile_birthTime => 'Hora';

  @override
  String get profile_birthLocation => 'Ubicación';

  @override
  String get profile_birthTimezone => 'Zona Horaria';

  @override
  String get chart_chakras => 'Chakras';

  @override
  String get chakra_title => 'Energía de Chakras';

  @override
  String get chakra_activated => 'Activado';

  @override
  String get chakra_inactive => 'Inactivo';

  @override
  String chakra_activatedCount(int count) {
    return '$count de 7 chakras activados';
  }

  @override
  String get chakra_hdMapping => 'Mapeo del Centro DH';

  @override
  String get chakra_element => 'Elemento';

  @override
  String get chakra_location => 'Ubicación';

  @override
  String get chakra_root => 'Raíz';

  @override
  String get chakra_root_sanskrit => 'Muladhara';

  @override
  String get chakra_root_description =>
      'Fundamento, supervivencia y estabilidad';

  @override
  String get chakra_sacral => 'Sacral';

  @override
  String get chakra_sacral_sanskrit => 'Svadhisthana';

  @override
  String get chakra_sacral_description => 'Creatividad, sexualidad y emociones';

  @override
  String get chakra_solarPlexus => 'Plexo Solar';

  @override
  String get chakra_solarPlexus_sanskrit => 'Manipura';

  @override
  String get chakra_solarPlexus_description =>
      'Poder personal, confianza y voluntad';

  @override
  String get chakra_heart => 'Corazón';

  @override
  String get chakra_heart_sanskrit => 'Anahata';

  @override
  String get chakra_heart_description => 'Amor, compasión y conexión';

  @override
  String get chakra_throat => 'Garganta';

  @override
  String get chakra_throat_sanskrit => 'Vishuddha';

  @override
  String get chakra_throat_description => 'Comunicación, expresión y verdad';

  @override
  String get chakra_thirdEye => 'Tercer Ojo';

  @override
  String get chakra_thirdEye_sanskrit => 'Ajna';

  @override
  String get chakra_thirdEye_description =>
      'Intuición, percepción e imaginación';

  @override
  String get chakra_crown => 'Corona';

  @override
  String get chakra_crown_sanskrit => 'Sahasrara';

  @override
  String get chakra_crown_description => 'Conexión espiritual y consciencia';

  @override
  String get quiz_title => 'Cuestionarios';

  @override
  String get quiz_yourProgress => 'Tu Progreso';

  @override
  String quiz_quizzesCompleted(int count) {
    return '$count cuestionarios completados';
  }

  @override
  String get quiz_accuracy => 'Precisión';

  @override
  String get quiz_streak => 'Racha';

  @override
  String get quiz_all => 'Todos';

  @override
  String get quiz_difficulty => 'Dificultad';

  @override
  String get quiz_beginner => 'Principiante';

  @override
  String get quiz_intermediate => 'Intermedio';

  @override
  String get quiz_advanced => 'Avanzado';

  @override
  String quiz_questions(int count) {
    return '$count preguntas';
  }

  @override
  String quiz_points(int points) {
    return '+$points pts';
  }

  @override
  String get quiz_completed => 'Completado';

  @override
  String get quiz_noQuizzes => 'No hay cuestionarios disponibles';

  @override
  String get quiz_checkBackLater => 'Vuelve más tarde para nuevo contenido';

  @override
  String get quiz_startQuiz => 'Iniciar Cuestionario';

  @override
  String get quiz_tryAgain => 'Intentar de Nuevo';

  @override
  String get quiz_backToQuizzes => 'Volver a Cuestionarios';

  @override
  String get quiz_shareResults => 'Compartir Resultados';

  @override
  String get quiz_yourBest => 'Tu Mejor';

  @override
  String get quiz_perfectScore => '¡Puntuación Perfecta!';

  @override
  String get quiz_newBest => '¡Nuevo Mejor!';

  @override
  String get quiz_streakExtended => '¡Racha Extendida!';

  @override
  String quiz_questionOf(int current, int total) {
    return 'Pregunta $current de $total';
  }

  @override
  String quiz_correct(int count) {
    return '$count correctas';
  }

  @override
  String get quiz_submitAnswer => 'Enviar Respuesta';

  @override
  String get quiz_nextQuestion => 'Siguiente Pregunta';

  @override
  String get quiz_seeResults => 'Ver Resultados';

  @override
  String get quiz_exitQuiz => '¿Salir del Cuestionario?';

  @override
  String get quiz_exitWarning => 'Tu progreso se perderá si sales ahora.';

  @override
  String get quiz_exit => 'Salir';

  @override
  String get quiz_timesUp => '¡Se Acabó el Tiempo!';

  @override
  String get quiz_timesUpMessage =>
      'Se te acabó el tiempo. Tu progreso será enviado.';

  @override
  String get quiz_excellent => '¡Excelente!';

  @override
  String get quiz_goodJob => '¡Buen Trabajo!';

  @override
  String get quiz_keepLearning => '¡Sigue Aprendiendo!';

  @override
  String get quiz_keepPracticing => '¡Sigue Practicando!';

  @override
  String get quiz_masteredTopic => '¡Has dominado este tema!';

  @override
  String get quiz_strongUnderstanding => 'Tienes un entendimiento sólido.';

  @override
  String get quiz_onRightTrack => 'Estás en el camino correcto.';

  @override
  String get quiz_reviewExplanations =>
      'Revisa las explicaciones para mejorar.';

  @override
  String get quiz_studyMaterial => 'Estudia el material e intenta de nuevo.';

  @override
  String get quiz_attemptHistory => 'Historial de Intentos';

  @override
  String get quiz_statistics => 'Estadísticas de Cuestionarios';

  @override
  String get quiz_totalQuizzes => 'Cuestionarios';

  @override
  String get quiz_totalQuestions => 'Preguntas';

  @override
  String get quiz_bestStreak => 'Mejor Racha';

  @override
  String quiz_strongest(String category) {
    return 'Más fuerte: $category';
  }

  @override
  String quiz_needsWork(String category) {
    return 'Necesita trabajo: $category';
  }

  @override
  String get quiz_category_types => 'Tipos';

  @override
  String get quiz_category_centers => 'Centros';

  @override
  String get quiz_category_authorities => 'Autoridades';

  @override
  String get quiz_category_profiles => 'Perfiles';

  @override
  String get quiz_category_gates => 'Puertas';

  @override
  String get quiz_category_channels => 'Canales';

  @override
  String get quiz_category_definitions => 'Definiciones';

  @override
  String get quiz_category_general => 'General';

  @override
  String get quiz_explanation => 'Explicación';

  @override
  String get quiz_quizzes => 'Cuestionarios';

  @override
  String get quiz_questionsLabel => 'Preguntas';

  @override
  String get quiz_shareProgress => 'Compartir Progreso';

  @override
  String get quiz_shareProgressSubject =>
      'Mi Progreso de Aprendizaje de Diseño Humano';

  @override
  String get quiz_sharePerfect =>
      '¡Logré una puntuación perfecta! Estoy dominando el Diseño Humano.';

  @override
  String get quiz_shareExcellent =>
      '¡Me va muy bien en mi viaje de aprendizaje de Diseño Humano!';

  @override
  String get quiz_shareGoodJob =>
      'Estoy aprendiendo sobre Diseño Humano. ¡Cada cuestionario me ayuda a crecer!';

  @override
  String quiz_shareSubject(String quizTitle, int score) {
    return 'Obtuve $score% en \"$quizTitle\" - Cuestionario de Diseño Humano';
  }

  @override
  String get quiz_failedToLoadStats => 'Error al cargar estadísticas';

  @override
  String get planetary_personality => 'Personalidad';

  @override
  String get planetary_design => 'Diseño';

  @override
  String get planetary_consciousBirth => 'Consciente · Nacimiento';

  @override
  String get planetary_unconsciousPrenatal => 'Inconsciente · 88° Prenatal';

  @override
  String get gamification_yourProgress => 'Tu Progreso';

  @override
  String get gamification_level => 'Nivel';

  @override
  String get gamification_points => 'pts';

  @override
  String get gamification_viewAll => 'Ver Todo';

  @override
  String get gamification_allChallengesComplete =>
      '¡Todos los desafíos diarios completos!';

  @override
  String get gamification_dailyChallenge => 'Desafío Diario';

  @override
  String get gamification_achievements => 'Logros';

  @override
  String get gamification_challenges => 'Desafíos';

  @override
  String get gamification_leaderboard => 'Tabla de Clasificación';

  @override
  String get gamification_streak => 'Racha';

  @override
  String get gamification_badges => 'Medallas';

  @override
  String get gamification_earnedBadge => '¡Ganaste una medalla!';

  @override
  String get gamification_claimReward => 'Reclamar Recompensa';

  @override
  String get gamification_completed => 'Completado';

  @override
  String get common_copy => 'Copiar';

  @override
  String get share_myShares => 'Mis Compartidos';

  @override
  String get share_createNew => 'Crear Nuevo';

  @override
  String get share_newLink => 'Nuevo Enlace';

  @override
  String get share_noShares => 'Sin Enlaces Compartidos';

  @override
  String get share_noSharesMessage =>
      'Crea enlaces para compartir y permitir que otros vean tu carta sin necesidad de una cuenta.';

  @override
  String get share_createFirst => 'Crea Tu Primer Enlace';

  @override
  String share_activeLinks(int count) {
    return '$count Enlaces Activos';
  }

  @override
  String share_expiredLinks(int count) {
    return '$count Expirados';
  }

  @override
  String get share_clearExpired => 'Limpiar';

  @override
  String get share_clearExpiredTitle => 'Limpiar Enlaces Expirados';

  @override
  String share_clearExpiredMessage(int count) {
    return 'Esto eliminará $count enlaces expirados de tu historial.';
  }

  @override
  String get share_clearAll => 'Limpiar Todo';

  @override
  String get share_expiredCleared => 'Enlaces expirados eliminados';

  @override
  String get share_linkCopied => 'Enlace copiado al portapapeles';

  @override
  String get share_revokeTitle => 'Revocar Enlace';

  @override
  String get share_revokeMessage =>
      'Esto deshabilitará permanentemente este enlace compartido. Cualquiera con el enlace ya no podrá ver tu carta.';

  @override
  String get share_revoke => 'Revocar';

  @override
  String get share_linkRevoked => 'Enlace revocado';

  @override
  String get share_totalLinks => 'Total';

  @override
  String get share_active => 'Activo';

  @override
  String get share_totalViews => 'Visualizaciones';

  @override
  String get share_chartLink => 'Compartir Carta';

  @override
  String get share_transitLink => 'Compartir Tránsito';

  @override
  String get share_compatibilityLink => 'Informe de Compatibilidad';

  @override
  String get share_link => 'Compartir Enlace';

  @override
  String share_views(int count) {
    return '$count visualizaciones';
  }

  @override
  String get share_expired => 'Expirado';

  @override
  String get share_activeLabel => 'Activo';

  @override
  String share_expiredOn(String date) {
    return 'Expiró $date';
  }

  @override
  String share_expiresIn(String time) {
    return 'Expira en $time';
  }

  @override
  String get auth_emailNotConfirmed => 'Por favor confirma tu email';

  @override
  String get auth_resendConfirmation => 'Reenviar Email de Confirmación';

  @override
  String get auth_confirmationSent => 'Email de confirmación enviado';

  @override
  String get auth_checkEmail =>
      'Revisa tu email para el enlace de confirmación';

  @override
  String get auth_checkYourEmail => 'Revisa Tu Email';

  @override
  String get auth_confirmationLinkSent =>
      'Hemos enviado un enlace de confirmación a:';

  @override
  String get auth_clickLinkToActivate =>
      'Por favor haz clic en el enlace en el email para activar tu cuenta.';

  @override
  String get auth_goToSignIn => 'Ir a Iniciar Sesión';

  @override
  String get auth_returnToHome => 'Volver al Inicio';

  @override
  String get hashtags_explore => 'Explorar Hashtags';

  @override
  String get hashtags_trending => 'Tendencias';

  @override
  String get hashtags_popular => 'Populares';

  @override
  String get hashtags_hdTopics => 'Temas DH';

  @override
  String get hashtags_noTrending => 'Aún no hay hashtags en tendencia';

  @override
  String get hashtags_noPopular => 'Aún no hay hashtags populares';

  @override
  String get hashtags_noHdTopics => 'Aún no hay temas DH';

  @override
  String get hashtag_noPosts => 'Aún no hay publicaciones';

  @override
  String get hashtag_beFirst => '¡Sé el primero en publicar con este hashtag!';

  @override
  String hashtag_postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count publicaciones',
      one: '1 publicación',
    );
    return '$_temp0';
  }

  @override
  String hashtag_recentPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count publicaciones hoy',
      one: '1 publicación hoy',
    );
    return '$_temp0';
  }

  @override
  String get feed_forYou => 'Para Ti';

  @override
  String get feed_trending => 'Tendencias';

  @override
  String get feed_hdTopics => 'Temas DH';

  @override
  String feed_gateTitle(int number) {
    return 'Puerta $number';
  }

  @override
  String feed_gatePosts(int number) {
    return 'Publicaciones sobre Puerta $number';
  }

  @override
  String get transit_events_title => 'Eventos de Tránsito';

  @override
  String get transit_events_happening => 'Sucediendo Ahora';

  @override
  String get transit_events_upcoming => 'Próximos';

  @override
  String get transit_events_past => 'Eventos Pasados';

  @override
  String get transit_events_noCurrentEvents =>
      'No hay eventos sucediendo ahora';

  @override
  String get transit_events_noUpcomingEvents =>
      'No hay eventos próximos programados';

  @override
  String get transit_events_noPastEvents => 'No hay eventos pasados';

  @override
  String get transit_events_live => 'EN VIVO';

  @override
  String get transit_events_join => 'Unirse';

  @override
  String get transit_events_joined => 'Unido';

  @override
  String get transit_events_leave => 'Salir';

  @override
  String get transit_events_participating => 'participando';

  @override
  String get transit_events_posts => 'publicaciones';

  @override
  String get transit_events_viewInsights => 'Ver Percepciones';

  @override
  String transit_events_endsIn(String time) {
    return 'Termina en $time';
  }

  @override
  String transit_events_startsIn(String time) {
    return 'Comienza en $time';
  }

  @override
  String get transit_events_notFound => 'Evento no encontrado';

  @override
  String get transit_events_communityPosts => 'Publicaciones de la Comunidad';

  @override
  String get transit_events_noPosts =>
      'Aún no hay publicaciones para este evento';

  @override
  String get transit_events_shareExperience => 'Compartir Experiencia';

  @override
  String get transit_events_participants => 'Participantes';

  @override
  String get transit_events_duration => 'Duración';

  @override
  String get transit_events_eventEnded => 'Este evento ha terminado';

  @override
  String get transit_events_youreParticipating => '¡Estás participando!';

  @override
  String transit_events_experiencingWith(int count) {
    return 'Experimentando este tránsito con $count otros';
  }

  @override
  String get transit_events_joinCommunity => 'Únete a la Comunidad';

  @override
  String get transit_events_shareYourExperience =>
      'Comparte tu experiencia y conecta con otros';

  @override
  String get activity_title => 'Actividad de Amigos';

  @override
  String get activity_noActivities => 'Aún no hay actividad de amigos';

  @override
  String get activity_followFriends =>
      '¡Sigue amigos para ver sus logros e hitos aquí!';

  @override
  String get activity_findFriends => 'Encontrar Amigos';

  @override
  String get activity_celebrate => 'Celebrar';

  @override
  String get activity_celebrated => 'Celebrado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Crear';

  @override
  String get groupChallenges_title => 'Desafíos de Grupo';

  @override
  String get groupChallenges_myTeams => 'Mis Equipos';

  @override
  String get groupChallenges_challenges => 'Desafíos';

  @override
  String get groupChallenges_leaderboard => 'Tabla de Clasificación';

  @override
  String get groupChallenges_createTeam => 'Crear Equipo';

  @override
  String get groupChallenges_teamName => 'Nombre del Equipo';

  @override
  String get groupChallenges_teamNameHint => 'Ingresa un nombre de equipo';

  @override
  String get groupChallenges_teamDescription => 'Descripción';

  @override
  String get groupChallenges_teamDescriptionHint => '¿De qué trata tu equipo?';

  @override
  String get groupChallenges_teamCreated => '¡Equipo creado exitosamente!';

  @override
  String get groupChallenges_noTeams => 'Aún No Hay Equipos';

  @override
  String get groupChallenges_noTeamsDescription =>
      '¡Crea o únete a un equipo para competir en desafíos de grupo!';

  @override
  String groupChallenges_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String groupChallenges_points(int points) {
    return '$points pts';
  }

  @override
  String get groupChallenges_noChallenges => 'No Hay Desafíos Activos';

  @override
  String get groupChallenges_active => 'Activo';

  @override
  String get groupChallenges_upcoming => 'Próximo';

  @override
  String groupChallenges_reward(int points) {
    return 'Recompensa de $points pts';
  }

  @override
  String groupChallenges_teamsEnrolled(String count) {
    return '$count equipos';
  }

  @override
  String groupChallenges_participants(String count) {
    return '$count participantes';
  }

  @override
  String groupChallenges_endsIn(String time) {
    return 'Termina en $time';
  }

  @override
  String get groupChallenges_weekly => 'Semanal';

  @override
  String get groupChallenges_monthly => 'Mensual';

  @override
  String get groupChallenges_allTime => 'Todo el Tiempo';

  @override
  String get groupChallenges_noTeamsOnLeaderboard =>
      'Aún no hay equipos en la tabla de clasificación';

  @override
  String get groupChallenges_pts => 'pts';

  @override
  String get groupChallenges_teamNotFound => 'Equipo no encontrado';

  @override
  String get groupChallenges_members => 'Miembros';

  @override
  String get groupChallenges_totalPoints => 'Puntos Totales';

  @override
  String get groupChallenges_joined => 'Unido';

  @override
  String get groupChallenges_join => 'Unirse';

  @override
  String get groupChallenges_status => 'Estado';

  @override
  String get groupChallenges_about => 'Acerca de';

  @override
  String get groupChallenges_noMembers => 'Aún no hay miembros';

  @override
  String get groupChallenges_admin => 'Administrador';

  @override
  String groupChallenges_contributed(int points) {
    return '$points pts contribuidos';
  }

  @override
  String get groupChallenges_joinedTeam => '¡Te uniste exitosamente al equipo!';

  @override
  String get groupChallenges_leaveTeam => 'Salir del Equipo';

  @override
  String get groupChallenges_leaveConfirmation =>
      '¿Estás seguro de que quieres salir de este equipo? Tus puntos contribuidos permanecerán con el equipo.';

  @override
  String get groupChallenges_leave => 'Salir';

  @override
  String get groupChallenges_leftTeam => 'Has salido del equipo';

  @override
  String get groupChallenges_challengeDetails => 'Detalles del Desafío';

  @override
  String get groupChallenges_challengeNotFound => 'Desafío no encontrado';

  @override
  String get groupChallenges_target => 'Objetivo';

  @override
  String get groupChallenges_starts => 'Comienza';

  @override
  String get groupChallenges_ends => 'Termina';

  @override
  String get groupChallenges_hdTypes => 'Tipos DH';

  @override
  String get groupChallenges_noTeamsToEnroll => 'No Hay Equipos para Inscribir';

  @override
  String get groupChallenges_createTeamToJoin =>
      'Crea un equipo primero para inscribirte en desafíos';

  @override
  String get groupChallenges_enrollTeam => 'Inscribir un Equipo';

  @override
  String get groupChallenges_enrolled => 'Inscrito';

  @override
  String get groupChallenges_enroll => 'Inscribir';

  @override
  String get groupChallenges_teamEnrolled => '¡Equipo inscrito exitosamente!';

  @override
  String get groupChallenges_noTeamsEnrolled => 'Aún no hay equipos inscritos';

  @override
  String get circles_title => 'Círculos de Compatibilidad';

  @override
  String get circles_myCircles => 'Mis Círculos';

  @override
  String get circles_invitations => 'Invitaciones';

  @override
  String get circles_create => 'Crear Círculo';

  @override
  String get circles_selectIcon => 'Selecciona un ícono';

  @override
  String get circles_name => 'Nombre del Círculo';

  @override
  String get circles_nameHint => 'Familia, Equipo, Amigos...';

  @override
  String get circles_description => 'Descripción';

  @override
  String get circles_descriptionHint => '¿Para qué es este círculo?';

  @override
  String get circles_created => '¡Círculo creado exitosamente!';

  @override
  String get circles_noCircles => 'Aún No Hay Círculos';

  @override
  String get circles_noCirclesDescription =>
      'Crea un círculo para analizar compatibilidad con amigos, familia o miembros del equipo.';

  @override
  String get circles_suggestions => 'Inicio Rápido';

  @override
  String circles_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get circles_private => 'Privado';

  @override
  String get circles_noInvitations => 'Sin Invitaciones';

  @override
  String get circles_noInvitationsDescription =>
      'Las invitaciones a círculos que recibas aparecerán aquí.';

  @override
  String circles_invitedBy(String name) {
    return 'Invitado por $name';
  }

  @override
  String get circles_decline => 'Rechazar';

  @override
  String get circles_accept => 'Aceptar';

  @override
  String get circles_invitationDeclined => 'Invitación rechazada';

  @override
  String get circles_invitationAccepted => '¡Te uniste al círculo!';

  @override
  String get circles_notFound => 'Círculo no encontrado';

  @override
  String get circles_invite => 'Invitar Miembro';

  @override
  String get circles_members => 'Miembros';

  @override
  String get circles_analysis => 'Análisis';

  @override
  String get circles_feed => 'Feed';

  @override
  String get circles_inviteMember => 'Invitar Miembro';

  @override
  String get circles_sendInvite => 'Enviar Invitación';

  @override
  String get circles_invitationSent => '¡Invitación enviada!';

  @override
  String get circles_invitationFailed => 'Error al enviar invitación';

  @override
  String get circles_deleteTitle => 'Eliminar Círculo';

  @override
  String circles_deleteConfirmation(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get circles_deleted => 'Círculo eliminado';

  @override
  String get circles_noMembers => 'Aún no hay miembros';

  @override
  String get circles_noAnalysis => 'Aún No Hay Análisis';

  @override
  String get circles_runAnalysis =>
      'Ejecuta un análisis de compatibilidad para ver cómo interactúan los miembros de tu círculo.';

  @override
  String get circles_needMoreMembers =>
      'Agrega al menos 2 miembros para ejecutar un análisis.';

  @override
  String get circles_analyzeCompatibility => 'Analizar Compatibilidad';

  @override
  String get circles_harmonyScore => 'Puntuación de Armonía';

  @override
  String get circles_typeDistribution => 'Distribución de Tipos';

  @override
  String get circles_electromagneticConnections =>
      'Conexiones Electromagnéticas';

  @override
  String get circles_electromagneticDesc =>
      'Atracción intensa - se completan mutuamente';

  @override
  String get circles_companionshipConnections => 'Conexiones de Compañía';

  @override
  String get circles_companionshipDesc =>
      'Comodidad y estabilidad - entendimiento compartido';

  @override
  String get circles_groupStrengths => 'Fortalezas del Grupo';

  @override
  String get circles_areasForGrowth => 'Áreas de Crecimiento';

  @override
  String get circles_writePost => 'Comparte algo con tu círculo...';

  @override
  String get circles_noPosts => 'Aún No Hay Publicaciones';

  @override
  String get circles_beFirstToPost =>
      '¡Sé el primero en compartir algo con tu círculo!';

  @override
  String get experts_title => 'Expertos en DH';

  @override
  String get experts_becomeExpert => 'Convertirse en Experto';

  @override
  String get experts_filterBySpecialization => 'Filtrar por Especialización';

  @override
  String get experts_allExperts => 'Todos los Expertos';

  @override
  String get experts_experts => 'Expertos';

  @override
  String get experts_noExperts => 'No se encontraron expertos';

  @override
  String get experts_featured => 'Expertos Destacados';

  @override
  String experts_followers(int count) {
    return '$count seguidores';
  }

  @override
  String get experts_notFound => 'Experto no encontrado';

  @override
  String get experts_following => 'Siguiendo';

  @override
  String get experts_follow => 'Seguir';

  @override
  String get experts_about => 'Acerca de';

  @override
  String get experts_specializations => 'Especializaciones';

  @override
  String get experts_credentials => 'Credenciales';

  @override
  String get experts_reviews => 'Reseñas';

  @override
  String get experts_writeReview => 'Escribir Reseña';

  @override
  String get experts_reviewContent => 'Tu Reseña';

  @override
  String get experts_reviewHint =>
      'Comparte tu experiencia trabajando con este experto...';

  @override
  String get experts_submitReview => 'Enviar Reseña';

  @override
  String get experts_reviewSubmitted => '¡Reseña enviada exitosamente!';

  @override
  String get experts_noReviews => 'Aún no hay reseñas';

  @override
  String get experts_followersLabel => 'Seguidores';

  @override
  String get experts_rating => 'Calificación';

  @override
  String get experts_years => 'Años';

  @override
  String get learningPaths_title => 'Rutas de Aprendizaje';

  @override
  String get learningPaths_explore => 'Explorar';

  @override
  String get learningPaths_inProgress => 'En Progreso';

  @override
  String get learningPaths_completed => 'Completados';

  @override
  String get learningPaths_featured => 'Rutas Destacadas';

  @override
  String get learningPaths_allPaths => 'Todas las Rutas';

  @override
  String get learningPaths_noPathsExplore =>
      'No hay rutas de aprendizaje disponibles';

  @override
  String get learningPaths_noPathsInProgress => 'No Hay Rutas en Progreso';

  @override
  String get learningPaths_noPathsInProgressDescription =>
      '¡Inscríbete en una ruta de aprendizaje para comenzar tu viaje!';

  @override
  String get learningPaths_browsePaths => 'Explorar Rutas';

  @override
  String get learningPaths_noPathsCompleted => 'No Hay Rutas Completadas';

  @override
  String get learningPaths_noPathsCompletedDescription =>
      '¡Completa rutas de aprendizaje para verlas aquí!';

  @override
  String learningPaths_enrolled(int count) {
    return '$count inscritos';
  }

  @override
  String learningPaths_stepsCount(int count) {
    return '$count pasos';
  }

  @override
  String learningPaths_progress(int completed, int total) {
    return '$completed de $total pasos';
  }

  @override
  String get learningPaths_resume => 'Reanudar';

  @override
  String learningPaths_completedOn(String date) {
    return 'Completado el $date';
  }

  @override
  String get learningPathNotFound => 'Ruta de aprendizaje no encontrada';

  @override
  String learningPathMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String learningPathSteps(int count) {
    return '$count pasos';
  }

  @override
  String learningPathBy(String author) {
    return 'Por $author';
  }

  @override
  String learningPathEnrolled(int count) {
    return '$count inscritos';
  }

  @override
  String learningPathCompleted(int count) {
    return '$count completados';
  }

  @override
  String get learningPathEnroll => 'Comenzar a Aprender';

  @override
  String get learningPathYourProgress => 'Tu Progreso';

  @override
  String get learningPathCompletedBadge => 'Completado';

  @override
  String learningPathProgressText(int completed, int total) {
    return '$completed de $total pasos completados';
  }

  @override
  String get learningPathStepsTitle => 'Pasos de Aprendizaje';

  @override
  String get learningPathEnrollTitle => '¿Comenzar Esta Ruta?';

  @override
  String learningPathEnrollMessage(String title) {
    return 'Te inscribirás en \"$title\" y podrás seguir tu progreso a medida que completes cada paso.';
  }

  @override
  String get learningPathViewContent => 'Ver Contenido';

  @override
  String get learningPathMarkComplete => 'Marcar como Completado';

  @override
  String get learningPathStepCompleted => '¡Paso completado!';

  @override
  String get thought_title => 'Pensamientos';

  @override
  String get thought_feedTitle => 'Pensamientos';

  @override
  String get thought_createNew => 'Compartir un Pensamiento';

  @override
  String get thought_emptyFeed => 'Tu feed de pensamientos está vacío';

  @override
  String get thought_emptyFeedMessage =>
      'Sigue personas o comparte un pensamiento para comenzar';

  @override
  String get thought_regenerate => 'Regenerar';

  @override
  String thought_regeneratedFrom(String username) {
    return 'Regenerado de @$username';
  }

  @override
  String get thought_regenerateSuccess => '¡Pensamiento regenerado en tu muro!';

  @override
  String get thought_regenerateConfirm => '¿Regenerar este pensamiento?';

  @override
  String get thought_regenerateDescription =>
      'Esto compartirá este pensamiento en tu muro, acreditando al autor original.';

  @override
  String get thought_addComment => 'Agregar un comentario (opcional)';

  @override
  String thought_regenerateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count regeneraciones',
      one: '1 regeneración',
    );
    return '$_temp0';
  }

  @override
  String get thought_cannotRegenerateOwn =>
      'No puedes regenerar tu propio pensamiento';

  @override
  String get thought_alreadyRegenerated => 'Ya has regenerado este pensamiento';

  @override
  String get thought_postDetail => 'Pensamiento';

  @override
  String get thought_noComments =>
      'Aún no hay comentarios. ¡Sé el primero en comentar!';

  @override
  String thought_replyingTo(String username) {
    return 'Respondiendo a $username';
  }

  @override
  String get thought_writeReply => 'Escribe una respuesta...';

  @override
  String get thought_commentPlaceholder => 'Agregar un comentario...';

  @override
  String get messages_title => 'Mensajes';

  @override
  String get messages_conversation => 'Conversación';

  @override
  String get messages_loading => 'Cargando...';

  @override
  String get messages_muteNotifications => 'Silenciar Notificaciones';

  @override
  String get messages_notificationsMuted => 'Notificaciones silenciadas';

  @override
  String get messages_blockUser => 'Bloquear Usuario';

  @override
  String get messages_blockUserConfirm =>
      '¿Estás seguro de que quieres bloquear a este usuario? Ya no recibirás mensajes de ellos.';

  @override
  String get messages_userBlocked => 'Usuario bloqueado';

  @override
  String get messages_block => 'Bloquear';

  @override
  String get messages_deleteConversation => 'Eliminar Conversación';

  @override
  String get messages_deleteConversationConfirm =>
      '¿Estás seguro de que quieres eliminar esta conversación? Esta acción no se puede deshacer.';

  @override
  String get messages_conversationDeleted => 'Conversación eliminada';

  @override
  String get messages_startConversation => '¡Inicia la conversación!';

  @override
  String get profile_takePhoto => 'Tomar Foto';

  @override
  String get profile_chooseFromGallery => 'Elegir de la Galería';

  @override
  String get profile_avatarUpdated => 'Avatar actualizado exitosamente';

  @override
  String get profile_profileUpdated => 'Perfil actualizado exitosamente';

  @override
  String get profile_noProfileFound => 'No se encontró perfil';

  @override
  String get discovery_title => 'Descubrir';

  @override
  String get discovery_searchUsers => 'Buscar usuarios...';

  @override
  String get discovery_discoverTab => 'Descubrir';

  @override
  String get discovery_followingTab => 'Siguiendo';

  @override
  String get discovery_followersTab => 'Seguidores';

  @override
  String get discovery_noUsersFound => 'No se encontraron usuarios';

  @override
  String get discovery_tryAdjustingFilters => 'Intenta ajustar tus filtros';

  @override
  String get discovery_notFollowingAnyone => 'No sigues a nadie';

  @override
  String get discovery_discoverPeople => 'Descubre personas para seguir';

  @override
  String get discovery_noFollowersYet => 'Aún no hay seguidores';

  @override
  String get discovery_shareInsights =>
      'Comparte tus conocimientos para ganar seguidores';

  @override
  String get discovery_clearAll => 'Limpiar todo';

  @override
  String chart_gate(int number) {
    return 'Puerta $number';
  }

  @override
  String chart_channel(String id) {
    return 'Canal $id';
  }

  @override
  String get chart_center => 'Centro';

  @override
  String get chart_keynote => 'Nota Clave';

  @override
  String get chart_element => 'Elemento';

  @override
  String get chart_location => 'Ubicación';

  @override
  String get chart_hdCenters => 'Centros DH';

  @override
  String get reaction_comment => 'Comentar';

  @override
  String get reaction_react => 'Reaccionar';

  @override
  String get reaction_standard => 'Estándar';

  @override
  String get reaction_humanDesign => 'Diseño Humano';

  @override
  String get share_shareChart => 'Compartir Carta';

  @override
  String get share_createShareLink => 'Crear Enlace para Compartir';

  @override
  String get share_shareViaUrl => 'Compartir vía URL';

  @override
  String get share_exportAsPng => 'Exportar como PNG';

  @override
  String get share_fullReport => 'Informe completo';

  @override
  String get share_linkExpiration => 'Expiración del Enlace';

  @override
  String get share_neverExpires => 'Nunca expira';

  @override
  String get share_oneHour => '1 hora';

  @override
  String get share_twentyFourHours => '24 horas';

  @override
  String get share_sevenDays => '7 días';

  @override
  String get share_thirtyDays => '30 días';

  @override
  String get share_creating => 'Creando...';

  @override
  String get share_signInToShare => 'Inicia sesión para compartir tu carta';

  @override
  String get share_createShareableLinks =>
      'Crea enlaces compartibles de tu carta de Diseño Humano';

  @override
  String get share_linkImage => 'Imagen';

  @override
  String get share_pdf => 'PDF';

  @override
  String get post_share => 'Compartir';

  @override
  String get post_edit => 'Editar';

  @override
  String get post_report => 'Reportar';

  @override
  String get mentorship_title => 'Mentoría';

  @override
  String get mentorship_pendingRequests => 'Solicitudes Pendientes';

  @override
  String get mentorship_availableMentors => 'Mentores Disponibles';

  @override
  String get mentorship_noMentorsAvailable => 'No hay mentores disponibles';

  @override
  String mentorship_requestMentorship(String name) {
    return 'Solicitar Mentoría de $name';
  }

  @override
  String get mentorship_sendMessage =>
      'Envía un mensaje explicando qué te gustaría aprender:';

  @override
  String get mentorship_learnPrompt => 'Me gustaría aprender más sobre...';

  @override
  String get mentorship_requestSent => '¡Solicitud enviada!';

  @override
  String get mentorship_sendRequest => 'Enviar Solicitud';

  @override
  String get mentorship_becomeAMentor => 'Convertirse en Mentor';

  @override
  String get mentorship_shareKnowledge =>
      'Comparte tu conocimiento de Diseño Humano';

  @override
  String get story_cancel => 'Cancelar';

  @override
  String get story_createStory => 'Crear Historia';

  @override
  String get story_share => 'Compartir';

  @override
  String get story_typeYourStory => 'Escribe tu historia...';

  @override
  String get story_background => 'Fondo';

  @override
  String get story_attachTransitGate =>
      'Adjuntar Puerta de Tránsito (opcional)';

  @override
  String get story_none => 'Ninguno';

  @override
  String story_gateNumber(int number) {
    return 'Puerta $number';
  }

  @override
  String get story_whoCanSee => '¿Quién puede ver esto?';

  @override
  String get story_followers => 'Seguidores';

  @override
  String get story_everyone => 'Todos';

  @override
  String get challenges_title => 'Desafíos';

  @override
  String get challenges_daily => 'Diario';

  @override
  String get challenges_weekly => 'Semanal';

  @override
  String get challenges_monthly => 'Mensual';

  @override
  String get challenges_noDailyChallenges =>
      'No hay desafíos diarios disponibles';

  @override
  String get challenges_noWeeklyChallenges =>
      'No hay desafíos semanales disponibles';

  @override
  String get challenges_noMonthlyChallenges =>
      'No hay desafíos mensuales disponibles';

  @override
  String get challenges_errorLoading => 'Error al cargar desafíos';

  @override
  String challenges_claimedPoints(int points) {
    return '¡Reclamaste $points puntos!';
  }

  @override
  String get challenges_totalPoints => 'Puntos Totales';

  @override
  String get challenges_level => 'Nivel';

  @override
  String get learning_all => 'Todos';

  @override
  String get learning_types => 'Tipos';

  @override
  String get learning_gates => 'Puertas';

  @override
  String get learning_centers => 'Centros';

  @override
  String get learning_liveSessions => 'Sesiones en Vivo';

  @override
  String get quiz_noActiveSession => 'No hay sesión de cuestionario activa';

  @override
  String get quiz_noQuestionsAvailable => 'No hay preguntas disponibles';

  @override
  String get quiz_ok => 'OK';

  @override
  String get liveSessions_title => 'Sesiones en Vivo';

  @override
  String get liveSessions_upcoming => 'Próximas';

  @override
  String get liveSessions_mySessions => 'Mis Sesiones';

  @override
  String get liveSessions_errorLoading => 'Error al cargar sesiones';

  @override
  String get liveSessions_registeredSuccessfully => '¡Registrado exitosamente!';

  @override
  String get liveSessions_cancelRegistration => 'Cancelar Registro';

  @override
  String get liveSessions_cancelRegistrationConfirm =>
      '¿Estás seguro de que quieres cancelar tu registro?';

  @override
  String get liveSessions_no => 'No';

  @override
  String get liveSessions_yesCancel => 'Sí, Cancelar';

  @override
  String get liveSessions_registrationCancelled => 'Registro cancelado';

  @override
  String get gateChannelPicker_gates => 'Puertas (64)';

  @override
  String get gateChannelPicker_channels => 'Canales (36)';

  @override
  String get gateChannelPicker_search => 'Buscar puertas o canales...';

  @override
  String get leaderboard_weekly => 'Semanal';

  @override
  String get leaderboard_monthly => 'Mensual';

  @override
  String get leaderboard_allTime => 'Todo el Tiempo';

  @override
  String get ai_chatTitle => 'Asistente IA';

  @override
  String get ai_askAi => 'Preguntar a IA';

  @override
  String get ai_askAboutChart => 'Pregunta a la IA sobre Tu Carta';

  @override
  String get ai_miniDescription =>
      'Obtén conocimientos personalizados sobre tu Diseño Humano';

  @override
  String get ai_startChatting => 'Empezar a chatear';

  @override
  String get ai_welcomeTitle => 'Tu Asistente de DH';

  @override
  String get ai_welcomeSubtitle =>
      'Pregúntame cualquier cosa sobre tu carta de Diseño Humano. Puedo explicar tu tipo, estrategia, autoridad, puertas, canales y más.';

  @override
  String get ai_inputPlaceholder => 'Pregunta sobre tu carta...';

  @override
  String get ai_newConversation => 'Nueva Conversación';

  @override
  String get ai_conversations => 'Conversaciones';

  @override
  String get ai_noConversations => 'Aún no hay conversaciones';

  @override
  String get ai_noConversationsMessage =>
      'Inicia una conversación con la IA para obtener conocimientos personalizados de tu carta.';

  @override
  String get ai_deleteConversation => 'Eliminar Conversación';

  @override
  String get ai_deleteConversationConfirm =>
      '¿Estás seguro de que quieres eliminar esta conversación?';

  @override
  String get ai_messagesExhausted => 'Mensajes Gratuitos Agotados';

  @override
  String get ai_upgradeForUnlimited =>
      'Mejora a Premium para conversaciones ilimitadas de IA sobre tu carta de Diseño Humano.';

  @override
  String ai_usageCount(int used, int limit) {
    return '$used de $limit mensajes gratuitos usados';
  }

  @override
  String get ai_errorGeneric => 'Algo salió mal. Por favor intenta de nuevo.';

  @override
  String get ai_errorNetwork =>
      'No se pudo contactar con el servicio de IA. Verifica tu conexión.';

  @override
  String get events_title => 'Eventos de la Comunidad';

  @override
  String get events_upcoming => 'Próximos';

  @override
  String get events_past => 'Pasados';

  @override
  String get events_create => 'Crear Evento';

  @override
  String get events_noUpcoming => 'No hay eventos próximos';

  @override
  String get events_noUpcomingMessage =>
      '¡Crea un evento para conectar con la comunidad de DH!';

  @override
  String get events_online => 'En Línea';

  @override
  String get events_inPerson => 'Presencial';

  @override
  String get events_hybrid => 'Híbrido';

  @override
  String events_participants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participantes',
      one: '1 participante',
    );
    return '$_temp0';
  }

  @override
  String get events_register => 'Registrarse';

  @override
  String get events_registered => 'Registrado';

  @override
  String get events_cancelRegistration => 'Cancelar Registro';

  @override
  String get events_registrationFull => 'Evento Lleno';

  @override
  String get events_eventTitle => 'Título del Evento';

  @override
  String get events_eventDescription => 'Descripción';

  @override
  String get events_eventType => 'Tipo de Evento';

  @override
  String get events_startDate => 'Fecha y Hora de Inicio';

  @override
  String get events_endDate => 'Fecha y Hora de Fin';

  @override
  String get events_location => 'Ubicación';

  @override
  String get events_virtualLink => 'Enlace de Reunión Virtual';

  @override
  String get events_maxParticipants => 'Participantes Máximos';

  @override
  String get events_hdTypeFilter => 'Filtro de Tipo DH';

  @override
  String get events_allTypes => 'Abierto a Todos los Tipos';

  @override
  String get events_created => '¡Evento creado!';

  @override
  String get events_deleted => 'Evento eliminado';

  @override
  String get events_notFound => 'Evento no encontrado';

  @override
  String get chartOfDay_title => 'Carta del Día';

  @override
  String get chartOfDay_featured => 'Carta Destacada';

  @override
  String get chartOfDay_viewChart => 'Ver Carta';

  @override
  String get discussion_typeDiscussion => 'Discusión de Tipo';

  @override
  String get discussion_channelDiscussion => 'Discusión de Canal';

  @override
  String get ai_wantMoreInsights => '¿Quieres más insights de AI?';

  @override
  String ai_messagesPackTitle(int count) {
    return '$count Mensajes';
  }

  @override
  String get ai_orSubscribe => 'o suscríbete para ilimitado';

  @override
  String get ai_bestValue => 'Mejor valor';

  @override
  String get ai_getMoreMessages => 'Obtener más mensajes';

  @override
  String ai_fromPrice(String price) {
    return 'Desde $price';
  }

  @override
  String ai_perMessage(String price) {
    return '$price/mensaje';
  }

  @override
  String get ai_transitInsightTitle => 'Perspectiva de Tránsito del Día';

  @override
  String get ai_transitInsightDesc =>
      'Obtén una interpretación personalizada de IA sobre cómo los tránsitos de hoy afectan tu carta.';

  @override
  String get ai_chartReadingTitle => 'Lectura de Carta con IA';

  @override
  String get ai_chartReadingDesc =>
      'Genera una lectura completa de IA de tu carta de Diseño Humano.';

  @override
  String get ai_chartReadingCost =>
      'Esta lectura usa 3 mensajes de IA de tu cuota.';

  @override
  String get ai_compatibilityTitle => 'Lectura de Compatibilidad con IA';

  @override
  String get ai_compatibilityReading => 'Análisis de Compatibilidad con IA';

  @override
  String get ai_dreamJournalTitle => 'Diario de Sueños';

  @override
  String get ai_dreamEntryHint =>
      'Registra tus sueños para descubrir perspectivas ocultas de tu diseño...';

  @override
  String get ai_interpretDream => 'Interpretar Sueño';

  @override
  String get ai_journalPromptsTitle => 'Temas para el Diario';

  @override
  String get ai_journalPromptsDesc =>
      'Obtén temas personalizados para tu diario basados en tu carta y los tránsitos de hoy.';

  @override
  String get ai_generating => 'Generando...';

  @override
  String get ai_askFollowUp => 'Hacer Seguimiento';

  @override
  String get ai_regenerate => 'Regenerar';

  @override
  String get ai_exportPdf => 'Exportar PDF';

  @override
  String get ai_shareReading => 'Compartir Lectura';

  @override
  String get group_notFound => 'Grupo no encontrado';

  @override
  String get group_members => 'Miembros';

  @override
  String get group_sharedCharts => 'Cartas Compartidas';

  @override
  String get group_feed => 'Feed';

  @override
  String get group_invite => 'Invitar';

  @override
  String get group_inviteMembers => 'Invitar Miembros';

  @override
  String get group_searchUsers => 'Buscar por nombre...';

  @override
  String get group_searchHint => 'Escribe al menos 2 caracteres para buscar';

  @override
  String get group_noUsersFound => 'No se encontraron usuarios';

  @override
  String group_memberAdded(String name) {
    return '$name añadido al grupo';
  }

  @override
  String get group_addMemberFailed => 'No se pudo añadir al miembro';

  @override
  String get group_noMembers => 'Aún no hay miembros';

  @override
  String get group_promote => 'Promover a Administrador';

  @override
  String get group_demote => 'Degradar a Miembro';

  @override
  String get group_removeMember => 'Eliminar';

  @override
  String get group_promoteTitle => 'Promover Miembro';

  @override
  String group_promoteConfirmation(String name) {
    return '¿Hacer a $name administrador de este grupo?';
  }

  @override
  String get group_demoteTitle => 'Degradar Miembro';

  @override
  String group_demoteConfirmation(String name) {
    return '¿Eliminar el rol de administrador de $name?';
  }

  @override
  String get group_removeMemberTitle => 'Eliminar Miembro';

  @override
  String group_removeMemberConfirmation(String name) {
    return '¿Eliminar a $name de este grupo?';
  }

  @override
  String get group_editName => 'Editar Nombre';

  @override
  String get group_editDescription => 'Editar Descripción';

  @override
  String get group_delete => 'Eliminar Grupo';

  @override
  String get group_deleteTitle => 'Eliminar Grupo';

  @override
  String group_deleteConfirmation(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get group_deleted => 'Grupo eliminado';

  @override
  String get group_leave => 'Abandonar Grupo';

  @override
  String get group_leaveTitle => 'Abandonar Grupo';

  @override
  String group_leaveConfirmation(String name) {
    return '¿Estás seguro de que quieres abandonar \"$name\"?';
  }

  @override
  String get group_left => 'Has abandonado el grupo';

  @override
  String get group_updated => 'Grupo actualizado';

  @override
  String get group_noSharedCharts => 'No Hay Cartas Compartidas';

  @override
  String get group_noSharedChartsMessage =>
      'Comparte tu carta con el grupo desde la pantalla de carta.';

  @override
  String get group_writePost => 'Escribe algo...';

  @override
  String get group_noPosts => 'Aún No Hay Publicaciones';

  @override
  String get group_beFirstToPost => '¡Inicia la conversación!';

  @override
  String get group_deletePostConfirmation => '¿Eliminar esta publicación?';

  @override
  String get group_shareChart => 'Compartir carta';

  @override
  String get group_share => 'Compartir';

  @override
  String get group_chartShared => 'Carta compartida con el grupo';

  @override
  String get group_noChartsToShare =>
      'No hay cartas guardadas para compartir. Crea una carta primero.';
}
