# Mamba Fast Tracker

Um aplicativo de controle de jejum intermitente e registro de calorias diárias, construído com foco em **qualidade de produção, arquitetura escalável e funcionamento offline-first**. Este projeto foi desenvolvido como resolução do Desafio Técnico para Desenvolvedor Mobile da Mamba Growth.

O foco principal desta entrega é a robustez da funcionalidade central (Timer rodando de forma confiável em background) e a persistência correta do estado e dos dados do usuário.

## Como rodar o projeto

**Pré-requisitos:**
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado na máquina.
- Um emulador Android/iOS ou um dispositivo físico conectado (também compatível com testes via navegador Web).

**Passo a passo:**
1. Clone este repositório:
   ```bash
   git clone [https://github.com/yvesesteves/mamba-fast-tracker.git](https://github.com/yvesesteves/mamba-fast-tracker.git)
   ```

2. Acesse a pasta do projeto:
   ```bash
   cd mamba-fast-tracker
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```

4. Execute o aplicativo:
   ```bash
   flutter run
   ```

---

## Stack Escolhida
- Linguagem: **Dart**

- Framework: **Flutter**

- Gerência de Estado: **flutter_bloc (Cubit)**

- Banco de Dados Local: **hive (NoSQL)**
---
## Arquitetura Utilizada

Foi adotada a Clean Architecture guiada por Features (modularização por funcionalidades). Essa abordagem garante que o projeto seja escalável e de fácil manutenção.

- **Core:** Serviços globais, temas e utilitários (ex: 'storage_service.dart', 'notification_service.dart').

- **Features:** Divisão lógica das áreas do app (auth, dashboard, fasting, meals).

- A lógica de negócios foi isolada da interface visual utilizando o padrão Cubit (uma variação mais enxuta do BLoC), garantindo reatividade previsível e separação de responsabilidades.
--- 
## Decisões Técnicas
- **Timer Baseado em Datas** (Core Feature): Em vez de utilizar cronômetros ativos na memória (que são mortos pelo sistema operacional quando o app vai para o background), o timer salva o 'DateTime' de início no banco de dados local. A interface apenas calcula a diferença entre o momento atual e a data salva. Isso garante que nenhum estado seja perdido ao fechar e reabrir o app, mantendo a precisão perfeita.
  
- **Offline-first Nativo:** Todas as ações (autenticação, registro de refeições, metas) funcionam 100% sem internet, utilizando o 'Hive' para persistência instantânea no dispositivo.

- **Dark Mode Padrão:** Para entregar um design moderno, polido e amigável à bateria, o aplicativo foi projetado de forma nativa em modo escuro.

---
## Bibliotecas Utilizadas

- **flutter_bloc:** Padrão da indústria para gerenciamento de estados complexos.

- **hive e hive_flutter:** Banco de dados NoSQL extremamente leve e rápido, ideal para offline-first.

- **fl_chart:** Renderização fluida do gráfico de barras para o histórico semanal.

- **flutter_local_notifications:** Disparo nativo de notificações sem dependência de serviços externos (Firebase).

- **intl:** Formatação padronizada de datas e horários.

--- 
## Trade-offs Considerados
 Diante do prazo estipulado de 3 a 4 dias corridos para entrega do MVP, algumas concessões conscientes foram feitas para garantir a estabilidade das core features:

**1. Mock de Usuário e Meta Diária:** Em vez de construir um CRUD complexo de perfis para o usuário definir suas calorias diárias, a meta de calorias foi fixada (2000 kcal) e o login valida qualquer e-mail/senha localmente. Isso permitiu focar todo o tempo de desenvolvimento na estabilidade do cronômetro de jejum.

**2. Dados Simulados no Histórico (Dias Anteriores):** Criar uma rotina de cronjob em background para virar os dias à meia-noite exigiria bibliotecas nativas de WorkManager. Optou-se por utilizar dados "mockados" na aba de Histórico apenas para validar a capacidade de construção de UI e fluxos de navegação.

---

## O que melhoraria com mais tempo
Se houvesse mais tempo para evolução deste produto, os próximos passos seriam:

- **Personalização de Metas (Perfil):** Criação de uma tela de perfil onde o usuário possa inserir seus dados (altura, peso e objetivos). O app calcularia a meta diária de calorias ideal ou permitiria a definição manual, substituindo o valor fixado no MVP.

- **Testes Unitários:** Cobertura de testes na camada dos Cubits (especialmente na lógica de cálculo de tempo de jejum).

- **Firebase Auth e Firestore:** Migrar o banco offline-first local para sincronização em nuvem, mantendo o funcionamento híbrido.

- **Crashlytics & Analytics:** Integração de monitoramento para rastrear falhas silenciosas no dispositivo dos usuários e observar métricas de uso dos protocolos.

- **Feature Flags:** Implementação de controle remoto para ocultar/exibir abas (como a de Gráficos) dinamicamente.

- **Theme Toggle:** Adição de uma configuração na interface para o usuário alternar livremente entre Light e Dark mode.
--- 

## Tempo gasto no desafio

Aproximadamente 8 horas distribuídas ao longo do prazo estabelecido.

--- 

## *Developed by Yves Esteves* 