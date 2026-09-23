import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { CineService } from '../../../../core/services/cine.service';
import { PeliculaService } from '../../../../core/services/pelicula.service';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';
import { SeccionFormularioComponent } from '../../../../shared/components/seccion-formulario/seccion-formulario.component';

@Component({
  selector: 'app-nuevo-cine',
  standalone: true,
  imports: [ReactiveFormsModule, BotonComponent, SeccionFormularioComponent],
  templateUrl: './nuevo-cine.component.html',
  styleUrl: './nuevo-cine.component.css',
})
export class NuevoCineComponent {
  private fb = inject(FormBuilder);
  private router = inject(Router);
  private cineService = inject(CineService);
  private peliculaService = inject(PeliculaService);

  readonly formatosDisponibles = ['2D', '3D', 'IMAX', 'XD', '4DX', 'VIP'];
  readonly peliculas = this.peliculaService.peliculas;

  form = this.fb.nonNullable.group({
    nombre: ['', [Validators.required, Validators.maxLength(100)]],
    locacion: ['', [Validators.required, Validators.maxLength(150)]],
    formatos: this.fb.nonNullable.control<string[]>([], Validators.required),
    peliculas: this.fb.nonNullable.control<number[]>([]),
  });

  get nombre() { return this.form.controls.nombre; }
  get locacion() { return this.form.controls.locacion; }
  get formatos() { return this.form.controls.formatos; }

  // --- Formatos (checkboxes) ---
  formatoSeleccionado(formato: string): boolean {
    return this.formatos.value.includes(formato);
  }

  alternarFormato(formato: string) {
    const actuales = this.formatos.value;
    this.formatos.setValue(
      actuales.includes(formato)
        ? actuales.filter(f => f !== formato)
        : [...actuales, formato]
    );
    this.formatos.markAsTouched();
  }

  // --- Películas (checkboxes) ---
  peliculaSeleccionada(id: number): boolean {
    return this.form.controls.peliculas.value.includes(id);
  }

  alternarPelicula(id: number) {
    const control = this.form.controls.peliculas;
    const actuales = control.value;
    control.setValue(
      actuales.includes(id)
        ? actuales.filter(p => p !== id)
        : [...actuales, id]
    );
  }

  guardar() {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const valores = this.form.getRawValue();
    this.cineService.agregar(
      {
        nombre: valores.nombre.trim(),
        locacion: valores.locacion.trim(),
        formatos: valores.formatos.join(', '),
      },
      valores.peliculas
    );

    this.router.navigate(['/cines']);
  }

  volver() {
    this.router.navigate(['/cines']);
  }
}