
BEGIN;
SET search_path TO public;


INSERT INTO public.tab_pmtros (id_empresa, dia_pagos1, dia_pagos2, dia_pagos3, num_orden) VALUES
    (9000000011, 1, 3, 5, 500001),
    (9000000012, 1, 3, 5, 500002),
    (9000000013, 1, 3, 5, 500003),
    (9000000014, 1, 3, 5, 500004),
    (9000000015, 1, 3, 5, 500005),
    (9000000016, 1, 3, 5, 500006),
    (9000000017, 1, 3, 5, 500007),
    (9000000018, 1, 3, 5, 500008),
    (9000000019, 1, 3, 5, 500009),
    (9000000020, 1, 3, 5, 500010),
    (9000000021, 1, 3, 5, 500011),
    (9000000022, 1, 3, 5, 500012),
    (9000000023, 1, 3, 5, 500013),
    (9000000024, 1, 3, 5, 500014),
    (9000000025, 1, 3, 5, 500015),
    (9000000026, 1, 3, 5, 500016),
    (9000000027, 1, 3, 5, 500017),
    (9000000028, 1, 3, 5, 500018),
    (9000000029, 1, 3, 5, 500019),
    (9000000030, 1, 3, 5, 500020);

INSERT INTO public.tab_dptos (id_dpto, nom_dpto) VALUES
    ('01', 'Amazonas - Prueba'),
    ('02', 'Antioquia - Prueba'),
    ('03', 'Arauca - Prueba'),
    ('04', 'Atlantico - Prueba'),
    ('05', 'Bogota D.C. - Prueba'),
    ('06', 'Bolivar - Prueba'),
    ('07', 'Boyaca - Prueba'),
    ('08', 'Caldas - Prueba'),
    ('09', 'Caqueta - Prueba'),
    ('10', 'Casanare - Prueba'),
    ('11', 'Cauca - Prueba'),
    ('12', 'Cesar - Prueba'),
    ('13', 'Choco - Prueba'),
    ('14', 'Cordoba - Prueba'),
    ('15', 'Cundinamarca - Prueba'),
    ('16', 'Guainia - Prueba'),
    ('17', 'Guaviare - Prueba'),
    ('18', 'Huila - Prueba'),
    ('19', 'La Guajira - Prueba'),
    ('20', 'Magdalena - Prueba');

INSERT INTO public.tab_ciud (id_ciud, nom_ciud, id_dpto) VALUES
    ('01001', 'Ciudad de prueba Amazonas', '01'),
    ('02001', 'Ciudad de prueba Antioquia', '02'),
    ('03001', 'Ciudad de prueba Arauca', '03'),
    ('04001', 'Ciudad de prueba Atlantico', '04'),
    ('05001', 'Ciudad de prueba Bogota D.C.', '05'),
    ('06001', 'Ciudad de prueba Bolivar', '06'),
    ('07001', 'Ciudad de prueba Boyaca', '07'),
    ('08001', 'Ciudad de prueba Caldas', '08'),
    ('09001', 'Ciudad de prueba Caqueta', '09'),
    ('10001', 'Ciudad de prueba Casanare', '10'),
    ('11001', 'Ciudad de prueba Cauca', '11'),
    ('12001', 'Ciudad de prueba Cesar', '12'),
    ('13001', 'Ciudad de prueba Choco', '13'),
    ('14001', 'Ciudad de prueba Cordoba', '14'),
    ('15001', 'Ciudad de prueba Cundinamarca', '15'),
    ('16001', 'Ciudad de prueba Guainia', '16'),
    ('17001', 'Ciudad de prueba Guaviare', '17'),
    ('18001', 'Ciudad de prueba Huila', '18'),
    ('19001', 'Ciudad de prueba La Guajira', '19'),
    ('20001', 'Ciudad de prueba Magdalena', '20');

INSERT INTO public.tab_prefijos (cod_prefijo, nom_pais, num_digitos_min, num_digitos_max) VALUES
    ('+1', 'Estados Unidos - Prueba', 10, 10),
    ('+34', 'España - Prueba', 9, 9),
    ('+44', 'Reino Unido - Prueba', 10, 10),
    ('+49', 'Alemania - Prueba', 11, 11),
    ('+33', 'Francia - Prueba', 9, 9),
    ('+39', 'Italia - Prueba', 10, 10),
    ('+52', 'Mexico - Prueba', 10, 10),
    ('+55', 'Brasil - Prueba', 11, 11),
    ('+56', 'Chile - Prueba', 9, 9),
    ('+54', 'Argentina - Prueba', 10, 10),
    ('+51', 'Peru - Prueba', 9, 9),
    ('+58', 'Venezuela - Prueba', 10, 10),
    ('+593', 'Ecuador - Prueba', 9, 9),
    ('+598', 'Uruguay - Prueba', 8, 8),
    ('+61', 'Australia - Prueba', 9, 9),
    ('+64', 'Nueva Zelanda - Prueba', 9, 9),
    ('+81', 'Japon - Prueba', 10, 10),
    ('+82', 'Corea del Sur - Prueba', 10, 10),
    ('+86', 'China - Prueba', 11, 11),
    ('+91', 'India - Prueba', 10, 10);

INSERT INTO public.tab_prov (id_prov, nom_prov, ape1_prov, ape2_prov, dir_prov, email_prov, id_ciud, val_cupocre, val_puntos, num_fact, ind_estado) VALUES
    (8000000001, 'Carlos', 'Gomez', 'Comercial', 'Calle 10 # 12-01', 'proveedor01@pruebas.com', '01001', 5000000, 80, 100, True),
    (8000000002, 'Laura', 'Rodriguez', 'Comercial', 'Calle 11 # 12-02', 'proveedor02@pruebas.com', '02001', 5100000, 81, 101, True),
    (8000000003, 'Andres', 'Martinez', 'Comercial', 'Calle 12 # 12-03', 'proveedor03@pruebas.com', '03001', 5200000, 82, 102, True),
    (8000000004, 'Diana', 'Hernandez', 'Comercial', 'Calle 13 # 12-04', 'proveedor04@pruebas.com', '04001', 5300000, 83, 103, True),
    (8000000005, 'Jorge', 'Lopez', 'Comercial', 'Calle 14 # 12-05', 'proveedor05@pruebas.com', '05001', 5400000, 84, 104, True),
    (8000000006, 'Camila', 'Torres', 'Comercial', 'Calle 15 # 12-06', 'proveedor06@pruebas.com', '06001', 5500000, 85, 105, True),
    (8000000007, 'Miguel', 'Ramirez', 'Comercial', 'Calle 16 # 12-07', 'proveedor07@pruebas.com', '07001', 5600000, 86, 106, True),
    (8000000008, 'Valentina', 'Moreno', 'Comercial', 'Calle 17 # 12-08', 'proveedor08@pruebas.com', '08001', 5700000, 87, 107, True),
    (8000000009, 'Sebastian', 'Jimenez', 'Comercial', 'Calle 18 # 12-09', 'proveedor09@pruebas.com', '09001', 5800000, 88, 108, True),
    (8000000010, 'Natalia', 'Alvarez', 'Comercial', 'Calle 19 # 12-10', 'proveedor10@pruebas.com', '10001', 5900000, 89, 109, True),
    (8000000011, 'Felipe', 'Ruiz', 'Comercial', 'Calle 20 # 12-11', 'proveedor11@pruebas.com', '11001', 6000000, 90, 110, True),
    (8000000012, 'Paula', 'Castillo', 'Comercial', 'Calle 21 # 12-12', 'proveedor12@pruebas.com', '12001', 6100000, 91, 111, True),
    (8000000013, 'Daniel', 'Sanchez', 'Comercial', 'Calle 22 # 12-13', 'proveedor13@pruebas.com', '13001', 6200000, 92, 112, True),
    (8000000014, 'Mariana', 'Acosta', 'Comercial', 'Calle 23 # 12-14', 'proveedor14@pruebas.com', '14001', 6300000, 93, 113, True),
    (8000000015, 'Diego', 'Ortiz', 'Comercial', 'Calle 24 # 12-15', 'proveedor15@pruebas.com', '15001', 6400000, 94, 114, True),
    (8000000016, 'Juliana', 'Vargas', 'Comercial', 'Calle 25 # 12-16', 'proveedor16@pruebas.com', '16001', 6500000, 95, 115, True),
    (8000000017, 'Santiago', 'Mendoza', 'Comercial', 'Calle 26 # 12-17', 'proveedor17@pruebas.com', '17001', 6600000, 96, 116, True),
    (8000000018, 'Isabella', 'Rojas', 'Comercial', 'Calle 27 # 12-18', 'proveedor18@pruebas.com', '18001', 6700000, 97, 117, True),
    (8000000019, 'Mateo', 'Cabrera', 'Comercial', 'Calle 28 # 12-19', 'proveedor19@pruebas.com', '19001', 6800000, 98, 118, True),
    (8000000020, 'Sara', 'Pineda', 'Comercial', 'Calle 29 # 12-20', 'proveedor20@pruebas.com', '20001', 6900000, 99, 119, True);

INSERT INTO public.tab_tel_prov (id_prov, cod_prefijo, num_telefono, tipo_tel, ind_principal) VALUES
    (8000000001, '+1', '2025550101', 'CELULAR', True),
    (8000000002, '+34', '612345678', 'WHATSAPP', True),
    (8000000003, '+44', '7700900101', 'CELULAR', True),
    (8000000004, '+49', '15123456789', 'WHATSAPP', True),
    (8000000005, '+33', '612345679', 'CELULAR', True),
    (8000000006, '+39', '3123456789', 'WHATSAPP', True),
    (8000000007, '+52', '5512345678', 'CELULAR', True),
    (8000000008, '+55', '11987654321', 'WHATSAPP', True),
    (8000000009, '+56', '912345678', 'CELULAR', True),
    (8000000010, '+54', '1123456789', 'WHATSAPP', True),
    (8000000011, '+51', '912345678', 'CELULAR', True),
    (8000000012, '+58', '4123456789', 'WHATSAPP', True),
    (8000000013, '+593', '991234567', 'CELULAR', True),
    (8000000014, '+598', '99123456', 'WHATSAPP', True),
    (8000000015, '+61', '412345678', 'CELULAR', True),
    (8000000016, '+64', '211234567', 'WHATSAPP', True),
    (8000000017, '+81', '9012345678', 'CELULAR', True),
    (8000000018, '+82', '1012345678', 'WHATSAPP', True),
    (8000000019, '+86', '13800138000', 'CELULAR', True),
    (8000000020, '+91', '9876543210', 'WHATSAPP', True);

INSERT INTO public.tab_prod (id_prod, nom_prod, ind_estado) VALUES
    ('SKU-TEC-001', 'Portatil empresarial 14 pulgadas', True),
    ('SKU-TEC-002', 'Mouse inalambrico', True),
    ('SKU-TEC-003', 'Teclado mecanico', True),
    ('SKU-TEC-004', 'Monitor LED 24 pulgadas', True),
    ('SKU-TEC-005', 'Impresora laser', True),
    ('SKU-TEC-006', 'Disco SSD 1 TB', True),
    ('SKU-TEC-007', 'Memoria RAM 16 GB', True),
    ('SKU-TEC-008', 'Router empresarial', True),
    ('SKU-TEC-009', 'Switch de red 24 puertos', True),
    ('SKU-TEC-010', 'Cable UTP categoria 6', True),
    ('SKU-TEC-011', 'Camara IP', True),
    ('SKU-TEC-012', 'Telefono IP', True),
    ('SKU-TEC-013', 'Regulador de voltaje', True),
    ('SKU-TEC-014', 'UPS 1500 VA', True),
    ('SKU-TEC-015', 'Licencia de software anual', True),
    ('SKU-TEC-016', 'Disco duro externo 2 TB', True),
    ('SKU-TEC-017', 'Adaptador USB-C', True),
    ('SKU-TEC-018', 'Base refrigerante', True),
    ('SKU-TEC-019', 'Proyector multimedia', True),
    ('SKU-TEC-020', 'Escaner documental', True);

INSERT INTO public.tab_prod_prov (id_prov, id_prod, val_prod, ind_disp) VALUES
    (8000000001, 'SKU-TEC-001', 2850000, True),
    (8000000002, 'SKU-TEC-002', 65000, True),
    (8000000003, 'SKU-TEC-003', 180000, True),
    (8000000004, 'SKU-TEC-004', 720000, True),
    (8000000005, 'SKU-TEC-005', 890000, True),
    (8000000006, 'SKU-TEC-006', 310000, True),
    (8000000007, 'SKU-TEC-007', 195000, True),
    (8000000008, 'SKU-TEC-008', 430000, True),
    (8000000009, 'SKU-TEC-009', 1250000, True),
    (8000000010, 'SKU-TEC-010', 520000, True),
    (8000000011, 'SKU-TEC-011', 260000, True),
    (8000000012, 'SKU-TEC-012', 390000, True),
    (8000000013, 'SKU-TEC-013', 145000, True),
    (8000000014, 'SKU-TEC-014', 980000, True),
    (8000000015, 'SKU-TEC-015', 650000, True),
    (8000000016, 'SKU-TEC-016', 340000, True),
    (8000000017, 'SKU-TEC-017', 55000, True),
    (8000000018, 'SKU-TEC-018', 95000, True),
    (8000000019, 'SKU-TEC-019', 1750000, True),
    (8000000020, 'SKU-TEC-020', 810000, True);

INSERT INTO public.tab_areas (nom_area, nom_encarg) VALUES
    ('Administracion - Prueba', 'Encargado 01'),
    ('Contabilidad - Prueba', 'Encargado 02'),
    ('Sistemas - Prueba', 'Encargado 03'),
    ('Recursos Humanos - Prueba', 'Encargado 04'),
    ('Compras - Prueba', 'Encargado 05'),
    ('Ventas - Prueba', 'Encargado 06'),
    ('Logistica - Prueba', 'Encargado 07'),
    ('Produccion - Prueba', 'Encargado 08'),
    ('Almacen - Prueba', 'Encargado 09'),
    ('Mantenimiento - Prueba', 'Encargado 10'),
    ('Mercadeo - Prueba', 'Encargado 11'),
    ('Calidad - Prueba', 'Encargado 12'),
    ('Servicio al cliente - Prueba', 'Encargado 13'),
    ('Operaciones - Prueba', 'Encargado 14'),
    ('Proyectos - Prueba', 'Encargado 15'),
    ('Auditoria - Prueba', 'Encargado 16'),
    ('Transporte - Prueba', 'Encargado 17'),
    ('Seguridad - Prueba', 'Encargado 18'),
    ('Comercial - Prueba', 'Encargado 19'),
    ('Direccion - Prueba', 'Encargado 20');

-- 10. Ordenes: id_orden es identity; guardar la correspondencia para los detalles.
CREATE TEMP TABLE tmp_test_ordenes (n INTEGER PRIMARY KEY, id_orden BIGINT NOT NULL) ON COMMIT DROP;
WITH nuevas AS (
    INSERT INTO public.tab_orden_compra (fec_orden, id_area)
    SELECT TIMESTAMP '2026-10-01 08:00:00' + (a.n-1) * INTERVAL '1 day', a.id_area
    FROM (
        SELECT id_area, ROW_NUMBER() OVER (ORDER BY id_area) AS n
        FROM public.tab_areas WHERE nom_area LIKE '%- Prueba'
    ) a
    WHERE a.n <= 20
    RETURNING id_orden
)
INSERT INTO tmp_test_ordenes
SELECT ROW_NUMBER() OVER (ORDER BY id_orden), id_orden FROM nuevas;

-- 11. Detalles de orden
INSERT INTO public.tab_det_orden (id_orden, id_prod, val_cant)
SELECT o.id_orden, p.id_prod, 2 + o.n
FROM tmp_test_ordenes o
JOIN public.tab_prod p ON p.id_prod = 'SKU-TEC-' || LPAD(o.n::TEXT, 3, '0')
ORDER BY o.n;

-- 12. Facturas: id_factura es identity; guardar su correspondencia.
CREATE TEMP TABLE tmp_test_facturas (n INTEGER PRIMARY KEY, id_factura BIGINT NOT NULL, id_prov DECIMAL(10,0) NOT NULL) ON COMMIT DROP;
WITH nuevas AS (
    INSERT INTO public.tab_enc_compra (fec_factura, id_prov, id_ciud_entrega, val_observa)
    SELECT DATE '2026-10-05' + g, p.id_prov, p.id_ciud, 'Factura de prueba ' || LPAD(g::TEXT, 2, '0')
    FROM generate_series(1,20) g
    JOIN public.tab_prov p ON p.id_prov = 8000000000 + g
    RETURNING id_factura, id_prov
)
INSERT INTO tmp_test_facturas
SELECT ROW_NUMBER() OVER (ORDER BY id_factura), id_factura, id_prov FROM nuevas;

-- 13. Detalles de factura: el producto está en el catálogo del proveedor.
INSERT INTO public.tab_det_compra (id_factura, id_prod, val_cant, val_unit, val_descu, porc_iva)
SELECT f.id_factura, p.id_prod, 2, pp.val_prod, 0,
       CASE WHEN f.n % 3 = 0 THEN 5 ELSE 19 END
FROM tmp_test_facturas f
JOIN public.tab_prod p ON p.id_prod = 'SKU-TEC-' || LPAD(f.n::TEXT, 3, '0')
JOIN public.tab_prod_prov pp ON pp.id_prov = f.id_prov AND pp.id_prod = p.id_prod
ORDER BY f.n;

-- 14. Pagos parciales: id_pago es identity y no se inserta manualmente.
INSERT INTO public.tab_pagos (id_factura, fec_pago, val_pago)
SELECT f.id_factura, DATE '2026-10-20' + f.n, pp.val_prod
FROM tmp_test_facturas f
JOIN public.tab_prod p ON p.id_prod = 'SKU-TEC-' || LPAD(f.n::TEXT, 3, '0')
JOIN public.tab_prod_prov pp ON pp.id_prov = f.id_prov AND pp.id_prod = p.id_prod
ORDER BY f.n;

-- 15. Relación orden-factura (20 relaciones).
INSERT INTO public.tab_rel_orden_factura (id_orden, id_factura)
SELECT o.id_orden, f.id_factura
FROM tmp_test_ordenes o
JOIN tmp_test_facturas f ON f.n = o.n
ORDER BY o.n;

COMMIT;

SELECT 'tab_pmtros' AS tabla, COUNT(*) AS registros FROM public.tab_pmtros
UNION ALL SELECT 'tab_dptos', COUNT(*) FROM public.tab_dptos
UNION ALL SELECT 'tab_ciud', COUNT(*) FROM public.tab_ciud
UNION ALL SELECT 'tab_prefijos', COUNT(*) FROM public.tab_prefijos
UNION ALL SELECT 'tab_prov', COUNT(*) FROM public.tab_prov
UNION ALL SELECT 'tab_tel_prov', COUNT(*) FROM public.tab_tel_prov
UNION ALL SELECT 'tab_prod', COUNT(*) FROM public.tab_prod
UNION ALL SELECT 'tab_prod_prov', COUNT(*) FROM public.tab_prod_prov
UNION ALL SELECT 'tab_areas', COUNT(*) FROM public.tab_areas
UNION ALL SELECT 'tab_orden_compra', COUNT(*) FROM public.tab_orden_compra
UNION ALL SELECT 'tab_det_orden', COUNT(*) FROM public.tab_det_orden
UNION ALL SELECT 'tab_enc_compra', COUNT(*) FROM public.tab_enc_compra
UNION ALL SELECT 'tab_det_compra', COUNT(*) FROM public.tab_det_compra
UNION ALL SELECT 'tab_pagos', COUNT(*) FROM public.tab_pagos
UNION ALL SELECT 'tab_rel_orden_factura', COUNT(*) FROM public.tab_rel_orden_factura
ORDER BY tabla;
