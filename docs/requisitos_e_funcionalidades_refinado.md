# Plataforma de Vendas — Requisitos e Funcionalidades (Revisão)

> Este documento substitui e refina `requisitos_e_funcionalidades.md`, incorporando os pontos de revisão levantados após a primeira elicitação: requisitos genéricos foram detalhados, épicos foram quebrados em requisitos menores, duplicidades entre requisito/funcionalidade foram eliminadas, requisitos inviáveis foram removidos e associações erradas entre requisito e funcionalidade foram corrigidas. Toda a numeração (RF, RNF, FT) foi refeita nesta versão e **não corresponde** à numeração do documento original.

## 1. Visão Geral

Plataforma SaaS multi-tenant que auxilia donos de academia a aumentar vendas, unificando em um só lugar: visão gerencial (Dashboard), gestão de leads (CRM), ligações (Discador), disparo em massa de WhatsApp (Disparador), atendimento multicanal (Chats), automação por IA (Agentes) e premiação da equipe (Gamificação).

**Nota de terminologia:** o **CRM** é o módulo de gestão de leads como um todo (cadastro, histórico, relatórios, tutorial etc.). O **Kanban** é apenas a funcionalidade de visualização do funil em colunas dentro do CRM. Os dois termos não são sinônimos e não devem ser usados de forma intercambiável ao longo deste documento.

**Perfis de usuário** (definido na elicitação):

| Papel | Escopo | Acesso a módulos |
|---|---|---|
| **Administrador Geral** | Dono da plataforma. Gerencia contas de academias (Administradores) e, quando necessário, também gerencia diretamente os SDRs de qualquer conta: cria, bloqueia, remove. | Todos os módulos, de todas as contas. |
| **Administrador** | Dono/gestor de uma academia (tenant). Gerencia seus SDRs: cria, bloqueia, remove. | Dashboard, CRM, Discador, Disparador, Chats, Agentes, Gamificação (apenas da sua conta). |
| **SDR** | Opera vendas no dia a dia dentro da conta do Administrador que o gerencia. | CRM, Discador, Chats. |

Cada conta de Administrador (academia) tem **dados isolados**: leads, conversas, credenciais de integração, templates e configurações de agentes não são compartilhados entre academias.

Não há permissões granulares por sub-papel (ex.: gerente/supervisor com acesso limitado dentro da conta do Administrador) — isso foi discutido e descartado, por ora, pelos stakeholders.

---

## 2. Requisitos

`Origem`: **Informado** = veio do briefing/reunião com o usuário · **Elicitado** = identificado nesta análise.

### 2.1 Requisitos Funcionais (RF)

#### Dashboard

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-01 | Indicadores-chave de vendas | O Dashboard deve exibir os KPIs: vendas totais (R$) no período, novas matrículas, leads ativos e taxa de conversão geral. | Informado + Elicitado |
| RF-02 | Evolução de vendas | O Dashboard deve exibir um gráfico de série temporal mostrando a tendência de vendas no período selecionado. | Elicitado |
| RF-03 | Filtro de período do Dashboard | O Dashboard deve permitir selecionar um intervalo de datas, aplicado a todos os indicadores exibidos. | Elicitado |
| RF-04 | Resumo por módulo no Dashboard | O Dashboard deve exibir cards de resumo com um indicador relevante de cada módulo: CRM (quantidade de leads por status), Discador (ligações realizadas no dia), Disparador (mensagens enviadas no dia), Chats (conversas ativas/não lidas) e Agentes (atendimentos automatizados no dia). | Informado + Elicitado |
| RF-05 | Filtro de Dashboard por conta | Para o Administrador Geral, o Dashboard deve permitir selecionar/filtrar por conta (academia); para Administrador e SDR, o escopo é sempre a própria conta. | Elicitado |

#### CRM (inclui o Kanban)

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-06 | Kanban de status dos leads | O CRM deve exibir o funil de vendas como um quadro Kanban, com colunas representando os status do lead (sem contato, tentativa, remarcado, agendado, negociando, ganhou, perdeu, desqualificado, excluído), reaproveitando os status já existentes. | Informado |
| RF-07 | Movimentação de leads entre etapas | O usuário deve poder mover um lead entre colunas do Kanban por arrastar e soltar, atualizando o status do lead. | Informado |
| RF-08 | Informações resumidas no card do Kanban | Cada card do Kanban deve exibir, sem necessidade de abrir o detalhe do lead: nome, contato, faixa de faturamento, origem e SDR responsável. | Informado |
| RF-09 | Histórico de mudanças de status | O sistema deve manter uma linha do tempo das mudanças de status de cada lead através do Kanban. | Elicitado |
| RF-10 | Ligar a partir do card do lead | Ao abrir o card de um lead no CRM, deve haver um link que abre o Discador já com aquele lead carregado e a ligação iniciada automaticamente. | Informado |
| RF-11 | Importação de leads via planilha | O CRM deve manter a importação de leads via planilha já existente no sistema, e o sistema deve fornecer um modelo de planilha (template) para orientar o formato esperado da importação. | Elicitado (a partir do sistema existente) + Elicitado |
| RF-12 | Cadastro manual de lead | Deve ser possível cadastrar um lead manualmente pelo CRM, preenchendo os campos definidos no requisito de dados cadastrais do lead (RF-13), além da importação em massa via planilha (RF-11). | Informado |
| RF-13 | Dados cadastrais do lead | O cadastro do lead tem como campos obrigatórios nome e telefone. Campos opcionais: e-mail, data de nascimento, profissão e motivo de procura da academia (campo de seleção com lista pré-definida de 6 a 8 motivos, ex.: emagrecimento, ganho de massa muscular). A data de entrada do lead no sistema deve ser registrada automaticamente, sem preenchimento manual, e exibida no card do Kanban. | Informado |
| RF-14 | Alerta de SLA por tempo parado na etapa | Se um lead permanecer mais de 24 horas na mesma etapa sem avançar — principalmente nas duas primeiras etapas (sem contato / em contato) — o card deve ficar destacado em vermelho, sinalizando atraso no atendimento. | Informado |
| RF-15 | Tooltip explicativo das etapas do funil | Ao passar o mouse sobre o nome de cada etapa do Kanban, deve ser exibida uma explicação do que ela significa, reduzindo a necessidade de treinamento da equipe. | Informado |
| RF-16 | Ações rápidas no card do lead | A partir do card/detalhe do lead deve ser possível iniciar uma conversa de WhatsApp (selecionando um template aprovado, já que o envio por WhatsApp é restrito à API Oficial) ou enviar um e-mail com conteúdo livre, sem sair da tela. | Informado |
| RF-17 | Registro de anotações no lead | O usuário deve poder registrar anotações livres sobre o lead, salvas na linha do tempo/histórico do card. | Informado |
| RF-18 | Agendamento de atividades futuras | O usuário deve poder criar atividades futuras vinculadas ao lead, dos tipos ligação, e-mail, reunião/visita ou tarefa genérica, cada uma com data/horário e lembrete opcional; as atividades ficam visíveis no histórico do card. | Informado + Elicitado |
| RF-19 | Dados ao mover lead para "Agendamento" | Ao mover um lead para a etapa de agendamento, o sistema deve solicitar o dia e o horário da visita/atendimento marcado. | Informado |
| RF-20 | Confirmação/lembrete automático de agendamento | Ao registrar um agendamento, o sistema deve disparar automaticamente uma mensagem lembrando o lead do compromisso marcado, via WhatsApp (usando template aprovado) ou e-mail (conteúdo livre). | Informado + Elicitado |
| RF-21 | Classificação de temperatura da negociação | Ao mover um lead para a etapa "Negociando", o sistema deve solicitar a classificação da temperatura da negociação (ex.: quente/morno/frio). | Informado |
| RF-22 | Dados ao marcar lead como "Ganhou" | Ao mover um lead para "Ganhou", o sistema deve solicitar o valor total do plano fechado (ex.: valor total do contrato anual, e não apenas o valor de uma parcela). | Informado |
| RF-23 | Dados ao marcar lead como "Perdeu" | Ao mover um lead para "Perdeu", o sistema deve solicitar o valor do plano que estava sendo negociado e o motivo da perda. | Informado |
| RF-24 | Visão de visitas agendadas | Deve existir uma visão/relatório dedicado listando todos os leads com visita agendada (ex.: para o dia atual), ordenada por horário, para a recepção saber quem vai chegar e quando. | Informado |
| RF-25 | Tutorial guiado do CRM | O CRM deve contar com um tour interativo (sobreposição de telas) explicando a jornada do lead pelas etapas do Kanban, exibido no primeiro acesso do usuário e reexecutável a qualquer momento. Viabilidade confirmada: implementável com bibliotecas de tour de UI já maduras, sem dependências externas complexas. | Informado |
| RF-26 | Documentação automática de ligações pela IA | Durante uma ligação feita pelo Discador, a IA deve transcrever/documentar automaticamente um resumo da chamada no histórico do card do lead, sem depender de preenchimento manual do consultor. Viabilidade condicionada à captura de áudio da ligação: como o sistema não usa provedor VoIP e a chamada é feita pelo aplicativo "Vincular ao Celular" no aparelho/computador do SDR, o acesso ao áudio para transcrição precisa ser validado tecnicamente antes da implementação. Prioridade baixa, pós-MVP. | Informado |
| RF-27 | Resumo automático de conversas de chat pela IA | O histórico de conversas de WhatsApp/Instagram/Facebook vinculado a um lead deve ser resumido automaticamente pela IA e mantido no card do lead. | Informado |
| RF-28 | Transição automática de etapa por resultado de ligação | Dependendo do resultado registrado na ligação do Discador (ex.: contato feito e agendamento marcado), o CRM deve mover o lead automaticamente para a etapa correspondente, sem exigir ação manual do consultor. | Informado |
| RF-29 | Métrica de tempo até primeiro contato (Lead Time) | O sistema deve calcular e exibir o tempo médio entre a entrada do lead e o primeiro contato realizado, permitindo identificar atrasos que impactam a conversão. | Elicitado |
| RF-30 | Performance por consultor de vendas | O sistema deve exibir a performance de cada consultor com base nas métricas: taxa de conversão (leads → matrícula), número de ligações realizadas, número de agendamentos marcados, taxa de comparecimento a agendamentos, número de vendas fechadas e valor total vendido no período. Exibido em aba própria no CRM e refletido também no Dashboard. | Informado + Elicitado |

#### Discador

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-31 | Discagem automática via "Vincular ao Celular" | O Discador deve permitir iniciar uma fila automática de discagem que, para cada lead da fila, aciona o aplicativo "Vincular ao Celular" instalado no computador do SDR, iniciando a ligação automaticamente, sem discagem manual do número. O sistema não utiliza provedor VoIP. | Informado |
| RF-32 | Script de vendas por faixa de faturamento | Durante a ligação, o Discador deve exibir o script de vendas adequado à faixa de faturamento (`revenue_range`) do lead. | Informado |
| RF-33 | Navegação própria do módulo Discador | O Discador deve ter navegação própria dentro do módulo (Fila, Ligação Ativa, Histórico, Scripts, Relatórios), separada da barra lateral principal da plataforma. | Informado + Elicitado |
| RF-34 | Fila de ligações | O Discador deve disponibilizar uma tela de fila, listando os leads a serem discados em sequência conforme o modo de distribuição definido (RF-40) e a disponibilidade do SDR (RF-39). | Informado + Elicitado |
| RF-35 | Registro de dados da ligação | Cada ligação deve registrar duração, resultado (atendeu/não atendeu), horário, lead e SDR responsável, disponível na tela de ligação ativa e no histórico do módulo. | Informado + Elicitado |
| RF-36 | Cadastro de scripts por faixa de faturamento | Deve existir uma tela de administração para criar e editar scripts de vendas vinculados a cada `revenue_range`, editável pelo Administrador. | Elicitado |
| RF-37 | Relatórios do módulo Discador | O Discador deve disponibilizar relatórios com: total de ligações por SDR, taxa de atendimento, tempo médio de ligação, taxa de conversão em agendamento e ranking de SDRs por volume/resultado de ligações. | Informado + Elicitado |
| RF-38 | Acesso de Administrador e SDR ao Discador | O módulo Discador deve ser acessível tanto pelo SDR (operação) quanto pelo Administrador (supervisão), unificando a visibilidade hoje restrita apenas ao SDR. | Informado + Elicitado |
| RF-39 | Fila respeita disponibilidade do SDR | A fila automática de discagem deve considerar o estado de sessão do SDR (em atendimento, pausado, disponível), reaproveitando `WorkSession`/`Pause` já existentes. | Elicitado |
| RF-40 | Distribuição de leads entre consultores | Ao subir uma lista de leads (CSV/Excel, a partir da planilha-modelo do RF-11), o Administrador deve poder distribuir os leads entre os consultores de duas formas: (a) distribuição igualitária — mesma quantidade e mesmo potencial de faturamento por consultor; ou (b) definição manual da quantidade de leads por consultor, podendo o sistema sugerir uma distribuição baseada na capacidade e no desempenho histórico (taxa de conversão) de cada consultor, com o Administrador sempre podendo ajustar os valores finais antes de confirmar. | Informado + Elicitado |

#### Disparador

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-41 | Disparo de mensagens WhatsApp | O Disparador deve permitir enviar mensagens em massa para uma lista de números via API Oficial do WhatsApp (Meta Cloud API), utilizando templates pré-aprovados pela Meta. | Informado |
| RF-42 | Credenciais de integração por conta | Cada conta deve configurar suas próprias credenciais de integração: WhatsApp Cloud API (Phone Number ID, Bearer Token, Business Account ID), Instagram e Facebook. | Elicitado (a partir do sistema existente) |
| RF-43 | Monitoramento em tempo real do disparo | O Disparador deve monitorar em tempo real o status de entrega e leitura das mensagens enviadas. | Elicitado |
| RF-44 | Seleção de templates aprovados | O Disparador deve permitir selecionar, entre os templates já aprovados pela Meta, qual será utilizado em cada disparo. O cadastro/criação de novos templates é feito diretamente no Meta Business Manager, fora do sistema. | Elicitado |

#### Chats

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-45 | Integração com canais de chat | O sistema deve integrar as conversas de WhatsApp, Instagram e Facebook da academia em um módulo de Chats. | Informado |
| RF-46 | Vínculo entre conversa e lead | Uma conversa em Chats deve poder ser associada ao card do lead correspondente no CRM. | Elicitado |
| RF-47 | Atribuição exclusiva de conversas | Cada conversa em Chats deve ser atribuída a um único SDR por vez (atribuição exclusiva), podendo ser reatribuída a outro SDR quando necessário. O sistema deve identificar e exibir claramente qual SDR está conduzindo cada conversa, além de sinalizar mensagens não lidas. | Elicitado (validado) |

#### Agentes de IA

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-48 | Agentes de IA | O sistema deve fornecer agentes de IA para: negociação de inadimplência, recuperação de visitantes que não fecharam, recuperação de ex-alunos e atendimento geral da academia. | Informado |
| RF-49 | Agente de confirmação de agendamento | Deve existir um agente de IA dedicado a confirmar agendamentos com o lead antes da data marcada, somando-se aos demais agentes do RF-48. | Informado (estende RF-48) |
| RF-50 | Limites configuráveis de autonomia dos agentes | Cada Agente de IA deve operar de forma autônoma dentro de limites configuráveis pelo Administrador: desconto máximo permitido, valor mínimo aceitável em renegociação, condições que autorizam renegociação e número máximo de tentativas/interações antes de escalonar. Fora desses limites, a conversa deve escalar automaticamente para um humano (RF-51). | Elicitado (validado) |
| RF-51 | Handoff Agente ↔ humano | Deve ser possível transferir uma conversa entre Agente de IA e atendente humano sem perda de contexto/histórico. | Elicitado |
| RF-52 | Histórico e auditoria dos Agentes | Toda conversa e ação tomada por um Agente (ex.: desconto oferecido, remarcação) deve ficar registrada para auditoria. | Elicitado |

#### Administração e Contas

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-53 | Isolamento multi-tenant | Dados de leads, conversas, credenciais de integração e configurações devem ser isolados por conta (academia); nenhum dado de uma academia deve ser visível para outra. | Elicitado (validado) |
| RF-54 | Gestão de contas por Administrador Geral | O Administrador Geral pode criar, bloquear e remover contas de Administrador (academias) e, quando necessário, também criar, bloquear e remover SDRs de qualquer conta. | Elicitado (validado) |
| RF-55 | Gestão de SDRs por Administrador | O Administrador pode criar, bloquear e remover SDRs vinculados à sua conta. | Elicitado (validado) |
| RF-56 | Controle de acesso por módulo | O acesso a cada módulo deve respeitar o papel do usuário: Administrador Geral acessa todos os módulos de todas as contas; Administrador acessa Dashboard, CRM, Discador, Disparador, Chats, Agentes e Gamificação da própria conta, incluindo a gestão de SDRs; SDR acessa CRM, Discador e Chats da própria conta, sem acesso a configurações administrativas (credenciais, limites de agentes, gestão de usuários). Não há permissões granulares por sub-papel nesta fase. | Elicitado (validado) |
| RF-57 | Auditoria administrativa | Ações administrativas (bloqueio/remoção de contas e usuários, alteração de configurações sensíveis) devem ser registradas, estendendo o `AuditLog` já existente aos novos módulos. | Elicitado (a partir do sistema existente) |

#### Gamificação

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RF-58 | Módulo de premiação/gamificação | O sistema deve definir, por período configurável (ex.: semanal), um ranking dos consultores com base nas métricas de performance (RF-30). A recompensa de cada período é definida pelo Administrador como texto livre (ex.: "day-off", "bônus X"); o sistema não processa nem entrega fisicamente/financeiramente a recompensa, apenas registra e exibe o que foi definido e o ranking correspondente. | Informado |

### 2.2 Requisitos Não Funcionais (RNF)

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
| RNF-01 | Conformidade LGPD | Dados sensíveis — dados pessoais do lead (nome, telefone, e-mail, data de nascimento, profissão), dados financeiros de inadimplência de alunos, gravações/transcrições de ligações, histórico de conversas (WhatsApp/Instagram/Facebook), valores de planos/contratos fechados e credenciais de integração — devem ter política de retenção, consentimento e exclusão sob a LGPD. | Elicitado |
| RNF-02 | Atualização em tempo real | Devem refletir em tempo real na interface (Turbo Streams/Action Cable, dado o stack Hotwire já usado no projeto): fila do Discador, status de disparo, novas mensagens em Chats, movimentação de leads no Kanban quando alterada por outro usuário, status de disponibilidade dos SDRs (em atendimento/pausado/disponível) e contadores de mensagens não lidas. | Elicitado |
| RNF-03 | Responsividade do Discador e Chats | Como SDRs podem operar fora da mesa (ex.: tablet), Discador e Chats devem ser utilizáveis em telas menores; demais módulos podem ser desktop-first. | Elicitado |
| RNF-04 | Limites por plano | Cada conta (Administrador) deve ter limites de uso associados ao seu plano (nº de SDRs, volume de disparos, ligações), dado o modelo SaaS. O modelo de cobrança e os valores de cada plano ainda não foram definidos e serão revisados posteriormente; este requisito cobre apenas a existência do mecanismo de limites configuráveis por conta, independente da precificação final. | Elicitado |
| RNF-05 | Onboarding de integrações | Deve existir um fluxo guiado para uma nova conta configurar suas credenciais de WhatsApp/Instagram/Facebook na primeira vez que acessa Disparador/Chats. Viabilidade confirmada: fluxo de configuração assistida é factível com o stack atual. | Elicitado |
| RNF-06 | Exportação de relatórios | Dashboard e CRM devem permitir exportar dados em formato CSV para análise externa. Viabilidade confirmada: exportação server-side simples a partir dos dados já consultados nas telas. | Elicitado |

---

## 3. Funcionalidades por Módulo

Cada funcionalidade referencia os requisitos que a originam.

### 3.1 Dashboard

| ID | Funcionalidade | Descrição | Requisitos | Estimativa (dias) | Prioridade |
|---|---|---|---|---|---|
| FT-01 | Painel de KPIs de vendas | Cards com as métricas: vendas (R$), novas matrículas, leads ativos, taxa de conversão. | RF-01 |  |  |
| FT-02 | Gráfico de evolução de vendas | Gráfico de série temporal mostrando tendência de vendas no período selecionado. | RF-02 |  |  |
| FT-03 | Filtro de período | Seleção de intervalo de datas para todos os dados do Dashboard. | RF-03 |  |  |
| FT-04 | Seletor de conta (Admin Geral) | Dropdown para o Administrador Geral trocar entre contas/academias visualizadas. | RF-05 |  |  |
| FT-05 | Cards de resumo por módulo | Um indicador por módulo: leads por status (CRM), ligações do dia (Discador), mensagens enviadas no dia (Disparador), conversas ativas/não lidas (Chats), atendimentos automatizados no dia (Agentes). | RF-04 |  |  |
| FT-06 | Exportação de relatório do Dashboard | Botão que gera e baixa um arquivo CSV com os dados exibidos no Dashboard, respeitando o filtro de período aplicado. | RNF-06 |  |  |
| FT-07 | Indicador de performance por consultor | Ranking resumido dos consultores por taxa de conversão e vendas fechadas, refletido no Dashboard a partir da aba de performance do CRM. | RF-30 |  |  |
| FT-08 | Indicador de Lead Time | Card com o tempo médio até o primeiro contato de um lead. | RF-29 |  |  |

### 3.2 CRM

| ID | Funcionalidade | Descrição | Requisitos | Estimativa (dias) | Prioridade |
|---|---|---|---|---|---|
| FT-09 | Quadro Kanban de leads | Colunas por status do lead (sem contato, tentativa, remarcado, agendado, negociando, ganhou, perdeu, desqualificado, excluído). | RF-06 |  |  |
| FT-10 | Arrastar e soltar entre colunas | Mover leads entre status via drag-and-drop (já implementado com SortableJS). | RF-07 |  |  |
| FT-11 | Card de lead detalhado | Exibe nome, contato, faixa de faturamento, origem, SDR responsável e data de entrada no funil. | RF-08, RF-13 |  |  |
| FT-12 | Botão "Ligar agora" | No card do lead, abre o Discador com o lead carregado e inicia a ligação automaticamente. | RF-10 |  |  |
| FT-13 | Importação de leads via planilha | Upload de arquivo para importação em massa, com botão para baixar o modelo de planilha esperado. | RF-11 |  |  |
| FT-14 | Histórico de status do lead | Linha do tempo de mudanças de status do lead. | RF-09 |  |  |
| FT-15 | Vínculo com conversa de Chats | A partir do card do lead, acessar a conversa associada em Chats (e vice-versa). | RF-46 |  |  |
| FT-16 | Atribuição de lead a SDR | Define/altera o SDR responsável pelo lead: automaticamente no momento da distribuição (RF-40) e manualmente a qualquer momento pelo Administrador ou por outro SDR autorizado. | RF-08, RF-40 |  |  |
| FT-17 | Data de entrada no funil | Exibida no card do lead. | RF-13 |  |  |
| FT-18 | Alerta visual de SLA (24h) | Card fica destacado em vermelho se ultrapassar 24h parado na mesma etapa. | RF-14 |  |  |
| FT-19 | Tooltip de etapas do Kanban | Texto explicativo ao passar o mouse sobre o nome da etapa. | RF-15 |  |  |
| FT-20 | Campos estendidos do lead | E-mail, data de nascimento, profissão e motivo de procura (lista pré-definida) no cadastro do lead. | RF-13 |  |  |
| FT-21 | Cadastro manual de lead | Botão "Novo Cadastro" no CRM com formulário rápido (nome e telefone obrigatórios; demais campos opcionais). | RF-12 |  |  |
| FT-22 | Atalhos de contato no card | Botão para abrir conversa de WhatsApp com seleção de template aprovado, e botão para enviar e-mail de conteúdo livre, direto do card do lead. | RF-16 |  |  |
| FT-23 | Anotações do lead | Campo de texto livre, salvo na linha do tempo do card. | RF-17 |  |  |
| FT-24 | Atividades futuras | Criação e visualização de atividades agendadas (ligação, e-mail, reunião/visita, tarefa) na linha do tempo do lead. | RF-18 |  |  |
| FT-25 | Formulário de agendamento | Captura de dia/horário ao mover o lead para a etapa de agendamento. | RF-19 |  |  |
| FT-26 | Envio automático de lembrete de agendamento | Disparo automático de mensagem lembrando o lead do compromisso, via WhatsApp (template) ou e-mail (livre). | RF-20 |  |  |
| FT-27 | Formulário de negociação | Captura da temperatura da negociação ao mover o lead para "Negociando". | RF-21 |  |  |
| FT-28 | Formulário de fechamento (Ganhou) | Captura do valor total do plano fechado. | RF-22 |  |  |
| FT-29 | Formulário de perda (Perdeu) | Captura do valor negociado e do motivo da perda. | RF-23 |  |  |
| FT-30 | Painel "Visitas agendadas" | Lista de leads com visita marcada, ordenada por horário. | RF-24 |  |  |
| FT-31 | Tutorial guiado do CRM | Tour interativo por sobreposição de telas, explicando o funil ao novo usuário; reexecutável pelo menu de ajuda. | RF-25 |  |  |
| FT-32 | Documentação automática de ligação no card | Resumo da ligação gerado por IA e anexado ao histórico do lead, condicionado à viabilidade técnica de captura de áudio descrita em RF-26. | RF-26 |  |  |
| FT-33 | Resumo automático de conversas no card | Resumo do histórico de chat gerado por IA e anexado ao card do lead. | RF-27 |  |  |
| FT-34 | Movimentação automática de etapa | Baseada no resultado da ligação registrado no Discador. | RF-28 |  |  |
| FT-35 | Aba de performance de consultores | Métricas de conversão, ligações, agendamentos e vendas por consultor, dentro do próprio CRM. | RF-30 |  |  |

### 3.3 Discador

| ID | Funcionalidade | Descrição | Requisitos | Estimativa (dias) | Prioridade |
|---|---|---|---|---|---|
| FT-36 | Navegação por sub-módulos | Sub-navegação própria dentro de Discador (Fila/Ligação, Histórico, Scripts, Relatórios), independente da barra lateral principal. | RF-33 |  |  |
| FT-37 | Fila automática de discagem | Inicia e avança automaticamente pela fila de leads a ligar, respeitando a disponibilidade do SDR. | RF-34, RF-39 |  |  |
| FT-38 | Sessão de trabalho do SDR | Iniciar/pausar/retomar sessão (reaproveita `WorkSession`/`Pause`). | RF-39 |  |  |
| FT-39 | Exibição de script por faturamento | Mostra o script correspondente à `revenue_range` do lead durante a chamada. | RF-32, RF-36 |  |  |
| FT-40 | Cadastro de scripts | Tela de administração para criar/editar scripts vinculados a faixas de faturamento. | RF-36 |  |  |
| FT-41 | Relatórios do módulo | Total de ligações por SDR, taxa de atendimento, tempo médio de ligação, taxa de conversão em agendamento e ranking de SDRs. | RF-37 |  |  |
| FT-42 | Configuração da distribuição de leads | Escolha entre distribuição igualitária ou definição manual da quantidade/peso por consultor, com sugestão do sistema baseada em capacidade e performance histórica. | RF-40 |  |  |

### 3.4 Disparador

| ID | Funcionalidade | Descrição | Requisitos | Estimativa (dias) | Prioridade |
|---|---|---|---|---|---|
| FT-43 | Envio via API Oficial | Disparo de templates pré-aprovados via Meta Cloud API para lista de números. | RF-41, RF-44 |  |  |
| FT-44 | Monitoramento em tempo real | Atualizações de status (enviado/entregue/lido/falhou) ao vivo. | RF-43 |  |  |
| FT-45 | Histórico de disparos | Lista de mensagens enviadas com status individual. | RF-41 |  |  |
| FT-46 | Seleção de templates | Escolha, entre os templates já aprovados pela Meta, de qual usar em cada disparo (o cadastro do template é feito no Meta Business Manager, fora do sistema). | RF-44 |  |  |
| FT-47 | Configuração de credenciais | Tela para inserir/salvar Phone Number ID, Bearer Token e Business Account ID, por conta. | RF-42 |  |  |

### 3.5 Chats

**Sugestão de organização:** em vez de apenas cards por canal (WhatsApp/Instagram/Facebook) isolados, recomenda-se uma **caixa de entrada unificada** com filtro por canal — assim o SDR não precisa navegar entre três telas separadas para responder. Os cards por canal ficam como *filtros/atalhos* no topo, mostrando contagem de não lidas por canal, mas a lista de conversas é única e cruza com o CRM (lead vinculado visível na conversa).

| ID | Funcionalidade | Descrição | Requisitos | Estimativa (dias) | Prioridade |
|---|---|---|---|---|---|
| FT-48 | Caixa de entrada unificada | Lista de conversas de todos os canais, com filtro por canal; depende das credenciais de integração configuradas por conta. | RF-45, RF-42 |  |  |
| FT-49 | Vínculo com lead do CRM | Exibe e permite associar o lead correspondente à conversa. | RF-46 |  |  |
| FT-50 | Atribuição exclusiva e indicador de não lidas | Atribui a conversa a um único SDR por vez, com opção de reatribuição, e sinaliza visualmente mensagens não lidas. | RF-47 |  |  |
| FT-51 | Handoff Agente ↔ humano | Transferir a condução da conversa entre Agente de IA e SDR sem perder histórico. | RF-51 |  |  |
| FT-52 | Conexão de canais | Tela de configuração para conectar/desconectar as contas de WhatsApp, Instagram e Facebook usadas pela caixa de entrada unificada. | RF-42, RF-45 |  |  |

### 3.6 Agentes

**Sugestão de organização:** manter os agentes como **cards ao entrar no módulo** (um por finalidade: Inadimplência, Recuperação de Visitantes, Recuperação de Ex-alunos, Atendimento, Confirmação de Agendamento), pois cada um tem configuração e métricas próprias — mas ao abrir um agente, mostrar suas conversas ativas dentro do mesmo painel de Chats (reaproveitando a caixa de entrada unificada, filtrada por "conduzido por este agente"), evitando duplicar a UI de conversa em dois módulos diferentes.

| ID | Funcionalidade | Descrição | Requisitos | Estimativa (dias) | Prioridade |
|---|---|---|---|---|---|
| FT-53 | Catálogo de agentes | Cards para os agentes (Inadimplência, Recuperação de Visitantes, Recuperação de Ex-alunos, Atendimento), com status ativo/inativo. | RF-48 |  |  |
| FT-54 | Configuração de limites de autonomia | Painel por agente para definir desconto máximo, valor mínimo de renegociação, condições de renegociação e número máximo de tentativas antes de escalonar. | RF-50 |  |  |
| FT-55 | Escalonamento para humano | Transferência automática da conversa quando a interação sai dos limites configurados. | RF-50, RF-51 |  |  |
| FT-56 | Histórico e auditoria de ações | Registro de conversas e ações tomadas por cada agente (ex.: desconto oferecido, remarcação), disponível para consulta. | RF-52 |  |  |
| FT-57 | Métricas por agente | Recuperações concluídas, negociações fechadas, taxa de conversão — alimenta o Dashboard. | RF-48 |  |  |
| FT-58 | Agente de confirmação de agendamento | Card do agente dedicado a confirmar agendamentos com o lead antes da data marcada. | RF-49 |  |  |

### 3.7 Administração e Contas (transversal)

| ID | Funcionalidade | Descrição | Requisitos | Estimativa (dias) | Prioridade |
|---|---|---|---|---|---|
| FT-59 | Gestão de contas (Admin Geral) | Criar, bloquear e remover contas de Administrador (academias); e, quando necessário, criar, bloquear e remover SDRs de qualquer conta diretamente. | RF-54 |  |  |
| FT-60 | Gestão de SDRs (Administrador) | Criar, bloquear e remover SDRs da própria conta. | RF-55 |  |  |
| FT-61 | Controle de acesso por papel | Aplicação das regras de visibilidade de módulo por papel (Admin Geral / Administrador / SDR). | RF-56 |  |  |
| FT-62 | Isolamento de dados por conta | Escopo de dados restrito à conta do usuário autenticado (exceto Admin Geral). | RF-53 |  |  |
| FT-63 | Configuração de limites por conta | Definição e acompanhamento de limites de uso por conta (nº de SDRs, volume de disparos, ligações), sem vínculo com um modelo de cobrança específico. | RNF-04 |  |  |
| FT-64 | Auditoria administrativa | Log de ações sensíveis (bloqueios, remoções, mudanças de configuração) por conta e por usuário. | RF-57 |  |  |
| FT-65 | Onboarding de integrações | Fluxo guiado de configuração inicial das credenciais de canais (WhatsApp/Instagram/Facebook). | RNF-05 |  |  |

### 3.8 Gamificação / Premiação (módulo novo)

| ID | Funcionalidade | Descrição | Requisitos | Estimativa (dias) | Prioridade |
|---|---|---|---|---|---|
| FT-66 | Configuração de premiação | Administrador define, em texto livre, a recompensa do período e o período de apuração (ex.: semanal). | RF-58 |  |  |
| FT-67 | Ranking de consultores | Exibição do ranking de consultores no período vigente, com base nas métricas de performance. | RF-58, RF-30 |  |  |

---

## Outros pontos

- O sistema não utiliza provedor VoIP. O sistema chama a aplicação "Vincular ao celular" que deve estar instalado no computador. Após ser chamado, o "Vincular ao celular" inicia a ligação automaticamente.
- Deve haver um painel para adicionar prompt, regras e restrições para cada agente.
- O modelo de cobrança do SaaS não importa no momento (ver RNF-04). Isso será revisado posteriormente.
- No CRM entregue às academias, os leads representam pessoas interessadas em se matricular na academia (potenciais alunos), e não outras academias — os nomes de academia usados no protótipo mostrado na reunião de revisão do CRM foram apenas um exemplo ilustrativo do funil interno da própria Gestão Fitness, para não confundir com o produto entregue ao cliente final.
- O sistema não faz controle de acesso físico, controle de catraca ou controle de treino dos alunos da academia; é exclusivamente um sistema de vendas/funil comercial (CRM + Discador + Disparador + Chats + Agentes).
- Foi discutida e descartada, por ora, a criação de permissões granulares por sub-papel (ex.: gerente/supervisor com acesso limitado dentro da conta do Administrador); os stakeholders decidiram não implementar esse nível de granularidade nesta fase.
- A entrega seguirá abordagem iterativa por módulo (MVP por módulo, com melhorias incrementais); a priorização final de funcionalidades dentro de cada módulo será refinada e validada em reunião futura.
- **Requisitos removidos nesta revisão** (com justificativa): disparo de WhatsApp via API não oficial/Evolution API e suas regras anti-bloqueio (mantida apenas a API Oficial da Meta); captura automática de leads via landing page/campanhas (inviável no modelo atual); liberação progressiva automática do modo de distribuição por performance (substituída pela configuração manual descrita em RF-40); renomeação do papel "SDR" para "Consultor de Vendas" na interface e ocultação automática da seleção de perfil de acesso (fora de escopo desta fase); integração futura com CRM de terceiros (baixa viabilidade/prioridade, descartada por ora).
