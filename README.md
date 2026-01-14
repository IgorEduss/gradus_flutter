<p align="center">
  <img src="assets/images/logo.png" alt="Logo Gradus" width="200" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?style=flat&logo=flutter" alt="Flutter Version" />
  <img src="https://img.shields.io/badge/Dart-3.x-blue?style=flat&logo=dart" alt="Dart Version" />
  <img src="https://img.shields.io/badge/Architecture-Clean-green?style=flat" alt="Clean Architecture" />
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=flat" alt="License" />
</p>

# Gradus - Aplicação de Finanças Pessoais (Teoria da Escada Rolante)

> "Transforme economias fortuitas em investimento consciente."

O **Gradus** é uma aplicação mobile desenvolvida em Flutter que materializa o "Princípio da Escada Rolante". Diferente de gerenciadores financeiros comuns, ele foca na **autorresponsabilidade**: converter descontos e economias inesperadas em aportes para um fundo de crescimento pessoal (FER), utilizando lógica de juros e correção monetária.

## 📱 Sobre o Projeto

Este projeto foi desenvolvido com foco em **Engenharia de Software robusta**, utilizando arquitetura limpa e padrões de mercado para garantir escalabilidade e testabilidade. O app opera sob o conceito *Local-First*, garantindo privacidade total dos dados, com sincronização opcional em nuvem.

### 🎥 Demonstração

<p align="center">
  <img src="assets/images/gradus.gif" alt="Demo do App Gradus" width="200" />
</p>


## 🛠️ Stack Tecnológica & Arquitetura

O projeto segue estritamente a **Clean Architecture** dividida em camadas (`Domain`, `Data`, `Presentation`) com **MVVM**.

* **Linguagem:** Dart (Null Safety)
* **Framework:** Flutter (Android/iOS)
* **Gerenciamento de Estado:** Riverpod (Providers e Notifiers - Code Gen)
* **Banco de Dados Local:** SQLite via **Drift** (Persistência reativa e segura)
* **Injeção de Dependência:** GetIt + Injectable
* **Integração Cloud:** Google Drive API (para backups criptografados)
* **UI:** Material Design 3

## 🧠 Desafios Técnicos e Soluções

### 1. Motor de Processamento do Ciclo Mensal
Implementação de um algoritmo complexo que consolida compromissos financeiros. O sistema prioriza pagamentos ao fundo FER em caso de déficit e gera empréstimos automáticos para garantir a integridade contábil.
* *Solução:* Uso de transações atômicas no SQLite para garantir que atualizações de saldo, criação de empréstimos e registros de histórico ocorram simultaneamente ou falhem com rollback seguro.

### 2. Arquitetura Offline-First com Sync
O app precisa funcionar 100% offline, mas permitir backup.
* *Solução (Em Desenvolvimento):* Implementação planejada de `WorkManager` para tarefas de backup em segundo plano, garantindo que os dados sejam salvos no Google Drive do usuário sem travar a UI.

### 3. Sistema de Bloqueio e Segurança
Proteção de dados sensíveis locais.
* *Solução:* Integração de autenticação biométrica e PIN, utilizando armazenamento seguro (`FlutterSecureStorage`) para chaves e tokens.

## 📂 Estrutura do Código

A base de código reflete a separação de responsabilidades:

```
gradus/
├── lib/
│   ├── core/                # Configurações globais e utilitários
│   ├── data/                # Camada de dados (repositórios, fontes de dados)
│   ├── domain/              # Camada de domínio (casos de uso, entidades)
│   ├── infrastructure/      # Infraestrutura (serviços externos)
│   ├── presentation/        # Camada de apresentação (UI, controllers, providers)
│   └── main.dart            # Ponto de entrada da aplicação
├── test/                    # Testes unitários e widget tests
├── pubspec.yaml             # Configurações do projeto
└── README.md                # Documentação do projeto
```

## 🚀 Como rodar o projeto

### Pré-requisitos
* Flutter SDK (Versão estável mais recente)
* Dart SDK

### Instalação

1.  Clone o repositório:
    ```bash
    git clone https://github.com/IgorEduss/gradus_flutter.git
    ```
2.  Instale as dependências:
    ```bash
    flutter pub get
    ```
3.  Gere os arquivos de código (Drift, Riverpod, Injectable):
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  Execute o app:
    ```bash
    flutter run
    ```

## 📄 Licença

Este projeto está sob a licença MIT.