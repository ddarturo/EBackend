import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import Database from './models/database/Database.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export async function seedDatabaseIfNeeded() {
  const prisma = Database.getInstance().client;

  try {
    console.log('📡 Verificando estado de la tabla producto en PostgreSQL...');

    // 1. Verificar si la tabla existe y cuántos registros tiene
    let count = 0;
    try {
      count = await prisma.producto.count();
      console.log(`ℹ️ Registros actuales en la tabla producto: ${count}`);
    } catch (e) {
      console.log('ℹ️ La tabla producto aún no existe o no tiene registros.');
    }

    if (count >= 10000) {
      console.log(`✅ La base de datos ya contiene ${count} productos. No requiere inicialización.`);
      return;
    }

    console.log('🔄 Inicializando tabla y poblando los 10.000 productos de clase16nov...');
    const sqlPath = path.resolve(__dirname, '../capa1_datos/deploy_render.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');

    // Ejecutar el script SQL de creación e inserción
    await prisma.$executeRawUnsafe(sql);

    const verify = await prisma.producto.count();
    console.log(`🎉 Base de datos poblada exitosamente con ${verify} productos.`);
  } catch (err) {
    console.error('❌ Error durante la verificación/población de la base de datos:', err.message);
  }
}

// Ejecución directa si se invoca con `node seed.js`
if (process.argv[1] && process.argv[1].endsWith('seed.js')) {
  seedDatabaseIfNeeded().then(() => process.exit(0));
}
