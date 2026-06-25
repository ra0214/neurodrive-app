import 'package:flutter/material.dart';
import '../view_models/community_view_model.dart';
import '../widgets/experience_card.dart';

class CommunityScreen extends StatefulWidget {
  final CommunityViewModel viewModel;

  const CommunityScreen({super.key, required this.viewModel});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.viewModel.loadCommunityData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        if (widget.viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopActionCard(),
              const SizedBox(height: 16),
              _buildPrecisionCard(),
              const SizedBox(height: 24),
              const Text(
                'EXPERIENCIAS RECIENTES',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...widget.viewModel.experiences.map((exp) => ExperienceCard(experience: exp)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopActionCard() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Comunidad y\nFeedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 120, // Give button a fixed width or wrap in IntrinsicWidth
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Compartir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                minimumSize: const Size(0, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecisionCard() {
    final summary = widget.viewModel.summary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PRECISIÓN GLOBAL',
                style: TextStyle(fontSize: 10, color: Colors.white54, letterSpacing: 1.2),
              ),
              const SizedBox(height: 4),
              Text(
                '${summary?.globalPrecision ?? 0}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.cyan),
              ),
            ],
          ),
          Row(
            children: [
              _buildEmojiIcon(Icons.sentiment_dissatisfied_outlined, false),
              const SizedBox(width: 8),
              _buildEmojiIcon(Icons.sentiment_satisfied_alt_outlined, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiIcon(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.cyan.withValues(alpha: 0.1) : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.cyan : Colors.white10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: isSelected ? Colors.cyan : Colors.white24, size: 20),
    );
  }
}
