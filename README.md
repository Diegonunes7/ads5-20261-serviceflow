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
