import { Component, computed, inject } from '@angular/core';
import { PeliculaService } from '../../../../core/services/pelicula.service';
import { Pelicula } from '../../../../core/models/pelicula.model';
import { TablaPeliculasComponent } from '../../components/tabla-peliculas/tabla-peliculas.component';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';

@Component({
  selector: 'app-lista-peliculas',
  standalone: true,
  imports: [TablaPeliculasComponent, BotonComponent],
  templateUrl: './lista-peliculas.component.html',
  styleUrl: './lista-peliculas.component.css',
})
export class ListaPeliculasComponent {
  private peliculaService = inject(PeliculaService);

  peliculas = this.peliculaService.peliculas;
  total = computed(() => this.peliculas().length);

  nuevaPelicula() {
    // TODO: navegar al formulario de registro
    console.log('Nueva película');
  }

  editarPelicula(pelicula: Pelicula) {
    // TODO: navegar al formulario de edición
    console.log('Editar', pelicula);
  }
}
