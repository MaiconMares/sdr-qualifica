# Plataforma de Vendas — Requisitos e Funcionalidades (Reunião de Revisão do CRM)

## 1. Visão Geral

Este documento complementa `requisitos_e_funcionalidades.md` com requisitos elicitados a partir da transcrição de uma reunião de revisão do protótipo, focada principalmente no módulo de **CRM**, mas que também trouxe pontos novos para **Discador**, **Agentes de IA**, **Dashboard** e um módulo novo de **Gamificação/Premiação**.

Apenas requisitos e funcionalidades **ainda não presentes** em `requisitos_e_funcionalidades.md` estão listados aqui. A numeração de IDs continua a partir do documento original (RF-28+, RNF-07+, FT-47+).

---

## 2. Requisitos

`Origem`: **Informado** = dito explicitamente pelos stakeholders na reunião · **Elicitado** = inferido/deduzido a partir do que foi discutido (ex.: comparação com sistema concorrente apresentado na call).

### 2.1 Requisitos Funcionais (RF)

| ID | Requisito | Descrição | Origem |
|---|---|---|---|
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
| RNF-07 | Integração futura com CRM de terceiros | Após a entrega da primeira versão da plataforma, deve ser avaliada a integração com o CRM atualmente utilizado pela Gestão Fitness (sistema de terceiros, em outra linguagem/stack), permitindo importar ou sincronizar dados. Baixa prioridade, pós-MVP. | Informado |

---

## 3. Funcionalidades por Módulo

Cada funcionalidade referencia os requisitos que a originam.

### 3.1 Dashboard

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-47 | Indicador de performance por consultor | Ranking/resumo de performance dos consultores de vendas refletido no Dashboard. | RF-51 |
| FT-48 | Métrica de Lead Time | Indicador do tempo médio até o primeiro contato de um lead. | RF-47 |

### 3.2 CRM

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
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
| FT-69 | Escolha do modo de distribuição de leads | Opção entre distribuição igualitária ou por performance ao subir uma lista de leads. | RF-49 |
| FT-70 | Liberação progressiva do modo por performance | Funcionalidade de distribuição por performance aparece automaticamente após período configurável de operação, como uma "nova funcionalidade". | RF-50 |

### 3.6 Agentes

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-71 | Agente de confirmação de agendamento | Novo tipo de agente dedicado a confirmar agendamentos com o lead antes da data marcada. | RF-38 |

### 3.7 Administração e Contas (transversal)

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-72 | Renomeação de papel na interface | Exibir "Consultor de Vendas" no lugar de "SDR" em toda a interface voltada ao usuário final. | RF-53 |
| FT-73 | Seleção automática de visão por login | Visão do usuário definida pelo papel do login, sem seletor manual de perfil; filtros de "visualizar como" restritos a papéis operacionais (Administrador e Consultores). | RF-54 |

### 3.8 Gamificação / Premiação (módulo novo)

| ID | Funcionalidade | Descrição | Requisitos |
|---|---|---|---|
| FT-74 | Configuração de premiação | Administrador define recompensa e período de apuração (ex.: semanal). | RF-52 |
| FT-75 | Ranking de consultores | Exibição do ranking de consultores de vendas no período vigente. | RF-52 |

---

## Outros pontos

- No CRM entregue às academias, os leads representam pessoas interessadas em se matricular na academia (potenciais alunos), e não outras academias — os nomes de academia usados no protótipo mostrado na reunião foram apenas um exemplo ilustrativo do funil interno da própria Gestão Fitness, para não confundir com o produto entregue ao cliente final.
- O sistema não faz controle de acesso físico, controle de catraca ou controle de treino dos alunos da academia; é exclusivamente um sistema de vendas/funil comercial (CRM + Discador + Disparador + Chats + Agentes).
- Foi discutida e descartada, por ora, a criação de permissões granulares por sub-papel (ex.: gerente/supervisor com acesso limitado dentro da conta do Administrador); os stakeholders decidiram não implementar esse nível de granularidade nesta fase.
- A entrega seguirá abordagem iterativa por módulo (MVP por módulo, com melhorias incrementais); a priorização final de funcionalidades dentro de cada módulo será refinada e validada em reunião futura.
