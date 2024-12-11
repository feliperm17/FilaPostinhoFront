import 'package:flutter/material.dart';
import 'package:fila_postinho_front/shared/widgets/custom_button.dart';
import 'package:fila_postinho_front/shared/widgets/custom_text_field.dart';
import 'package:fila_postinho_front/shared/utils/validators.dart';
import 'package:fila_postinho_front/features/auth/services/auth_service.dart';
import 'package:fila_postinho_front/shared/widgets/background_gradient.dart';

class ResetPasswordScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const ResetPasswordScreen({
    required this.toggleTheme,
    super.key,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _isLoading = ValueNotifier<bool>(false);
  final _authService = AuthService();

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading.value = true;
      });

      try {
        final response =
            await _authService.resetPassword(_emailController.text);

        if (mounted) {
          if (response['success'] == true) {
            _showSuccessAndPop();
          } else {
            _showError(response['message']);
          }
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading.value = false;
          });
        }
      }
    }
  }

  void _showSuccessAndPop() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('E-mail de recuperação enviado com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.of(context).pop();
  }

  void _showError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Erro ao enviar e-mail de recuperação'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BackgroundGradient(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Digite seu e-mail para recuperar sua senha',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'E-mail',
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<bool>(
                  valueListenable: _isLoading,
                  builder: (context, isLoading, _) {
                    return CustomButton(
                      text: 'Enviar',
                      onPressed: _resetPassword,
                      isLoading: isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
