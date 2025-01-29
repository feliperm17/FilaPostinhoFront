import 'package:fila_postinho_front/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fila_postinho_front/core/theme/colors.dart';
import 'package:fila_postinho_front/widgets/custom_button.dart';
import 'package:fila_postinho_front/widgets/custom_text_field.dart';
import '../../utils/current_user.dart';
import 'package:fila_postinho_front/screens/auth/register_screen.dart';
import 'package:fila_postinho_front/services/auth_service.dart';
import 'package:fila_postinho_front/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/widgets/background_gradient.dart';
import 'package:fila_postinho_front/services/auth_storage_service.dart';
import '../../utils/jwt_token.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const LoginScreen({
    required this.toggleTheme,
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _isLoading = ValueNotifier<bool>(false);
  final _authService = AuthService();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await AuthStorageService.getCredentials();
    if (credentials['email'] != null && credentials['password'] != null) {
      setState(() {
        _emailController.text = credentials['email']!;
        _passwordController.text = credentials['password']!;
        _rememberMe = true;
      });
    }
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 32.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: isSmallScreen ? double.infinity : 400,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: isSmallScreen
                          ? 0
                          : (MediaQuery.of(context).size.width - 400) / 2,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!isSmallScreen) const SizedBox(height: 32),
                        const SizedBox(height: 24),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isSmallScreen ? 32 : 48),
                        Semantics(
                          label: 'Campo de email para login',
                          child: CustomTextField(
                            label: 'E-mail',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Senha',
                          controller: _passwordController,
                          obscureText: true,
                          prefixIcon: Icons.lock,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: AppColors.primary,
                            ),
                            const Text('Lembrar-me'),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Entrar',
                          onPressed: _login,
                          isLoading: _isLoading.value,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Não tem uma conta?'),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(
                                      toggleTheme: widget.toggleTheme,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Cadastre-se',
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
            );
          },
        ),
      ),
    );
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading.value = true;
      });

      try {
        if (_rememberMe) {
          await AuthStorageService.saveCredentials(
            _emailController.text,
            _passwordController.text,
          );
        } else {
          await AuthStorageService.clearCredentials();
        }

        final response = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (mounted) {
          if (response['success'] == true) {
            _showSnackBar(
              'Login Realizado!',
              'Você foi autenticado com sucesso.',
              true,
            );
            currentUser = User.fromJson(response['user']);
            setState(() {
              _isLoading.value = false;
            });
            if (currentUser!.isAdmin == false) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (_) => true);
            } else {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/admin/home', (_) => true);
            }
          } else {
            String errorMessage = 'Erro ao realizar login';
            if (response['message'] != null) {
              switch (response['message']) {
                case 'invalid_credentials':
                  errorMessage = 'E-mail ou senha incorretos';
                  break;
                case 'user_not_found':
                  errorMessage = 'Usuário não encontrado';
                  break;
                case 'account_disabled':
                  errorMessage =
                      'Conta desativada. Entre em contato com o suporte';
                  break;
                default:
                  errorMessage = response['message'];
              }
            }
            _showSnackBar('Erro no Login', errorMessage, false);
          }
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar(
            'Erro no Sistema',
            'Ocorreu um erro ao tentar realizar o login. Tente novamente mais tarde.',
            false,
          );
        }
      } finally {
        _isLoading.value = false;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isLoading.dispose();
    super.dispose();
  }
}
