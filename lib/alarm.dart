//lib/alarm.dart
import 'package:flutter/material.dart';

import 'alarm_form.dart';
import 'alarm_model.dart';
import 'alarm_repository.dart';
import 'delete_dialog.dart';
import 'movie_model.dart';
import 'movie_repository.dart';

const Color kMorado = Color.fromARGB(255, 107, 63, 158);
const Color kAzul = Color.fromARGB(255, 132, 217, 222);

/// M5: Mis alarmas.
class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final margen = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cine Alarm'),
        foregroundColor: Colors.white,
        backgroundColor: kMorado,
      ),
      body: ListenableBuilder(
        listenable: AlarmRepository.instance,
        builder: (context, _) {
          final alarmas = AlarmRepository.instance.alarmas;

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: margen, vertical: 20),
            children: [
              const Text(
                'Mis Alarmas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              const Text(
                'Tus próximos estrenos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              if (alarmas.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'Aún no tienes alarmas.\nAñade una desde el detalle de una película.',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                for (final alarma in alarmas)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AlarmaCard(
                      key: ValueKey(alarma.movieId),
                      alarma: alarma,
                    ),
                  ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kMorado,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
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

class _AlarmaCard extends StatelessWidget {
  const _AlarmaCard({super.key, required this.alarma});
  final Alarma alarma;

  void _editar(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AlarmFormPage(movieId: movie.id)),
    );
  }

  Future<void> _eliminar(BuildContext context, Movie movie) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmado = await confirmarEliminarAlarma(context, movie.title);
    if (!confirmado) return;

    AlarmRepository.instance.eliminar(movie.id);
    messenger.showSnackBar(
      SnackBar(content: Text('Alarma de ${movie.title} eliminada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie?>(
      future: MovieRepository.instance.getMovieById(alarma.movieId),
      builder: (context, snapshot) {
        final movie = snapshot.data;
        if (movie == null) return const SizedBox.shrink();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    movie.poster,
                    width: 80,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.broken_image, size: 60),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text('Estreno: ${movie.fechaEstrenoLarga}'),
                      Text(
                        alarma.textoAviso(movie.releaseDays),
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromARGB(255, 179, 129, 237),
                            ),
                            onPressed: () => _editar(context, movie),
                            child: const Text('Editar alarma'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromARGB(255, 228, 107, 127),
                            ),
                            onPressed: () => _eliminar(context, movie),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}