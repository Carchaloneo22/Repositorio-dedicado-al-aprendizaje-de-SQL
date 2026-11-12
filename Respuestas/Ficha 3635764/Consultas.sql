----------------------------------------------------------
-- Ejercicio 1 : Extrae, muestra columnas y registros de la tabla.
----------------------------------------------------------
SELECT * FROM tab_prov;

----------------------------------------------------------
-- Ejercicio 2 : Filtra filas según una condición.
----------------------------------------------------------
SELECT * FROM tab_prod
WHERE ind_estado = true;

----------------------------------------------------------
-- Ejercicio 3 : Ordena los resultados por alfabeto o numeración.
----------------------------------------------------------
SELECT * FROM tab_prov
ORDER BY nom_prov ASC;

----------------------------------------------------------
-- Ejercicio 4 : Restringe la cantidad máxima de filas.
----------------------------------------------------------
SELECT id_ciud, nom_ciud FROM tab_ciud
LIMIT 10;

----------------------------------------------------------
-- Ejercicio 5 : Cuenta el número de los registros coincidentes.
----------------------------------------------------------
SELECT COUNT(*) AS total_ordenes FROM tab_orden_compra;

----------------------------------------------------------
-- Ejercicio 6 : Suma los valores de la columna.
----------------------------------------------------------
SELECT SUM(val_neto) AS total_acumulado FROM tab_det_compra;

----------------------------------------------------------
-- Ejercicio 7 : Calcula el valor promedio
----------------------------------------------------------
SELECT AVG(val_cupocre) AS promedio_cupo FROM tab_prov;

----------------------------------------------------------
-- Ejercicio 8 : Agrupa filas que comparten un valor
----------------------------------------------------------
SELECT id_dpto, COUNT(*) AS total_ciudades FROM tab_ciud
GROUP BY id_dpto;

----------------------------------------------------------
-- Ejercicio 9 : Agrega un registro a la fila o una tabla.
----------------------------------------------------------
INSERT INTO tab_areas (id_area, nom_area, nom_encarg)
VALUES (9, 'Auditoría', 'Elena Beltrán');

----------------------------------------------------------
-- Ejercicio 10 : Modifica datos existentes en una tabla.
----------------------------------------------------------
UPDATE tab_prov
SET val_puntos = 98
WHERE id_prov = 1000000001;

----------------------------------------------------------
-- Ejercicio 11 : Elimina registros de una tabla.
----------------------------------------------------------
DELETE FROM tab_orden_compra
WHERE id_orden = 100030;

----------------------------------------------------------
-- Ejercicio 12 : Combina información de dos o más tablas relacionadas
----------------------------------------------------------
SELECT c.nom_ciud, d.nom_dpto FROM tab_ciud c
JOIN tab_dptos d ON c.id_dpto = d.id_dpto;

----------------------------------------------------------
-- Ejercicio 13 : Una consulta interna para alimentar el filtro de otra principal.
----------------------------------------------------------
SELECT c.nom_ciud, d.nom_dpto FROM tab_ciud c
JOIN tab_dptos d ON c.id_dpto = d.id_dpto;

----------------------------------------------------------
-- Ejercicio 14 : Aplica condicional (tipo Si/Sino) para mostrar categorías.
----------------------------------------------------------
SELECT id_prov, nom_comp, val_cupocre,
CASE
WHEN val_cupocre >= 5000000 THEN 'Cupo Alto'
WHEN val_cupocre BETWEEN 3000000 AND 4999999 THEN 'Cupo Medio'
ELSE 'Cupo Bajo'
END AS clasificacion_cupo
FROM tab_prov;

----------------------------------------------------------
-- Ejercicio 15 : Une resultados de consultas eliminando duplicados.
----------------------------------------------------------
SELECT id_prod FROM tab_det_orden
UNION
SELECT id_prod FROM tab_det_compra;

----------------------------------------------------------
-- Ejercicio 16 : Resultados de consultas conservando los duplicados.
----------------------------------------------------------
SELECT id_ciud FROM tab_prov
UNION ALL
SELECT id_ciud_entrega FROM tab_enc_compra;

----------------------------------------------------------
-- Ejercicio 17 : Filtra los resultados.
----------------------------------------------------------
SELECT id_factura FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT(*) > 1;

----------------------------------------------------------
-- Ejercicio 18 : Verifica la existencia de registros.
----------------------------------------------------------
SELECT * FROM tab_prov p
WHERE EXISTS (
SELECT 1
FROM tab_enc_compra e
WHERE id_prov = id_prov
);

----------------------------------------------------------
-- Ejercicio 19 : Ubica patrones de texto
----------------------------------------------------------
SELECT FROM tab_prov p
WHERE EXISTS (
SELECT 1
FROM tab_enc_compra e
WHERE id_prov = id_prov
);

----------------------------------------------------------
-- Ejercicio 20 : Filtra valores que se encuentran dentro de un rango determinado.
----------------------------------------------------------
SELECT FROM tab_enc_compra
WHERE fec_factura BETWEEN '2024-02-01' AND '2024-02-29';
