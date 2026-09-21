import 'package:flutter/material.dart';
import 'package:stacked_cards_carousel/stacked_cards_carousel.dart';

void main() {
  runApp(const MainApp());
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName});
  final String cardName;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 100,
      child: Center(child: Text(cardName)),
    );
  }
}

class _CardAlarma extends StatelessWidget {
  const _CardAlarma({required this.movieName,
                      required this.aviso});
    final String movieName;
    final int aviso;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.movie),
          title:  Text(movieName),
          subtitle: Text("Aviso en $aviso dias"),
          trailing: TextButton(
            child: const Text('ACTIVA'),
            onPressed: () {
              /* ... */
            },
          ),
        ),
      ),
    );
  }
}

class _CardProxima extends StatelessWidget {
  const _CardProxima({required this.movieName,
                      required this.estreno});
    final String movieName;
    final int estreno;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.movie),
          title:  Text(movieName),
          subtitle: Text("Estreno en $estreno dias"),
          trailing: TextButton(
            child: const Text('ACTIVAR'),
            onPressed: () {
              /* ... */
            },
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
      home: HomePage(),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.movie_filter_outlined),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
          title: Text('Cine Alarm'),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 107, 63, 158),
        
      ),
      body: 
      SingleChildScrollView(
        child: Column(
    children: [
      SizedBox(height: 20),
      TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.clear),
            border: OutlineInputBorder(),
          ),
    ),
    SizedBox(height: 20),
    SizedBox(
      child: Text.rich(TextSpan(text:"En Cartelera Pronto", style: TextStyle( fontSize: 25) ))
    ),
    SizedBox(height: 20),

    SizedBox(
    height: 300,
    child: StackedCardsCarouselWidget(
      items: <Widget>[
        Card(child: _SampleCard(cardName: 'E')),
        Card(child: _SampleCard(cardName: 'El')),
        Card(child: _SampleCard(cardName: 'Ele')),
        Card(child: _SampleCard(cardName: 'Elev')),
        Card(child: _SampleCard(cardName: 'Eleva')),
        Card(child: _SampleCard(cardName: 'Elevat')),
        Card(child: _SampleCard(cardName: 'Elevate')),
        Card(child: _SampleCard(cardName: 'Elevated')),
        ]
    ),
    ),
    SizedBox(height: 20),
    SizedBox(
      child: Text.rich(TextSpan(text:"Radar de Alarmas", style: TextStyle( fontSize: 25) ))
    ),
    SizedBox(height: 20),
    _CardAlarma(movieName: "La odisea",
                 aviso: 5),
    SizedBox(height: 10),
    _CardAlarma(movieName: "The Invite",
                 aviso: 2),
    SizedBox(height: 10),
    _CardProxima(movieName: "The Invite",
                 estreno: 20),
    SizedBox(height: 10),
    _CardProxima(movieName: "The Invite",
                 estreno: 14),
    ],
  ),
      ),
    );
    }
}
