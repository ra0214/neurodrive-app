import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neurodrive/features/auth/presentation/view_models/register_view_model.dart';
import 'package:neurodrive/core/security/security_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreEmpresaController = TextEditingController();
  final _rfcController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();
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
                ? [const Color(0xFF08132A), const Color(0xFF0D1B2A)]
                : [theme.colorScheme.primary.withValues(alpha: 0.05), theme.colorScheme.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Icon(Icons.sensors, color: theme.colorScheme.primary, size: 48),
                const SizedBox(height: 16),
                Text('NeuroDrive', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                const SizedBox(height: 40),
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
                      Text('Crea tu cuenta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 32),
                      _buildLabel('NOMBRE EMPRESA / PERSONAL', Icons.business_outlined),
                      TextField(controller: _nombreEmpresaController, decoration: const InputDecoration(hintText: 'Ej. Mi Empresa')),
                      const SizedBox(height: 20),
                      _buildLabel('RFC', Icons.badge_outlined),
                      TextField(controller: _rfcController, decoration: const InputDecoration(hintText: 'RFC123456789')),
                      const SizedBox(height: 20),
                      _buildLabel('CORREO ELECTRÓNICO', Icons.email_outlined),
                      TextField(controller: _emailController, decoration: const InputDecoration(hintText: 'correo@ejemplo.com')),
                      const SizedBox(height: 20),
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
                            await viewModel.register(
                              nombreEmpresa: _nombreEmpresaController.text,
                              rfc: _rfcController.text,
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                            if (mounted && viewModel.error == null) {
                              Navigator.pushReplacementNamed(context, '/login');
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro exitoso. Inicia sesión.'), backgroundColor: Colors.green));
                            } else if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(viewModel.error!), backgroundColor: theme.colorScheme.error));
                            }
                          },
                          child: viewModel.isLoading ? const CircularProgressIndicator() : const Text('Registrarse'),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: Text('¿Ya tienes cuenta? Inicia Sesión', style: TextStyle(color: theme.colorScheme.primary))),
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