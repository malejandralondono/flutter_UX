// lib/data/movie_repository.dart
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '/movie_model.dart';

/// Carga las películas desde assets/movies.json una sola vez
/// y permite buscarlas por id.
class MovieRepository {
  MovieRepository._();
  static final MovieRepository instance = MovieRepository._();

  List<Movie>? _cache;

  Future<List<Movie>> getMovies() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/movies.json');
    final data = jsonDecode(raw) as List<dynamic>;
    _cache = data
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  Future<Movie?> getMovieById(int id) async {
    final movies = await getMovies();
    for (final movie in movies) {
      if (movie.id == id) return movie;
    }
    return null;
  }
}