# Casino Frontend — Experiencia DevOps Introducción

**Frontend SPA Angular 17 de Casino Online**  
*Introducción a Herramientas DevOps (ISY1101) — Experiencia 2*

> Aplicación web profesional dockerizada con arquitectura moderna, autenticación JWT, componentes standalone, animaciones avanzadas (Three.js + GSAP) y reverse proxy Nginx. Diseñada para despliegue en EC2 con integración CI/CD.

---

## 📋 Tabla de Contenidos

1. [Descripción General](#descripción-general)
2. [Stack Tecnológico](#stack-tecnológico)
3. [Estructura del Proyecto](#estructura-del-proyecto)
4. [Arquitectura de Software](#arquitectura-de-software)
5. [Variables de Entorno](#variables-de-entorno)
6. [Componentes y Rutas](#componentes-y-rutas)
7. [Servicios Core](#servicios-core)
8. [Ejecución Local](#ejecución-local)
9. [Build de Producción](#build-de-producción)
10. [Docker y Containerización](#docker-y-containerización)
11. [Configuración Nginx](#configuración-nginx)
12. [Conceptos DevOps](#conceptos-devops)
13. [Checklist de Validación](#checklist-de-validación)
14. [Troubleshooting](#troubleshooting)
15. [Comandos Útiles](#comandos-útiles)
16. [Notas de Arquitectura](#notas-de-arquitectura)

---

## Descripción General

### Propósito Académico

Este proyecto es una **Experiencia de Aprendizaje en DevOps** que integra:

- **Desarrollo Frontend moderno** (Angular 17, TypeScript 5.4)
- **Containerización** (Docker multi-stage, imagen optimizada)
- **Orquestación** (Docker Compose para desarrollo)
- **Reverse Proxy** (Nginx con caché y reescritura de rutas SPA)
- **Autenticación y seguridad** (JWT, CORS, headers de seguridad)
- **Animaciones profesionales** (Three.js para WebGL, GSAP para motion graphics)
- **Principios 12-Factor App** (variables de entorno, procesos sin estado)

### Contexto de Negocio

Casino Online completo donde usuarios pueden:

- **Registrarse y autenticarse** (seguridad con JWT)
- **Jugar al menos 3 juegos**: Slots, Ruleta, Blackjack
- **Gestionar saldo** (depósitos, retiros, transacciones)
- **Ver historial** de movimientos
- **Visualizar perfil** con estadísticas personales
- **Experiencia visual inmersiva** (animaciones 3D, efectos visuales)

---

## Stack Tecnológico

### Tabla de Tecnologías

| Capa | Componente | Versión | Descripción |
|------|-----------|---------|-------------|
| **Frontend Framework** | Angular | 17.3.0 | Framework component-based, standalone architecture |
| **Lenguaje** | TypeScript | 5.4.2 | Tipado estático, mejor mantenibilidad |
| **Build Tool** | Angular CLI / Vite + esbuild | 17.3.0 | Compilación optimizada, code splitting automático |
| **Routing** | @angular/router | 17.3.0 | SPA routing con lazy loading, route guards |
| **State Management** | Angular Signals | 17.3.0 | Reactividad moderna sin RxJS boilerplate |
| **HTTP Client** | @angular/common/http | 17.3.0 | Interceptores, manejo de errores |
| **Formularios** | @angular/forms | 17.3.0 | Validación, binding reactivo |
| **Animaciones 3D** | Three.js | 0.184.0 | WebGL, renderizado 3D en canvas |
| **Animaciones 2D** | GSAP | 3.15.0 | Motion graphics, timelines, easing |
| **CSS** | Nativo CSS3 | - | Design system personalizado (sin frameworks) |
| **Web Server** | Nginx | alpine | Reverse proxy, caché, SPA fallback |
| **Containerización** | Docker | 20+ | Imágenes multi-stage, optimización |
| **Build** | Docker Compose | 1.29+ | Orquestación local (dev + database) |

### Dependencias NPM Principales

```json
{
  "dependencies": {
    "@angular/animations": "^17.3.0",
    "@angular/common": "^17.3.0",
    "@angular/compiler": "^17.3.0",
    "@angular/core": "^17.3.0",
    "@angular/forms": "^17.3.0",
    "@angular/platform-browser": "^17.3.0",
    "@angular/platform-browser-dynamic": "^17.3.0",
    "@angular/router": "^17.3.0",
    "@types/three": "^0.184.1",
    "gsap": "^3.15.0",
    "rxjs": "~7.8.0",
    "three": "^0.184.0",
    "tslib": "^2.3.0",
    "zone.js": "~0.14.3"
  }
}
```

---

## Estructura del Proyecto

### Árbol de Directorios Completo

```
casino-frontend/
│
├── 📄 package.json                      ← Manifesto NPM (scripts, dependencias)
├── 📄 package-lock.json                 ← Lock file (reproducibilidad)
├── 📄 tsconfig.json                     ← Configuración TypeScript raíz
├── 📄 tsconfig.app.json                 ← Config TS para aplicación
├── 📄 angular.json                      ← Configuración Angular CLI
├── 📄 .gitignore                        ← Archivos a ignorar en Git
│
├── 📄 Dockerfile                        ← Multi-stage build: builder + runtime
├── 📄 nginx.conf                        ← Configuración Nginx (reverse proxy)
│
├── 📄 README.md                         ← Este archivo
│
├── 📁 src/                              ← Código fuente TypeScript
│   │
│   ├── 📄 index.html                    ← Punto de entrada HTML
│   ├── 📄 main.ts                       ← Bootstrap standalone
│   ├── 📄 styles.css                    ← Estilos globales
│   │
│   ├── 📁 environments/                 ← Configuración por entorno
│   │   ├── environment.ts               ← Desarrollo (apiBaseUrl = localhost:3000)
│   │   └── environment.prod.ts          ← Producción (apiBaseUrl = '')
│   │
│   └── 📁 app/                          ← Código de la aplicación
│       ├── 📄 app.component.ts          ← Componente raíz (shell)
│       ├── 📄 app.routes.ts             ← Definición de rutas lazy-loaded
│       ├── 📁 models/
│       │   └── casino.models.ts         ← Interfaces TypeScript
│       ├── 📁 services/
│       │   ├── auth.service.ts          ← Autenticación y sesión
│       │   └── casino.service.ts        ← API del casino
│       ├── 📁 interceptors/
│       │   └── auth.interceptor.ts      ← Adjunta JWT a requests
│       ├── 📁 guards/
│       │   └── auth.guard.ts            ← Protección de rutas
│       ├── 📁 utils/
│       │   └── particles.ts             ← Generador de partículas
│       └── 📁 components/               ← Componentes visuales
│           ├── three-background/
│           ├── header/
│           ├── login/  register/
│           ├── lobby/
│           ├── slots/ roulette/ blackjack/
│           ├── profile/
│           └── history/
│
├── 📁 dist/                             ← Salida de build (GENERADA)
│   └── casino-frontend/browser/         ← Archivos servidos por Nginx
│
└── 📁 node_modules/                     ← Dependencias NPM (GENERADAS)
```

---

## Arquitectura de Software

### Patrones Aplicados

#### 1. **Standalone Components (Angular 17+)**

```typescript
@Component({
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule]
})
export class LoginComponent { }
```

**Beneficios:** Menor boilerplate, tree-shaking más efectivo, bundle más pequeño.

#### 2. **Angular Signals (State Management)**

```typescript
private _usuario = signal<Usuario | null>(null);
public usuario = this._usuario.asReadonly();
```

Reactividad moderna sin RxJS boilerplate.

#### 3. **Lazy Loading de Rutas**

```typescript
{ path: 'slots', loadComponent: () => import('./slots.component').then(m => m.SlotsComponent) }
```

Cada componente se descarga como chunk separado.

#### 4. **Route Guards (Protección de Autenticación)**

```typescript
export const authGuard: CanActivateFn = (route, state) => {
  const auth = inject(AuthService);
  return auth.autenticado() ? true : inject(Router).navigate(['/login']) || false;
};
```

Protege rutas privadas (`/lobby`, `/slots`, etc.).

#### 5. **HTTP Interceptor (Autenticación Automática)**

```typescript
// Cada request HTTP sale con JWT
Authorization: Bearer <token>
```

#### 6. **SPA Fallback (Nginx)**

```nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

Si usuario recarga en `/slots`, Nginx devuelve `index.html` y Angular Router toma control.

#### 7. **Environment Switching**

```typescript
// environment.ts: apiBaseUrl = 'http://localhost:3000'
// environment.prod.ts: apiBaseUrl = ''  (reverse proxy)
```

---

## Variables de Entorno

### Tabla de Configuración

| Entorno | Archivo | apiBaseUrl | Comportamiento |
|---------|---------|------------|-----------------|
| **Desarrollo** | `environment.ts` | `http://localhost:3000` | Requests directas al backend |
| **Producción** | `environment.prod.ts` | `''` (vacío) | Requests relativas via Nginx |

---

## Componentes y Rutas

### Tabla de Rutas

| Ruta | Componente | Auth Requerido | Lazy Loading | Descripción |
|------|-----------|---|---|-------------|
| `/` | — | No | — | Redirige a `/lobby` |
| `/login` | LoginComponent | No | Sí | Formulario login |
| `/register` | RegisterComponent | No | Sí | Formulario registro |
| `/lobby` | LobbyComponent | **Sí** | Sí | Catálogo de juegos |
| `/slots` | SlotsComponent | **Sí** | Sí | Tragamonedas |
| `/roulette` | RouletteComponent | **Sí** | Sí | Ruleta europea |
| `/blackjack` | BlackjackComponent | **Sí** | Sí | Blackjack |
| `/profile` | ProfileComponent | **Sí** | Sí | Perfil usuario |
| `/history` | HistoryComponent | **Sí** | Sí | Historial |
| `**` (catch-all) | — | — | — | Redirige a `/lobby` |

---

## Servicios Core

### AuthService

Gestiona autenticación, sesión y JWT.

```typescript
readonly usuario = this._usuario.asReadonly();
readonly token = this._token.asReadonly();
readonly autenticado = computed(() => !!this._token());

registrar(datos): Observable<RespuestaAuth>
login(username, password): Observable<RespuestaAuth>
logout(): void
```

**Persistencia:** Token en `localStorage` bajo clave `casino.session`.

### CasinoService

Llamadas HTTP al backend.

```typescript
listarJuegos(): Observable<Juego[]>
miPerfil(): Observable<Usuario>
depositar(monto): Observable<{ saldo }>
historial(limit): Observable<Transaccion[]>
jugarSlots(apuesta): Observable<ResultadoSlots>
jugarRuleta(apuesta): Observable<ResultadoRuleta>
jugarBlackjack(accion): Observable<EstadoBlackjack>
```

---

## Ejecución Local

### Requisitos Previos

```bash
node --version      # v20.x LTS
npm --version       # 10.x
docker --version    # 20.x
docker-compose --version  # 1.29+
```

### Instalación y Ejecución

```bash
# Instalar dependencias
npm install

# Modo desarrollo (sin Docker)
npm start          # http://localhost:4200

# Build de producción
npm run build      # dist/casino-frontend/browser/
```

---

## Build de Producción

### Compilación Optimizada

```bash
npm run build
# Genera: dist/casino-frontend/browser/
# Contiene: index.html, main.js (minificado), estilos CSS
```

**Optimizaciones:**
- Minificación JS/CSS
- Hash en nombres de archivo (cache busting)
- AOT compilation
- Sin source maps en producción
- Lazy loading por componente

---

## Docker y Containerización

### Dockerfile Multi-Stage

**Stage 1 (Builder):** Node.js 20 Alpine — compila la SPA

**Stage 2 (Runtime):** Nginx Alpine — sirve archivos estáticos

```dockerfile
# Stage 1: Compilación
FROM node:20-alpine AS builder
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Ejecución
FROM nginxinc/nginx-unprivileged:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/casino-frontend/browser /usr/share/nginx/html
EXPOSE 8080
```

**Ventajas:**
- Imagen final ~50 MB (vs. 1.5 GB sin multi-stage)
- Sin `node_modules` en producción
- Usuario no-root (seguridad)
- Imagen base Alpine mínima (5 MB)

### Construcción y Ejecución

```bash
# Build
docker build -t casino-frontend:latest .

# Run
docker run -p 8080:8080 casino-frontend:latest

# Acceso
http://localhost:8080
```

---

## Configuración Nginx

### nginx.conf (Reverse Proxy + SPA Fallback)

```nginx
server {
    listen 8080;
    root /usr/share/nginx/html;
    index index.html;

    # Reverse proxy: /api/* → Backend:3000
    location /api/ {
        proxy_pass http://backend:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # SPA fallback
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Caché static assets
    location ~* \.(js|css|png|jpg|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

**Funciones:**
1. **SPA Fallback:** Redirige rutas desconocidas a `index.html`
2. **Reverse Proxy:** Reenvía `/api/` al backend
3. **Caché:** Assets con hash nunca cambian (cache agresivo)

---

## Conceptos DevOps

### 12-Factor App

| Factor | Implementación |
|--------|---|
| **Codebase** | Git repo único |
| **Dependencies** | package.json + npm ci |
| **Config** | environment.ts (por entorno) |
| **Backing Services** | Backend + DB como servicios |
| **Build/Run/Dev** | Separación clara |
| **Processes** | Sin estado local |
| **Port Binding** | Nginx:8080 self-contained |
| **Concurrency** | Nginx multi-worker |
| **Disposability** | Docker container rápido |
| **Dev/Prod Parity** | environment.prod.ts |
| **Logs** | stdout (docker logs) |
| **Admin Tasks** | CLI tools |

### Stateless Architecture

- AuthService no guarda estado en memoria
- localStorage (cliente) o backend (servidor)
- Contenedor puede replicarse sin sincronización

### Health Checks

```bash
curl http://localhost:8080
# Retorna: 200 OK + HTML
```

---

## Checklist de Validación

### ✅ Build

```bash
npm run build
ls -lah dist/casino-frontend/browser/
du -sh dist/casino-frontend/browser/  # < 1 MB
```

### ✅ Docker

```bash
docker build -t casino-frontend:1.0 .
docker run -p 8080:8080 --name test casino-frontend:1.0
curl http://localhost:8080
docker exec test whoami  # nginx
docker stop test && docker rm test
```

### ✅ Nginx Reverse Proxy

```bash
# Requests estáticas
curl http://localhost:8080/

# Reverse proxy
curl http://localhost:8080/api/juegos

# SPA fallback
curl http://localhost:8080/slots
# Retorna: index.html
```

### ✅ Autenticación

```bash
# Register, Login, JWT en localStorage
# Header Authorization: Bearer <token>
```

### ✅ Lazy Loading

En DevTools > Network:
- Initial: main.js (100 KB)
- On /slots: slots.component.js (20 KB)
- On /roulette: roulette.component.js (15 KB)

---

## Troubleshooting

| Error | Solución |
|-------|----------|
| `npm ERR! code ERESOLVE` | `npm install --legacy-peer-deps` |
| `Port 4200 already in use` | `ng serve --port 4201` |
| `CORS error` | Usar reverse proxy Nginx |
| `404 on page reload` | Verificar `try_files` en Nginx |
| `docker: not found` | Instalar Docker |
| `Cannot find module X` | `npm ci` |
| `Nginx 502 Bad Gateway` | Backend no accesible |

---

## Comandos Útiles

### Desarrollo

```bash
npm install          # Instalar dependencias
npm start            # Dev server :4200
npm run build        # Build producción
npm run watch        # Watch mode
```

### Docker

```bash
docker build -t casino-frontend .
docker run -p 8080:8080 casino-frontend
docker logs -f casino-frontend
docker exec -it casino-frontend sh
```

### Docker Compose

```bash
docker-compose up           # Start all services
docker-compose down         # Stop
docker-compose down -v      # Stop + clean volumes
docker-compose logs -f      # Follow logs
```

### Git

```bash
git checkout -b feature/readme
git add .
git commit -m "docs: Casino Frontend comprehensive README"
git push origin feature/readme
git checkout dev && git merge feature/readme
git push origin dev
```

---

## Notas de Arquitectura

### Comunicación Frontend-Backend

```
Componente → CasinoService → AuthInterceptor 
  → Nginx Reverse Proxy → Backend:3000 → PostgreSQL
```

### Escalabilidad Horizontal

```
Multiple Frontend Instances → Nginx Load Balancer → Backend
```

En Docker Swarm: `docker service scale casino-frontend=3`

### Seguridad

- JWT en localStorage (riesgo XSS en producción real)
- En prod: usar httpOnly cookie
- HTTPS/TLS con certificados
- CORS manejado por reverse proxy
- Usuario no-root en Docker

---

## Próximos Pasos (EP2)

- [ ] GitHub Actions workflow (build + push + deploy)
- [ ] Deploy automático a AWS EC2
- [ ] HTTPS con Let's Encrypt
- [ ] Monitoring y logging centralizado

---

## Referencias

- [Angular 17 Docs](https://angular.io/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [12 Factor App](https://12factor.net/)

---

> Documentación actualizada: 17 de mayo de 2026  
> Versión: 2.0.0 — Comprehensive Professional Documentation
