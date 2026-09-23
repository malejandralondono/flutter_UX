import { Component, input, output } from '@angular/core';
import { Cine } from '../../../../core/models/cine.model';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';

@Component({
  selector: 'app-tabla-cines',
  standalone: true,
  imports: [BotonComponent],
  templateUrl: './tabla-cines.component.html',
  styleUrls: ['./tabla-cines.component.css']
})
export class TablaCinesComponent {

  cines = input.required<Cine[]>();
  editar = output<Cine>();

}
