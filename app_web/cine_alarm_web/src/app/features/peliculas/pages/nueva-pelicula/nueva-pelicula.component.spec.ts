import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NuevaPeliculaComponent } from './nueva-pelicula.component';

describe('NuevaPeliculaComponent', () => {
  let component: NuevaPeliculaComponent;
  let fixture: ComponentFixture<NuevaPeliculaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NuevaPeliculaComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(NuevaPeliculaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
