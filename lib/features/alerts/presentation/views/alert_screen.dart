import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/alert_view_model.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AlertViewModel>();
    final alert = viewModel.currentAlert;
    final theme = Theme.of(context);

    if (alert == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text('No hay alertas activas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: viewModel.simulateAlert,
              icon: const Icon(Icons.bug_report),
              label: const Text('Simular Alerta Crítica'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade100,
                foregroundColor: Colors.orange.shade900,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Icono de Alerta
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                )
              ],
            ),
            child: const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 24),

          // Títulos
          Text(
            alert.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          Text(
            alert.description,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),

          // Métricas
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // Usa el color de superficie del tema
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricColumn('NIVEL FATIGA', '${alert.fatigueLevel.toInt()}%', Colors.red),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                _buildMetricColumn('OJOS CERRADOS', '${alert.closedEyesTime}s', Colors.orange.shade700),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Card de Mapa / Área de Descanso
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // Usa el color de superficie del tema
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.local_parking, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          alert.locationName ?? 'Buscando área de descanso...',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text('A 450m', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // Imagen de mapa simulada
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.map, size: 50, color: Colors.grey)),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                  ),
                  child: const Center(
                    child: Text(
                      'AUTO-PILOTO ACTIVADO',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Botón de Llamada
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: viewModel.callEmergency,
              icon: const Icon(Icons.phone),
              label: const Text('LLAMAR A CENTRAL', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary, // Cian en oscuro, Azul oscuro en claro
                foregroundColor: theme.colorScheme.onPrimary, // Negro en oscuro, Blanco en claro
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Cancelar
          TextButton(
            onPressed: viewModel.dismissAlert,
            child: const Text(
              'ESTOY DESPIERTO, CANCELAR ALERTA',
              style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.underline,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
