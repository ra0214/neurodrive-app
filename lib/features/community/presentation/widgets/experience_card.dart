import 'package:flutter/material.dart';
import '../../domain/entities/experience.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;

  const ExperienceCard({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cyanColor = const Color(0xFF00F1FE);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: experience.isCritical 
            ? theme.colorScheme.error.withOpacity(0.8) 
            : theme.colorScheme.onSurface.withOpacity(0.1),
          width: experience.isCritical ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cyanColor.withOpacity(0.5), width: 2),
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w900, 
                        fontSize: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (experience.userRole.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: cyanColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: cyanColor, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              experience.userRole.toUpperCase(),
                              style: TextStyle(
                                color: cyanColor, 
                                fontSize: 9, 
                                fontWeight: FontWeight.black,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                experience.timeAgo,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4), 
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (experience.isCritical) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'ESTADO CRÍTICO DETECTADO',
                        style: TextStyle(
                          color: theme.colorScheme.error, 
                          fontSize: 11, 
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    experience.content,
                    style: TextStyle(
                      fontStyle: FontStyle.italic, 
                      color: theme.colorScheme.onSurface,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              experience.content,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.9),
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              _buildAction(theme, Icons.thumb_up_alt_rounded, experience.likes.toString(), cyanColor, isLiked: experience.likes > 30),
              const SizedBox(width: 25),
              _buildAction(theme, Icons.chat_bubble_rounded, experience.comments.toString(), cyanColor),
              if (!experience.isCritical && experience.content.length > 50) ...[
                const Spacer(),
                Text(
                  'Ver más', 
                  style: TextStyle(
                    color: cyanColor, 
                    fontSize: 13, 
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(ThemeData theme, IconData icon, String count, Color cyan, {bool isLiked = false}) {
    final color = isLiked ? cyan : theme.colorScheme.onSurface.withOpacity(0.5);
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          count, 
          style: TextStyle(
            color: color, 
            fontSize: 14,
            fontWeight: isLiked ? FontWeight.w900 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
