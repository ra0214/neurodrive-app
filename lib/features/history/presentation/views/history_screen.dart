import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/global_providers.dart';
import '../widgets/summary_card.dart';
import '../widgets/record_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyViewModelProvider).loadHistoryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(historyViewModelProvider);

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.summary != null)
            SummaryCard(summary: viewModel.summary!),
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
          ...viewModel.records.map((record) => RecordTile(record: record)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(label: 'Todos los Viajes', isSelected: true),
          SizedBox(width: 8),
          _FilterChip(label: 'Alto Riesgo'),
          SizedBox(width: 8),
          _FilterChip(label: 'Rutas'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip({super.key, required this.label, this.isSelected = false});

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
