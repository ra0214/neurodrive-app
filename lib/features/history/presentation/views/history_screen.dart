import 'package:flutter/material.dart';
import '../view_models/history_view_models.dart';
import '../widgets/summary_card.dart';
import '../widgets/record_tile.dart';

class HistoryScreen extends StatefulWidget {
  final HistoryViewModel viewModel;

  const HistoryScreen({super.key, required this.viewModel});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.viewModel.loadHistoryData();
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
              if (widget.viewModel.summary != null)
                SummaryCard(summary: widget.viewModel.summary!),
              const SizedBox(height: 24),
              _buildFilters(),
              const SizedBox(height: 24),
              const Text(
                'REGISTROS RECIENTES',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...widget.viewModel.records.map((record) => RecordTile(record: record)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(label: 'Todos los Viajes', isSelected: true),
          const SizedBox(width: 8),
          _FilterChip(label: 'Alto Riesgo'),
          const SizedBox(width: 8),
          _FilterChip(label: 'Rutas'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.cyan : const Color(0xFF161D2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
