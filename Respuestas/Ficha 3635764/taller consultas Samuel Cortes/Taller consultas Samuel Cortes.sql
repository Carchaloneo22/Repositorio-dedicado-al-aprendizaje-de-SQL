
-- =========================================
-- ELIMINACIÓN DE TABLAS Y TIPOS
-- =========================================

DROP TABLE IF EXISTS tab_pagos CASCADE;
DROP TABLE IF EXISTS tab_det_compra CASCADE;
DROP TABLE IF EXISTS tab_enc_compra CASCADE;
DROP TABLE IF EXISTS tab_orden_compra CASCADE;
DROP TABLE IF EXISTS tab_prod_prov CASCADE;
DROP TABLE IF EXISTS tab_prov CASCADE;
DROP TABLE IF EXISTS tab_areas CASCADE;
DROP TABLE IF EXISTS tab_prod CASCADE;
DROP TABLE IF EXISTS tab_ciud CASCADE;
DROP TABLE IF EXISTS tab_dptos CASCADE;
DROP TABLE IF EXISTS tab_pmtros CASCADE;

DROP TYPE IF EXISTS datos CASCADE;


-- =========================================
-- TABLA DE PARÁMETROS
-- =========================================

CREATE TABLE tab_pmtros
(
    id_empresa  DECIMAL(10,0) NOT NULL,
    dia_pagos1  DECIMAL(1,0) NOT NULL,
    dia_pagos2  DECIMAL(1,0) NOT NULL,
    dia_pagos3  DECIMAL(1,0) NOT NULL,
    num_orden   DECIMAL(6,0) NOT NULL,

    PRIMARY KEY (id_empresa),

    CHECK (dia_pagos1 BETWEEN 1 AND 7),
    CHECK (dia_pagos2 BETWEEN 1 AND 7),
    CHECK (dia_pagos3 BETWEEN 1 AND 7)
);


-- =========================================
-- TIPO COMPUESTO: DATOS DEL PROVEEDOR
-- =========================================

CREATE TYPE datos AS
(
    direccion VARCHAR(150),
    telefono  DECIMAL(10,0),
    correo    VARCHAR(100)
);


-- =========================================
-- TABLA DE DEPARTAMENTOS
-- =========================================

CREATE TABLE tab_dptos
(
    id_dpto  VARCHAR(2) NOT NULL,
    nom_dpto VARCHAR(100) NOT NULL,

    PRIMARY KEY (id_dpto)
);


-- =========================================
-- TABLA DE CIUDADES
-- =========================================

CREATE TABLE tab_ciud
(
    id_ciud  VARCHAR(5) NOT NULL,
    nom_ciud VARCHAR(100) NOT NULL,
    id_dpto  VARCHAR(2) NOT NULL,

    PRIMARY KEY (id_ciud),

    FOREIGN KEY (id_dpto)
        REFERENCES tab_dptos(id_dpto)
);


-- =========================================
-- TABLA DE PROVEEDORES
-- =========================================

CREATE TABLE tab_prov
(
    id_prov     DECIMAL(10,0) NOT NULL,
    nom_prov    VARCHAR(100) NOT NULL,
    ape_prov    VARCHAR(100) NOT NULL,
    nom_comp    VARCHAR(150) NOT NULL,
    datos_prov  datos,
    id_ciud     VARCHAR(5) NOT NULL,
    val_cupocre DECIMAL(10,0) NOT NULL DEFAULT 0,
    val_puntos  DECIMAL(3,0) NOT NULL,
    num_fact    DECIMAL(6,0) NOT NULL,
    ind_estado  BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (id_prov),

    FOREIGN KEY (id_ciud)
        REFERENCES tab_ciud(id_ciud),

    CHECK (val_cupocre >= 0),
    CHECK (val_puntos >= 0),
    CHECK (num_fact >= 0)
);


-- =========================================
-- TABLA DE PRODUCTOS
-- =========================================

CREATE TABLE tab_prod
(
    id_prod    SMALLINT NOT NULL,
    id_ref     VARCHAR(50) NOT NULL,
    nom_prod   VARCHAR(150) NOT NULL,
    ind_estado BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (id_prod),

    UNIQUE (id_ref)
);


-- =========================================
-- TABLA DE PRODUCTOS POR PROVEEDOR
-- =========================================

CREATE TABLE tab_prod_prov
(
    id_prov  DECIMAL(10,0) NOT NULL,
    id_prod  SMALLINT NOT NULL,
    val_prod DECIMAL(10,0) NOT NULL,
    ind_disp BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (id_prov, id_prod),

    FOREIGN KEY (id_prov)
        REFERENCES tab_prov(id_prov),

    FOREIGN KEY (id_prod)
        REFERENCES tab_prod(id_prod),

    CHECK (val_prod >= 0)
);


-- =========================================
-- TABLA DE ÁREAS
-- =========================================

CREATE TABLE tab_areas
(
    id_area    DECIMAL(2,0) NOT NULL,
    nom_area   VARCHAR(100) NOT NULL,
    nom_encarg VARCHAR(100) NOT NULL,

    PRIMARY KEY (id_area)
);


-- =========================================
-- TABLA DE ÓRDENES DE COMPRA
-- =========================================

CREATE TABLE tab_orden_compra
(
    id_orden  DECIMAL(6,0) NOT NULL,
    fec_orden DATE NOT NULL,
    id_area   DECIMAL(2,0) NOT NULL,
    id_prod   SMALLINT NOT NULL,
    val_cant  SMALLINT NOT NULL,

    PRIMARY KEY (id_orden),

    FOREIGN KEY (id_prod)
        REFERENCES tab_prod(id_prod),

    FOREIGN KEY (id_area)
        REFERENCES tab_areas(id_area),

    CHECK (val_cant > 0)
);


-- =========================================
-- TABLA DE ENCABEZADO DE COMPRA
-- =========================================

CREATE TABLE tab_enc_compra
(
    id_factura  DECIMAL(6,0) NOT NULL,
    fec_factura DATE NOT NULL,
    id_ciud     VARCHAR(5) NOT NULL,
    id_prov     DECIMAL(10,0) NOT NULL,
    val_observa TEXT,

    PRIMARY KEY (id_factura),

    FOREIGN KEY (id_ciud)
        REFERENCES tab_ciud(id_ciud),

    FOREIGN KEY (id_prov)
        REFERENCES tab_prov(id_prov)
);


-- =========================================
-- TABLA DE DETALLE DE COMPRA
-- =========================================

CREATE TABLE tab_det_compra
(
    id_factura DECIMAL(6,0) NOT NULL,
    id_prod    SMALLINT NOT NULL,
    val_cant   SMALLINT NOT NULL,
    val_bruto  DECIMAL(10,0) NOT NULL,
    val_descu  DECIMAL(10,0) NOT NULL,
    val_iva    DECIMAL(10,0) NOT NULL,
    val_neto   DECIMAL(10,0) NOT NULL,

    PRIMARY KEY (id_factura, id_prod),

    FOREIGN KEY (id_factura)
        REFERENCES tab_enc_compra(id_factura),

    FOREIGN KEY (id_prod)
        REFERENCES tab_prod(id_prod),

    CHECK (val_cant > 0),
    CHECK (val_bruto >= 0),
    CHECK (val_descu >= 0),
    CHECK (val_iva >= 0),
    CHECK (val_neto >= 0)
);


-- =========================================
-- TABLA DE PAGOS
-- =========================================

CREATE TABLE tab_pagos
(
    id_factura DECIMAL(6,0) NOT NULL,
    id_pago    DECIMAL(2,0) NOT NULL,
    fec_pago   DATE NOT NULL,
    val_pago   DECIMAL(10,0) NOT NULL,
    val_saldo  DECIMAL(10,0) NOT NULL,

    PRIMARY KEY (id_factura, id_pago),

    FOREIGN KEY (id_factura)
        REFERENCES tab_enc_compra(id_factura),

    CHECK (id_pago > 0),
    CHECK (val_pago >= 0),
    CHECK (val_saldo >= 0)
);


-- =========================================
-- 1. TABLA DE PARAMETROS
-- =========================================

INSERT INTO tab_pmtros
(id_empresa, dia_pagos1, dia_pagos2, dia_pagos3, num_orden)
VALUES
(9001234567, 1, 3, 5, 1001);


-- =========================================
-- 2. TABLA DE DEPARTAMENTOS
-- =========================================

INSERT INTO tab_dptos (id_dpto, nom_dpto)
VALUES
('05', 'Antioquia'),
('11', 'Cundinamarca'),
('76', 'Valle del Cauca'),
('08', 'Atlantico'),
('68', 'Santander');


-- =========================================
-- 3. TABLA DE CIUDADES
-- =========================================

INSERT INTO tab_ciud (id_ciud, nom_ciud, id_dpto)
VALUES
('05001', 'Medellin', '05'),
('05088', 'Bello', '05'),
('11001', 'Bogota', '11'),
('76001', 'Cali', '76'),
('08001', 'Barranquilla', '08'),
('68001', 'Bucaramanga', '68'),
('05266', 'Envigado', '05'),
('11011', 'La Calera', '11'),
('76109', 'Buenaventura', '76'),
('68276', 'Floridablanca', '68');


-- =========================================
-- 4. TABLA DE PROVEEDORES
-- =========================================

INSERT INTO tab_prov
(id_prov, nom_prov, ape_prov, nom_comp, datos_prov,
 id_ciud, val_cupocre, val_puntos, num_fact, ind_estado)
VALUES
(1000000001, 'Carlos', 'Perez', 'Distribuciones CP',
 ROW('Calle 10 # 20-30', 3001234567, 'cp@gmail.com')::datos,
 '05001', 5000000, 85, 100, TRUE),

(1000000002, 'Maria', 'Gomez', 'Comercial MG',
 ROW('Carrera 15 # 30-40', 3012345678, 'mg@gmail.com')::datos,
 '11001', 8000000, 92, 150, TRUE),

(1000000003, 'Juan', 'Rodriguez', 'Suministros JR',
 ROW('Calle 50 # 12-15', 3023456789, 'jr@gmail.com')::datos,
 '76001', 3500000, 78, 80, TRUE),

(1000000004, 'Laura', 'Martinez', 'Papeleria LM',
 ROW('Carrera 8 # 25-60', 3034567890, 'lm@gmail.com')::datos,
 '08001', 6000000, 95, 120, TRUE),

(1000000005, 'Andres', 'Lopez', 'Tecnologia AL',
 ROW('Calle 40 # 18-20', 3045678901, 'al@gmail.com')::datos,
 '68001', 4500000, 88, 90, TRUE),

(1000000006, 'Sofia', 'Ramirez', 'Importaciones SR',
 ROW('Carrera 20 # 15-10', 3056789012, 'sr@gmail.com')::datos,
 '05088', 2500000, 75, 60, FALSE),

(1000000007, 'Pedro', 'Torres', 'Comercial PT',
 ROW('Calle 12 # 10-20', 3067890123, 'pt@gmail.com')::datos,
 '05266', 7000000, 98, 200, TRUE),

(1000000008, 'Elena', 'Castro', 'Suministros EC',
 ROW('Carrera 9 # 45-30', 3078901234, 'ec@gmail.com')::datos,
 '11011', 5500000, 90, 110, TRUE);


-- =========================================
-- 5. TABLA DE PRODUCTOS
-- =========================================

INSERT INTO tab_prod
(id_prod, id_ref, nom_prod, ind_estado)
VALUES
(1, 'REF001', 'Computador portatil', TRUE),
(2, 'REF002', 'Mouse inalambrico', TRUE),
(3, 'REF003', 'Teclado mecanico', TRUE),
(4, 'REF004', 'Monitor 24 pulgadas', TRUE),
(5, 'REF005', 'Impresora multifuncional', TRUE),
(6, 'REF006', 'Disco duro externo', TRUE),
(7, 'REF007', 'Memoria USB 64GB', FALSE),
(8, 'REF008', 'Silla ergonomica', TRUE),
(9, 'REF009', 'Escritorio oficina', TRUE),
(10, 'REF010', 'Audifonos', TRUE);


-- =========================================
-- 6. TABLA DE AREAS
-- =========================================

INSERT INTO tab_areas
(id_area, nom_area, nom_encarg)
VALUES
(1, 'Administracion', 'Carlos Mendoza'),
(2, 'Contabilidad', 'Laura Fernandez'),
(3, 'Sistemas', 'Andres Ramirez'),
(4, 'Compras', 'Maria Torres'),
(5, 'Recursos Humanos', 'Sofia Castro'),
(6, 'Ventas', 'Pedro Gomez'),
(7, 'Almacen', 'Juan Rodriguez'),
(8, 'Logistica', 'Diana Martinez');


-- =========================================
-- 7. TABLA DE PRODUCTOS POR PROVEEDOR
-- =========================================

INSERT INTO tab_prod_prov
(id_prov, id_prod, val_prod, ind_disp)
VALUES
(1000000001, 1, 2500000, TRUE),
(1000000001, 2, 45000, TRUE),
(1000000002, 3, 180000, TRUE),
(1000000002, 4, 850000, TRUE),
(1000000003, 5, 950000, TRUE),
(1000000003, 6, 280000, TRUE),
(1000000004, 7, 35000, FALSE),
(1000000004, 8, 650000, TRUE),
(1000000005, 9, 750000, TRUE),
(1000000005, 10, 120000, TRUE),
(1000000006, 1, 2450000, TRUE),
(1000000006, 3, 175000, TRUE),
(1000000007, 2, 42000, TRUE),
(1000000007, 5, 920000, TRUE),
(1000000008, 4, 830000, TRUE);


-- =========================================
-- 8. TABLA DE ORDENES DE COMPRA
-- =========================================

INSERT INTO tab_orden_compra
(id_orden, fec_orden, id_area, id_prod, val_cant)
VALUES
(1001, '2026-01-10', 3, 1, 5),
(1002, '2026-01-12', 4, 2, 20),
(1003, '2026-01-15', 1, 3, 10),
(1004, '2026-01-18', 3, 4, 8),
(1005, '2026-01-20', 7, 5, 4),
(1006, '2026-02-01', 3, 6, 12),
(1007, '2026-02-05', 4, 8, 6),
(1008, '2026-02-10', 1, 9, 3),
(1009, '2026-02-15', 6, 10, 15),
(1010, '2026-02-20', 5, 7, 25);


-- =========================================
-- 9. TABLA DE ENCABEZADO DE COMPRA
-- =========================================

INSERT INTO tab_enc_compra
(id_factura, fec_factura, id_ciud, id_prov, val_observa)
VALUES
(2001, '2026-01-11', '05001', 1000000001, 'Compra de computadores'),
(2002, '2026-01-13', '11001', 1000000002, 'Compra de perifericos'),
(2003, '2026-01-16', '76001', 1000000003, 'Compra de impresoras'),
(2004, '2026-01-19', '08001', 1000000004, 'Compra de mobiliario'),
(2005, '2026-01-22', '68001', 1000000005, 'Compra de accesorios'),
(2006, '2026-02-02', '05088', 1000000006, 'Compra de equipos'),
(2007, '2026-02-06', '05266', 1000000007, 'Compra de mouse'),
(2008, '2026-02-11', '11011', 1000000008, 'Compra de monitores');


-- =========================================
-- 10. TABLA DE DETALLE DE COMPRA
-- =========================================

INSERT INTO tab_det_compra
(id_factura, id_prod, val_cant, val_bruto,
 val_descu, val_iva, val_neto)
VALUES
(2001, 1, 2, 5000000, 250000, 902500, 5652500),
(2001, 2, 10, 450000, 20000, 81700, 511700),

(2002, 3, 5, 900000, 45000, 162450, 1017450),
(2002, 4, 2, 1700000, 100000, 304000, 1904000),

(2003, 5, 3, 2850000, 150000, 513000, 3213000),
(2003, 6, 4, 1120000, 50000, 203300, 1273300),

(2004, 8, 4, 2600000, 100000, 475000, 2975000),
(2004, 7, 20, 700000, 20000, 129200, 809200),

(2005, 9, 3, 2250000, 100000, 408500, 2558500),
(2005, 10, 5, 600000, 30000, 108300, 678300),

(2006, 1, 1, 2450000, 50000, 456000, 2856000),
(2006, 3, 3, 525000, 25000, 95000, 595000),

(2007, 2, 15, 630000, 30000, 114000, 714000),
(2007, 5, 2, 1840000, 40000, 342000, 2142000),

(2008, 4, 3, 2490000, 90000, 456000, 2856000);


-- =========================================
-- 11. TABLA DE PAGOS
-- =========================================

INSERT INTO tab_pagos
(id_factura, id_pago, fec_pago, val_pago, val_saldo)
VALUES
(2001, 1, '2026-01-15', 3000000, 3164200),
(2001, 2, '2026-01-25', 2164200, 0),

(2002, 1, '2026-01-20', 1500000, 1421450),
(2002, 2, '2026-01-30', 1421450, 0),

(2003, 1, '2026-01-25', 2000000, 2484300),
(2003, 2, '2026-02-05', 2484300, 0),

(2004, 1, '2026-01-28', 2000000, 1784200),
(2004, 2, '2026-02-10', 1784200, 0),

(2005, 1, '2026-02-01', 1500000, 1736800),
(2005, 2, '2026-02-15', 1736800, 0),

(2006, 1, '2026-02-10', 2000000, 1451000),
(2006, 2, '2026-02-20', 1451000, 0),

(2007, 1, '2026-02-15', 1000000, 1856000),
(2007, 2, '2026-02-25', 1856000, 0),

(2008, 1, '2026-02-20', 1500000, 1356000),
(2008, 2, '2026-02-28', 1356000, 0);


-- =====================================================
-- TALLER PRACTICO DE SQL: CONSULTAS Y AUDITORIA
-- SISTEMA DE COMPRAS Y PROVEEDORES
-- =====================================================

-- BLOQUE I: CONSULTAS BASICAS, FILTROS Y AGREGACIONES

-- EJERCICIO 1: SELECT BASICA
SELECT *
FROM tab_prov;


-- EJERCICIO 2: SELECT CON WHERE
SELECT *
FROM tab_prod
WHERE ind_estado = TRUE;


-- EJERCICIO 3: SELECT CON ORDER BY
SELECT *
FROM tab_prov
ORDER BY nom_prov ASC;


-- EJERCICIO 4: SELECT CON LIMIT
SELECT id_ciud, nom_ciud
FROM tab_ciud
LIMIT 10;


-- EJERCICIO 5: SELECT CON COUNT
SELECT COUNT(*) AS total_ordenes
FROM tab_orden_compra;


-- EJERCICIO 6: SELECT CON SUM
SELECT SUM(val_neto) AS total_neto_facturado
FROM tab_det_compra;


-- EJERCICIO 7: SELECT CON AVG
SELECT AVG(val_cupocre) AS promedio_cupo_credito
FROM tab_prov;


-- EJERCICIO 8: SELECT CON GROUP BY
SELECT
    d.id_dpto,
    d.nom_dpto,
    COUNT(c.id_ciud) AS total_ciudades
FROM tab_dptos d
INNER JOIN tab_ciud c
    ON d.id_dpto = c.id_dpto
GROUP BY d.id_dpto, d.nom_dpto
ORDER BY d.nom_dpto;


-- EJERCICIO 9: INSERT
INSERT INTO tab_areas
(id_area, nom_area, nom_encarg)
VALUES
(9, 'Auditoría', 'Elena Beltrán');


-- EJERCICIO 10: UPDATE
UPDATE tab_prov
SET val_puntos = 98
WHERE id_prov = 1000000001;


-- BLOQUE II: MODIFICACIONES, JOINS Y SUBCONSULTAS

-- EJERCICIO 11: DELETE
DELETE FROM tab_orden_compra
WHERE id_orden = 100030;


-- EJERCICIO 12: JOIN
SELECT
    c.nom_ciud AS nombre_ciudad,
    d.nom_dpto AS nombre_departamento
FROM tab_ciud c
INNER JOIN tab_dptos d
    ON c.id_dpto = d.id_dpto;


-- EJERCICIO 13: SUBCONSULTA
SELECT *
FROM tab_prod
WHERE id_prod IN (
    SELECT id_prod
    FROM tab_prod_prov
    WHERE val_prod > 2000000
);


-- EJERCICIO 14: CASE
SELECT
    id_prov,
    nom_prov,
    ape_prov,
    val_cupocre,
    CASE
        WHEN val_cupocre >= 5000000 THEN 'Cupo Alto'
        WHEN val_cupocre >= 3000000 THEN 'Cupo Medio'
        ELSE 'Cupo Bajo'
    END AS clasificacion_cupo
FROM tab_prov;


-- EJERCICIO 15: UNION
SELECT id_prod
FROM tab_orden_compra

UNION

SELECT id_prod
FROM tab_det_compra;


-- EJERCICIO 16: UNION ALL
SELECT id_ciud
FROM tab_prov

UNION ALL

SELECT id_ciud
FROM tab_enc_compra;


-- EJERCICIO 17: HAVING
SELECT
    id_factura,
    COUNT(id_prod) AS total_productos
FROM tab_det_compra
GROUP BY id_factura
HAVING COUNT(id_prod) > 1;


-- EJERCICIO 18: EXISTS
SELECT *
FROM tab_prov p
WHERE EXISTS (
    SELECT 1
    FROM tab_enc_compra e
    WHERE e.id_prov = p.id_prov
);


-- EJERCICIO 19: LIKE
SELECT
    id_prov,
    nom_prov,
    ape_prov,
    (datos_prov).correo AS correo
FROM tab_prov
WHERE (datos_prov).correo LIKE '%tecnosum%';


-- EJERCICIO 20: BETWEEN
SELECT *
FROM tab_enc_compra
WHERE fec_factura BETWEEN '2024-02-01' AND '2024-02-29';


-- =====================================================
-- FIN DEL TALLER PRACTICO
-- =====================================================
