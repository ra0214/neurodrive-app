import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/login_view_model.dart';
import '../../../core/security/security_service.dart';

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
                const Text('Bloqueo de Seguridad'),
              ],
            ),
            content: Text(errorMessage, style: const TextStyle(fontSize: 14)),
            actions: [
              ElevatedButton(
                onPressed: () => exit(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('CERRAR APLICACIÓN'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                // Logo Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Icon(Icons.sensors, color: theme.colorScheme.primary, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'NeuroDrive',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'THE SILENT GUARDIAN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onBackground.withValues(alpha: 0.7),
                    letterSpacing: 3.0,
                  ),
                ),
                const SizedBox(height: 60),
                // Login Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                    boxShadow: isDark ? [] : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ingresa tus credenciales para continuar con el monitoreo.',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildTextFieldLabel(context, 'CORREO ELECTRÓNICO'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: const InputDecoration(
                          hintText: 'usuario@neurodrive.ai',
                          prefixIcon: Icon(Icons.email_outlined, size: 18),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTextFieldLabel(context, 'CONTRASEÑA'),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Olvidé mi contraseña',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, size: 18),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              size: 18,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                                  await viewModel.login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  if (mounted) {
                                    if (viewModel.error == null) {
                                      Navigator.pushReplacementNamed(context, '/home');
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(viewModel.error!),
                                          backgroundColor: theme.colorScheme.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: viewModel.isLoading
                              ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Iniciar Sesión'),
                                    SizedBox(width: 8),
                                    Icon(Icons.login, size: 20),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(color: theme.colorScheme.onBackground.withValues(alpha: 0.6)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Registrarse',
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldLabel(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          label.contains('CORREO') ? Icons.email_outlined : Icons.lock_outline,
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}
