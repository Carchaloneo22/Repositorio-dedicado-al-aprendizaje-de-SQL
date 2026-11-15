ROLLBACK;
--...................................................................
-- Limpieza (CASCADE elimina también vistas y triggers dependientes).
--...................................................................

DROP TABLE IF EXISTS 	tab_pagos,
						tab_det_compra,
						tab_enc_compra,
 						tab_det_orden, 
 						tab_orden_compra,
						tab_prod_prov,
						tab_prov,
 						tab_area,
 						tab_prod,
 						tab_ciud,
 						tab_dptos,
 						tab_pmtros 					CASCADE;
						 
DROP FUNCTION IF EXISTS fn_valida_det_compra() 		CASCADE;
DROP FUNCTION IF EXISTS fn_valida_pago()			CASCADE;
--....................................................................
-- 							Fin de la limpieza.
--....................................................................

--...........................................................................................
-- 							1. Parámetros generales de la empresa
--...........................................................................................

CREATE TABLE tab_pmtros		(

 id_empresa			DECIMAL(10,0) 		NOT NULL,
 dia_pagos1 		SMALLINT 			NOT NULL, -- día de la semana: 1=lunes ... 7=domingo
 dia_pagos2 		SMALLINT 			NOT NULL,
 dia_pagos3 		SMALLINT 			NOT NULL,
 num_orden 			DECIMAL(6,0) 		NOT NULL, -- consecutivo de órdenes de compra
 CONSTRAINT pk_pmtros 					PRIMARY KEY (id_empresa),
 CONSTRAINT ck_pmtros_id 				CHECK (id_empresa > 0),
 CONSTRAINT ck_pmtros_dias 				CHECK (dia_pagos1 		BETWEEN 1 AND 7
 										AND dia_pagos2 			BETWEEN 1 AND 7
										AND dia_pagos3 			BETWEEN 1 AND 7
 										AND dia_pagos1 < dia_pagos2
										AND dia_pagos2 < dia_pagos3),
 CONSTRAINT ck_pmtros_orden 			CHECK (num_orden > 0)
);

--..........................................................................................
-- 						Fin de los parámetros generales de la empresa
--..........................................................................................

--......................................................................
-- 							2. Departamentos
--......................................................................

CREATE TABLE tab_dptos(

 id_dpto 			VARCHAR(2) 			NOT NULL,
 nom_dpto 			VARCHAR(30) 		NOT NULL,
 
 CONSTRAINT pk_dptos					PRIMARY KEY (id_dpto),
 CONSTRAINT uq_dptos_nombre				UNIQUE (nom_dpto),
 CONSTRAINT ck_dptos_id 				CHECK (id_dpto ~ '^[0-9]{2}$'),
 CONSTRAINT ck_dptos_nombre 			CHECK (BTRIM(nom_dpto) <> '')
);

--.......................................................................
-- 							Fin de Departamentos
--.......................................................................

--.......................................................................
-- 3. Ciudades (el código de la ciudad empieza por el código del dpto.)
--.......................................................................

CREATE TABLE tab_ciud (
id_ciud 		VARCHAR(5) 			NOT NULL,
nom_ciud 		VARCHAR(30) 			NOT NULL,
id_dpto 		VARCHAR(2) 				NOT NULL,

 CONSTRAINT pk_ciud 					PRIMARY KEY (id_ciud),
 CONSTRAINT fk_ciud_dpto 				FOREIGN KEY (id_dpto)
 REFERENCES tab_dptos (id_dpto)
 ON UPDATE CASCADE ON DELETE RESTRICT,
 CONSTRAINT uq_ciud_nombre 				UNIQUE (id_dpto, nom_ciud),
 CONSTRAINT ck_ciud_id 					CHECK (id_ciud ~ '^[0-9]{5}$'),
 CONSTRAINT ck_ciud_prefijo 			CHECK (LEFT(id_ciud, 2) = id_dpto),
 CONSTRAINT ck_ciud_nombre 				CHECK (BTRIM(nom_ciud) <> '')
);

--........................................................................
-- 						Fin de la tabla de ciudad
--........................................................................

--.......................................................................................................
-- 						4. Proveedores (datos de contacto atómicos: cumple 1FN)
--.......................................................................................................

CREATE TABLE tab_prov(
 id_prov DECIMAL(10,0) 					NOT NULL,
 nom_prov VARCHAR(30) 					NOT NULL,
 ape1_prov VARCHAR(20)					NOT NULL,
 ape2_prov VARCHAR(20),
 nom_comp VARCHAR(80) 					GENERATED ALWAYS AS
 (nom_prov || ' ' || ape1_prov || 		COALESCE(' ' || ape2_prov, ''))
 STORED,
 dir_prov VARCHAR(100) 					NOT NULL,
 tel_prov VARCHAR(10) 					NOT NULL,
 email_prov VARCHAR(100) 				NOT NULL,
 id_ciud VARCHAR(5) 					NOT NULL,
 val_cupocre DECIMAL(12,0) 				NOT NULL DEFAULT 0,
 val_puntos DECIMAL(3,0) 				NOT NULL DEFAULT 0,
 num_fact DECIMAL(6,0) 					NOT NULL,
 ind_estado BOOLEAN 					NOT NULL DEFAULT TRUE,
 CONSTRAINT pk_prov 					PRIMARY KEY (id_prov),
 CONSTRAINT fk_prov_ciud 				FOREIGN KEY (id_ciud)
 REFERENCES tab_ciud (id_ciud)
 ON UPDATE CASCADE ON DELETE RESTRICT,
 CONSTRAINT uq_prov_email 				UNIQUE (email_prov),
 CONSTRAINT ck_prov_id 					CHECK (id_prov > 0),
 CONSTRAINT ck_prov_tel 				CHECK (tel_prov ~ '^(60[124-8]|3[0-9]{2})[0-9]{7}$'),
 CONSTRAINT ck_prov_email 				CHECK (email_prov ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'),
 CONSTRAINT ck_prov_cupo 				CHECK (val_cupocre >= 0),
 CONSTRAINT ck_prov_puntos 				CHECK (val_puntos BETWEEN 0 AND 100),
 CONSTRAINT ck_prov_fact 				CHECK (num_fact > 0)
);

--.......................................................................................................
-- 										Fin de la tabla de provedores
--.......................................................................................................

--........................................................................
-- 							5. Productos
--........................................................................

CREATE TABLE tab_prod (
 id_prod SMALLINT 						NOT NULL,
 id_ref VARCHAR(10) 					NOT NULL,
 nom_prod VARCHAR(50) 					NOT NULL,
 ind_estado BOOLEAN 					NOT NULL DEFAULT TRUE,
 CONSTRAINT pk_prod 					PRIMARY KEY (id_prod),
 CONSTRAINT uq_prod_ref 				UNIQUE (id_ref),
 CONSTRAINT ck_prod_id 					CHECK (id_prod > 0),
 CONSTRAINT ck_prod_ref 				CHECK (id_ref ~ '^PROD[0-9]{3}$'),
 CONSTRAINT ck_prod_nombre 				CHECK (BTRIM(nom_prod) <> '')
);

--........................................................................
-- 						Fin de la tabla de productos
--........................................................................

--........................................................................
-- 							6. Productos
--........................................................................

CREATE TABLE tab_prod_prov (
 id_prov DECIMAL(10,0) 					NOT NULL,
 id_prod SMALLINT 						NOT NULL,
 val_prod DECIMAL(10,0) 				NOT NULL,
 ind_disp BOOLEAN 						NOT NULL DEFAULT TRUE,
 CONSTRAINT pk_prod_prov 				PRIMARY KEY (id_prov, id_prod),
 CONSTRAINT fk_prodprov_prov 			FOREIGN KEY (id_prov)
 REFERENCES tab_prov (id_prov) 			ON DELETE RESTRICT,
 CONSTRAINT fk_prodprov_prod 			FOREIGN KEY (id_prod)
 REFERENCES tab_prod (id_prod)			ON DELETE RESTRICT,
 CONSTRAINT ck_prodprov_valor			CHECK (val_prod > 0)
);

--.........................................................................
-- 						Fin de la tabla de productos
--.........................................................................

--.........................................................................
-- 						7. Áreas de la empresa
--.........................................................................

CREATE TABLE tab_area (
 id_area DECIMAL(2,0) 					NOT NULL,
 nom_area VARCHAR(50) 					NOT NULL,
 nom_encarg VARCHAR(80) 				NOT NULL,
 CONSTRAINT pk_areas 					PRIMARY KEY (id_area),
 CONSTRAINT uq_areas_nombre 			UNIQUE (nom_area),
 CONSTRAINT ck_areas_id 				CHECK (id_area > 0)
);

--..........................................................................
-- 						Fin de la tabla de empresa
--..........................................................................

--..........................................................................
-- 8. Órdenes de compra: encabezado + detalle (una orden, varios productos)
--..........................................................................

CREATE TABLE tab_orden_compra (
 id_orden_compra DECIMAL(6,0) 			NOT NULL,
 fec_orden TIMESTAMP 					NOT NULL DEFAULT CURRENT_TIMESTAMP,
 id_area DECIMAL(2,0) 					NOT NULL,
 CONSTRAINT pk_orden 					PRIMARY KEY (id_orden_compra),
 CONSTRAINT fk_orden_area 				FOREIGN KEY (id_area)
 REFERENCES tab_area (id_area) 			ON DELETE RESTRICT,
 CONSTRAINT ck_orden_id 				CHECK (id_orden_compra > 0)
);

--...................................................................................
-- 						9. Tabla de departamento de area.
--...................................................................................

CREATE TABLE tab_det_orden (
 id_orden DECIMAL(6,0) 								NOT NULL,
 id_prod SMALLINT 									NOT NULL,
 val_cant SMALLINT 									NOT NULL,
 CONSTRAINT pk_det_orden 							PRIMARY KEY (id_orden, id_prod),
 CONSTRAINT fk_detorden_orden 						FOREIGN KEY (id_orden)
 REFERENCES tab_orden_compra (id_orden_compra) 		ON DELETE CASCADE,
 CONSTRAINT fk_detorden_prod 						FOREIGN KEY (id_prod)
 REFERENCES tab_prod (id_prod) 						ON DELETE RESTRICT,
 CONSTRAINT ck_detorden_cant 						CHECK (val_cant > 0)
);

--...................................................................................
-- 							Fin de departamento de area.
--...................................................................................

--.................................................................................
-- 						10. Facturas de compra: encabezado
--.................................................................................

CREATE TABLE tab_enc_compra(
 id_factura DECIMAL(6,0) 			NOT NULL,
 fec_factura DATE 					NOT NULL DEFAULT CURRENT_DATE,
 id_prov DECIMAL(10,0) 				NOT NULL,
 id_ciud_entrega VARCHAR(5) 		NOT NULL, -- ciudad donde se recibe la compra
 val_observa TEXT,
 CONSTRAINT pk_enc_compra 			PRIMARY KEY (id_factura),
 CONSTRAINT fk_enc_prov 			FOREIGN KEY (id_prov)
 REFERENCES tab_prov (id_prov) 		ON DELETE RESTRICT,
 CONSTRAINT fk_enc_ciud 			FOREIGN KEY (id_ciud_entrega)
 REFERENCES tab_ciud (id_ciud) 		ON DELETE RESTRICT,
 CONSTRAINT ck_enc_id 				CHECK (id_factura > 0),
 CONSTRAINT ck_enc_fecha 			CHECK (fec_factura >= DATE '2000-01-01')
);

--...............................................................................
-- 							Fin de facturas de compra.
--...............................................................................

--...............................................................................................
--				 11. Facturas de compra: detalle (bruto, IVA y neto se CALCULAN)
--...............................................................................................

CREATE TABLE tab_det_compra(
 id_factura DECIMAL(6,0) 						NOT NULL,
 id_prod SMALLINT 								NOT NULL,
 val_cant SMALLINT 								NOT NULL,
 val_unit DECIMAL(10,0) 						NOT NULL,
 val_descu DECIMAL(12,0) 						NOT NULL DEFAULT 0,
 porc_iva DECIMAL(4,2) 							NOT NULL DEFAULT 19,
 val_bruto DECIMAL(12,0) 						GENERATED ALWAYS AS (val_cant * val_unit) STORED,
 val_iva DECIMAL(12,0) 							GENERATED ALWAYS AS
 (ROUND((val_cant * val_unit - val_descu) * porc_iva / 100)) STORED,
 val_neto DECIMAL(12,0) 						GENERATED ALWAYS AS
 (val_cant * val_unit - val_descu
 + ROUND((val_cant * val_unit - val_descu) * porc_iva / 100)) STORED,
 CONSTRAINT pk_det_compra 						PRIMARY KEY (id_factura, id_prod),
 CONSTRAINT fk_detcomp_enc 						FOREIGN KEY (id_factura)
 REFERENCES tab_enc_compra (id_factura) 		ON DELETE CASCADE,
 CONSTRAINT fk_detcomp_prod 					FOREIGN KEY (id_prod)
 REFERENCES tab_prod (id_prod) 					ON DELETE RESTRICT,
 CONSTRAINT ck_detcomp_cant 					CHECK (val_cant > 0),
 CONSTRAINT ck_detcomp_unit 					CHECK (val_unit > 0),
 CONSTRAINT ck_detcomp_descu 					CHECK (val_descu >= 0
 AND val_descu <= val_cant * val_unit),
 CONSTRAINT ck_detcomp_iva 						CHECK (porc_iva IN (0, 5, 19))
);

--...................................................................
-- Fin de tabla de compras.
--...................................................................

--...................................................................
-- 12. Pagos (el saldo NO se almacena: se calcula en la vista)
--...................................................................

CREATE TABLE tab_pagos (
 id_factura DECIMAL(6,0) 						NOT NULL,
 id_pago SMALLINT 								NOT NULL,
 fec_pago DATE 									NOT NULL,
 val_pago DECIMAL(12,0) 						NOT NULL,
 CONSTRAINT pk_pagos 							PRIMARY KEY (id_factura, id_pago),
 CONSTRAINT fk_pagos_enc 						FOREIGN KEY (id_factura)
 REFERENCES tab_enc_compra (id_factura) 		ON DELETE RESTRICT,
 CONSTRAINT ck_pagos_id 						CHECK (id_pago > 0),
 CONSTRAINT ck_pagos_valor 						CHECK (val_pago > 0)
);

--...................................................................
-- Fin de tabla de pagos.
--...................................................................


-- Índices de apoyo para las claves foráneas más consultadas
CREATE INDEX idx_ciud_dpto 		ON tab_ciud (id_dpto);
CREATE INDEX idx_prov_ciud 		ON tab_prov (id_ciud);
CREATE INDEX idx_enc_prov 		ON tab_enc_compra (id_prov);
CREATE INDEX idx_enc_fecha 		ON tab_enc_compra (fec_factura);
CREATE INDEX idx_detcomp_prod 	ON tab_det_compra (id_prod);

--...................................................................
-- Vista de estado de facturas (el saldo se calcula, no se guarda)
--...................................................................
CREATE OR REPLACE VIEW vw_estado_factura AS
SELECT e.id_factura,
       e.fec_factura,
       p.nom_comp                                   AS proveedor,
       COALESCE(d.val_total, 0)                     AS val_total,
       COALESCE(g.val_pagado, 0)                    AS val_pagado,
       COALESCE(d.val_total, 0) - COALESCE(g.val_pagado, 0) AS val_saldo,
       CASE
         WHEN d.val_total IS NULL                   THEN 'SIN DETALLE'
         WHEN COALESCE(g.val_pagado, 0) = 0         THEN 'PENDIENTE'
         WHEN COALESCE(g.val_pagado, 0) < d.val_total THEN 'PAGO PARCIAL'
         ELSE 'PAGADA'
       END                                          AS estado
  FROM tab_enc_compra e
  JOIN tab_prov p ON p.id_prov = e.id_prov
  LEFT JOIN (SELECT id_factura, SUM(val_neto) AS val_total
               FROM tab_det_compra GROUP BY id_factura) d ON d.id_factura = e.id_factura
  LEFT JOIN (SELECT id_factura, SUM(val_pago) AS val_pagado
               FROM tab_pagos GROUP BY id_factura) g ON g.id_factura = e.id_factura;

--...................................................................
-- Trigger: el proveedor solo puede facturar productos de su catálogo
--...................................................................
CREATE OR REPLACE FUNCTION fn_valida_det_compra() RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (SELECT 1
                   FROM tab_enc_compra e
                   JOIN tab_prod_prov pp ON pp.id_prov = e.id_prov
                  WHERE e.id_factura = NEW.id_factura
                    AND pp.id_prod   = NEW.id_prod
                    AND pp.ind_disp  = TRUE) THEN
    RAISE EXCEPTION 'El producto % no lo vende (o no está disponible) el proveedor de la factura %',
                    NEW.id_prod, NEW.id_factura;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_valida_det_compra
BEFORE INSERT OR UPDATE ON tab_det_compra
FOR EACH ROW EXECUTE FUNCTION fn_valida_det_compra();

--...................................................................
-- Trigger: el pago no puede ser anterior a la factura ni superar el saldo
--...................................................................
CREATE OR REPLACE FUNCTION fn_valida_pago() RETURNS TRIGGER AS $$
DECLARE
  v_fec     DATE;
  v_total   NUMERIC;
  v_pagado  NUMERIC;
BEGIN
  SELECT fec_factura INTO v_fec FROM tab_enc_compra WHERE id_factura = NEW.id_factura;
  IF NEW.fec_pago < v_fec THEN
    RAISE EXCEPTION 'Fecha de pago % anterior a la factura (%)', NEW.fec_pago, v_fec;
  END IF;

  SELECT COALESCE(SUM(val_neto), 0) INTO v_total
    FROM tab_det_compra WHERE id_factura = NEW.id_factura;
  SELECT COALESCE(SUM(val_pago), 0) INTO v_pagado
    FROM tab_pagos WHERE id_factura = NEW.id_factura AND id_pago <> NEW.id_pago;

  IF NEW.val_pago > v_total - v_pagado THEN
    RAISE EXCEPTION 'El pago (%) supera el saldo de la factura % (saldo: %)',
                    NEW.val_pago, NEW.id_factura, v_total - v_pagado;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_valida_pago
BEFORE INSERT OR UPDATE ON tab_pagos
FOR EACH ROW EXECUTE FUNCTION fn_valida_pago();

BEGIN;

INSERT INTO tab_dptos (id_dpto, nom_dpto)	VALUES

('01', 'antioquia'),('02', 'atlántico'),('03', 'bolívar'),('04', 'boyacá'),('05', 'caldas'),
('06', 'cauca'),('07', 'cesar'),('08', 'córdoba'),('09', 'cundinamarca'),('10', 'huila'),
('11', 'la guajira'),('12', 'magdalena'),('13', 'meta'),('14', 'nariño'),('15', 'norte de santander'),
('16', 'quindío'),('17', 'risaralda'),('18', 'santander'),('19', 'tolima'),('20', 'valle del cauca')
;
 

INSERT INTO tab_ciud (id_ciud, nom_ciud, id_dpto)	VALUES

('01001', 'medellín', '01'),('01002', 'bello', '01'),('01003', 'itagüí', '01'),('01004', 'envigado', '01'),
('01005', 'sabaneta', '01'),('01006', 'rionegro', '01'),('01007', 'apartadó', '01'),('01008', 'turbo', '01'),
('01009', 'caucasia', '01'),('01010', 'santa fe de antioquia', '01'),('01011', 'la ceja', '01'),('01012', 'marinilla', '01'),

('02001', 'barranquilla', '02'),('02002', 'soledad', '02'),('02003', 'malambo', '02'),('02004', 'sabanalarga', '02'),
('02005', 'puerto colombia', '02'),('02006', 'baranoa', '02'),('02007', 'galapa', '02'),('02008', 'santo tomás', '02'),

('03001', 'cartagena', '03'),('03002', 'magangué', '03'),('03003', 'turbaco', '03'),('03004', 'el carmen de bolívar', '03'),
('03005', 'mompox', '03'),('03006', 'arjona', '03'),('03007', 'san juan nepomuceno', '03'),('03008', 'maría la baja', '03'),

('04001', 'tunja', '04'),('04002', 'duitama', '04'),('04003', 'sogamoso', '04'),
('04004', 'chiquinquirá', '04'),('04005', 'paipa', '04'),('04006', 'villa de leyva', '04'),('04007', 'puerto boyacá', '04'),('04008', 'moniquirá', '04'),

('05001', 'manizales', '05'),('05002', 'la dorada', '05'),('05003', 'villamaría', '05'),('05004', 'chinchiná', '05'),
('05005', 'riosucio', '05'),('05006', 'anserma', '05'),('05007', 'aguadas', '05'),

('06001', 'popayán', '06'),('06002', 'santander de quilichao', '06'),('06003', 'puerto tejada', '06'),('06004', 'patía', '06'),
('06005', 'silvia', '06'),('06006', 'piendamó', '06'),('06007', 'guapi', '06'),

('07001', 'valledupar', '07'),('07002', 'aguachica', '07'),('07003', 'agustín codazzi', '07'),
('07004', 'la jagua de ibirico', '07'),('07005', 'bosconia', '07'),('07006', 'chimichagua', '07'),('07007', 'curumaní', '07'),

('08001', 'montería', '08'),('08002', 'lorica', '08'),('08003', 'sahagún', '08'),('08004', 'cereté', '08'),
('08005', 'montelíbano', '08'),('08006', 'planeta rica', '08'),('08007', 'tierralta', '08'),

('09001', 'soacha', '09'),('09002', 'zipaquirá', '09'),('09003', 'facatativá', '09'),('09004', 'girardot', '09'),('09005', 'fusagasugá', '09'),
('09006', 'chía', '09'),('09007', 'cajicá', '09'),('09008', 'mosquera', '09'),('09009', 'madrid', '09'),('09010', 'villeta', '09'),

('10001', 'neiva', '10'),('10002', 'pitalito', '10'),('10003', 'garzón', '10'),
('10004', 'la plata', '10'),('10005', 'campoalegre', '10'),('10006', 'rivera', '10'),('10007', 'san agustín', '10'),

('11001', 'riohacha', '11'),('11002', 'maicao', '11'),('11003', 'uribia', '11'),
('11004', 'fonseca', '11'),('11005', 'san juan del cesar', '11'),('11006', 'villanueva', '11'),

('12001', 'santa marta', '12'),('12002', 'ciénaga', '12'),('12003', 'fundación', '12'),('12004', 'aracataca', '12'),
('12005', 'el banco', '12'),('12006', 'plato', '12'),('12007', 'zona bananera', '12'),

('13001', 'villavicencio', '13'),('13002', 'acacías', '13'),('13003', 'granada', '13'),('13004', 'puerto lópez', '13'),
('13005', 'restrepo', '13'),('13006', 'cumaral', '13'),('13007', 'san martín', '13'),

('14001', 'pasto', '14'),('14002', 'tumaco', '14'),('14003', 'ipiales', '14'),('14004', 'túquerres', '14'),
('14005', 'la unión', '14'),('14006', 'samaniego', '14'),('14007', 'barbacoas', '14'),('14008', 'el charco', '14'),

('15001', 'cúcuta', '15'),('15002', 'ocaña', '15'),('15003', 'pamplona', '15'),('15004', 'villa del rosario', '15'),
('15005', 'los patios', '15'),('15006', 'tibú', '15'),('15007', 'chinácota', '15'),('15008', 'ábrego', '15'),

('16001', 'armenia', '16'),('16002', 'calarcá', '16'),('16003', 'montenegro', '16'),
('16004', 'la tebaida', '16'),('16005', 'quimbaya', '16'),('16006', 'salento', '16'),

('17001', 'pereira', '17'),('17002', 'dosquebradas', '17'),('17003', 'la virginia', '17'),
('17004', 'santa rosa de cabal', '17'),('17005', 'marsella', '17'),('17006', 'belén de umbría', '17'),

('18001', 'bucaramanga', '18'),('18002', 'floridablanca', '18'),('18003', 'girón', '18'),('18004', 'piedecuesta', '18'),('18005', 'barrancabermeja', '18'),
('18006', 'san gil', '18'),('18007', 'socorro', '18'),('18008', 'barbosa', '18'),('18009', 'málaga', '18'),('18010', 'vélez', '18'),

('19001', 'ibagué', '19'),('19002', 'espinal', '19'),('19003', 'melgar', '19'),('19004', 'honda', '19'),
('19005', 'chaparral', '19'),('19006', 'líbano', '19'),('19007', 'mariquita', '19'),('19008', 'flandes', '19'),

('20001', 'cali', '20'),('20002', 'palmira', '20'),('20003', 'buenaventura', '20'),('20004', 'tuluá', '20'),('20005', 'buga', '20'),
('20006', 'cartago', '20'),('20007', 'jamundí', '20'),('20008', 'yumbo', '20'),('20009', 'candelaria', '20');

INSERT INTO tab_prov (id_prov, nom_prov, ape1_prov, ape2_prov, dir_prov, tel_prov,email_prov, id_ciud, val_cupocre, val_puntos, num_fact) VALUES

(1000000001, 'María', 'Rodríguez', 'López', 'Carrera 43A #1-50', '6042345678', 'maria@tecnosum.com', '01001', 3500000, 88, 1500),

(1000000002, 'Andrés', 'Martínez', 'Pérez', 'Calle 72 #54-10', '6053456789', 'andres@tecnosum.com', '02001', 7000000, 92, 2000),

(1000000003, 'Laura', 'García', 'Ramírez', 'Avenida Pedro de Heredia #31-45', '6054567890', 'laura@tecnosum.com', '03001', 4200000, 79, 800),

(1000000004, 'Juan', 'Torres', 'Castro', 'Carrera 10 #19-35', '6085678901', 'juan@tecnosum.com', '04001', 2500000, 85, 1200),

(1000000005, 'Camila', 'Vargas', 'Ortiz', 'Calle 23 #21-18', '6066789012', 'camila@tecnosum.com', '05001', 6000000, 90, 1800),

(1000000006, 'Felipe', 'Ruiz', 'Mejía', 'Carrera 6 #4-22', '6027890123', 'felipe@tecnosum.com', '06001', 3000000, 74, 700),

(1000000007, 'Valentina', 'Moreno', 'Díaz', 'Calle 15 #12-40', '6058901234', 'valentina@tecnosum.com', '07001', 8000000, 97, 2500),

(1000000008, 'Santiago', 'Jiménez', 'Rojas', 'Carrera 3 #30-12', '6049012345', 'santiago@tecnosum.com', '08001', 4800000, 81, 1100),

(1000000009, 'Daniela', 'Sánchez', 'Acosta', 'Calle 13 #7-65', '6010123456', 'daniela@tecnosum.com', '09001', 5500000, 93, 1600),

(1000000010, 'Sebastián', 'Ramírez', 'Cruz', 'Carrera 5 #9-31', '6081234560', 'sebastian@tecnosum.com', '10001', 2000000, 68, 500),

(1000000011, 'Paula', 'Herrera', 'Silva', 'Calle 20 #4-77', '6052345601', 'paula@tecnosum.com', '12001', 9000000, 99, 3000),

(1000000012, 'Nicolás', 'Castillo', 'Vega', 'Carrera 33 #38-25', '6083456012', 'nicolas@tecnosum.com', '13001', 3800000, 83, 900),

(1000000013, 'Juliana', 'Ortega', 'Navarro', 'Calle 18 #25-14', '6074567123', 'juliana@tecnosum.com', '15001', 6500000, 89, 1700),

(1000000014, 'Mateo', 'Mendoza', 'Salazar', 'Carrera 14 #11-08', '6065671234', 'mateo@tecnosum.com', '16001', 4000000, 77, 1000),

(1000000015, 'Sofía', 'Cárdenas', 'Prieto', 'Avenida Circunvalar #6-52', '6066782345', 'sofia@tecnosum.com', '17001', 7500000, 94, 2200),

(1000000016, 'Diego', 'Peña', 'Bermúdez', 'Calle 35 #19-41', '6077893456', 'diego@tecnosum.com', '18001', 5000000, 86, 1300),

(1000000017, 'Carolina', 'Parra', 'Giraldo', 'Carrera 5 #36-20', '6088904567', 'carolina@tecnosum.com', '19001', 3200000, 72, 600),

(1000000018, 'Alejandro', 'Cortés', 'Montoya', 'Avenida 6N #28-30', '6029015678', 'alejandro@tecnosum.com', '20001', 10000000, 100, 3500),

(1000000019, 'Natalia', 'Rincón', 'Quintero', 'Calle 1 #2-15', '6055026789', 'natalia@tecnosum.com', '11001', 2800000, 70, 650),

(1000000020, 'Esteban', 'Zapata', 'Arango', 'Carrera 25 #15-60', '6024037890', 'esteban@tecnosum.com', '14001', 5800000, 91, 1900)
;

INSERT INTO tab_pmtros (id_empresa, dia_pagos1, dia_pagos2, dia_pagos3, num_orden) VALUES
(1, 1, 3, 5, 100031);

INSERT INTO tab_prod (id_prod, id_ref, nom_prod) VALUES
(1,  'PROD001', 'portátil 15 pulgadas'),
(2,  'PROD002', 'mouse inalámbrico'),
(3,  'PROD003', 'teclado mecánico'),
(4,  'PROD004', 'monitor 24 pulgadas'),
(5,  'PROD005', 'cable hdmi 2 metros'),
(6,  'PROD006', 'disco duro externo 1tb'),
(7,  'PROD007', 'cámara web hd'),
(8,  'PROD008', 'impresora multifuncional'),
(9,  'PROD009', 'diadema con micrófono'),
(10, 'PROD010', 'tableta 10 pulgadas'),
(11, 'PROD011', 'memoria usb 64gb'),
(12, 'PROD012', 'proyector led'),
(13, 'PROD013', 'silla ergonómica'),
(14, 'PROD014', 'router wifi'),
(15, 'PROD015', 'ups 750va'),
(16, 'PROD016', 'escáner de documentos'),
(17, 'PROD017', 'televisor 32 pulgadas'),
(18, 'PROD018', 'regleta multitoma'),
(19, 'PROD019', 'switch 24 puertos'),
(20, 'PROD020', 'parlantes para pc')

;

INSERT INTO tab_prod_prov(id_prov, id_prod, val_prod) VALUES

(1000000001, 1, 2500000),

(1000000002, 2, 85000),

(1000000003, 3, 120000),

(1000000004, 4, 800000),

(1000000005, 5, 45000),

(1000000006, 6, 230000),

(1000000007, 7, 65000),

(1000000008, 8, 1400000),

(1000000009, 9, 95000),

(1000000010, 10, 310000),

(1000000011, 11, 52000),

(1000000012, 12, 670000),

(1000000013, 13, 140000),

(1000000014, 14, 78000),

(1000000015, 15, 420000),

(1000000016, 16, 185000),

(1000000017, 17, 960000),

(1000000018, 18, 58000),

(1000000019, 19, 275000),

(1000000020, 20, 110000)

;

INSERT INTO tab_area (id_area, nom_area, nom_encarg) VALUES

(1, 'compras',         'carlos pérez gómez'),
(2, 'ventas',          'ana martínez ruiz'),
(3, 'tecnología',      'luis hernández díaz'),
(4, 'operaciones',     'marta rojas silva'),
(5, 'administración',  'jorge díaz ramírez'),
(6, 'recursos humanos','paula ríos gómez'),
(7, 'calidad',         'sofía castro pérez'),
(8, 'logística',       'andrés torres vargas')

;

INSERT INTO tab_orden_compra (id_orden_compra, fec_orden, id_area)	VALUES

(100001, '2024-01-17 10:05', 1),
(100002, '2024-01-18 14:20', 2),
(100003, '2024-01-19 08:45', 4),
(100004, '2024-01-22 11:10', 3),
(100005, '2024-01-23 15:30', 2),
(100006, '2024-01-24 09:00', 1),
(100007, '2024-01-25 16:40', 3),
(100008, '2024-01-26 10:25', 2),
(100009, '2024-01-29 08:15', 4),
(100010, '2024-01-30 13:50', 1),
(100011, '2024-01-31 09:35', 3),
(100012, '2024-02-01 11:45', 2),
(100013, '2024-02-02 14:05', 1),
(100014, '2024-02-05 08:55', 3),
(100015, '2024-02-06 10:40', 4),
(100016, '2024-02-07 15:15', 2),
(100017, '2024-02-08 09:20', 1),
(100018, '2024-02-09 16:00', 3),
(100019, '2024-02-12 08:35', 2),
(100020, '2024-02-13 12:10', 4),
(100021, '2024-02-14 10:50', 1),
(100022, '2024-02-15 14:35', 3),
(100023, '2024-02-16 09:05', 2),
(100024, '2024-02-19 11:25', 1),
(100025, '2024-02-20 15:45', 4),
(100026, '2024-02-21 08:40', 3),
(100027, '2024-02-22 13:15', 2),
(100028, '2024-02-23 10:30', 1),
(100029, '2024-02-26 09:50', 3),
(100030, '2024-02-27 14:55', 2);

INSERT INTO tab_det_orden (id_orden, id_prod, val_cant) VALUES

(100001, 1, 2),
(100001, 2, 5),
(100002, 4, 3),
(100003, 6, 2)

;

INSERT INTO tab_enc_compra (id_factura, fec_factura, id_prov, id_ciud_entrega)
SELECT 200000 + t.n::int,
       DATE '2024-01-15' + ((t.n::int - 1) * 3),
       1000000000 + t.p,
       '18001'
FROM unnest(ARRAY[
   13, 6,11, 1,11,14,11,17, 1,20,
    5,12, 9,10,20,12, 2,20, 3, 8,
   19,12, 9, 3, 7,19,17,10,18, 2,
   19,14,18,17,15, 8, 9, 4,16, 5,
   16,15, 7, 8, 6, 3,14,13,16,18,
    4, 7,15,13, 5, 4, 2, 6,10, 1
]) WITH ORDINALITY AS t(p, n);

INSERT INTO tab_det_compra (id_factura, id_prod, val_cant, val_unit, val_descu) VALUES

(200001, 13, 11, 140000, 77000),
(200002, 6, 9, 230000, 103500),
(200003, 11, 7, 52000, 18200),
(200004, 1, 3, 2500000, 375000),
(200005, 11, 5, 52000, 13000),
(200006, 14, 14, 78000, 54600),
(200007, 11, 4, 52000, 10400),
(200008, 17, 2, 960000, 96000),
(200009, 1, 1, 2500000, 125000),
(200010, 20, 11, 110000, 60500),
(200011, 5, 6, 45000, 13500),
(200012, 12, 4, 670000, 134000),
(200013, 9, 7, 95000, 33250),
(200014, 10, 13, 310000, 201500),
(200015, 20, 9, 110000, 49500),
(200016, 12, 3, 670000, 100500),
(200017, 2, 11, 85000, 46750),
(200018, 20, 3, 110000, 16500),
(200019, 3, 3, 120000, 18000),
(200020, 8, 4, 1400000, 280000),
(200021, 19, 4, 275000, 55000),
(200022, 12, 3, 670000, 100500),
(200023, 9, 4, 95000, 19000),
(200024, 3, 9, 120000, 54000),
(200025, 7, 8, 65000, 26000),
(200026, 19, 2, 275000, 27500),
(200027, 17, 1, 960000, 48000),
(200028, 10, 14, 310000, 217000),
(200029, 18, 10, 58000, 29000),
(200030, 2, 11, 85000, 46750),
(200031, 19, 14, 275000, 192500),
(200032, 14, 15, 78000, 58500),
(200033, 18, 7, 58000, 20300),
(200034, 17, 3, 960000, 144000),
(200035, 15, 13, 420000, 273000),
(200036, 8, 3, 1400000, 210000),
(200037, 9, 11, 95000, 52250),
(200038, 4, 4, 800000, 160000),
(200039, 16, 11, 185000, 101750),
(200040, 5, 14, 45000, 31500),
(200041, 16, 9, 185000, 83250),
(200042, 15, 3, 420000, 63000),
(200043, 7, 15, 65000, 48750),
(200044, 8, 1, 1400000, 70000),
(200045, 6, 6, 230000, 69000),
(200046, 3, 9, 120000, 54000),
(200047, 14, 13, 78000, 50700),
(200048, 13, 12, 140000, 84000),
(200049, 16, 3, 185000, 27750),
(200050, 18, 2, 58000, 5800),
(200051, 4, 3, 800000, 120000),
(200052, 7, 12, 65000, 39000),
(200053, 15, 11, 420000, 231000),
(200054, 13, 12, 140000, 84000),
(200055, 5, 15, 45000, 33750),
(200056, 4, 4, 800000, 160000),
(200057, 2, 6, 85000, 25500),
(200058, 6, 13, 230000, 149500),
(200059, 10, 8, 310000, 124000),
(200060, 1, 3, 2500000, 375000);

INSERT INTO tab_pagos (id_factura, id_pago, fec_pago, val_pago) VALUES

(200001, 1, '2024-02-05', 600000),
(200001, 2, '2024-02-15', 600000),
(200001, 3, '2024-02-25', 540970),
(200002, 1, '2024-03-05', 810000),
(200002, 2, '2024-03-15', 810000),
(200002, 3, '2024-03-25', 720135),
(200003, 1, '2024-04-05', 140000),
(200003, 2, '2024-04-15', 140000),
(200003, 3, '2024-04-25', 131502),
(200004, 1, '2024-05-05', 2960000),
(200004, 2, '2024-05-15', 2960000),
(200004, 3, '2024-05-25', 2558750),
(200005, 1, '2024-06-05', 100000),
(200005, 2, '2024-06-15', 100000),
(200005, 3, '2024-06-25', 93930),
(200006, 1, '2024-07-05', 430000),
(200006, 2, '2024-07-15', 430000),
(200006, 3, '2024-07-25', 374506),
(200007, 1, '2024-08-05', 110000),
(200007, 2, '2024-08-15', 125144);
COMMIT; 

--.....................
-- 		EJERCICIO 1
--.....................
SELECT * FROM 	tab_prov;
--.......................
-- 	FIN DEL EJERCICIO 1
--.......................

--.....................
-- 		EJERCICIO 2
--.....................
SELECT 			nom_prod, ind_estado
FROM 			tab_prod
WHERE 			ind_estado = true ;

--........................
-- 		FIN DEL EJERCICIO 2
--.........................

--.....................
-- 		EJERCICIO 3
--.....................
SELECT 			nom_prov
FROM			tab_prov
ORDER BY 		nom_prov asc;

--........................
-- 		FIN DEL EJERCICIO 3
--.........................

--.....................
-- 		EJERCICIO 4
--.....................
SELECT			id_ciud, nom_ciud
FROM			tab_ciud
LIMIT			10;
--.........................
-- 		FIN DEL EJERCICIO 4
--..........................

--.....................
-- 		 EJERCICIO 5
--.....................
SELECT			id_orden_compra
FROM			tab_orden_compra
COUNT		;	

--.........................
-- 		FIN DEL EJERCICIO 5
--.........................

--.....................
-- 		EJERCICIO 6
--.....................
SELECT SUM	(val_neto)	AS valor_total
FROM 		tab_det_compra;

--.........................
-- 		FIN DEL EJERCICIO 6
--.........................

--.....................
-- 		EJERCICIO 7
--.....................
SELECT AVG (val_cupocre)	AS	valor_total
FROM		tan_det_compr
--........................
-- 		FIN DEL EJERCICIO 7
--........................

--.....................
-- 		 EJERCICIO 8
--.....................
SELECT			id_dpto count (id_ciu)
AS				total_valor
FROM			tab_ciud
GROUP			id_dpto;
--.........................
-- 		FIN DEL EJERCICIO 8
--.........................

--.....................
-- 		 EJERCICIO 9
--.....................
INSERT INTO  tab_area (id_area,nom_area,nom_encarg)	VALUES
			('9','Auditoria','Elena Beltran');

--........................
-- 		FIN DEL EJERCICIO 9
--.........................

--.....................
-- 		EJERCICIO 10
--.....................
UPDATE		tab_prov
SET 		val_puntos = '98'
WHERE		id_prov =1000000001;
--.........................
-- 		FIN DEL EJERCICIO 10
--.........................

--......................
--    Ejercicio 11
--....................
DELETE FROM tab_orden_compra
WHERE id_orden= 100030;
--.....................
-- 		FIN DEL EJERCICIO 10
--.....................

--....................
--   Ejercicio 12
--...................

SELECT c.nom_ciud, d.nom_dpto FROM tab_ciud AS c
JOIN tab_dptos AS d ON c.id_dpto =d.id_dpto;

--.........................
-- 		FIN DEL EJERCICIO 12
--.........................
.
--......................
--    Ejercicio 13
--......................
SELECT id_prod FROM tab_prod
WHERE id_prod IN(
SELECT id_prod FROM tab_prod_prov
WHERE val_prod>2000000
);
--.........................
-- 		FIN DEL EJERCICIO 13
--........................

--...............
--  Ejercicio 14
--...............
SELECT nom_prov, val_cupocre, 
CASE
WHEN val_cupocre>=5000000 THEN 'Cupo alto'
WHEN val_cupocre BETWEEN 3000000 AND 4999999 THEN 'Cupo medio'
ELSE 'Cupo bajo'
END AS cupo_total
FROM tab_prov;
--.........................
-- 		FIN DEL EJERCICIO 14
--.........................

--..........................
--    Ejercicio 15
--.........................
SELECT id_prod FROM tab_orden_compra
UNION
SELECT id_prod FROM tab_det_compra;
--.....................
-- 		FIN DEL EJERCICIO 15
--.....................

--.....................
--    Ejercicio 16
--....................

SELECT id_ciud FROM tab_enc_compra
UNION ALL
SELECT id_ciud FROM tab_prov;
--..........................
-- 		FIN DEL EJERCICIO 16
--.........................

-........................
--    Ejercicio 17 
--......................
SELECT id_factura, COUNT (*) AS total_productos
FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT (*) > 1;

--.........................
-- 		FIN DEL EJERCICIO 17
--..........................

--...........................
--    Ejercicio 18
--...........................
SELECT nom_prov FROM tab_prov p
WHERE EXISTS (
SELECT 1
FROM tab_enc_compra e
WHERE e.id_prov = p.id_prov
);
--.........................
-- 		FIN DEL EJERCICIO 18
--.........................

--...................
--    Ejercicio 19
--...................
SELECT nom_prov, datos_prov FROM tab_prov
WHERE datos_prov::text LIKE '%tecnosum%'
;
--..........................
-- 		FIN DEL EJERCICIO 19
--..........................

--......................
--    Ejercicio 20
--.....................
SELECT fec_factura FROM tab_enc_compra
WHERE fec_factura BETWEEN '2024/02/01'::date AND '2024/02/29'::date;

--..........................
-- 		FIN DEL EJERCICIO 20
--..........................





