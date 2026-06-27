import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              ? [const Color(0xFF0D1B2A), theme.colorScheme.background]
              : [theme.colorScheme.primary.withValues(alpha: 0.05), theme.colorScheme.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Icon(Icons.sensors, color: theme.colorScheme.primary, size: 40),
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
                const SizedBox(height: 40),
                // Registration Card
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Crea tu cuenta',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Únete a la red de conductores seguros',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildTextField(
                        context,
                        label: 'NOMBRE COMPLETO',
                        hint: 'Ej. Carlos Mendoza',
                        icon: Icons.person_outline,
                        controller: _fullNameController,
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        context,
                        label: 'CORREO ELECTRÓNICO',
                        hint: 'carlos@ejemplo.com',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        context,
                        label: 'CONTRASEÑA',
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onSuffixIconPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                                  await viewModel.register(
                                    fullName: _fullNameController.text,
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
                                    Text('Registrarse'),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: 18),
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
                      '¿Ya tienes una cuenta? ',
                      style: TextStyle(color: theme.colorScheme.onBackground.withValues(alpha: 0.6)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Iniciar Sesión',
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

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixIconPressed,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
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
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 18,
                    ),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
