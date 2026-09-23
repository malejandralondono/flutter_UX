import { Component, computed, inject } from '@angular/core';
import { Router } from '@angular/router';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';
import { CineService } from '../../../../core/services/cine.service';
import { Cine } from '../../../../core/models/cine.model';
import { TablaCinesComponent } from '../tabla-cines/tabla-cines.component';


@Component({
  selector: 'app-lista-cines',
  standalone: true,
  imports: [ BotonComponent, TablaCinesComponent ],
  templateUrl: './lista-cines.component.html',
  styleUrl: './lista-cines.component.css'
})
export class ListaCinesComponent {
  private cineService = inject(CineService);
  private router = inject(Router);

  cines = this.cineService.cines;
  total = computed(() => this.cines().length);
  nuevoCine() {
    this.router.navigate(['/cines', 'nuevo']);
  }
editarCine(cine: Cine) {
  this.router.navigate(['/cines', cine.id, 'editar']);
}
}
