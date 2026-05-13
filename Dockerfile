# ── Stage 1: builder ──────────────────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar manifiestos primero (mejor cache de capas)
COPY package*.json ./

# npm ci requiere package-lock.json — el frontend sí lo tiene
RUN npm ci

# Copiar el resto del código fuente
COPY . .

# Build de producción — Angular 17 genera en dist/casino-frontend/browser/
RUN npm run build

# ── Stage 2: runtime ──────────────────────────────────────────────────────────
# nginx-unprivileged: igual que nginx oficial pero corre en puerto 8080 sin root
FROM nginxinc/nginx-unprivileged:alpine AS runtime

# Copiar configuración de Nginx (reverse proxy + SPA fallback)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# IMPORTANTE: Angular 17 con application builder genera en browser/
# No apuntar a dist/casino-frontend — faltaría la subcarpeta browser/
COPY --from=builder /app/dist/casino-frontend/browser /usr/share/nginx/html

# nginx-unprivileged ya usa usuario nginx sin root — no hace falta USER
EXPOSE 8080