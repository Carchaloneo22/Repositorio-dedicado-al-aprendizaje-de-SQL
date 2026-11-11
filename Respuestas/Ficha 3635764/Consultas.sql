--Ejercicio 1

SELECT * FROM tab_prov;

--Ejercicio 2
SELECT nom_prod FROM tab_prod
WHERE ind_estado=TRUE

--Ejercicio 3

SELECT nom_prov FROM tab_prov
ORDER BY nom_prov ASC;

--Ejeercicio 4

SELECT id_ciud, nom_ciud FROM tab_ciud
LIMIT 10;

--Ejercicio 5

SELECT COUNT (id_orden) FROM tab_orden_compra;

--Ejercicio 6

SELECT SUM (val_neto) FROM tab_det_compra;

--Ejercicio 7

SELECT AVG (val_cupocre) FROM tab_prov;


--Ejercicio 8 

SELECT id_dpto, nom_ciud AS total_ciudades FROM tab_ciud
GROUP BY id_dpto, nom_ciud;

--Ejercicio 9

INSERT INTO tab_areas (id_area, nom_area, nom_ecarg)
VALUES (9, 'Auditoría', 'Elena Beltrán');

--Ejercicio 10

UPDATE tab_prov
SET val_puntos=98
WHERE id_prov = 1000000001;

--Bloque II Ejercicio 11
DELETE FROM tab_orden_compra
WHERE id_orden= 100030;

--Ejercicio 12

SELECT c.nom_ciud, d.nom_dpto FROM tab_ciud AS c
JOIN tab_dptos AS d ON c.id_dpto =d.id_dpto;

--Ejercicio 13
SELECT id_prod FROM tab_prod
WHERE id_prod IN(
SELECT id_prod FROM tab_prod_prov
WHERE val_prod>2000000
);

--Ejercicio 14
SELECT nom_prov, val_cupocre, 
CASE
WHEN val_cupocre>=5000000 THEN 'Cupo alto'
WHEN val_cupocre BETWEEN 3000000 AND 4999999 THEN 'Cupo medio'
ELSE 'Cupo bajo'
END AS cupo_total
FROM tab_prov;

--Ejercicio 15
SELECT id_prod FROM tab_orden_compra
UNION
SELECT id_prod FROM tab_det_compra;

--Ejercicio 16
SELECT id_ciud FROM tab_enc_compra
UNION ALL
SELECT id_ciud FROM tab_prov;


--Ejercicio 17 
SELECT id_factura, COUNT (*) AS total_productos
FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT (*) > 1;


--Ejercicio 18
SELECT nom_prov FROM tab_prov p
WHERE EXISTS (
SELECT 1
FROM tab_enc_compra e
WHERE e.id_prov = p.id_prov
);

--Ejercicio 19
SELECT nom_prov, datos_prov FROM tab_prov
WHERE datos_prov::text LIKE '%tecnosum%'
;

--Ejercicio 20
SELECT fec_factura FROM tab_enc_compra
WHERE fec_factura BETWEEN '2024/02/01'::date AND '2024/02/29'::date;