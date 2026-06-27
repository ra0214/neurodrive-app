import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para SystemNavigator.pop
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:provider/provider.dart';
import 'package:neurodrive/features/auth/presentation/view_models/login_view_model.dart';
import 'package:neurodrive/core/security/security_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkSecurity() async {
    final String? errorMessage = await SecurityService.checkDeviceSecurity();
    if (errorMessage != null && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Row(
              children: [
                Icon(Icons.security, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 10),
                const Text('Seguridad'),
              ],
            ),
            content: Text(errorMessage),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (kIsWeb) {
                    Navigator.of(context).pop();
                  } else {
                    SystemNavigator.pop(); // Cierre seguro en Android/iOS
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('CERRAR'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D1B2A), theme.colorScheme.background]
                : [theme.colorScheme.primary.withValues(alpha: 0.05), theme.colorScheme.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Icon(Icons.sensors, color: theme.colorScheme.primary, size: 48),
                const SizedBox(height: 16),
                Text('NeuroDrive', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                Text('THE SILENT GUARDIAN', style: TextStyle(fontSize: 10, letterSpacing: 3, color: theme.colorScheme.onBackground.withValues(alpha: 0.6))),
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bienvenido', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 32),
                      _buildLabel('CORREO ELECTRÓNICO', Icons.email_outlined),
                      TextField(controller: _emailController, decoration: const InputDecoration(hintText: 'usuario@neurodrive.ai')),
                      const SizedBox(height: 24),
                      _buildLabel('CONTRASEÑA', Icons.lock_outline),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading ? null : () async {
                            await viewModel.login(email: _emailController.text, password: _passwordController.text);
                            if (mounted && viewModel.error == null) Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: viewModel.isLoading ? const CircularProgressIndicator() : const Text('Iniciar Sesión'),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text('¿No tienes cuenta? Regístrate', style: TextStyle(color: theme.colorScheme.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(children: [
      Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
      const SizedBox(width: 8),
      Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
    ]);
  }
}