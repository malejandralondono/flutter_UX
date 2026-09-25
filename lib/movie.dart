// lib/movie.dart
import 'package:flutter/material.dart';

import 'alarm.dart';
import 'alarm_form.dart';
import 'alarm_repository.dart';
import 'movie_model.dart';
import 'movie_repository.dart';

const Color kMorado = Color.fromARGB(255, 107, 63, 158);
const Color kAzul = Color.fromARGB(255, 132, 217, 222);

class MoviePage extends StatelessWidget {
  const MoviePage({super.key, required this.movieId});
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cine Alarm'),
        foregroundColor: Colors.white,
        backgroundColor: kMorado,
      ),
      body: FutureBuilder<Movie?>(
        future: MovieRepository.instance.getMovieById(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final movie = snapshot.data;
          if (movie == null) {
            return Center(
              child: Text('No existe una película con id $movieId'),
            );
          }
          return SingleChildScrollView(child: _MovieDetail(movie: movie));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kMorado,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AlarmPage()),
            );
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Catálogo'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Mis Alarmas'),
        ],
      ),
    );
  }
}

class _MovieDetail extends StatelessWidget {
  const _MovieDetail({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                movie.poster,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(movie.title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text('${movie.genre}  |  ${movie.duration} min'),
          const SizedBox(height: 16),

          Card(
            child: ListTile(
              tileColor: const Color.fromARGB(255, 224, 211, 237),
              title: Text(
                'Estreno: ${movie.fechaEstrenoCorta}',
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              height: 56,
              child: ListenableBuilder(
                listenable: AlarmRepository.instance,
                builder: (context, _) {
                  final tieneAlarma =
                      AlarmRepository.instance.getByMovieId(movie.id) != null;

                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAzul,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlarmFormPage(movieId: movie.id),
                        ),
                      );
                    },
                    icon: Icon(tieneAlarma ? Icons.edit_notifications : Icons.alarm_add),
                    label: Text(tieneAlarma ? 'Editar alarma' : 'Añadir alarma'),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text("Actores", style: TextStyle(fontSize: 17)),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: movie.actors.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final actor = movie.actors[i];
                return SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          actor.photo,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const CircleAvatar(
                            radius: 32,
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        actor.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          const Text("Sinopsis", style: TextStyle(fontSize: 17)),
          const SizedBox(height: 8),
          Text(movie.synopsis),
        ],
      ),
    );
  }
}