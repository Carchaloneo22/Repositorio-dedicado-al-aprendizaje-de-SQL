
begin;
-- 1. PARÁMETROS GENERALES
CREATE TABLE tab_pmtros (
    id_empresa DECIMAL(10,0) NOT NULL,
    dia_pagos1 SMALLINT NOT NULL,
    dia_pagos2 SMALLINT NOT NULL,
    dia_pagos3 SMALLINT NOT NULL,
    num_orden DECIMAL(6,0) NOT NULL,
    CONSTRAINT pk_pmtros PRIMARY KEY (id_empresa),
    CONSTRAINT ck_pmtros_id CHECK (id_empresa > 0),
    CONSTRAINT ck_pmtros_dias CHECK (
        dia_pagos1 BETWEEN 1 AND 7 AND dia_pagos2 BETWEEN 1 AND 7
        AND dia_pagos3 BETWEEN 1 AND 7
        AND dia_pagos1 < dia_pagos2 AND dia_pagos2 < dia_pagos3
    ),
    CONSTRAINT ck_pmtros_orden CHECK (num_orden > 0)
);

-- 2. GEOGRAFÍA: códigos como texto para preservar ceros iniciales.
CREATE TABLE tab_dptos (
    id_dpto VARCHAR(2) NOT NULL,
    nom_dpto VARCHAR(60) NOT NULL,
    CONSTRAINT pk_dptos PRIMARY KEY (id_dpto),
    CONSTRAINT uq_dptos_nombre UNIQUE (nom_dpto),
    CONSTRAINT ck_dptos_id CHECK (id_dpto ~ '^[0-9]{2}$'),
    CONSTRAINT ck_dptos_nombre CHECK (BTRIM(nom_dpto) <> '')
);

CREATE TABLE tab_ciud (
    id_ciud VARCHAR(5) NOT NULL,
    nom_ciud VARCHAR(80) NOT NULL,
    id_dpto VARCHAR(2) NOT NULL,
    CONSTRAINT pk_ciud PRIMARY KEY (id_ciud),
    CONSTRAINT fk_ciud_dpto FOREIGN KEY (id_dpto)
        REFERENCES tab_dptos (id_dpto)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_ciud_nombre UNIQUE (id_dpto, nom_ciud),
    CONSTRAINT ck_ciud_id CHECK (id_ciud ~ '^[0-9]{5}$'),
    CONSTRAINT ck_ciud_prefijo CHECK (LEFT(id_ciud, 2) = id_dpto),
    CONSTRAINT ck_ciud_nombre CHECK (BTRIM(nom_ciud) <> '')
);

-- 3. PREFIJOS INTERNACIONALES
CREATE TABLE tab_prefijos (
    cod_prefijo VARCHAR(4) NOT NULL,
    nom_pais VARCHAR(60) NOT NULL,
    num_digitos_min SMALLINT NOT NULL,
    num_digitos_max SMALLINT NOT NULL,
    CONSTRAINT pk_prefijos PRIMARY KEY (cod_prefijo),
    CONSTRAINT uq_prefijos_pais UNIQUE (nom_pais),
    CONSTRAINT ck_prefijos_formato CHECK (cod_prefijo ~ '^\+[1-9][0-9]{0,2}$'),
    CONSTRAINT ck_prefijos_pais CHECK (BTRIM(nom_pais) <> ''),
    CONSTRAINT ck_prefijos_min CHECK (num_digitos_min BETWEEN 1 AND 15),
    CONSTRAINT ck_prefijos_max CHECK (
        num_digitos_max BETWEEN num_digitos_min AND 15
    )
);

INSERT INTO tab_prefijos (cod_prefijo, nom_pais, num_digitos_min, num_digitos_max)
VALUES ('+57', 'Colombia', 10, 10);

-- 4. PROVEEDORES
CREATE TABLE tab_prov (
    id_prov DECIMAL(10,0) NOT NULL,
    nom_prov VARCHAR(60) NOT NULL,
    ape1_prov VARCHAR(60) NOT NULL,
    ape2_prov VARCHAR(60),
    nom_comp VARCHAR(185) GENERATED ALWAYS AS
        (nom_prov || ' ' || ape1_prov || COALESCE(' ' || ape2_prov, '')) STORED,
    dir_prov VARCHAR(100) NOT NULL,
    email_prov VARCHAR(100) NOT NULL,
    id_ciud VARCHAR(5) NOT NULL,
    val_cupocre DECIMAL(12,0) NOT NULL DEFAULT 0,
    val_puntos DECIMAL(3,0) NOT NULL DEFAULT 0,
    num_fact DECIMAL(6,0) NOT NULL,
    ind_estado BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_prov PRIMARY KEY (id_prov),
    CONSTRAINT fk_prov_ciud FOREIGN KEY (id_ciud)
        REFERENCES tab_ciud (id_ciud)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_prov_email UNIQUE (email_prov),
    CONSTRAINT ck_prov_id CHECK (id_prov > 0),
    CONSTRAINT ck_prov_nombre CHECK (BTRIM(nom_prov) <> '' AND BTRIM(ape1_prov) <> ''),
    CONSTRAINT ck_prov_direccion CHECK (BTRIM(dir_prov) <> ''),
    CONSTRAINT ck_prov_email CHECK (
        email_prov ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'
    ),
    CONSTRAINT ck_prov_cupo CHECK (val_cupocre >= 0),
    CONSTRAINT ck_prov_puntos CHECK (val_puntos BETWEEN 0 AND 100),
    CONSTRAINT ck_prov_fact CHECK (num_fact > 0),
    CONSTRAINT ck_prov_inactivo_sin_cupo CHECK (ind_estado = TRUE OR val_cupocre = 0)
);

-- 5. TELÉFONOS DE PROVEEDORES
CREATE TABLE tab_tel_prov (
    id_tel_prov BIGINT GENERATED ALWAYS AS IDENTITY,
    id_prov DECIMAL(10,0) NOT NULL,
    cod_prefijo VARCHAR(4) NOT NULL,
    num_telefono VARCHAR(15) NOT NULL,
    tipo_tel VARCHAR(15) NOT NULL DEFAULT 'CELULAR',
    ind_principal BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_tel_prov PRIMARY KEY (id_tel_prov),
    CONSTRAINT fk_telprov_prov FOREIGN KEY (id_prov)
        REFERENCES tab_prov (id_prov) ON DELETE CASCADE,
    CONSTRAINT fk_telprov_prefijo FOREIGN KEY (cod_prefijo)
        REFERENCES tab_prefijos (cod_prefijo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_telprov_numero UNIQUE (id_prov, cod_prefijo, num_telefono),
    CONSTRAINT ck_telprov_numero CHECK (num_telefono ~ '^[0-9]+$'),
    CONSTRAINT ck_telprov_tipo CHECK (tipo_tel IN ('FIJO', 'CELULAR', 'WHATSAPP', 'OTRO'))
);
CREATE UNIQUE INDEX uq_telprov_principal
    ON tab_tel_prov (id_prov) WHERE ind_principal = TRUE;

-- 6. PRODUCTOS Y CATÁLOGO DE PROVEEDORES
CREATE TABLE tab_prod (
    id_prod VARCHAR(30) NOT NULL,
    nom_prod VARCHAR(80) NOT NULL,
    ind_estado BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_prod PRIMARY KEY (id_prod),
    CONSTRAINT ck_prod_id CHECK (BTRIM(id_prod) <> ''),
    CONSTRAINT ck_prod_nombre CHECK (BTRIM(nom_prod) <> '')
);

CREATE TABLE tab_prod_prov (
    id_prov DECIMAL(10,0) NOT NULL,
    id_prod VARCHAR(30) NOT NULL,
    val_prod DECIMAL(10,0) NOT NULL,
    ind_disp BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_prod_prov PRIMARY KEY (id_prov, id_prod),
    CONSTRAINT fk_prodprov_prov FOREIGN KEY (id_prov)
        REFERENCES tab_prov (id_prov) ON DELETE RESTRICT,
    CONSTRAINT fk_prodprov_prod FOREIGN KEY (id_prod)
        REFERENCES tab_prod (id_prod) ON DELETE RESTRICT,
    CONSTRAINT ck_prodprov_valor CHECK (val_prod > 0)
);

-- 7. ÁREAS Y ÓRDENES DE COMPRA
CREATE TABLE tab_areas (
    id_area SMALLINT GENERATED ALWAYS AS IDENTITY,
    nom_area VARCHAR(60) NOT NULL,
    nom_encarg VARCHAR(100) NOT NULL,
    CONSTRAINT pk_areas PRIMARY KEY (id_area),
    CONSTRAINT uq_areas_nombre UNIQUE (nom_area),
    CONSTRAINT ck_areas_id CHECK (id_area > 0),
    CONSTRAINT ck_areas_nombre CHECK (BTRIM(nom_area) <> ''),
    CONSTRAINT ck_areas_encargado CHECK (BTRIM(nom_encarg) <> '')
);

CREATE TABLE tab_orden_compra (
    id_orden BIGINT GENERATED ALWAYS AS IDENTITY,
    fec_orden TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_area SMALLINT NOT NULL,
    CONSTRAINT pk_orden PRIMARY KEY (id_orden),
    CONSTRAINT fk_orden_area FOREIGN KEY (id_area)
        REFERENCES tab_areas (id_area) ON DELETE RESTRICT,
    CONSTRAINT ck_orden_id CHECK (id_orden > 0)
);

CREATE TABLE tab_det_orden (
    id_orden BIGINT NOT NULL,
    id_prod VARCHAR(30) NOT NULL,
    val_cant SMALLINT NOT NULL,
    CONSTRAINT pk_det_orden PRIMARY KEY (id_orden, id_prod),
    CONSTRAINT fk_detorden_orden FOREIGN KEY (id_orden)
        REFERENCES tab_orden_compra (id_orden) ON DELETE CASCADE,
    CONSTRAINT fk_detorden_prod FOREIGN KEY (id_prod)
        REFERENCES tab_prod (id_prod) ON DELETE RESTRICT,
    CONSTRAINT ck_detorden_cant CHECK (val_cant > 0)
);

-- 8. ENCABEZADOS Y DETALLES DE FACTURA
CREATE TABLE tab_enc_compra (
    id_factura BIGINT GENERATED ALWAYS AS IDENTITY,
    fec_factura DATE NOT NULL DEFAULT CURRENT_DATE,
    id_prov DECIMAL(10,0) NOT NULL,
    id_ciud_entrega VARCHAR(5) NOT NULL,
    val_observa TEXT,
    CONSTRAINT pk_enc_compra PRIMARY KEY (id_factura),
    CONSTRAINT fk_enc_prov FOREIGN KEY (id_prov)
        REFERENCES tab_prov (id_prov) ON DELETE RESTRICT,
    CONSTRAINT fk_enc_ciud FOREIGN KEY (id_ciud_entrega)
        REFERENCES tab_ciud (id_ciud) ON DELETE RESTRICT,
    CONSTRAINT ck_enc_id CHECK (id_factura > 0),
    CONSTRAINT ck_enc_fecha CHECK (fec_factura >= DATE '2000-01-01')
);

CREATE TABLE tab_det_compra (
    id_factura BIGINT NOT NULL,
    id_prod VARCHAR(30) NOT NULL,
    val_cant SMALLINT NOT NULL,
    val_unit DECIMAL(10,0) NOT NULL,
    val_descu DECIMAL(12,0) NOT NULL DEFAULT 0,
    porc_iva DECIMAL(4,2) NOT NULL DEFAULT 19,
    val_bruto DECIMAL(12,0) GENERATED ALWAYS AS
        (val_cant * val_unit) STORED,
    val_iva DECIMAL(12,0) GENERATED ALWAYS AS
        (ROUND((val_cant * val_unit - val_descu) * porc_iva / 100)) STORED,
    val_neto DECIMAL(12,0) GENERATED ALWAYS AS
        (val_cant * val_unit - val_descu
         + ROUND((val_cant * val_unit - val_descu) * porc_iva / 100)) STORED,
    CONSTRAINT pk_det_compra PRIMARY KEY (id_factura, id_prod),
    CONSTRAINT fk_detcomp_enc FOREIGN KEY (id_factura)
        REFERENCES tab_enc_compra (id_factura) ON DELETE CASCADE,
    CONSTRAINT fk_detcomp_prod FOREIGN KEY (id_prod)
        REFERENCES tab_prod (id_prod) ON DELETE RESTRICT,
    CONSTRAINT ck_detcomp_cant CHECK (val_cant > 0),
    CONSTRAINT ck_detcomp_unit CHECK (val_unit > 0),
    CONSTRAINT ck_detcomp_descu CHECK (val_descu >= 0 AND val_descu <= val_cant * val_unit),
    CONSTRAINT ck_detcomp_iva CHECK (porc_iva IN (0, 5, 19))
);

-- 9. PAGOS: el saldo se calcula en la vista, no se almacena.
CREATE TABLE tab_pagos (
    id_factura BIGINT NOT NULL,
    id_pago BIGINT GENERATED ALWAYS AS IDENTITY,
    fec_pago DATE NOT NULL,
    val_pago DECIMAL(12,0) NOT NULL,
    CONSTRAINT pk_pagos PRIMARY KEY (id_factura, id_pago),
    CONSTRAINT fk_pagos_enc FOREIGN KEY (id_factura)
        REFERENCES tab_enc_compra (id_factura) ON DELETE RESTRICT,
    CONSTRAINT ck_pagos_id CHECK (id_pago > 0),
    CONSTRAINT ck_pagos_valor CHECK (val_pago > 0)
);

-- 10. RELACIÓN N:M ENTRE ÓRDENES Y FACTURAS
CREATE TABLE tab_rel_orden_factura (
    id_orden BIGINT NOT NULL,
    id_factura BIGINT NOT NULL,
    CONSTRAINT pk_rel_orden_factura PRIMARY KEY (id_orden, id_factura),
    CONSTRAINT fk_rel_orden FOREIGN KEY (id_orden)
        REFERENCES tab_orden_compra (id_orden) ON DELETE CASCADE,
    CONSTRAINT fk_rel_factura FOREIGN KEY (id_factura)
        REFERENCES tab_enc_compra (id_factura) ON DELETE CASCADE
);


-- ÍNDICES DE APOYO PARA CONSULTAS Y CLAVES FORÁNEAS
CREATE INDEX idx_ciud_dpto ON tab_ciud (id_dpto);
CREATE INDEX idx_prov_ciud ON tab_prov (id_ciud);
CREATE INDEX idx_telprov_prov ON tab_tel_prov (id_prov);
CREATE INDEX idx_prodprov_prod ON tab_prod_prov (id_prod);
CREATE INDEX idx_orden_area ON tab_orden_compra (id_area);
CREATE INDEX idx_detorden_prod ON tab_det_orden (id_prod);
CREATE INDEX idx_enc_prov ON tab_enc_compra (id_prov);
CREATE INDEX idx_enc_fecha ON tab_enc_compra (fec_factura);
CREATE INDEX idx_detcomp_prod ON tab_det_compra (id_prod);
CREATE INDEX idx_pagos_fecha ON tab_pagos (fec_pago);
CREATE INDEX idx_rel_factura ON tab_rel_orden_factura (id_factura);

COMMIT;
