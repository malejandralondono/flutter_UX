import { Pelicula } from './pelicula.model';

export interface Cine {
  id: number;
  nombre: string;
  locacion: string; 
  peliculas: Pelicula[];
  formatos: string;
 }