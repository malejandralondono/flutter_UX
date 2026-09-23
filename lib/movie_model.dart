// lib/models/movie_model.dart

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
  final int releaseDays;
  final String synopsis;
  final List<Actor> actors;

  const Movie({
    required this.id,
    required this.title,
    required this.poster,
    required this.duration,
    required this.genre,
    required this.releaseDays,
    required this.synopsis,
    required this.actors,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      poster: json['poster'] as String,
      duration: json['duration'] as int,
      genre: json['genre'] as String,
      releaseDays: json['releaseDays'] as int,
      synopsis: json['synopsis'] as String,
      actors: (json['actors'] as List<dynamic>)
          .map((a) => Actor.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}