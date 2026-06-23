import 'package:flutter/material.dart';
import '../../domain/entities/drive_record.dart';
import 'package:intl/intl.dart';

class RecordTile extends StatelessWidget {
  final DriveRecord record;

  const RecordTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;
    IconData? icon;

    switch (record.status) {
      case RecordStatus.critico:
        statusText = 'CRÍTICO';
        statusColor = Colors.redAccent;
        icon = Icons.warning_amber_rounded;
        break;
      case RecordStatus.optimo:
        statusText = 'ÓPTIMO';
        statusColor = Colors.cyan;
        break;
      case RecordStatus.estable:
        statusText = 'ESTABLE';
        statusColor = Colors.white54;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (record.status == RecordStatus.critico)
            Container(
              width: 2,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              color: Colors.redAccent.withValues(alpha: 0.5),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMM, HH:mm').format(record.date).toUpperCase(),
                  style: const TextStyle(fontSize: 10, color: Colors.white24),
                ),
                const SizedBox(height: 4),
                Text(
                  record.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: statusColor.withValues(alpha: 0.7), size: 14),
                const SizedBox(width: 4),
              ],
              Text(
                statusText,
                style: TextStyle(color: statusColor.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white24),
            ],
          ),
        ],
      ),
    );
  }
}
