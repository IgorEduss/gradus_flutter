# 1. Visão Geral da Arquitetura

## **1.1. Stack Tecnológica Detalhada**

Esta seção descreve o conjunto de tecnologias, bibliotecas e plataformas escolhidas para a implementação da versão inicial (MVP) do aplicativo "Gradus" (Teoria da Escada Rolante). As escolhas foram feitas visando robustez, manutenibilidade e alinhamento com as práticas modernas de desenvolvimento multiplataforma.

- ### **Plataforma Alvo:**
    
    - **Flutter (Multiplataforma):** O aplicativo será desenvolvido utilizando o framework Flutter, compilando nativamente para Android (foco inicial) e iOS.
        
    - **Justificativa:** Proporciona o melhor desempenho possível em cross-platform (renderização via Skia/Impeller), uma experiência de usuário fluida (60/120fps) e acesso completo às funcionalidades nativas, mantendo uma única base de código para facilitar a manutenção e evolução do produto.
        
- ### **Linguagem de Programação:**
    
    - **Dart (Versão Estável Recente):** Utilizada integralmente para a camada de interface do usuário (`presentation`), lógica de negócios (`domain`) e camada de dados (`data`).
        
    - **Justificativa:** Linguagem moderna, fortemente tipada e segura (_Null Safety_). A unificação da linguagem elimina a complexidade de interoperabilidade (como ocorria com Java/Kotlin) e permite compartilhar lógica de validação e DTOs entre todas as camadas do sistema de forma transparente.
        
- ### **Arquitetura Principal:**
    
    - **Clean Architecture + MVVM (Model-View-ViewModel):** O padrão arquitetural que guiará a estrutura do código.
        
    - **Justificativa:** Promove uma clara separação de responsabilidades. A lógica de negócios (`domain`) permanece isolada de frameworks externos, enquanto a camada de apresentação (`presentation`) reage a estados gerenciados pelos ViewModels, resultando em um código organizado, testável e fácil de manter.
        
- ### **Interface do Usuário (UI):**
    
    - **Flutter Widgets:** Construção declarativa da interface utilizando os widgets nativos do Material Design 3.
        
    - **Justificativa:** Simplifica e acelera o desenvolvimento da UI, exigindo menos código para layouts complexos, permitindo a criação de componentes reutilizáveis de forma fácil e garantindo fidelidade visual entre plataformas.
        
- ### **Gerenciamento de Estado:**
    
    - **Riverpod:** Biblioteca de gerenciamento de estado reativo e injeção de dependência.
        
    - **Justificativa:** Evolução robusta do padrão Provider. Oferece segurança em tempo de compilação, testabilidade superior e desacoplamento total da árvore de widgets (`BuildContext`), permitindo que a lógica de apresentação seja pura.
        
- ### **Banco de Dados e Persistência:**
    
    - **SQLite:** O banco de dados relacional que será usado para a persistência de todos os dados localmente no dispositivo.
        
    - **Drift (antigo Moor):** A biblioteca que será usada como camada de persistência reativa sobre o SQLite no ecossistema Dart.
        
    - **Justificativa:** O Drift simplifica drasticamente a interação com o banco de dados, reduz código repetitivo (`boilerplate`), fornece verificação de queries SQL em tempo de compilação (evitando erros em tempo de execução) e se integra de forma reativa com `Streams` para atualização automática da UI.
        
- ### **Injeção de Dependência:**
    
    - **GetIt + Injectable:** Combinação de um _Service Locator_ (`GetIt`) com geração de código (`Injectable`).
        
    - **Justificativa:** Simplifica a implementação do padrão de Injeção de Dependência. Gerencia o ciclo de vida dos objetos (Singletons, Factories) e facilita o fornecimento de dependências (como `Repositories` para `ViewModels`), tornando o código mais desacoplado e muito mais fácil de testar.
        
- ### **Tarefas em Segundo Plano:**
    
    - **workmanager:** Plugin para o gerenciamento de tarefas assíncronas e persistentes.
        
    - **Justificativa:** Wrapper para o `WorkManager` (Android) e `BGTaskScheduler` (iOS). Ideal para operações como o backup e a restauração na nuvem, pois garante que a tarefa será executada mesmo que o aplicativo seja fechado ou o dispositivo reiniciado.
        
- ### **Integração com Serviços de Nuvem:**
    
    - **Google Drive API (`googleapis`):** Para a funcionalidade de backup e restauração na conta Google Drive do usuário.
        
    - **Justificativa:** Permite que o usuário tenha controle total sobre seus dados, salvando-os em sua nuvem pessoal, o que aumenta a confiança e a portabilidade dos dados.
    
### **Segurança Local e Autenticação:**

- **flutter_secure_storage:** Biblioteca para armazenamento seguro de dados sensíveis.
    
- **local_auth:** Plugin para autenticação biométrica nativa (FaceID, TouchID, Impressão Digital).
    
- **Justificativa:** Necessário para armazenar o PIN do usuário e o identificador da **conta Google** vinculada (`email` ou `id`), garantindo que essas informações não fiquem expostas e permitindo a recuperação de acesso segura.

---

## **1.2. Padrão Arquitetural Adotado (Clean + MVVM)**

Para garantir uma base de código organizada, escalável e testável, o aplicativo "Gradus" adotará o padrão de arquitetura **Clean Architecture combinado com MVVM**.

Esta arquitetura divide a aplicação em camadas concêntricas, cada uma com responsabilidades claras:

### **Domain Layer (Domínio):**

- **Definição:** Representa a lógica de negócios pura e as regras do aplicativo. É a camada mais interna e não possui conhecimento sobre a interface do usuário, banco de dados ou frameworks externos.
    
- **Componentes no Nosso Projeto:**
    
    - **Entities:** Objetos de negócio puros (Classes Dart simples).
        
    - **UseCases:** Encapsulam regras de negócio específicas (ex: `CalcularInflacaoUseCase`).
        
    - **Repository Interfaces:** Contratos abstratos que definem _o que_ deve ser feito com os dados, mas não _como_.
        

### **Data Layer (Dados):**

- **Definição:** Responsável por recuperar e persistir dados. Implementa as interfaces definidas na camada de Domínio.
    
- **Componentes no Nosso Projeto:**
    
    - **DataSources:** Fontes de dados brutas (ex: `DriftDatabase` para local, `DriveService` para remoto).
        
    - **Models (DTOs):** Representações dos dados para transporte e banco de dados, incluindo métodos de serialização (`fromJson`/`toJson`) e mapeamento para as Entidades.
        
    - **Repositories Implementations:** Coordenam a fonte de dados e decidem se a informação vem do banco local ou da nuvem.
        

### **Presentation Layer (Apresentação):**

- **Definição:** É a camada de Interface do Usuário (UI) que o usuário vê e com a qual interage. Sua principal responsabilidade é exibir os dados e encaminhar as interações para os ViewModels.
    
- **Componentes no Nosso Projeto:**
    
    - **Widgets/Screens:** Telas construídas com Flutter.
        
    - **ViewModels (Riverpod Providers):** Gerenciam o estado da tela. Solicitam dados aos UseCases, formatam para exibição e expõem estados reativos (`Loading`, `Success`, `Error`) para a View.
        

### **Benefícios desta Arquitetura para Este Projeto:**

- **Independência de Frameworks:** A lógica de negócios não depende do Flutter.
    
- **Testabilidade:** Cada camada pode ser testada de forma isolada. Podemos testar a lógica do UseCase sem precisar emular o dispositivo.
    
- **Manutenibilidade:** Mudanças na UI ou no Banco de Dados não afetam as Regras de Negócio.
    

---

## **1.3. Estrutura de Módulos e Pacotes do Projeto**

Para refletir a arquitetura e garantir uma clara separação de responsabilidades, o projeto adotará uma estrutura de pastas organizada por camadas (_Layer-first_) ou funcionalidades (_Feature-first_).

A estrutura de pastas sugerida (`lib/`) é a seguinte:

Plaintext

```
lib/
│
├── main.dart                  // Inicialização, DI e runApp
├── core/                      // Recursos compartilhados (Shared Kernel)
│   ├── constants/             // Strings, rotas, chaves de API
│   ├── theme/                 // Definições de tema (AppTheme, Cores)
│   ├── utils/                 // Formatadores, Validadores
│   └── errors/                // Definição de Failures e Exceptions
│
├── data/                      // CAMADA DE DADOS
│   ├── local/                 // Persistência Local
│   │   ├── db/                // Configuração do Drift Database
│   │   ├── tables/            // Definições das Tabelas (Drift Tables)
│   │   └── daos/              // Data Access Objects (Queries)
│   ├── remote/                // Serviços Remotos (APIs de nuvem)
│   ├── models/                // DTOs e Mappers
│   └── repositories/          // Implementação dos Repositórios
│
├── domain/                    // CAMADA DE DOMÍNIO
│   ├── entities/              // Classes de negócio puras
│   ├── repositories/          // Interfaces (Contratos)
│   └── usecases/              // Regras de negócio (Verbos: Calcular, Salvar)
│
└── presentation/              // CAMADA DE APRESENTAÇÃO
    ├── widgets/               // Componentes visuais reutilizáveis
    ├── providers/             // Gerenciamento de Estado (Riverpod)
    └── screens/               // Telas do App
        ├── dashboard/
        ├── transactions/
        ├── settings/
        └── ...
```

---

# 2. Design do Banco de Dados (SQLite-Drift)

Este capítulo detalha a estrutura completa do banco de dados SQLite que servirá como a camada de persistência local para o aplicativo "Gradus". O design foi concebido para ser relacional, normalizado e robusto, utilizando a biblioteca **Drift** para implementação.

## **2.1. Esquema Relacional (Descrição das Relações)**

A tabela `usuarios` é a entidade central do esquema. Todas as outras tabelas principais contêm uma chave estrangeira `usuario_id`, estabelecendo uma relação onde **um** `usuário` pode ter **muitos** `fundos_principais`, `caixinhas`, `emprestimos`, `compromissos` e `transacoes`.

- **`fundos_principais`**: Ligada diretamente ao `usuarios`. Cada usuário terá exatamente dois registros nesta tabela: um para o "FER" e um para o "MSP".
    
- **`caixinhas`**: Ligada diretamente ao `usuarios`. Representa os múltiplos objetivos de poupança do usuário dentro do seu MSP.
    
- **`emprestimos`**: Além de se ligar ao `usuarios`, esta tabela também possui uma chave estrangeira para `fundos_principais`, indicando que a origem dos fundos de um empréstimo é sempre o registro do "FER".
    
- **`compromissos`**: Ligada ao `usuarios`, esta tabela pode ter como destino dos aportes um registro em `fundos_principais` (para o FER ou MSP Geral) ou um registro em `caixinhas`.
    
- **`transacoes`**: É a tabela mais conectada, funcionando como o livro-razão. Ela se liga ao `usuarios` e possui chaves estrangeiras opcionais para `fundos_principais` e `caixinhas` (para indicar origem e destino dos fundos) e também para `emprestimos` e `compromissos` (para vincular uma transação de pagamento à sua dívida ou obrigação original).
    

Este modelo relacional garante a integridade dos dados e permite a construção de consultas complexas e relatórios detalhados sobre a vida financeira do usuário dentro do aplicativo.

---

## **2.2. Definição Detalhada das Tabelas (Entidades Drift)**

_Nota Técnica: No Drift, as colunas são definidas no Dart. Tipos Booleanos são mapeados para `INTEGER` (0 ou 1) no SQLite, e datas para `INTEGER` ou `TEXT` (ISO8601), mas manipulados como `bool` e `DateTime` no código._

### **2.2.1. Tabela `Usuarios`**

- **Descrição:** Armazena o perfil e as configurações do usuário principal do aplicativo.
    
- **Nome da Tabela no SQLite:** `usuarios`
    

|**Coluna**|**Tipo Drift (Dart)**|**Restrições / Definição**|**Descrição**|
|---|---|---|---|
|`id`|`IntColumn`|`autoIncrement()`|Identificador único para o registro do usuário.|
|`user_cloud_id`|`TextColumn`|`nullable()`|Identificador único do usuário fornecido pelo provedor de nuvem. `NULL` se offline.|
|`unidade_pagamento`|`RealColumn`|`NOT NULL`|Valor da "unidade" base configurada pelo usuário para o cálculo de parcelas.|
|`dia_revisao_mensal`|`IntColumn`|`NOT NULL`|Dia do mês (1-31) preferido pelo usuário para a revisão dos compromissos.|
|`inflacao_aplicar_fer_emprestimos`|`BoolColumn`|`withDefault(Constant(true))`|Booleano. Se aplica inflação a empréstimos do FER.|
|`inflacao_aplicar_fer_facilitadores`|`BoolColumn`|`withDefault(Constant(false))`|Booleano. Se aplica inflação a aportes de facilitadores.|
|`inflacao_aplicar_msp_depositos`|`BoolColumn`|`withDefault(Constant(false))`|Booleano. Se aplica inflação a depósitos pessoais programados.|
|`data_criacao`|`DateTimeColumn`|`NOT NULL`|Data e hora da criação do registro.|
|`data_atualizacao`|`DateTimeColumn`|`NOT NULL`|Data e hora da última atualização do registro.|
|`data_atualizacao`|`DateTimeColumn`|`NOT NULL`|Data e hora da última atualização do registro.|

**Notas Adicionais:**

- **`dia_revisao_mensal`:** A lógica da aplicação deve tratar o caso em que o dia escolhido não existe em um determinado mês (ex: dia 31 em fevereiro). Nesses casos, a data de revisão deve ser ajustada para o último dia válido daquele mês.
    

### **2.2.2. Tabela `FundosPrincipais`**

- **Descrição:** Armazena os saldos e informações dos fundos principais: "Capital do Fundo Escada Rolante (FER)" e "Meu Saldo Pessoal (MSP)".
    
- **Nome da Tabela no SQLite:** `fundos_principais`
    

|**Coluna**|**Tipo Drift (Dart)**|**Restrições / Definição**|**Descrição**|
|---|---|---|---|
|`id`|`IntColumn`|`autoIncrement()`|Identificador único para o registro do fundo.|
|`usuario_id`|`IntColumn`|`references(Usuarios, #id)`|Chave estrangeira para o usuário dono do fundo.|
|`tipo_fundo`|`TextColumn`|`NOT NULL`|Identifica o tipo de fundo. Valores: "FER" ou "MSP".|
|`nome_fundo`|`TextColumn`|`NOT NULL`|Nome descritivo (ex: "Capital FER").|
|`saldo_atual`|`RealColumn`|`withDefault(Constant(0.0))`|O saldo monetário líquido e disponível do fundo.|
|`pico_patrimonio_total_alcancado`|`RealColumn`|`withDefault(Constant(0.0))`|**Aplicável ao FER:** Valor máximo que o patrimônio total (saldo + empréstimos) já alcançou.|
|`data_criacao`|`DateTimeColumn`|`NOT NULL`|Data e hora da criação.|
|`data_atualizacao`|`DateTimeColumn`|`NOT NULL`|Data e hora da última atualização.|

**Notas Adicionais:**

- **Índice Único:** Um índice composto único nas colunas `usuario_id` e `tipo_fundo` garante que um usuário não possa ter mais de um fundo do mesmo tipo.
    
- **Criação Padrão:** A lógica da aplicação deve garantir que, ao criar um novo usuário, dois registros correspondentes sejam criados automaticamente nesta tabela.
    
- **Saldo MSP:** O `saldo_atual` do fundo "MSP" representa apenas o "Saldo Geral Disponível", ou seja, o dinheiro que não está alocado em "Caixinhas".
    

### **2.2.3. Tabela `Caixinhas`**

- **Descrição:** Armazena as "Caixinhas" ou "cofres" de objetivos criados pelo usuário.
    
- **Nome da Tabela no SQLite:** `caixinhas`
    

|**Coluna**|**Tipo Drift (Dart)**|**Restrições / Definição**|**Descrição**|
|---|---|---|---|
|`id`|`IntColumn`|`autoIncrement()`|Identificador único para a caixinha.|
|`usuario_id`|`IntColumn`|`references(Usuarios, #id)`|Chave estrangeira para o usuário.|
|`nome_caixinha`|`TextColumn`|`NOT NULL`|Nome personalizado da caixinha.|
|`saldo_atual`|`RealColumn`|`withDefault(Constant(0.0))`|Saldo monetário atual armazenado nesta caixinha.|
|`meta_valor`|`RealColumn`|`nullable()`|Valor da meta financeira opcional.|
|`deposito_obrigatorio`|`BoolColumn`|`withDefault(Constant(false))`|Booleano. Indica se o depósito para esta caixinha é obrigatório.|
|`status_caixinha`|`TextColumn`|`withDefault(Constant('ATIVA'))`|Status: "ATIVA", "CONCLUÍDA", "PAUSADA".|
|`data_conclusao`|`DateTimeColumn`|`nullable()`|Data em que a meta foi atingida.|
|`data_criacao`|`DateTimeColumn`|`NOT NULL`|Data e hora da criação.|
|`data_atualizacao`|`DateTimeColumn`|`NOT NULL`|Data e hora da atualização.|

**Notas Adicionais:**

- **Relação com MSP:** O saldo total do MSP é a soma do `saldo_atual` do fundo "MSP" na tabela `fundos_principais` com a soma dos `saldo_atual` de todas as caixinhas ativas nesta tabela.
    

### **2.2.4. Tabela `Emprestimos`**

- **Descrição:** Armazena os detalhes de cada empréstimo individual do FER.
    
- **Nome da Tabela no SQLite:** `emprestimos`
    

|**Coluna**|**Tipo Drift (Dart)**|**Restrições / Definição**|**Descrição**|
|---|---|---|---|
|`id`|`IntColumn`|`autoIncrement()`|Identificador único para o registro.|
|`usuario_id`|`IntColumn`|`references(Usuarios, #id)`|Chave estrangeira para o usuário.|
|`fundo_origem_id`|`IntColumn`|`references(FundosPrincipais, #id)`|Chave estrangeira para a origem (o registro do FER).|
|`valor_concedido`|`RealColumn`|`NOT NULL`|Montante original emprestado.|
|`saldo_devedor_atual`|`RealColumn`|`NOT NULL`|Saldo pendente atual (corrigido).|
|`proposito`|`TextColumn`|`nullable()`|Descrição breve do propósito.|
|`status_emprestimo`|`TextColumn`|`NOT NULL`|Status: "ATIVO", "QUITADO".|
|`data_concessao`|`DateTimeColumn`|`NOT NULL`|Data da concessão.|
|`data_quitacao`|`DateTimeColumn`|`nullable()`|Data da quitação total.|
|`data_ultimo_ajuste_inflacao`|`DateTimeColumn`|`nullable()`|Data do último ajuste por inflação.|
|`data_criacao`|`DateTimeColumn`|`NOT NULL`|Data da criação.|
|`data_atualizacao`|`DateTimeColumn`|`NOT NULL`|Data da atualização.|
|`data_exclusao`|`DateTimeColumn`|`nullable()`|Data da exclusão lógica.|

**Notas Adicionais:**

- **Fluxo de Dados:** Ao conceder um empréstimo, um novo registro é criado e o `saldo_atual` do FER é reduzido. Ao receber um pagamento, o `saldo_devedor_atual` é reduzido e o `saldo_atual` do FER é aumentado.
    

### **2.2.5. Tabela `Compromissos`**

- **Descrição:** Base para a funcionalidade do "Ciclo Mensal".
    
- **Nome da Tabela no SQLite:** `compromissos`
    

|**Coluna**|**Tipo Drift (Dart)**|**Restrições / Definição**|**Descrição**|
|---|---|---|---|
|`id`|`IntColumn`|`autoIncrement()`|Identificador único.|
|`usuario_id`|`IntColumn`|`references(Usuarios, #id)`|Chave estrangeira para o usuário.|
|`descricao`|`TextColumn`|`NOT NULL`|Descrição do compromisso.|
|`tipo_compromisso`|`TextColumn`|`NOT NULL`|Enum: "FACILITADOR_FER", "DEPOSITO_MSP", etc.|
|`valor_total_comprometido`|`RealColumn`|`nullable()`|Valor total a aportar (se houver fim).|
|`valor_parcela`|`RealColumn`|`NOT NULL`|Valor da parcela padrão.|
|`numero_total_parcelas`|`IntColumn`|`nullable()`|Número total de parcelas (se houver).|
|`numero_parcelas_pagas`|`IntColumn`|`withDefault(Constant(0))`|Quantidade de parcelas já pagas.|
|`fundo_principal_destino_id`|`IntColumn`|`nullable(), references(FundosPrincipais)`|FK se o destino for FER ou MSP Geral.|
|`caixinha_destino_id`|`IntColumn`|`nullable(), references(Caixinhas)`|FK se o destino for Caixinha.|
|`data_inicio_compromisso`|`DateTimeColumn`|`NOT NULL`|Data de início.|
|`data_proximo_vencimento`|`DateTimeColumn`|`nullable()`|Próxima data calculada.|
|`status_compromisso`|`TextColumn`|`withDefault(Constant('ATIVO'))`|Status: "ATIVO", "CONCLUIDO", "CANCELADO".|
|`ajuste_inflacao_aplicavel`|`BoolColumn`|`withDefault(Constant(false))`|Booleano. Se aplica inflação.|
|`data_criacao`|`DateTimeColumn`|`NOT NULL`|Data da criação.|
|`data_atualizacao`|`DateTimeColumn`|`NOT NULL`|Data da atualização.|
|`data_exclusao`|`DateTimeColumn`|`nullable()`|Data da exclusão lógica.|

**Notas Adicionais:**

- **Interação com `Transacoes`:** Quando uma parcela é paga, uma nova linha é inserida na tabela `Transacoes` com o campo `compromisso_id` preenchido.
    

### **2.2.6. Tabela `Transacoes`**

- **Descrição:** Livro-razão (ledger) central.
    
- **Nome da Tabela no SQLite:** `transacoes`
    

|**Coluna**|**Tipo Drift (Dart)**|**Restrições / Definição**|**Descrição**|
|---|---|---|---|
|`id`|`IntColumn`|`autoIncrement()`|Identificador único.|
|`usuario_id`|`IntColumn`|`references(Usuarios, #id)`|Chave estrangeira para o usuário.|
|`valor`|`RealColumn`|`NOT NULL`|O montante monetário.|
|`data_transacao`|`DateTimeColumn`|`NOT NULL`|Data efetiva da ocorrência.|
|`descricao`|`TextColumn`|`NOT NULL`|Descrição da transação.|
|`tipo_transacao`|`TextColumn`|`NOT NULL`|Categoria (Depósito, Pagto Facilitador, etc).|
|`fundo_principal_origem_id`|`IntColumn`|`nullable(), references(FundosPrincipais)`|De onde saiu o dinheiro.|
|`caixinha_origem_id`|`IntColumn`|`nullable(), references(Caixinhas)`|De qual caixinha saiu.|
|`fundo_principal_destino_id`|`IntColumn`|`nullable(), references(FundosPrincipais)`|Para onde foi o dinheiro.|
|`caixinha_destino_id`|`IntColumn`|`nullable(), references(Caixinhas)`|Para qual caixinha foi.|
|`emprestimo_id`|`IntColumn`|`nullable(), references(Emprestimos)`|Vínculo com empréstimo.|
|`compromisso_id`|`IntColumn`|`nullable(), references(Compromissos)`|Vínculo com pagamento de parcela.|
|`data_criacao`|`DateTimeColumn`|`NOT NULL`|Data da criação.|
|`data_atualizacao`|`DateTimeColumn`|`NOT NULL`|Data da atualização.|
|`data_exclusao`|`DateTimeColumn`|`nullable()`|Data da exclusão lógica.|

**Notas Adicionais:**

- **Fonte da Verdade:** Os valores em `saldo_atual` nas outras tabelas devem ser sempre o resultado da soma de todas as transações relevantes.
    

---

## **2.3. Estrutura dos DAOs (Accessors no Drift)**

Os DAOs (chamados de **Accessors** no Drift) são um componente central. Eles são responsáveis por definir o contrato de comunicação entre a aplicação e o banco de dados.

### **Princípios Gerais dos DAOs no Projeto:**

1. **Definição Declarativa e Fluente:** Diferente do Room que usa SQL puro em Strings, no Drift utilizaremos a sintaxe fluente do Dart (`select(users)...`), que é type-safe, embora SQL puro também seja suportado se necessário.
    
2. **Separação de Responsabilidades:** Os DAOs encapsulam a lógica de query. Os Repositórios chamarão os métodos do DAO.
    
3. **Segurança em Tempo de Compilação:** O Drift valida todas as queries durante o processo de build (`build_runner`), prevenindo erros de sintaxe.
    
4. **Reatividade com `Stream`:** Priorizaremos o uso de `Stream` como tipo de retorno para as queries de leitura. Isso permite que a camada de UI (via Riverpod) observe as mudanças no banco de dados de forma reativa e se atualize automaticamente.
    

### **DAOs a Serem Criados:**

- `UsuariosDao`
    
- `FundosPrincipaisDao`
    
- `CaixinhasDao`
    
- `EmprestimosDao`
    
- `CompromissosDao`
    
- `TransacoesDao`
    

### **Padrão de Métodos em cada DAO:**

A maioria dos DAOs seguirá um padrão de métodos similar:

- **Inserção (`insert`):** Método para criar novos registros.
    
- **Atualização (`update`):** Método para atualizar um registro existente.
    
- **Exclusão (`delete`):** Método para remover registros (Hard Delete, com regras de negócio para arquivamento se necessário).
    
- **Leitura (`watch`/`get`):**
    
    - Métodos para buscar um registro específico por ID.
        
    - Métodos para buscar todos os registros ativos (`where((t) => t.dataExclusao.isNull())`).
        
    - Métodos que retornam `Stream` para observação em tempo real.
        
- **Transações:** Operações complexas que envolvem múltiplas tabelas (ex: pagar parcela e atualizar saldo) serão executadas dentro de blocos `transaction`.
    

---

# 3. Detalhamento de Lógicas de Negócio Críticas

Esta é a rotina operacional mais importante do aplicativo, responsável por consolidar e processar os compromissos financeiros do usuário a cada mês. O processo é acionado no dia do mês configurado pelo usuário em `usuarios.dia_revisao_mensal`.

O fluxo lógico pode ser dividido nos seguintes passos:

## **3.1. Lógica do Ciclo Mensal de Compromissos**

### **Passo 1: Gatilho do Ciclo**

- O aplicativo deve verificar diariamente (via `workmanager`) se o dia atual corresponde ao `dia_revisao_mensal` do usuário.
    
- Ao detectar que é o dia correto, o processo do ciclo mensal é iniciado.
    

### **Passo 2: Aplicação de Ajustes por Inflação**

- Antes de consolidar as parcelas, o sistema primeiro aplica os ajustes de inflação, conforme definido nas configurações do usuário.
    
- **Ação:**
    
    1. O sistema busca a taxa de inflação mensal de referência (ex: IPCA) via API.
        
    2. Se a taxa for positiva, ele identifica todos os `Emprestimos` e `Compromissos` ativos que estão marcados para receber ajuste.
        
    3. Para cada item, o sistema calcula o valor do ajuste sobre o saldo devedor/remanescente e atualiza o valor na respectiva tabela (`emprestimos.saldo_devedor_atual` ou `compromissos.valor_total_comprometido`).
        
    4. Para fins de rastreabilidade, uma `Transacao` do tipo `AJUSTE_INFLACAO` é registrada para cada ajuste realizado, vinculada ao empréstimo ou compromisso correspondente.
        

### **Passo 3: Consolidação dos Compromissos do Mês**

- **Ação:**
    
    1. O sistema consulta a tabela `Compromissos` para encontrar todos os registros ativos (`status_compromisso = 'ATIVO'`) cujo `data_proximo_vencimento` cai no mês corrente.
        
    2. Para cada `Emprestimo` ativo, o sistema calcula o valor da parcela devida para o mês, com base na "Unidade" de pagamento do usuário.
        
    3. O sistema agrega todos esses itens em uma lista consolidada.
        

### **Passo 4: Apresentação na Tela de Revisão**

- A lista consolidada é apresentada ao usuário na tela "Ciclo Mensal de Compromissos", que projetamos visualmente.
    
- A tela exibe o valor total devido no mês, com a quebra entre os valores destinados ao FER e ao MSP.
    

### **Passo 5: Processamento da Confirmação do Usuário**

- O usuário informa o valor total que ele está "confirmando" (pagando) naquele mês. A lógica então trata três cenários principais:
    
    - **Cenário A: Pagamento Exato (`valor_pago == valor_devido`)**
        
        - O sistema cria uma `Transacao` para cada item da lista de compromissos.
            
        - Atualiza o `numero_parcelas_pagas` de cada `Compromisso` e o `saldo_devedor_atual` de cada `Emprestimo` pago.
            
        - Atualiza os saldos (`saldo_atual`) dos `FundosPrincipais` e `Caixinhas` de destino.
            
        - Atualiza o status dos compromissos/empréstimos para "CONCLUIDO" se forem quitados.
            
    - **Cenário B: Pagamento Inferior (`valor_pago < valor_devido`)**
        
        - O sistema segue a regra de prioridade: os compromissos com o FER (empréstimos e facilitadores) devem ser pagos primeiro.
            
        - Se o valor pago não cobrir o total devido ao FER, o sistema calcula o déficit.
            
        - Com base na preferência do usuário nas configurações, o sistema irá:
            
            1. Sugerir a criação de um novo `Emprestimo` do FER para cobrir o déficit; ou
                
            2. Sugerir o uso de fundos do "Meu Saldo Pessoal (MSP)" para cobrir o déficit.
                
    - **Cenário C: Pagamento Superior (`valor_pago > valor_devido`)**
        
        - Todos os compromissos do mês são quitados primeiro.
            
        - O sistema então apresenta ao usuário opções para alocar o valor excedente, seguindo a ordem de prioridade definida nas configurações (ex: 1º Amortizar Empréstimos, 2º Quitar Facilitadores, etc.).
            

### **Passo 6: Finalização do Ciclo**

- Após o processamento dos pagamentos, o sistema atualiza a `data_proximo_vencimento` de todos os compromissos recorrentes para o mês seguinte.
    
- A tela é atualizada para refletir o novo status ("Compromissos de Junho concluídos!").
    

---

## **3.2. Lógica da Conciliação de Saldos (Tratamento de Diferenças)**

Esta funcionalidade permite que o usuário mantenha os saldos virtuais do aplicativo sincronizados com seus saldos financeiros do mundo real. O fluxo é iniciado pelo usuário e segue uma série de regras estritas para garantir que o "Capital do Fundo Escada Rolante (FER)" nunca tenha uma perda não contabilizada, conforme a regra fundamental do sistema.

O processo lógico é o seguinte:

### **Passo 1: Entrada do Usuário**

- O usuário navega para a tela de "Conciliação de Saldos".
    
- O aplicativo solicita que ele insira um único valor: o `saldo_real_total`, que é a soma de todos os seus saldos em contas bancárias/investimentos que ele considera parte deste sistema.
    

### **Passo 2: Cálculo do Saldo Virtual Total**

- A aplicação calcula o `saldo_virtual_total` esperado. A fórmula é: `saldo_virtual_total = (saldo_atual do FER) + (saldo_atual do MSP Geral) + (SOMA(saldo_atual) de todas as Caixinhas ativas)`
    
- Os valores são obtidos das tabelas `fundos_principais` e `caixinhas`.
    

### **Passo 3: Apuração da Diferença**

- O sistema calcula a diferença: `diferenca = saldo_real_total - saldo_virtual_total`.
    
- A lógica então se ramifica com base no sinal desta diferença.
    

### **Passo 4: Tratamento da Diferença**

- **Cenário A: Diferença Positiva (`diferenca > 0`) - Tratado como Rendimento**
    
    - Uma diferença positiva é interpretada como um ganho não contabilizado (rendimentos, juros, etc.).
        
    - **Ação:** O sistema distribui esse ganho proporcionalmente entre o FER e o MSP, conforme a regra definida na documentação funcional (7.5).
        
        1. Calcula a proporção de cada fundo no `saldo_virtual_total`. Ex: `proporcao_fer = saldo_fer / saldo_virtual_total`.
            
        2. Calcula o valor do ganho para cada fundo. Ex: `ganho_fer = diferenca * proporcao_fer`.
            
        3. Atualiza o `saldo_atual` do registro do FER e do MSP Geral na tabela `fundos_principais`.
            
        4. Registra duas novas `Transacoes`: uma do tipo `REGISTRO_RENDIMENTO_FER` creditando o FER, e outra do tipo `REGISTRO_RENDIMENTO_MSP` creditando o MSP Geral, para fins de histórico.
            
- **Cenário B: Diferença Negativa (`diferenca < 0`) - Tratado como Discrepância**
    
    - Uma diferença negativa significa que o usuário tem menos dinheiro na realidade do que o app registrou. Este é o cenário mais crítico e segue uma regra de duas etapas, conforme a documentação funcional (5.5).
        
    - **Ação:**
        
        1. **Justificação pelo Usuário:** O aplicativo informa ao usuário o valor da discrepância (ex: "Foi encontrada uma diferença negativa de R$ 50,00.") e oferece a opção de justificar esse valor como um "Uso de Saldo Pessoal (MSP)" que não foi registrado.
            
        2. O usuário pode inserir um valor a ser justificado. A aplicação debita essa quantia justificada do "Meu Saldo Pessoal" (geralmente do Saldo Geral), registrando uma `Transacao` do tipo `USO_MSP_CONCILIACAO`.
            
        3. **Empréstimo Obrigatório do FER:** Se, após a justificação, ainda houver uma diferença negativa remanescente (ou se o usuário não justificar nenhum valor), **este valor restante obrigatoriamente gera um novo Empréstimo do FER para o usuário.**
            
        4. O sistema cria um novo registro na tabela `emprestimos` no valor da diferença restante.
            
        5. Uma `Transacao` do tipo `CONCESSAO_EMPRESTIMO_CONCILIACAO` é registrada, debitando o `saldo_atual` do FER e vinculando-a ao novo empréstimo.
            

### **Passo 5: Conclusão e Feedback**

- Após os ajustes, o `saldo_virtual_total` do aplicativo estará alinhado com o `saldo_real_total` informado.
    
- O aplicativo exibe um resumo claro das ações que foram tomadas (ex: "Rendimento de R$20,00 alocado." ou "Discrepância resolvida com R$15,00 de Uso de MSP e um novo Empréstimo de R$35,00.").
    

---

## **3.3. Lógica do Ajuste por Inflação**

Este mecanismo é projetado para proteger o poder de compra dos fundos, principalmente o FER, contra a erosão inflacionária, conforme descrito na seção **3.3** da documentação funcional. A lógica é executada como o primeiro passo do "Ciclo Mensal de Compromissos".

O processo lógico é o seguinte:

### **Passo 1: Gatilho e Obtenção da Taxa**

- No "Dia de Vencimento/Revisão" configurado pelo usuário, o sistema inicia este processo.
    
- A primeira ação é consultar uma fonte de dados externa (API pública, como a do IBGE) para obter a taxa de inflação do último mês fechado.
    
- A lógica deve ser capaz de lidar com falhas na API (ex: sem conexão com a internet), pulando o ajuste para o mês corrente e, opcionalmente, registrando um alerta para o usuário.
    

### **Passo 2: Validação da Taxa**

- O sistema verifica se a `taxa_inflacao_mensal` obtida é positiva (`> 0`).
    
- Conforme a regra, se a taxa for zero ou negativa (deflação), o processo de ajuste é interrompido para o mês corrente, e o sistema prossegue para o próximo passo do Ciclo Mensal.
    

### **Passo 3: Identificação dos Itens a Serem Ajustados**

- O sistema consulta as configurações de inflação na tabela `usuarios` para saber a quais tipos de compromisso o ajuste deve ser aplicado (Empréstimos, Facilitadores, Depósitos Pessoais).
    
- Em seguida, o sistema busca todos os registros com `status` = "ATIVO" nas tabelas `emprestimos` e `compromissos` que correspondam às preferências de ajuste do usuário.
    

### **Passo 4: Aplicação e Registro do Ajuste**

- O sistema itera sobre cada item identificado e aplica o ajuste:
    
    - **Para cada `Emprestimo` ativo:**
        
        1. **Cálculo:** `valor_ajuste = emprestimos.saldo_devedor_atual * taxa_inflacao_mensal`.
            
        2. **Atualização:** O campo `emprestimos.saldo_devedor_atual` é incrementado com o `valor_ajuste`. O campo `emprestimos.data_ultimo_ajuste_inflacao` é atualizado com a data atual.
            
        3. **Registro:** Uma nova `Transacao` é criada com `tipo_transacao = AJUSTE_INFLACAO_EMPRESTIMO`, o `valor` do ajuste e o `emprestimo_id` correspondente. Esta transação é de natureza contábil e não afeta o saldo líquido dos fundos, mas garante um histórico transparente.
            
    - **Para cada `Compromisso` ativo:**
        
        1. **Cálculo do Saldo Remanescente:** `saldo_remanescente = compromissos.valor_total_comprometido - (compromissos.numero_parcelas_pagas * compromissos.valor_parcela)`.
            
        2. **Cálculo do Ajuste:** `valor_ajuste = saldo_remanescente * taxa_inflacao_mensal`.
            
        3. **Atualização:** O campo `compromissos.valor_total_comprometido` é incrementado com o `valor_ajuste`. Isso fará com que o número de parcelas ou o valor da última parcela ("resto") aumente naturalmente para cobrir o novo total.
            
        4. **Registro:** Assim como nos empréstimos, uma `Transacao` pode ser criada para registrar o ajuste para fins de auditoria, vinculada ao `compromisso_id`.
            

### **Passo 5: Conclusão**

- Após todos os ajustes serem aplicados e registrados, o sistema prossegue para o passo seguinte do Ciclo Mensal: a consolidação das parcelas (já corrigidas) para apresentação ao usuário.
    
- O usuário poderá ver o histórico de todos os ajustes aplicados nos relatórios detalhados de empréstimos e compromissos, conforme a seção **6.3** da documentação funcional.
    

## **3.4. Lógica de Autenticação e Recuperação (Lock System)**

O sistema de bloqueio ("Lock Screen") opera como uma camada superior e independente da arquitetura principal do app. Sua função é descriptografar ou liberar o acesso à UI, garantindo a privacidade dos dados financeiros locais.

### **Fluxo de Inicialização e Bloqueio:**

1. Ao iniciar, o app consulta o `FlutterSecureStorage` para verificar a existência de uma chave `user_pin`.
    
2. **Se não existir (Primeiro Acesso):** Redireciona para o fluxo de Onboarding.
    
3. **Se existir:** Exibe a tela de bloqueio e aguarda a entrada do PIN ou validação biométrica.
    

### **Fluxo de Recuperação de Acesso (Esqueci meu PIN):**

Este fluxo resolve o problema crítico de apps _Local-First_ (perda de senha = perda de dados) utilizando a conta de nuvem do usuário como validador de identidade.

1. **Pré-requisito:** O usuário deve ter vinculado uma conta (Google) nas configurações ou onboarding. O e-mail desta conta é armazenado de forma segura no dispositivo (`recovery_email`).
    
2. **Gatilho:** O usuário aciona "Esqueci meu código" na tela de bloqueio.
    
3. **Autenticação Externa:** O app invoca o fluxo de login OAuth2 (via `googleapis`), solicitando que o usuário faça login na sua conta de nuvem.
    
4. **Validação de Identidade:**
    
    - O sistema compara o e-mail retornado pelo token de autenticação com o `recovery_email` armazenado no `SecureStorage`.
        
    - **Match Positivo (`emails iguais`):** O sistema libera o fluxo de "Redefinição de PIN". O usuário cria um novo código, o `SecureStorage` é atualizado, e o banco de dados SQLite (`db.sqlite`) é preservado intacto.
        
    - **Match Negativo ou Erro:** O acesso permanece negado.
        
5. **Fallback:** Se o usuário não tiver vinculado uma conta anteriormente, a única opção apresentada será o "Reset de Fábrica" (apagar banco de dados e chaves).
---

# 4. Design da Interface (UI-UX)

Este capítulo documenta o design visual e a experiência do usuário para as telas centrais do aplicativo. O design segue os princípios do Material Design 3, com um tema escuro e foco na clareza e usabilidade. Para cada tela, apresentamos o mockup visual gerado e um "wireframe textual" que descreve seus componentes e funcionalidades.

## **4.1. Mockups Visuais e Wireframes das Telas**

### **4.1.1. Tela: Painel Principal (Dashboard)**

- **Mockup Visual:**
    
    (Nota: Referência ao arquivo `Copilot_20250618_201554.png`)
    
- **Wireframe Textual:**
    
    - **Propósito:** Fornecer ao usuário uma visão geral e imediata dos seus dois principais fundos (FER e MSP), destacar a "saúde" do Fundo Escada Rolante e dar acesso rápido às ações mais comuns.
        
    - **Componentes:**
        
        - **Barra Superior:** Título "Meu Painel". (Ícone de configurações removido em favor da aba Perfil).
            
        - **Card "Fundo Escada Rolante (FER)":**
            
            - Exibe o "Saldo Disponível" em destaque.
                
            - Informa o "Patrimônio Total" e o "Pico de Patrimônio".
                
            - Contém um indicador visual (ex: anel de progresso) para a "Saúde do Fundo", mostrando o percentual do capital que está emprestado.
                
            - **Interação:** Tocar neste card leva o usuário para a tela de "Detalhes do FER".
                
        - **Card "Meu Saldo Pessoal (MSP)":**
            
            - Exibe o "Dinheiro Total" do MSP (calculado) em destaque.
                
            - Mostra uma quebra visual (ex: barra de progresso) entre o "Saldo Geral Disponível" e o total "Em Caixinhas".
                
            - **Interação:** Tocar neste card leva o usuário para a tela de "Gerenciamento do MSP e Caixinhas".
                
        - **Seção "Compromissos do Mês":**
            
            - Uma pequena lista mostrando os próximos compromissos para o mês corrente.
                
            - **Interação:** Tocar em "Ver todos" leva para a tela do "Ciclo Mensal de Compromissos".
                
        - **Botão de Ação Flutuante (FAB):**
            
            - Um botão `+` proeminente no canto inferior direito.
                
            - **Interação:** Ao ser tocado, deve apresentar um menu com ações rápidas como "Registrar Transação", "Registrar Facilitador" e "Solicitar Empréstimo".
                

### **4.1.2. Tela: Detalhes do FER**

- **Mockup Visual:**
    
    (Nota: Referência ao arquivo `Copilot_20250618_201619.png`)
    
- **Wireframe Textual:**
    
    - **Propósito:** Oferecer ao usuário uma visão detalhada do "Fundo Escada Rolante", incluindo seus principais indicadores, ações relacionadas e um histórico completo de transações.
        
    - **Componentes:**
        
        - **Barra Superior:** Título "Detalhes do FER", um ícone de "voltar" (seta para a esquerda) e um ícone de "mais opções" (três pontos verticais).
            
        - **Card de Resumo:**
            
            - Exibe o "Saldo Disponível" em destaque, seguido pelo "Patrimônio Total" e o "Pico de Patrimônio".
                
        - **Seção de Ações Rápidas:**
            
            - Um conjunto de botões para as ações mais comuns relacionadas ao FER, como "Adicionar Facilitador" e "Novo Empréstimo".
                
        - **Lista de Histórico de Transações:**
            
            - A parte principal da tela, com o título "Histórico de Transações".
                
            - Uma lista vertical rolável de todas as transações que afetam o FER.
                
            - Cada item da lista deve exibir a data, a descrição e o valor da transação.
                
            - O valor deve ser formatado com um sinal de `+` e cor verde para entradas (aportes de facilitadores, pagamentos de empréstimos) e um sinal de `-` com cor vermelha para saídas (concessão de empréstimos).
                

### **4.1.3. Tela: Gerenciamento do MSP e Caixinhas**

- **Mockup Visual:**
    
    (Nota: Referência ao arquivo `Copilot_20250618_201625.png`)
    
- **Wireframe Textual:**
    
    - **Propósito:** Apresentar uma visão detalhada do "Meu Saldo Pessoal (MSP)", permitindo ao usuário ver o saldo geral disponível e gerenciar suas "Caixinhas" de objetivos.
        
    - **Componentes:**
        
        - **Barra Superior:** Título "Meu Saldo Pessoal", um ícone de "voltar" (seta para a esquerda) e um ícone para "Adicionar Nova Caixinha" (+).
            
        - **Card de Resumo do MSP:**
            
            - Exibe o "Saldo Geral Disponível" em destaque.
                
            - Informa o "Total em Caixinhas" e o "Total MSP" (a soma dos dois).
                
        - **Lista de "Suas Caixinhas":**
            
            - A parte principal da tela, com o título "Suas Caixinhas".
                
            - Uma lista vertical rolável de cards, onde cada card representa uma caixinha.
                
            - **Cada card de caixinha exibe:**
                
                - O nome da caixinha.
                    
                - O saldo atual da caixinha.
                    
                - Se houver uma meta definida, uma barra de progresso visual e o valor da meta.
                    
                - O status da caixinha (ex: "Ativa").
                    
            - **Interação:** Tocar em um card de caixinha poderia levar a uma tela de detalhes daquela caixinha específica, com seu histórico de transações.
                
        - **Botão de Ação Flutuante (FAB):**
            
            - Um botão `+` que pode ser usado para registrar rapidamente uma nova transação (receita, despesa ou transferência) relacionada ao MSP.
                

### **4.1.4. Tela: Ciclo Mensal de Compromissos**

- **Mockup Visual:**
    
    (Nota: Referência ao arquivo `Copilot_20250618_201631.png`)
    
- **Wireframe Textual:**
    
    - **Propósito:** Apresentar ao usuário uma lista consolidada de todos os seus compromissos financeiros para o mês corrente, permitindo que ele revise e confirme a realização desses aportes.
        
    - **Componentes:**
        
        - **Barra Superior:** Título dinâmico com o mês atual (ex: "Compromissos de Junho"), um ícone de "voltar" e um ícone de "informação" (i) para explicar a funcionalidade da tela.
            
        - **Card de Resumo Total:**
            
            - Exibe o "Total do Mês" em destaque.
                
            - Mostra um detalhamento dos valores totais destinados ao "Fundo (FER)" e a "Você (MSP)".
                
        - **Lista Detalhada de Compromissos:**
            
            - A lista é dividida por subtítulos para maior clareza: "Aportes para o Fundo (FER)" e "Aportes para Você (MSP)".
                
            - Cada compromisso é apresentado como um item ou card individual, contendo um ícone, a descrição do compromisso e o valor da parcela do mês.
                
        - **Botão de Ação Principal:**
            
            - Um botão de largura total, fixo no rodapé da tela, com o texto "Confirmar Compromissos de [Mês]".
                
            - **Interação:** Ao ser tocado, inicia o fluxo de confirmação, onde o usuário informará o valor total que está "pagando", acionando as lógicas de tratamento de déficit ou superávit que definimos.
                

### **4.1.5. Tela: Nova Transação**

- **Mockup Visual:**
    
    (Nota: Referência ao arquivo `Copilot_20250618_201638.png`)
    
- **Wireframe Textual:**
    
    - **Propósito:** Fornecer uma interface unificada e intuitiva para o usuário registrar suas movimentações financeiras relacionadas ao "Meu Saldo Pessoal (MSP)", como receitas, despesas e transferências internas.
        
    - **Componentes:**
        
        - **Barra Superior:** Título "Nova Transação" e um ícone de "voltar".
            
        - **Seletor de Tipo:** Um conjunto de botões de alternância para o usuário selecionar o tipo de transação: **"Receita"**, **"Despesa"** ou **"Transferência"**.
            
        - **Formulário de Entrada:**
            
            - Campo para "Valor" monetário.
                
            - Campo de texto para "Descrição".
                
            - Campo de "Data" com um seletor de calendário.
                
        - **Campos Dinâmicos de Origem/Destino:** A parte central da tela, cujo conteúdo muda com base no tipo de transação selecionado:
            
            - Se **"Receita"**: Exibe um único seletor/dropdown chamado **"Depositar Em"**, listando o "Saldo Geral MSP" e todas as "Caixinhas" do usuário.
                
            - Se **"Despesa"**: Exibe um único seletor/dropdown chamado **"Retirar De"**, listando o "Saldo Geral MSP" e todas as "Caixinhas".
                
            - Se **"Transferência"**: Exibe dois seletores/dropdowns: **"Retirar De" (Origem)** e **"Depositar Em" (Destino)**.
                
        - **Botão de Ação Principal:**
            
            - Um botão de largura total, fixo no rodapé da tela, com o texto "Salvar Transação".
                

### **4.1.6. Tela: Configurações**

- **Mockup Visual:**
    
    (Nota: Referência ao arquivo `Copilot_20250618_201644.png`)
    
- **Wireframe Textual:**
    
    - **Propósito:** Servir como o painel de controle central do aplicativo, onde o usuário pode personalizar as regras do sistema, gerenciar seus dados e acessar informações sobre o aplicativo.
        
    - **Componentes:**
        
        - **Barra Superior:** Título "Configurações" e um ícone de "voltar".
            
        - **Lista de Opções Agrupadas por Seções:**
            
            - **Seção "Conta e Dados":**
                
                - Item para "Backup e Restauração na Nuvem", que mostra o status da conexão atual e leva à tela de gerenciamento de backups.
                    
            - **Seção "Preferências do Aplicativo":**
                
                - Item para editar a "Unidade de Pagamento Padrão".
                    
                - Item para alterar o "Dia da Revisão Mensal".
                    
                - Item que navega para uma sub-tela de "Configurações de Inflação", com os toggles para cada tipo de compromisso.
                    
                - Item opcional para configurar os "Limites de Saúde do Fundo".
                    
            - **Seção "Sobre":**
                
                - Links para "Sobre o Aplicativo" (com a versão), "Avalie o Aplicativo", "Termos de Serviço" e "Política de Privacidade".
                    
        - **Rodapé:** Exibição da versão atual do aplicativo.
            

---

## **4.2. Fluxo de Navegação Principal**

Esta seção descreve a estrutura de navegação primária do aplicativo. A navegação será implementada utilizando o componente **GoRouter** (ou Navigator 2.0), gerenciando a pilha de telas e as rotas.

### **Ponto de Entrada:**

- O aplicativo é iniciado e a primeira tela exibida é o **`Painel Principal (Dashboard)`**.
    

### **Fluxos a partir do `Painel Principal (Dashboard)`:**

1. `Painel Principal` → **Toque no Card "Fundo Escada Rolante (FER)"** → Navega para a `Tela de Detalhes do FER`.
    
2. `Painel Principal` → **Toque no Card "Meu Saldo Pessoal (MSP)"** → Navega para a `Tela de Gerenciamento do MSP e Caixinhas`.
    
3. `Painel Principal` → **Toque no link "Ver todos" dos Compromissos** → Navega para a `Tela do Ciclo Mensal de Compromissos`.
    
4. `Painel Principal` → **Toque no Ícone de Configurações (engrenagem)** → Navega para a `Tela de Configurações`.
    
5. `Painel Principal` → **Toque no Botão de Ação Flutuante (+)** → Abre um menu de ações rápidas. A seleção de uma opção navega para a tela correspondente:
    
    - "Registrar Transação" → `Tela de Nova Transação`.
        
    - "Registrar Facilitador" → `Tela de Novo Compromisso` (pré-selecionada para Facilitador).
        
    - "Solicitar Empréstimo" → `Tela de Novo Empréstimo`.
        

### **Navegação de Retorno:**

- Em todas as telas secundárias, o **ícone de seta para a esquerda** na Barra Superior sempre retornará o usuário à tela anterior na pilha de navegação.
    

### **Fluxos de Sub-navegação:**

- `Tela de Configurações` → **Toque em "Backup e Restauração na Nuvem"** → Navega para uma `Tela de Gerenciamento de Backup`.
    
- `Tela de Gerenciamento do MSP e Caixinhas` → **Toque no ícone +** → Navega para a `Tela de Nova Caixinha`.
    

---

# 5. Funcionalidades Externas

Este capítulo detalha as integrações do aplicativo com serviços de terceiros, que são cruciais para funcionalidades que vão além do armazenamento de dados local.

## **5.1. Fluxo de Backup e Restauração na Nuvem (Google Drive/OneDrive)**

Para garantir a segurança dos dados do usuário e permitir a portabilidade entre dispositivos, o aplicativo implementará uma funcionalidade de backup e restauração utilizando os serviços de nuvem pessoal do usuário.

### **Princípios Fundamentais:**

- **Controle do Usuário:** Os dados são salvos na conta pessoal do usuário (Google Drive ou OneDrive), e não em um servidor do aplicativo. O usuário tem total controle sobre seus arquivos de backup.
    
- **Segurança:** A autenticação é realizada via protocolos seguros (OAuth 2.0) diretamente com o provedor de nuvem, e o aplicativo só solicita permissão para acessar a sua própria pasta de dados.
    
- **Flexibilidade:** O sistema suportará dois tipos de backup: um **"Backup da Última Versão"** para recuperação rápida e **"Pontos de Restauração"** nomeados, que são preservados e não são sobrescritos automaticamente.
    

### **Fluxo de Autenticação:**

1. **Início:** Na tela de "Configurações", o usuário seleciona a opção "Conectar" para o serviço de nuvem desejado (Google Drive ou OneDrive).
    
2. **Solicitação de Conta:** O aplicativo, utilizando o SDK oficial do provedor (Google Sign-In ou MSAL), solicita que o usuário escolha uma conta existente no dispositivo.
    
3. **Pedido de Permissão:** Uma tela de consentimento do provedor de nuvem é exibida, solicitando permissão para que o aplicativo acesse e gerencie os arquivos _que ele mesmo criar_ em uma pasta específica.
    
4. **Confirmação:** Após o consentimento do usuário, o aplicativo recebe a autorização para interagir com a API do serviço de nuvem. A UI é atualizada para mostrar a conta conectada.
    
5. **Tratamento de Falhas:** Se o usuário negar a permissão ou se houver uma falha de rede, o aplicativo exibirá uma mensagem informativa.
    

### **Fluxo de Criação de Backup (Manual):**

1. **Ação do Usuário:** O usuário seleciona "Fazer Backup Agora" (para o backup da última versão) ou "Criar Ponto de Restauração".
    
2. **Execução em Segundo Plano:** A operação é delegada a um `workmanager` para garantir que ela seja concluída mesmo que o aplicativo seja fechado.
    
3. **Processo do Worker:**
    
    - O Drift realiza um _checkpoint_ para garantir que todos os dados do arquivo WAL foram mesclados ao arquivo `.sqlite` principal.
        
    - Cria uma cópia segura do arquivo do banco de dados SQLite local.
        
    - Define um nome para o arquivo na nuvem (ex: `backup_latest.db` ou `ponto_restauracao_[nome]_[data].db`).
        
    - Faz o upload do arquivo para a pasta designada na nuvem do usuário.
        
    - Após o sucesso, limpa a cópia temporária do dispositivo.
        
    - Notifica a UI sobre o resultado (sucesso ou falha).
        

### **Fluxo de Restauração de Dados:**

1. **Ação do Usuário:** O usuário seleciona "Restaurar Dados" na tela de configurações.
    
2. **Listagem de Backups:** O aplicativo consulta a pasta de backup na nuvem e exibe uma lista de todos os backups disponíveis.
    
3. **Seleção e Confirmação Crítica:** O usuário seleciona o backup desejado. O aplicativo exibe um **aviso enfático** de que a restauração substituirá todos os dados locais atuais.
    
4. **Execução da Restauração:** Após a confirmação, um worker executa a tarefa:
    
    - Baixa o arquivo de backup selecionado para um local temporário.
        
    - **Fecha todas as conexões** com o banco de dados Drift local para evitar corrupção.
        
    - **Substitui** os arquivos do banco de dados local (`db.sqlite`) pelo arquivo de backup baixado.
        
    - **Reinicia o aplicativo:** Esta é a abordagem mais segura para garantir que todas as partes do aplicativo carreguem os novos dados corretamente.
        
5. **Feedback Final:** Após o reinício, uma mensagem confirma o sucesso ou a falha da restauração.
    

---

# 6. Padrões e Convenções de Código

Este capítulo final estabelece as diretrizes e padrões de codificação a serem seguidos durante o desenvolvimento do aplicativo "Gradus" em Dart/Flutter.

## **6.1. Convenções de Nomenclatura**

- **Pacotes e Arquivos:** Nomes em `snake_case`. Ex: `usuario_repository.dart`.
    
- **Classes, Interfaces e Widgets:** `UpperCamelCase`. Ex: `UsuarioRepository`, `DashboardScreen`.
    
- **Métodos, Variáveis e Parâmetros:** `lowerCamelCase`. Ex: `salvarNovoCompromisso()`, `saldoDevedorAtual`.
    
- **Constantes:** `lowerCamelCase` (preferência do Dart moderno para constantes locais) ou `SCREAMING_SNAKE_CASE` (para constantes globais importantes).
    

## **6.2. Padrões de Formatação e Estilo**

- **Effective Dart:** Seguiremos as diretrizes oficiais do "Effective Dart" e utilizaremos o pacote `flutter_lints` para análise estática.
    
- **Comentários e Documentação:**
    
    - **Doc Comments (`///`):** Utilizados para documentar classes e métodos públicos. Devem explicar a **intenção ("o porquê")** daquele código.
        
- **Princípios Gerais:**
    
    - **DRY (Don't Repeat Yourself):** Evitar a duplicação de código.
        
    - **KISS (Keep It Simple, Stupid):** Dar preferência a soluções simples e diretas.
        
    - **Responsabilidade Única:** Cada classe e método deve ter uma responsabilidade única e bem definida, em alinhamento com a Clean Architecture.