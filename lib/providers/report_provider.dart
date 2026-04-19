import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportState {
  final bool loading;

  ReportState({this.loading = false});

  ReportState copyWith({bool? loading}) {
    return ReportState(
      loading: loading ?? this.loading,
    );
  }
}

class ReportNotifier extends StateNotifier<ReportState> {
  ReportNotifier() : super(ReportState());

  void setLoading(bool value) {
    state = state.copyWith(loading: value);
  }
}

final reportProvider =
    StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  return ReportNotifier();
});