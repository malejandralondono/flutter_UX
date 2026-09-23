import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SeccionFormularioComponent } from './seccion-formulario.component';

describe('SeccionFormularioComponent', () => {
  let component: SeccionFormularioComponent;
  let fixture: ComponentFixture<SeccionFormularioComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SeccionFormularioComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SeccionFormularioComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
