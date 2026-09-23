import { Injectable, inject, signal } from '@angular/core';
import { Cine } from '../models/cine.model';
import { PeliculaService } from './pelicula.service';

@Injectable({ providedIn: 'root' })
export class CineService {
  private peliculaService = inject(PeliculaService);

private readonly _cines = signal<Cine[]>([
  {
    id: 1,
    nombre: 'Cine Colombia Andino',
    locacion: 'Bogotá - Centro Comercial Andino',
    formatos: '2D, 3D, IMAX',
    peliculas: this.peliculaService.getPeliculasPorIds([1, 5, 6]),
  },
  {
    id: 2,
    nombre: 'Cinemark Plaza Central',
    locacion: 'Bogotá - Plaza Central',
    formatos: '2D, 3D, XD',
    peliculas: this.peliculaService.getPeliculasPorIds([1, 2, 4, 5]),
  },
  {
    id: 3,
    nombre: 'Procinal Unicentro',
    locacion: 'Bogotá - Unicentro',
    formatos: '2D, 3D',
    peliculas: this.peliculaService.getPeliculasPorIds([2, 3, 6]),
  },
  {
    id: 4,
    nombre: 'Cinépolis Titán Plaza',
    locacion: 'Bogotá - Titán Plaza',
    formatos: '2D, 3D, 4DX, VIP',
    peliculas: this.peliculaService.getPeliculasPorIds([1, 4, 5, 6]),
  },
  {
    id: 5,
    nombre: 'Cine Colombia Chipichape',
    locacion: 'Cali - Chipichape',
    formatos: '2D, 3D',
    peliculas: this.peliculaService.getPeliculasPorIds([2, 5]),
  },
  {
    id: 6,
    nombre: 'Cinemark El Tesoro',
    locacion: 'Medellín - El Tesoro',
    formatos: '2D, 3D, XD',
    peliculas: this.peliculaService.getPeliculasPorIds([1, 3, 4, 6]),
  },
  {
    id: 7,
    nombre: 'Cinemateca de Bogotá',
    locacion: 'Bogotá - Centro',
    formatos: '2D',
    peliculas: this.peliculaService.getPeliculasPorIds([3]),
  },
  {
    id: 8,
    nombre: 'Royal Films Buenavista',
    locacion: 'Barranquilla - Buenavista',
    formatos: '2D, 3D',
    peliculas: this.peliculaService.getPeliculasPorIds([1, 2, 5, 6]),
  },
]);

  readonly cines = this._cines.asReadonly();

  getCinePorId(id: number): Cine | undefined {
  return this._cines().find(c => c.id === id);
}

actualizar(id: number, datos: Omit<Cine, 'id' | 'peliculas'>, idsPeliculas: number[]) {
  this._cines.update(lista =>
    lista.map(c =>
      c.id === id
        ? { ...datos, id, peliculas: this.peliculaService.getPeliculasPorIds(idsPeliculas) }
        : c
    )
  );
}

  agregar(datos: Omit<Cine, 'id' | 'peliculas'>, idsPeliculas: number[]) {
    const nuevo: Cine = {
      ...datos,
      id: Date.now(),
      peliculas: this.peliculaService.getPeliculasPorIds(idsPeliculas),
    };
    this._cines.update(lista => [...lista, nuevo]);
  }
}