import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { PeliculaService } from '../../../../core/services/pelicula.service';
import { Pelicula, PeliculaFormulario } from '../../../../core/models/pelicula.model';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';
import { FormularioPeliculaComponent } from '../../components/formulario-pelicula/formulario-pelicula.component';

@Component({
  selector: 'app-editar-pelicula',
  standalone: true,
  imports: [BotonComponent, FormularioPeliculaComponent],
  templateUrl: './editar-pelicula.component.html',
  styleUrl: './editar-pelicula.component.css',
})
export class EditarPeliculaComponent implements OnInit {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private peliculaService = inject(PeliculaService);

  pelicula?: Pelicula;

  ngOnInit() {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.pelicula = this.peliculaService.obtenerPorId(id);

    if (!this.pelicula) {
      this.volver();
    }
  }

  guardar(datos: PeliculaFormulario) {
    if (!this.pelicula) return;
    this.peliculaService.actualizar(this.pelicula.id, datos);
    this.volver();
  }

  volver() {
    this.router.navigate(['/peliculas']);
  }
}