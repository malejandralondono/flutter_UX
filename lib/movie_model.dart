// lib/models/movie_model.dart

const _mesesCortos = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

const _mesesLargos = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

class Actor {
  final String name;
  final String photo;

  const Actor({required this.name, required this.photo});

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      name: json['name'] as String,
      photo: json['photo'] as String,
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String poster;
  final int duration; // minutos
  final String genre;
  final DateTime releaseDate;
  final String synopsis;
  final List<Actor> actors;

  const Movie({
    required this.id,
    required this.title,
    required this.poster,
    required this.duration,
    required this.genre,
    required this.releaseDate,
    required this.synopsis,
    required this.actors,
  });

  /// Días que faltan para el estreno, contados desde hoy.
  int get releaseDays {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final dias = releaseDate.difference(hoy).inDays;
    return dias < 0 ? 0 : dias;
  }

  /// Ej: "27 oct 2026"
  String get fechaEstrenoCorta =>
      '${releaseDate.day} ${_mesesCortos[releaseDate.month - 1]} ${releaseDate.year}';

  /// Ej: "27 de octubre de 2026"
  String get fechaEstrenoLarga =>
      '${releaseDate.day} de ${_mesesLargos[releaseDate.month - 1]} de ${releaseDate.year}';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      poster: json['poster'] as String,
      duration: json['duration'] as int,
      genre: json['genre'] as String,
      releaseDate: _leerFechaEstreno(json),
      synopsis: json['synopsis'] as String,
      actors: (json['actors'] as List<dynamic>)
          .map((a) => Actor.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Usa "releaseDate" si existe. Si no, la calcula desde "releaseDays"
  /// para que la app no se rompa mientras se actualiza el JSON.
  static DateTime _leerFechaEstreno(Map<String, dynamic> json) {
    final fecha = json['releaseDate'] as String?;
    if (fecha != null) return DateTime.parse(fecha);

    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    return hoy.add(Duration(days: json['releaseDays'] as int));
  }
}