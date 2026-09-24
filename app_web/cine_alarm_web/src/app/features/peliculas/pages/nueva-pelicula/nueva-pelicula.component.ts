import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { PeliculaService } from '../../../../core/services/pelicula.service';
import { PeliculaFormulario } from '../../../../core/models/pelicula.model';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';
import { FormularioPeliculaComponent } from '../../components/formulario-pelicula/formulario-pelicula.component';

@Component({
  selector: 'app-nueva-pelicula',
  standalone: true,
  imports: [BotonComponent, FormularioPeliculaComponent],
  templateUrl: './nueva-pelicula.component.html',
  styleUrl: './nueva-pelicula.component.css',
})
export class NuevaPeliculaComponent {
  private router = inject(Router);
  private peliculaService = inject(PeliculaService);

  guardar(datos: PeliculaFormulario) {
    this.peliculaService.agregar(datos);
    this.volver();
  }

  volver() {
    this.router.navigate(['/peliculas']);
  }
}