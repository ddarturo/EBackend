-- =============================================================================
-- DEPLOY RENDER: CAPA 1 DATOS (PostgreSQL)
-- Tabla: producto (id, nombre, descripcion, urlimagen, pvp, stock)
-- Registros: 10.000 productos
-- =============================================================================

DROP TABLE IF EXISTS producto;

CREATE TABLE producto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    urlimagen VARCHAR(500) NOT NULL,
    pvp NUMERIC(10, 2) NOT NULL,
    stock INTEGER NOT NULL
);

-- INSERCIÓN DE 10.000 PRODUCTOS
INSERT INTO producto (nombre, descripcion, urlimagen, pvp, stock)
SELECT
    -- Nombre realista y limpio (sin #número)
    tipos[1 + ((i * 7) % 25)] || ' ' ||
    marcas[1 + ((i * 13) % array_length(marcas, 1))] || ' ' ||
    modelos[1 + ((i * 3) % array_length(modelos, 1))] AS nombre,
    
    -- Descripción del producto
    'Herramienta profesional: ' ||
    tipos[1 + ((i * 7) % 25)] || ' de alto rendimiento, marca ' ||
    marcas[1 + ((i * 13) % array_length(marcas, 1))] || ', ideal para trabajos exigentes en construcción, taller y hogar. Garantía oficial de fábrica y máxima durabilidad.' AS descripcion,
    
    -- URL de imagen real correspondiente exactamente a su tipo de herramienta
    imagenes[1 + ((i * 7) % 25)] AS urlimagen,
    
    -- PVP (entre $4.50 y $985.00 con 2 decimales)
    ROUND((((i * 179) % 98050) / 100.0 + 4.50)::numeric, 2) AS pvp,
    
    -- Stock (entre 1 y 250 unidades)
    (1 + ((i * 37) % 250))::integer AS stock
FROM
    generate_series(1, 10000) AS s(i),
    (SELECT ARRAY[
        'Taladro percutor inalámbrico',
        'Sierra circular eléctrica',
        'Amoladora angular 4-1/2',
        'Martillo carpintero 16oz',
        'Set de destornilladores aislados',
        'Lijadora orbital compacta',
        'Llave francesa ajustable 10 pulg',
        'Juego de llaves combinadas',
        'Caja portaherramientas metálica',
        'Cinta métrica autobloqueante 8m',
        'Nivel láser autonivelante 360',
        'Pistola de calor profesional',
        'Soldadora inverter 200A',
        'Compresor de aire 2HP',
        'Generador eléctrico a gasolina',
        'Bomba de agua periférica 1/2HP',
        'Manguera reforzada 25m',
        'Escalera de aluminio 6 peldaños',
        'Gafas de seguridad policarbonato',
        'Guantes de protección mecánica',
        'Pintura látex antibacterial 1 galón',
        'Rodillo profesional antigoteo',
        'Brocha para cerdas sintéticas 3 pulg',
        'Disco diamantado de corte 115mm',
        'Candado de latón macizo 50mm'
    ] AS tipos) t,
    (SELECT ARRAY[
        'https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500&q=80', -- Taladro
        'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500&q=80', -- Sierra circular
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&q=80', -- Amoladora angular
        'https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500&q=80', -- Martillo carpintero
        'https://images.unsplash.com/photo-1581783898377-1c85bf937427?w=500&q=80', -- Set de destornilladores
        'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=500&q=80', -- Lijadora orbital
        'https://images.unsplash.com/photo-1611288875785-f62fb9b044a7?w=500&q=80', -- Llave francesa
        'https://images.unsplash.com/photo-1581166397057-235af2b3c6dd?w=500&q=80', -- Juego de llaves
        'https://images.unsplash.com/photo-1530124566582-a618bc2615dc?w=500&q=80', -- Caja portaherramientas
        'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=500&q=80', -- Cinta métrica
        'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=500&q=80', -- Nivel láser
        'https://images.unsplash.com/photo-1581092162384-8987c1d64718?w=500&q=80', -- Pistola de calor
        'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=500&q=80', -- Soldadora inverter
        'https://images.unsplash.com/photo-1616401784845-180882ba9ba8?w=500&q=80', -- Compresor de aire
        'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=500&q=80', -- Generador eléctrico
        'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?w=500&q=80', -- Bomba de agua
        'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=500&q=80', -- Manguera reforzada
        'https://images.unsplash.com/photo-1570050785780-3c79854c7813?w=500&q=80', -- Escalera de aluminio
        'https://images.unsplash.com/photo-1593854519602-687eae339d57?w=500&q=80', -- Gafas de seguridad
        'https://images.unsplash.com/photo-1584483766114-2cea6facdf57?w=500&q=80', -- Guantes de protección
        'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=500&q=80', -- Pintura látex
        'https://images.unsplash.com/photo-1525909002-1b05e0c869d8?w=500&q=80', -- Rodillo profesional
        'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=500&q=80', -- Brocha para cerdas
        'https://images.unsplash.com/photo-1560846389-956694677531?w=500&q=80', -- Disco diamantado
        'https://images.unsplash.com/photo-1555529902-5261145633bf?w=500&q=80'  -- Candado de latón
    ] AS imagenes) img,
    (SELECT ARRAY[
        'DeWalt',
        'Bosch Professional',
        'Makita',
        'Stanley',
        'Milwaukee',
        'Black+Decker',
        'Truper Expert',
        'Craftsman',
        'Total Tools',
        '3M Industrial'
    ] AS marcas) m,
    (SELECT ARRAY[
        'Heavy Duty V-100',
        'Pro Edition Max',
        'Extreme Torque 20V',
        'Titanium Precision',
        'Eco Powerline',
        'Ultra Durable X7',
        'Compact Force',
        'Master Series 3000',
        'Industrial Plus',
        'Turbo Grip Gen-2'
    ] AS modelos) mo;

-- VERIFICACIÓN
SELECT COUNT(*) AS total_productos FROM producto;

SELECT id, nombre, pvp, stock, substring(urlimagen, 1, 45) || '...' AS urlimagen
FROM producto
ORDER BY id ASC
LIMIT 5;
