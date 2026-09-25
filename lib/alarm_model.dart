// lib/alarm_model.dart
class Alarma {
  final int movieId;
  final int dias;
  final int horas;

  const Alarma({required this.movieId, required this.dias, this.horas = 0});

  String get descripcion {
    final partes = <String>[];
    if (dias > 0) partes.add('$dias ${dias == 1 ? 'día' : 'días'}');
    if (horas > 0) partes.add('$horas ${horas == 1 ? 'hora' : 'horas'}');
    return 'Aviso ${partes.join(' y ')} antes del estreno';
  }
}