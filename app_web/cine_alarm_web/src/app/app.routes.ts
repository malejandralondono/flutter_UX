import { Routes } from '@angular/router';
import { ListaPeliculasComponent } from './features/peliculas/pages/lista-peliculas/lista-peliculas.component';
import { NuevaPeliculaComponent } from './features/peliculas/pages/nueva-pelicula/nueva-pelicula.component';
import { ListaCinesComponent } from './features/cines/pages/lista-cines/lista-cines.component';
import { NuevoCineComponent } from './features/cines/pages/nuevo-cine/nuevo-cine.component';
import { EditarCineComponent } from './features/cines/pages/editar-cine/editar-cine.component';

export const routes: Routes = [
  { path: '', redirectTo: 'peliculas', pathMatch: 'full' },
  { path: 'peliculas', component: ListaPeliculasComponent },
  { path: 'peliculas/nueva', component: NuevaPeliculaComponent },
  { path: 'cines', component: ListaCinesComponent },
  { path: 'cines/nuevo', component: NuevoCineComponent },
  { path: 'cines/:id/editar', component: EditarCineComponent },
];