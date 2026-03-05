import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  template: '<router-outlet></router-outlet>', // Esto es vital para ver las pantallas
  styles: []
})
export class AppComponent {
  title = 'frontend';
}