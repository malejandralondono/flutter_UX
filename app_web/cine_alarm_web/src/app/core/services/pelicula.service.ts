import { Injectable, signal } from '@angular/core';
import { Pelicula, PeliculaFormulario } from '../models/pelicula.model';

@Injectable({ providedIn: 'root' })
export class PeliculaService {
  private readonly _peliculas = signal<Pelicula[]>([
    {
      id: 1,
      titulo: 'La odisea',
      fechaEstreno: '2026-10-09',
      cantidadCines: 12,
      posterUrl: '/posters/the_odessy.jpg',
      sinopsis:
        'Narra el largo y peligroso viaje de regreso a casa del rey griego Odiseo (Ulises) tras la guerra de Troya.',
    },
    { id: 2, titulo: 'Minions', fechaEstreno: '2026-10-24', cantidadCines: 8, posterUrl: '/posters/minions.jpg' },
    { id: 3, titulo: 'Spiderman', fechaEstreno: '2026-09-29', cantidadCines: 4, posterUrl: '/posters/spiderverse.jpg' },
    { id: 4, titulo: 'Coyote vs ACME', fechaEstreno: '2026-10-04', cantidadCines: 7, posterUrl: '/posters/coyote_vs_acme.jpg' },
    { id: 5, titulo: 'Avatar', fechaEstreno: '2026-10-24', cantidadCines: 10, posterUrl: '/posters/avatar_fire_and_ash.jpg' },
    { id: 6, titulo: 'The Invite', fechaEstreno: '2026-09-29', cantidadCines: 12, posterUrl: '/posters/the_invite.jpg' },
  ]);

  readonly peliculas = this._peliculas.asReadonly();

  obtenerPorId(id: number): Pelicula | undefined {
    return this._peliculas().find(pelicula => pelicula.id === id);
  }

  agregar(datos: PeliculaFormulario) {
    const nueva: Pelicula = { ...datos, id: Date.now(), cantidadCines: 0 };
    this._peliculas.update(lista => [...lista, nueva]);
  }

  actualizar(id: number, datos: PeliculaFormulario) {
    this._peliculas.update(lista =>
      lista.map(pelicula => (pelicula.id === id ? { ...pelicula, ...datos } : pelicula))
    );
  }

  getPeliculasPorIds(ids: number[]): Pelicula[] {
    return this._peliculas().filter(pelicula => ids.includes(pelicula.id));
  }
}