# Prompt para Claude Design — Plataforma de Vendas (Academia)

> Copie o conteúdo abaixo (a partir de "## Prompt") e cole no Claude Design.

## Prompt

Quero que você desenhe a interface de alta fidelidade de uma **plataforma web de vendas para donos de academia**, a partir de um protótipo de baixa fidelidade (wireframe em papel) que estou anexando/descrevendo abaixo. Gere telas completas, coerentes entre si, prontas para revisão de design (não é necessário gerar código, apenas o layout visual/UI). A plataforma Discador e Disparador, dois dos módulos descritos abaixo, já existem e as imagens de todas as telas foram anexadas. Você deve construir o protótipo levando em conta as plataformas Discador e Disparador existentes e não remover o que já existe. A plataforma final deve se basear no Discador e Disparador e conter ambos como módulo.

### 1. Contexto do produto

A plataforma ajuda o dono de academia a vender mais, unificando 6 módulos numa barra lateral fixa:

1. **Dashboard** — visão consolidada de vendas e desempenho de todos os módulos.
2. **CRM** — Kanban de leads (herda o Kanban já existente no sistema atual de Discador).
3. **Discador** — ligação automática para leads, fila de discagem, script de vendas em tela.
4. **Disparador** — disparo de mensagens em massa no WhatsApp (API oficial com templates, ou API não oficial com mensagens livres).
5. **Chats** — caixa de entrada unificada de WhatsApp, Instagram e Facebook da academia.
6. **Agentes** — agentes de IA para negociação de inadimplência, recuperação de visitantes e ex-alunos, e atendimento.

Existem 3 perfis de usuário, e a barra lateral deve refletir o que cada um pode ver:
- **Administrador Geral**: vê todos os módulos + uma área de gestão de contas (academias).
- **Administrador** (dono de academia): vê Dashboard, CRM, Discador, Disparador, Chats, Agentes + gestão dos seus SDRs.
- **SDR**: vê apenas CRM, Discador e Chats.

Desenhe a barra lateral considerando esses 3 estados (pode ser 3 variações da mesma sidebar, indicando os itens habilitados/ocultos por perfil).

### 2. Sistema visual (basear-se no sistema já existente — manter consistência de marca)

O produto atual (módulo de disparo) já usa este sistema visual; **mantenha e estenda**, não reinvente:

- **Sidebar**: fundo escuro quase-preto (tom `slate-900`/`#0f172a`), item ativo com fundo verde translúcido e texto verde-claro, ícone + rótulo por item, indicador de status de conexão no rodapé (bolinha verde "Conectado").
- **Área de conteúdo**: fundo cinza muito claro (`#f8fafc`), cards brancos com cantos arredondados (`rounded-xl`), sombra suave, título em negrito + subtítulo cinza descritivo no topo de cada tela.
- **Cor de destaque (ação primária)**: verde (`#16a34a`/`#22c55e`) — usado em botões primários ("Enviar", "Ligar", "Salvar") e em badges de sucesso.
- **Badges de status**: pílulas coloridas discretas — verde para positivo (Lido/Entregue/Ativo), azul para neutro/em progresso (Enviado/Em negociação), cinza para pendente, vermelho para falha/urgente.
- **Tipografia**: sans-serif neutra (ex.: Inter), títulos em negrito, textos auxiliares em cinza médio.
- **Formulários**: inputs com borda cinza clara, cantos arredondados, foco em verde.
- Gere também um **modo escuro** coerente (fundo de conteúdo em cinza-azulado escuro, cards em tom ligeiramente mais claro que o fundo, mesma paleta de acento verde).

### 3. Telas a desenhar (baseadas no protótipo de baixa fidelidade anexo)

O protótipo em papel mostra 4 telas numeradas (①-④) mais uma barra lateral repetida com os itens: Dashboard, CRM, Discador, Disparador, Chats, Agentes, Sair. Desenhe as 4 originais em alta fidelidade e mais 2 novas (Chats e Agentes, não esboçadas no papel — segui minhas recomendações de estrutura abaixo).

**① Dashboard**
- Cabeçalho: "Dashboard" + subtítulo curto.
- Linha de cards de KPI no topo: Vendas (ex. "R$ 12M"), Novos alunos matriculados (ex. "53"), e mais 2-3 métricas relevantes (leads ativos, taxa de conversão).
- Gráfico principal de evolução de vendas ao longo do tempo (linha ou área, tendência de crescimento) ocupando a maior parte da tela.
- Seção inferior com cards-resumo por módulo (CRM: leads por status; Discador: ligações do dia; Disparador: mensagens enviadas; Chats: conversas ativas; Agentes: atendimentos automatizados).
- Filtro de período no canto superior direito. Se for a variação para Administrador Geral, incluir também um seletor de conta/academia.

**② CRM (Kanban)**
- Cabeçalho: "CRM" + subtítulo "Estado dos leads".
- Quadro Kanban horizontal com colunas de status (ex.: Sem contato, Tentativa, Remarcado, Agendado, Desqualificado) — use os rótulos aproximados do papel ("Em contato", "Em negociação", "Remarcado") como referência de tom, mas pode usar os status reais do sistema.
- Cada coluna com cards de lead: nome, telefone, faixa de faturamento (badge), SDR responsável (avatar pequeno).
- Cada card deve ter um botão/ícone de **"Ligar agora"** que, ao clicar, abriria o Discador já discando para aquele lead — deixe esse botão visualmente destacado (ícone de telefone verde).
- Indicar visualmente que os cards são arrastáveis entre colunas (cursor/handle de drag).

**③ Discador**
- Cabeçalho: "Discador" com sub-navegação própria do módulo (abas ou tabs internas: "Ligação", "Fila", "Histórico", "Scripts", "Relatórios") — isso é importante: todas as telas do Discador devem parecer parte do mesmo módulo, não espalhadas pela navegação principal.
- Tela de "Ligação" (a que está no papel): cronômetro da chamada (ex. "13:05") em destaque, número discado, indicador "Chamando..."/"Em andamento", painel de **script de vendas** (texto rolável, deve indicar visualmente que muda conforme a faixa de faturamento do lead), e botões grandes "Atendeu? Sim/Não" ao final para registrar o resultado.
- Um painel lateral ou superior mostrando a fila automática (próximos leads a discar) e um contador.
- Botões de Pausar/Retomar sessão.

**④ Disparador**
- Cabeçalho: "Disparador" com sub-navegação/tabs para alternar entre **API Oficial** e **API não oficial** (Evolution).
- Formulário de disparo: seleção de tipo de mensagem (Template pré-aprovado vs. Texto livre), campo de mensagem, campo de lista de números (textarea com separação por vírgula), botão primário verde "Enviar".
- Cards de métricas no topo (mensagens enviadas, recebidas, entregues, lidas).
- Para a API não oficial, incluir um bloco de "Regras anti-bloqueio" (delay mínimo/máximo, embaralhar destinatários, variação de texto) — pode ser um painel colapsável.
- Seções de "Mensagens recebidas" e "Histórico de envios" com status em badges coloridas (Lido, Entregue, Enviado, Pendente, Falhou), atualizando em tempo real (indicador "AO VIVO").

**⑤ Chats (novo — recomendação de estrutura)**
- Não usar apenas cards por canal isolados. Desenhar como **caixa de entrada unificada**: lista de conversas à esquerda (com avatar, nome/número, último preview de mensagem, canal indicado por um pequeno ícone de Whatsapp/Instagram/Facebook, badge de não lida), painel de conversa à direita (estilo chat).
- No topo da lista, filtros rápidos por canal (chips: Todos / WhatsApp / Instagram / Facebook) mostrando contagem de não lidas.
- No painel de conversa, mostrar um cartão lateral com o **lead vinculado** (nome, faixa de faturamento, status no CRM, link para abrir o card completo).
- Indicar quando a conversa está sendo conduzida por um **Agente de IA** (badge "Atendido por Agente" com opção de "Assumir conversa").

**⑥ Agentes (novo — recomendação de estrutura)**
- Tela inicial em **cards**, um por agente: "Negociação de Inadimplência", "Recuperação de Visitantes", "Recuperação de Ex-alunos", "Atendimento da Academia" — cada card com ícone temático, status Ativo/Inativo (toggle), e métricas resumidas (ex.: "12 negociações fechadas este mês").
- Ao abrir um agente: painel de configuração de **limites de autonomia** (ex.: campo "desconto máximo (%)", regras de escalonamento) e lista das conversas atualmente conduzidas por esse agente (reaproveitando o mesmo layout de lista de conversas do módulo Chats, filtrado).

### 4. Estados e detalhes de interação a representar

- Estado vazio (ex.: "Nenhuma mensagem recebida ainda", já usado no sistema atual — manter o tom).
- Estado de carregamento/tempo real (indicador "AO VIVO" já usado).
- Estado de escalonamento de Agente para humano (alerta ou notificação visual).
- Drag-and-drop no Kanban (mostrar um card "flutuando" em transição entre colunas, se possível).

### 5. Responsividade

Desenhe também a versão mobile/tablet das telas de **Discador** e **Chats** (SDRs podem usá-las fora da mesa) — sidebar colapsando em menu inferior ou gaveta lateral. As demais telas podem ser desktop-first.

### 6. Entregáveis esperados

- Sidebar em 3 variações de perfil (Admin Geral / Administrador / SDR).
- As 6 telas principais descritas acima, em modo claro.
- Versão em modo escuro de pelo menos Dashboard e Discador.
- Versões mobile de Discador e Chats.
