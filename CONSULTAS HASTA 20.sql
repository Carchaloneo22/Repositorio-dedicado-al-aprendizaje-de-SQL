-- TALLER PRACTICO DE SQL --


-- BLOQUE 1: CONSULTAS BASICAS, FILTROS Y AGREGACIONES --


-------------------
-- SELECT BASICA -- 
-------------------
SELECT * 
FROM tab_prov
-------------------


----------------------
-- SELECT con WHERE --
----------------------
SELECT nom_prod, ind_estado
FROM tab_prod
WHERE ind_estado = true;
----------------------


-------------------------
-- SELECT con ORDER BY --
-------------------------
SELECT nom_prov
FROM tab_prov
ORDER BY nom_prov desc;
-------------------------


----------------------
-- SELECT con LIMIT --
----------------------
SELECT id_ciud, nom_ciud
FROM tab_ciud
LIMIT 10;
----------------------


----------------------
-- SELECT CON COUNT --
----------------------
SELECT id_orden
FROM tab_orden_compra
COUNT;
----------------------


--------------------
-- SELECT CON SUM --
--------------------
SELECT SUM (val_neto)	 
FROM tab_det_compra
AS total_valor;
--------------------


--------------------
-- SELECT CON AVG --
--------------------
SELECT AVG (val_cupocre)
FROM tab_prov
AS prom;
--------------------


-------------------------
-- SELECT CON GROUP BY --
-------------------------
SELECT id_dpto, COUNT (id_ciud)
AS total_ciud
FROM tab_ciud
GROUP BY id_dpto;
-------------------------


------------
-- INSERT --
------------
INSERT INTO tab_areas (id_area, nom_area, nom_ecarg) VALUES 
('9', 'Auditoria', 'Elena Beltran');
------------


------------
-- UPDATE --
------------
UPDATE tab_prov 
SET val_puntos = '98'
WHERE id_prov = '1000000001';
------------

-- BLOQUE II: MODIFICACIONES, JOINS Y SUBCONSULTAS --


------------
-- DELETE --
------------
DELETE FROM tab_orden_compra WHERE id_orden = 100030;
------------


----------
-- JOIN --
----------
SELECT CONCAT(tab_ciud.nom_ciud, ' - ', tab_dptos.nom_dpto) AS ciud_y_dpto
FROM tab_ciud
JOIN tab_dptos ON tab_ciud.id_dpto = tab_dptos.id_dpto;
----------


-----------------
-- SUBCONSULTA --
-----------------
SELECT CONCAT(tab_prod.id_prod, '-', tab_prod_prov.id_prod) AS tod_y_prov
FROM tab_prod
JOIN tab_prod_prov ON tab_prod.id_prod = tab_prod_prov.id_prod
WHERE val_prod > 2000000;
-----------------


----------
-- CASE -- 
----------
SELECT id_prov, val_cupocre,
	CASE 
		WHEN val_cupocre >= 5000000 THEN 'Cupo Alto'
		WHEN val_cupocre BETWEEN 3000000 AND 4999999 THEN 'Cupo Medio'
		ELSE 'Cupo Bajo'
	END AS cupo_cre
FROM tab_prov;
-----------


-----------
-- UNION --
-----------
SELECT id_factura FROM tab_det_compra
UNION 
SELECT id_orden FROM tab_orden_compra
-----------


---------------
-- UNION ALL --
---------------
SELECT id_ciud FROM tab_prov
UNION ALL 
SELECT id_ciud FROM tab_enc_compra
---------------

------------
-- HAVING --
------------
SELECT id_factura
FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT(id_prod) > 1
ORDER BY id_factura DESC;
------------


------------
-- EXISTS --
------------
SELECT nom_prov
FROM tab_prov
WHERE EXISTS (
SELECT 1
FROM tab_enc_compra
WHERE id_prov = id_prov);
-------------


----------
-- LIKE --
----------
SELECT datos_prov
FROM tab_prov
WHERE datos_prov:: text LIKE '%tecnosum%';
----------


-------------
-- BETWEEN --
-------------
SELECT fec_factura FROM tab_enc_compra
WHERE fec_factura BETWEEN '2024/02/01'::date AND '2024/02/29'::date;
-------------