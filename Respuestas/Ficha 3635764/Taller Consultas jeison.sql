 ---------------------------------------------------------------------
-- 0. LIMPIEZA (permite re-ejecutar el script)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS tab_pagos, tab_det_compra, tab_enc_compra,
                     tab_det_orden, tab_orden_compra, tab_prod_prov,
                     tab_prov, tab_areas, tab_prod, tab_ciud,
                     tab_dptos, tab_pmtros CASCADE;
DROP FUNCTION IF EXISTS fn_valida_det_compra() CASCADE;
DROP FUNCTION IF EXISTS fn_valida_pago() CASCADE;
 
 
 
-- =====================================================================
-- TABLA 1: tab_pmtros  (parámetros generales de la empresa)
-- =====================================================================
CREATE TABLE tab_pmtros
(
    id_empresa  DECIMAL(10,0) NOT NULL,
    dia_pagos1  SMALLINT      NOT NULL,  -- 1=lunes ... 7=domingo
    dia_pagos2  SMALLINT      NOT NULL,
    dia_pagos3  SMALLINT      NOT NULL,
    num_orden   DECIMAL(6,0)  NOT NULL,  -- consecutivo de órdenes de compra
    CONSTRAINT pk_pmtros       PRIMARY KEY (id_empresa),
    CONSTRAINT ck_pmtros_id    CHECK (id_empresa > 0),
    CONSTRAINT ck_pmtros_dias  CHECK (dia_pagos1 BETWEEN 1 AND 7
                                  AND dia_pagos2 BETWEEN 1 AND 7
                                  AND dia_pagos3 BETWEEN 1 AND 7
                                  AND dia_pagos1 < dia_pagos2
                                  AND dia_pagos2 < dia_pagos3),
    CONSTRAINT ck_pmtros_orden CHECK (num_orden > 0)
);
 
 
-- =====================================================================
-- TABLA 2: tab_dptos  (departamentos)
-- =====================================================================
CREATE TABLE tab_dptos
(
    id_dpto   VARCHAR(2)  NOT NULL,
    nom_dpto  VARCHAR(60) NOT NULL,
    CONSTRAINT pk_dptos        PRIMARY KEY (id_dpto),
    CONSTRAINT uq_dptos_nombre UNIQUE (nom_dpto),
    CONSTRAINT ck_dptos_id     CHECK (id_dpto ~ '^[0-9]{2}$'),
    CONSTRAINT ck_dptos_nombre CHECK (BTRIM(nom_dpto) <> '')
);
 
 
-- =====================================================================
-- TABLA 3: tab_ciud  (ciudades; el código inicia con el del dpto.)
-- =====================================================================
CREATE TABLE tab_ciud
(
    id_ciud   VARCHAR(5)  NOT NULL,
    nom_ciud  VARCHAR(80) NOT NULL,
    id_dpto   VARCHAR(2)  NOT NULL,
    CONSTRAINT pk_ciud        PRIMARY KEY (id_ciud),
    CONSTRAINT fk_ciud_dpto   FOREIGN KEY (id_dpto)
        REFERENCES tab_dptos (id_dpto)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_ciud_nombre UNIQUE (id_dpto, nom_ciud),
    CONSTRAINT ck_ciud_id     CHECK (id_ciud ~ '^[0-9]{5}$'),
    CONSTRAINT ck_ciud_prefijo CHECK (LEFT(id_ciud, 2) = id_dpto),
    CONSTRAINT ck_ciud_nombre CHECK (BTRIM(nom_ciud) <> '')
);
 
 
-- =====================================================================
-- TABLA 4: tab_prov  (proveedores; contacto atómico = 1FN)
-- =====================================================================
CREATE TABLE tab_prov
(
    id_prov      DECIMAL(10,0) NOT NULL,
    nom_prov     VARCHAR(60)   NOT NULL,
    ape1_prov    VARCHAR(60)   NOT NULL,
    ape2_prov    VARCHAR(60),
    nom_comp     VARCHAR(185)  GENERATED ALWAYS AS
                 (nom_prov || ' ' || ape1_prov || COALESCE(' ' || ape2_prov, ''))
                 STORED,
    dir_prov     VARCHAR(100)  NOT NULL,
    tel_prov     VARCHAR(10)   NOT NULL,
    email_prov   VARCHAR(100)  NOT NULL,
    id_ciud      VARCHAR(5)    NOT NULL,
    val_cupocre  DECIMAL(12,0) NOT NULL DEFAULT 0,
    val_puntos   DECIMAL(3,0)  NOT NULL DEFAULT 0,
    num_fact     DECIMAL(6,0)  NOT NULL,
    ind_estado   BOOLEAN       NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_prov       PRIMARY KEY (id_prov),
    CONSTRAINT fk_prov_ciud  FOREIGN KEY (id_ciud)
        REFERENCES tab_ciud (id_ciud)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_prov_email UNIQUE (email_prov),
    CONSTRAINT ck_prov_id    CHECK (id_prov > 0),
    CONSTRAINT ck_prov_tel   CHECK (tel_prov ~ '^(60[124-8]|3[0-9]{2})[0-9]{7}$'),
    CONSTRAINT ck_prov_email CHECK (email_prov ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'),
    CONSTRAINT ck_prov_cupo  CHECK (val_cupocre >= 0),
    CONSTRAINT ck_prov_puntos CHECK (val_puntos BETWEEN 0 AND 100),
    CONSTRAINT ck_prov_fact  CHECK (num_fact > 0)
);
 
 
-- =====================================================================
-- TABLA 5: tab_prod  (productos)
-- =====================================================================
CREATE TABLE tab_prod
(
    id_prod     SMALLINT    NOT NULL,
    id_ref      VARCHAR(10) NOT NULL,
    nom_prod    VARCHAR(80) NOT NULL,
    ind_estado  BOOLEAN     NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_prod       PRIMARY KEY (id_prod),
    CONSTRAINT uq_prod_ref   UNIQUE (id_ref),
    CONSTRAINT ck_prod_id    CHECK (id_prod > 0),
    CONSTRAINT ck_prod_ref   CHECK (id_ref ~ '^PROD[0-9]{3}$'),
    CONSTRAINT ck_prod_nombre CHECK (BTRIM(nom_prod) <> '')
);
 
 
-- =====================================================================
-- TABLA 6: tab_prod_prov  (catálogo: relación N:M con precio)
-- =====================================================================
CREATE TABLE tab_prod_prov
(
    id_prov   DECIMAL(10,0) NOT NULL,
    id_prod   SMALLINT      NOT NULL,
    val_prod  DECIMAL(10,0) NOT NULL,
    ind_disp  BOOLEAN       NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_prod_prov     PRIMARY KEY (id_prov, id_prod),
    CONSTRAINT fk_prodprov_prov FOREIGN KEY (id_prov)
        REFERENCES tab_prov (id_prov) ON DELETE RESTRICT,
    CONSTRAINT fk_prodprov_prod FOREIGN KEY (id_prod)
        REFERENCES tab_prod (id_prod) ON DELETE RESTRICT,
    CONSTRAINT ck_prodprov_valor CHECK (val_prod > 0)
);
 
 
-- =====================================================================
-- TABLA 7: tab_areas  (áreas de la empresa)
-- =====================================================================
CREATE TABLE tab_areas
(
    id_area     DECIMAL(2,0) NOT NULL,
    nom_area    VARCHAR(60)  NOT NULL,
    nom_encarg  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_areas        PRIMARY KEY (id_area),
    CONSTRAINT uq_areas_nombre UNIQUE (nom_area),
    CONSTRAINT ck_areas_id     CHECK (id_area > 0)
);
 
 
-- =====================================================================
-- TABLA 8: tab_orden_compra  (encabezado de la orden)
-- =====================================================================
CREATE TABLE tab_orden_compra
(
    id_orden   DECIMAL(6,0) NOT NULL,
    fec_orden  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_area    DECIMAL(2,0) NOT NULL,
    CONSTRAINT pk_orden      PRIMARY KEY (id_orden),
    CONSTRAINT fk_orden_area FOREIGN KEY (id_area)
        REFERENCES tab_areas (id_area) ON DELETE RESTRICT,
    CONSTRAINT ck_orden_id   CHECK (id_orden > 0)
);
 
 
-- =====================================================================
-- TABLA 9: tab_det_orden  (detalle de la orden: varios productos)
-- =====================================================================
CREATE TABLE tab_det_orden
(
    id_orden  DECIMAL(6,0) NOT NULL,
    id_prod   SMALLINT     NOT NULL,
    val_cant  SMALLINT     NOT NULL,
    CONSTRAINT pk_det_orden      PRIMARY KEY (id_orden, id_prod),
    CONSTRAINT fk_detorden_orden FOREIGN KEY (id_orden)
        REFERENCES tab_orden_compra (id_orden) ON DELETE CASCADE,
    CONSTRAINT fk_detorden_prod  FOREIGN KEY (id_prod)
        REFERENCES tab_prod (id_prod) ON DELETE RESTRICT,
    CONSTRAINT ck_detorden_cant  CHECK (val_cant > 0)
);
 
 
-- =====================================================================
-- TABLA 10: tab_enc_compra  (encabezado de factura de compra)
-- =====================================================================
CREATE TABLE tab_enc_compra
(
    id_factura       DECIMAL(6,0) NOT NULL,
    fec_factura      DATE         NOT NULL DEFAULT CURRENT_DATE,
    id_prov          DECIMAL(10,0) NOT NULL,
    id_ciud_entrega  VARCHAR(5)   NOT NULL,  -- ciudad donde se recibe la compra
    val_observa      TEXT,
    CONSTRAINT pk_enc_compra PRIMARY KEY (id_factura),
    CONSTRAINT fk_enc_prov   FOREIGN KEY (id_prov)
        REFERENCES tab_prov (id_prov) ON DELETE RESTRICT,
    CONSTRAINT fk_enc_ciud   FOREIGN KEY (id_ciud_entrega)
        REFERENCES tab_ciud (id_ciud) ON DELETE RESTRICT,
    CONSTRAINT ck_enc_id     CHECK (id_factura > 0),
    CONSTRAINT ck_enc_fecha  CHECK (fec_factura >= DATE '2000-01-01')
);
 
 
-- =====================================================================
-- TABLA 11: tab_det_compra  (detalle de factura; bruto/IVA/neto calculados)
-- =====================================================================
CREATE TABLE tab_det_compra
(
    id_factura  DECIMAL(6,0)  NOT NULL,
    id_prod     SMALLINT      NOT NULL,
    val_cant    SMALLINT      NOT NULL,
    val_unit    DECIMAL(10,0) NOT NULL,
    val_descu   DECIMAL(12,0) NOT NULL DEFAULT 0,
    porc_iva    DECIMAL(4,2)  NOT NULL DEFAULT 19,
    val_bruto   DECIMAL(12,0) GENERATED ALWAYS AS (val_cant * val_unit) STORED,
    val_iva     DECIMAL(12,0) GENERATED ALWAYS AS
                (ROUND((val_cant * val_unit - val_descu) * porc_iva / 100)) STORED,
    val_neto    DECIMAL(12,0) GENERATED ALWAYS AS
                (val_cant * val_unit - val_descu
                 + ROUND((val_cant * val_unit - val_descu) * porc_iva / 100)) STORED,
    CONSTRAINT pk_det_compra   PRIMARY KEY (id_factura, id_prod),
    CONSTRAINT fk_detcomp_enc  FOREIGN KEY (id_factura)
        REFERENCES tab_enc_compra (id_factura) ON DELETE CASCADE,
    CONSTRAINT fk_detcomp_prod FOREIGN KEY (id_prod)
        REFERENCES tab_prod (id_prod) ON DELETE RESTRICT,
    CONSTRAINT ck_detcomp_cant  CHECK (val_cant > 0),
    CONSTRAINT ck_detcomp_unit  CHECK (val_unit > 0),
    CONSTRAINT ck_detcomp_descu CHECK (val_descu >= 0
                                   AND val_descu <= val_cant * val_unit),
    CONSTRAINT ck_detcomp_iva   CHECK (porc_iva IN (0, 5, 19))
);
 
 
-- =====================================================================
-- TABLA 12: tab_pagos  (el saldo NO se almacena: se calcula en la vista)
-- =====================================================================
CREATE TABLE tab_pagos
(
    id_factura  DECIMAL(6,0)  NOT NULL,
    id_pago     SMALLINT      NOT NULL,
    fec_pago    DATE          NOT NULL,
    val_pago    DECIMAL(12,0) NOT NULL,
    CONSTRAINT pk_pagos     PRIMARY KEY (id_factura, id_pago),
    CONSTRAINT fk_pagos_enc FOREIGN KEY (id_factura)
        REFERENCES tab_enc_compra (id_factura) ON DELETE RESTRICT,
    CONSTRAINT ck_pagos_id    CHECK (id_pago > 0),
    CONSTRAINT ck_pagos_valor CHECK (val_pago > 0)
);
 



BEGIN;


 
-- TABLA 1: tab_pmtros  (1 filas)
INSERT INTO public.tab_pmtros (id_empresa, dia_pagos1, dia_pagos2, dia_pagos3, num_orden) VALUES
(1, 1, 3, 5, 100031);
 
-- TABLA 2: tab_dptos  (20 filas)
INSERT INTO public.tab_dptos (id_dpto, nom_dpto) VALUES
('01', 'Amazonas'),
('02', 'Antioquia'),
('03', 'Arauca'),
('04', 'Atlántico'),
('05', 'Bolívar'),
('06', 'Boyacá'),
('07', 'Caldas'),
('08', 'Caquetá'),
('09', 'Casanare'),
('10', 'Cauca'),
('11', 'Cesar'),
('12', 'Chocó'),
('13', 'Córdoba'),
('14', 'Cundinamarca'),
('15', 'Huila'),
('16', 'La Guajira'),
('17', 'Magdalena'),
('18', 'Meta'),
('19', 'Nariño'),
('20', 'Valle del Cauca');
 
-- TABLA 3: tab_ciud  (61 filas)
INSERT INTO public.tab_ciud (id_ciud, nom_ciud, id_dpto) VALUES
('01001', 'Leticia', '01'),
('01002', 'Puerto Nariño', '01'),
('02001', 'Medellín', '02'),
('02002', 'Bello', '02'),
('02003', 'Itagüí', '02'),
('02004', 'Envigado', '02'),
('02005', 'Rionegro', '02'),
('02006', 'Marinilla', '02'),
('02007', 'Copacabana', '02'),
('02008', 'La Estrella', '02'),
('03001', 'Arauca', '03'),
('03002', 'Tame', '03'),
('03003', 'Saravena', '03'),
('04001', 'Barranquilla', '04'),
('04002', 'Soledad', '04'),
('04003', 'Malambo', '04'),
('04004', 'Sabanalarga', '04'),
('05001', 'Cartagena', '05'),
('05002', 'Magangué', '05'),
('05003', 'Turbaco', '05'),
('06001', 'Tunja', '06'),
('06002', 'Duitama', '06'),
('06003', 'Sogamoso', '06'),
('07001', 'Manizales', '07'),
('07002', 'Villamaría', '07'),
('07003', 'Chinchiná', '07'),
('08001', 'Florencia', '08'),
('08002', 'San Vicente del Caguán', '08'),
('09001', 'Yopal', '09'),
('09002', 'Aguazul', '09'),
('10001', 'Popayán', '10'),
('10002', 'Santander de Quilichao', '10'),
('11001', 'Valledupar', '11'),
('11002', 'Aguachica', '11'),
('12001', 'Quibdó', '12'),
('12002', 'Istmina', '12'),
('12003', 'Riosucio', '12'),
('13001', 'Montería', '13'),
('13002', 'Lorica', '13'),
('13003', 'Sahagún', '13'),
('14001', 'Bogotá', '14'),
('14002', 'Soacha', '14'),
('14003', 'Zipaquirá', '14'),
('14004', 'Facatativá', '14'),
('14005', 'Chía', '14'),
('15001', 'Neiva', '15'),
('15002', 'Pitalito', '15'),
('16001', 'Riohacha', '16'),
('16002', 'Maicao', '16'),
('17001', 'Santa Marta', '17'),
('17002', 'Ciénaga', '17'),
('18001', 'Villavicencio', '18'),
('18002', 'Acacías', '18'),
('18003', 'Puerto López', '18'),
('19001', 'Pasto', '19'),
('19002', 'Ipiales', '19'),
('19003', 'Tumaco', '19'),
('20001', 'Cali', '20'),
('20002', 'Palmira', '20'),
('20003', 'Buenaventura', '20'),
('20004', 'Tuluá', '20');
 
-- TABLA 4: tab_prov  (20 filas)
INSERT INTO public.tab_prov (id_prov, nom_prov, ape1_prov, ape2_prov, dir_prov, tel_prov, email_prov, id_ciud, val_cupocre, val_puntos, num_fact) VALUES
(1000000001, 'Carlos', 'Gómez', 'Hernández', 'Calle 10 #20-10', '3413530829', 'carlos@tecnosum.com', '01001', 5000000, 90, 1000),
(1000000002, 'Ana', 'Martínez', 'López', 'Calle 13 #21-11', '6041810111', 'ana@suministros.com', '02001', 3000000, 96, 2000),
(1000000003, 'María', 'López', 'García', 'Calle 16 #22-12', '6079990608', 'maria@tecnoplus.com', '03001', 3000000, 81, 3000),
(1000000004, 'Luis', 'Rodríguez', 'Pérez', 'Calle 19 #23-13', '3741973060', 'luis@lrdistribuciones.com', '04001', 5500000, 76, 4000),
(1000000005, 'Sofía', 'Ramírez', 'González', 'Calle 22 #24-14', '6051629072', 'sofia@sramirez.com', '05001', 3000000, 83, 5000),
(1000000006, 'David', 'Torres', 'Vargas', 'Calle 25 #25-15', '6088015764', 'david@torresvargas.com', '06001', 3000000, 77, 6000),
(1000000007, 'Carmen', 'Vargas', 'Mendoza', 'Calle 28 #26-16', '3118122250', 'carmen@cvmendoza.com', '07001', 3000000, 96, 7000),
(1000000008, 'Pedro', 'Hernández', 'Silva', 'Calle 31 #27-17', '6083077052', 'pedro@phsilva.com', '08001', 3500000, 90, 8000),
(1000000009, 'Jorge', 'Díaz', 'Ramírez', 'Calle 34 #28-18', '6082037872', 'jorge@jdiaz.com', '09001', 5500000, 88, 9000),
(1000000010, 'Lucía', 'Fernández', 'Romero', 'Calle 37 #29-19', '3501831970', 'lucia@lfromero.com', '10001', 3500000, 71, 10000),
(1000000011, 'Andrés', 'Ortega', 'Navarro', 'Calle 40 #30-20', '6053234302', 'andres@ortegana.com', '11001', 4000000, 83, 11000),
(1000000012, 'Patricia', 'Mendoza', 'Rojas', 'Calle 43 #31-21', '6043420198', 'patricia@pmrojas.com', '12001', 5500000, 73, 12000),
(1000000013, 'Roberto', 'Navarro', 'Suárez', 'Calle 46 #32-22', '3736175466', 'roberto@rnsuarez.com', '13001', 5500000, 96, 13000),
(1000000014, 'Isabel', 'Pérez', 'Morales', 'Calle 49 #33-23', '6014032085', 'isabel@ipmorales.com', '14001', 3000000, 88, 14000),
(1000000015, 'Miguel', 'Suárez', 'Romero', 'Calle 52 #34-24', '6084151952', 'miguel@msromero.com', '15001', 4000000, 73, 15000),
(1000000016, 'Elena', 'Morales', 'Fernández', 'Calle 55 #35-25', '3702053424', 'elena@emorales.com', '16001', 5500000, 71, 16000),
(1000000017, 'Gabriela', 'Rojas', 'Pérez', 'Calle 58 #36-26', '6054455413', 'gabriela@grojas.com', '17001', 5000000, 91, 17000),
(1000000018, 'Diego', 'Castro', 'Peña', 'Calle 61 #37-27', '6089920785', 'diego@dcastro.com', '18001', 5000000, 94, 18000),
(1000000019, 'Valentina', 'Ruiz', 'Cano', 'Calle 64 #38-28', '3408811503', 'valentina@vruiz.com', '19001', 5500000, 84, 19000),
(1000000020, 'Camilo', 'Reyes', 'Mora', 'Calle 67 #39-29', '6027066345', 'camilo@creyes.com', '20001', 4000000, 77, 20000);
 
-- TABLA 5: tab_prod  (20 filas)
INSERT INTO public.tab_prod (id_prod, id_ref, nom_prod) VALUES
(1, 'PROD001', 'Laptop Gamer'),
(2, 'PROD002', 'Mouse Inalámbrico'),
(3, 'PROD003', 'Teclado Mecánico'),
(4, 'PROD004', 'Monitor 24"'),
(5, 'PROD005', 'Impresora Láser'),
(6, 'PROD006', 'Tablet 10"'),
(7, 'PROD007', 'Smartphone'),
(8, 'PROD008', 'Auriculares Bluetooth'),
(9, 'PROD009', 'Disco Duro SSD 1TB'),
(10, 'PROD010', 'Memoria RAM 16GB'),
(11, 'PROD011', 'Cámara Web'),
(12, 'PROD012', 'Micrófono USB'),
(13, 'PROD013', 'Silla Ergonómica'),
(14, 'PROD014', 'Escritorio Oficina'),
(15, 'PROD015', 'Proyector'),
(16, 'PROD016', 'Tarjeta Gráfica'),
(17, 'PROD017', 'Fuente de Poder'),
(18, 'PROD018', 'Altavoces'),
(19, 'PROD019', 'Router WiFi'),
(20, 'PROD020', 'Cargador Universal');
 
-- TABLA 6: tab_prod_prov  (100 filas)
INSERT INTO public.tab_prod_prov (id_prov, id_prod, val_prod) VALUES
(1000000001, 1, 2400000),
(1000000001, 5, 432000),
(1000000001, 9, 304000),
(1000000001, 13, 440000),
(1000000001, 17, 177000),
(1000000002, 2, 85000),
(1000000002, 6, 1248000),
(1000000002, 10, 280000),
(1000000002, 14, 543000),
(1000000002, 18, 147000),
(1000000003, 3, 125000),
(1000000003, 7, 1728000),
(1000000003, 11, 80000),
(1000000003, 15, 1392000),
(1000000003, 19, 218000),
(1000000004, 4, 832000),
(1000000004, 8, 129000),
(1000000004, 12, 138000),
(1000000004, 16, 3100000),
(1000000004, 20, 95000),
(1000000005, 5, 450000),
(1000000005, 9, 343000),
(1000000005, 13, 458000),
(1000000005, 17, 156000),
(1000000005, 1, 2300000),
(1000000006, 6, 1200000),
(1000000006, 10, 291000),
(1000000006, 14, 543000),
(1000000006, 18, 147000),
(1000000006, 2, 85000),
(1000000007, 7, 1872000),
(1000000007, 11, 80000),
(1000000007, 15, 1508000),
(1000000007, 19, 210000),
(1000000007, 3, 110000),
(1000000008, 8, 146000),
(1000000008, 12, 150000),
(1000000008, 16, 2976000),
(1000000008, 20, 87000),
(1000000008, 4, 832000),
(1000000009, 9, 304000),
(1000000009, 13, 422000),
(1000000009, 17, 170000),
(1000000009, 1, 2400000),
(1000000009, 5, 432000),
(1000000010, 10, 291000),
(1000000010, 14, 614000),
(1000000010, 18, 166000),
(1000000010, 2, 78000),
(1000000010, 6, 1152000),
(1000000011, 11, 83000),
(1000000011, 15, 1508000),
(1000000011, 19, 210000),
(1000000011, 3, 115000),
(1000000011, 7, 1872000),
(1000000012, 12, 150000),
(1000000012, 16, 3224000),
(1000000012, 20, 95000),
(1000000012, 4, 832000),
(1000000012, 8, 134000),
(1000000013, 13, 422000),
(1000000013, 17, 156000),
(1000000013, 1, 2400000),
(1000000013, 5, 432000),
(1000000013, 9, 317000),
(1000000014, 14, 566000),
(1000000014, 18, 147000),
(1000000014, 2, 88000),
(1000000014, 6, 1152000),
(1000000014, 10, 280000),
(1000000015, 15, 1450000),
(1000000015, 19, 193000),
(1000000015, 3, 115000),
(1000000015, 7, 1872000),
(1000000015, 11, 80000),
(1000000016, 16, 3100000),
(1000000016, 20, 91000),
(1000000016, 4, 736000),
(1000000016, 8, 146000),
(1000000016, 12, 156000),
(1000000017, 17, 177000),
(1000000017, 1, 2600000),
(1000000017, 5, 468000),
(1000000017, 9, 304000),
(1000000017, 13, 458000),
(1000000018, 18, 166000),
(1000000018, 2, 78000),
(1000000018, 6, 1152000),
(1000000018, 10, 258000),
(1000000018, 14, 566000),
(1000000019, 19, 218000),
(1000000019, 3, 115000),
(1000000019, 7, 1656000),
(1000000019, 11, 80000),
(1000000019, 15, 1334000),
(1000000020, 20, 87000),
(1000000020, 4, 736000),
(1000000020, 8, 134000),
(1000000020, 12, 138000),
(1000000020, 16, 3100000);
 
-- TABLA 7: tab_areas  (8 filas)
INSERT INTO public.tab_areas (id_area, nom_area, nom_encarg) VALUES
(1, 'Compras', 'Jorge Ramírez'),
(2, 'Ventas', 'Marta Cruz'),
(3, 'Tecnología', 'Pedro Salas'),
(4, 'Operaciones', 'Sandra Gil'),
(5, 'Administración', 'Laura Pineda'),
(6, 'Recursos Humanos', 'Camila Ortiz'),
(7, 'Calidad', 'Héctor Mejía'),
(8, 'Logística', 'Natalia Duarte');
 
-- TABLA 8: tab_orden_compra  (30 filas)
INSERT INTO public.tab_orden_compra (id_orden, fec_orden, id_area) VALUES
(100001, '2024-01-01 08:00', 1),
(100002, '2024-01-02 09:07', 4),
(100003, '2024-01-03 10:14', 3),
(100004, '2024-01-04 11:21', 4),
(100005, '2024-01-05 12:28', 3),
(100006, '2024-01-06 13:35', 3),
(100007, '2024-01-07 14:42', 3),
(100008, '2024-01-08 15:49', 2),
(100009, '2024-01-09 16:56', 2),
(100010, '2024-01-10 08:03', 3),
(100011, '2024-01-11 09:10', 3),
(100012, '2024-01-12 10:17', 1),
(100013, '2024-01-13 11:24', 3),
(100014, '2024-01-14 12:31', 1),
(100015, '2024-01-15 13:38', 2),
(100016, '2024-01-16 14:45', 4),
(100017, '2024-01-17 15:52', 2),
(100018, '2024-01-18 16:59', 4),
(100019, '2024-01-19 08:06', 2),
(100020, '2024-01-20 09:13', 2),
(100021, '2024-01-21 10:20', 2),
(100022, '2024-01-22 11:27', 3),
(100023, '2024-01-23 12:34', 4),
(100024, '2024-01-24 13:41', 4),
(100025, '2024-01-25 14:48', 2),
(100026, '2024-01-26 15:55', 1),
(100027, '2024-01-27 16:02', 1),
(100028, '2024-01-28 08:09', 4),
(100029, '2024-01-01 09:16', 2),
(100030, '2024-01-02 10:23', 2);
 
-- TABLA 9: tab_det_orden  (63 filas)
INSERT INTO public.tab_det_orden (id_orden, id_prod, val_cant) VALUES
(100001, 7, 20),
(100002, 9, 12),
(100003, 4, 16),
(100003, 20, 15),
(100004, 10, 5),
(100004, 3, 4),
(100005, 9, 17),
(100005, 16, 1),
(100005, 6, 7),
(100006, 18, 1),
(100007, 3, 12),
(100007, 9, 6),
(100007, 17, 12),
(100008, 18, 8),
(100008, 17, 20),
(100008, 11, 7),
(100009, 8, 17),
(100009, 7, 16),
(100010, 1, 16),
(100010, 20, 9),
(100010, 9, 7),
(100011, 12, 3),
(100011, 20, 8),
(100012, 16, 7),
(100013, 16, 20),
(100014, 12, 4),
(100014, 3, 13),
(100015, 6, 11),
(100015, 14, 3),
(100016, 13, 6),
(100016, 3, 6),
(100017, 5, 19),
(100018, 5, 5),
(100018, 16, 18),
(100018, 12, 18),
(100019, 1, 4),
(100020, 7, 1),
(100020, 20, 9),
(100021, 17, 19),
(100021, 8, 11),
(100022, 14, 12),
(100022, 5, 15),
(100022, 2, 19),
(100023, 5, 17),
(100023, 18, 17),
(100023, 20, 1),
(100024, 20, 1),
(100025, 5, 16),
(100026, 2, 17),
(100026, 11, 18),
(100026, 17, 16),
(100027, 2, 9),
(100027, 8, 2),
(100027, 7, 4),
(100028, 1, 11),
(100028, 3, 20),
(100028, 15, 17),
(100029, 9, 18),
(100029, 15, 16),
(100029, 17, 17),
(100030, 17, 7),
(100030, 9, 15),
(100030, 18, 5);
 
-- TABLA 10: tab_enc_compra  (60 filas)
INSERT INTO public.tab_enc_compra (id_factura, fec_factura, id_prov, id_ciud_entrega, val_observa) VALUES
(200001, '2024-01-10', 1000000001, '08001', NULL),
(200002, '2024-01-12', 1000000002, '02003', NULL),
(200003, '2024-01-14', 1000000003, '14003', NULL),
(200004, '2024-01-16', 1000000004, '09002', NULL),
(200005, '2024-01-18', 1000000005, '03001', NULL),
(200006, '2024-01-20', 1000000006, '06002', NULL),
(200007, '2024-01-22', 1000000007, '06002', NULL),
(200008, '2024-01-24', 1000000008, '11001', NULL),
(200009, '2024-01-26', 1000000009, '02004', NULL),
(200010, '2024-01-28', 1000000010, '19001', NULL),
(200011, '2024-01-30', 1000000011, '05001', NULL),
(200012, '2024-02-01', 1000000012, '05001', NULL),
(200013, '2024-02-03', 1000000013, '13002', NULL),
(200014, '2024-02-05', 1000000014, '09002', NULL),
(200015, '2024-02-07', 1000000015, '20003', NULL),
(200016, '2024-02-09', 1000000016, '04004', NULL),
(200017, '2024-02-11', 1000000017, '14001', NULL),
(200018, '2024-02-13', 1000000018, '05001', NULL),
(200019, '2024-02-15', 1000000019, '11001', NULL),
(200020, '2024-02-17', 1000000020, '11001', NULL),
(200021, '2024-02-19', 1000000001, '06003', NULL),
(200022, '2024-02-21', 1000000002, '14001', NULL),
(200023, '2024-02-23', 1000000003, '13002', NULL),
(200024, '2024-02-25', 1000000004, '03002', NULL),
(200025, '2024-02-27', 1000000005, '04004', NULL),
(200026, '2024-02-29', 1000000006, '06003', NULL),
(200027, '2024-03-02', 1000000007, '02004', NULL),
(200028, '2024-03-04', 1000000008, '10001', NULL),
(200029, '2024-03-06', 1000000009, '05001', NULL),
(200030, '2024-03-08', 1000000010, '11001', NULL),
(200031, '2024-03-10', 1000000011, '14002', NULL),
(200032, '2024-03-12', 1000000012, '03003', NULL),
(200033, '2024-03-14', 1000000013, '04003', NULL),
(200034, '2024-03-16', 1000000014, '11001', NULL),
(200035, '2024-03-18', 1000000015, '17001', NULL),
(200036, '2024-03-20', 1000000016, '01001', NULL),
(200037, '2024-03-22', 1000000017, '02004', NULL),
(200038, '2024-03-24', 1000000018, '04004', NULL),
(200039, '2024-03-26', 1000000019, '18002', NULL),
(200040, '2024-03-28', 1000000020, '02004', NULL),
(200041, '2024-03-30', 1000000001, '02008', NULL),
(200042, '2024-04-01', 1000000002, '07003', NULL),
(200043, '2024-04-03', 1000000003, '13001', NULL),
(200044, '2024-04-05', 1000000004, '02001', NULL),
(200045, '2024-04-07', 1000000005, '07003', NULL),
(200046, '2024-04-09', 1000000006, '01002', NULL),
(200047, '2024-04-11', 1000000007, '05003', NULL),
(200048, '2024-04-13', 1000000008, '05003', NULL),
(200049, '2024-04-15', 1000000009, '14001', NULL),
(200050, '2024-04-17', 1000000010, '04002', NULL),
(200051, '2024-04-19', 1000000011, '02004', NULL),
(200052, '2024-04-21', 1000000012, '13001', NULL),
(200053, '2024-04-23', 1000000013, '11002', NULL),
(200054, '2024-04-25', 1000000014, '19001', NULL),
(200055, '2024-04-27', 1000000015, '16002', NULL),
(200056, '2024-04-29', 1000000016, '02008', NULL),
(200057, '2024-05-01', 1000000017, '14003', NULL),
(200058, '2024-05-03', 1000000018, '20001', NULL),
(200059, '2024-05-05', 1000000019, '15001', NULL),
(200060, '2024-05-07', 1000000020, '17002', NULL);
 
-- TABLA 11: tab_det_compra  (38 filas)
INSERT INTO public.tab_det_compra (id_factura, id_prod, val_cant, val_unit, val_descu) VALUES
(200001, 13, 8, 440000, 176000),
(200002, 14, 2, 543000, 0),
(200003, 3, 6, 125000, 0),
(200003, 7, 5, 1728000, 0),
(200004, 4, 7, 832000, 582400),
(200005, 9, 7, 343000, 240100),
(200006, 10, 6, 291000, 0),
(200006, 14, 6, 543000, 0),
(200007, 19, 7, 210000, 73500),
(200007, 7, 9, 1872000, 842400),
(200008, 8, 4, 146000, 0),
(200009, 17, 3, 170000, 25500),
(200009, 9, 3, 304000, 91200),
(200010, 2, 9, 78000, 70200),
(200010, 14, 6, 614000, 0),
(200011, 15, 7, 1508000, 0),
(200012, 12, 5, 150000, 0),
(200013, 13, 5, 422000, 0),
(200014, 2, 9, 88000, 79200),
(200015, 11, 1, 80000, 0),
(200015, 19, 2, 193000, 0),
(200016, 20, 4, 91000, 18200),
(200017, 13, 5, 458000, 229000),
(200017, 1, 9, 2600000, 0),
(200018, 18, 1, 166000, 0),
(200018, 6, 1, 1152000, 0),
(200019, 3, 2, 115000, 23000),
(200019, 11, 8, 80000, 64000),
(200020, 4, 6, 736000, 0),
(200020, 16, 3, 3100000, 930000),
(200021, 5, 1, 432000, 0),
(200022, 14, 1, 543000, 0),
(200022, 6, 7, 1248000, 436800),
(200023, 11, 1, 80000, 8000),
(200024, 12, 8, 138000, 0),
(200025, 13, 4, 458000, 0),
(200025, 1, 5, 2300000, 0),
(200026, 6, 6, 1200000, 720000);
 
-- TABLA 12: tab_pagos  (22 filas)
INSERT INTO public.tab_pagos (id_factura, id_pago, fec_pago, val_pago) VALUES
(200001, 1, '2024-01-20', 1326453),
(200001, 2, '2024-01-30', 1326453),
(200001, 3, '2024-02-09', 1326454),
(200002, 1, '2024-01-22', 430780),
(200002, 2, '2024-02-01', 430780),
(200002, 3, '2024-02-11', 430780),
(200003, 1, '2024-01-24', 3724700),
(200003, 2, '2024-02-03', 3724700),
(200003, 3, '2024-02-13', 3724700),
(200004, 1, '2024-01-26', 2079168),
(200004, 2, '2024-02-05', 2079168),
(200004, 3, '2024-02-15', 2079168),
(200005, 1, '2024-01-28', 857157),
(200005, 2, '2024-02-07', 857157),
(200005, 3, '2024-02-17', 857157),
(200006, 1, '2024-01-30', 1984920),
(200006, 2, '2024-02-09', 1984920),
(200006, 3, '2024-02-19', 1984920),
(200007, 1, '2024-02-01', 10354249),
(200008, 1, '2024-02-03', 347480),
(200009, 1, '2024-02-05', 776653),
(200010, 1, '2024-02-07', 2567901);


COMMIT;

-- =====================================================================
-- TALLER PRÁCTICO DE SQL: CONSULTAS Y AUDITORÍA
-- BLOQUE I: Consultas básicas, filtros y agregaciones (1 - 10)
-- Modelo: Sistema de Compras y Proveedores (PostgreSQL)
-- =====================================================================


--Ejercicio 1 (SELECT Básica): Escriba una consulta para seleccionar todos los campos y registros de la tabla de
--proveedores (tab_prov).

SELECT *
FROM tab_prov;

--Ejercicio 2 (SELECT con WHERE): Obtenga todos los productos (tab_prod) cuyo estado (ind_estado) se
--encuentre activo (true).

SELECT ind_estado, nom_prod
FROM tab_prod
WHERE ind_estado = TRUE;

--Ejercicio 3 (SELECT con ORDER BY): Liste los proveedores de la tabla tab_prov ordenados alfabéticamente de
--forma ascendente por su primer nombre.

SELECT *
FROM tab_prov
ORDER BY nom_prov ASC;

--Ejercicio 4 (SELECT con LIMIT): Muestre únicamente los primeros 10 registros de la tabla de ciudades
--(tab_ciud), proyectando su ID y nombre.

SELECT id_ciud, nom_ciud
FROM tab_ciud
LIMIT 10;

--Ejercicio 5 (SELECT con COUNT): Obtenga el número total de órdenes de compra (tab_orden_compra)
--registradas en el sistema.

SELECT COUNT (*) AS total_ordenes
FROM tab_orden_compra;


--Ejercicio 6 (SELECT con SUM): Calcule el monto total acumulado del valor neto (val_neto) facturado en la tabla
--de detalle de compra (tab_det_compra).

SELECT SUM(val_neto) AS total_acumulado_neto
FROM tab_det_compra;


--Ejercicio 7 (SELECT con AVG): Determine el valor promedio del cupo de crédito (val_cupocre) otorgado a los
--proveedores en tab_prov.

SELECT AVG(val_cupocre) AS promedio_cupo_credito
FROM tab_prov;


--Ejercicio 8 (SELECT con GROUP BY): Muestre la cantidad total de ciudades registradas por cada departamento
--en la tabla tab_ciud.

SELECT d.nom_dpto, COUNT(c.id_ciud) AS total_ciudades
  FROM tab_dptos d
  LEFT JOIN tab_ciud c ON c.id_dpto = d.id_dpto
 GROUP BY d.nom_dpto
 ORDER BY total_ciudades;


--Ejercicio 9 (INSERT): Escriba la sentencia para insertar una nueva área en tab_areas con ID 9, nombre
--'Auditoría' y encargada 'Elena Beltrán'.

INSERT INTO tab_areas (id_area, nom_area, nom_encarg)
VALUES (9, 'Auditoría', 'Elena Beltrán')

SELECT * FROM tab_areas WHERE id_area = 9;


--Ejercicio 10 (UPDATE): Actualice la cantidad de puntos (val_puntos) a 98 para el proveedor con ID
--1000000001 en tab_prov.


UPDATE tab_prov
SET val_puntos = 98
WHERE id_prov = 1000000001;

SELECT id_prov, nom_comp, val_puntos
FROM tab_prov
WHERE id_prov = 1000000001;


--Ejercicio 11 (DELETE): Elimine el registro de la orden de compra en tab_orden_compra cuyo id_orden sea
--100030.

DELETE FROM tab_orden_compra
WHERE id_orden = 100030;


--Ejercicio 12 (JOIN): Realice una consulta que combine tab_ciud y tab_dptos para mostrar el nombre de la
--ciudad y el nombre de su respectivo departamento.

SELECT c.nom_ciud, d.nom_dpto
FROM tab_ciud c
JOIN tab_dptos d ON d.id_dpto = c.id_dpto
ORDER BY d.nom_dpto, c.nom_ciud;
 
--Ejercicio 13 (Subconsulta): Seleccione todos los productos de tab_prod cuyos IDs estén presentes en
--tab_prod_prov con un valor del producto (val_prod) superior a 2,000,000.


SELECT * FROM tab_prod
WHERE id_prod IN (SELECT id_prod
                     FROM tab_prod_prov
                    WHERE val_prod > 2000000)
ORDER BY id_prod;


--Ejercicio 14 (CASE): Clasifique a los proveedores según su cupo de crédito: 'Cupo Alto' (>= 5,000,000), 'Cupo
--Medio' (3,000,000 a 4,999,999) y 'Cupo Bajo' (< 3,000,000).


SELECT nom_comp,
       val_cupocre,
       CASE
           WHEN val_cupocre >= 5000000 THEN 'Cupo Alto'
           WHEN val_cupocre >= 3000000 THEN 'Cupo Medio'   -- 3.000.000 a 4.999.999
           ELSE 'Cupo Bajo'                                 -- menos de 3.000.000
       END AS categoria_cupo
  FROM tab_prov
 ORDER BY val_cupocre DESC;


--Ejercicio 15 (UNION): Combine en un único listado sin duplicados los IDs de los productos pedidos en órdenes
--de compra y los facturados en detalles de compra.


SELECT id_prod FROM tab_det_orden
UNION
SELECT id_prod FROM tab_det_compra
ORDER BY id_prod;

--Ejercicio 16 (UNION ALL): Combine en una lista (incluyendo duplicados) los códigos de ciudad asociados a
--proveedores y los vinculados a encabezados de compra.

SELECT id_ciud FROM tab_prov
UNION ALL
SELECT id_ciud_entrega FROM tab_enc_compra;


--Ejercicio 17 (HAVING): Muestre los IDs de las facturas en tab_det_compra que tengan asociadas más de 1
--línea de detalle/producto.


SELECT id_factura, COUNT(*) AS lineas
FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT(*) > 1
ORDER BY id_factura;



--Ejercicio 18 (EXISTS): Seleccione los proveedores en tab_prov que tengan al menos una factura registrada en
--tab_enc_compra.

SELECT p.id_prov, p.nom_comp
FROM tab_prov p
WHERE EXISTS (SELECT 1
                 FROM tab_enc_compra e
                WHERE e.id_prov = p.id_prov)
 ORDER BY p.id_prov;


--Ejercicio 19 (LIKE): Liste los proveedores cuyo correo electrónico (campo compuesto datos_prov) contenga la
--subcadena 'tecnosum'.

SELECT id_prov, nom_comp, email_prov
FROM tab_prov
WHERE email_prov LIKE '%tecnosum%';


--Ejercicio 20 (BETWEEN): Consulte los encabezados de compra (tab_enc_compra) con fecha de factura entre el
--1 de febrero de 2024 y el 29 de febrero de 2024.


SELECT * FROM tab_enc_compra
WHERE fec_factura BETWEEN DATE '2024-02-01' AND DATE '2024-02-29'
ORDER BY fec_factura;









