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
    widget.viewModel.loadMonitoringData();
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
          return const Center(child: Text('No data available'));
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.circle, color: Colors.cyan, size: 12),
          SizedBox(width: 12),
          Text(
            'Conducción Segura',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
          Spacer(),
          Icon(Icons.verified_user_outlined, color: Colors.cyan, size: 20),
        ],
      ),
    );
  }
}
