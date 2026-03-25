import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reporte_model.dart';

class ReportNotifier extends StateNotifier<List<Reporte>> {
  ReportNotifier() : super([]);

  void addReport(Reporte reporte) {
    state = [...state, reporte];
  }
}

final reportProvider =
    StateNotifierProvider<ReportNotifier, List<Reporte>>(
        (ref) => ReportNotifier());