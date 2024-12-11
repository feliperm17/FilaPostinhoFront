class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    // Verifica se tem nome e sobrenome
    final names = value.trim().split(' ');
    if (names.length < 2) {
      return 'Por favor, insira seu nome completo';
    }
    // Verifica se cada parte tem pelo menos 2 caracteres
    if (names.any((name) => name.length < 2)) {
      return 'Cada nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Digite um e-mail válido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'A senha deve conter pelo menos um número';
    }

    if (!value.contains(RegExp(r'[!@#\$%\^&\*\(\),.?":{}|<>]'))) {
      return 'A senha deve conter pelo menos um caractere especial';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }
    if (value != password) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu CPF';
    }

    // Remove caracteres não numéricos
    String cpf = value.replaceAll(RegExp(r'[^\d]'), '');

    // Verifica se tem 11 dígitos
    if (cpf.length != 11) {
      return 'CPF inválido';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Calcula os dígitos verificadores
    List<int> numbers = cpf.split('').map(int.parse).toList();

    // Primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += numbers[i] * (10 - i);
    }
    int digito1 = 11 - (soma % 11);
    if (digito1 > 9) digito1 = 0;

    if (numbers[9] != digito1) {
      return 'CPF inválido';
    }

    // Segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += numbers[i] * (11 - i);
    }
    int digito2 = 11 - (soma % 11);
    if (digito2 > 9) digito2 = 0;

    if (numbers[10] != digito2) {
      return 'CPF inválido';
    }

    return null;
  }

  static String? validateCEP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu CEP';
    }
    String cep = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cep.length != 8) {
      return 'CEP inválido';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu telefone';
    }
    String phone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (phone.length < 10 || phone.length > 11) {
      return 'Telefone inválido';
    }
    return null;
  }

  static String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data de nascimento é obrigatória';
    }

    // Remove caracteres não numéricos
    final cleanDate = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanDate.length != 8) {
      return 'Data inválida';
    }

    try {
      final day = int.parse(cleanDate.substring(0, 2));
      final month = int.parse(cleanDate.substring(2, 4));
      final year = int.parse(cleanDate.substring(4));

      final date = DateTime(year, month, day);
      final now = DateTime.now();

      // Verifica se é uma data futura
      if (date.isAfter(now)) {
        return 'Data não pode ser futura';
      }

      // Verifica idade mínima (por exemplo, 18 anos)
      final minAge = now.subtract(const Duration(days: 365 * 18));
      if (date.isAfter(minAge)) {
        return 'Idade mínima é 18 anos';
      }

      return null;
    } catch (e) {
      return 'Data inválida';
    }
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    if (value.length < 3) {
      return 'Mínimo de 3 caracteres';
    }
    return null;
  }

  static String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu estado';
    }
    if (value.length != 2) {
      return 'Use a sigla do estado (ex: SP)';
    }
    return null;
  }
}