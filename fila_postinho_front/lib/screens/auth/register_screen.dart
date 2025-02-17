import 'package:fila_postinho_front/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fila_postinho_front/core/theme/colors.dart';
import 'package:fila_postinho_front/widgets/custom_button.dart';
import 'package:fila_postinho_front/widgets/custom_text_field.dart';
import '../../utils/validators.dart';
import 'package:fila_postinho_front/services/auth_service.dart';
import 'package:fila_postinho_front/screens/auth/login_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:fila_postinho_front/services/cep_service.dart';
import 'package:fila_postinho_front/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/widgets/background_gradient.dart';
import 'package:fila_postinho_front/core/constants/responsive_breakpoints.dart';
import 'package:fila_postinho_front/widgets/responsive_container.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const RegisterScreen({
    required this.toggleTheme,
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cpfController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _countryController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();

  // Formatadores de máscara
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Outros formatadores que podem ser úteis:
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _dateMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ThemeToggleButton(
              onPressed: widget.toggleTheme,
              isDark: isDark,
            ),
          ),
        ],
      ),
      body: BackgroundGradient(
        child: ResponsiveContainer(
          maxWidth: ResponsiveBreakpoints.maxFormWidth,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Cadastro',
                    style: TextStyle(
                      fontSize: ResponsiveBreakpoints.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Dados pessoais
                  _buildSectionTitle('Dados Pessoais'),
                  const SizedBox(height: 16),
                  _buildTextField('Nome', _nameController, Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField('CPF', _cpfController, Icons.badge,
                      mask: [_cpfMask]),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Telefone',
                    _phoneController,
                    Icons.phone,
                    mask: [_phoneMask],
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Data de Nascimento',
                    _birthDateController,
                    Icons.calendar_today,
                    mask: [_dateMask],
                    keyboardType: TextInputType.datetime,
                    validator: Validators.validateBirthDate,
                  ),
                  // Continue o padrão para os outros campos
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        label: 'Campo de email para login',
                        child: _buildTextField(
                          'E-mail',
                          _emailController,
                          Icons.email,
                          validator: Validators.validateEmail,
                          onChanged: (value) {
                            setState(() {}); // Para atualizar o indicador
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        'Senha',
                        _passwordController,
                        Icons.lock,
                        obscureText: true,
                        validator: Validators.validatePassword,
                        onChanged: (value) {
                          setState(() {}); // Para atualizar o indicador
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildPasswordStrengthIndicator(_passwordController.text),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Confirmar Senha',
                        _confirmPasswordController,
                        Icons.lock,
                        obscureText: true,
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                        onChanged: (value) {
                          setState(() {}); // Para atualizar o indicador
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildPasswordStrengthIndicator(
                          _confirmPasswordController.text),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Endereço'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'CEP',
                    _cepController,
                    Icons.location_on,
                    mask: [_cepMask],
                    keyboardType: TextInputType.number,
                    validator: Validators.validateCEP,
                    onChanged: (value) {
                      if (value.length == 9) _searchCep();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Rua', _streetController, Icons.location_on),
                  const SizedBox(height: 16),
                  _buildTextField('Número', _numberController, Icons.numbers),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'Complemento', _complementController, Icons.house),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'Bairro', _neighborhoodController, Icons.location_city),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'Cidade', _cityController, Icons.location_city),
                  const SizedBox(height: 16),
                  _buildTextField('Estado', _stateController, Icons.map),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Cadastrar',
                    onPressed: _register,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Já tem uma conta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                toggleTheme: widget.toggleTheme,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Faça login',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = User(
          name: _nameController.text,
          cpf: _cpfController.text,
          email: _emailController.text,
          password: _passwordController.text,
          number: _phoneController.text,
        );

        final response = await _authService.register(user);
        
        if (response['success'] == true) {
          _showSnackBar('Cadastro Realizado!', response['message'], true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(toggleTheme: widget.toggleTheme),
            ),
          );
        } else {
          _showSnackBar('Erro no Cadastro', response['message'], false);
        }
      } catch (e) {
        _showSnackBar('Erro no Sistema', 
          'Ocorreu um erro ao tentar realizar o cadastro. Tente novamente mais tarde.',
          false
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _searchCep() async {
    final cep = _cepController.text;
    if (cep.length < 8) return;

    setState(() => _isLoading = true);
    try {
      final address = await CepService.fetchAddress(cep);
      if (address != null) {
        _streetController.text = address['street'] ?? '';
        _neighborhoodController.text = address['neighborhood'] ?? '';
        _cityController.text = address['city'] ?? '';
        _stateController.text = address['state'] ?? '';
        _countryController.text = address['country'] ?? '';
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String title, String message, bool isSuccess) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(message),
          ],
        ),
        backgroundColor: isSuccess ? AppColors.primary : AppColors.error,
        duration: const Duration(seconds: 15),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'Fechar',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cepController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _countryController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: ResponsiveBreakpoints.fontSizeLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    List<TextInputFormatter>? mask,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return CustomTextField(
      label: label,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      prefixIcon: icon,
      inputFormatters: mask,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  Widget _buildPasswordStrengthIndicator(String password) {
    final strength = _calculatePasswordStrength(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: strength / 4,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation(
            strength < 2
                ? Colors.red
                : strength < 3
                    ? Colors.orange
                    : Colors.green,
          ),
        ),
        Text(
          strength < 2
              ? 'Senha fraca'
              : strength < 3
                  ? 'Senha média'
                  : 'Senha forte',
          style: TextStyle(
            color: strength < 2
                ? Colors.red
                : strength < 3
                    ? Colors.orange
                    : Colors.green,
          ),
        ),
      ],
    );
  }
}
