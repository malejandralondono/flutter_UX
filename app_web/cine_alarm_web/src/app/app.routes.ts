import { Routes } from '@angular/router';
import { ListaPeliculasComponent } from './features/peliculas/pages/lista-peliculas/lista-peliculas.component';
import { ListaCinesComponent } from './features/cines/pages/lista-cines/lista-cines.component';

export const routes: Routes = [
  { path: '', redirectTo: 'peliculas', pathMatch: 'full' },
  { path: 'peliculas', component: ListaPeliculasComponent },
  { path: 'cines', component: ListaCinesComponent },
];