-- =============================================================================
-- SCRIPT DE LAS 30 CONSULTAS SQL Y CONSULTA COMPLEJA DE AUDITORÍA/ANALÍTICA
-- Base de Datos: Sistema de Gestión de Compras y Proveedores
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Consulta SELECT básica (El manejo de esta consulta es una mala practica pero se ejecuta como muestra de la recoleccion de todos los datos)
-- -----------------------------------------------------------------------------
SELECT * FROM tab_prov;

-- -----------------------------------------------------------------------------
-- 2. Consulta SELECT con filtro WHERE
-- -----------------------------------------------------------------------------
SELECT * FROM tab_prod WHERE ind_estado = true;

-- -----------------------------------------------------------------------------
-- 3. Consulta SELECT con ORDER BY
-- -----------------------------------------------------------------------------
SELECT * FROM tab_prov ORDER BY nom_prov ASC;

-- -----------------------------------------------------------------------------
-- 4. Consulta SELECT con LIMIT
-- -----------------------------------------------------------------------------
SELECT id_ciud, nom_ciud FROM tab_ciud LIMIT 10;

-- -----------------------------------------------------------------------------
-- 5. Consulta SELECT con COUNT
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS total_ordenes FROM tab_orden_compra;

-- -----------------------------------------------------------------------------
-- 6. Consulta SELECT con SUM
-- -----------------------------------------------------------------------------
SELECT SUM(val_neto) AS total_facturado_neto FROM tab_det_compra;

-- -----------------------------------------------------------------------------
-- 7. Consulta SELECT con AVG
-- -----------------------------------------------------------------------------
SELECT AVG(val_cupocre) AS promedio_cupo_credito FROM tab_prov;

-- -----------------------------------------------------------------------------
-- 8. Consulta SELECT con GROUP BY
-- -----------------------------------------------------------------------------
SELECT id_dpto, COUNT(*) AS num_ciudades 
FROM tab_ciud 
GROUP BY id_dpto;

-- -----------------------------------------------------------------------------
-- 9. Consulta INSERT
-- -----------------------------------------------------------------------------
INSERT INTO tab_areas (id_area, nom_area, nom_ecarg) 
VALUES (9, 'Auditoría', 'Elena Beltrán');

-- -----------------------------------------------------------------------------
-- 10. Consulta UPDATE
-- -----------------------------------------------------------------------------
UPDATE tab_prov 
SET val_puntos = 98 
WHERE id_prov = 1000000001;

-- -----------------------------------------------------------------------------
-- 11. Consulta DELETE
-- -----------------------------------------------------------------------------
DELETE FROM tab_orden_compra WHERE id_orden = 100030;

-- -----------------------------------------------------------------------------
-- 12. Consulta JOIN
-- -----------------------------------------------------------------------------
SELECT c.nom_ciud, d.nom_dpto 
FROM tab_ciud c 
JOIN tab_dptos d ON c.id_dpto = d.id_dpto;

-- -----------------------------------------------------------------------------
-- 13. Consulta con Subconsulta
-- -----------------------------------------------------------------------------
SELECT * FROM tab_prod 
WHERE id_prod IN (SELECT id_prod FROM tab_prod_prov WHERE val_prod > 2000000);

-- -----------------------------------------------------------------------------
-- 14. Consulta con CASE
-- -----------------------------------------------------------------------------
SELECT nom_comp, val_cupocre,
       CASE 
           WHEN val_cupocre >= 5000000 THEN 'Cupo Alto'
           WHEN val_cupocre BETWEEN 3000000 AND 4999999 THEN 'Cupo Medio'
           ELSE 'Cupo Bajo'
       END AS categoria_credito
FROM tab_prov;

-- -----------------------------------------------------------------------------
-- 15. Consulta con UNION
-- -----------------------------------------------------------------------------
SELECT id_prod FROM tab_orden_compra
UNION
SELECT id_prod FROM tab_det_compra;

-- -----------------------------------------------------------------------------
-- 16. Consulta con UNION ALL
-- -----------------------------------------------------------------------------
SELECT id_ciud FROM tab_prov
UNION ALL
SELECT id_ciud FROM tab_enc_compra;

-- -----------------------------------------------------------------------------
-- 17. Consulta con HAVING
-- -----------------------------------------------------------------------------
SELECT id_factura, COUNT(*) AS num_items 
FROM tab_det_compra 
GROUP BY id_factura 
HAVING COUNT(*) > 1;

-- -----------------------------------------------------------------------------
-- 18. Consulta con EXISTS
-- -----------------------------------------------------------------------------
SELECT * FROM tab_prov p
WHERE EXISTS (SELECT 1 FROM tab_enc_compra e WHERE p.id_prov = e.id_prov);

-- -----------------------------------------------------------------------------
-- 19. Consulta con LIKE
-- -----------------------------------------------------------------------------
SELECT * FROM tab_prov WHERE (datos_prov).correo LIKE '%tecnosum%';

-- -----------------------------------------------------------------------------
-- 20. Consulta con BETWEEN
-- -----------------------------------------------------------------------------
SELECT * FROM tab_enc_compra 
WHERE fec_factura BETWEEN '2024-02-01' AND '2024-02-29';

-- -----------------------------------------------------------------------------
-- 21. Verificación de Volumetría y Conteo de Tablas
-- -----------------------------------------------------------------------------
SELECT 'Proveedores' AS tabla, COUNT(*) AS total FROM tab_prov
UNION ALL
SELECT 'Encabezado Compras', COUNT(*) FROM tab_enc_compra
UNION ALL
SELECT 'Detalle Compras', COUNT(*) FROM tab_det_compra
UNION ALL
SELECT 'Pagos', COUNT(*) FROM tab_pagos;

-- -----------------------------------------------------------------------------
-- 22. Verificación de anomalías (Espacios en blanco)
-- -----------------------------------------------------------------------------
SELECT id_prod, nom_prod 
FROM tab_prod 
WHERE nom_prod LIKE ' %' OR nom_prod LIKE '% ';

-- -----------------------------------------------------------------------------
-- 23. Detección de Caracteres Extraños o Corruptos (Encoding/Colación)
-- -----------------------------------------------------------------------------
SELECT id_factura, val_observa 
FROM tab_enc_compra 
WHERE val_observa LIKE '%%';

-- -----------------------------------------------------------------------------
-- 24. Auditoría General de Constraints por Tabla
-- -----------------------------------------------------------------------------
SELECT 
    constraint_name AS "Nombre_Constraint",
    constraint_type AS "Tipo",
    table_name AS "Tabla"
FROM information_schema.table_constraints
WHERE table_name = 'tab_det_compra';

-- -----------------------------------------------------------------------------
-- 25. Consulta con Tipo Complejo PostgreSQL (Composite Type datos)
-- -----------------------------------------------------------------------------
SELECT nom_comp, 
       (datos_prov).direccion AS direccion, 
       (datos_prov).telefono AS telefono, 
       (datos_prov).correo AS correo 
FROM tab_prov;

-- -----------------------------------------------------------------------------
-- 26. Consulta de Cálculo Financiero acumulado por Factura
-- -----------------------------------------------------------------------------
SELECT id_factura, SUM(val_pago) AS total_abonado, MIN(val_saldo) AS saldo_final 
FROM tab_pagos 
GROUP BY id_factura;

-- -----------------------------------------------------------------------------
-- 27. Consulta de Cruce Múltiple de Productos por Proveedor
-- -----------------------------------------------------------------------------
SELECT p.nom_comp, pr.nom_prod, pp.val_prod 
FROM tab_prod_prov pp
JOIN tab_prov p ON pp.id_prov = p.id_prov
JOIN tab_prod pr ON pp.id_prod = pr.id_prod
WHERE pp.ind_disp = true AND (pr.nom_prod LIKE '%Gamer%' OR pr.nom_prod LIKE '%Oficina%');

-- -----------------------------------------------------------------------------
-- 28. Consulta de Agregación Temporal por Mes
-- -----------------------------------------------------------------------------
SELECT EXTRACT(MONTH FROM fec_factura) AS mes, COUNT(*) AS num_facturas, SUM(d.val_neto) AS total_mes
FROM tab_enc_compra e
JOIN tab_det_compra d ON e.id_factura = d.id_factura
GROUP BY EXTRACT(MONTH FROM fec_factura)
ORDER BY mes ASC;

-- -----------------------------------------------------------------------------
-- 29. Consulta de Órdenes solicitadas por Área
-- -----------------------------------------------------------------------------
SELECT a.nom_area, COUNT(o.id_orden) AS cantidad_ordenes, SUM(o.val_cant) AS unidades_pedidas
FROM tab_orden_compra o
JOIN tab_areas a ON o.id_area = a.id_area
GROUP BY a.nom_area;

-- -----------------------------------------------------------------------------
-- 30. CONSULTA DE ORDEN COMPLEJO (Estructura basada en la imagen de referencia)
-- -----------------------------------------------------------------------------
SELECT a.nom_area AS Area, 
       COUNT(DISTINCT o.id_prod) AS Num_Productos_Diferentes,
       AVG(o.val_cant) AS Promedio_Cant_Por_Orden, 
       SUM(d.val_neto) AS Inversion_Total_Area
FROM tab_areas a

-- 1. Unir Áreas con Órdenes de Compra
INNER JOIN tab_orden_compra o ON a.id_area = o.id_area

-- 2. Unir Órdenes con Detalles de Compra mediante el producto
INNER JOIN tab_det_compra d ON o.id_prod = d.id_prod

-- 3. Filtrar productos con valor representativo y lotes mínimos por orden
WHERE d.val_neto > 500000 
  AND o.val_cant >= 5

-- 4. Agrupar los resultados por área
GROUP BY a.nom_area

-- 5. Filtrar grupos de áreas que cumplen la condición de variedad de productos
HAVING COUNT(DISTINCT o.id_prod) >= 1

-- 6. Ordenar por inversión total de forma descendente
ORDER BY Inversion_Total_Area DESC;
