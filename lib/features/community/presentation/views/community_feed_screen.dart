import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/feedback_provider.dart';
import '../widgets/feedback_card.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedbackProvider>().fetchFeedbacks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cyanColor = const Color(0xFF00F1FE);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "ALERTAS DE COMUNIDAD",
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.5,
            fontSize: 18,
            color: isDark ? cyanColor : theme.colorScheme.onBackground,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<FeedbackProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.feedbacks.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: cyanColor),
            );
          }
          
          if (provider.errorMessage != null && provider.feedbacks.isEmpty) {
            return _buildErrorState(provider, theme, cyanColor);
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchFeedbacks(),
            color: cyanColor,
            backgroundColor: theme.colorScheme.surface,
            child: provider.feedbacks.isEmpty 
              ? ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Center(
                      child: Text(
                        "No hay alertas en tu zona.",
                        style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.5)),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: provider.feedbacks.length,
                  itemBuilder: (context, index) => FeedbackCard(feedback: provider.feedbacks[index]),
                ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: cyanColor,
        elevation: 10,
        onPressed: () => _showAddFeedbackModal(context),
        icon: const Icon(Icons.add_alert_rounded, color: Colors.black),
        label: const Text(
          "REPORTAR RUTA",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildErrorState(FeedbackProvider provider, ThemeData theme, Color cyan) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 70, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.8), fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchFeedbacks(),
              style: ElevatedButton.styleFrom(backgroundColor: cyan, foregroundColor: Colors.black),
              child: const Text("REINTENTAR"),
            )
          ],
        ),
      ),
    );
  }

  void _showAddFeedbackModal(BuildContext context) {
    // Implementación del modal con tema dinámico...
  }
}
