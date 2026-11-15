-- =============================================================================
-- SCRIPT DE BASE DE DATOS: SISTEMA DE COMPRAS Y PROVEEDORES (PostgreSQL)
-- Crea las tablas, el tipo compuesto y carga datos de ejemplo para probar
-- los 30 ejercicios del taller.
-- Orden de uso: 1) ejecutar este script completo, 2) ejecutar las consultas.
-- Nota: los datos ya traen casos para los ejercicios (orden 100030, correo
-- 'tecnosum', facturas de febrero de 2024, un nombre con espacios y una
-- observación con '%%'). El área 9 NO existe a propósito: la crea el ejercicio 9.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. LIMPIEZA (se borra primero lo que depende de otras tablas)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS tab_pagos        CASCADE;
DROP TABLE IF EXISTS tab_det_compra   CASCADE;
DROP TABLE IF EXISTS tab_enc_compra   CASCADE;
DROP TABLE IF EXISTS tab_orden_compra CASCADE;
DROP TABLE IF EXISTS tab_prod_prov    CASCADE;
DROP TABLE IF EXISTS tab_prov         CASCADE;
DROP TABLE IF EXISTS tab_areas        CASCADE;
DROP TABLE IF EXISTS tab_prod         CASCADE;
DROP TABLE IF EXISTS tab_ciud         CASCADE;
DROP TABLE IF EXISTS tab_dptos        CASCADE;
DROP TABLE IF EXISTS tab_pmtros       CASCADE;
DROP TYPE  IF EXISTS datos            CASCADE;

-- -----------------------------------------------------------------------------
-- 2. TIPO COMPUESTO (UDT) con los datos de contacto del proveedor
-- -----------------------------------------------------------------------------
CREATE TYPE datos AS
(
    direccion VARCHAR(150),
    telefono  DECIMAL(10,0),
    correo    VARCHAR(100)
);

-- -----------------------------------------------------------------------------
-- 3. TABLAS
-- -----------------------------------------------------------------------------
CREATE TABLE tab_pmtros
(
    id_empresa DECIMAL(10,0) NOT NULL,
    dia_pagos1 DECIMAL(1,0)  NOT NULL,
    dia_pagos2 DECIMAL(1,0)  NOT NULL,
    dia_pagos3 DECIMAL(1,0)  NOT NULL,
    num_orden  DECIMAL(6,0)  NOT NULL,
    PRIMARY KEY (id_empresa),
    CHECK (dia_pagos1 BETWEEN 1 AND 7),
    CHECK (dia_pagos2 BETWEEN 1 AND 7),
    CHECK (dia_pagos3 BETWEEN 1 AND 7)
);

CREATE TABLE tab_dptos
(
    id_dpto  VARCHAR(2)   NOT NULL,
    nom_dpto VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_dpto)
);

CREATE TABLE tab_ciud
(
    id_ciud  VARCHAR(5)   NOT NULL,
    nom_ciud VARCHAR(100) NOT NULL,
    id_dpto  VARCHAR(2)   NOT NULL,
    PRIMARY KEY (id_ciud),
    FOREIGN KEY (id_dpto) REFERENCES tab_dptos (id_dpto)
);

CREATE TABLE tab_prov
(
    id_prov     DECIMAL(10,0) NOT NULL,
    nom_prov    VARCHAR(100)  NOT NULL,
    ape_prov    VARCHAR(100)  NOT NULL,
    nom_comp    VARCHAR(150)  NOT NULL,
    datos_prov  datos,
    id_ciud     VARCHAR(5)    NOT NULL,
    val_cupocre DECIMAL(10,0) NOT NULL DEFAULT 0,
    val_puntos  DECIMAL(3,0)  NOT NULL,
    num_fact    DECIMAL(6,0)  NOT NULL,
    ind_estado  BOOLEAN       NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_prov),
    FOREIGN KEY (id_ciud) REFERENCES tab_ciud (id_ciud),
    CHECK (val_cupocre >= 0),
    CHECK (val_puntos  >= 0),
    CHECK (num_fact    >= 0)
);

CREATE TABLE tab_prod
(
    id_prod    SMALLINT     NOT NULL,
    id_ref     VARCHAR(50)  NOT NULL,
    nom_prod   VARCHAR(150) NOT NULL,
    ind_estado BOOLEAN      NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_prod),
    UNIQUE (id_ref)
);

CREATE TABLE tab_prod_prov
(
    id_prov  DECIMAL(10,0) NOT NULL,
    id_prod  SMALLINT      NOT NULL,
    val_prod DECIMAL(10,0) NOT NULL,
    ind_disp BOOLEAN       NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_prov, id_prod),
    FOREIGN KEY (id_prov) REFERENCES tab_prov (id_prov),
    FOREIGN KEY (id_prod) REFERENCES tab_prod (id_prod),
    CHECK (val_prod >= 0)
);

CREATE TABLE tab_areas
(
    id_area    DECIMAL(2,0) NOT NULL,
    nom_area   VARCHAR(100) NOT NULL,
    nom_encarg VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_area)
);

CREATE TABLE tab_orden_compra
(
    id_orden  DECIMAL(6,0) NOT NULL,
    fec_orden DATE         NOT NULL,
    id_area   DECIMAL(2,0) NOT NULL,
    id_prod   SMALLINT     NOT NULL,
    val_cant  SMALLINT     NOT NULL,
    PRIMARY KEY (id_orden),
    FOREIGN KEY (id_area) REFERENCES tab_areas (id_area),
    FOREIGN KEY (id_prod) REFERENCES tab_prod  (id_prod),
    CHECK (val_cant > 0)
);

CREATE TABLE tab_enc_compra
(
    id_factura  DECIMAL(6,0)  NOT NULL,
    fec_factura DATE          NOT NULL,
    id_ciud     VARCHAR(5)    NOT NULL,
    id_prov     DECIMAL(10,0) NOT NULL,
    val_observa TEXT,
    PRIMARY KEY (id_factura),
    FOREIGN KEY (id_ciud) REFERENCES tab_ciud (id_ciud),
    FOREIGN KEY (id_prov) REFERENCES tab_prov (id_prov)
);

CREATE TABLE tab_det_compra
(
    id_factura DECIMAL(6,0)  NOT NULL,
    id_prod    SMALLINT      NOT NULL,
    val_cant   SMALLINT      NOT NULL,
    val_bruto  DECIMAL(10,0) NOT NULL,
    val_descu  DECIMAL(10,0) NOT NULL,
    val_iva    DECIMAL(10,0) NOT NULL,
    val_neto   DECIMAL(10,0) NOT NULL,
    PRIMARY KEY (id_factura, id_prod),
    FOREIGN KEY (id_factura) REFERENCES tab_enc_compra (id_factura),
    FOREIGN KEY (id_prod)    REFERENCES tab_prod       (id_prod),
    CHECK (val_cant  > 0),
    CHECK (val_bruto >= 0),
    CHECK (val_descu >= 0),
    CHECK (val_iva   >= 0),
    CHECK (val_neto  >= 0)
);

CREATE TABLE tab_pagos
(
    id_factura DECIMAL(6,0)  NOT NULL,
    id_pago    DECIMAL(2,0)  NOT NULL,
    fec_pago   DATE          NOT NULL,
    val_pago   DECIMAL(10,0) NOT NULL,
    val_saldo  DECIMAL(10,0) NOT NULL,
    PRIMARY KEY (id_factura, id_pago),
    FOREIGN KEY (id_factura) REFERENCES tab_enc_compra (id_factura),
    CHECK (id_pago   > 0),
    CHECK (val_pago  >= 0),
    CHECK (val_saldo >= 0)
);

-- -----------------------------------------------------------------------------
-- 4. DATOS DE EJEMPLO (se insertan de padres a hijos por las llaves foráneas)
-- -----------------------------------------------------------------------------
INSERT INTO tab_pmtros (id_empresa, dia_pagos1, dia_pagos2, dia_pagos3, num_orden)
VALUES (9001234567, 1, 3, 5, 100031);

INSERT INTO tab_dptos (id_dpto, nom_dpto) VALUES
('05', 'Antioquia'),
('08', 'Atlántico'),
('11', 'Cundinamarca'),
('13', 'Bolívar'),
('68', 'Santander'),
('76', 'Valle del Cauca');

INSERT INTO tab_ciud (id_ciud, nom_ciud, id_dpto) VALUES
('05001', 'Medellín',      '05'),
('05088', 'Bello',         '05'),
('05266', 'Envigado',      '05'),
('08001', 'Barranquilla',  '08'),
('08758', 'Soledad',       '08'),
('11001', 'Bogotá',        '11'),
('11011', 'La Calera',     '11'),
('13001', 'Cartagena',     '13'),
('68001', 'Bucaramanga',   '68'),
('68276', 'Floridablanca', '68'),
('76001', 'Cali',          '76'),
('76109', 'Buenaventura',  '76');

INSERT INTO tab_prov (id_prov, nom_prov, ape_prov, nom_comp, datos_prov,
                      id_ciud, val_cupocre, val_puntos, num_fact, ind_estado) VALUES
(1000000001, 'Carlos', 'Pérez',    'Distribuciones CP',
    ROW('Calle 10 # 20-30',    3001234567, 'cp@proveedores.com')::datos,        '05001', 5000000, 85, 100, TRUE),
(1000000002, 'María',  'Gómez',    'Comercial MG',
    ROW('Carrera 15 # 30-40',  3012345678, 'mg@proveedores.com')::datos,        '11001', 8000000, 92, 150, TRUE),
(1000000003, 'Juan',   'Rodríguez','Suministros JR',
    ROW('Calle 50 # 12-15',    3023456789, 'jr@proveedores.com')::datos,        '76001', 3500000, 78,  80, TRUE),
(1000000004, 'Laura',  'Martínez', 'Papelería LM',
    ROW('Carrera 8 # 25-60',   3034567890, 'lm@proveedores.com')::datos,        '08001', 6000000, 95, 120, TRUE),
(1000000005, 'Andrés', 'López',    'Tecnología AL',
    ROW('Calle 40 # 18-20',    3045678901, 'al@proveedores.com')::datos,        '68001', 4500000, 88,  90, TRUE),
(1000000006, 'Sofía',  'Ramírez',  'Importaciones SR',
    ROW('Carrera 20 # 15-10',  3056789012, 'sr@proveedores.com')::datos,        '05088', 2500000, 75,  60, FALSE),
(1000000007, 'Pedro',  'Torres',   'Comercial PT',
    ROW('Calle 12 # 10-20',    3067890123, 'pt@proveedores.com')::datos,        '05266', 7000000, 97, 200, TRUE),
(1000000008, 'Elena',  'Castro',   'Suministros EC',
    ROW('Carrera 9 # 45-30',   3078901234, 'ec@proveedores.com')::datos,        '11011', 5500000, 90, 110, TRUE),
(1000000009, 'Luis',   'Vega',     'Tecnosum SAS',
    ROW('Calle 1 # 2-3',       3101112233, 'ventas@tecnosum.com')::datos,       '05001', 4000000, 80,  10, TRUE);

INSERT INTO tab_prod (id_prod, id_ref, nom_prod, ind_estado) VALUES
(1,  'REF001', 'Computador portátil',      TRUE),
(2,  'REF002', 'Mouse inalámbrico',        TRUE),
(3,  'REF003', 'Teclado mecánico',         TRUE),
(4,  'REF004', 'Monitor 24 pulgadas',      TRUE),
(5,  'REF005', 'Impresora multifuncional', TRUE),
(6,  'REF006', 'Disco duro externo',       TRUE),
(7,  'REF007', 'Memoria USB 64GB',         FALSE),
(8,  'REF008', 'Silla ergonómica',         TRUE),
(9,  'REF009', 'Escritorio de oficina',    TRUE),
(10, 'REF010', 'Audífonos',                TRUE),
(11, 'REF011', '  Mouse Gamer ',           TRUE),   -- espacios sobrantes (ejercicio 22)
(12, 'REF012', 'Silla Oficina',            TRUE);

INSERT INTO tab_prod_prov (id_prov, id_prod, val_prod, ind_disp) VALUES
(1000000001, 1,  2500000, TRUE),
(1000000001, 2,    45000, TRUE),
(1000000002, 3,   180000, TRUE),
(1000000002, 4,   850000, TRUE),
(1000000003, 5,   950000, TRUE),
(1000000003, 6,   280000, TRUE),
(1000000004, 7,    35000, FALSE),
(1000000004, 8,   650000, TRUE),
(1000000005, 9,   750000, TRUE),
(1000000005, 10,  120000, TRUE),
(1000000006, 1,  2450000, TRUE),
(1000000007, 5,   920000, TRUE),
(1000000008, 4,   830000, TRUE),
(1000000009, 11,  150000, TRUE),
(1000000009, 12,  400000, TRUE);

-- Áreas 1 a 8. El área 9 la inserta el ejercicio 9.
INSERT INTO tab_areas (id_area, nom_area, nom_encarg) VALUES
(1, 'Administración',   'Carlos Mendoza'),
(2, 'Contabilidad',     'Laura Fernández'),
(3, 'Sistemas',         'Andrés Ramírez'),
(4, 'Compras',          'María Torres'),
(5, 'Recursos Humanos', 'Sofía Castro'),
(6, 'Ventas',           'Pedro Gómez'),
(7, 'Almacén',          'Juan Rodríguez'),
(8, 'Logística',        'Diana Martínez');

INSERT INTO tab_orden_compra (id_orden, fec_orden, id_area, id_prod, val_cant) VALUES
(100021, '2026-01-10', 3, 1,   5),
(100022, '2026-01-12', 4, 2,  20),
(100023, '2026-01-15', 1, 3,  10),
(100024, '2026-01-18', 3, 4,   8),
(100025, '2026-01-20', 7, 5,   4),
(100026, '2026-02-01', 3, 6,  12),
(100027, '2026-02-05', 4, 8,   6),
(100028, '2026-02-10', 1, 9,   3),
(100029, '2026-02-15', 6, 10, 15),
(100030, '2026-02-20', 5, 7,  25);   -- orden que borra el ejercicio 11

INSERT INTO tab_enc_compra (id_factura, fec_factura, id_ciud, id_prov, val_observa) VALUES
(3001, '2024-01-28', '05001', 1000000001, 'Compra de computadores'),
(3002, '2024-02-05', '11001', 1000000002, 'Compra de perifericos'),
(3003, '2024-02-14', '76001', 1000000003, 'Compra de impresoras'),
(3004, '2024-02-29', '08001', 1000000004, 'Compra de mobiliario'),
(3005, '2024-03-04', '68001', 1000000005, 'Compra de accesorios'),
(3006, '2026-01-15', '05088', 1000000006, 'Compra con error de codificaci%%n'),  -- ejercicio 23
(3007, '2026-02-10', '05266', 1000000007, 'Compra de mouse'),
(3008, '2026-02-20', '11011', 1000000008, 'Compra de monitores'),
(3009, '2026-03-02', '05001', 1000000009, 'Compra gamer');

INSERT INTO tab_det_compra (id_factura, id_prod, val_cant, val_bruto, val_descu, val_iva, val_neto) VALUES
(3001, 1,  2, 5000000, 250000, 902500, 5652500),
(3001, 2, 10,  450000,  20000,  81700,  511700),
(3002, 3,  5,  900000,  45000, 162450, 1017450),
(3002, 4,  2, 1700000, 100000, 304000, 1904000),
(3003, 5,  3, 2850000, 150000, 513000, 3213000),
(3003, 6,  4, 1120000,  50000, 203300, 1273300),
(3004, 8,  4, 2600000, 100000, 475000, 2975000),
(3005, 10, 5,  600000,  30000, 108300,  678300),
(3005, 12, 2,  800000,      0, 152000,  952000),
(3006, 1,  1, 2500000,  50000, 465500, 2915500),
(3006, 3,  3,  540000,  25000,  97850,  612850),
(3007, 2, 15,  675000,  30000, 122550,  767550),
(3007, 5,  2, 1900000,  40000, 353400, 2213400),
(3008, 4,  3, 2550000,  90000, 467400, 2927400),
(3009, 11, 2,  300000,      0,  57000,  357000),
(3009, 12, 1,  400000,      0,  76000,  476000);

-- Cada factura se paga en dos abonos; el saldo del último abono queda en 0.
INSERT INTO tab_pagos (id_factura, id_pago, fec_pago, val_pago, val_saldo) VALUES
(3001, 1, '2024-01-28', 3699000, 2465200),
(3001, 2, '2024-02-12', 2465200,       0),
(3002, 1, '2024-02-05', 1753000, 1168450),
(3002, 2, '2024-02-20', 1168450,       0),
(3003, 1, '2024-02-14', 2692000, 1794300),
(3003, 2, '2024-02-29', 1794300,       0),
(3004, 1, '2024-02-29', 1785000, 1190000),
(3004, 2, '2024-03-15', 1190000,       0),
(3005, 1, '2024-03-04',  978000,  652300),
(3005, 2, '2024-03-19',  652300,       0),
(3006, 1, '2026-01-15', 2117000, 1411350),
(3006, 2, '2026-01-30', 1411350,       0),
(3007, 1, '2026-02-10', 1789000, 1191950),
(3007, 2, '2026-02-25', 1191950,       0),
(3008, 1, '2026-02-20', 1756000, 1171400),
(3008, 2, '2026-03-07', 1171400,       0),
(3009, 1, '2026-03-02',  500000,  333000),
(3009, 2, '2026-03-17',  333000,       0);

-- -----------------------------------------------------------------------------
-- 5. VERIFICACIÓN: cantidad de filas cargadas por tabla
-- -----------------------------------------------------------------------------
SELECT 'tab_dptos' AS tabla, COUNT(*) AS filas FROM tab_dptos
UNION ALL SELECT 'tab_ciud',         COUNT(*) FROM tab_ciud
UNION ALL SELECT 'tab_prov',         COUNT(*) FROM tab_prov
UNION ALL SELECT 'tab_prod',         COUNT(*) FROM tab_prod
UNION ALL SELECT 'tab_prod_prov',    COUNT(*) FROM tab_prod_prov
UNION ALL SELECT 'tab_areas',        COUNT(*) FROM tab_areas
UNION ALL SELECT 'tab_orden_compra', COUNT(*) FROM tab_orden_compra
UNION ALL SELECT 'tab_enc_compra',   COUNT(*) FROM tab_enc_compra
UNION ALL SELECT 'tab_det_compra',   COUNT(*) FROM tab_det_compra
UNION ALL SELECT 'tab_pagos',        COUNT(*) FROM tab_pagos;
