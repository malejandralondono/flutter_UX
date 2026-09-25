// lib/alarm_repository.dart
import 'package:flutter/foundation.dart';

import 'alarm_model.dart';

class AlarmRepository extends ChangeNotifier {
  AlarmRepository._();
  static final AlarmRepository instance = AlarmRepository._();

  final List<Alarma> _alarmas = [
    const Alarma(movieId: 4, dias: 5),
    const Alarma(movieId: 5, dias: 15),
  ];

  List<Alarma> get alarmas => List.unmodifiable(_alarmas);

  Alarma? getByMovieId(int movieId) {
    for (final alarma in _alarmas) {
      if (alarma.movieId == movieId) return alarma;
    }
    return null;
  }

  /// Crea la alarma o la reemplaza si la película ya tenía una.
  void guardar(Alarma alarma) {
    final i = _alarmas.indexWhere((a) => a.movieId == alarma.movieId);
    if (i == -1) {
      _alarmas.add(alarma);
    } else {
      _alarmas[i] = alarma;
    }
    notifyListeners();
  }

  void eliminar(int movieId) {
    _alarmas.removeWhere((a) => a.movieId == movieId);
    notifyListeners();
  }
}