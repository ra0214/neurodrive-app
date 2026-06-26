import 'package:flutter/material.dart';
import '../view_models/monitoring_view_model.dart';
import '../widgets/attention_card.dart';
import '../widgets/monitoring_grid_items.dart';
import '../widgets/destination_card.dart';

class MonitoringScreen extends StatefulWidget {
  final MonitoringViewModel viewModel;

  const MonitoringScreen({super.key, required this.viewModel});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid calling notifyListeners() during build phase
    Future.microtask(() => widget.viewModel.loadMonitoringData());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        if (widget.viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final status = widget.viewModel.status;
        if (status == null) {
          return const Center(child: Text('No hay datos disponibles'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 16),
              AttentionCard(
                level: status.attentionLevel,
                activeTime: status.activeTime,
                sessionId: status.sessionId,
              ),
              const SizedBox(height: 16),
              MonitoringGridItems(status: status),
              const SizedBox(height: 16),
              DestinationCard(destination: status.nextDestination),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, color: theme.colorScheme.primary, size: 12),
          const SizedBox(width: 12),
          Text(
            'Conducción Segura',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          Icon(Icons.verified_user_outlined, color: theme.colorScheme.primary, size: 20),
        ],
      ),
    );
  }
}
