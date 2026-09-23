import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ListaCinesComponent } from './lista-cines.component';

describe('ListaCinesComponent', () => {
  let component: ListaCinesComponent;
  let fixture: ComponentFixture<ListaCinesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ListaCinesComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ListaCinesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
