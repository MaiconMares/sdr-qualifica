# Plataforma de Vendas — Requisitos e Funcionalidades

## 1. Visão Geral

Plataforma SaaS multi-tenant que auxilia donos de academia a aumentar vendas, unificando em um só lugar: visão gerencial (Dashboard), gestão de leads (CRM), ligações (Discador), disparo em massa de WhatsApp (Disparador), atendimento multicanal (Chats) e automação por IA (Agentes).

**Perfis de usuário** (definido na elicitação):

| Papel | Escopo | Acesso a módulos |
|---|---|---|
| **Administrador Geral** | Dono da plataforma. Gerencia contas de academias (Administradores) e de seus SDRs: cria, bloqueia, remove. | Todos os módulos, de todas as contas. |
| **Administrador** | Dono/gestor de uma academia (tenant). Gerencia seus SDRs: cria, bloqueia, remove. | Dashboard, CRM, Discador, Disparador, Chats, Agentes (apenas da sua conta). |
| **SDR** | Opera vendas no dia a dia dentro da conta do Administrador que o gerencia. | CRM, Discador, Chats. |

Cada conta de Administrador (academia) tem **dados isolados**: leads, conversas, credenciais de integração, templates e configurações de agentes não são compartilhados entre academias.

---

## 2. Requisitos

`Origem`: **Informado** = veio do briefing do usuário · **Elicitado** = identificado nesta análise (parte validada com o usuário, parte inferida do sistema existente).

### 2.1 Requisitos Funcionais (RF)

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-01 | Dashboard consolidado | O Dashboard deve exibir dados relevantes de vendas agregando informações de todos os demais módulos (CRM, Discador, Disparador, Chats, Agentes). | Informado |
| RF-02 | Kanban de leads | O CRM deve mostrar o estado dos leads em formato Kanban (reaproveitando o Kanban já existente no Discador atual), permitindo mover leads entre colunas de status. | Informado |
| RF-03 | Ligar a partir do lead | Ao abrir o card de um lead no CRM, deve haver um link que abre o Discador já com aquele lead carregado e a ligação iniciada automaticamente. | Informado |
| RF-04 | Discagem automática | O Discador deve automatizar a ligação e permitir iniciar uma fila de ligação automática. | Informado |
| RF-05 | Script por faturamento | Durante a ligação, o Discador deve exibir o script de vendas adequado à faixa de faturamento (`revenue_range`) do lead. | Informado |
| RF-06 | Reestruturação do módulo Discador | Todas as telas do Discador (fila, ligação ativa, histórico, configuração de scripts, relatórios do módulo) devem ficar acessíveis dentro do próprio módulo, separadas dos demais itens da barra lateral — hoje o Discador só é visível para SDR e o Kanban só para Admin, sem uma navegação unificada. | Informado + Elicitado |
| RF-07 | Disparo de mensagens WhatsApp | O Disparador deve permitir enviar mensagens para uma lista de números via **API Oficial** (templates pré-aprovados, Meta Cloud API) ou via **API não oficial** (mensagens livres, Evolution API). | Informado |
| RF-08 | Integração com canais de chat | O sistema deve integrar as conversas de WhatsApp, Instagram e Facebook da academia em um módulo de Chats. | Informado |
| RF-09 | Agentes de IA | O sistema deve fornecer agentes de IA para: negociação de inadimplência, recuperação de visitantes que não fecharam, recuperação de ex-alunos e atendimento geral da academia. | Informado |
| RF-10 | Isolamento multi-tenant | Dados de leads, conversas, credenciais de integração e configurações devem ser isolados por conta (academia); nenhum dado de uma academia deve ser visível para outra. | Elicitado (validado) |
| RF-11 | Gestão de contas por Administrador Geral | O Administrador Geral pode criar, bloquear e remover contas de Administrador (academias). | Elicitado (validado) |
| RF-12 | Gestão de SDRs por Administrador | O Administrador pode criar, bloquear e remover SDRs vinculados à sua conta. | Elicitado (validado) |
| RF-13 | Controle de acesso por módulo | O acesso a cada módulo deve respeitar o papel do usuário (ver tabela de perfis na seção 1). | Elicitado (validado) |
| RF-14 | Credenciais de integração por conta | Cada conta deve configurar suas próprias credenciais (WhatsApp Cloud API, Evolution API/instância, Instagram, Facebook) — reaproveitando o padrão já usado no Disparador atual (Phone Number ID, Bearer Token, Business Account ID, URL/instância Evolution). | Elicitado (a partir do sistema existente) |
| RF-15 | Scripts configuráveis por faixa de faturamento | Deve existir um cadastro de scripts de vendas vinculado a cada `revenue_range`, editável pelo Administrador. | Elicitado |
| RF-16 | Fila respeita disponibilidade do SDR | A fila automática de discagem deve considerar o estado de sessão do SDR (em atendimento, pausado, disponível), reaproveitando `WorkSession`/`Pause` já existentes. | Elicitado |
| RF-17 | Registro de dados da ligação | Cada ligação deve registrar duração, resultado (atendeu/não atendeu), horário, lead e SDR responsável. | Informado + Elicitado |
| RF-18 | Regras anti-bloqueio no disparo | O Disparador (API não oficial) deve manter as regras de proteção já existentes: delay mínimo/máximo entre envios, embaralhamento de destinatários, variação de texto (spintax), limite de 50 números por disparo, e monitoramento em tempo real de status de entrega/leitura. | Elicitado (a partir do sistema existente) |
| RF-19 | Gestão de templates aprovados | O Disparador deve permitir cadastrar e selecionar templates aprovados pela Meta para uso via API Oficial. | Elicitado |
| RF-20 | Vínculo entre conversa e lead | Uma conversa em Chats deve poder ser associada ao card do lead correspondente no CRM. | Elicitado |
| RF-21 | Atribuição e status de conversas | Conversas em Chats devem poder ser atribuídas a um SDR e sinalizar mensagens não lidas. | Elicitado |
| RF-22 | Autonomia configurável dos Agentes | Cada Agente de IA deve operar de forma autônoma dentro de limites configuráveis pelo Administrador (ex.: desconto máximo, condições de renegociação); fora desses limites, a conversa deve escalar para um humano (SDR/Administrador). | Elicitado (validado) |
| RF-23 | Handoff Agente ↔ humano | Deve ser possível transferir uma conversa entre Agente de IA e atendente humano sem perda de contexto/histórico. | Elicitado |
| RF-24 | Histórico e auditoria dos Agentes | Toda conversa e ação tomada por um Agente (ex.: desconto oferecido, remarcação) deve ficar registrada para auditoria. | Elicitado |
| RF-25 | Auditoria administrativa | Ações administrativas (bloqueio/remoção de contas e usuários, alteração de configurações sensíveis) devem ser registradas, estendendo o `AuditLog` já existente aos novos módulos. | Elicitado (a partir do sistema existente) |
| RF-26 | Filtro de Dashboard por conta | Para o Administrador Geral, o Dashboard deve permitir selecionar/filtrar por conta (academia); para Administrador e SDR, o escopo é sempre a própria conta. | Elicitado |
| RF-27 | Importação de leads | O CRM deve manter a importação de leads via planilha já existente no sistema. | Elicitado (a partir do sistema existente) |
| RF-28 | Data de entrada do lead no card | O card do lead no Kanban do CRM deve exibir a data em que o lead entrou no sistema/etapa. | Informado |
| RF-29 | Alerta de SLA por tempo parado na etapa | Se um lead permanecer mais de 24 horas na mesma etapa sem avançar — principalmente nas duas primeiras etapas (sem contato / em contato) — o card deve ficar destacado em vermelho, sinalizando atraso no atendimento. | Informado |
| RF-30 | Tooltip explicativo das etapas do funil | Ao passar o mouse sobre o nome de cada etapa do Kanban, deve ser exibida uma explicação do que ela significa, reduzindo a necessidade de treinamento da equipe. | Informado |
| RF-31 | Campos adicionais do lead | Além de nome e telefone (únicos campos obrigatórios), o cadastro do lead deve permitir registrar e-mail, data de nascimento, profissão e motivo de procura da academia — este último como campo de seleção com lista pré-definida de 6 a 8 motivos (ex.: emagrecimento, ganho de massa muscular). | Informado |
| RF-32 | Cadastro manual de lead | Deve ser possível cadastrar um lead manualmente pelo CRM (nome, telefone, e-mail), além da importação em massa via planilha já prevista. | Informado |
| RF-33 | Ações rápidas no card do lead | A partir do card/detalhe do lead deve ser possível iniciar uma conversa de WhatsApp ou enviar um e-mail diretamente, sem sair da tela. | Informado |
| RF-34 | Registro de anotações no lead | O usuário deve poder registrar anotações livres sobre o lead, que ficam salvas na linha do tempo/histórico do card. | Informado |
| RF-35 | Agendamento de atividades futuras | O usuário deve poder criar atividades futuras vinculadas ao lead (ex.: ligação, e-mail), visíveis no histórico do card. | Informado |
| RF-36 | Dados ao mover lead para "Agendamento" | Ao mover um lead para a etapa de agendamento, o sistema deve solicitar o dia e o horário da visita/atendimento marcado. | Informado |
| RF-37 | Confirmação/lembrete automático de agendamento | Ao registrar um agendamento, o sistema deve disparar automaticamente uma mensagem lembrando o lead do compromisso marcado. | Informado |
| RF-38 | Agente de IA para confirmação de agendamento | Deve existir uma automação/agente de IA dedicado a confirmar agendamentos com o lead antes da data marcada, somando-se aos demais agentes já previstos (inadimplência, recuperação de visitantes, recuperação de ex-alunos, atendimento). | Informado (estende RF-09) |
| RF-39 | Classificação de temperatura da negociação | Ao mover um lead para a etapa "Negociando", o sistema deve solicitar a classificação da temperatura da negociação (ex.: quente/morno/frio). | Informado |
| RF-40 | Dados ao marcar lead como "Ganhou" | Ao mover um lead para "Ganhou", o sistema deve solicitar o valor total do plano fechado, orientando o usuário a informar o valor total do contrato (ex.: plano anual), e não apenas o valor de uma parcela. | Informado |
| RF-41 | Dados ao marcar lead como "Perdeu" | Ao mover um lead para "Perdeu", o sistema deve solicitar o valor do plano que estava sendo negociado e o motivo da perda. | Informado |
| RF-42 | Visão de visitas agendadas | Deve existir uma visão/relatório dedicado listando todos os leads com visita agendada (ex.: para o dia atual), ordenada por horário, para a recepção saber quem vai chegar e quando. | Informado |
| RF-43 | Tutorial guiado do CRM | O CRM deve contar com um tutorial/guia interativo explicando a jornada do lead pelas etapas do funil, acelerando o onboarding de novos usuários. | Informado |
| RF-44 | Documentação automática de ligações pela IA | Durante uma ligação feita pelo Discador, a IA deve transcrever/documentar automaticamente um resumo da chamada dentro do histórico do card do lead, sem depender do preenchimento manual do consultor. | Informado |
| RF-45 | Resumo automático de conversas de chat pela IA | O histórico de conversas de WhatsApp/Instagram/Facebook vinculado a um lead deve ser resumido automaticamente pela IA e mantido dentro do card do lead. | Informado |
| RF-46 | Transição automática de etapa por resultado de ligação | Dependendo do resultado registrado na ligação do Discador (ex.: contato feito e agendamento marcado), o CRM deve mover o lead automaticamente para a etapa correspondente, sem exigir ação manual do consultor. | Informado |
| RF-47 | Métrica de tempo até primeiro contato (Lead Time) | O sistema deve calcular e exibir o tempo médio entre a entrada do lead e o primeiro contato realizado, permitindo identificar atrasos que impactam a conversão. | Elicitado |
| RF-48 | Captura automática de leads via landing page/campanhas | Leads originados de landing pages ou campanhas de tráfego pago devem poder entrar automaticamente no funil do CRM, sem necessidade de cadastro manual pela recepção. | Elicitado (referência ao sistema concorrente mostrado na reunião) |
| RF-49 | Distribuição de leads para o Discador | Ao subir uma lista de leads (CSV/Excel, a partir de planilha-modelo fornecida pelo sistema), o Administrador deve poder optar entre dois modos de distribuição entre os consultores: (a) **distribuição igualitária** — mesma quantidade e mesmo potencial de faturamento por consultor; ou (b) **distribuição por performance/produtividade** — aloca mais leads aos consultores com melhor taxa de conversão histórica. | Informado |
| RF-50 | Liberação progressiva da distribuição por performance | O modo de distribuição por performance deve ficar indisponível até que haja histórico suficiente de operação com distribuição igualitária (período configurável, ex.: 1 mês); ao ser liberado, deve ser apresentado ao Administrador como uma nova funcionalidade. | Informado |
| RF-51 | Performance por consultor de vendas | O sistema deve exibir a performance de cada consultor de vendas (ex.: taxa de conversão, vendas fechadas), em aba própria e refletida também no Dashboard. | Informado |
| RF-52 | Módulo de premiação/gamificação | O sistema deve contar com um módulo de premiação que define recompensas periódicas (ex.: semanais) e exibe um ranking dos consultores mais bem posicionados no período, incentivando a competição saudável na equipe. | Informado |
| RF-53 | Nomenclatura de papel "Consultor de Vendas" | O papel referido tecnicamente como SDR deve ser exibido ao usuário final como "Consultor de Vendas" em toda a interface. | Informado |
| RF-54 | Ocultar seleção de perfil de acesso | O usuário não deve escolher nem ver o nome do seu perfil de acesso (Administrador Geral, Administrador, Consultor) na interface; a visão exibida é definida automaticamente pelo login. Onde houver filtros de visualização (ex.: "visualizando como"), as opções devem se limitar a papéis operacionais (Administrador e Consultores), sem expor a opção de Administrador Geral. | Informado |

### 2.2 Requisitos Não Funcionais (RNF)

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RNF-01 | Conformidade LGPD | Dados sensíveis (financeiros de inadimplência, gravações/registros de ligação, conversas) devem ter política de retenção, consentimento e exclusão sob a LGPD. | Elicitado |
| RNF-02 | Atualização em tempo real | Fila do Discador, status de disparo e novas mensagens em Chats devem refletir em tempo real na interface (Turbo Streams/Action Cable, dado o stack Hotwire já usado no projeto). | Elicitado |
| RNF-03 | Responsividade do Discador e Chats | Como SDRs podem operar fora da mesa (ex.: tablet), Discador e Chats devem ser utilizáveis em telas menores; demais módulos podem ser desktop-first. | Elicitado |
| RNF-04 | Limites por plano | Cada conta (Administrador) deve ter limites de uso associados a um plano de assinatura (nº de SDRs, volume de disparos, ligações), dado o modelo SaaS. | Elicitado |
| RNF-05 | Onboarding de integrações | Deve existir um fluxo guiado para uma nova conta configurar suas credenciais de WhatsApp/Instagram/Facebook na primeira vez que acessa Disparador/Chats. | Elicitado |
| RNF-06 | Exportação de relatórios | Dashboard e CRM devem permitir exportar dados (CSV) para análise externa. | Elicitado |
| RNF-07 | Integração futura com CRM de terceiros | Após a entrega da primeira versão da plataforma, deve ser avaliada a integração com o CRM atualmente utilizado pela Gestão Fitness (sistema de terceiros, em outra linguagem/stack), permitindo importar ou sincronizar dados. Baixa prioridade, pós-MVP. | Informado |

---

## 3. Funcionalidades por Módulo

Cada funcionalidade referencia os requisitos que a originam.

### 3.1 Dashboard

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-01 | Painel de KPIs de vendas | Cards com métricas-chave: vendas (R$), novas matrículas, leads ativos, taxa de conversão. | RF-01 |
| FT-02 | Gráfico de evolução de vendas | Gráfico de série temporal mostrando tendência de vendas no período selecionado. | RF-01 |
| FT-03 | Filtro de período | Seleção de intervalo de datas para todos os dados do Dashboard. | RF-01 |
| FT-04 | Seletor de conta (Admin Geral) | Dropdown para o Administrador Geral trocar entre contas/academias visualizadas. | RF-26 |
| FT-05 | Cards de resumo por módulo | Indicadores rápidos de CRM (leads por status), Discador (ligações do dia), Disparador (mensagens enviadas), Chats (conversas ativas) e Agentes (atendimentos automatizados). | RF-01 |
| FT-06 | Exportação de relatório | Botão para exportar os dados do Dashboard em CSV. | RNF-06 |
| FT-47 | Indicador de performance por consultor | Ranking/resumo de performance dos consultores de vendas refletido no Dashboard. | RF-51 |
| FT-48 | Métrica de Lead Time | Indicador do tempo médio até o primeiro contato de um lead. | RF-47 |

### 3.2 CRM

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-07 | Quadro Kanban de leads | Colunas por status do lead (reaproveitando os status já existentes: sem contato, tentativa, remarcado, agendado, desqualificado, excluído). | RF-02 |
| FT-08 | Arrastar e soltar entre colunas | Mover leads entre status via drag-and-drop (já implementado com SortableJS). | RF-02 |
| FT-09 | Card de lead detalhado | Nome, contato, faixa de faturamento, origem, SDR responsável. | RF-02 |
| FT-10 | Botão "Ligar agora" | No card do lead, abre o Discador com o lead carregado e inicia a ligação automaticamente. | RF-03 |
| FT-11 | Importação de leads via planilha | Upload de arquivo para importação em massa de leads. | RF-27 |
| FT-12 | Histórico de status do lead | Linha do tempo de mudanças de status do lead. | RF-02 |
| FT-13 | Vínculo com conversa de Chats | A partir do card do lead, acessar a conversa associada em Chats (e vice-versa). | RF-20 |
| FT-14 | Atribuição de lead a SDR | Definir/alterar o SDR responsável pelo lead. | RF-02 |
| FT-49 | Data de entrada no funil | Exibida no card do lead. | RF-28 |
| FT-50 | Alerta visual de SLA (24h) | Card fica destacado em vermelho se ultrapassar 24h parado na mesma etapa. | RF-29 |
| FT-51 | Tooltip de etapas do Kanban | Texto explicativo ao passar o mouse sobre o nome da etapa. | RF-30 |
| FT-52 | Campos estendidos do lead | E-mail, data de nascimento, profissão e motivo de procura (lista pré-definida) no cadastro do lead. | RF-31 |
| FT-53 | Cadastro manual de lead | Botão "Novo Cadastro" no CRM com formulário rápido (nome, telefone, e-mail). | RF-32 |
| FT-54 | Atalhos de contato no card | Botões para abrir conversa de WhatsApp e enviar e-mail direto do card do lead. | RF-33 |
| FT-55 | Anotações do lead | Campo de texto livre, salvo na linha do tempo do card. | RF-34 |
| FT-56 | Atividades futuras | Criação e visualização de atividades agendadas (ligação, e-mail etc.) na linha do tempo do lead. | RF-35 |
| FT-57 | Formulário de agendamento | Captura de dia/horário ao mover o lead para a etapa de agendamento. | RF-36 |
| FT-58 | Envio automático de lembrete de agendamento | Disparo automático de mensagem lembrando o lead do compromisso marcado. | RF-37 |
| FT-59 | Formulário de negociação | Captura da temperatura da negociação ao mover o lead para "Negociando". | RF-39 |
| FT-60 | Formulário de fechamento (Ganhou) | Captura do valor total do plano fechado. | RF-40 |
| FT-61 | Formulário de perda (Perdeu) | Captura do valor negociado e do motivo da perda. | RF-41 |
| FT-62 | Painel "Visitas agendadas" | Lista de leads com visita marcada, ordenada por horário. | RF-42 |
| FT-63 | Tutorial guiado do CRM | Passo a passo interativo explicando o funil ao novo usuário. | RF-43 |
| FT-64 | Documentação automática de ligação no card | Resumo da ligação gerado por IA e anexado ao histórico do lead. | RF-44 |
| FT-65 | Resumo automático de conversas no card | Resumo do histórico de chat gerado por IA e anexado ao card do lead. | RF-45 |
| FT-66 | Movimentação automática de etapa | Baseada no resultado da ligação registrado no Discador. | RF-46 |
| FT-67 | Captação automática de leads externos | Entrada automática de leads vindos de landing pages/campanhas de tráfego pago no funil do CRM. | RF-48 |
| FT-68 | Aba de performance de consultores | Métricas de conversão/vendas por consultor, dentro do próprio CRM. | RF-51 |

### 3.3 Discador

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-15 | Navegação unificada do módulo | Sub-navegação própria dentro de Discador (Fila/Ligação, Histórico, Scripts, Relatórios), independente da barra lateral principal. | RF-06 |
| FT-16 | Fila automática de discagem | Inicia e avança automaticamente pela fila de leads a ligar. | RF-04, RF-16 |
| FT-17 | Sessão de trabalho do SDR | Iniciar/pausar/retomar sessão (reaproveita `WorkSession`/`Pause`). | RF-16 |
| FT-18 | Exibição de script por faturamento | Mostra o script correspondente à `revenue_range` do lead durante a chamada. | RF-05, RF-15 |
| FT-19 | Registro de dados da ligação | Salva duração, resultado (atendeu/não atendeu) e horário de cada chamada. | RF-17 |
| FT-20 | Cadastro de scripts | Tela de administração para criar/editar scripts vinculados a faixas de faturamento. | RF-15 |
| FT-21 | Relatórios do módulo | Chamadas por SDR, taxa de atendimento, tempo médio, dentro do próprio módulo Discador. | RF-06 |
| FT-22 | Acesso do Administrador ao Discador | Administrador passa a visualizar/supervisionar o módulo (hoje restrito ao SDR). | RF-13 |
| FT-69 | Escolha do modo de distribuição de leads | Opção entre distribuição igualitária ou por performance ao subir uma lista de leads. | RF-49 |
| FT-70 | Liberação progressiva do modo por performance | Funcionalidade de distribuição por performance aparece automaticamente após período configurável de operação, como uma "nova funcionalidade". | RF-50 |

### 3.4 Disparador

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-23 | Envio via API Oficial | Disparo de templates pré-aprovados via Meta Cloud API para lista de números. | RF-07, RF-19 |
| FT-24 | Envio via API não oficial | Disparo de mensagens livres via Evolution API para lista de números. | RF-07 |
| FT-25 | Regras anti-bloqueio | Delay configurável, embaralhar destinatários, variação de texto (spintax), limite por lote. | RF-18 |
| FT-26 | Monitoramento em tempo real | Mensagens recebidas e atualizações de status (enviado/entregue/lido/falhou) ao vivo. | RF-18 |
| FT-27 | Histórico de disparos | Lista de mensagens enviadas com status individual. | RF-18 |
| FT-28 | Gestão de templates | Cadastro e seleção de templates aprovados pela Meta. | RF-19 |
| FT-29 | Configuração de credenciais | Tela para inserir/salvar Phone Number ID, Bearer Token, Business Account ID (Oficial) e URL/API Key/instância (Evolution), por conta. | RF-14 |

### 3.5 Chats

**Sugestão de organização:** em vez de apenas cards por canal (Whatsapp/Instagram/Facebook) isolados, recomenda-se uma **caixa de entrada unificada** com filtro por canal — assim o SDR não precisa navegar entre três telas separadas para responder. Os cards por canal ficam como *filtros/atalhos* no topo, mostrando contagem de não lidas por canal, mas a lista de conversas é única e cruza com o CRM (lead vinculado visível na conversa).

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-30 | Caixa de entrada unificada | Lista de conversas de todos os canais, com filtro por canal (Whatsapp/Instagram/Facebook). | RF-08 |
| FT-31 | Vínculo com lead do CRM | Exibe e permite associar o lead correspondente à conversa. | RF-20 |
| FT-32 | Atribuição e não lidas | Atribuir conversa a um SDR; indicador visual de mensagens não lidas. | RF-21 |
| FT-33 | Handoff Agente ↔ humano | Transferir a condução da conversa entre Agente de IA e SDR sem perder histórico. | RF-23 |
| FT-34 | Conexão de canais | Tela de configuração para conectar/desconectar contas de Whatsapp, Instagram e Facebook. | RF-14 |

### 3.6 Agentes

**Sugestão de organização:** manter os agentes como **cards ao entrar no módulo** (um por finalidade: Inadimplência, Recuperação de Visitantes, Recuperação de Ex-alunos, Atendimento), pois cada um tem configuração e métricas próprias — mas ao abrir um agente, mostrar suas conversas ativas dentro do mesmo painel de Chats (reaproveitando a caixa de entrada unificada, filtrada por "conduzido por este agente"), evitando duplicar a UI de conversa em dois módulos diferentes.

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-35 | Catálogo de agentes | Cards para os 4 agentes (Inadimplência, Recuperação de Visitantes, Recuperação de Ex-alunos, Atendimento), com status ativo/inativo. | RF-09 |
| FT-36 | Configuração de limites de autonomia | Definição de regras por agente (ex.: desconto máximo, condições de escalonamento). | RF-22 |
| FT-37 | Escalonamento para humano | Transferência automática da conversa quando a situação sai dos limites configurados. | RF-22 |
| FT-38 | Histórico e auditoria de ações | Registro de conversas e ações tomadas por cada agente. | RF-24 |
| FT-39 | Métricas por agente | Recuperações concluídas, negociações fechadas, taxa de conversão — alimenta o Dashboard. | RF-09 |
| FT-71 | Agente de confirmação de agendamento | Novo tipo de agente dedicado a confirmar agendamentos com o lead antes da data marcada. | RF-38 |

### 3.7 Administração e Contas (transversal)

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-40 | Gestão de contas (Admin Geral) | Criar, bloquear e remover contas de Administrador (academias). | RF-11 |
| FT-41 | Gestão de SDRs (Administrador) | Criar, bloquear e remover SDRs da própria conta. | RF-12 |
| FT-42 | Controle de acesso por papel | Aplicação das regras de visibilidade de módulo por papel (Admin Geral / Administrador / SDR). | RF-13 |
| FT-43 | Isolamento de dados por conta | Escopo de dados restrito à conta do usuário autenticado (exceto Admin Geral). | RF-10 |
| FT-44 | Gestão de plano/assinatura | Definição e acompanhamento de limites de uso por conta. | RNF-04 |
| FT-45 | Auditoria administrativa | Log de ações sensíveis (bloqueios, remoções, mudanças de configuração). | RF-25 |
| FT-46 | Onboarding de integrações | Fluxo guiado de configuração inicial das credenciais de canais. | RNF-05 |
| FT-72 | Renomeação de papel na interface | Exibir "Consultor de Vendas" no lugar de "SDR" em toda a interface voltada ao usuário final. | RF-53 |
| FT-73 | Seleção automática de visão por login | Visão do usuário definida pelo papel do login, sem seletor manual de perfil; filtros de "visualizar como" restritos a papéis operacionais (Administrador e Consultores). | RF-54 |

### 3.8 Gamificação / Premiação (módulo novo)

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-74 | Configuração de premiação | Administrador define recompensa e período de apuração (ex.: semanal). | RF-52 |
| FT-75 | Ranking de consultores | Exibição do ranking de consultores de vendas no período vigente. | RF-52 |

---

## Outros pontos

- O sistema não utiliza provedor VoIP. O sistema chama a aplicação "Vincular ao celular" que deve estar instalado no computador. Após ser chamado, o "Vincular ao celular" inicia a ligação automaticamente.
- Deve haver um painel para adicionar prompt, regras e restrições para cada agente. 
- O modelo de cobrança do SaaS não importa no momento. Isso será revisado posteriormente.
- No CRM entregue às academias, os leads representam pessoas interessadas em se matricular na academia (potenciais alunos), e não outras academias — os nomes de academia usados no protótipo mostrado na reunião de revisão do CRM foram apenas um exemplo ilustrativo do funil interno da própria Gestão Fitness, para não confundir com o produto entregue ao cliente final.
- O sistema não faz controle de acesso físico, controle de catraca ou controle de treino dos alunos da academia; é exclusivamente um sistema de vendas/funil comercial (CRM + Discador + Disparador + Chats + Agentes).
- Foi discutida e descartada, por ora, a criação de permissões granulares por sub-papel (ex.: gerente/supervisor com acesso limitado dentro da conta do Administrador); os stakeholders decidiram não implementar esse nível de granularidade nesta fase.
- A entrega seguirá abordagem iterativa por módulo (MVP por módulo, com melhorias incrementais); a priorização final de funcionalidades dentro de cada módulo será refinada e validada em reunião futura.