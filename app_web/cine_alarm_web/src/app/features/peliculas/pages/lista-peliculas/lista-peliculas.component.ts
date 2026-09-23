import { Component, computed, inject } from '@angular/core';
import { Router } from '@angular/router';
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
  private router = inject(Router);

  peliculas = this.peliculaService.peliculas;
  total = computed(() => this.peliculas().length);

  nuevaPelicula() {
    this.router.navigate(['/peliculas', 'nueva']);
  }

  editarPelicula(pelicula: Pelicula) {
    // TODO: navegar al formulario de edición (P3)
    console.log('Editar', pelicula);
  }
}