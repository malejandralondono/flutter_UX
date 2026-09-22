import { Component, input } from '@angular/core';

@Component({
  selector: 'button[appBoton]',
  standalone: true,
  template: '<ng-content />',
  styleUrl: './boton.component.css',
  host: {
    '[class.pequeno]': "tamano() === 'pequeno'",
  },
})
export class BotonComponent {
  tamano = input<'normal' | 'pequeno'>('normal');
}