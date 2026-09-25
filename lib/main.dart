// lib/main.dart
import 'package:flutter/material.dart';
import 'package:stacked_cards_carousel/stacked_cards_carousel.dart';

import 'alarm.dart';
import 'alarm_form.dart';
import 'alarm_model.dart';
import 'alarm_repository.dart';
import 'movie.dart';
import 'movie_model.dart';
import 'movie_repository.dart';

const Color kMorado = Color.fromARGB(255, 107, 63, 158);
const Color kAzul = Color.fromARGB(255, 132, 217, 222);

void main() {
  runApp(const MainApp());
}

void abrirPelicula(BuildContext context, int movieId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => MoviePage(movieId: movieId)),
  );
}

void abrirFormularioAlarma(BuildContext context, int movieId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => AlarmFormPage(movieId: movieId)),
  );
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName, required this.poster});
  final String cardName;
  final String poster;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Image.asset(
            poster,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const Center(child: Icon(Icons.broken_image, size: 48)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(cardName, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

/// Película que ya tiene alarma: el botón abre la edición (M7).
class _CardAlarma extends StatelessWidget {
  const _CardAlarma({required this.movie, required this.alarma});
  final Movie movie;
  final Alarma alarma;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ListTile(
          leading: Image.asset(
            movie.poster,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.broken_image, size: 80),
          ),
          title: Text(movie.title),
          subtitle: Text(alarma.textoAviso(movie.releaseDays, prefijo: 'Aviso')),
          trailing: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: kMorado,
            ),
            child: const Text('ACTIVA'),
            onPressed: () => abrirFormularioAlarma(context, movie.id),
          ),
        ),
      ),
    );
  }
}

/// Película próxima sin alarma: el botón abre la configuración (M4).
class _CardProxima extends StatelessWidget {
  const _CardProxima({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ListTile(
          leading: Image.asset(
            movie.poster,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.broken_image, size: 80),
          ),
          title: Text(movie.title),
          subtitle: Text("Estreno en ${movie.releaseDays} días"),
          trailing: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: kAzul,
            ),
            child: const Text('ACTIVAR'),
            onPressed: () => abrirFormularioAlarma(context, movie.id),
          ),
        ),
      ),
    );
  }
}

/// Muestra primero las películas con alarma y luego las 2 próximas sin alarma.
/// Se actualiza solo cuando se crea, edita o elimina una alarma.
class _RadarAlarmas extends StatelessWidget {
  const _RadarAlarmas({required this.moviesFuture});
  final Future<List<Movie>> moviesFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final movies = snapshot.data!;

        return ListenableBuilder(
          listenable: AlarmRepository.instance,
          builder: (context, _) {
            final conAlarma = <(Movie, Alarma)>[];
            final sinAlarma = <Movie>[];

            for (final movie in movies) {
              final alarma = AlarmRepository.instance.getByMovieId(movie.id);
              if (alarma != null) {
                conAlarma.add((movie, alarma));
              } else {
                sinAlarma.add(movie);
              }
            }
            sinAlarma.sort((a, b) => a.releaseDays.compareTo(b.releaseDays));

            return Column(
              children: [
                for (final (movie, alarma) in conAlarma)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CardAlarma(movie: movie, alarma: alarma),
                  ),
                for (final movie in sinAlarma.take(2))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CardProxima(movie: movie),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = MovieRepository.instance.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.movie_filter_outlined),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Cine Alarm'),
        foregroundColor: Colors.white,
        backgroundColor: kMorado,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.clear),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("En Cartelera Pronto", style: TextStyle(fontSize: 25)),
            SizedBox(
              height: 350,
              child: FutureBuilder<List<Movie>>(
                future: _moviesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'No se pudo cargar assets/movies.json. '
                        'Revisa que esté declarado en pubspec.yaml.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  final movies = snapshot.data!;
                  return StackedCardsCarouselWidget(
                    items: movies
                        .map(
                          (movie) => GestureDetector(
                            onTap: () => abrirPelicula(context, movie.id),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: _SampleCard(
                                cardName: movie.title,
                                poster: movie.poster,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            const Text("Tu radar de estrenos", style: TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: _RadarAlarmas(moviesFuture: _moviesFuture),
            ),
            const SizedBox(height: 20),
          ],
        ),
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