import { Injectable, signal } from '@angular/core';
import { Pelicula, PeliculaFormulario } from '../models/pelicula.model';

@Injectable({ providedIn: 'root' })
export class PeliculaService {
  private readonly _peliculas = signal<Pelicula[]>([
    {
      id: 1,
      titulo: 'Nova: Horizonte',
      fechaEstreno: '2026-08-28',
      cantidadCines: 12,
      sinopsis: 'Una historia de aventura y suspenso...',
      trailerUrl: 'https://www.youtube.com/watch?v=BPidLpADlaM',
    },
    { id: 2, titulo: 'Medianoche en Cali', fechaEstreno: '2026-08-24', cantidadCines: 8 },
    { id: 3, titulo: 'El último fotograma', fechaEstreno: '2026-09-04', cantidadCines: 4 },
    { id: 4, titulo: 'Ruta nocturna', fechaEstreno: '2026-09-10', cantidadCines: 7 },
    { id: 5, titulo: 'Spiderman', fechaEstreno: '2026-09-12', cantidadCines: 10 },
    { id: 6, titulo: 'El Coyote', fechaEstreno: '2026-09-13', cantidadCines: 12 },
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

