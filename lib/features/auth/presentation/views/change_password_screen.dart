import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seguridad"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.security_update_good_rounded, size: 48, color: Colors.cyan),
            const SizedBox(height: 16),
            const Text(
              "Actualiza tu PIN",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Por tu seguridad, debes cambiar el PIN temporal asignado por la empresa por uno nuevo y privado.",
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _pinController,
              obscureText: _obscure,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nuevo PIN definitivo",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPinController,
              obscureText: _obscure,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Confirmar PIN",
                prefixIcon: Icon(Icons.check_circle_outline),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí iría la lógica de actualización en el backend
                  Navigator.pushReplacementNamed(context, '/home');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("PIN actualizado correctamente")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("GUARDAR Y CONTINUAR", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
