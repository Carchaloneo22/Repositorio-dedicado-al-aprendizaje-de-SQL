# Taller práctico de SQL - Sistema de compras y proveedores (ejercicios 11 a 30)

**Estudiante:** Jose David Gomez Saavedra
**Programa:** SENA - Análisis y Desarrollo de Software
**Asignatura:** Bases de Datos Relacionales
**Motor:** PostgreSQL
**Fecha:** 13 de noviembre de 2026

*Documento modificado en Claude para su organización.*

## Bloque II: modificaciones, joins y subconsultas

### Ejercicio 11: DELETE

Eliminar de tab_orden_compra la orden con id_orden 100030.

```sql
DELETE FROM tab_orden_compra
WHERE id_orden = 100030;
```

El WHERE limita el borrado a esa orden. Sin él se borrarían todas las órdenes. Si la orden tuviera filas en otras tablas que la referencian, PostgreSQL rechazaría el borrado por la llave foránea.

### Ejercicio 12: JOIN

Mostrar el nombre de cada ciudad con el nombre de su departamento.

```sql
SELECT c.nom_ciud AS nombre_ciudad,
       d.nom_dpto AS nombre_departamento
FROM tab_ciud c
INNER JOIN tab_dptos d ON c.id_dpto = d.id_dpto;
```

El JOIN une las dos tablas por id_dpto, que es la llave que tienen en común. Los alias c y d acortan la escritura.

### Ejercicio 13: Subconsulta

Productos cuyo id esté en tab_prod_prov con val_prod mayor a 2.000.000.

```sql
SELECT *
FROM tab_prod
WHERE id_prod IN (
    SELECT id_prod
    FROM tab_prod_prov
    WHERE val_prod > 2000000
);
```

La subconsulta saca los id_prod que cumplen el valor y la consulta de afuera trae solo esos productos. Si un producto lo venden varios proveedores, igual sale una sola vez.

### Ejercicio 14: CASE

Clasificar a los proveedores según su cupo de crédito.

```sql
SELECT id_prov,
       nom_comp,
       val_cupocre,
       CASE
           WHEN val_cupocre >= 5000000 THEN 'Cupo Alto'
           WHEN val_cupocre BETWEEN 3000000 AND 4999999 THEN 'Cupo Medio'
           ELSE 'Cupo Bajo'
       END AS clasificacion_cupo
FROM tab_prov;
```

CASE revisa las condiciones en orden y se queda con la primera que se cumpla. Lo que no entra en las dos primeras cae en el ELSE, o sea menos de 3.000.000.

### Ejercicio 15: UNION

Listado único de los IDs de productos pedidos en órdenes y facturados en detalles de compra.

```sql
SELECT id_prod
FROM tab_orden_compra
UNION
SELECT id_prod
FROM tab_det_compra;
```

UNION junta los dos resultados y quita los repetidos. Las dos consultas deben tener el mismo número de columnas y tipos compatibles.

### Ejercicio 16: UNION ALL

Lista con los códigos de ciudad de proveedores y de encabezados de compra, incluyendo duplicados.

```sql
SELECT id_ciud
FROM tab_prov
UNION ALL
SELECT id_ciud
FROM tab_enc_compra;
```

UNION ALL no quita duplicados, así que muestra todas las filas de las dos tablas. Por eso devuelve más filas que un UNION.

### Ejercicio 17: HAVING

IDs de facturas que tengan más de una línea de detalle.

```sql
SELECT id_factura,
       COUNT(*) AS total_lineas
FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT(*) > 1;
```

Se agrupa por factura y se cuentan sus líneas. HAVING filtra los grupos ya contados, algo que WHERE no puede hacer con COUNT.

### Ejercicio 18: EXISTS

Proveedores que tengan al menos una factura en tab_enc_compra.

```sql
SELECT p.*
FROM tab_prov p
WHERE EXISTS (
    SELECT 1
    FROM tab_enc_compra e
    WHERE e.id_prov = p.id_prov
);
```

Por cada proveedor se busca si hay una factura suya. EXISTS solo devuelve verdadero o falso, por eso el SELECT 1 de adentro no importa qué columna trae.

### Ejercicio 19: LIKE

Proveedores cuyo correo contenga la palabra 'tecnosum'.

```sql
SELECT id_prov,
       nom_comp,
       (datos_prov).correo AS correo
FROM tab_prov
WHERE (datos_prov).correo LIKE '%tecnosum%';
```

El correo está dentro del tipo compuesto datos_prov, por eso se accede con paréntesis: (datos_prov).correo. Los % a cada lado significan que antes y después puede haber cualquier texto.

### Ejercicio 20: BETWEEN

Encabezados de compra con fecha de factura entre el 1 y el 29 de febrero de 2024.

```sql
SELECT *
FROM tab_enc_compra
WHERE fec_factura BETWEEN '2024-02-01' AND '2024-02-29';
```

BETWEEN incluye los dos extremos. 2024 es bisiesto, por eso febrero llega hasta el 29.

## Bloque III: auditoría, control de calidad y reportes

### Ejercicio 21: Volumetría

Conteo de registros de tab_prov, tab_enc_compra, tab_det_compra y tab_pagos con UNION ALL.

```sql
SELECT 'tab_prov' AS tabla, COUNT(*) AS total_registros FROM tab_prov
UNION ALL
SELECT 'tab_enc_compra', COUNT(*) FROM tab_enc_compra
UNION ALL
SELECT 'tab_det_compra', COUNT(*) FROM tab_det_compra
UNION ALL
SELECT 'tab_pagos', COUNT(*) FROM tab_pagos;
```

Cada SELECT cuenta una tabla y le pone su nombre como texto. UNION ALL apila las cuatro filas en un solo reporte. Se usa ALL para que no se mezclen resultados que casualmente den el mismo número.

### Ejercicio 22: Anomalías de texto

Detectar productos con espacios al inicio o al final del nombre.

```sql
SELECT id_prod,
       '[' || nom_prod || ']' AS nombre_con_corchetes
FROM tab_prod
WHERE nom_prod <> BTRIM(nom_prod);
```

BTRIM quita los espacios de los dos extremos. Si el nombre original es distinto al nombre recortado, tenía espacios sobrando. Los corchetes sirven para ver dónde están esos espacios.

### Ejercicio 23: Encoding / caracteres corruptos

Facturas cuyas observaciones contengan los caracteres '%%'.

```sql
SELECT id_factura,
       val_observa
FROM tab_enc_compra
WHERE POSITION('%%' IN val_observa) > 0;
```

Aquí no sirve LIKE '%%' porque en LIKE el % es un comodín y esa condición se cumple para cualquier texto. POSITION busca el texto tal cual y devuelve su posición, o 0 si no lo encuentra. Otra forma válida es escapar los símbolos: `WHERE val_observa LIKE '%\%\%%'`.

### Ejercicio 24: Auditoría de constraints

Listar los constraints de tab_det_compra desde el diccionario de datos.

```sql
SELECT constraint_name AS nombre_constraint,
       constraint_type AS tipo
FROM information_schema.table_constraints
WHERE table_schema = 'public'
  AND table_name = 'tab_det_compra'
ORDER BY constraint_type, constraint_name;
```

information_schema guarda la información de la estructura de la base de datos. Se filtra por esquema public y por nombre de tabla. Salen la llave primaria, las foráneas y los CHECK. En PostgreSQL 16 también aparecen los NOT NULL como CHECK con nombres generados.

### Ejercicio 25: Tipos compuestos

Extraer dirección, teléfono y correo del tipo datos en tab_prov.

```sql
SELECT id_prov,
       nom_comp,
       (datos_prov).direccion AS direccion,
       (datos_prov).telefono  AS telefono,
       (datos_prov).correo    AS correo
FROM tab_prov;
```

datos_prov es un tipo compuesto con tres campos. Para sacar cada uno se escribe la columna entre paréntesis y luego un punto con el nombre del subcampo.

### Ejercicio 26: Cálculo financiero

Por factura, el total abonado y el saldo mínimo que queda.

```sql
SELECT id_factura,
       SUM(val_pago)  AS total_abonado,
       MIN(val_saldo) AS saldo_final
FROM tab_pagos
GROUP BY id_factura
ORDER BY id_factura;
```

SUM suma todos los abonos de la factura. Como el saldo baja con cada pago, el MIN de val_saldo es el saldo que queda al final.

### Ejercicio 27: Cruce multitabla

Proveedor, producto y valor para ítems disponibles cuyo nombre contenga 'Gamer' u 'Oficina'.

```sql
SELECT p.nom_comp   AS proveedor,
       pr.nom_prod  AS producto,
       pp.val_prod  AS valor_producto
FROM tab_prod_prov pp
INNER JOIN tab_prov p  ON pp.id_prov = p.id_prov
INNER JOIN tab_prod pr ON pp.id_prod = pr.id_prod
WHERE pp.ind_disp = TRUE
  AND (pr.nom_prod ILIKE '%Gamer%' OR pr.nom_prod ILIKE '%Oficina%');
```

tab_prod_prov conecta proveedores con productos, por eso se une con las dos tablas. ILIKE no distingue mayúsculas, así que también encuentra nombres como "Escritorio oficina". Los paréntesis en el OR evitan que el AND se mezcle mal con las condiciones.

### Ejercicio 28: Agregación temporal

Suma del valor neto facturado por número de mes.

```sql
SELECT EXTRACT(MONTH FROM e.fec_factura) AS num_mes,
       SUM(d.val_neto)                   AS total_neto
FROM tab_enc_compra e
INNER JOIN tab_det_compra d ON e.id_factura = d.id_factura
GROUP BY EXTRACT(MONTH FROM e.fec_factura)
ORDER BY num_mes;
```

La fecha está en el encabezado y el valor neto en el detalle, por eso se unen. EXTRACT saca el número del mes (1 a 12) y se agrupa por él. Si hay facturas de varios años, el mismo mes de años distintos se suma junto.

### Ejercicio 29: Resumen por área

Total de órdenes y suma de unidades solicitadas por nombre de área.

```sql
SELECT a.nom_area                AS area,
       COUNT(o.id_orden)         AS total_ordenes,
       SUM(o.val_cant)           AS unidades_solicitadas
FROM tab_areas a
INNER JOIN tab_orden_compra o ON a.id_area = o.id_area
GROUP BY a.nom_area
ORDER BY total_ordenes DESC;
```

Se une cada orden con su área y se agrupa por nombre de área. COUNT cuenta las órdenes y SUM suma val_cant, que son las unidades pedidas en cada orden.

## Bloque IV: consulta compleja de estructura avanzada

### Ejercicio 30: Consulta multidimensional de rendimiento y filtrado complejo

Combinar tab_areas, tab_orden_compra y tab_det_compra para sacar, por área, los productos distintos solicitados, el promedio de cantidad por orden y la inversión total en valor neto. Debe usar WHERE, GROUP BY, HAVING y ORDER BY descendente.

```sql
SELECT a.nom_area                       AS area,
       COUNT(DISTINCT o.id_prod)        AS productos_distintos,
       ROUND(AVG(o.val_cant), 2)        AS promedio_cantidad_por_orden,
       SUM(d.val_neto)                  AS inversion_total_neto
FROM tab_areas a
INNER JOIN tab_orden_compra o ON a.id_area = o.id_area
INNER JOIN tab_det_compra d   ON o.id_prod = d.id_prod
WHERE d.val_neto >= 500000
GROUP BY a.nom_area
HAVING SUM(d.val_neto) > 1000000
ORDER BY inversion_total_neto DESC;
```

- **JOIN:** las áreas se unen con sus órdenes, y las órdenes con el detalle de compra por id_prod. Es el único campo que tienen en común estas dos tablas.
- **WHERE:** descarta las líneas de menos de 500.000, para quedarse con montos significativos antes de agrupar.
- **GROUP BY y HAVING:** se agrupa por área y HAVING deja solo las áreas con más de 1.000.000 invertidos, porque ese filtro depende de la suma.
- **ORDER BY DESC:** muestra primero el área que más invirtió.

Como la unión es por producto, una orden se repite por cada línea de factura de ese producto. Por eso el promedio y la suma son una aproximación y no un dato exacto por orden.

## Preguntas de conocimiento teórico-práctico

**P1.** Respuesta: **B) GROUP BY y HAVING.** Se agrupan los errores por proyecto y HAVING COUNT(*) > 10 filtra los grupos. WHERE no sirve porque actúa antes de agrupar.

**P2.** Respuesta: **B) JOIN con condición ON.** Es la forma directa de traer datos de dos tablas relacionadas en una sola fila.

**P3.** Respuesta: **C) Expresión CASE.** Permite escribir la condición (más de 30 días es 'Crítico', si no 'Normal') dentro del SELECT.
