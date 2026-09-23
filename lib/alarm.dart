//lib/alarm.dart
import 'package:flutter/material.dart';
import 'main.dart';
import 'movie_model.dart';
import 'movie_repository.dart';

const Color kMorado = Color.fromARGB(255, 107, 63, 158);
const Color kAzul = Color.fromARGB(255, 132, 217, 222);

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cine Alarm'),
        foregroundColor: Colors.white,
        backgroundColor: kMorado,
      ),
      body:  SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text("Mis Alarmas", style: TextStyle(fontSize: 25)),
            const Text("Tus proximos estrenos", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(1),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _AlarmaCard(movie: snapshot.data!);
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(2),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _AlarmaCard(movie: snapshot.data!);
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(3),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _AlarmaCard(movie: snapshot.data!);
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(4),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _AlarmaCard(movie: snapshot.data!);
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(5),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _AlarmaCard(movie: snapshot.data!);
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Movie?>(
                future: MovieRepository.instance.getMovieById(6),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return _AlarmaCard(movie: snapshot.data!);
                },
              ),
            ),
            
            
            ])),),
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: kMorado,
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white70,
  currentIndex: 1, 
  onTap: (index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
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


class _AlarmaCard extends StatelessWidget {
  const _AlarmaCard({required this.movie});
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // necesario dentro de trailing
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 179, 129, 237),
              ),
              child: const Text('Editar'),
              onPressed: () {
              },
            ),
            const SizedBox(width: 8),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 228, 107, 127),
              ),
              child: const Text('Eliminar'),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    ),
  );
}}