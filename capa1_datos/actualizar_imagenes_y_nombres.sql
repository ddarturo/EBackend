-- =============================================================================
-- ACTUALIZACIÓN DE PRODUCTOS:
-- 1. Eliminar el sufijo '#número' de todos los nombres de producto.
-- 2. Asignar imágenes reales y exactas según el tipo de producto.
-- =============================================================================

\c clase12nov

-- 1. Eliminar '#número' al final del nombre
UPDATE producto
SET nombre = TRIM(REGEXP_REPLACE(nombre, '\s*#\d+$', ''));

-- 2. Actualizar las imágenes para que coincidan con la herramienta exacta
UPDATE producto
SET urlimagen = CASE
    WHEN nombre ILIKE '%Taladro%' 
        THEN 'https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500&q=80'
    WHEN nombre ILIKE '%Sierra%' 
        THEN 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500&q=80'
    WHEN nombre ILIKE '%Amoladora%' 
        THEN 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&q=80'
    WHEN nombre ILIKE '%Martillo%' 
        THEN 'https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500&q=80'
    WHEN nombre ILIKE '%destornillador%' 
        THEN 'https://images.unsplash.com/photo-1581783898377-1c85bf937427?w=500&q=80'
    WHEN nombre ILIKE '%Lijadora%' 
        THEN 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=500&q=80'
    WHEN nombre ILIKE '%Llave francesa%' 
        THEN 'https://images.unsplash.com/photo-1611288875785-f62fb9b044a7?w=500&q=80'
    WHEN nombre ILIKE '%Juego de llaves%' 
        THEN 'https://images.unsplash.com/photo-1581166397057-235af2b3c6dd?w=500&q=80'
    WHEN nombre ILIKE '%Caja portaherramientas%' 
        THEN 'https://images.unsplash.com/photo-1530124566582-a618bc2615dc?w=500&q=80'
    WHEN nombre ILIKE '%Cinta métrica%' 
        THEN 'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=500&q=80'
    WHEN nombre ILIKE '%Nivel láser%' 
        THEN 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=500&q=80'
    WHEN nombre ILIKE '%Pistola de calor%' 
        THEN 'https://images.unsplash.com/photo-1581092162384-8987c1d64718?w=500&q=80'
    WHEN nombre ILIKE '%Soldadora%' 
        THEN 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=500&q=80'
    WHEN nombre ILIKE '%Compresor%' 
        THEN 'https://images.unsplash.com/photo-1616401784845-180882ba9ba8?w=500&q=80'
    WHEN nombre ILIKE '%Generador%' 
        THEN 'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=500&q=80'
    WHEN nombre ILIKE '%Bomba de agua%' 
        THEN 'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?w=500&q=80'
    WHEN nombre ILIKE '%Manguera%' 
        THEN 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=500&q=80'
    WHEN nombre ILIKE '%Escalera%' 
        THEN 'https://images.unsplash.com/photo-1570050785780-3c79854c7813?w=500&q=80'
    WHEN nombre ILIKE '%Gafas%' 
        THEN 'https://images.unsplash.com/photo-1593854519602-687eae339d57?w=500&q=80'
    WHEN nombre ILIKE '%Guantes%' 
        THEN 'https://images.unsplash.com/photo-1584483766114-2cea6facdf57?w=500&q=80'
    WHEN nombre ILIKE '%Pintura%' 
        THEN 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=500&q=80'
    WHEN nombre ILIKE '%Rodillo%' 
        THEN 'https://images.unsplash.com/photo-1525909002-1b05e0c869d8?w=500&q=80'
    WHEN nombre ILIKE '%Brocha%' 
        THEN 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=500&q=80'
    WHEN nombre ILIKE '%Disco%' 
        THEN 'https://images.unsplash.com/photo-1560846389-956694677531?w=500&q=80'
    WHEN nombre ILIKE '%Candado%' 
        THEN 'https://images.unsplash.com/photo-1555529902-5261145633bf?w=500&q=80'
    ELSE urlimagen
END;

-- 3. También actualizar en la base de datos por defecto 'postgres' si existe la tabla
\c postgres
DO $$
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'producto') THEN
        UPDATE producto
        SET nombre = TRIM(REGEXP_REPLACE(nombre, '\s*#\d+$', ''));

        UPDATE producto
        SET urlimagen = CASE
            WHEN nombre ILIKE '%Taladro%' THEN 'https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500&q=80'
            WHEN nombre ILIKE '%Sierra%' THEN 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500&q=80'
            WHEN nombre ILIKE '%Amoladora%' THEN 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&q=80'
            WHEN nombre ILIKE '%Martillo%' THEN 'https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500&q=80'
            WHEN nombre ILIKE '%destornillador%' THEN 'https://images.unsplash.com/photo-1581783898377-1c85bf937427?w=500&q=80'
            WHEN nombre ILIKE '%Lijadora%' THEN 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=500&q=80'
            WHEN nombre ILIKE '%Llave francesa%' THEN 'https://images.unsplash.com/photo-1611288875785-f62fb9b044a7?w=500&q=80'
            WHEN nombre ILIKE '%Juego de llaves%' THEN 'https://images.unsplash.com/photo-1581166397057-235af2b3c6dd?w=500&q=80'
            WHEN nombre ILIKE '%Caja portaherramientas%' THEN 'https://images.unsplash.com/photo-1530124566582-a618bc2615dc?w=500&q=80'
            WHEN nombre ILIKE '%Cinta métrica%' THEN 'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=500&q=80'
            WHEN nombre ILIKE '%Nivel láser%' THEN 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=500&q=80'
            WHEN nombre ILIKE '%Pistola de calor%' THEN 'https://images.unsplash.com/photo-1581092162384-8987c1d64718?w=500&q=80'
            WHEN nombre ILIKE '%Soldadora%' THEN 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=500&q=80'
            WHEN nombre ILIKE '%Compresor%' THEN 'https://images.unsplash.com/photo-1616401784845-180882ba9ba8?w=500&q=80'
            WHEN nombre ILIKE '%Generador%' THEN 'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=500&q=80'
            WHEN nombre ILIKE '%Bomba de agua%' THEN 'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?w=500&q=80'
            WHEN nombre ILIKE '%Manguera%' THEN 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=500&q=80'
            WHEN nombre ILIKE '%Escalera%' THEN 'https://images.unsplash.com/photo-1570050785780-3c79854c7813?w=500&q=80'
            WHEN nombre ILIKE '%Gafas%' THEN 'https://images.unsplash.com/photo-1593854519602-687eae339d57?w=500&q=80'
            WHEN nombre ILIKE '%Guantes%' THEN 'https://images.unsplash.com/photo-1584483766114-2cea6facdf57?w=500&q=80'
            WHEN nombre ILIKE '%Pintura%' THEN 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=500&q=80'
            WHEN nombre ILIKE '%Rodillo%' THEN 'https://images.unsplash.com/photo-1525909002-1b05e0c869d8?w=500&q=80'
            WHEN nombre ILIKE '%Brocha%' THEN 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=500&q=80'
            WHEN nombre ILIKE '%Disco%' THEN 'https://images.unsplash.com/photo-1560846389-956694677531?w=500&q=80'
            WHEN nombre ILIKE '%Candado%' THEN 'https://images.unsplash.com/photo-1555529902-5261145633bf?w=500&q=80'
            ELSE urlimagen
        END;
    END IF;
END $$;
