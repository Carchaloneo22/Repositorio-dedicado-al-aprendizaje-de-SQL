--#############
--# CONSULTAS #
--#############

------------
--BLOQUE I |
------------

--1 CONSULTA
SELECT *FROM tab_prov
--2 CONSULTA
SELECT * FROM tab_prod WHERE ind_estado=TRUE
--3 CONSULTA
SELECT * FROM tab_prov ORDER BY nom_prov ASC
--4 CONSULTA
SELECT (id_ciudad, nom_ciudad) FROM tab_ciudad LIMIT 10
--5 CONSULTA
SELECT COUNT (id_orden) FROM tab_orden_compra
--6 CONSULTA 
SELECT SUM (val_neto) FROM tab_det_compra
--7CONSULTA
SELECT AVG (val_neto) FROM tab_det_compra AS val_promedio 
--8 CONSULTA
SELECT id_dpto, COUNT (id_ciudad) AS total_ciudades FROM tab_ciudad GROUP BY id_dpto
--9 CONSULTA
INSERT INTO tab_areas (id_area, nom_area, nom_encargado) VALUES
('9', 'Auditoría', 'Elena Beltrán')
--10 CONSULTA
UPDATE tab_enc_compra SET id_ciud_entrega = '09101' WHERE id_factura = 'FAC-2026-062'

-------------
--BLOQUE II |
-------------

--11 CONSULTA
DELETE FROM tab_orden_compra WHERE id_orden = '000061'
--12 CONSULTA
SELECT CONCAT(tab_ciudad.nom_ciudad, ' - ', tab_dpto.nom_dpto) AS ciudad_y_dpto 
FROM tab_ciudad 
JOIN tab_dpto ON tab_ciudad.id_dpto = tab_dpto.id_dpto
--13 CONSULTA
SELECT CONCAT(tab_prod.id_prod, ' - ', tab_prod_prov.id_prod) AS prod_y_prov 
FROM tab_prod 
JOIN tab_prod_prov ON tab_prod.id_prod = tab_prod_prov.id_prod
WHERE val_prod > '9000'
--14 CONSULTA
SELECT CONCAT(tab_prod.nom_prod, '-', tab_prod_prov.val_prod) AS nombre_producto,
	CASE
		WHEN val_prod>'10000' THEN 'Producto Suntuoso'
		WHEN val_prod BETWEEN '5000' AND '10000' THEN 'Producto Accesible'
		ELSE 'Producto Económico'
	END AS Categoria_producto
FROM tab_prod_prov
JOIN tab_prod ON tab_prod_prov.id_prod =tab_prod.id_prod
--15 CONSULTA
SELECT id_prod FROM tab_det_orden
UNION
SELECT id_prod FROM tab_det_compra
--16 CONSULTA
SELECT id_ciudad FROM tab_prov
UNION ALL
SELECT id_ciud_entrega FROM tab_enc_compra
--17 CONSULTA
SELECT id_factura
FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT (*) >1
--18 CONSULTA
SELECT CONCAT(tab_prov.nom_prov, ' - ', tab_enc_compra.id_factura) AS Proveedores_Factura 
FROM tab_prov 
JOIN tab_enc_compra ON tab_prov.id_prov = tab_enc_compra.id_prov
--19 CONSULTA
SELECT * FROM tab_prov WHERE email_prov LIKE '%tecnosum%'
--20 CONSULTA
SELECT * FROM tab_enc_compra WHERE fec_factura BETWEEN '2026-01-10' AND '2026-02-10'

--------------
--BLOQUE III |
--------------

