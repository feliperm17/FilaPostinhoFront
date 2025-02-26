# FilaPostinhoFront

## Descrição

O **FilaPostinhoFront** é um projeto frontend desenvolvido em Flutter, que se conecta ao backend do FilaPostinho para gerenciar filas de atendimento em ambientes de saúde. Este aplicativo permite que os usuários se registrem, façam login, e se inscrevam em filas, além de visualizar seu status e receber notificações.

## 🔧 Pré-requisitos

Antes de executar o projeto, certifique-se de que você possui os seguintes pré-requisitos instalados em sua máquina:

- **Flutter** (versão 2.0 ou superior)
- **Dart** (versão 2.12 ou superior)
- **Android Studio** ou **Visual Studio Code** (para desenvolvimento)
- **Emulador Android** ou **dispositivo físico** para testes

## 🚀 Funcionalidades

- **Registro de Usuário**: Permite que novos usuários se registrem no sistema.
- **Login de Usuário**: Autenticação de usuários existentes.
- **Gerenciamento de Filas**: Inscrição em filas, visualização de status e posição na fila.
- **Notificações**: Recebimento de notificações sobre o status da fila.

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento de aplicativos móveis.
- **Dart**: Linguagem de programação utilizada pelo Flutter.
- **HTTP**: Biblioteca para realizar requisições HTTP ao backend.
- **Provider**: Gerenciamento de estado para o aplicativo.

## 🏃 Instalação

Para instalar e executar o projeto, siga os passos abaixo:

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/feliperm17/FilaPostinhoFront
   cd FilaPostinhoFront
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Inicie o emulador** ou conecte um dispositivo físico.

4. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

## Estrutura do Projeto

- **lib/core**: Configurações da API e constantes.
- **lib/models**: Modelos de dados utilizados no aplicativo.
- **lib/services**: Serviços para comunicação com a API.
- **lib/utils**: Utilitários e funções auxiliares.
- **lib/main.dart**: Ponto de entrada do aplicativo.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou enviar um pull request.

## Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

```