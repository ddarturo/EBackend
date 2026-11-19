import { Router } from 'express';
import productoRoutes from './producto.routes.js';
import { seedDatabaseIfNeeded } from '../seed.js';

const apiRouter = Router();

// Endpoint de estado del servicio (Health Check)
apiRouter.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Servicio API REST activo y respondiendo correctamente.',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// Endpoint de auto-inicialización / seed de los 10.000 productos
apiRouter.all('/seed', async (req, res) => {
  const result = await seedDatabaseIfNeeded(req.query.force === 'true');
  res.status(result.success ? 200 : 500).json(result);
});

// Registrar rutas por modelo
apiRouter.use('/productos', productoRoutes);

export default apiRouter;
