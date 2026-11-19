# Documento de Arquitectura de Software - Backend REST API
**Proyecto:** Sistema de Gestión de Productos (Arquitectura N-Capas)  
**Tecnologías:** Node.js, Express.js, PostgreSQL  
**Entorno de Ejecución:** Puerto 5050  

---

## 1. Visión General y Estilos Arquitectónicos

El backend está concebido bajo una integración armónica de tres estilos arquitectónicos reconocidos en la ingeniería de software:

```
┌─────────────────────────────────────────────────────────────┐
│               CAPA 3: PRESENTACIÓN (Frontend)               │
│         HTML5 / CSS3 / JavaScript Modular / Live Server     │
└──────────────────────────────┬──────────────────────────────┘
                               │  Peticiones HTTP (JSON REST)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│               CAPA 2: APLICACIONES (Backend)                │
│       Node.js + Express.js en Puerto 5050 (Patrón MVC)      │
│   [Routes] ──▶ [Middlewares] ──▶ [Controllers] ──▶ [Models] │
└──────────────────────────────┬──────────────────────────────┘
                               │  Protocolo TCP / Pool SQL
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                  CAPA 1: DATOS (Persistencia)               │
│          PostgreSQL (Base de datos: clase12nov)             │
│                 Tabla: producto (10.000 filas)              │
└─────────────────────────────────────────────────────────────┘
```

### 1.1. Estilo N-Capas (Layered Architecture)
Permite desacoplar responsabilidades en niveles jerárquicos independientes donde cada capa solo se comunica con su capa adyacente:
* **Capa 1 (Datos):** Base de datos relacional PostgreSQL con la tabla `producto` (`id`, `nombre`, `descripcion`, `urlimagen`, `pvp`, `stock`).
* **Capa 2 (Lógica de Aplicación / Backend):** Servidor Node.js y Express que contiene la lógica de negocio, reglas de validación y control de acceso.
* **Capa 3 (Presentación / Frontend):** Cliente web desacoplado que consume servicios mediante HTTP y se aloja en un servidor estático (Live Server).

### 1.2. Estilo Cliente - Servidor (Client - Server)
* **Independencia de plataformas:** El cliente (frontend) y el servidor (backend) son procesos totalmente independientes.
* **Protocolo sin estado (Stateless):** Cada solicitud enviada por el cliente contiene toda la información necesaria para ser procesada; el servidor no guarda sesiones en memoria para atender las peticiones de la API.

### 1.3. Estilo REST (Representational State Transfer)
La API sigue las restricciones y principios RESTful:
* **Recursos como URIs:** Sustantivos en plural (`/api/v1/productos`).
* **Uso semántico de verbos HTTP:** `GET` para consultar, `POST` para crear, `PUT` para reemplazar totalmente, `PATCH` para actualización parcial y `DELETE` para eliminación.
* **Representaciones estándar:** Intercambio de mensajes exclusivamente en formato `application/json`.
* **Respuestas con códigos de estado HTTP normalizados:** Comunicación del resultado de la operación mediante el estándar RFC de HTTP.

---

## 2. Patrón Arquitectónico del Backend: MVC (Modelo - Vista - Controlador)

El backend implementa el patrón **MVC adaptado a APIs REST**:

```
 Cliente (HTTP)
       │
       ▼
 ┌────────────┐     Invocación      ┌────────────┐
 │ Controller │ ──────────────────▶ │   Model    │ ──▶ (Base de Datos)
 └─────┬──────┘                     └────────────┘
       │
       │ Genera
       ▼
 ┌────────────┐
 │    View    │ (Serialización JSON de respuesta)
 └────────────┘
```

* **Modelo (`models/`):** Representa los datos y las reglas del dominio de negocio. Aloja la persistencia y la interacción directa con la base de datos PostgreSQL mediante el patrón Repository y la conexión Singleton.
* **Vista (`views` o serializadores JSON):** En un API REST moderna, la "Vista" no es una plantilla HTML, sino la **representación JSON estandarizada** que se entrega al cliente con una estructura de respuesta consistente (ej: `{ success: true, data: [...], pagination: {...} }`).
* **Controlador (`controllers/`):** Actúa como intermediario. Recibe la petición HTTP saneada desde las rutas y middlewares, delega la operación al modelo correspondiente, gestiona el flujo de control y emite la respuesta con el código HTTP apropiado.

---

## 3. Patrones de Diseño Implementados

### 3.1. Patrón Singleton (Base de Datos)
* **Ubicación:** `models/database/Database.js` (o `config/db.js`).
* **Propósito:** Garantizar que exista **una única instancia** del pool de conexiones de PostgreSQL (`pg.Pool`) a lo largo del ciclo de vida del servidor.
* **Justificación técnica:** Abrir y cerrar conexiones por cada petición agota los sockets del sistema operativo y degrada drásticamente el rendimiento con 10.000 registros. El Singleton reutiliza el pool de conexiones eficientemente.

```javascript
// Ejemplo conceptual del Singleton
import pkg from 'pg';
const { Pool } = pkg;

class Database {
  constructor() {
    if (!Database.instance) {
      Database.instance = new Pool({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        database: process.env.DB_NAME,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        max: 20 // Máximo 20 conexiones en pool
      });
    }
  }

  static getInstance() {
    if (!Database.instance) {
      new Database();
    }
    return Database.instance;
  }
}
```

### 3.2. Patrón Repository (Acceso a Datos)
* **Ubicación:** `models/repositories/ProductoRepository.js`.
* **Propósito:** Desacoplar la lógica de acceso a datos de la lógica del negocio y del controlador.
* **Justificación técnica:** El controlador jamás escribe sentencias SQL (`SELECT`, `INSERT`). Toda la interacción con PostgreSQL se encapsula en métodos del repositorio (`findAll`, `findById`, `create`, `update`, `delete`), facilitando pruebas unitarias y el mantenimiento.

### 3.3. Patrón Factory (Comunicación entre Capas)
* **Ubicación:** `models/factories/ProductoFactory.js` y `controllers/factories/`.
* **Propósito:** Centralizar la creación e instanciación de objetos del dominio y controladores.
* **Justificación técnica:** Permite inyectar las dependencias (por ejemplo, pasar el `ProductoRepository` al `ProductoController`) sin acoplar fuertemente los módulos, cumpliendo con el principio de Inversión de Dependencias (DIP) de SOLID.

---

## 4. Estructura de Directorios del Backend

La estructura del proyecto dentro de `Clase12Nov/capa2_backend/` está organizada según los requerimientos solicitados:

```
capa2_backend/
├── .env                        # Variables de entorno globales (ignorado en Git)
├── .env.example                # Plantilla de variables de entorno para desarrollo
├── .gitignore                  # Exclusión de node_modules y .env
├── package.json                # Dependencias (express, pg, dotenv, cors, helmet, etc.)
├── server.js                   # Punto de entrada principal (puerto 5050)
│
├── routes/                     # Rutas de la API (un archivo por modelo)
│   ├── index.js                # Enrutador centralizado y versionado (/api/v1)
│   └── producto.routes.js      # Endpoints específicos del modelo Producto
│
├── middlewares/                # Filtros transversales y de seguridad
│   ├── cors.middleware.js      # Control de orígenes y cabeceras CORS
│   ├── validation.middleware.js# Validación de tipos y esquemas de entrada
│   ├── sanitize.middleware.js  # Sanitización contra XSS e inyecciones
│   ├── jsonVerify.middleware.js# Detección de JSON malformados en payloads
│   ├── pagination.middleware.js# Cálculo y normalización de 'page' y 'limit'
│   ├── versioning.middleware.js# Control de prefijos y compatibilidad de versiones
│   └── errorHandler.middleware.js # Manejador global centralizado de excepciones
│
├── controllers/                # Controladores (uno por modelo)
│   └── producto.controller.js  # Acciones: GET, POST, PUT, PATCH, DELETE + HTTP codes
│
└── models/                     # Capa del Modelo (Dominio, Repositorio, Singleton)
    ├── entities/
    │   └── Producto.js         # Entidad de dominio Producto
    ├── repositories/
    │   └── ProductoRepository.js # Patrón Repository (Consultas SQL parametrizadas)
    ├── database/
    │   └── Database.js         # Patrón Singleton para el Pool de PostgreSQL
    └── factories/
        └── ProductoFactory.js  # Patrón Factory para instanciación e inyección
```

---

## 5. Especificación de Componentes y Módulos

### 5.1. `server.js` (Orquestador Central)
* Carga las variables de entorno desde el archivo `.env`.
* Configura middlewares globales de seguridad (`helmet`, `cors`, `express.json`).
* Inicializa y escucha peticiones exclusivamente en el **puerto 5050** (`process.env.PORT || 5050`).
* Registra el enrutador versionado base: `/api/v1`.
* Registra el middleware de manejo global de excepciones al final de la cadena.

### 5.2. `routes/` (Rutas)
* **Un archivo por modelo:** Por cada entidad existe su respectivo archivo de rutas (ej: `producto.routes.js`).
* **Mapeo de Endpoints:**
  * `GET    /api/v1/productos`         -> Obtener productos con paginación y filtros.
  * `GET    /api/v1/productos/:id`     -> Obtener un producto por ID.
  * `POST   /api/v1/productos`         -> Crear un nuevo producto.
  * `PUT    /api/v1/productos/:id`     -> Reemplazo completo de un producto.
  * `PATCH  /api/v1/productos/:id`     -> Actualización parcial de campos de un producto.
  * `DELETE /api/v1/productos/:id`     -> Eliminar un producto por ID.

### 5.3. `middlewares/` (Filtros Transversales)
1. **Control de CORS (`cors.middleware.js`):** Restringe los dominios que pueden consumir la API mediante `process.env.ALLOWED_ORIGINS` (evita accesos no autorizados desde otros orígenes).
2. **Validación de Esquema (`validation.middleware.js`):** Valida que los datos requeridos estén presentes y posean el tipo correcto (ej: `pvp` numérico positivo, `stock` entero no negativo).
3. **Sanitización (`sanitize.middleware.js`):** Limpia caracteres peligrosos en campos de texto (`nombre`, `descripcion`) para prevenir ataques de Cross-Site Scripting (XSS).
4. **Verificación de JSON (`jsonVerify.middleware.js`):** Intercepta errores de sintaxis si el cliente envía un JSON roto o inválido, respondiendo con código `400 Bad Request` antes de que llegue al controlador.
5. **Paginación (`pagination.middleware.js`):** Valida los parámetros `?page=1&limit=20`. Previene denegación de servicio (DoS) fijando límites máximos (ej: máximo 100 registros por página) y calculando automáticamente `offset = (page - 1) * limit`.
6. **Versionamiento (`versioning.middleware.js`):** Valida que la petición incluya el prefijo de versión (`/api/v1/`), garantizando retrocompatibilidad futura con versiones posteriores (`v2`, etc.).
7. **Control Centralizado de Excepciones (`errorHandler.middleware.js`):** Captura cualquier error no controlado lanzado por `async/await`. Devuelve una respuesta limpia sin exponer el *stack trace* ni la estructura interna de la base de datos en producción.

### 5.4. `controllers/` (Controladores y Códigos HTTP)
El controlador `producto.controller.js` implementa los siguientes métodos y respuestas HTTP normalizadas:

| Método HTTP | Acción / Endpoint | Código Éxito | Códigos de Error Posibles | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| **GET** | `getAll` (`/api/v1/productos`) | **`200 OK`** | `500 Internal Server Error` | Retorna lista paginada de productos y metadatos. |
| **GET** | `getById` (`/api/v1/productos/:id`) | **`200 OK`** | `400 Bad Request`, `404 Not Found` | Retorna el producto solicitado si existe. |
| **POST** | `create` (`/api/v1/productos`) | **`201 Created`** | `400 Bad Request`, `422 Unprocessable` | Crea el producto y devuelve el registro con su nuevo ID. |
| **PUT** | `update` (`/api/v1/productos/:id`) | **`200 OK`** | `400 Bad Request`, `404 Not Found`, `422` | Requiere enviar **todos** los campos para actualización total. |
| **PATCH** | `partialUpdate` (`/api/v1/productos/:id`) | **`200 OK`** | `400 Bad Request`, `404 Not Found`, `422` | Actualiza **solo los campos** enviados en el body. |
| **DELETE** | `delete` (`/api/v1/productos/:id`) | **`204 No Content`** | `400 Bad Request`, `404 Not Found` | Elimina el registro y no devuelve cuerpo de contenido. |

---

## 6. Configuración Global Segura: Archivo `.env`

Toda la configuración del entorno se extrae del código fuente para cumplir con los principios de *The Twelve-Factor App*.

### Ejemplo de `.env`:
```ini
# Configuración del Servidor
PORT=5050
NODE_ENV=development
API_VERSION=v1

# Base de Datos PostgreSQL (Capa 1)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=clase12nov
DB_USER=pez
DB_PASSWORD=
DB_POOL_MAX=20
DB_TIMEOUT=30000

# Seguridad y CORS
ALLOWED_ORIGINS=http://localhost:5500,http://127.0.0.1:5500,http://localhost:3000

# Parámetros de Paginación
PAGINATION_DEFAULT_LIMIT=20
PAGINATION_MAX_LIMIT=100
```

---

## 7. Buenas Prácticas de Programación Segura Aplicadas

1. **Prevención de SQL Injection:**
   Todas las consultas en el `ProductoRepository` se ejecutan mediante **consultas parametrizadas** de la librería `pg` (ej: `SELECT * FROM producto WHERE id = $1`, `[$1]`). Nunca se concatenan cadenas de texto en las consultas.
2. **Defensa contra Ataques XSS:**
   Se limpian los textos recibidos mediante el middleware de sanitización antes de guardarlos o procesarlos.
3. **Manejo de Errores Seguro (Information Disclosure):**
   El middleware de control de excepciones nunca retorna mensajes internos de PostgreSQL (como errores de sintaxis SQL o nombres de tablas) al cliente en entornos de producción.
4. **Protección contra DoS en Consultas:**
   Con una base de datos de 10.000 registros, la paginación obligatoria y el límite máximo (`PAGINATION_MAX_LIMIT = 100`) impiden que un cliente malintencionado solicite toda la tabla a la vez, preservando la memoria RAM del servidor.
5. **Principio de Mínimo Privilegio:**
   Las credenciales de base de datos se configuran con los permisos estrictamente necesarios para el esquema de la aplicación.
