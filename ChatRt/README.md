# Proyecto Microservicios (Día 1)

Estructura base para el proyecto con:

- API Gateway (Express, configuración de rutas)
- Servicios: Auth y Chat (cada uno con su propio server.js, modelos, controladores, etc.)
- Configurado para usar Docker y contenedores más adelante.

## Estructura de carpetas

- `api-gateway/`
- `services/`
  - `auth-service/`
  - `chat-service/`

## Pasos iniciales

1. Instalar dependencias en cada servicio (`auth-service`, `chat-service`) y en el `api-gateway`.
2. Definir variables de entorno en cada `.env`.
3. Más adelante, se agregará Docker, NGINX, RabbitMQ, etc.

