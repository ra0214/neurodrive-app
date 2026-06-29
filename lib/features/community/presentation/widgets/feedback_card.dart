import 'package:flutter/material.dart';
import '../../data/models/feedback_model.dart';
import 'package:intl/intl.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;

  const FeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF1D1E33),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    feedback.nombreRuta,
                    style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                _buildDangerIndicator(feedback.nivelPeligro),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              feedback.comentario,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const Divider(color: Colors.white10, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chofer ID: ${feedback.idAutor}",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(feedback.fecha),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
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
          index < level ? Icons.warning_rounded : Icons.warning_amber_rounded,
          color: index < level ? Colors.redAccent : Colors.white10,
          size: 18,
        );
      }),
    );
  }
}
