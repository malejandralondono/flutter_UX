import { Component, OnInit, inject, input, output, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Pelicula, PeliculaFormulario } from '../../../../core/models/pelicula.model';
import { BotonComponent } from '../../../../shared/components/boton/boton.component';
import { SeccionFormularioComponent } from '../../../../shared/components/seccion-formulario/seccion-formulario.component';

const TAMANO_MAXIMO_POSTER = 2 * 1024 * 1024; // 2 MB

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

  errorPoster = signal<string | null>(null);

  form = this.fb.nonNullable.group({
    titulo: ['', [Validators.required, Validators.maxLength(100)]],
    fechaEstreno: ['', Validators.required],
    sinopsis: ['', Validators.maxLength(1000)],
    trailerUrl: ['', Validators.pattern(/^https?:\/\/.+/)],
    posterUrl: [''],
  });

  get titulo() { return this.form.controls.titulo; }
  get fechaEstreno() { return this.form.controls.fechaEstreno; }
  get trailerUrl() { return this.form.controls.trailerUrl; }
  get poster() { return this.form.controls.posterUrl; }

  ngOnInit() {
    const pelicula = this.pelicula();
    if (pelicula) {
      this.form.patchValue({
        titulo: pelicula.titulo,
        fechaEstreno: pelicula.fechaEstreno,
        sinopsis: pelicula.sinopsis ?? '',
        trailerUrl: pelicula.trailerUrl ?? '',
        posterUrl: pelicula.posterUrl ?? '',
      });
    }
  }

  alSeleccionarPoster(event: Event) {
    const input = event.target as HTMLInputElement;
    const archivo = input.files?.[0];
    input.value = ''; // permite volver a elegir el mismo archivo
    if (!archivo) return;

    if (!archivo.type.startsWith('image/')) {
      this.errorPoster.set('El archivo debe ser una imagen.');
      return;
    }
    if (archivo.size > TAMANO_MAXIMO_POSTER) {
      this.errorPoster.set('La imagen no puede pesar más de 2 MB.');
      return;
    }

    const lector = new FileReader();
    lector.onload = () => {
      this.poster.setValue(lector.result as string);
      this.poster.markAsDirty();
      this.errorPoster.set(null);
    };
    lector.onerror = () => this.errorPoster.set('No se pudo leer la imagen. Intenta con otra.');
    lector.readAsDataURL(archivo);
  }

  quitarPoster() {
    this.poster.setValue('');
    this.poster.markAsDirty();
    this.errorPoster.set(null);
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
      posterUrl: valores.posterUrl || undefined,
    });
  }
}