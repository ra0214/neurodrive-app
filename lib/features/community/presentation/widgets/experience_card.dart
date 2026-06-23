import 'package:flutter/material.dart';
import '../../domain/entities/experience.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;

  const ExperienceCard({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(16),
        border: experience.isCritical 
          ? Border.all(color: Colors.redAccent.withValues(alpha: 0.3)) 
          : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white10,
                child: const Icon(Icons.person, color: Colors.white54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (experience.userRole.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.cyan, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            experience.userRole,
                            style: const TextStyle(color: Colors.cyan, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Text(
                experience.timeAgo,
                style: const TextStyle(color: Colors.white24, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (experience.isCritical) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'ESTADO CRÍTICO DETECTADO',
                        style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    experience.content,
                    style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              experience.content,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAction(Icons.thumb_up_outlined, experience.likes.toString(), isLiked: experience.likes > 30),
              const SizedBox(width: 24),
              _buildAction(Icons.chat_bubble_outline, experience.comments.toString()),
              if (!experience.isCritical && experience.content.length > 50) ...[
                const Spacer(),
                const Text('Ver más', style: TextStyle(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold)),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String count, {bool isLiked = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isLiked ? Colors.cyan : Colors.white54),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(color: isLiked ? Colors.cyan : Colors.white54, fontSize: 12)),
      ],
    );
  }
}
