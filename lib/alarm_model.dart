// lib/alarm_model.dart

class Alarma {
  final int movieId;
  final int dias;
  final int horas;

  const Alarma({required this.movieId, required this.dias, this.horas = 0});

  /// Ej: "Aviso 5 días antes del estreno"
  String get descripcion {
    final partes = <String>[];
    if (dias > 0) partes.add('$dias ${dias == 1 ? 'día' : 'días'}');
    if (horas > 0) partes.add('$horas ${horas == 1 ? 'hora' : 'horas'}');
    return 'Aviso ${partes.join(' y ')} antes del estreno';
  }

  /// Cuánto falta para que suene la alarma. Ej: "Alarma en 5 días"
  String textoAviso(int releaseDays, {String prefijo = 'Alarma'}) {
    final horasRestantes = releaseDays * 24 - (dias * 24 + horas);
    if (horasRestantes <= 0) return '$prefijo hoy';

    final d = horasRestantes ~/ 24;
    final h = horasRestantes % 24;
    final partes = <String>[];
    if (d > 0) partes.add('$d ${d == 1 ? 'día' : 'días'}');
    if (h > 0) partes.add('$h ${h == 1 ? 'hora' : 'horas'}');
    return '$prefijo en ${partes.join(' y ')}';
  }
}