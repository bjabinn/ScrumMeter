
import { fakeAsync, ComponentFixture, TestBed } from '@angular/core/testing';

import { SortedTableExampleComponent } from './sorted-table-example.component';

describe('SortedTableExampleComponent', () => {
  let component: SortedTableExampleComponent;
  let fixture: ComponentFixture<SortedTableExampleComponent>;

  beforeEach(fakeAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ SortedTableExampleComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SortedTableExampleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should compile', () => {
    expect(component).toBeTruthy();
  });
});
