// lib/main.dart
import 'package:flutter/material.dart';
import 'package:stacked_cards_carousel/stacked_cards_carousel.dart';

import 'movie_repository.dart';
import 'movie_model.dart';
import 'movie.dart';
import 'alarm.dart';


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
            errorBuilder: (_, __, ___) =>
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

class _CardAlarma extends StatelessWidget {
  const _CardAlarma({required this.movie});
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
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
          title: Text(movie.title),
          subtitle: Text("Aviso en ${movie.releaseDays} días"),
          trailing: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: kMorado,
            ),
            child: const Text('ACTIVA'),
            onPressed: () {
Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AlarmPage()),
      );            },
          ),
        ),
      ),
    );
  }
}

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
                errorBuilder: (_, __, ___) =>
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
            onPressed: () {
Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AlarmPage()),
      );            },
          ),
        ),
      ),
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
            const Text("Radar de Alarmas", style: TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(4),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _CardAlarma(movie: snapshot.data!);
                },
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(5),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _CardAlarma(movie: snapshot.data!);
                },
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(3),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _CardProxima(movie: snapshot.data!);
                },
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
                child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(2),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _CardProxima(movie: snapshot.data!);
                },
              ),
            ),
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