// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Inside Me';

  @override
  String get common_save => 'Salvar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_delete => 'Excluir';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_done => 'Concluído';

  @override
  String get common_next => 'Próximo';

  @override
  String get common_back => 'Voltar';

  @override
  String get common_skip => 'Pular';

  @override
  String get common_continue => 'Continuar';

  @override
  String get common_loading => 'Carregando...';

  @override
  String get common_error => 'Erro';

  @override
  String get common_retry => 'Tentar novamente';

  @override
  String get common_close => 'Fechar';

  @override
  String get common_search => 'Buscar';

  @override
  String get common_share => 'Compartilhar';

  @override
  String get common_settings => 'Configurações';

  @override
  String get common_logout => 'Sair';

  @override
  String get common_profile => 'Perfil';

  @override
  String get common_type => 'Tipo';

  @override
  String get common_strategy => 'Estratégia';

  @override
  String get common_authority => 'Autoridade';

  @override
  String get common_definition => 'Definição';

  @override
  String get common_create => 'Criar';

  @override
  String get common_viewFull => 'Ver Completo';

  @override
  String get common_send => 'Enviar';

  @override
  String get common_like => 'Curtir';

  @override
  String get common_reply => 'Responder';

  @override
  String get common_deleteConfirmation =>
      'Tem certeza de que deseja excluir isso? Esta ação não pode ser desfeita.';

  @override
  String get common_comingSoon => 'Em breve!';

  @override
  String get nav_home => 'Início';

  @override
  String get nav_chart => 'Mapa';

  @override
  String get nav_today => 'Diário';

  @override
  String get nav_social => 'Social';

  @override
  String get nav_profile => 'Perfil';

  @override
  String get nav_ai => 'IA';

  @override
  String get nav_more => 'Mais';

  @override
  String get nav_learn => 'Aprender';

  @override
  String get affirmation_savedSuccess => 'Afirmação salva!';

  @override
  String get affirmation_alreadySaved => 'Afirmação já salva';

  @override
  String get home_goodMorning => 'Bom dia';

  @override
  String get home_goodAfternoon => 'Boa tarde';

  @override
  String get home_goodEvening => 'Boa noite';

  @override
  String get home_yourDesign => 'Seu Design';

  @override
  String get home_completeProfile => 'Complete Seu Perfil';

  @override
  String get home_enterBirthData => 'Inserir Dados de Nascimento';

  @override
  String get home_myChart => 'Meu Mapa';

  @override
  String get home_savedCharts => 'Salvos';

  @override
  String get home_composite => 'Composto';

  @override
  String get home_penta => 'Penta';

  @override
  String get home_friends => 'Amigos';

  @override
  String get home_myBodygraph => 'Meu Bodygraph';

  @override
  String get home_definedCenters => 'Centros Definidos';

  @override
  String get home_activeChannels => 'Canais Ativos';

  @override
  String get home_activeGates => 'Portas Ativas';

  @override
  String get transit_today => 'Trânsitos de Hoje';

  @override
  String get transit_sun => 'Sol';

  @override
  String get transit_earth => 'Terra';

  @override
  String get transit_moon => 'Lua';

  @override
  String transit_gate(int number) {
    return 'Porta $number';
  }

  @override
  String transit_newChannelsActivated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count novos canais ativados',
      one: '1 novo canal ativado',
    );
    return '$_temp0';
  }

  @override
  String transit_gatesHighlighted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count portas destacadas',
      one: '1 porta destacada',
    );
    return '$_temp0';
  }

  @override
  String get transit_noConnections => 'Nenhuma conexão direta de trânsito hoje';

  @override
  String get auth_signIn => 'Entrar';

  @override
  String get auth_signUp => 'Cadastrar';

  @override
  String get auth_signInWithApple => 'Entrar com Apple';

  @override
  String get auth_signInWithGoogle => 'Entrar com Google';

  @override
  String get auth_signInWithEmail => 'Entrar com E-mail';

  @override
  String get auth_email => 'E-mail';

  @override
  String get auth_password => 'Senha';

  @override
  String get auth_confirmPassword => 'Confirmar Senha';

  @override
  String get auth_forgotPassword => 'Esqueceu a Senha?';

  @override
  String get auth_noAccount => 'Não tem uma conta?';

  @override
  String get auth_hasAccount => 'Já tem uma conta?';

  @override
  String get auth_termsAgree =>
      'Ao se cadastrar, você concorda com nossos Termos de Serviço e Política de Privacidade';

  @override
  String get auth_welcomeBack => 'Bem-vindo de volta';

  @override
  String get auth_signInSubtitle =>
      'Entre para continuar sua jornada de Design Humano';

  @override
  String get auth_signInRequired => 'Entrada Necessária';

  @override
  String get auth_signInToCalculateChart =>
      'Por favor, entre para calcular e salvar seu mapa de Design Humano.';

  @override
  String get auth_signInToCreateStory =>
      'Por favor, entre para compartilhar histórias com a comunidade.';

  @override
  String get auth_signUpSubtitle => 'Comece sua jornada de Design Humano hoje';

  @override
  String get auth_signUpWithApple => 'Cadastrar com Apple';

  @override
  String get auth_signUpWithGoogle => 'Cadastrar com Google';

  @override
  String get auth_signUpWithMicrosoft => 'Sign up with Microsoft';

  @override
  String get auth_enterName => 'Digite seu nome';

  @override
  String get auth_nameRequired => 'Nome é obrigatório';

  @override
  String get auth_termsOfService => 'Termos de Serviço';

  @override
  String get auth_privacyPolicy => 'Política de Privacidade';

  @override
  String get auth_acceptTerms =>
      'Por favor, aceite os Termos de Serviço para continuar';

  @override
  String get auth_resetPasswordTitle => 'Redefinir Senha';

  @override
  String get auth_resetPasswordPrompt =>
      'Digite seu endereço de e-mail e enviaremos um link para redefinir sua senha.';

  @override
  String get auth_enterEmail => 'Digite seu e-mail';

  @override
  String get auth_resetEmailSent => 'E-mail de redefinição de senha enviado!';

  @override
  String get auth_name => 'Nome';

  @override
  String get auth_createAccount => 'Criar Conta';

  @override
  String get auth_iAgreeTo => 'Eu concordo com ';

  @override
  String get auth_and => ' e ';

  @override
  String get auth_birthInformation => 'Informações de Nascimento';

  @override
  String get auth_calculateMyChart => 'Calcular Meu Mapa';

  @override
  String get onboarding_welcome => 'Bem-vindo ao Inside Me';

  @override
  String get onboarding_welcomeSubtitle =>
      'Descubra seu blueprint energético único';

  @override
  String get onboarding_birthData => 'Digite Seus Dados de Nascimento';

  @override
  String get onboarding_birthDataSubtitle =>
      'Precisamos disso para calcular seu mapa';

  @override
  String get onboarding_birthDate => 'Data de Nascimento';

  @override
  String get onboarding_birthTime => 'Hora de Nascimento';

  @override
  String get onboarding_birthLocation => 'Local de Nascimento';

  @override
  String get onboarding_searchLocation => 'Buscar uma cidade...';

  @override
  String get onboarding_unknownTime => 'Não sei minha hora de nascimento';

  @override
  String get onboarding_timeImportance =>
      'Saber sua hora exata de nascimento é importante para um mapa preciso';

  @override
  String get onboarding_birthDataExplanation =>
      'Seus dados de nascimento são usados para calcular seu mapa único de Design Humano. Quanto mais precisa a informação, mais preciso será seu mapa.';

  @override
  String get onboarding_noTimeWarning =>
      'Sem uma hora de nascimento precisa, alguns detalhes do mapa (como seu Ascendente e linhas exatas das portas) podem não ser precisos. Usaremos meio-dia como padrão.';

  @override
  String get onboarding_enterBirthTimeInstead => 'Inserir hora de nascimento';

  @override
  String get onboarding_birthDataPrivacy =>
      'Seus dados de nascimento são criptografados e armazenados com segurança. Você pode atualizar ou excluí-los a qualquer momento nas configurações do seu perfil.';

  @override
  String get onboarding_saveFailed => 'Falha ao salvar dados de nascimento';

  @override
  String get onboarding_fillAllFields =>
      'Por favor, preencha todos os campos obrigatórios';

  @override
  String get onboarding_selectLanguage => 'Selecionar Idioma';

  @override
  String get onboarding_getStarted => 'Começar';

  @override
  String get onboarding_alreadyHaveAccount => 'Já tenho uma conta';

  @override
  String get onboarding_liveInAlignment =>
      'Descubra seu blueprint energético único e viva em alinhamento com sua verdadeira natureza.';

  @override
  String get chart_myChart => 'Meu Mapa';

  @override
  String get chart_viewChart => 'Ver Mapa';

  @override
  String get chart_calculate => 'Calcular Mapa';

  @override
  String get chart_recalculate => 'Recalcular';

  @override
  String get chart_share => 'Compartilhar Mapa';

  @override
  String get chart_createChart => 'Criar Mapa';

  @override
  String get chart_composite => 'Mapa Composto';

  @override
  String get chart_transit => 'Trânsitos de Hoje';

  @override
  String get chart_bodygraph => 'Bodygraph';

  @override
  String get chart_planets => 'Planetas';

  @override
  String get chart_details => 'Detalhes do Mapa';

  @override
  String get chart_properties => 'Propriedades';

  @override
  String get chart_gates => 'Portas';

  @override
  String get chart_channels => 'Canais';

  @override
  String get chart_noChartYet => 'Ainda Sem Mapa';

  @override
  String get chart_addBirthDataPrompt =>
      'Adicione seus dados de nascimento para gerar seu mapa único de Design Humano.';

  @override
  String get chart_addBirthData => 'Adicionar Dados de Nascimento';

  @override
  String get chart_noActiveChannels => 'Sem Canais Ativos';

  @override
  String get chart_channelsFormedBothGates =>
      'Canais são formados quando ambas as portas estão definidas.';

  @override
  String get chart_savedCharts => 'Mapas Salvos';

  @override
  String get chart_addChart => 'Adicionar Mapa';

  @override
  String get chart_noSavedCharts => 'Sem Mapas Salvos';

  @override
  String get chart_noSavedChartsMessage =>
      'Crie mapas para você e outros para salvá-los aqui.';

  @override
  String get chart_loadFailed => 'Falha ao carregar mapas';

  @override
  String get chart_renameChart => 'Renomear Mapa';

  @override
  String get chart_rename => 'Renomear';

  @override
  String get chart_renameFailed => 'Falha ao renomear mapa';

  @override
  String get chart_deleteChart => 'Excluir Mapa';

  @override
  String chart_deleteConfirm(String name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get chart_deleteFailed => 'Falha ao excluir mapa';

  @override
  String get chart_you => 'Você';

  @override
  String get chart_personName => 'Nome';

  @override
  String get chart_enterPersonName => 'Digite o nome da pessoa';

  @override
  String get chart_addChartDescription =>
      'Crie um mapa para outra pessoa inserindo suas informações de nascimento.';

  @override
  String get chart_calculateAndSave => 'Calcular e Salvar Mapa';

  @override
  String get chart_saved => 'Mapa salvo com sucesso';

  @override
  String get chart_consciousGates => 'Portas Conscientes';

  @override
  String get chart_unconsciousGates => 'Portas Inconscientes';

  @override
  String get chart_personalitySide =>
      'Lado da Personalidade - do que você está consciente';

  @override
  String get chart_designSide =>
      'Lado do Design - o que os outros veem em você';

  @override
  String get type_manifestor => 'Manifestador';

  @override
  String get type_generator => 'Gerador';

  @override
  String get type_manifestingGenerator => 'Gerador Manifestante';

  @override
  String get type_projector => 'Projetor';

  @override
  String get type_reflector => 'Refletor';

  @override
  String get type_manifestor_strategy => 'Informar';

  @override
  String get type_generator_strategy => 'Responder';

  @override
  String get type_manifestingGenerator_strategy => 'Responder';

  @override
  String get type_projector_strategy => 'Aguardar Convite';

  @override
  String get type_reflector_strategy => 'Aguardar Ciclo Lunar';

  @override
  String get authority_emotional => 'Emocional';

  @override
  String get authority_sacral => 'Sacral';

  @override
  String get authority_splenic => 'Esplênica';

  @override
  String get authority_ego => 'Ego/Coração';

  @override
  String get authority_self => 'Auto-Projetada';

  @override
  String get authority_environment => 'Mental/Ambiental';

  @override
  String get authority_lunar => 'Lunar';

  @override
  String get definition_none => 'Sem Definição';

  @override
  String get definition_single => 'Definição Simples';

  @override
  String get definition_split => 'Definição Dividida';

  @override
  String get definition_tripleSplit => 'Divisão Tripla';

  @override
  String get definition_quadrupleSplit => 'Divisão Quádrupla';

  @override
  String get profile_1_3 => '1/3 Investigador/Mártir';

  @override
  String get profile_1_4 => '1/4 Investigador/Oportunista';

  @override
  String get profile_2_4 => '2/4 Eremita/Oportunista';

  @override
  String get profile_2_5 => '2/5 Eremita/Herege';

  @override
  String get profile_3_5 => '3/5 Mártir/Herege';

  @override
  String get profile_3_6 => '3/6 Mártir/Modelo';

  @override
  String get profile_4_6 => '4/6 Oportunista/Modelo';

  @override
  String get profile_4_1 => '4/1 Oportunista/Investigador';

  @override
  String get profile_5_1 => '5/1 Herege/Investigador';

  @override
  String get profile_5_2 => '5/2 Herege/Eremita';

  @override
  String get profile_6_2 => '6/2 Modelo/Eremita';

  @override
  String get profile_6_3 => '6/3 Modelo/Mártir';

  @override
  String get center_head => 'Cabeça';

  @override
  String get center_ajna => 'Ajna';

  @override
  String get center_throat => 'Garganta';

  @override
  String get center_g => 'G/Eu';

  @override
  String get center_heart => 'Coração/Ego';

  @override
  String get center_sacral => 'Sacral';

  @override
  String get center_solarPlexus => 'Plexo Solar';

  @override
  String get center_spleen => 'Baço';

  @override
  String get center_root => 'Raiz';

  @override
  String get center_defined => 'Definido';

  @override
  String get center_undefined => 'Indefinido';

  @override
  String get section_type => 'Tipo';

  @override
  String get section_strategy => 'Estratégia';

  @override
  String get section_authority => 'Autoridade';

  @override
  String get section_profile => 'Perfil';

  @override
  String get section_definition => 'Definição';

  @override
  String get section_centers => 'Centros';

  @override
  String get section_channels => 'Canais';

  @override
  String get section_gates => 'Portas';

  @override
  String get section_conscious => 'Consciente (Personalidade)';

  @override
  String get section_unconscious => 'Inconsciente (Design)';

  @override
  String get social_title => 'Social';

  @override
  String get social_thoughts => 'Pensamentos';

  @override
  String get social_discover => 'Descobrir';

  @override
  String get social_groups => 'Grupos';

  @override
  String get social_invite => 'Convidar';

  @override
  String get social_createPost => 'Compartilhe um pensamento...';

  @override
  String get social_noThoughtsYet => 'Ainda sem pensamentos';

  @override
  String get social_noThoughtsMessage =>
      'Seja o primeiro a compartilhar suas percepções sobre Design Humano!';

  @override
  String get social_createGroup => 'Criar Grupo';

  @override
  String get social_members => 'Membros';

  @override
  String get social_comments => 'Comentários';

  @override
  String get social_addComment => 'Adicionar um comentário...';

  @override
  String get social_noComments => 'Ainda sem comentários';

  @override
  String social_shareLimit(int remaining) {
    return 'Você tem $remaining compartilhamentos restantes este mês';
  }

  @override
  String get social_visibility => 'Visibilidade';

  @override
  String get social_private => 'Privado';

  @override
  String get social_friendsOnly => 'Apenas Amigos';

  @override
  String get social_public => 'Público';

  @override
  String get social_shared => 'Compartilhado';

  @override
  String get social_noGroupsYet => 'Ainda Sem Grupos';

  @override
  String get social_noGroupsMessage =>
      'Crie grupos para analisar dinâmicas de equipe com análise Penta.';

  @override
  String get social_noSharedCharts => 'Sem Mapas Compartilhados';

  @override
  String get social_noSharedChartsMessage =>
      'Mapas compartilhados com você aparecerão aqui.';

  @override
  String get social_createGroupPrompt =>
      'Crie um grupo para analisar dinâmicas de equipe.';

  @override
  String get social_groupName => 'Nome do Grupo';

  @override
  String get social_groupNameHint => 'Família, Equipe, etc.';

  @override
  String get social_groupDescription => 'Descrição (opcional)';

  @override
  String get social_groupDescriptionHint => 'Para que serve este grupo?';

  @override
  String social_groupCreated(String name) {
    return 'Grupo \"$name\" criado!';
  }

  @override
  String get social_groupNameRequired =>
      'Por favor, digite um nome para o grupo';

  @override
  String get social_createGroupFailed =>
      'Falha ao criar grupo. Por favor, tente novamente.';

  @override
  String get social_noDescription => 'Sem descrição';

  @override
  String get social_admin => 'Administrador';

  @override
  String social_sharedBy(String name) {
    return 'Compartilhado por $name';
  }

  @override
  String get social_loadGroupsFailed => 'Falha ao carregar grupos';

  @override
  String get social_loadSharedFailed =>
      'Falha ao carregar mapas compartilhados';

  @override
  String get social_userNotFound => 'Usuário não encontrado';

  @override
  String get discovery_userNotFound => 'Usuário não encontrado';

  @override
  String get discovery_following => 'Seguindo';

  @override
  String get discovery_follow => 'Seguir';

  @override
  String get discovery_sendMessage => 'Enviar Mensagem';

  @override
  String get discovery_about => 'Sobre';

  @override
  String get discovery_humanDesign => 'Design Humano';

  @override
  String get discovery_type => 'Tipo';

  @override
  String get discovery_profile => 'Perfil';

  @override
  String get discovery_authority => 'Autoridade';

  @override
  String get discovery_compatibility => 'Compatibilidade';

  @override
  String get discovery_compatible => 'compatível';

  @override
  String get discovery_followers => 'Seguidores';

  @override
  String get discovery_followingLabel => 'Seguindo';

  @override
  String get discovery_noResults => 'Nenhum usuário encontrado';

  @override
  String get discovery_noResultsMessage =>
      'Tente ajustar seus filtros ou volte mais tarde';

  @override
  String get userProfile_viewChart => 'Bodygraph';

  @override
  String get userProfile_chartPrivate => 'Este mapa é privado';

  @override
  String get userProfile_chartFriendsOnly =>
      'Torne-se seguidor mútuo para ver este mapa';

  @override
  String get userProfile_chartFollowToView => 'Siga para ver este mapa';

  @override
  String get userProfile_publicProfile => 'Perfil Público';

  @override
  String get userProfile_privateProfile => 'Perfil Privado';

  @override
  String get userProfile_friendsOnlyProfile => 'Apenas Amigos';

  @override
  String get userProfile_followersList => 'Seguidores';

  @override
  String get userProfile_followingList => 'Seguindo';

  @override
  String get userProfile_noFollowers => 'Ainda sem seguidores';

  @override
  String get userProfile_noFollowing => 'Ainda não está seguindo ninguém';

  @override
  String get userProfile_thoughts => 'Pensamentos';

  @override
  String get userProfile_noThoughts => 'Ainda sem pensamentos compartilhados';

  @override
  String get userProfile_showAll => 'Mostrar Tudo';

  @override
  String get popularCharts_title => 'Mapas Populares';

  @override
  String get popularCharts_subtitle => 'Mapas públicos mais seguidos';

  @override
  String time_minutesAgo(int minutes) {
    return '${minutes}m atrás';
  }

  @override
  String time_hoursAgo(int hours) {
    return '${hours}h atrás';
  }

  @override
  String time_daysAgo(int days) {
    return '${days}d atrás';
  }

  @override
  String get transit_title => 'Trânsitos de Hoje';

  @override
  String get transit_currentEnergies => 'Energias Atuais';

  @override
  String get transit_sunGate => 'Porta do Sol';

  @override
  String get transit_earthGate => 'Porta da Terra';

  @override
  String get transit_moonGate => 'Porta da Lua';

  @override
  String get transit_activeGates => 'Portas de Trânsito Ativas';

  @override
  String get transit_activeChannels => 'Canais de Trânsito Ativos';

  @override
  String get transit_personalImpact => 'Impacto Pessoal';

  @override
  String transit_gateActivated(int gate) {
    return 'Porta $gate ativada por trânsito';
  }

  @override
  String transit_channelFormed(String channel) {
    return 'Canal $channel formado com seu mapa';
  }

  @override
  String get transit_noPersonalImpact =>
      'Nenhuma conexão direta de trânsito hoje';

  @override
  String get transit_viewFullTransit => 'Ver Mapa de Trânsito Completo';

  @override
  String get affirmation_title => 'Afirmação Diária';

  @override
  String affirmation_forYourType(String type) {
    return 'Para Seu $type';
  }

  @override
  String affirmation_basedOnGate(int gate) {
    return 'Baseado na Porta $gate';
  }

  @override
  String get affirmation_refresh => 'Nova Afirmação';

  @override
  String get affirmation_save => 'Salvar Afirmação';

  @override
  String get affirmation_saved => 'Afirmações Salvas';

  @override
  String get affirmation_share => 'Compartilhar Afirmação';

  @override
  String get affirmation_notifications => 'Notificações de Afirmação Diária';

  @override
  String get affirmation_notificationTime => 'Horário de Notificação';

  @override
  String get lifestyle_today => 'Hoje';

  @override
  String get lifestyle_insights => 'Percepções';

  @override
  String get lifestyle_journal => 'Diário';

  @override
  String get lifestyle_addJournalEntry => 'Adicionar Entrada de Diário';

  @override
  String get lifestyle_journalPrompt =>
      'Como você está experienciando seu design hoje?';

  @override
  String get lifestyle_noJournalEntries => 'Ainda sem entradas no diário';

  @override
  String get lifestyle_mood => 'Humor';

  @override
  String get lifestyle_energy => 'Nível de Energia';

  @override
  String get lifestyle_reflection => 'Reflexão';

  @override
  String get penta_title => 'Penta';

  @override
  String get penta_description => 'Análise de grupo para 3-5 pessoas';

  @override
  String get penta_createNew => 'Criar Penta';

  @override
  String get penta_selectMembers => 'Selecionar Membros';

  @override
  String get penta_minMembers => 'Mínimo de 3 membros necessário';

  @override
  String get penta_maxMembers => 'Máximo de 5 membros';

  @override
  String get penta_groupDynamics => 'Dinâmicas de Grupo';

  @override
  String get penta_missingRoles => 'Papéis Ausentes';

  @override
  String get penta_strengths => 'Forças do Grupo';

  @override
  String get penta_analysis => 'Análise Penta';

  @override
  String get penta_clearAnalysis => 'Limpar Análise';

  @override
  String get penta_infoText =>
      'A análise Penta revela os papéis naturais que emergem em pequenos grupos de 3-5 pessoas, mostrando como cada membro contribui para as dinâmicas da equipe.';

  @override
  String get penta_calculating => 'Calculando...';

  @override
  String get penta_calculate => 'Calcular Penta';

  @override
  String get penta_groupRoles => 'Papéis do Grupo';

  @override
  String get penta_electromagneticConnections => 'Conexões Eletromagnéticas';

  @override
  String get penta_connectionsDescription =>
      'Conexões energéticas especiais entre membros que criam atração e química.';

  @override
  String get penta_areasForAttention => 'Áreas de Atenção';

  @override
  String get composite_title => 'Mapa Composto';

  @override
  String get composite_infoText =>
      'Um mapa composto mostra as dinâmicas de relacionamento entre duas pessoas, revelando como seus mapas interagem e se complementam.';

  @override
  String get composite_selectTwoCharts => 'Selecione 2 Mapas';

  @override
  String get composite_calculate => 'Analisar Conexão';

  @override
  String get composite_calculating => 'Analisando...';

  @override
  String get composite_clearAnalysis => 'Limpar Análise';

  @override
  String get composite_connectionTheme => 'Tema da Conexão';

  @override
  String get composite_definedCenters => 'Definidos';

  @override
  String get composite_undefinedCenters => 'Abertos';

  @override
  String get composite_score => 'Pontuação';

  @override
  String get composite_themeVeryBonded =>
      'Conexão muito unida - vocês podem se sentir profundamente entrelaçados, o que pode ser intenso';

  @override
  String get composite_themeBonded =>
      'Conexão unida - forte senso de união e energia compartilhada';

  @override
  String get composite_themeBalanced =>
      'Conexão equilibrada - mistura saudável de união e independência';

  @override
  String get composite_themeIndependent =>
      'Conexão independente - mais espaço para crescimento individual';

  @override
  String get composite_themeVeryIndependent =>
      'Conexão muito independente - tempo de conexão intencional ajuda a fortalecer o vínculo';

  @override
  String get composite_electromagnetic => 'Canais Eletromagnéticos';

  @override
  String get composite_electromagneticDesc =>
      'Atração intensa - vocês se completam';

  @override
  String get composite_companionship => 'Canais de Companheirismo';

  @override
  String get composite_companionshipDesc =>
      'Conforto e estabilidade - compreensão compartilhada';

  @override
  String get composite_dominance => 'Canais de Dominância';

  @override
  String get composite_dominanceDesc => 'Um ensina/condiciona o outro';

  @override
  String get composite_compromise => 'Canais de Compromisso';

  @override
  String get composite_compromiseDesc => 'Tensão natural - requer consciência';

  @override
  String get composite_noConnections => 'Sem Conexões de Canal';

  @override
  String get composite_noConnectionsDesc =>
      'Estes mapas não formam conexões diretas de canal, mas ainda pode haver interações interessantes de portas.';

  @override
  String get composite_noChartsTitle => 'Nenhum Mapa Disponível';

  @override
  String get composite_noChartsDesc =>
      'Crie mapas para você e outros para comparar suas dinâmicas de relacionamento.';

  @override
  String get composite_needMoreCharts => 'Precisa de Mais Mapas';

  @override
  String get composite_needMoreChartsDesc =>
      'Você precisa de pelo menos 2 mapas para analisar um relacionamento. Adicione outro mapa para continuar.';

  @override
  String get composite_selectTwoHint =>
      'Selecione 2 mapas para analisar sua conexão';

  @override
  String get composite_selectOneMore => 'Selecione mais 1 mapa';

  @override
  String get premium_upgrade => 'Atualizar para Premium';

  @override
  String get premium_subscribe => 'Assinar';

  @override
  String get premium_restore => 'Restaurar Compras';

  @override
  String get premium_features => 'Recursos Premium';

  @override
  String get premium_unlimitedShares => 'Compartilhamento Ilimitado de Mapas';

  @override
  String get premium_groupCharts => 'Mapas de Grupo';

  @override
  String get premium_advancedTransits => 'Análise Avançada de Trânsitos';

  @override
  String get premium_personalizedAffirmations => 'Afirmações Personalizadas';

  @override
  String get premium_journalInsights => 'Percepções do Diário';

  @override
  String get premium_adFree => 'Experiência Sem Anúncios';

  @override
  String get premium_monthly => 'Mensal';

  @override
  String get premium_yearly => 'Anual';

  @override
  String get premium_perMonth => '/mês';

  @override
  String get premium_perYear => '/ano';

  @override
  String get premium_bestValue => 'Melhor Valor';

  @override
  String get settings_appearance => 'Aparência';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_selectLanguage => 'Selecionar Idioma';

  @override
  String get settings_changeLanguage => 'Alterar Idioma';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_selectTheme => 'Selecionar Tema';

  @override
  String get settings_chartDisplay => 'Exibição do Mapa';

  @override
  String get settings_showGateNumbers => 'Mostrar Números das Portas';

  @override
  String get settings_showGateNumbersSubtitle =>
      'Exibir números das portas no bodygraph';

  @override
  String get settings_use24HourTime => 'Usar Formato 24 Horas';

  @override
  String get settings_use24HourTimeSubtitle =>
      'Exibir hora no formato de 24 horas';

  @override
  String get settings_feedback => 'Feedback';

  @override
  String get settings_hapticFeedback => 'Feedback Tátil';

  @override
  String get settings_hapticFeedbackSubtitle => 'Vibração nas interações';

  @override
  String get settings_account => 'Conta';

  @override
  String get settings_changePassword => 'Alterar Senha';

  @override
  String get settings_deleteAccount => 'Excluir Conta';

  @override
  String get settings_deleteAccountConfirm =>
      'Tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita e todos os seus dados serão permanentemente excluídos.';

  @override
  String get settings_appVersion => 'Versão do App';

  @override
  String get settings_rateApp => 'Avaliar o App';

  @override
  String get settings_sendFeedback => 'Enviar Feedback';

  @override
  String get settings_themeLight => 'Claro';

  @override
  String get settings_themeDark => 'Escuro';

  @override
  String get settings_themeSystem => 'Sistema';

  @override
  String get settings_notifications => 'Notificações';

  @override
  String get settings_privacy => 'Privacidade';

  @override
  String get settings_chartVisibility => 'Visibilidade do Mapa';

  @override
  String get settings_chartVisibilitySubtitle =>
      'Controle quem pode ver seu mapa de Design Humano';

  @override
  String get settings_chartPrivate => 'Privado';

  @override
  String get settings_chartPrivateDesc => 'Apenas você pode ver seu mapa';

  @override
  String get settings_chartFriends => 'Amigos';

  @override
  String get settings_chartFriendsDesc =>
      'Seguidores mútuos podem ver seu mapa';

  @override
  String get settings_chartPublic => 'Público';

  @override
  String get settings_chartPublicDesc => 'Seus seguidores podem ver seu mapa';

  @override
  String get settings_about => 'Sobre';

  @override
  String get settings_help => 'Ajuda e Suporte';

  @override
  String get settings_terms => 'Termos de Serviço';

  @override
  String get settings_privacyPolicy => 'Política de Privacidade';

  @override
  String get settings_version => 'Versão';

  @override
  String get settings_dailyTransits => 'Trânsitos Diários';

  @override
  String get settings_dailyTransitsSubtitle =>
      'Receber atualizações diárias de trânsito';

  @override
  String get settings_gateChanges => 'Mudanças de Porta';

  @override
  String get settings_gateChangesSubtitle =>
      'Notificar quando o Sol muda de porta';

  @override
  String get settings_socialActivity => 'Atividade Social';

  @override
  String get settings_socialActivitySubtitle =>
      'Solicitações de amizade e mapas compartilhados';

  @override
  String get settings_achievements => 'Conquistas';

  @override
  String get settings_achievementsSubtitle =>
      'Desbloqueios de emblemas e marcos';

  @override
  String get settings_deleteAccountWarning =>
      'Isso irá excluir permanentemente todos os seus dados incluindo mapas, postagens e mensagens.';

  @override
  String get settings_deleteAccountFailed =>
      'Falha ao excluir conta. Por favor, tente novamente.';

  @override
  String get settings_passwordChanged => 'Senha alterada com sucesso';

  @override
  String get settings_passwordChangeFailed =>
      'Falha ao alterar senha. Por favor, tente novamente.';

  @override
  String get settings_feedbackSubject => 'Feedback do App Inside Me';

  @override
  String get settings_feedbackBody =>
      'Olá,\n\nGostaria de compartilhar o seguinte feedback sobre o Inside Me:\n\n';

  @override
  String get auth_newPassword => 'Nova Senha';

  @override
  String get auth_passwordRequired => 'Senha é obrigatória';

  @override
  String get auth_passwordTooShort => 'Senha deve ter pelo menos 8 caracteres';

  @override
  String get auth_passwordsDoNotMatch => 'Senhas não coincidem';

  @override
  String get settings_exportData => 'Exportar Meus Dados';

  @override
  String get settings_exportDataSubtitle =>
      'Baixar uma cópia de todos os seus dados (GDPR)';

  @override
  String get settings_exportingData => 'Preparando sua exportação de dados...';

  @override
  String get settings_exportDataSubject =>
      'Inside Me - Exportação dos Meus Dados';

  @override
  String get settings_exportDataFailed =>
      'Falha ao exportar dados. Por favor, tente novamente.';

  @override
  String get error_generic => 'Algo deu errado';

  @override
  String get error_network => 'Sem conexão com a internet';

  @override
  String get error_invalidEmail => 'Por favor, digite um e-mail válido';

  @override
  String get error_invalidPassword => 'Senha deve ter pelo menos 8 caracteres';

  @override
  String get error_passwordMismatch => 'Senhas não coincidem';

  @override
  String get error_birthDataRequired =>
      'Por favor, digite seus dados de nascimento';

  @override
  String get error_locationRequired =>
      'Por favor, selecione seu local de nascimento';

  @override
  String get error_chartCalculation => 'Não foi possível calcular seu mapa';

  @override
  String get profile_editProfile => 'Editar Perfil';

  @override
  String get profile_shareChart => 'Compartilhar Meu Mapa';

  @override
  String get profile_exportPdf => 'Exportar Mapa em PDF';

  @override
  String get profile_upgradePremium => 'Atualizar para Premium';

  @override
  String get profile_birthData => 'Dados de Nascimento';

  @override
  String get profile_chartSummary => 'Resumo do Mapa';

  @override
  String get profile_viewFullChart => 'Ver Mapa Completo';

  @override
  String get profile_signOut => 'Sair';

  @override
  String get profile_signOutConfirm => 'Tem certeza de que deseja sair?';

  @override
  String get profile_addBirthDataPrompt =>
      'Adicione seus dados de nascimento para gerar seu mapa de Design Humano.';

  @override
  String get profile_addBirthDataToShare =>
      'Adicione dados de nascimento para compartilhar seu mapa';

  @override
  String get profile_addBirthDataToExport =>
      'Adicione dados de nascimento para exportar seu mapa';

  @override
  String get profile_exportFailed => 'Falha ao exportar PDF';

  @override
  String get profile_signOutConfirmTitle => 'Sair';

  @override
  String get profile_loadFailed => 'Falha ao carregar perfil';

  @override
  String get profile_defaultUserName => 'Usuário Inside Me';

  @override
  String get profile_birthDate => 'Data';

  @override
  String get profile_birthTime => 'Hora';

  @override
  String get profile_birthLocation => 'Local';

  @override
  String get profile_birthTimezone => 'Fuso Horário';

  @override
  String get chart_chakras => 'Chakras';

  @override
  String get chakra_title => 'Energia dos Chakras';

  @override
  String get chakra_activated => 'Ativado';

  @override
  String get chakra_inactive => 'Inativo';

  @override
  String chakra_activatedCount(int count) {
    return '$count de 7 chakras ativados';
  }

  @override
  String get chakra_hdMapping => 'Mapeamento de Centro HD';

  @override
  String get chakra_element => 'Elemento';

  @override
  String get chakra_location => 'Localização';

  @override
  String get chakra_root => 'Raiz';

  @override
  String get chakra_root_sanskrit => 'Muladhara';

  @override
  String get chakra_root_description =>
      'Ancoragem, sobrevivência e estabilidade';

  @override
  String get chakra_sacral => 'Sacral';

  @override
  String get chakra_sacral_sanskrit => 'Svadhisthana';

  @override
  String get chakra_sacral_description => 'Criatividade, sexualidade e emoções';

  @override
  String get chakra_solarPlexus => 'Plexo Solar';

  @override
  String get chakra_solarPlexus_sanskrit => 'Manipura';

  @override
  String get chakra_solarPlexus_description =>
      'Poder pessoal, confiança e vontade';

  @override
  String get chakra_heart => 'Coração';

  @override
  String get chakra_heart_sanskrit => 'Anahata';

  @override
  String get chakra_heart_description => 'Amor, compaixão e conexão';

  @override
  String get chakra_throat => 'Garganta';

  @override
  String get chakra_throat_sanskrit => 'Vishuddha';

  @override
  String get chakra_throat_description => 'Comunicação, expressão e verdade';

  @override
  String get chakra_thirdEye => 'Terceiro Olho';

  @override
  String get chakra_thirdEye_sanskrit => 'Ajna';

  @override
  String get chakra_thirdEye_description => 'Intuição, percepção e imaginação';

  @override
  String get chakra_crown => 'Coroa';

  @override
  String get chakra_crown_sanskrit => 'Sahasrara';

  @override
  String get chakra_crown_description => 'Conexão espiritual e consciência';

  @override
  String get quiz_title => 'Quizzes';

  @override
  String get quiz_yourProgress => 'Seu Progresso';

  @override
  String quiz_quizzesCompleted(int count) {
    return '$count quizzes completados';
  }

  @override
  String get quiz_accuracy => 'Precisão';

  @override
  String get quiz_streak => 'Sequência';

  @override
  String get quiz_all => 'Todos';

  @override
  String get quiz_difficulty => 'Dificuldade';

  @override
  String get quiz_beginner => 'Iniciante';

  @override
  String get quiz_intermediate => 'Intermediário';

  @override
  String get quiz_advanced => 'Avançado';

  @override
  String quiz_questions(int count) {
    return '$count perguntas';
  }

  @override
  String quiz_points(int points) {
    return '+$points pts';
  }

  @override
  String get quiz_completed => 'Completado';

  @override
  String get quiz_noQuizzes => 'Nenhum quiz disponível';

  @override
  String get quiz_checkBackLater => 'Volte mais tarde para novo conteúdo';

  @override
  String get quiz_startQuiz => 'Iniciar Quiz';

  @override
  String get quiz_tryAgain => 'Tentar Novamente';

  @override
  String get quiz_backToQuizzes => 'Voltar aos Quizzes';

  @override
  String get quiz_shareResults => 'Compartilhar Resultados';

  @override
  String get quiz_yourBest => 'Seu Melhor';

  @override
  String get quiz_perfectScore => 'Pontuação Perfeita!';

  @override
  String get quiz_newBest => 'Novo Recorde!';

  @override
  String get quiz_streakExtended => 'Sequência Estendida!';

  @override
  String quiz_questionOf(int current, int total) {
    return 'Pergunta $current de $total';
  }

  @override
  String quiz_correct(int count) {
    return '$count corretas';
  }

  @override
  String get quiz_submitAnswer => 'Enviar Resposta';

  @override
  String get quiz_nextQuestion => 'Próxima Pergunta';

  @override
  String get quiz_seeResults => 'Ver Resultados';

  @override
  String get quiz_exitQuiz => 'Sair do Quiz?';

  @override
  String get quiz_exitWarning =>
      'Seu progresso será perdido se você sair agora.';

  @override
  String get quiz_exit => 'Sair';

  @override
  String get quiz_timesUp => 'Tempo Esgotado!';

  @override
  String get quiz_timesUpMessage =>
      'Você ficou sem tempo. Seu progresso será enviado.';

  @override
  String get quiz_excellent => 'Excelente!';

  @override
  String get quiz_goodJob => 'Bom Trabalho!';

  @override
  String get quiz_keepLearning => 'Continue Aprendendo!';

  @override
  String get quiz_keepPracticing => 'Continue Praticando!';

  @override
  String get quiz_masteredTopic => 'Você dominou este tópico!';

  @override
  String get quiz_strongUnderstanding => 'Você tem uma compreensão forte.';

  @override
  String get quiz_onRightTrack => 'Você está no caminho certo.';

  @override
  String get quiz_reviewExplanations => 'Revise as explicações para melhorar.';

  @override
  String get quiz_studyMaterial => 'Estude o material e tente novamente.';

  @override
  String get quiz_attemptHistory => 'Histórico de Tentativas';

  @override
  String get quiz_statistics => 'Estatísticas de Quiz';

  @override
  String get quiz_totalQuizzes => 'Quizzes';

  @override
  String get quiz_totalQuestions => 'Perguntas';

  @override
  String get quiz_bestStreak => 'Melhor Sequência';

  @override
  String quiz_strongest(String category) {
    return 'Mais forte: $category';
  }

  @override
  String quiz_needsWork(String category) {
    return 'Precisa trabalhar: $category';
  }

  @override
  String get quiz_category_types => 'Tipos';

  @override
  String get quiz_category_centers => 'Centros';

  @override
  String get quiz_category_authorities => 'Autoridades';

  @override
  String get quiz_category_profiles => 'Perfis';

  @override
  String get quiz_category_gates => 'Portas';

  @override
  String get quiz_category_channels => 'Canais';

  @override
  String get quiz_category_definitions => 'Definições';

  @override
  String get quiz_category_general => 'Geral';

  @override
  String get quiz_explanation => 'Explicação';

  @override
  String get quiz_quizzes => 'Quizzes';

  @override
  String get quiz_questionsLabel => 'Perguntas';

  @override
  String get quiz_shareProgress => 'Compartilhar Progresso';

  @override
  String get quiz_shareProgressSubject =>
      'Meu Progresso de Aprendizado de Design Humano';

  @override
  String get quiz_sharePerfect =>
      'Consegui uma pontuação perfeita! Estou dominando o Design Humano.';

  @override
  String get quiz_shareExcellent =>
      'Estou indo muito bem na minha jornada de aprendizado de Design Humano!';

  @override
  String get quiz_shareGoodJob =>
      'Estou aprendendo sobre Design Humano. Cada quiz me ajuda a crescer!';

  @override
  String quiz_shareSubject(String quizTitle, int score) {
    return 'Pontuei $score% em \"$quizTitle\" - Quiz de Design Humano';
  }

  @override
  String get quiz_failedToLoadStats => 'Falha ao carregar estatísticas';

  @override
  String get planetary_personality => 'Personalidade';

  @override
  String get planetary_design => 'Design';

  @override
  String get planetary_consciousBirth => 'Consciente · Nascimento';

  @override
  String get planetary_unconsciousPrenatal => 'Inconsciente · 88° Pré-natal';

  @override
  String get gamification_yourProgress => 'Seu Progresso';

  @override
  String get gamification_level => 'Nível';

  @override
  String get gamification_points => 'pts';

  @override
  String get gamification_viewAll => 'Ver Tudo';

  @override
  String get gamification_allChallengesComplete =>
      'Todos os desafios diários completos!';

  @override
  String get gamification_dailyChallenge => 'Desafio Diário';

  @override
  String get gamification_achievements => 'Conquistas';

  @override
  String get gamification_challenges => 'Desafios';

  @override
  String get gamification_leaderboard => 'Classificação';

  @override
  String get gamification_streak => 'Sequência';

  @override
  String get gamification_badges => 'Emblemas';

  @override
  String get gamification_earnedBadge => 'Você ganhou um emblema!';

  @override
  String get gamification_claimReward => 'Reclamar Recompensa';

  @override
  String get gamification_completed => 'Completado';

  @override
  String get common_copy => 'Copiar';

  @override
  String get share_myShares => 'Meus Compartilhamentos';

  @override
  String get share_createNew => 'Criar Novo';

  @override
  String get share_newLink => 'Novo Link';

  @override
  String get share_noShares => 'Sem Links Compartilhados';

  @override
  String get share_noSharesMessage =>
      'Crie links de compartilhamento para permitir que outros vejam seu mapa sem precisar de uma conta.';

  @override
  String get share_createFirst => 'Crie Seu Primeiro Link';

  @override
  String share_activeLinks(int count) {
    return '$count Links Ativos';
  }

  @override
  String share_expiredLinks(int count) {
    return '$count Expirados';
  }

  @override
  String get share_clearExpired => 'Limpar';

  @override
  String get share_clearExpiredTitle => 'Limpar Links Expirados';

  @override
  String share_clearExpiredMessage(int count) {
    return 'Isso removerá $count links expirados do seu histórico.';
  }

  @override
  String get share_clearAll => 'Limpar Tudo';

  @override
  String get share_expiredCleared => 'Links expirados removidos';

  @override
  String get share_linkCopied => 'Link copiado para área de transferência';

  @override
  String get share_revokeTitle => 'Revogar Link';

  @override
  String get share_revokeMessage =>
      'Isso desativará permanentemente este link de compartilhamento. Qualquer pessoa com o link não poderá mais ver seu mapa.';

  @override
  String get share_revoke => 'Revogar';

  @override
  String get share_linkRevoked => 'Link revogado';

  @override
  String get share_totalLinks => 'Total';

  @override
  String get share_active => 'Ativo';

  @override
  String get share_totalViews => 'Visualizações';

  @override
  String get share_chartLink => 'Compartilhamento de Mapa';

  @override
  String get share_transitLink => 'Compartilhamento de Trânsito';

  @override
  String get share_compatibilityLink => 'Relatório de Compatibilidade';

  @override
  String get share_link => 'Link de Compartilhamento';

  @override
  String share_views(int count) {
    return '$count visualizações';
  }

  @override
  String get share_expired => 'Expirado';

  @override
  String get share_activeLabel => 'Ativo';

  @override
  String share_expiredOn(String date) {
    return 'Expirado em $date';
  }

  @override
  String share_expiresIn(String time) {
    return 'Expira em $time';
  }

  @override
  String get auth_emailNotConfirmed => 'Por favor, confirme seu e-mail';

  @override
  String get auth_resendConfirmation => 'Reenviar E-mail de Confirmação';

  @override
  String get auth_confirmationSent => 'E-mail de confirmação enviado';

  @override
  String get auth_checkEmail =>
      'Verifique seu e-mail para o link de confirmação';

  @override
  String get auth_checkYourEmail => 'Verifique Seu E-mail';

  @override
  String get auth_confirmationLinkSent =>
      'Enviamos um link de confirmação para:';

  @override
  String get auth_clickLinkToActivate =>
      'Por favor, clique no link do e-mail para ativar sua conta.';

  @override
  String get auth_goToSignIn => 'Ir para Entrar';

  @override
  String get auth_returnToHome => 'Voltar ao Início';

  @override
  String get hashtags_explore => 'Explorar Hashtags';

  @override
  String get hashtags_trending => 'Em Alta';

  @override
  String get hashtags_popular => 'Popular';

  @override
  String get hashtags_hdTopics => 'Tópicos HD';

  @override
  String get hashtags_noTrending => 'Ainda sem hashtags em alta';

  @override
  String get hashtags_noPopular => 'Ainda sem hashtags populares';

  @override
  String get hashtags_noHdTopics => 'Ainda sem tópicos HD';

  @override
  String get hashtag_noPosts => 'Ainda sem postagens';

  @override
  String get hashtag_beFirst => 'Seja o primeiro a postar com esta hashtag!';

  @override
  String hashtag_postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postagens',
      one: '1 postagem',
    );
    return '$_temp0';
  }

  @override
  String hashtag_recentPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postagens hoje',
      one: '1 postagem hoje',
    );
    return '$_temp0';
  }

  @override
  String get feed_forYou => 'Para Você';

  @override
  String get feed_trending => 'Em Alta';

  @override
  String get feed_hdTopics => 'Tópicos HD';

  @override
  String feed_gateTitle(int number) {
    return 'Porta $number';
  }

  @override
  String feed_gatePosts(int number) {
    return 'Postagens sobre Porta $number';
  }

  @override
  String get transit_events_title => 'Eventos de Trânsito';

  @override
  String get transit_events_happening => 'Acontecendo Agora';

  @override
  String get transit_events_upcoming => 'Próximos';

  @override
  String get transit_events_past => 'Eventos Passados';

  @override
  String get transit_events_noCurrentEvents =>
      'Nenhum evento acontecendo agora';

  @override
  String get transit_events_noUpcomingEvents =>
      'Nenhum evento próximo agendado';

  @override
  String get transit_events_noPastEvents => 'Nenhum evento passado';

  @override
  String get transit_events_live => 'AO VIVO';

  @override
  String get transit_events_join => 'Participar';

  @override
  String get transit_events_joined => 'Participando';

  @override
  String get transit_events_leave => 'Sair';

  @override
  String get transit_events_participating => 'participando';

  @override
  String get transit_events_posts => 'postagens';

  @override
  String get transit_events_viewInsights => 'Ver Percepções';

  @override
  String transit_events_endsIn(String time) {
    return 'Termina em $time';
  }

  @override
  String transit_events_startsIn(String time) {
    return 'Começa em $time';
  }

  @override
  String get transit_events_notFound => 'Evento não encontrado';

  @override
  String get transit_events_communityPosts => 'Postagens da Comunidade';

  @override
  String get transit_events_noPosts => 'Ainda sem postagens para este evento';

  @override
  String get transit_events_shareExperience => 'Compartilhar Experiência';

  @override
  String get transit_events_participants => 'Participantes';

  @override
  String get transit_events_duration => 'Duração';

  @override
  String get transit_events_eventEnded => 'Este evento terminou';

  @override
  String get transit_events_youreParticipating => 'Você está participando!';

  @override
  String transit_events_experiencingWith(int count) {
    return 'Experienciando este trânsito com $count outros';
  }

  @override
  String get transit_events_joinCommunity => 'Participar da Comunidade';

  @override
  String get transit_events_shareYourExperience =>
      'Compartilhe sua experiência e conecte-se com outros';

  @override
  String get activity_title => 'Atividade de Amigos';

  @override
  String get activity_noActivities => 'Ainda sem atividade de amigos';

  @override
  String get activity_followFriends =>
      'Siga amigos para ver suas conquistas e marcos aqui!';

  @override
  String get activity_findFriends => 'Encontrar Amigos';

  @override
  String get activity_celebrate => 'Celebrar';

  @override
  String get activity_celebrated => 'Celebrado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Criar';

  @override
  String get groupChallenges_title => 'Desafios em Grupo';

  @override
  String get groupChallenges_myTeams => 'Minhas Equipes';

  @override
  String get groupChallenges_challenges => 'Desafios';

  @override
  String get groupChallenges_leaderboard => 'Classificação';

  @override
  String get groupChallenges_createTeam => 'Criar Equipe';

  @override
  String get groupChallenges_teamName => 'Nome da Equipe';

  @override
  String get groupChallenges_teamNameHint => 'Digite um nome de equipe';

  @override
  String get groupChallenges_teamDescription => 'Descrição';

  @override
  String get groupChallenges_teamDescriptionHint => 'Sobre o que é sua equipe?';

  @override
  String get groupChallenges_teamCreated => 'Equipe criada com sucesso!';

  @override
  String get groupChallenges_noTeams => 'Ainda Sem Equipes';

  @override
  String get groupChallenges_noTeamsDescription =>
      'Crie ou entre em uma equipe para competir em desafios em grupo!';

  @override
  String groupChallenges_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String groupChallenges_points(int points) {
    return '$points pts';
  }

  @override
  String get groupChallenges_noChallenges => 'Sem Desafios Ativos';

  @override
  String get groupChallenges_active => 'Ativo';

  @override
  String get groupChallenges_upcoming => 'Próximos';

  @override
  String groupChallenges_reward(int points) {
    return 'Recompensa de $points pts';
  }

  @override
  String groupChallenges_teamsEnrolled(String count) {
    return '$count equipes';
  }

  @override
  String groupChallenges_participants(String count) {
    return '$count participantes';
  }

  @override
  String groupChallenges_endsIn(String time) {
    return 'Termina em $time';
  }

  @override
  String get groupChallenges_weekly => 'Semanal';

  @override
  String get groupChallenges_monthly => 'Mensal';

  @override
  String get groupChallenges_allTime => 'Todos os Tempos';

  @override
  String get groupChallenges_noTeamsOnLeaderboard =>
      'Ainda sem equipes na classificação';

  @override
  String get groupChallenges_pts => 'pts';

  @override
  String get groupChallenges_teamNotFound => 'Equipe não encontrada';

  @override
  String get groupChallenges_members => 'Membros';

  @override
  String get groupChallenges_totalPoints => 'Pontos Totais';

  @override
  String get groupChallenges_joined => 'Participou';

  @override
  String get groupChallenges_join => 'Participar';

  @override
  String get groupChallenges_status => 'Status';

  @override
  String get groupChallenges_about => 'Sobre';

  @override
  String get groupChallenges_noMembers => 'Ainda sem membros';

  @override
  String get groupChallenges_admin => 'Administrador';

  @override
  String groupChallenges_contributed(int points) {
    return '$points pts contribuídos';
  }

  @override
  String get groupChallenges_joinedTeam => 'Entrou na equipe com sucesso!';

  @override
  String get groupChallenges_leaveTeam => 'Sair da Equipe';

  @override
  String get groupChallenges_leaveConfirmation =>
      'Tem certeza de que deseja sair desta equipe? Seus pontos contribuídos permanecerão com a equipe.';

  @override
  String get groupChallenges_leave => 'Sair';

  @override
  String get groupChallenges_leftTeam => 'Você saiu da equipe';

  @override
  String get groupChallenges_challengeDetails => 'Detalhes do Desafio';

  @override
  String get groupChallenges_challengeNotFound => 'Desafio não encontrado';

  @override
  String get groupChallenges_target => 'Meta';

  @override
  String get groupChallenges_starts => 'Começa';

  @override
  String get groupChallenges_ends => 'Termina';

  @override
  String get groupChallenges_hdTypes => 'Tipos HD';

  @override
  String get groupChallenges_noTeamsToEnroll => 'Sem Equipes para Inscrever';

  @override
  String get groupChallenges_createTeamToJoin =>
      'Crie uma equipe primeiro para se inscrever em desafios';

  @override
  String get groupChallenges_enrollTeam => 'Inscrever uma Equipe';

  @override
  String get groupChallenges_enrolled => 'Inscrito';

  @override
  String get groupChallenges_enroll => 'Inscrever';

  @override
  String get groupChallenges_teamEnrolled => 'Equipe inscrita com sucesso!';

  @override
  String get groupChallenges_noTeamsEnrolled => 'Ainda sem equipes inscritas';

  @override
  String get circles_title => 'Círculos de Compatibilidade';

  @override
  String get circles_myCircles => 'Meus Círculos';

  @override
  String get circles_invitations => 'Convites';

  @override
  String get circles_create => 'Criar Círculo';

  @override
  String get circles_selectIcon => 'Selecione um ícone';

  @override
  String get circles_name => 'Nome do Círculo';

  @override
  String get circles_nameHint => 'Família, Equipe, Amigos...';

  @override
  String get circles_description => 'Descrição';

  @override
  String get circles_descriptionHint => 'Para que serve este círculo?';

  @override
  String get circles_created => 'Círculo criado com sucesso!';

  @override
  String get circles_noCircles => 'Ainda Sem Círculos';

  @override
  String get circles_noCirclesDescription =>
      'Crie um círculo para analisar compatibilidade com amigos, família ou membros da equipe.';

  @override
  String get circles_suggestions => 'Início Rápido';

  @override
  String circles_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String get circles_private => 'Privado';

  @override
  String get circles_noInvitations => 'Sem Convites';

  @override
  String get circles_noInvitationsDescription =>
      'Convites de círculo que você receber aparecerão aqui.';

  @override
  String circles_invitedBy(String name) {
    return 'Convidado por $name';
  }

  @override
  String get circles_decline => 'Recusar';

  @override
  String get circles_accept => 'Aceitar';

  @override
  String get circles_invitationDeclined => 'Convite recusado';

  @override
  String get circles_invitationAccepted => 'Você entrou no círculo!';

  @override
  String get circles_notFound => 'Círculo não encontrado';

  @override
  String get circles_invite => 'Convidar Membro';

  @override
  String get circles_members => 'Membros';

  @override
  String get circles_analysis => 'Análise';

  @override
  String get circles_feed => 'Feed';

  @override
  String get circles_inviteMember => 'Convidar Membro';

  @override
  String get circles_sendInvite => 'Enviar Convite';

  @override
  String get circles_invitationSent => 'Convite enviado!';

  @override
  String get circles_invitationFailed => 'Falha ao enviar convite';

  @override
  String get circles_deleteTitle => 'Excluir Círculo';

  @override
  String circles_deleteConfirmation(String name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get circles_deleted => 'Círculo excluído';

  @override
  String get circles_noMembers => 'Ainda sem membros';

  @override
  String get circles_noAnalysis => 'Ainda Sem Análise';

  @override
  String get circles_runAnalysis =>
      'Execute uma análise de compatibilidade para ver como os membros do seu círculo interagem.';

  @override
  String get circles_needMoreMembers =>
      'Adicione pelo menos 2 membros para executar uma análise.';

  @override
  String get circles_analyzeCompatibility => 'Analisar Compatibilidade';

  @override
  String get circles_harmonyScore => 'Pontuação de Harmonia';

  @override
  String get circles_typeDistribution => 'Distribuição de Tipos';

  @override
  String get circles_electromagneticConnections => 'Conexões Eletromagnéticas';

  @override
  String get circles_electromagneticDesc =>
      'Atração intensa - vocês se completam';

  @override
  String get circles_companionshipConnections => 'Conexões de Companheirismo';

  @override
  String get circles_companionshipDesc =>
      'Conforto e estabilidade - compreensão compartilhada';

  @override
  String get circles_groupStrengths => 'Forças do Grupo';

  @override
  String get circles_areasForGrowth => 'Áreas de Crescimento';

  @override
  String get circles_writePost => 'Compartilhe algo com seu círculo...';

  @override
  String get circles_noPosts => 'Ainda Sem Postagens';

  @override
  String get circles_beFirstToPost =>
      'Seja o primeiro a compartilhar algo com seu círculo!';

  @override
  String get experts_title => 'Especialistas HD';

  @override
  String get experts_becomeExpert => 'Tornar-se Especialista';

  @override
  String get experts_filterBySpecialization => 'Filtrar por Especialização';

  @override
  String get experts_allExperts => 'Todos os Especialistas';

  @override
  String get experts_experts => 'Especialistas';

  @override
  String get experts_noExperts => 'Nenhum especialista encontrado';

  @override
  String get experts_featured => 'Especialistas em Destaque';

  @override
  String experts_followers(int count) {
    return '$count seguidores';
  }

  @override
  String get experts_notFound => 'Especialista não encontrado';

  @override
  String get experts_following => 'Seguindo';

  @override
  String get experts_follow => 'Seguir';

  @override
  String get experts_about => 'Sobre';

  @override
  String get experts_specializations => 'Especializações';

  @override
  String get experts_credentials => 'Credenciais';

  @override
  String get experts_reviews => 'Avaliações';

  @override
  String get experts_writeReview => 'Escrever Avaliação';

  @override
  String get experts_reviewContent => 'Sua Avaliação';

  @override
  String get experts_reviewHint =>
      'Compartilhe sua experiência trabalhando com este especialista...';

  @override
  String get experts_submitReview => 'Enviar Avaliação';

  @override
  String get experts_reviewSubmitted => 'Avaliação enviada com sucesso!';

  @override
  String get experts_noReviews => 'Ainda sem avaliações';

  @override
  String get experts_followersLabel => 'Seguidores';

  @override
  String get experts_rating => 'Avaliação';

  @override
  String get experts_years => 'Anos';

  @override
  String get learningPaths_title => 'Trilhas de Aprendizado';

  @override
  String get learningPaths_explore => 'Explorar';

  @override
  String get learningPaths_inProgress => 'Em Andamento';

  @override
  String get learningPaths_completed => 'Concluídos';

  @override
  String get learningPaths_featured => 'Trilhas em Destaque';

  @override
  String get learningPaths_allPaths => 'Todas as Trilhas';

  @override
  String get learningPaths_noPathsExplore =>
      'Nenhuma trilha de aprendizado disponível';

  @override
  String get learningPaths_noPathsInProgress => 'Nenhuma Trilha em Andamento';

  @override
  String get learningPaths_noPathsInProgressDescription =>
      'Inscreva-se em uma trilha de aprendizado para começar sua jornada!';

  @override
  String get learningPaths_browsePaths => 'Explorar Trilhas';

  @override
  String get learningPaths_noPathsCompleted => 'Nenhuma Trilha Concluída';

  @override
  String get learningPaths_noPathsCompletedDescription =>
      'Complete trilhas de aprendizado para vê-las aqui!';

  @override
  String learningPaths_enrolled(int count) {
    return '$count inscritos';
  }

  @override
  String learningPaths_stepsCount(int count) {
    return '$count etapas';
  }

  @override
  String learningPaths_progress(int completed, int total) {
    return '$completed de $total etapas';
  }

  @override
  String get learningPaths_resume => 'Retomar';

  @override
  String learningPaths_completedOn(String date) {
    return 'Concluído em $date';
  }

  @override
  String get learningPathNotFound => 'Trilha de aprendizado não encontrada';

  @override
  String learningPathMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String learningPathSteps(int count) {
    return '$count etapas';
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
    return '$count concluídos';
  }

  @override
  String get learningPathEnroll => 'Começar a Aprender';

  @override
  String get learningPathYourProgress => 'Seu Progresso';

  @override
  String get learningPathCompletedBadge => 'Concluído';

  @override
  String learningPathProgressText(int completed, int total) {
    return '$completed de $total etapas concluídas';
  }

  @override
  String get learningPathStepsTitle => 'Etapas de Aprendizado';

  @override
  String get learningPathEnrollTitle => 'Começar Esta Trilha?';

  @override
  String learningPathEnrollMessage(String title) {
    return 'Você será inscrito em \"$title\" e poderá acompanhar seu progresso conforme completa cada etapa.';
  }

  @override
  String get learningPathViewContent => 'Ver Conteúdo';

  @override
  String get learningPathMarkComplete => 'Marcar como Concluído';

  @override
  String get learningPathStepCompleted => 'Etapa concluída!';

  @override
  String get thought_title => 'Pensamentos';

  @override
  String get thought_feedTitle => 'Pensamentos';

  @override
  String get thought_createNew => 'Compartilhar um Pensamento';

  @override
  String get thought_emptyFeed => 'Seu feed de pensamentos está vazio';

  @override
  String get thought_emptyFeedMessage =>
      'Siga pessoas ou compartilhe um pensamento para começar';

  @override
  String get thought_regenerate => 'Regenerar';

  @override
  String thought_regeneratedFrom(String username) {
    return 'Regenerado de @$username';
  }

  @override
  String get thought_regenerateSuccess =>
      'Pensamento regenerado para seu mural!';

  @override
  String get thought_regenerateConfirm => 'Regenerar este pensamento?';

  @override
  String get thought_regenerateDescription =>
      'Isso compartilhará este pensamento em seu mural, creditando o autor original.';

  @override
  String get thought_addComment => 'Adicionar um comentário (opcional)';

  @override
  String thought_regenerateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count regenerações',
      one: '1 regeneração',
    );
    return '$_temp0';
  }

  @override
  String get thought_cannotRegenerateOwn =>
      'Você não pode regenerar seu próprio pensamento';

  @override
  String get thought_alreadyRegenerated => 'Você já regenerou este pensamento';

  @override
  String get thought_postDetail => 'Pensamento';

  @override
  String get thought_noComments =>
      'Ainda sem comentários. Seja o primeiro a comentar!';

  @override
  String thought_replyingTo(String username) {
    return 'Respondendo a $username';
  }

  @override
  String get thought_writeReply => 'Escrever uma resposta...';

  @override
  String get thought_commentPlaceholder => 'Adicionar um comentário...';

  @override
  String get messages_title => 'Mensagens';

  @override
  String get messages_conversation => 'Conversa';

  @override
  String get messages_loading => 'Carregando...';

  @override
  String get messages_muteNotifications => 'Silenciar Notificações';

  @override
  String get messages_notificationsMuted => 'Notificações silenciadas';

  @override
  String get messages_blockUser => 'Bloquear Usuário';

  @override
  String get messages_blockUserConfirm =>
      'Tem certeza de que deseja bloquear este usuário? Você não receberá mais mensagens dele.';

  @override
  String get messages_userBlocked => 'Usuário bloqueado';

  @override
  String get messages_block => 'Bloquear';

  @override
  String get messages_deleteConversation => 'Excluir Conversa';

  @override
  String get messages_deleteConversationConfirm =>
      'Tem certeza de que deseja excluir esta conversa? Esta ação não pode ser desfeita.';

  @override
  String get messages_conversationDeleted => 'Conversa excluída';

  @override
  String get messages_startConversation => 'Comece a conversa!';

  @override
  String get profile_takePhoto => 'Tirar Foto';

  @override
  String get profile_chooseFromGallery => 'Escolher da Galeria';

  @override
  String get profile_avatarUpdated => 'Avatar atualizado com sucesso';

  @override
  String get profile_profileUpdated => 'Perfil atualizado com sucesso';

  @override
  String get profile_noProfileFound => 'Nenhum perfil encontrado';

  @override
  String get discovery_title => 'Descobrir';

  @override
  String get discovery_searchUsers => 'Buscar usuários...';

  @override
  String get discovery_discoverTab => 'Descobrir';

  @override
  String get discovery_followingTab => 'Seguindo';

  @override
  String get discovery_followersTab => 'Seguidores';

  @override
  String get discovery_noUsersFound => 'Nenhum usuário encontrado';

  @override
  String get discovery_tryAdjustingFilters => 'Tente ajustar seus filtros';

  @override
  String get discovery_notFollowingAnyone => 'Não está seguindo ninguém';

  @override
  String get discovery_discoverPeople => 'Descubra pessoas para seguir';

  @override
  String get discovery_noFollowersYet => 'Ainda sem seguidores';

  @override
  String get discovery_shareInsights =>
      'Compartilhe suas percepções para ganhar seguidores';

  @override
  String get discovery_clearAll => 'Limpar tudo';

  @override
  String chart_gate(int number) {
    return 'Porta $number';
  }

  @override
  String chart_channel(String id) {
    return 'Canal $id';
  }

  @override
  String get chart_center => 'Centro';

  @override
  String get chart_keynote => 'Nota-chave';

  @override
  String get chart_element => 'Elemento';

  @override
  String get chart_location => 'Localização';

  @override
  String get chart_hdCenters => 'Centros HD';

  @override
  String get reaction_comment => 'Comentar';

  @override
  String get reaction_react => 'Reagir';

  @override
  String get reaction_standard => 'Padrão';

  @override
  String get reaction_humanDesign => 'Design Humano';

  @override
  String get share_shareChart => 'Compartilhar Mapa';

  @override
  String get share_createShareLink => 'Criar Link de Compartilhamento';

  @override
  String get share_shareViaUrl => 'Compartilhar via URL';

  @override
  String get share_exportAsPng => 'Exportar como PNG';

  @override
  String get share_fullReport => 'Relatório completo';

  @override
  String get share_linkExpiration => 'Expiração do Link';

  @override
  String get share_neverExpires => 'Nunca expira';

  @override
  String get share_oneHour => '1 hora';

  @override
  String get share_twentyFourHours => '24 horas';

  @override
  String get share_sevenDays => '7 dias';

  @override
  String get share_thirtyDays => '30 dias';

  @override
  String get share_creating => 'Criando...';

  @override
  String get share_signInToShare => 'Entre para compartilhar seu mapa';

  @override
  String get share_createShareableLinks =>
      'Crie links compartilháveis para seu mapa de Design Humano';

  @override
  String get share_linkImage => 'Imagem';

  @override
  String get share_pdf => 'PDF';

  @override
  String get post_share => 'Compartilhar';

  @override
  String get post_edit => 'Editar';

  @override
  String get post_report => 'Denunciar';

  @override
  String get mentorship_title => 'Mentoria';

  @override
  String get mentorship_pendingRequests => 'Solicitações Pendentes';

  @override
  String get mentorship_availableMentors => 'Mentores Disponíveis';

  @override
  String get mentorship_noMentorsAvailable => 'Nenhum mentor disponível';

  @override
  String mentorship_requestMentorship(String name) {
    return 'Solicitar Mentoria de $name';
  }

  @override
  String get mentorship_sendMessage =>
      'Envie uma mensagem explicando o que você gostaria de aprender:';

  @override
  String get mentorship_learnPrompt => 'Gostaria de aprender mais sobre...';

  @override
  String get mentorship_requestSent => 'Solicitação enviada!';

  @override
  String get mentorship_sendRequest => 'Enviar Solicitação';

  @override
  String get mentorship_becomeAMentor => 'Tornar-se um Mentor';

  @override
  String get mentorship_shareKnowledge =>
      'Compartilhe seu conhecimento de Design Humano';

  @override
  String get story_cancel => 'Cancelar';

  @override
  String get story_createStory => 'Criar História';

  @override
  String get story_share => 'Compartilhar';

  @override
  String get story_typeYourStory => 'Digite sua história...';

  @override
  String get story_background => 'Fundo';

  @override
  String get story_attachTransitGate => 'Anexar Porta de Trânsito (opcional)';

  @override
  String get story_none => 'Nenhum';

  @override
  String story_gateNumber(int number) {
    return 'Porta $number';
  }

  @override
  String get story_whoCanSee => 'Quem pode ver isso?';

  @override
  String get story_followers => 'Seguidores';

  @override
  String get story_everyone => 'Todos';

  @override
  String get challenges_title => 'Desafios';

  @override
  String get challenges_daily => 'Diário';

  @override
  String get challenges_weekly => 'Semanal';

  @override
  String get challenges_monthly => 'Mensal';

  @override
  String get challenges_noDailyChallenges => 'Nenhum desafio diário disponível';

  @override
  String get challenges_noWeeklyChallenges =>
      'Nenhum desafio semanal disponível';

  @override
  String get challenges_noMonthlyChallenges =>
      'Nenhum desafio mensal disponível';

  @override
  String get challenges_errorLoading => 'Erro ao carregar desafios';

  @override
  String challenges_claimedPoints(int points) {
    return 'Reclamou $points pontos!';
  }

  @override
  String get challenges_totalPoints => 'Pontos Totais';

  @override
  String get challenges_level => 'Nível';

  @override
  String get learning_all => 'Todos';

  @override
  String get learning_types => 'Tipos';

  @override
  String get learning_gates => 'Portas';

  @override
  String get learning_centers => 'Centros';

  @override
  String get learning_liveSessions => 'Sessões Ao Vivo';

  @override
  String get quiz_noActiveSession => 'Nenhuma sessão de quiz ativa';

  @override
  String get quiz_noQuestionsAvailable => 'Nenhuma pergunta disponível';

  @override
  String get quiz_ok => 'OK';

  @override
  String get liveSessions_title => 'Sessões Ao Vivo';

  @override
  String get liveSessions_upcoming => 'Próximas';

  @override
  String get liveSessions_mySessions => 'Minhas Sessões';

  @override
  String get liveSessions_errorLoading => 'Erro ao carregar sessões';

  @override
  String get liveSessions_registeredSuccessfully => 'Registrado com sucesso!';

  @override
  String get liveSessions_cancelRegistration => 'Cancelar Registro';

  @override
  String get liveSessions_cancelRegistrationConfirm =>
      'Tem certeza de que deseja cancelar seu registro?';

  @override
  String get liveSessions_no => 'Não';

  @override
  String get liveSessions_yesCancel => 'Sim, Cancelar';

  @override
  String get liveSessions_registrationCancelled => 'Registro cancelado';

  @override
  String get gateChannelPicker_gates => 'Portas (64)';

  @override
  String get gateChannelPicker_channels => 'Canais (36)';

  @override
  String get gateChannelPicker_search => 'Buscar portas ou canais...';

  @override
  String get leaderboard_weekly => 'Semanal';

  @override
  String get leaderboard_monthly => 'Mensal';

  @override
  String get leaderboard_allTime => 'Todos os Tempos';

  @override
  String get ai_chatTitle => 'Assistente IA';

  @override
  String get ai_askAi => 'Perguntar à IA';

  @override
  String get ai_askAboutChart => 'Pergunte à IA Sobre Seu Mapa';

  @override
  String get ai_miniDescription =>
      'Obtenha percepções personalizadas sobre seu Design Humano';

  @override
  String get ai_startChatting => 'Começar a conversar';

  @override
  String get ai_welcomeTitle => 'Seu Assistente HD';

  @override
  String get ai_welcomeSubtitle =>
      'Pergunte-me qualquer coisa sobre seu mapa de Design Humano. Posso explicar seu tipo, estratégia, autoridade, portas, canais e muito mais.';

  @override
  String get ai_inputPlaceholder => 'Pergunte sobre seu mapa...';

  @override
  String get ai_newConversation => 'Nova Conversa';

  @override
  String get ai_conversations => 'Conversas';

  @override
  String get ai_noConversations => 'Ainda sem conversas';

  @override
  String get ai_noConversationsMessage =>
      'Inicie uma conversa com a IA para obter percepções personalizadas do mapa.';

  @override
  String get ai_deleteConversation => 'Excluir Conversa';

  @override
  String get ai_deleteConversationConfirm =>
      'Tem certeza de que deseja excluir esta conversa?';

  @override
  String get ai_messagesExhausted => 'Mensagens Gratuitas Esgotadas';

  @override
  String get ai_upgradeForUnlimited =>
      'Atualize para Premium para conversas ilimitadas com IA sobre seu mapa de Design Humano.';

  @override
  String ai_usageCount(int used, int limit) {
    return '$used de $limit mensagens gratuitas usadas';
  }

  @override
  String get ai_errorGeneric => 'Algo deu errado. Por favor, tente novamente.';

  @override
  String get ai_errorNetwork =>
      'Não foi possível alcançar o serviço de IA. Verifique sua conexão.';

  @override
  String get events_title => 'Eventos da Comunidade';

  @override
  String get events_upcoming => 'Próximos';

  @override
  String get events_past => 'Passados';

  @override
  String get events_create => 'Criar Evento';

  @override
  String get events_noUpcoming => 'Nenhum evento próximo';

  @override
  String get events_noUpcomingMessage =>
      'Crie um evento para conectar-se com a comunidade HD!';

  @override
  String get events_online => 'Online';

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
  String get events_register => 'Registrar';

  @override
  String get events_registered => 'Registrado';

  @override
  String get events_cancelRegistration => 'Cancelar Registro';

  @override
  String get events_registrationFull => 'Evento Lotado';

  @override
  String get events_eventTitle => 'Título do Evento';

  @override
  String get events_eventDescription => 'Descrição';

  @override
  String get events_eventType => 'Tipo de Evento';

  @override
  String get events_startDate => 'Data e Hora de Início';

  @override
  String get events_endDate => 'Data e Hora de Término';

  @override
  String get events_location => 'Local';

  @override
  String get events_virtualLink => 'Link da Reunião Virtual';

  @override
  String get events_maxParticipants => 'Máximo de Participantes';

  @override
  String get events_hdTypeFilter => 'Filtro de Tipo HD';

  @override
  String get events_allTypes => 'Aberto para Todos os Tipos';

  @override
  String get events_created => 'Evento criado!';

  @override
  String get events_deleted => 'Evento excluído';

  @override
  String get events_notFound => 'Evento não encontrado';

  @override
  String get chartOfDay_title => 'Mapa do Dia';

  @override
  String get chartOfDay_featured => 'Mapa em Destaque';

  @override
  String get chartOfDay_viewChart => 'Ver Mapa';

  @override
  String get discussion_typeDiscussion => 'Discussão de Tipo';

  @override
  String get discussion_channelDiscussion => 'Discussão de Canal';

  @override
  String get ai_wantMoreInsights => 'Quer mais insights de AI?';

  @override
  String ai_messagesPackTitle(int count) {
    return '$count Mensagens';
  }

  @override
  String get ai_orSubscribe => 'ou assine para ilimitado';

  @override
  String get ai_bestValue => 'Melhor valor';

  @override
  String get ai_getMoreMessages => 'Obter mais mensagens';

  @override
  String ai_fromPrice(String price) {
    return 'A partir de $price';
  }

  @override
  String ai_perMessage(String price) {
    return '$price/mensagem';
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
