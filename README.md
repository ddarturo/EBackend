# EBackend - Capa 1 (Datos) & Capa 2 (Backend)

[![Backend CI](https://github.com/ddarturo/EBackend/actions/workflows/backend-ci.yml/badge.svg)](https://github.com/ddarturo/EBackend/actions/workflows/backend-ci.yml)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live%20Docs-blue)](https://ddarturo.github.io/EBackend/)

Repositorio del componente Backend y Capa de Datos del Sistema de Gestión y Catálogo de Productos.

---

## 🏛️ Estilo y Patrones Arquitectónicos

- **Estilos Arquitectónicos:** N-Capas, Cliente-Servidor y REST API.
- **Patrón Arquitectónico Backend:** MVC (Modelo - Vista/JSON - Controlador).
- **Patrones de Diseño Implementados:**
  - **Singleton:** Para la gestión de la conexión a PostgreSQL a través de Prisma ORM (`models/database/Database.js`).
  - **Repository:** Para la persistencia y operaciones CRUD sobre la entidad `Producto` (`models/repositories/ProductoRepository.js`).
  - **Factory:** Para la instanciación e inyección de dependencias entre capas (`models/factories/ProductoFactory.js`).

---

## 📂 Estructura del Repositorio

```text
EBackend/
├── capa1_datos/
│   ├── base_de_datos.sql                     # Script DDL + Generación de 10.000 productos
│   └── actualizar_imagenes_y_nombres.sql     # Script de actualización de imágenes y nombres reales
├── capa2_backend/
│   ├── controllers/
│   │   └── producto.controller.js            # Controlador con métodos GET, POST, PUT, PATCH, DELETE
│   ├── middlewares/
│   │   ├── cors.middleware.js                # Control de CORS
│   │   ├── errorHandler.middleware.js        # Manejador global de excepciones
│   │   ├── jsonVerify.middleware.js          # Verificación de sintaxis JSON
│   │   ├── pagination.middleware.js          # Cálculo y validación de paginación
│   │   ├── sanitize.middleware.js            # Sanitización de entradas (Anti-XSS e inyecciones)
│   │   ├── validation.middleware.js          # Validación de esquemas y tipos de datos
│   │   └── versioning.middleware.js          # Control de versionamiento (/api/v1)
│   ├── models/
│   │   ├── database/Database.js              # Patrón Singleton con PrismaClient
│   │   ├── entities/Producto.js              # Entidad de dominio Producto
│   │   ├── factories/ProductoFactory.js      # Factoría de comunicación entre capas
│   │   └── repositories/ProductoRepository.js# Patrón Repository con consultas Prisma
│   ├── prisma/
│   │   └── schema.prisma                     # Esquema declarativo de Prisma ORM
│   ├── routes/
│   │   ├── index.js                          # Agregador modular de rutas
│   │   └── producto.routes.js                # Definición de rutas REST para productos
│   ├── .env.example                          # Plantilla de variables de entorno seguras
│   ├── package.json                          # Dependencias y scripts
│   ├── server.js                             # Punto de entrada Express (Puerto 5050)
│   └── test_integration.js                   # Prueba automatizada de integración
├── .github/
│   └── workflows/
│       └── backend-ci.yml                    # Pipeline CI en GitHub Actions con PostgreSQL
├── ARQUITECTURA_BACKEND.md                   # Documento detallado de especificación de arquitectura
├── index.html                                # Portal web de documentación interactiva (GitHub Pages)
└── README.md                                 # Documentación general
```

---

## 🚀 Puesta en Marcha

### Requisitos
- Node.js >= 18.x
- PostgreSQL 16

### Pasos
```bash
# 1. Navegar a la carpeta del backend
cd capa2_backend

# 2. Configurar variables de entorno
cp .env.example .env
# Configura DATABASE_URL en .env

# 3. Instalar dependencias
npm install

# 4. Generar el cliente de Prisma
npx prisma generate

# 5. Ejecutar pruebas de integración
node test_integration.js

# 6. Iniciar el servidor
npm start
```

---

## 📡 Endpoints de la API REST (`http://localhost:5050/api/v1`)

| Método | Endpoint | Descripción | Código Éxito |
| :--- | :--- | :--- | :--- |
| `GET` | `/health` | Chequeo de estado de la API | `200 OK` |
| `GET` | `/productos` | Listado paginado con búsqueda (`?page=1&limit=12&search=...`) | `200 OK` |
| `GET` | `/productos/:id` | Obtener un producto por su ID | `200 OK` |
| `POST` | `/productos` | Crear un nuevo producto | `201 Created` |
| `PUT` | `/productos/:id` | Reemplazo completo de un producto | `200 OK` |
| `PATCH`| `/productos/:id` | Actualización parcial de un producto | `200 OK` |
| `DELETE`| `/productos/:id` | Eliminación de un producto | `204 No Content` |
