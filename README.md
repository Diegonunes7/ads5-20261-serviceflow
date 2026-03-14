# 🚀 Projeto ServiceFlow - Gestão Inteligente de O.S.

## 📋 Visão Geral
O **ServiceFlow** é um sistema de gestão de ordens de serviço (O.S.) desenvolvido como parte da disciplina de Desenvolvimento de Software. O projeto foca em mobilidade, operação *offline-first* e arquitetura modular de alta performance.



## 🎯 Objetivo
Padronizar o desenvolvimento de um app profissional utilizando **Flutter 3.41.4** e **Dart 3.11.1**, aplicando conceitos de arquitetura limpa, generics e injeção de dependência para eliminar o retrabalho e garantir a escalabilidade do código.

## 🏗️ Arquitetura do Sistema
Utilizamos a estrutura **Base-Driven Architecture**, focada em componentes genéricos e reutilizáveis:

* **BaseModel:** Classe abstrata que obriga todas as entidades a possuírem `id`, `createdAt` e métodos de conversão (`toMap` / `toJson`).
* **BaseRepository<T>:** Abstração genérica para operações CRUD, centralizando a lógica de acesso a dados.
* **BaseViewModel<T>:** Gestão de estados (extends `ChangeNotifier`) com suporte nativo a estados de carregamento e erros.
* **DioClient:** Motor de rede centralizado com `Interceptors` para injeção automática de Token JWT.



## 📑 Requisitos Funcionais (RF)
* **RF01 - Autenticação:** Login com persistência de token seguro via `flutter_secure_storage`.
* **RF02 - Sincronização:** Operação *offline-first* com persistência local em SQLite.
* **RF03 - Evidências:** Captura de fotos e assinatura digital via dispositivos de hardware.
* **RF04 - Comunicação:** Integração direta com suporte via WhatsApp.

## 📝 User Stories & Backlog
1. **US01:** "Como técnico, quero uma interface padronizada para registro ágil de O.S."
2. **US02:** "Como técnico, preciso salvar meus relatórios mesmo sem conexão com a internet."
3. **US03:** "Como gestor, quero receber as fotos e assinaturas assim que o dispositivo recuperar a rede."

## 📊 Casos de Uso
O fluxo principal envolve a autenticação, sincronização de tarefas pendentes, execução técnica (coleta de mídia) e a finalização com envio via API RESTful.



## 🛠️ Stack Tecnológica
* **Flutter:** 3.41.4
* **Dart:** 3.11.1
* **Persistência:** `sqflite`
* **Network:** `dio`
* **Segurança:** `flutter_secure_storage`
* **Hardware:** `camera`, `signature`

## 🚀 Como Contribuir
1. **Clone este repositório:** `git clone <url-do-repositorio>`
2. **Crie sua branch:** `git checkout -b feature/nome-sobrenome`
3. **Instale as dependências:** `flutter pub get`
4. **Respeite a estrutura:** Siga os padrões `BaseModel` e `BaseRepository` definidos no diretório `/core`.

---
> **Nota do Professor:** Todo desenvolvimento deve ocorrer em branch individual. Não realize `push` diretamente na branch `main`.

## 📐 Documentação Técnica

### 1. Diagrama de Componentes
O sistema é dividido em `Core` (Infraestrutura) e `Modules` (Funcionalidades).

### Fluxo de Dados (Caminho da Informação)
Toda requisição segue o ciclo:
```text
View -> ViewModel -> Repository -> DioClient/SQLite
```

## 📊 Dicionário de Dados (Base de Dados)
| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| **id** | INTEGER | Chave Primária |
| **cliente** | TEXT | Nome do cliente |
| **status** | TEXT | Pendente/Iniciado/Concluído |
| **foto_path** | TEXT | Caminho local da imagem |
| **assinatura** | TEXT | Base64 da assinatura |
| **created_at** | TEXT | Timestamp ISO8601 |


### 2. Estrutura de Pastas (Padrão Obrigatório)
```text
lib/
├── core/             # Framework base (BaseModel, BaseRepository, DioClient)
├── data/             # Camada de Dados (Repositories, Models, LocalDB)
├── modules/          # Funcionalidades (Feature-first)
│   ├── auth/         # Login, AuthViewModel
│   ├── home/         # Dashboard, Lista de O.S.
│   └── execution/    # Câmera, Assinatura e Sync
└── main.dart         # Entrypoint e Rotas
```
### 4. Padrões de Implementação (O "Jeito ServiceFlow")

Para manter o projeto íntegro, siga estritamente estas diretrizes:

* **Regra da Herança:**
    - Toda nova entidade DEVE herdar de `BaseModel`.
    - Todo novo serviço DEVE herdar de `BaseRepository<T>`.
    - Toda nova lógica de tela DEVE estar encapsulada em um `BaseViewModel<T>`.

* **Tratamento de Erros:**
    - Nunca use `print()` para debugar erros na UI.
    - Utilize o `UiFeedbackMixin` (detalhado abaixo) para disparar notificações visuais (`SnackBars`) de forma padronizada.

* **Sincronização Offline:**
    - A lógica de persistência no `sqflite` deve ser isolada no seu respectivo `Repository`, nunca dentro da `View`.

---

## 🛠️ O Framework de Feedback (UiFeedbackMixin)

O sistema de mensagens é padronizado através de um *Mixin*. Ele deve ser utilizado em qualquer `ViewModel` para informar o usuário sobre o sucesso ou falha de uma operação.

# Diagramas de classes
Este diagrama mostra a relação do BaseModel com as classes concretas.
```mermaid
classDiagram
    class BaseModel {
        <<abstract>>
        +int? id
        +DateTime? createdAt
        +toMap()
        +toJson()
    }
    class OrdemServico {
        +String cliente
        +String status
        +toMap()
        +toJson()
    }
    class BaseRepository {
        <<abstract>>
        +Dio dio
        +getAll()
        +delete(int id)
    }
 ```   
    BaseModel <|-- OrdemServico
    BaseRepository ..> BaseModel : usa <T>

# Diagramas de componentes
```mermaid
graph TD
    subgraph Core
        DioClient[DioClient]
        BaseRepository[BaseRepository]
        BaseModel[BaseModel]
    end
    
    subgraph Modules
        Auth[Auth Module]
        Home[Home Module]
        Execution[Execution Module]
    end
 
    Modules --> Core
    Auth --> DioClient
    Home --> BaseRepository
    Execution --> BaseModel
```
