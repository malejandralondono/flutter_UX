import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TablaPeliculasComponent } from './tabla-peliculas.component';

describe('TablaPeliculasComponent', () => {
  let component: TablaPeliculasComponent;
  let fixture: ComponentFixture<TablaPeliculasComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TablaPeliculasComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TablaPeliculasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
