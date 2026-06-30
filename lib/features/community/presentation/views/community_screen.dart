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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cyanColor = const Color(0xFF00F1FE);

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        if (widget.viewModel.isLoading) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(child: CircularProgressIndicator(color: cyanColor)),
          );
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: Text(
              'NeuroDrive',
              style: TextStyle(
                color: cyanColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.account_circle_outlined, color: theme.colorScheme.onSurface),
                onPressed: () {},
              ),
            ],
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () => widget.viewModel.loadCommunityData(),
            color: cyanColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopActionCard(theme, isDark, cyanColor),
                  const SizedBox(height: 20),
                  _buildPrecisionCard(theme, isDark, cyanColor),
                  const SizedBox(height: 32),
                  Text(
                    'EXPERIENCIAS RECIENTES',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...widget.viewModel.experiences.map((exp) => ExperienceCard(experience: exp)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopActionCard(ThemeData theme, bool isDark, Color cyan) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101B33) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cyan.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Comunidad y\nFeedback',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                color: theme.colorScheme.onSurface,
                height: 1.2,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit, size: 18, color: Colors.black),
            label: const Text(
              'Compartir', 
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: cyan,
              elevation: 4,
              shadowColor: cyan.withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecisionCard(ThemeData theme, bool isDark, Color cyan) {
    final summary = widget.viewModel.summary;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cyan.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PRECISIÓN GLOBAL',
                style: TextStyle(
                  fontSize: 10, 
                  color: theme.colorScheme.onSurface.withOpacity(0.5), 
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${summary?.globalPrecision ?? 0}%',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, 
                  color: cyan,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildEmojiIcon(theme, Icons.sentiment_dissatisfied_outlined, false, cyan),
              const SizedBox(width: 10),
              _buildEmojiIcon(theme, Icons.sentiment_satisfied_alt_outlined, true, cyan),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiIcon(ThemeData theme, IconData icon, bool isSelected, Color cyan) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? cyan.withOpacity(0.15) : Colors.transparent,
        border: Border.all(color: isSelected ? cyan : theme.colorScheme.onSurface.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon, 
        color: isSelected ? cyan : theme.colorScheme.onSurface.withOpacity(0.3), 
        size: 24,
      ),
    );
  }
}
