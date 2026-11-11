

-- EJERCICIO 1 - SELECT BASICA: todos los campos y registros de proveedores.
SELECT id_prov,nom_prov,ape1_prov,ape2_prov,nom_comp,dir_prov,email_prov,id_ciud,val_cupocre,val_puntos,num_fact,ind_estado FROM tab_prov;

-- EJERCICIO 2 - SELECT CON WHERE: productos activos.
SELECT id_prod, nom_prod, ind_estado
FROM tab_prod
WHERE ind_estado = TRUE; 

-- EJERCICIO 3 - SELECT CON ORDER BY: proveedores por primer nombre ascendente.
SELECT id_prov,nom_prov,ape1_prov,ape2_prov,nom_comp,dir_prov,email_prov,id_ciud,val_cupocre,val_puntos,num_fact,ind_estado
FROM tab_prov
ORDER BY nom_prov ASC;

-- EJERCICIO 4 - SELECT CON LIMIT: primeros 10 registros de ciudades.
SELECT id_ciud, nom_ciud
FROM tab_ciud
LIMIT 10;

-- EJERCICIO 5 - SELECT CON COUNT: total de ordenes de compra.
SELECT COUNT(*) AS total_ordenes
FROM tab_orden_compra;

-- EJERCICIO 6 - SELECT CON SUM: total acumulado del valor neto facturado.
SELECT SUM(val_neto) AS total_facturado
FROM tab_det_compra;

-- EJERCICIO 7 - SELECT CON AVG: promedio del cupo de credito.
SELECT AVG(val_cupocre) AS promedio_cupo_credito
FROM tab_prov;

-- EJERCICIO 8 - SELECT CON GROUP BY: ciudades por departamento.
SELECT id_dpto, COUNT(*) AS total_ciudades
FROM tab_ciud
GROUP BY id_dpto
ORDER BY id_dpto;

-- EJERCICIO 9 - INSERT: insertar area con ID 9.
INSERT INTO tab_areas (id_area, nom_area, nom_encarg)
OVERRIDING SYSTEM VALUE
VALUES (9, 'Auditoria', 'Elena Beltran');

-- EJERCICIO 10 - UPDATE: asignar 98 puntos al proveedor indicado.
UPDATE tab_prov
SET val_puntos = 98
WHERE id_prov = 1000000001;

-- EJERCICIO 11 - DELETE: eliminar la orden indicada.
DELETE FROM tab_orden_compra
WHERE id_orden = 100030;

-- EJERCICIO 12 - JOIN: ciudad y departamento.
SELECT c.nom_ciud AS ciudad, d.nom_dpto AS departamento
FROM tab_ciud AS c
INNER JOIN tab_dptos AS d
    ON c.id_dpto = d.id_dpto;

-- EJERCICIO 13 - SUBCONSULTA: productos con precio superior a 2.000.000.
SELECT id_prod, nom_prod, ind_estado
FROM tab_prod
WHERE id_prod IN (
    SELECT id_prod
    FROM tab_prod_prov
    WHERE val_prod > 2000000
);

-- EJERCICIO 14 - CASE: clasificar proveedores por cupo.
SELECT
    id_prov,
    nom_comp,
    val_cupocre,
    CASE
        WHEN val_cupocre >= 5000000 THEN 'Cupo Alto'
        WHEN val_cupocre >= 3000000 THEN 'Cupo Medio'
        ELSE 'Cupo Bajo'
    END AS clasificacion_cupo
FROM tab_prov;

-- EJERCICIO 15 - UNION: productos pedidos o facturados, sin duplicados.
SELECT id_prod FROM tab_det_orden
UNION
SELECT id_prod FROM tab_det_compra;

-- EJERCICIO 16 - UNION ALL: codigos de ciudad, conservando duplicados.
SELECT id_ciud AS codigo_ciudad
FROM tab_prov
UNION ALL
SELECT id_ciud_entrega AS codigo_ciudad
FROM tab_enc_compra;

-- EJERCICIO 17 - HAVING: facturas con mas de una linea de detalle.
SELECT id_factura, COUNT(*) AS total_lineas
FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT(*) > 1;

-- EJERCICIO 18 - EXISTS: proveedores con al menos una factura.
SELECT id_prov,nom_prov,ape1_prov,ape2_prov,nom_comp,dir_prov,email_prov,id_ciud,val_cupocre,val_puntos,num_fact,ind_estado
FROM tab_prov AS p
WHERE EXISTS (
    SELECT 1
    FROM tab_enc_compra AS e
    WHERE e.id_prov = p.id_prov
);

-- EJERCICIO 19 - LIKE: correo que contenga 'tecnosum'.
SELECT id_prov, nom_comp, email_prov
FROM tab_prov
WHERE email_prov ILIKE '%tecnosum%';

-- EJERCICIO 20 - BETWEEN: facturas de febrero de 2024.
SELECT id_factura, fec_factura, id_prov, id_ciud_entrega, val_observa
FROM tab_enc_compra
WHERE fec_factura BETWEEN DATE '2024-02-01' AND DATE '2024-02-29';

-- EJERCICIO 21 - VOLUMETRIA: conteo de registros en cuatro tablas.
SELECT 'tab_prov' AS tabla, COUNT(*) AS total_registros FROM tab_prov
UNION ALL
SELECT 'tab_enc_compra', COUNT(*) FROM tab_enc_compra
UNION ALL
SELECT 'tab_det_compra', COUNT(*) FROM tab_det_compra
UNION ALL
SELECT 'tab_pagos', COUNT(*) FROM tab_pagos;

-- EJERCICIO 22 - ANOMALIAS DE TEXTO: espacios al inicio o al final del nombre.
SELECT id_prod, nom_prod
FROM tab_prod
WHERE nom_prod <> BTRIM(nom_prod);

-- EJERCICIO 23 - ENCODING: observaciones que contengan literalmente '%%'.
SELECT *
FROM tab_enc_compra
WHERE val_observa LIKE '%\%\%%';

-- EJERCICIO 24 - AUDITORIA DE CONSTRAINTS: restricciones de tab_det_compra.
SELECT constraint_name, constraint_type, table_name
FROM information_schema.table_constraints
WHERE table_name = 'tab_det_compra'
  AND table_schema = 'public'
ORDER BY constraint_type, constraint_name;

-- EJERCICIO 25 - DATOS NORMALIZADOS (adaptacion del tipo compuesto).
SELECT
    p.id_prov,
    p.nom_comp,
    p.dir_prov AS direccion,
    t.num_telefono AS telefono,
    p.email_prov AS correo
FROM tab_prov AS p
LEFT JOIN tab_tel_prov AS t
    ON p.id_prov = t.id_prov
ORDER BY p.id_prov;

-- EJERCICIO 26 - CALCULO FINANCIERO: abonado y saldo por factura.
SELECT
    e.id_factura,
    COALESCE(SUM(p.val_pago), 0) AS total_abonado,
    COALESCE((
        SELECT SUM(d.val_neto)
        FROM tab_det_compra AS d
        WHERE d.id_factura = e.id_factura
    ), 0) - COALESCE(SUM(p.val_pago), 0) AS saldo_final
FROM tab_enc_compra AS e
LEFT JOIN tab_pagos AS p
    ON e.id_factura = p.id_factura
GROUP BY e.id_factura
ORDER BY e.id_factura;

-- EJERCICIO 26 - ALTERNATIVA: usar la vista existente que calcula saldo y estado.
SELECT id_factura,
       total_pagado AS total_abonado,
       saldo AS saldo_final,
       estado_pago
FROM vw_estado_factura
ORDER BY id_factura;

-- EJERCICIO 27 - CRUCE MULTITABLA: productos disponibles Gamer u Oficina.
SELECT
    p.nom_comp AS proveedor,
    pr.nom_prod AS producto,
    pp.val_prod AS valor_producto
FROM tab_prod_prov AS pp
INNER JOIN tab_prov AS p ON pp.id_prov = p.id_prov
INNER JOIN tab_prod AS pr ON pp.id_prod = pr.id_prod
WHERE pp.ind_disp = TRUE
  AND (
      pr.nom_prod ILIKE '%Gamer%'
      OR pr.nom_prod ILIKE '%Oficina%'
  )
ORDER BY p.nom_comp, pr.nom_prod;

-- EJERCICIO 28 - AGREGACION TEMPORAL: suma por numero de mes.
SELECT
    EXTRACT(MONTH FROM e.fec_factura) AS numero_mes,
    SUM(d.val_neto) AS total_facturado
FROM tab_enc_compra AS e
INNER JOIN tab_det_compra AS d ON e.id_factura = d.id_factura
GROUP BY EXTRACT(MONTH FROM e.fec_factura)
ORDER BY numero_mes;

-- EJERCICIO 28 - ALTERNATIVA RECOMENDADA: separar tambien por año.
SELECT
    EXTRACT(YEAR FROM e.fec_factura) AS anio,
    EXTRACT(MONTH FROM e.fec_factura) AS mes,
    SUM(d.val_neto) AS total_facturado
FROM tab_enc_compra AS e
INNER JOIN tab_det_compra AS d ON e.id_factura = d.id_factura
GROUP BY
    EXTRACT(YEAR FROM e.fec_factura),
    EXTRACT(MONTH FROM e.fec_factura)
ORDER BY anio, mes;

-- EJERCICIO 29 - RESUMEN POR AREA: ordenes y unidades solicitadas.
SELECT
    a.nom_area,
    COUNT(DISTINCT o.id_orden) AS total_ordenes,
    COALESCE(SUM(d.val_cant), 0) AS unidades_solicitadas
FROM tab_areas AS a
LEFT JOIN tab_orden_compra AS o ON a.id_area = o.id_area
LEFT JOIN tab_det_orden AS d ON o.id_orden = d.id_orden
GROUP BY a.id_area, a.nom_area
ORDER BY a.nom_area;