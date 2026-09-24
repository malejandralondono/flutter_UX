import { Component, OnInit, inject, input, output } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Pelicula, PeliculaFormulario } from '../../../../core/models/pelicula.model';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';
import { SeccionFormularioComponent } from '../../../../shared/components/seccion-formulario/seccion-formulario.component';

@Component({
  selector: 'app-formulario-pelicula',
  standalone: true,
  imports: [ReactiveFormsModule, BotonComponent, SeccionFormularioComponent],
  templateUrl: './formulario-pelicula.component.html',
  styleUrl: './formulario-pelicula.component.css',
})
export class FormularioPeliculaComponent implements OnInit {
  private fb = inject(FormBuilder);

  pelicula = input<Pelicula>();
  textoBoton = input('Guardar película');

  guardar = output<PeliculaFormulario>();
  cancelar = output<void>();

  form = this.fb.nonNullable.group({
    titulo: ['', [Validators.required, Validators.maxLength(100)]],
    fechaEstreno: ['', Validators.required],
    sinopsis: ['', Validators.maxLength(1000)],
    trailerUrl: ['', Validators.pattern(/^https?:\/\/.+/)],
  });

  get titulo() { return this.form.controls.titulo; }
  get fechaEstreno() { return this.form.controls.fechaEstreno; }
  get trailerUrl() { return this.form.controls.trailerUrl; }

  ngOnInit() {
    const pelicula = this.pelicula();
    if (pelicula) {
      this.form.patchValue({
        titulo: pelicula.titulo,
        fechaEstreno: pelicula.fechaEstreno,
        sinopsis: pelicula.sinopsis ?? '',
        trailerUrl: pelicula.trailerUrl ?? '',
      });
    }
  }

  enviar() {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const valores = this.form.getRawValue();
    this.guardar.emit({
      titulo: valores.titulo.trim(),
      fechaEstreno: valores.fechaEstreno,
      sinopsis: valores.sinopsis.trim(),
      trailerUrl: valores.trailerUrl || undefined,
    });
  }
}