import { Component, input } from '@angular/core';

@Component({
  selector: 'app-seccion-formulario',
  standalone: true,
  templateUrl: './seccion-formulario.component.html',
  styleUrl: './seccion-formulario.component.css',
})
export class SeccionFormularioComponent {
  titulo = input.required<string>();
}