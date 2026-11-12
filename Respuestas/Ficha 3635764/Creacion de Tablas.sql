-- =============================================================================
-- CREACIÓN DE TABLAS BÁSICAS - SISTEMA DE COMPRAS A PROVEEDORES
-- =============================================================================

-- 1. Parámetros generales de la empresa
CREATE TABLE tab_pmtros
(
    id_empresa DECIMAL(10,0) NOT NULL,
    dia_pagos1 SMALLINT      NOT NULL,
    dia_pagos2 SMALLINT      NOT NULL,
    dia_pagos3 SMALLINT      NOT NULL,
    num_orden  DECIMAL(6,0)  NOT NULL,
    PRIMARY KEY (id_empresa)
);

-- 2. Departamentos
CREATE TABLE tab_dptos
(
    id_dpto  VARCHAR(2)  NOT NULL,
    nom_dpto VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_dpto)
);

-- 3. Ciudades
CREATE TABLE tab_ciud
(
    id_ciud  VARCHAR(5)  NOT NULL,
    nom_ciud VARCHAR(40) NOT NULL,
    id_dpto  VARCHAR(2)  NOT NULL,
    PRIMARY KEY (id_ciud),
    FOREIGN KEY (id_dpto) REFERENCES tab_dptos (id_dpto)
);

-- 4. Proveedores
CREATE TABLE tab_prov
(
    id_prov     DECIMAL(10,0) NOT NULL,
    nom_prov    VARCHAR(30)   NOT NULL,
    apel_prov   VARCHAR(30)   NOT NULL,
    ape2_prov   VARCHAR(30),
    nom_comp    VARCHAR(90)   NOT NULL,
    dir_prov    VARCHAR(60)   NOT NULL,
    tel_prov    VARCHAR(10)   NOT NULL,
    email_prov  VARCHAR(50)   NOT NULL,
    id_ciud     VARCHAR(5)    NOT NULL,
    val_cupocre DECIMAL(12,0) NOT NULL DEFAULT 0,
    val_puntos  DECIMAL(3,0)  NOT NULL DEFAULT 0,
    num_fact    DECIMAL(6,0)  NOT NULL,
    ind_estado  BOOLEAN       NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_prov),
    FOREIGN KEY (id_ciud) REFERENCES tab_ciud (id_ciud)
);

-- 5. Productos
CREATE TABLE tab_prod
(
    id_prod    SMALLINT    NOT NULL,
    id_ref     VARCHAR(10) NOT NULL,
    nom_prod   VARCHAR(40) NOT NULL,
    ind_estado BOOLEAN     NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_prod)
);

-- 6. Productos que vende cada proveedor
CREATE TABLE tab_prod_prov
(
    id_prov  DECIMAL(10,0) NOT NULL,
    id_prod  SMALLINT      NOT NULL,
    val_prod DECIMAL(10,0) NOT NULL,
    ind_disp BOOLEAN       NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_prov, id_prod),
    FOREIGN KEY (id_prov) REFERENCES tab_prov (id_prov),
    FOREIGN KEY (id_prod) REFERENCES tab_prod (id_prod)
);

-- 7. Áreas de la empresa
CREATE TABLE tab_areas
(
    id_area    DECIMAL(2,0) NOT NULL,
    nom_area   VARCHAR(30)  NOT NULL,
    nom_encarg VARCHAR(50)  NOT NULL,
    PRIMARY KEY (id_area)
);

-- 8. Órdenes de compra (Encabezado)
CREATE TABLE tab_orden_compra
(
    id_orden  DECIMAL(6,0) NOT NULL,
    fec_orden TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_area   DECIMAL(2,0) NOT NULL,
    PRIMARY KEY (id_orden),
    FOREIGN KEY (id_area) REFERENCES tab_areas (id_area)
);

-- 9. Detalle de órdenes de compra
CREATE TABLE tab_det_orden
(
    id_orden DECIMAL(6,0) NOT NULL,
    id_prod  SMALLINT     NOT NULL,
    val_cant SMALLINT     NOT NULL,
    PRIMARY KEY (id_orden, id_prod),
    FOREIGN KEY (id_orden) REFERENCES tab_orden_compra (id_orden),
    FOREIGN KEY (id_prod)  REFERENCES tab_prod (id_prod)
);

-- 10. Facturas de compra (Encabezado)
CREATE TABLE tab_enc_compra
(
    id_factura      DECIMAL(6,0)  NOT NULL,
    fec_factura     DATE          NOT NULL DEFAULT CURRENT_DATE,
    id_prov         DECIMAL(10,0) NOT NULL,
    id_ciud_entrega VARCHAR(5)    NOT NULL,
    val_observa     VARCHAR(150),
    PRIMARY KEY (id_factura),
    FOREIGN KEY (id_prov)         REFERENCES tab_prov (id_prov),
    FOREIGN KEY (id_ciud_entrega) REFERENCES tab_ciud (id_ciud)
);

-- 11. Facturas de compra (Detalle)
CREATE TABLE tab_det_compra
(
    id_factura DECIMAL(6,0)  NOT NULL,
    id_prod    SMALLINT      NOT NULL,
    val_cant   SMALLINT      NOT NULL,
    val_unit   DECIMAL(10,0) NOT NULL,
    val_descu  DECIMAL(12,0) NOT NULL DEFAULT 0,
    porc_iva   DECIMAL(4,2)  NOT NULL DEFAULT 19,
    val_bruto  DECIMAL(12,0) NOT NULL,
    val_iva    DECIMAL(12,0) NOT NULL,
    val_neto   DECIMAL(12,0) NOT NULL,
    PRIMARY KEY (id_factura, id_prod),
    FOREIGN KEY (id_factura) REFERENCES tab_enc_compra (id_factura),
    FOREIGN KEY (id_prod)    REFERENCES tab_prod (id_prod)
);

-- 12. Pagos
CREATE TABLE tab_pagos
(
    id_factura DECIMAL(6,0)  NOT NULL,
    id_pago    SMALLINT      NOT NULL,
    fec_pago   DATE          NOT NULL,
    val_pago   DECIMAL(12,0) NOT NULL,
    PRIMARY KEY (id_factura, id_pago),
    FOREIGN KEY (id_factura) REFERENCES tab_enc_compra (id_factura)
);