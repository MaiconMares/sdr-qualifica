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

### 2.2 Requisitos Não Funcionais (RNF)

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RNF-01 | Conformidade LGPD | Dados sensíveis (financeiros de inadimplência, gravações/registros de ligação, conversas) devem ter política de retenção, consentimento e exclusão sob a LGPD. | Elicitado |
| RNF-02 | Atualização em tempo real | Fila do Discador, status de disparo e novas mensagens em Chats devem refletir em tempo real na interface (Turbo Streams/Action Cable, dado o stack Hotwire já usado no projeto). | Elicitado |
| RNF-03 | Responsividade do Discador e Chats | Como SDRs podem operar fora da mesa (ex.: tablet), Discador e Chats devem ser utilizáveis em telas menores; demais módulos podem ser desktop-first. | Elicitado |
| RNF-04 | Limites por plano | Cada conta (Administrador) deve ter limites de uso associados a um plano de assinatura (nº de SDRs, volume de disparos, ligações), dado o modelo SaaS. | Elicitado |
| RNF-05 | Onboarding de integrações | Deve existir um fluxo guiado para uma nova conta configurar suas credenciais de WhatsApp/Instagram/Facebook na primeira vez que acessa Disparador/Chats. | Elicitado |
| RNF-06 | Exportação de relatórios | Dashboard e CRM devem permitir exportar dados (CSV) para análise externa. | Elicitado |

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

---

## Outros pontos

- O sistema não utiliza provedor VoIP. O sistema chama a aplicação "Vincular ao celular" que deve estar instalado no computador. Após ser chamado, o "Vincular ao celular" inicia a ligação automaticamente.
- Deve haver um painel para adicionar prompt, regras e restrições para cada agente. 
- O modelo de cobrança do SaaS não importa no momento. Isso será revisado posteriormente.