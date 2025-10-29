# Casa Andina (estructura Node + SQL)

Este PR agrega una estructura Node+Express+EJS y mueve el script SQL a `scripts/db/casa_A.sql`.

## Base de datos
- Importa `scripts/db/casa_A.sql` en MySQL/MariaDB (BD: `bd_andina2`).

## Configuración
- Copia `.env.example` a `.env` y ajusta credenciales.
- Instala dependencias: `npm install`.
- Ejecuta en desarrollo: `npm run dev`.

## Estructura
- `controllers/`, `models/`, `routes/`, `views/`, `public/`, `config/`, `scripts/db/`.

## Nota
La app PHP existente permanece intacta; esta estructura permite evolucionar a Node sin romper lo actual.
