class InputSanitizer {
  static String sanitizeInput(String input) {
    // Remove caracteres especiais perigosos
    return input.replaceAll(RegExp(r'[<>()\"\/\\]'), '');
  }

  static String sanitizeEmail(String email) {
    // Mantém apenas caracteres válidos para email
    return email.toLowerCase().trim().replaceAll(RegExp(r'[^a-z0-9@._-]'), '');
  }

  static String sanitizePhone(String phone) {
    // Mantém apenas números
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  static String sanitizeCPF(String cpf) {
    // Mantém apenas números
    return cpf.replaceAll(RegExp(r'[^\d]'), '');
  }
}
