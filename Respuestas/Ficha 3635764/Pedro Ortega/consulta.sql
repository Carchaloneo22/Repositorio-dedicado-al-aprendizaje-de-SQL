-- =====================================================
-- NIVEL 1: CONSULTAS BÁSICAS
-- =====================================================

-- CONSULTA 1: Catálogo de productos activos.

SELECT id_prod, nom_prod
FROM tab_prod
WHERE ind_estado = TRUE
ORDER BY id_prod;


-- CONSULTA 2: Ciudades por departamento.

SELECT id_ciud, nom_ciud
FROM tab_ciud
WHERE id_dpto = '02'
ORDER BY nom_ciud;


-- CONSULTA 3: Proveedores destacados.

SELECT nom_comp, val_cupocre, val_puntos
FROM tab_prov
WHERE val_cupocre >= 5000000
  AND val_puntos >= 90
ORDER BY val_cupocre DESC;


-- CONSULTA 4: Búsqueda de productos por nombre.

SELECT id_prod, nom_prod
FROM tab_prod
WHERE nom_prod ILIKE '%usb%'
   OR nom_prod ILIKE '%inalámbrico%'
ORDER BY nom_prod;


-- =====================================================
-- NIVEL 2: CONSULTAS INTERMEDIAS
-- =====================================================

-- CONSULTA 5: Proveedores con ubicación geográfica.

SELECT p.id_prov, p.nom_comp, c.nom_ciud, d.nom_dpto
FROM tab_prov p
INNER JOIN tab_ciud c ON c.id_ciud = p.id_ciud
INNER JOIN tab_dptos d ON d.id_dpto = c.id_dpto
ORDER BY d.nom_dpto, p.nom_comp;


-- CONSULTA 6: Departamentos con menos de ocho ciudades.

SELECT d.nom_dpto, COUNT(c.id_ciud) AS cantidad_ciudades
FROM tab_dptos d
LEFT JOIN tab_ciud c ON c.id_dpto = d.id_dpto
GROUP BY d.id_dpto, d.nom_dpto
HAVING COUNT(c.id_ciud) < 8
ORDER BY cantidad_ciudades;


-- CONSULTA 7: Rango de precios por producto.

SELECT id_prod, nom_prod,
       COUNT(DISTINCT id_prov) AS cantidad_proveedores,
       MIN(val_prod) AS precio_minimo,
       MAX(val_prod) AS precio_maximo,
       ROUND(AVG(val_prod)) AS precio_promedio
FROM vw_productos_proveedores
WHERE disponible = TRUE
GROUP BY id_prod, nom_prod
ORDER BY precio_promedio DESC;


-- CONSULTA 8: Proveedor con el precio más bajo.

SELECT v.id_prod, v.nom_prod, v.id_prov, v.proveedor,
       v.val_prod AS precio
FROM vw_productos_proveedores v
WHERE v.disponible = TRUE
  AND v.val_prod = (
      SELECT MIN(x.val_prod)
      FROM vw_productos_proveedores x
      WHERE x.id_prod = v.id_prod
        AND x.disponible = TRUE
  )
ORDER BY v.nom_prod;


-- CONSULTA 9: Total de compras por proveedor.

SELECT p.id_prov, p.nom_comp,
       COUNT(DISTINCT e.id_factura) AS cantidad_facturas,
       COALESCE(SUM(d.val_neto), 0) AS total_neto
FROM tab_prov p
LEFT JOIN tab_enc_compra e ON e.id_prov = p.id_prov
LEFT JOIN tab_det_compra d ON d.id_factura = e.id_factura
GROUP BY p.id_prov, p.nom_comp
ORDER BY total_neto DESC;


-- CONSULTA 10: Facturas sin detalles.

SELECT e.id_factura, e.fec_factura, e.id_prov, p.nom_comp
FROM tab_enc_compra e
INNER JOIN tab_prov p ON p.id_prov = e.id_prov
WHERE NOT EXISTS (
    SELECT 1
    FROM tab_det_compra d
    WHERE d.id_factura = e.id_factura
)
ORDER BY e.id_factura;


-- CONSULTA 11: Resumen de órdenes por área.

SELECT id_area, nom_area, cantidad_ordenes, unidades_solicitadas
FROM vw_resumen_ordenes_area
ORDER BY unidades_solicitadas DESC;


-- =====================================================
-- NIVEL 3: CONSULTAS AVANZADAS
-- =====================================================

-- CONSULTA 12: Estado de cuenta de facturas.

SELECT id_factura, proveedor,
       total_factura, total_pagado, saldo, estado_pago
FROM vw_estado_factura
WHERE saldo > 0
ORDER BY saldo DESC;


-- CONSULTA 13: Antigüedad de cartera.

SELECT id_factura, fec_factura,
       DATE '2024-06-30' - fec_factura::date AS dias,
       saldo,
       CASE
         WHEN DATE '2024-06-30' - fec_factura::date > 120
             THEN 'Más de 120 días'
         WHEN DATE '2024-06-30' - fec_factura::date > 90
             THEN '91 a 120 días'
         ELSE '90 días o menos'
       END AS rango_antiguedad
FROM vw_estado_factura
WHERE saldo > 0
ORDER BY dias DESC;


-- CONSULTA 14: Compras mensuales y acumuladas.

SELECT TO_CHAR(DATE_TRUNC('month', e.fec_factura), 'YYYY-MM') AS mes,
       SUM(d.val_neto) AS compras_mes,
       SUM(SUM(d.val_neto)) OVER (
           ORDER BY DATE_TRUNC('month', e.fec_factura)
       ) AS acumulado
FROM tab_enc_compra e
INNER JOIN tab_det_compra d ON d.id_factura = e.id_factura
GROUP BY DATE_TRUNC('month', e.fec_factura)
ORDER BY DATE_TRUNC('month', e.fec_factura);


-- CONSULTA 15: Ranking de productos más comprados.

SELECT RANK() OVER (ORDER BY SUM(d.val_neto) DESC) AS puesto,
       p.id_prod, p.nom_prod,
       SUM(d.val_cant) AS unidades,
       SUM(d.val_neto) AS total_neto
FROM tab_det_compra d
INNER JOIN tab_prod p ON p.id_prod = d.id_prod
GROUP BY p.id_prod, p.nom_prod
ORDER BY puesto
LIMIT 5;


-- CONSULTA 16: Análisis de sobrecostos.

WITH mejor_precio AS (
    SELECT id_prod, MIN(val_prod) AS precio_minimo
    FROM vw_productos_proveedores
    WHERE disponible = TRUE
    GROUP BY id_prod
)
SELECT d.id_factura, p.id_prod, p.nom_prod,
       d.val_cant, d.val_unit, m.precio_minimo,
       (d.val_unit - m.precio_minimo) * d.val_cant AS sobrecosto
FROM tab_det_compra d
INNER JOIN mejor_precio m ON m.id_prod = d.id_prod
INNER JOIN tab_prod p ON p.id_prod = d.id_prod
WHERE d.val_unit > m.precio_minimo
ORDER BY sobrecosto DESC
LIMIT 6;


-- CONSULTA 17: Auditoría de precios facturados.

SELECT d.id_factura, d.id_prod, p.nom_prod,
       d.val_unit AS precio_facturado,
       pp.val_prod AS precio_catalogo
FROM tab_det_compra d
INNER JOIN tab_enc_compra e ON e.id_factura = d.id_factura
INNER JOIN tab_prod p ON p.id_prod = d.id_prod
INNER JOIN tab_prod_prov pp
    ON pp.id_prov = e.id_prov
   AND pp.id_prod = d.id_prod
WHERE d.val_unit <> pp.val_prod
ORDER BY d.id_factura;