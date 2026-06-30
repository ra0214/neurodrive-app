import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _licenciaController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _licenciaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_licenciaController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingresa tu licencia y PIN")),
      );
      return;
    }

    final viewModel = context.read<LoginViewModel>();
    final response = await viewModel.login(
      numeroLicencia: _licenciaController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (response != null) {
      if (response.requiereCambioPassword) {
        Navigator.pushReplacementNamed(context, '/change-password');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else if (viewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.error!),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = context.watch<LoginViewModel>().isLoading;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Identidad Visual
                Icon(Icons.directions_car_filled_rounded, size: 80, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  "NeuroDrive",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Text(
                  "PORTAL EXCLUSIVO PARA CHOFERES",
                  style: TextStyle(fontSize: 10, letterSpacing: 2, color: Colors.white54),
                ),
                const SizedBox(height: 48),

                // Card de Login
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bienvenido de nuevo",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Usa tus credenciales asignadas por la empresa.",
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                      const SizedBox(height: 32),

                      // Campo Licencia
                      _buildLabel("NÚMERO DE LICENCIA"),
                      TextField(
                        controller: _licenciaController,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Ej: ABC123456",
                          prefixIcon: const Icon(Icons.badge_outlined),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo PIN
                      _buildLabel("PIN DE ACCESO"),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "••••••••",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botón de Acción
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                )
                              : const Text(
                                  "INICIAR SESIÓN",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "¿No tienes acceso?\nContacta al administrador de tu empresa.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.cyan),
      ),
    );
  }
}
