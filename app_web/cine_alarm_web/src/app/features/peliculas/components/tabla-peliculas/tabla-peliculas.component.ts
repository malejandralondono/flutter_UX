import { Component, input, output } from '@angular/core';
import { DatePipe } from '@angular/common';
import { Pelicula } from '../../../../core/models/pelicula.model';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';

@Component({
  selector: 'app-tabla-peliculas',
  standalone: true,
  imports: [DatePipe, BotonComponent],
  templateUrl: './tabla-peliculas.component.html',
  styleUrl: './tabla-peliculas.component.css',
})
export class TablaPeliculasComponent {
  peliculas = input.required<Pelicula[]>();
  editar = output<Pelicula>();
}