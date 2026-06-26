// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:neurodrive/main.dart';
import 'package:neurodrive/features/monitoring/data/repositories/mock_monitoring_repository.dart';
import 'package:neurodrive/features/monitoring/presentation/view_models/monitoring_view_model.dart';
import 'package:neurodrive/features/history/data/repositories/mock_history_repository.dart';
import 'package:neurodrive/features/history/presentation/view_models/history_view_models.dart';
import 'package:neurodrive/features/community/data/repositories/mock_community_repository.dart';
import 'package:neurodrive/features/community/presentation/view_models/community_view_model.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize mock dependencies
    final monitoringRepository = MockMonitoringRepository();
    final monitoringViewModel = MonitoringViewModel(repository: monitoringRepository);

    final historyRepository = MockHistoryRepository();
    final historyViewModel = HistoryViewModel(repository: historyRepository);

    final communityRepository = MockCommunityRepository();
    final communityViewModel = CommunityViewModel(repository: communityRepository);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      monitoringViewModel: monitoringViewModel,
      historyViewModel: historyViewModel,
      communityViewModel: communityViewModel,
    ));

    // Verify that the app title is present.
    expect(find.text('NeuroDrive'), findsAtLeastNWidgets(1));
  });
}
