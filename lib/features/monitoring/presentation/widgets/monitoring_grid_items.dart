import 'package:flutter/material.dart';
import '../../domain/entities/monitoring_status.dart';

class MonitoringGridItems extends StatelessWidget {
  final MonitoringStatus status;

  const MonitoringGridItems({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSimpleCard(
          icon: Icons.favorite,
          label: 'FRECUENCIA CARDÍACA',
          value: '${status.heartRate}',
          unit: 'bpm',
          trailing: _buildMiniGraph(),
        ),
        const SizedBox(height: 12),
        _buildSimpleCard(
          icon: Icons.remove_red_eye,
          label: 'FRECUENCIA DE PARPADEO',
          value: status.blinkFrequency,
          unit: '',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.cyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'STABLE',
              style: TextStyle(color: Colors.cyan, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildSimpleCard(
          icon: Icons.thermostat,
          label: 'TEMPERATURA CABINA',
          value: '${status.cabinTemperature}°C',
          unit: '',
          trailing: const Icon(Icons.arrow_forward, color: Colors.white24, size: 16),
        ),
      ],
    );
  }

  Widget _buildSimpleCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.redAccent.withValues(alpha: 0.7), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (unit.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: const TextStyle(fontSize: 12, color: Colors.white54),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildMiniGraph() {
    return Row(
      children: List.generate(5, (index) {
        final height = (index + 1) * 5.0 + (index % 2 == 0 ? 10 : 0);
        return Container(
          width: 8,
          height: height,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: index == 3 ? Colors.redAccent.withValues(alpha: 0.4) : Colors.white12,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
