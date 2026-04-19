import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';

class PollutionState {
  final List<ReportModel> reports;

  PollutionState({this.reports = const []});

  PollutionState copyWith({List<ReportModel>? reports}) {
    return PollutionState(
      reports: reports ?? this.reports,
    );
  }
}

class PollutionNotifier extends StateNotifier<PollutionState> {
  PollutionNotifier() : super(PollutionState());

  void addReport(ReportModel report) {
    final updated = [...state.reports, report];
    state = state.copyWith(reports: updated);
  }

  int getReportsByZone(String zone) {
    return state.reports.where((r) => r.zone == zone).length;
  }

  String getZoneLevel(String zone) {
    final count = getReportsByZone(zone);

    if (count >= 4) return "high";
    if (count >= 2) return "medium";
    return "low";
  }

  bool isCriticalZone(String zone) {
    return getReportsByZone(zone) >= 4;
  }
}

final pollutionProvider =
    StateNotifierProvider<PollutionNotifier, PollutionState>((ref) {
  return PollutionNotifier();
});