import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { PeliculaService } from '../../../../core/services/pelicula.service';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';
import { SeccionFormularioComponent } from '../../../../shared/components/seccion-formulario/seccion-formulario.component';

@Component({
  selector: 'app-nueva-pelicula',
  standalone: true,
  imports: [ReactiveFormsModule, BotonComponent, SeccionFormularioComponent],
  templateUrl: './nueva-pelicula.component.html',
  styleUrl: './nueva-pelicula.component.css',
})
export class NuevaPeliculaComponent {
  private fb = inject(FormBuilder);
  private router = inject(Router);
  private peliculaService = inject(PeliculaService);

  form = this.fb.nonNullable.group({
    titulo: ['', [Validators.required, Validators.maxLength(100)]],
    fechaEstreno: ['', Validators.required],
    sinopsis: ['', Validators.maxLength(1000)],
    trailerUrl: ['', Validators.pattern(/^https?:\/\/.+/)],
  });

  get titulo() { return this.form.controls.titulo; }
  get fechaEstreno() { return this.form.controls.fechaEstreno; }
  get trailerUrl() { return this.form.controls.trailerUrl; }

  guardar() {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const valores = this.form.getRawValue();
    this.peliculaService.agregar({
      titulo: valores.titulo.trim(),
      fechaEstreno: valores.fechaEstreno,
      sinopsis: valores.sinopsis.trim(),
      trailerUrl: valores.trailerUrl || undefined,
      cantidadCines: 0,
    });

    this.router.navigate(['/peliculas']);
  }

  volver() {
    this.router.navigate(['/peliculas']);
  }
}
