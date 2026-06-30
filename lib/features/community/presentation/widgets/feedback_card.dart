import 'package:flutter/material.dart';
import '../../data/models/feedback_model.dart';
import 'package:intl/intl.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;

  const FeedbackCard({super.key, required this.feedback});

  /// Helper: Formatea la fecha al estilo social solicitado
  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    final timeFormat = DateFormat('hh:mm a'); // Ejemplo: 03:30 PM

    if (dateToCheck == today) {
      return 'Hoy a las ${timeFormat.format(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Ayer a las ${timeFormat.format(date)}';
    } else {
      // Formato: 29 de Jun, 2026
      final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      return '${date.day} de ${months[date.month - 1]}, ${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101B33) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.nombreRuta,
                        style: const TextStyle(
                          fontSize: 19, 
                          fontWeight: FontWeight.w900, 
                          color: Color(0xFF00F1FE), // Cyan distintivo
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // TEXTO DE LA FECHA (GRIS Y PEQUEÑO)
                      Text(
                        _getFormattedDate(feedback.fecha),
                        style: const TextStyle(
                          color: Colors.grey, 
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDangerIndicator(feedback.nivelPeligro),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              feedback.comentario,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.9), 
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_outline, size: 14, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  feedback.autor,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6), 
                    fontSize: 12, 
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerIndicator(int level) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          Icons.local_fire_department_rounded,
          color: index < level ? Colors.orangeAccent : Colors.grey.withValues(alpha: 0.2),
          size: 20,
        );
      }),
    );
  }
}
