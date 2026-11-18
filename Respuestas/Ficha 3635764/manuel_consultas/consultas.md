> Nivel 1 · BLOQUE I: CONSULTAS BÁSICAS, FILTROS Y AGREGACIONES (1 - 10)
## Ejercicio 1 (SELECT Básica): Escriba una consulta para seleccionar todos los campos y registros de la tabla de proveedores (tab_prov).
### Código SQL:
```sql
SELECT * FROM tab_prov; 
```
## Ejercicio 2 (SELECT con WHERE): Obtenga todos los productos (tab_prod) cuyo estado (ind_estado) se encuentre activo (true).
### Código SQL:
```sql
SELECT id_prod, nom_prod, ind_estado
FROM tab_prod
WHERE ind_estado  =TRUE;
```
## Ejercicio 3 (SELECT con ORDER BY): Liste los proveedores de la tabla tab_prov ordenados alfabéticamente de forma ascendente por su primer nombre.
### Código SQL:
```sql
SELECT id_prov, nom_com
FROM tab_prov
ORDER BY nom_com;
```
## Ejercicio 4 (SELECT con LIMIT): Muestre únicamente los primeros 10 registros de la tabla de ciudades (tab_ciud), proyectando su ID y nombre.
### Código SQL:
```sql
SELECT id_ciud, nom_ciud
FROM tab_ciud
LIMIT 10;
```
> Nivel 2 · Combinación de tablas y agregación
## Ejercicio 5 (SELECT con COUNT): Obtenga el número total de órdenes de compra (tab_orden_compra) registradas en el sistema.
### Código SQL:
```sql
SELECT COUNT(*) AS total_ordenes
FROM tab_orden_compra;
```
## Ejercicio 6 (SELECT con SUM): Calcule el monto total acumulado del valor neto (val_neto) facturado en la tabla de detalle de compra (tab_det_compra).
### Código SQL:
```sql
SELECT SUM(val_neto)
FROM tab_det_compra;
```
## Ejercicio 7 (SELECT con AVG): Determine el valor promedio del cupo de crédito (val_cupocre) otorgado a los proveedores en tab_prov.
### Código SQL:
```sql
SELECT AVG(val_cupocre)
FROM tab_prov;
```
## Ejercicio 8 (SELECT con GROUP BY): Muestre la cantidad total de ciudades registradas por cada departamento en la tabla tab_ciud.
### Código SQL:
```sql
SELECT d.nom_dpto, COUNT(c.id_ciud) AS total_ciudades
FROM tab_dpto d
JOIN tab_ciud c ON c.id_dpto = d.id_dpto
GROUP d.nom_dpto;
```
## Ejercicio 9 (INSERT): Escriba la sentencia para insertar una nueva área en tab_areas con ID 9, nombre 'Auditoría' y encargada 'Elena Beltrán'.
### Código SQL:
```sql
INSERT INTO tab_areas (id_area, nom_area, nom_encarg)
VALUES (09, 'Auditoría, Elena Beltrán')
```
## Ejercicio 10 (UPDATE): Actualice la cantidad de puntos (val_puntos) a 98 para el proveedor con ID 1000000001 en tab_prov.
### Código SQL:
```sql
UPDATE tab_prov
SET val_puntos
WHERE id_prov = 1000000001;
```
## Ejercicio 11 (DELETE): Elimine el registro de la orden de compra en tab_orden_compra cuyo id_orden sea 100030.    
```sql
DELETE FROM tab_det_orden
WHERE id_orden = 100030;
DELEETE FROM tab_orden_compra
WHERE id_orden = 1000030;
```
## Ejercicio 12 (JOIN): Realice una consulta que combine tab_ciud y tab_dptos para mostrar el nombre de la ciudad y el nombre de su respectivo departamento.
```sql
SELECT c.nom_ciud, d.nom_dpto
FROM tab_ciud c
JOIN tab_dpto d ON d.id_dpto = c.id_dpto
ORDER BY c.nom_ciud;
```
## Ejercicio 13 (Subconsulta): Seleccione todos los productos de tab_prod cuyos IDs estén presentes en tab_prod_prov con un valor del producto (val_prod) superior a 2,000,000.
```sql
SELECT pp.id_prod, p.nom_prod, pp.val_prod
FROM tab_prod_prov pp
JOIN tab_prod p ON p.id_prod = pp.id_prod
WHERE pp.val_prod > 2000000
```
##  Ejercicio 14 (CASE): Clasifique a los proveedores según su cupo de crédito: 'Cupo Alto' (>= 5,000,000), 'Cupo Medio' (3,000,000 a 4,999,999) y 'Cupo Bajo' (< 3,000,000).
```sql
SELECT id_prov, nom_com, val_cupocre,
    CASE 
        WHEN val_cupocre >= 5000000  THEN 'Cupo Alto'
        WHEN val_cupocre    BETWEEN 3000000 AND 4999999 THEN 'Cupo Medio'
        ELSE 'Cupo Bajo'
      END AS clasificacion_cupo
FROM tab_prov
ORDER BY val_cupocre DESC;
```
## Ejercicio 15 (UNION): Combine en un único listado sin duplicados los IDs de los productos pedidos en órdenes de compra y los facturados en detalles de compra.
```sql
SELECT id_prod FROM tab_det_orden
UNION
SELECT id_prod FROM tab_det_compra;
```
## Ejercicio 16 (UNION ALL): Combine en una lista (incluyendo duplicados) los códigos de ciudad asociados a proveedores y los vinculados a encabezados de compra.
```sql
SELECT id_ciud FROM tab_prov
UNION ALL
SELECT id_ciud_entrega FROM tab_enc_compra;
```
## Ejercicio 17 (HAVING): Muestre los IDs de las facturas en tab_det_compra que tengan asociadas más de 1 línea de detalle/producto.
```sql
SELECT id_factura, COUNT(id_prod)
FROM tab_det_compra 
GROUP BY id_factura
HAVING COUNT(*) > 1;
```

## Ejercicio 18 (EXISTS): Seleccione los proveedores en tab_prov que tengan al menos una factura registrada en tab_enc_compra.
```sql
SELECT id_prov, nom_com FROM tab_prov p
WHERE EXISTS (
      SELECT 1 
	  FROM tab_enc_compra e
	  WHERE  e.id_prov = p.id_prov
);
```
## Ejercicio 19 (LIKE): Liste los proveedores cuyo correo electrónico (campo compuesto datos_prov) contenga la subcadena 'tecnosum'.
```sql
SELECT id_prov, nom_com, (datos_prov).correo
FROM tab_prov
WHERE (datos_prov).correo ILIKE '%tecnosum%';
```

## Ejercicio 20 (BETWEEN): Consulte los encabezados de compra (tab_enc_compra) con fecha de factura entre el 1 de febrero de 2024 y el 29 de febrero de 2024.
```sql
SELECT id_factura, id_prov, fec_factura
FROM   tab_enc_compra
WHERE  fec_factura BETWEEN '2024-02-01' AND '2024-02-29';
```
