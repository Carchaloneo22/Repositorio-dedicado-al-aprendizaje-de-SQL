# 📊 Reporte de Consultas a la Base de Datos - [Sistema de compras a proveedores]

> [!NOTE]
> **Estudiante:** Michelle Rojas  
> **Programa:** SENA - Análisis y Desarrollo de Software  
> **Ficha:** 3635764  
> **Motor:** PostgreSQL  
> **Fecha:** 8 de Noviembre de 2026
---
> [!IMPORTANT]
> Nivel 1 · BLOQUE I: CONSULTAS BÁSICAS, FILTROS Y AGREGACIONES (1 - 10)
## Ejercicio 1 (SELECT Básica): Escriba una consulta para seleccionar todos los campos y registros de la tabla de
proveedores (tab_prov).
### Código SQL:
```sql
SELECT * FROM tab_prov; 
```
> [!IMPORTANT]
> Este tipo de consulta es básica y demostrativa, mala práctica en entornos de desarrollo real! (SQL injection).<img width="1919" height="1079" alt="CONSULTA 2" src="https://github.com/user-attachments/assets/24aa2d10-d9ec-4965-9874-f84ac4387c83" />

-- Resultado:


## Ejercicio 2 (SELECT con WHERE): Obtenga todos los productos (tab_prod) cuyo estado (ind_estado) se
encuentre activo (true).
### Código SQL:
```sql
SELECT id_prod, nom_prod, ind_estado
FROM tab_prod
WHERE ind_estado  =TRUE;
```
-- Resultado:
![Uploading CONSULTA 2.png…]()


## Ejercicio 3 (SELECT con ORDER BY): Liste los proveedores de la tabla tab_prov ordenados alfabéticamente de
forma ascendente por su primer nombre.
### Código SQL:
```sql
SELECT id_prov, nom_com
FROM tab_prov
ORDER BY nom_com;
```
-- Resultado:

<img width="1919" height="1079" alt="consulta_3" src="https://github.com/user-attachments/assets/80e3f866-5373-4b6a-b767-e645c6d95a4b" />


## Ejercicio 4 (SELECT con LIMIT): Muestre únicamente los primeros 10 registros de la tabla de ciudades
(tab_ciud), proyectando su ID y nombre.
### Código SQL:
```sql
SELECT id_ciud, nom_ciud
FROM tab_ciud
LIMIT 10;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_4" src="https://github.com/user-attachments/assets/fd80a4e5-18be-4d4d-989a-4d990d8ab9da" />


> [!IMPORTANT]
> Nivel 2 · Combinación de tablas y agregación
## Ejercicio 5 (SELECT con COUNT): Obtenga el número total de órdenes de compra (tab_orden_compra)
registradas en el sistema.
### Código SQL:
```sql
SELECT COUNT(*) AS total_ordenes
FROM tab_orden_compra;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_5" src="https://github.com/user-attachments/assets/fd6d3449-f40b-4179-9e3c-e75eeb70c176" />


## Ejercicio 6 (SELECT con SUM): Calcule el monto total acumulado del valor neto (val_neto) facturado en la tabla
de detalle de compra (tab_det_compra).
### Código SQL:
```sql
SELECT SUM(val_neto)
FROM tab_det_compra;
```
-- Resultado:

<img width="1919" height="1079" alt="consulta_6" src="https://github.com/user-attachments/assets/5cf3ece4-1c7a-434e-bdf6-ef07c5f06015" />

## Ejercicio 7 (SELECT con AVG): Determine el valor promedio del cupo de crédito (val_cupocre) otorgado a los
proveedores en tab_prov.
### Código SQL:
```sql
SELECT AVG(val_cupocre)
FROM tab_prov;
```
-- Resultado:

<img width="1883" height="1079" alt="consulta_7" src="https://github.com/user-attachments/assets/3201a044-6942-430a-a753-9f72809a6c58" />

## Ejercicio 8 (SELECT con GROUP BY): Muestre la cantidad total de ciudades registradas por cada departamento
en la tabla tab_ciud.
### Código SQL:
```sql
SELECT d.nom_dpto, COUNT(c.id_ciud) AS total_ciudades
FROM tab_dpto d
JOIN tab_ciud c ON c.id_dpto = d.id_dpto
GROUP d.nom_dpto;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_8" src="https://github.com/user-attachments/assets/68795c5e-6805-4f14-954b-fede320ba6a5" />


## Ejercicio 9 (INSERT): Escriba la sentencia para insertar una nueva área en tab_areas con ID 9, nombre
'Auditoría' y encargada 'Elena Beltrán'.
### Código SQL:
```sql
INSERT INTO tab_areas (id_area, nom_area, nom_encarg)
VALUES (09, 'Auditoría, Elena Beltrán')
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_9" src="https://github.com/user-attachments/assets/a7af6fd2-7df0-4775-b6b7-c258fd26a00d" />


## Ejercicio 10 (UPDATE): Actualice la cantidad de puntos (val_puntos) a 98 para el proveedor con ID
1000000001 en tab_prov.
### Código SQL:
```sql
UPDATE tab_prov
SET val_puntos
WHERE id_prov = 1000000001;
```
-- Resultado:

<img width="1918" height="1079" alt="update_10" src="https://github.com/user-attachments/assets/ab1d3bcb-2b7a-4e64-8d15-6721ec89ba94" />

## Ejercicio 11 (DELETE): Elimine el registro de la orden de compra en tab_orden_compra cuyo id_orden sea
100030.    
```sql
DELETE FROM tab_det_orden
WHERE id_orden = 100030;
DELEETE FROM tab_orden_compra
WHERE id_orden = 1000030;
```
-- Resultado:
<img width="1919" height="1079" alt="delete_11" src="https://github.com/user-attachments/assets/fc7cec08-2854-4c74-81b6-df43bcd94a31" />

## Ejercicio 12 (JOIN): Realice una consulta que combine tab_ciud y tab_dptos para mostrar el nombre de la
ciudad y el nombre de su respectivo departamento.
```sql
SELECT c.nom_ciud, d.nom_dpto
FROM tab_ciud c
JOIN tab_dpto d ON d.id_dpto = c.id_dpto
ORDER BY c.nom_ciud;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_12" src="https://github.com/user-attachments/assets/3d5a8ad2-9593-4091-b944-1938bb500ea5" />

## Ejercicio 13 (Subconsulta): Seleccione todos los productos de tab_prod cuyos IDs estén presentes en
tab_prod_prov con un valor del producto (val_prod) superior a 2,000,000.
```sql
SELECT pp.id_prod, p.nom_prod, pp.val_prod
FROM tab_prod_prov pp
JOIN tab_prod p ON p.id_prod = pp.id_prod
WHERE pp.val_prod > 2000000
```
-- Resultado:

<img width="1913" height="1075" alt="consulta_13" src="https://github.com/user-attachments/assets/b21913a5-cc28-4154-baa5-b1f543ec2aaa" />

##  Ejercicio 14 (CASE): Clasifique a los proveedores según su cupo de crédito: 'Cupo Alto' (>= 5,000,000), 'Cupo
Medio' (3,000,000 a 4,999,999) y 'Cupo Bajo' (< 3,000,000).
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
-- Resultado:
<img width="1916" height="1077" alt="consulta_14" src="https://github.com/user-attachments/assets/f5cbf0ca-0fc7-43ca-97d0-6d11a9f949a8" />

## Ejercicio 15 (UNION): Combine en un único listado sin duplicados los IDs de los productos pedidos en órdenes
de compra y los facturados en detalles de compra.
```sql
SELECT id_prod FROM tab_det_orden
UNION
SELECT id_prod FROM tab_det_compra;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_15" src="https://github.com/user-attachments/assets/bf2f8eb3-28ef-47d7-a809-0937431c92f5" />

## Ejercicio 16 (UNION ALL): Combine en una lista (incluyendo duplicados) los códigos de ciudad asociados a
proveedores y los vinculados a encabezados de compra.
```sql
SELECT id_ciud FROM tab_prov
UNION ALL
SELECT id_ciud_entrega FROM tab_enc_compra;
```
-- Resultado:
<img width="1912" height="1080" alt="consulta_16" src="https://github.com/user-attachments/assets/7ba3cd7e-d2e4-4945-92e3-8be32ea5bc3a" />

## Ejercicio 17 (HAVING): Muestre los IDs de las facturas en tab_det_compra que tengan asociadas más de 1
línea de detalle/producto.
```sql
SELECT id_factura, COUNT(id_prod)
FROM tab_det_compra 
GROUP BY id_factura
HAVING COUNT(*) > 1;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_17" src="https://github.com/user-attachments/assets/cb99f6d5-0d43-42e6-827c-8989016f207a" />

## Ejercicio 18 (EXISTS): Seleccione los proveedores en tab_prov que tengan al menos una factura registrada en
tab_enc_compra.
```sql
SELECT id_prov, nom_com FROM tab_prov p
WHERE EXISTS (
      SELECT 1 
	  FROM tab_enc_compra e
	  WHERE  e.id_prov = p.id_prov
);
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_18" src="https://github.com/user-attachments/assets/2cb01223-bcbd-4eb0-977c-8f4de34c47e7" />

## Ejercicio 19 (LIKE): Liste los proveedores cuyo correo electrónico (campo compuesto datos_prov) contenga la
subcadena 'tecnosum'.
```sql
SELECT id_prov, nom_com, (datos_prov).correo
FROM tab_prov
WHERE (datos_prov).correo ILIKE '%tecnosum%';
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_19" src="https://github.com/user-attachments/assets/ca222346-610e-4210-91a5-dca5e7a8b491" />

## Ejercicio 20 (BETWEEN): Consulte los encabezados de compra (tab_enc_compra) con fecha de factura entre el
1 de febrero de 2024 y el 29 de febrero de 2024.
```sql
SELECT id_factura, id_prov, fec_factura
FROM   tab_enc_compra
WHERE  fec_factura BETWEEN '2024-02-01' AND '2024-02-29';
```
<img width="1919" height="1079" alt="consulta_20" src="https://github.com/user-attachments/assets/a504904d-d84a-4558-9c92-02bd321913fb" />


