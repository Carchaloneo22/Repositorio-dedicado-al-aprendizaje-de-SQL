-------------------------
--| COMPRAS PROVEEDORES |
-------------------------

--LIMPIEZA DE DATOS

DROP TABLE tab_det_orden;
DROP TABLE tab_orden_compra;
DROP TABLE tab_areas;
DROP TABLE tab_det_compra;
DROP TABLE tab_prod_prov;
DROP TABLE tab_prod;
DROP TABLE tab_pagos;
DROP TABLE tab_enc_compra;
DROP TABLE tab_prov;
DROP TABLE tab_param;
DROP TABLE tab_ciudad;
DROP TABLE tab_dpto;

--**TABLAS**

-------------------------
--| DATOS DEPARTAMENTOS |
-------------------------

CREATE TABLE tab_dpto
(
	id_dpto			DECIMAL (3)			NOT NULL,
	nom_dpto		VARCHAR (15)		NOT NULL,
	CONSTRAINT pk_id_dpto PRIMARY KEY (id_dpto)
);

--------------------
--| DATOS CIUDADES |
--------------------

CREATE TABLE tab_ciudad
(
	id_ciudad		DECIMAL (5)			NOT NULL,
	nom_ciudad		VARCHAR (30)		NOT NULL,
	id_dpto			DECIMAL (3)			NOT NULL,
	CONSTRAINT pk_id_ciudad PRIMARY KEY (id_ciudad), 
	CONSTRAINT fk_id_dpto 	FOREIGN KEY (id_dpto) REFERENCES tab_dpto (id_dpto) 
);

---------------------------
--| PARAMETROS PARA PAGOS |
---------------------------

CREATE TABLE tab_param
(
	id_empresa		DECIMAL(10)			NOT NULL,
	dia_pagos1		SMALLINT			NOT NULL,
	dia_pagos2		SMALLINT			NOT NULL,
	dia_pagos3		SMALLINT			NOT NULL,
	num_orden		DECIMAL (6)			NOT NULL,
	CONSTRAINT pk_id_empresa PRIMARY KEY (id_empresa)
);

-----------------------
--| DATOS PROVEEDORES |
-----------------------

CREATE TABLE tab_prov
(
	id_prov			DECIMAL(10)			NOT NULL,
	nom_prov		VARCHAR (20)		NOT NULL,
	ape1_prov		VARCHAR (15)		NOT NULL,
	ape2_prov		VARCHAR (15)		NOT NULL,
	nom_completo	VARCHAR(50) 		GENERATED ALWAYS  AS (nom_prov || ' ' || ape1_prov || ' ' || ape2_prov),
	dir_prov		VARCHAR (50)		NOT NULL,
	tel_prov		VARCHAR (50)		NOT NULL,
	email_prov		VARCHAR (60)		NOT NULL,
	id_ciudad		DECIMAL (5)			NOT NULL,
	CONSTRAINT 	pk_id_prov PRIMARY KEY (id_prov),
	CONSTRAINT	uk_email_prov UNIQUE (email_prov),
	CONSTRAINT  fk_id_ciudad FOREIGN KEY (id_ciudad) REFERENCES tab_ciudad (id_ciudad)
);

----------------------
--| ENCONTRAR COMPRA |
----------------------

CREATE TABLE tab_enc_compra
(
	id_factura		VARCHAR (12) 		NOT NULL,
	fec_factura		DATE				NOT NULL,
	id_prov			DECIMAL (10)		NOT NULL,
	id_ciud_entrega DECIMAL (5)			NOT NULL,
	CONSTRAINT pk_id_factura PRIMARY KEY (id_factura),
	CONSTRAINT fk_id_prov FOREIGN KEY (id_prov) REFERENCES tab_prov (id_prov),
	CONSTRAINT fk_id_ciudad_entrega FOREIGN KEY (id_ciud_entrega) REFERENCES tab_ciudad (id_ciudad)
);

--------------------
--| TABLA DE PAGOS |
--------------------

CREATE TABLE tab_pagos
(
	id_pago			VARCHAR (10)		NOT NULL,
	id_factura		VARCHAR (10)		NOT NULL,
	fec_pago		DATE				NOT NULL,
	val_pago		DECIMAL (10)		NOT NULL,
	CONSTRAINT pk_id_pago PRIMARY KEY (id_pago),
	CONSTRAINT fk_id_factura FOREIGN KEY (id_factura) REFERENCES tab_enc_compra (id_factura)
);

--------------------------
--| CONTROL DE PRODUCTOS |
--------------------------

CREATE TABLE tab_prod
(
	id_prod			VARCHAR (14) 		NOT NULL,
	id_ref			INT 				GENERATED ALWAYS AS IDENTITY,
	nom_prod		VARCHAR (40)		NOT NULL,
	ind_estado		BOOLEAN 			DEFAULT TRUE,
	CONSTRAINT pk_id_prod PRIMARY KEY (id_prod)
);

---------------------------------
--| SOLUCIÓN DE N:M PROD Y PROV |
---------------------------------

CREATE TABLE tab_prod_prov
(
	id_prod			VARCHAR (14)		NOT NULL,
	id_prov			DECIMAL(10)			NOT NULL,
	val_prod		DECIMAL(10)			NOT NULL,
	ind_disp		BOOLEAN				DEFAULT TRUE,
	FOREIGN KEY (id_prod) REFERENCES tab_prod (id_prod) ON DELETE CASCADE,
	FOREIGN KEY (id_prov) REFERENCES tab_prov (id_prov) ON DELETE CASCADE
);

-----------------------------------
--| SOLUCIÓN DE N:M COMPRA Y PROD |
-----------------------------------

CREATE TABLE tab_det_compra
(
	id_factura		VARCHAR (12)		NOT NULL,
	id_prod			VARCHAR (14)		NOT NULL,
	val_cant		DECIMAL (12,2)		NOT NULL,
	val_unit		DECIMAL (12,2)		NOT NULL,
	val_descu		DECIMAL (12,2)		NOT NULL,
	porc_iva		DECIMAL (5,2)		NOT NULL,
	val_bruto		DECIMAL (12)		GENERATED ALWAYS  AS (val_cant * val_unit),
	val_iva 		DECIMAL (5,2) 		GENERATED ALWAYS AS (((val_cant * val_unit) - val_descu) * (porc_iva / 100.0)),
	val_neto 		DECIMAL (12)		GENERATED ALWAYS AS (((val_cant * val_unit) - val_descu) + (((val_cant * val_unit) - val_descu) * (porc_iva / 100.0))),
	CONSTRAINT pk_det_compra PRIMARY KEY (id_factura, id_prod),
	CONSTRAINT fk_id_factura FOREIGN KEY (id_factura) REFERENCES tab_enc_compra (id_factura),
	CONSTRAINT fk_id_prod FOREIGN KEY (id_prod) REFERENCES tab_prod (id_prod)
);

--------------------
--| TABLA DE AREAS |
--------------------

CREATE TABLE tab_areas
(
	id_area			DECIMAL (3)			NOT NULL,
	nom_area		VARCHAR (32)		NOT NULL,
	nom_encargado	VARCHAR (32)		NOT NULL,
	CONSTRAINT pk_id_area PRIMARY KEY (id_area)
);

-------------------------
--| TABLA ORDEN COMPRAS |
-------------------------

CREATE TABLE tab_orden_compra
(
	id_orden		DECIMAL (6)			NOT NULL,
	fec_orden		DATE				NOT NULL,
	id_area			DECIMAL (3)			NOT NULL,
	CONSTRAINT pk_id_orden PRIMARY KEY (id_orden),
	FOREIGN KEY (id_area) REFERENCES tab_areas (id_area) ON UPDATE CASCADE ON DELETE RESTRICT
);

-----------------------------------
--| SOLUCIÓN DE N:M COMPRA Y PROD |
-----------------------------------

CREATE TABLE tab_det_orden
(
	id_orden		DECIMAL (6)			NOT NULL,
	id_prod			VARCHAR (14)		NOT NULL,
	val_cant		DECIMAL (12)		NOT NULL,
	CONSTRAINT pk_det_orden PRIMARY KEY (id_orden, id_prod),
	CONSTRAINT fk_id_orden FOREIGN KEY (id_orden) REFERENCES tab_orden_compra (id_orden),
	CONSTRAINT fk_id_prod FOREIGN KEY (id_prod) REFERENCES tab_prod (id_prod)
);