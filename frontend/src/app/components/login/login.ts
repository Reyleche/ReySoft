import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { catchError, firstValueFrom, of, timeout } from 'rxjs';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="login-container">
        <div class="login-card glass-effect">
            
            <div class="header-section">
              <img src="assets/coco.jpg" alt="Logo" class="logo-img" 
                     onerror="this.style.display='none'"> 
                <h1 class="titulo">Sistema ReySoft</h1>
                <h1 class="subtitulo">Coco & Caña edition</h1>
            </div>

            <div *ngIf="cargando" class="loading-state">
                <div class="spinner"></div>
                <p>Conectando con el sistema...</p>
            </div>

            <div *ngIf="!cargando && usuarios.length === 0" class="error-state fade-in">
                <p>No se encontró el servidor.</p>

                <div class="server-box">
                  <label class="server-label">Servidor (IP de la laptop)</label>
                  <input class="server-input" [(ngModel)]="serverInput" placeholder="http://192.168.1.50:3000" />
                  <div class="server-actions">
                    <button (click)="guardarServidor()" class="btn-server">Guardar</button>
                    <button (click)="resetServidor()" class="btn-server btn-server-secondary">Local</button>
                  </div>
                  <div class="server-hint">Actual: {{ serverBase }}</div>
                </div>

                <button (click)="cargarUsuarios()" class="btn-retry">
                    🔄 Reintentar Conexión
                </button>
            </div>

            <div *ngIf="!cargando && usuarios.length > 0 && !usuarioSeleccionado" class="fade-in">
                <p class="subtitulo">Selecciona tu perfil:</p>
                
                <div class="grid-users">
                    <div *ngFor="let user of usuarios" class="card-user" (click)="seleccionarUsuario(user)">
                        <div class="icon-circle"><i class="pi pi-user"></i></div>
                        <h3>{{ user.nombre }}</h3>
                        <span class="user-role">{{ user.rol }}</span>
                    </div>
                </div>
            </div>

            <div *ngIf="usuarioSeleccionado" class="pin-container fade-in">
                <h2>Hola, {{ usuarioSeleccionado.nombre }}</h2>
                
                <div class="pin-dots">
                    <span [class.filled]="pin.length >= 1"></span>
                    <span [class.filled]="pin.length >= 2"></span>
                    <span [class.filled]="pin.length >= 3"></span>
                    <span [class.filled]="pin.length >= 4"></span>
                </div>
                
                <div class="numpad-modern">
                    <button (click)="addPin('1')">1</button>
                    <button (click)="addPin('2')">2</button>
                    <button (click)="addPin('3')">3</button>
                    <button (click)="addPin('4')">4</button>
                    <button (click)="addPin('5')">5</button>
                    <button (click)="addPin('6')">6</button>
                    <button (click)="addPin('7')">7</button>
                    <button (click)="addPin('8')">8</button>
                    <button (click)="addPin('9')">9</button>
                    <button class="btn-cancel" (click)="cancelar()">❌</button>
                    <button (click)="addPin('0')">0</button>
                    <button class="btn-go" (click)="ingresar()">✔️</button>
                </div>
                <p class="error-msg" *ngIf="error">{{ error }}</p>
            </div>

        </div>
    </div>
  `,
  styles: [`
    /* FONDO Y CONTENEDOR PRINCIPAL */
    .login-container { 
        display: flex; justify-content: center; align-items: center; 
        height: 100vh; width: 100vw; 
        background: radial-gradient(circle at center, #141e30, #243b55); 
        color: white; font-family: 'Segoe UI', sans-serif; 
    }
    
    /* TARJETA CENTRAL (Glassmorphism) */
    .login-card { 
        background: rgba(255,255,255,0.05); backdrop-filter: blur(15px); 
        padding: 40px; border-radius: 20px; width: 380px; text-align: center; 
        border: 1px solid rgba(255,255,255,0.1); 
        box-shadow: 0 15px 35px rgba(0,0,0,0.5); 
    }
    
    /* LOGO Y TITULOS */
    .header-section {
      display: flex; flex-direction: column; align-items: center; justify-content: center;
      margin-bottom: 10px;
    }
    .logo-img { 
        width: 100px; height: 100px; border-radius: 50%; margin-bottom: 15px; 
        border: 3px solid rgba(255,255,255,0.2); object-fit: cover; background: white; 
    }
    .titulo { margin: 0 0 20px 0; font-weight: 300; letter-spacing: 2px; font-size: 1.8rem; }
    .subtitulo { opacity: 0.7; margin-bottom: 20px; font-size: 0.9rem; }

    /* ESTADO DE ERROR Y REINTENTO */
    .error-state p { color: #e74c3c; font-weight: bold; margin-bottom: 10px; }

    .server-box {
      text-align: left;
      background: rgba(255,255,255,0.05);
      border: 1px solid rgba(255,255,255,0.12);
      border-radius: 12px;
      padding: 12px;
      margin: 12px 0;
    }
    .server-label { display: block; font-size: 0.8rem; opacity: 0.85; margin-bottom: 6px; }
    .server-input {
      width: 100%;
      padding: 10px 12px;
      border-radius: 10px;
      border: 1px solid rgba(255,255,255,0.15);
      background: rgba(0,0,0,0.2);
      color: #fff;
      outline: none;
    }
    .server-actions { display: flex; gap: 10px; margin-top: 10px; }
    .btn-server {
      flex: 1;
      border: none;
      padding: 10px 12px;
      color: white;
      border-radius: 10px;
      cursor: pointer;
      background: rgba(46,204,113,0.35);
    }
    .btn-server-secondary { background: rgba(255,255,255,0.15); }
    .server-hint { margin-top: 8px; font-size: 0.75rem; opacity: 0.7; }

    .btn-retry { 
        background: #e67e22; border: none; padding: 12px 30px; 
        color: white; border-radius: 50px; cursor: pointer; 
        font-size: 1rem; transition: 0.2s; 
    }
    .btn-retry:hover { background: #d35400; transform: scale(1.05); }

    /* ANIMACION DE CARGA (Spinner) */
    .spinner { 
        margin: 20px auto; width: 40px; height: 40px; 
        border: 4px solid rgba(255,255,255,0.1); border-radius: 50%; 
        border-top: 4px solid #2ecc71; animation: spin 0.8s linear infinite; 
    }
    @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

    /* GRID DE USUARIOS */
    .grid-users { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
    .card-user { 
        background: rgba(255,255,255,0.05); padding: 20px; border-radius: 15px; 
        cursor: pointer; transition: 0.2s; border: 1px solid transparent; 
    }
    .card-user:hover { 
        background: rgba(255,255,255,0.2); border-color: #2ecc71; transform: translateY(-5px); 
    }
    .icon-circle { font-size: 1.5rem; margin-bottom: 5px; }
    .user-role { 
        font-size: 0.65rem; background: #2ecc71; color: #fff; 
        padding: 3px 8px; border-radius: 10px; text-transform: uppercase; letter-spacing: 1px; 
    }

    /* PIN Y TECLADO */
    .pin-dots { display: flex; justify-content: center; gap: 12px; margin: 20px 0; height: 15px; }
    .pin-dots span { width: 12px; height: 12px; border-radius: 50%; border: 2px solid rgba(255,255,255,0.3); transition: 0.2s; }
    .pin-dots span.filled { background: #2ecc71; border-color: #2ecc71; box-shadow: 0 0 10px #2ecc71; }

    .numpad-modern { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; width: 240px; margin: 0 auto; }
    .numpad-modern button { 
        height: 65px; width: 65px; border-radius: 50%; border: none; 
        background: rgba(255,255,255,0.1); color: white; font-size: 1.4rem; 
        cursor: pointer; transition: 0.1s; 
    }
    .numpad-modern button:active { background: white; color: black; transform: scale(0.9); }
    .btn-cancel { background: rgba(231,76,60,0.4) !important; }
    .btn-go { background: rgba(46,204,113,0.4) !important; }

    .fade-in { animation: fadeIn 0.4s ease-out; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
  `]
})
export class LoginComponent implements OnInit {
  usuarios: any[] = [];
  usuarioSeleccionado: any = null;
  pin: string = '';
  error: string = '';
  cargando: boolean = true; // Inicia cargando automáticamente
  serverBase: string = '';
  serverInput: string = '';

  constructor(
    private api: ApiService,
    private router: Router,
    private route: ActivatedRoute,
    private cdr: ChangeDetectorRef,
    private auth: AuthService
  ) {}

  async ngOnInit() {
    this.serverBase = this.api.getServerBase();
    this.serverInput = this.serverBase;
    const reason = this.route.snapshot.queryParamMap.get('reason');
    if (reason === 'expired') {
      this.error = 'Sesión expirada. Inicia nuevamente.';
    }
    if (this.auth.isLoggedIn()) {
      this.auth.clearSession();
      this.error = 'Sesión cerrada por seguridad. Inicia nuevamente.';
    }
    await this.cargarUsuarios();
  }

  guardarServidor() {
    this.api.setServerBase(this.serverInput);
    this.serverBase = this.api.getServerBase();
    this.usuarioSeleccionado = null;
    this.pin = '';
    this.cargarUsuarios();
  }

  resetServidor() {
    this.serverInput = 'http://localhost:3000';
    this.guardarServidor();
  }

  async cargarUsuarios() {
    this.cargando = true;
    this.usuarios = [];
    this.error = '';

    const killSwitch = setTimeout(() => {
      if (this.cargando) {
        console.warn('⚠️ Tiempo de espera agotado (frontend).');
        this.cargando = false;
        this.cdr.detectChanges();
      }
    }, 6000);

    try {
      const data = await firstValueFrom(
        this.api.getUsuarios().pipe(
          timeout(5000),
          catchError((e) => {
            console.error('Error de conexión:', e);
            return of([]);
          })
        )
      );
      this.usuarios = Array.isArray(data) ? data : [];
      this.cdr.detectChanges();
    } finally {
      this.cargando = false;
      clearTimeout(killSwitch);
      this.cdr.detectChanges();
    }
  }

  seleccionarUsuario(user: any) {
    this.usuarioSeleccionado = user;
    this.pin = '';
  }

  addPin(num: string) {
    if (this.pin.length < 4) this.pin += num;
  }

  ingresar() {
    if (!this.usuarioSeleccionado) return;
    const id = this.usuarioSeleccionado.id ?? this.usuarioSeleccionado.id_usuario;
    const pin = (this.pin || '').trim();
    if (!id || pin.length === 0) {
      this.error = 'Credenciales inválidas';
      return;
    }
    this.api.login(id, pin, this.usuarioSeleccionado?.nombre).subscribe({
      next: (res: any) => {
        if (res.success) {
          if (res.token) {
            this.auth.setSession(res.token, res.usuario);
          } else {
            this.auth.clearSession();
            this.error = 'No se recibió token. Intenta de nuevo.';
            this.pin = '';
            return;
          }
          this.router.navigate(['/dashboard']);
        } else {
            this.error = 'PIN Incorrecto';
            this.pin = '';
            // Borrar error después de 2 segs
            setTimeout(() => this.error = '', 2000);
        }
      },
      error: () => {
        this.error = 'Error de conexión';
        this.pin = '';
      }
    });
  }

  cancelar() {
    this.usuarioSeleccionado = null;
    this.pin = '';
    this.error = '';
  }
}