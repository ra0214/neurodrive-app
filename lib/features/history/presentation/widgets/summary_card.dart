import 'package:flutter/material.dart';
import '../../domain/entities/drive_record.dart';

class SummaryCard extends StatelessWidget {
  final WeeklySummary summary;

  const SummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RESUMEN SEMANAL',
                style: TextStyle(fontSize: 10, color: Colors.white54, letterSpacing: 1.2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, color: Colors.cyan, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '+${summary.growthPercentage}%',
                      style: const TextStyle(color: Colors.cyan, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Puntaje de\nSeguridad: ${summary.safetyScore}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          _buildWeeklyChart(),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DayLabel('LUN'),
              _DayLabel('MAR'),
              _DayLabel('MIÉ', isSelected: true),
              _DayLabel('JUE'),
              _DayLabel('VIE'),
              _DayLabel('SÁB'),
              _DayLabel('DOM'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: summary.weeklyData.map((value) {
          return Container(
            width: 30,
            height: value * 40,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _DayLabel(this.label, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isSelected)
          Container(
            height: 2,
            width: 20,
            margin: const EdgeInsets.only(bottom: 4),
            color: Colors.redAccent.withValues(alpha: 0.6),
          ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.white : Colors.white24,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
