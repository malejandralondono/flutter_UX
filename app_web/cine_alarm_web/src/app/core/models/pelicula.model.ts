export interface Pelicula {
  id: number;
  titulo: string;
  fechaEstreno: string; // formato 'YYYY-MM-DD'
  cantidadCines: number;
  sinopsis?: string;
  trailerUrl?: string;
  posterUrl?: string;
}