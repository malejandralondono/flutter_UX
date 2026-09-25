// lib/alarm_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'alarm_model.dart';
import 'alarm_repository.dart';
import 'movie_model.dart';
import 'movie_repository.dart';

const Color _morado = Color.fromARGB(255, 107, 63, 158);
const Color _lila = Color.fromARGB(255, 179, 129, 237);
const Color _fondoLila = Color.fromARGB(255, 224, 211, 237);

/// M4 (Configurar alarma) y M7 (Editar alarma).
class AlarmFormPage extends StatefulWidget {
  const AlarmFormPage({super.key, required this.movieId});
  final int movieId;

  @override
  State<AlarmFormPage> createState() => _AlarmFormPageState();
}

class _AlarmFormPageState extends State<AlarmFormPage> {
  static const _opciones = [1, 3, 5, 7, 10, 15];

  late final Future<Movie?> _movieFuture;
  late final bool _editando;

  int? _diasSeleccionados;
  final _diasCtrl = TextEditingController();
  final _horasCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _movieFuture = MovieRepository.instance.getMovieById(widget.movieId);

    final existente = AlarmRepository.instance.getByMovieId(widget.movieId);
    _editando = existente != null;

    if (existente != null) {
      if (existente.horas == 0 && _opciones.contains(existente.dias)) {
        _diasSeleccionados = existente.dias;
      } else {
        _diasCtrl.text = '${existente.dias}';
        _horasCtrl.text = '${existente.horas}';
      }
    }
  }

  @override
  void dispose() {
    _diasCtrl.dispose();
    _horasCtrl.dispose();
    super.dispose();
  }

  void _seleccionarOpcion(int dias) {
    setState(() {
      _diasSeleccionados = dias;
      _diasCtrl.clear();
      _horasCtrl.clear();
    });
  }

  void _alEscribirPersonalizada(String _) {
    if (_diasSeleccionados != null) {
      setState(() => _diasSeleccionados = null);
    }
  }

  void _guardar(Movie movie) {
    final int dias;
    final int horas;

    if (_diasSeleccionados != null) {
      dias = _diasSeleccionados!;
      horas = 0;
    } else {
      dias = int.tryParse(_diasCtrl.text) ?? 0;
      horas = int.tryParse(_horasCtrl.text) ?? 0;
    }

    String? error;
    if (dias == 0 && horas == 0) {
      error = 'Elige una opción o escribe una alarma personalizada.';
    } else if (horas > 23) {
      error = 'Las horas deben estar entre 0 y 23.';
    } else if (dias * 24 + horas > movie.releaseDays * 24) {
      error = 'La película se estrena en ${movie.releaseDays} días. Elige un aviso menor.';
    }

    final messenger = ScaffoldMessenger.of(context);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    AlarmRepository.instance.guardar(
      Alarma(movieId: movie.id, dias: dias, horas: horas),
    );
    messenger.showSnackBar(
      SnackBar(content: Text(_editando ? 'Alarma actualizada' : 'Alarma guardada')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cine Alarm'),
        foregroundColor: Colors.white,
        backgroundColor: _morado,
      ),
      body: FutureBuilder<Movie?>(
        future: _movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final movie = snapshot.data;
          if (movie == null) {
            return Center(child: Text('No existe una película con id ${widget.movieId}'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Encabezado(
                  movie: movie,
                  titulo: _editando ? 'Editar alarma' : 'Configurar alarma',
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '¿Con cuánto tiempo quieres recibir la alarma para el estreno?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final dias in _opciones)
                            ChoiceChip(
                              label: Text('$dias ${dias == 1 ? 'día' : 'días'}'),
                              selected: _diasSeleccionados == dias,
                              showCheckmark: false,
                              selectedColor: _lila,
                              labelStyle: TextStyle(
                                color: _diasSeleccionados == dias ? Colors.white : null,
                              ),
                              onSelected: (_) => _seleccionarOpcion(dias),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Alarma personalizada',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: _CampoNumero(
                              controller: _diasCtrl,
                              sufijo: 'días',
                              onChanged: _alEscribirPersonalizada,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _CampoNumero(
                              controller: _horasCtrl,
                              sufijo: 'horas',
                              onChanged: _alEscribirPersonalizada,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: _lila,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          ),
                          onPressed: () => _guardar(movie),
                          child: Text(_editando ? 'Guardar cambios' : 'Guardar alarma'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.movie, required this.titulo});
  final Movie movie;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _fondoLila,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _morado,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text('Estreno: ${movie.fechaEstrenoCorta}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampoNumero extends StatelessWidget {
  const _CampoNumero({
    required this.controller,
    required this.sufijo,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String sufijo;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        suffixText: sufijo,
        border: const UnderlineInputBorder(),
      ),
    );
  }
}