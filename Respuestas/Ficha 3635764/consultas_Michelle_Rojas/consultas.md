# 📊 Reporte de Consultas a la Base de Datos - [Sistema de compras a proveedores]

> [!NOTE]
> **Estudiante:** Michelle Rojas  
> **Programa:** SENA - Análisis y Desarrollo de Software  
> **Ficha:** 3635764  
> **Motor:** PostgreSQL  
> **Fecha:** 8 de Noviembre de 2026
---
> [!IMPORTANT]
> Nivel 1 · Consultas básicas
## Consulta 1: Catálogo de productos activos [SELECT, WHERE, ORDER BY]
-- Lista la referencia y el nombre de los productos activos, ordenados por referencia.
### Código SQL:
```sql
SELECT id_ref, nom_prod
FROM tab_prod
WHERE ind_estado = TRUE
ORDER BY id_ref;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_1" src="https://github.com/user-attachments/assets/b86c1272-e534-4812-a32f-9a5b8679abf1" />

## Consulta 2: Ciudades de un departamento [Filtro por clave foránea]
-- Mostrar las ciudades registradas para Antoquia (código 02).
### Código SQL:
```sql
SELECT id_ciud, nom_ciud
FROM tab_ciud
WHERE id_dpto = '02'
ORDER BY nom_ciud;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_2" src="https://github.com/user-attachments/assets/4384c073-e0d6-4baa-87e1-ddbc6106a349" />

## Consulta 3: Proveedores destacados [Operadores Lógicos AND]
-- Proveedores con cupo de crédito de al menos 5.000.000 y puntaje mínimo de 90.
### Código SQL:
```sql
SELECT nom_comp, val_cupocre, val_puntos
FROM tab_prov
WHERE val_cupocre >=5000000
  AND val_puntos  >=90
ORDER BY val_cupocre DESC;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_3" src="https://github.com/user-attachments/assets/0f7987b6-df45-4a89-826b-1e2a71b5096e" />


## Consulta 4: Búsqueda por patrón de texto [ILIKE y comodines]
-- Productos cuyo nombre contiene <<USB>> o <<Inamlámbrico>>, sin distinguir mayúsculas.
### Código SQL:
```sql
SELECT id_ref, nom_prod
FROM tab_prod
WHERE nom_prod ILIKE  '%usb%'
  OR nom_prod  ILIKE  '%inalámbrico%';
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_4" src="https://github.com/user-attachments/assets/37d7edf9-9d90-458d-94c6-c9efc1d33478" />

> [!IMPORTANT]
> Nivel 2 · Combinación de tablas y agregación
## Consulta 5: Proveedores con su ubicación [INNER JOIN/JOIN de tres tablas]
-- Nombre completo del proveedor con su ciudad y departamento.
### Código SQL:
```sql
SELECT p.nom_com, c.nom_ciud, d.nom_dpto
FROM tab_prov p
JOIN tab_ciud c ON c.ciud_id = p.id_ciud
JOIN tab_dpto d ON d.id_dpto = c.id_dpto
ORDER BY d.nom_dpto, p.nom_com;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_5" src="https://github.com/user-attachments/assets/aabbf3c4-7b71-45b1-9c59-d81b1af53595" />

## Consulta 6: Departamento con pocas ciudades [GROUP BY y HAVING]
-- Departamentos con menos de 8 ciudades registradas.
### Código SQL:
```sql
SELECT d.nom_dpto, COUNT(c.id_ciud) AS ciudades
FROM tab_dpto d
LEFT JOIN tab_ciud c ON c.id_dpto = d.id_dpto
GROUP BY d.nom_dpto
HAVING COUNT (c.id_ciud) <= 8;

```
-- Resultado:
<img width="1919" height="1079" alt="consulta_6" src="https://github.com/user-attachments/assets/1cc18a10-6c83-48fb-89b1-1b04242bea12" />

## Consulta 7: Rango de precios por producto [Funciones de agregación]
-- Para cada producto: número de proveedores, precio mínimo, máximo y promedio.
### Código SQL:
```sql
SELECT pr.nom_prod,
       COUNT(*)                AS proveedores,
       MIN(pp.val_prod)        AS precio_min,
       MAX(pp.val_prod)        AS precio_max,
       ROUNG(AVG(pp.val_prod)) AS precio_prom
FROM tab_prod_prov pp
JOIN tab_prod pr ON pr.id_prod = pp.id_prod
GROUP BY pr.nom_prod
ORDER BY precio_prom DESC;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_7" src="https://github.com/user-attachments/assets/061308f6-96fc-4595-a832-312733c432ea" />

## Consulta 8: Proveedor más económico por producto [subconsulta correlacionada]
-- Para cada producto, el proveedor que ofrece el menor precio.
### Código SQL:
```sql
SELECT pr.nom_prod, p.nom_com, pp.val_prod
FROM tab_prod_prov pp
JOIN tab_prod or ON pr.id_prod = pp.id_prod
JOIN tab_prov p ON p.id_prov = pp.id_prov
WHERE pp.val_prod = (SELECT MIN(x.val_prod)
                     FROM tab_prod_prov x
                     WHERE
ORDER BY pp.val_prod;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_8" src="https://github.com/user-attachments/assets/21ec6e9e-80c2-4f00-8388-b7e57515e4c9" />

## Consulta 9: Total comprado por proveedor [LEFT JOIN, SUM Y COALESCE]
-- Número de facturas y valor neto comprado a cada proveedor (incluye los que aún no tienen detalle).
### Código SQL:
```sql
SELECT p.nom_comp,
       COUNT(DISTINCT e.id_factura)    AS facturas
       COALESCE(SUM(d.val_neto), 0)   AS total_neto
FROM tab_prov p
LEFT JOIN tab_enc_compra e  ON e.id_prov    = p.id_prov
LEFT JOIN tab_det_compra d ON  e.id_factura = e.id_factura
GROUP BY p.nom_comp
ORDER BY total_neto DESC;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_9" src="https://github.com/user-attachments/assets/9256ee52-8f8c-4e82-bad8-6b537fc74c80" />

## Consulta 10: Facturas sin detalle [NOT EXIST (anti-join).
-- Encabezados de factura que no tienen ninguna línea de detalle (información incompleta).
### Código SQL:
```sql
SELECT e.id_factura, e.fec_factura, e.id_prov
FROM tab_enc_compra
WHERE NOT EXIST (SELECT 1
                FROM tab_det_compra d
                WHERE d.id_factura = e.id_factura)
ORDER BY e.id_factura;
```
-- Resultado:
<img width="1919" height="1079" alt="consulta_10" src="https://github.com/user-attachments/assets/4511ebd9-c22a-41eb-a057-340ecef908b4" />

