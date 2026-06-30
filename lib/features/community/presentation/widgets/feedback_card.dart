import 'package:flutter/material.dart';
import '../../data/models/feedback_model.dart';
import 'package:intl/intl.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;

  const FeedbackCard({super.key, required this.feedback});

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
          color: theme.colorScheme.primary.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      feedback.nombreRuta,
                      style: TextStyle(
                        fontSize: 19, 
                        fontWeight: FontWeight.w900, 
                        color: const Color(0xFF00F1FE), // Cyan NeuroDrive
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  _buildDangerIndicator(feedback.nivelPeligro),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                feedback.comentario,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.9), 
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: theme.colorScheme.onSurface.withOpacity(0.1)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person_outline, size: 14, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        feedback.autor,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6), 
                          fontSize: 12, 
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(feedback.fecha),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.4), 
                      fontSize: 11,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerIndicator(int level) {
    return Row(
      children: List.generate(5, (index) {
        final isActive = index < level;
        return Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Icon(
            Icons.local_fire_department_rounded,
            color: isActive ? Colors.orangeAccent : Colors.white.withOpacity(0.05),
            size: 20,
          ),
        );
      }),
    );
  }
}
