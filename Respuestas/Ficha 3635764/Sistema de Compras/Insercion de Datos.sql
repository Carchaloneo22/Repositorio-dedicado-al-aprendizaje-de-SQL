-- 1. Limpiamos cualquier transacción pendiente
ROLLBACK;

-- 2. Iniciamos una nueva transacción limpia
BEGIN;

-- 1. Parámetros generales
INSERT INTO tab_pmtros (id_empresa, dia_pagos1, dia_pagos2, dia_pagos3, num_orden) VALUES
(1, 1, 3, 5, 100031);

-- 2. Departamentos
INSERT INTO tab_dptos (id_dpto, nom_dpto) VALUES
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
('15', 'Guainía'),
('16', 'Guaviare'),
('17', 'Huila'),
('18', 'La Guajira'),
('19', 'Magdalena'),
('20', 'Meta');

-- 3. Ciudades
INSERT INTO tab_ciud (id_ciud, nom_ciud, id_dpto) VALUES
('01001', 'Leticia', '01'), 
('01002', 'Puerto Nariño', '01'), 
('01003', 'Tarapacá', '01'),
('01004', 'Puerto Arica', '01'), 
('01005', 'Puerto Santander', '01'), 
('01006', 'La Pedrera', '01'),
('02001', 'Medellín', '02'),
('02002', 'Bello', '02'),
('02003', 'Itagüí', '02'),
('02004', 'Envigado', '02'),
('02005', 'Rionegro', '02'),
('02006', 'Marinilla', '02'),
('02007', 'Copacabana', '02'),
('02008', 'La Estrella', '02'),
('03001', 'Arauca', '03'),
('03002', 'Saravena', '03'),
('03003', 'Tame', '03'),
('04001', 'Barranquilla', '04'),
('05001', 'Cartagena', '05'),
('07001', 'Manizales', '07'),
('14001', 'Bogotá D.C.', '14');

-- 4. Áreas de la empresa
INSERT INTO tab_areas (id_area, nom_area, nom_encarg) VALUES
(1, 'Administración', 'Paula Ríos'),
(2, 'Compras', 'Javier Gómez'),
(3, 'Ventas', 'Carolina Ruiz'),
(4, 'Tecnología', 'Marcos Silva'),
(5, 'Operaciones', 'Diana Torres'),
(6, 'Recursos Humanos', 'Elena Patiño'),
(7, 'Calidad', 'Fernando Cano'),
(8, 'Logística', 'Sandra Mejía');

-- 5. Productos
INSERT INTO tab_prod (id_prod, id_ref, nom_prod, ind_estado) VALUES
(1, 'PROD001', 'Laptop Gamer', TRUE),
(2, 'PROD002', 'Mouse Inalámbrico', TRUE),
(3, 'PROD003', 'Teclado Mecánico', TRUE),
(4, 'PROD004', 'Monitor 24"', TRUE),
(5, 'PROD005', 'Impresora Láser', TRUE),
(6, 'PROD006', 'Tablet 10"', TRUE),
(7, 'PROD007', 'Smartphone', TRUE),
(8, 'PROD008', 'Auriculares Bluetooth', TRUE),
(9, 'PROD009', 'Tarjeta Gráfica', TRUE),
(10, 'PROD010', 'Proyector', TRUE),
(11, 'PROD011', 'Escritorio Oficina', TRUE),
(12, 'PROD012', 'Silla Ergonómica', TRUE),
(13, 'PROD013', 'Altavoces', TRUE),
(14, 'PROD014', 'Micrófono USB', TRUE),
(15, 'PROD015', 'Disco Duro SSD 1TB', TRUE),
(16, 'PROD016', 'Fuente de Poder', TRUE),
(17, 'PROD017', 'Memoria RAM 16GB', TRUE),
(18, 'PROD018', 'Cámara Web', TRUE),
(19, 'PROD019', 'Hub USB-C', TRUE),
(20, 'PROD020', 'UPS 1000VA', TRUE);

-- 6. Proveedores (Incluye nom_comp explícitamente)
INSERT INTO tab_prov (id_prov, nom_prov, apel_prov, ape2_prov, nom_comp, dir_prov, tel_prov, email_prov, id_ciud, val_cupocre, val_puntos, num_fact, ind_estado) VALUES
(1000000001, 'Carlos', 'Gómez', 'Hernández', 'Carlos Gómez Hernández', 'Calle 100 #45-20', '6011234567', 'carlos@tecnosum.com', '14001', 5000000, 95, 1000, TRUE),
(1000000002, 'Ana', 'Martínez', 'López', 'Ana Martínez López', 'Carrera 43A #1-50', '6042345678', 'ana.martinez@sistemas.co', '02001', 4000000, 88, 1001, TRUE),
(1000000003, 'Luis', 'Rodríguez', 'Pérez', 'Luis Rodríguez Pérez', 'Calle 50 #12-30', '6013456789', 'luis.rodriguez@tecnologia.com', '14001', 8000000, 92, 1002, TRUE),
(1000000004, 'Sofía', 'Ramírez', 'González', 'Sofía Ramírez González', 'Carrera 7 #71-21', '6014567890', 'sofia.ramirez@digital.com', '14001', 6000000, 94, 1003, TRUE),
(1000000005, 'Roberto', 'Navarro', 'Suárez', 'Roberto Navarro Suárez', 'Calle 10 #3-15', '6015678901', 'roberto.navarro@innova.com', '14001', 5800000, 96, 1004, TRUE),
(1000000006, 'David', 'Torres', 'Vargas', 'David Torres Vargas', 'Carrera 15 #93-40', '6016789012', 'david.torres@redes.co', '14001', 5500000, 91, 1005, TRUE),
(1000000007, 'Andrés', 'Ortega', 'Navarro', 'Andrés Ortega Navarro', 'Calle 22 #6-10', '6067890123', 'andres.ortega@soportes.com', '07001', 5200000, 92, 1006, TRUE),
(1000000008, 'Carmen', 'Vargas', 'Mendoza', 'Carmen Vargas Mendoza', 'Calle 33 #14-20', '6048901234', 'carmen.vargas@comercial.com', '02004', 3500000, 85, 1007, TRUE),
(1000000009, 'Gabriela', 'Rojas', 'Pérez', 'Gabriela Rojas Pérez', 'Carrera 20 #18-40', '6079012345', 'gabriela.rojas@suministros.co', '03002', 4500000, 89, 1008, TRUE),
(1000000010, 'Lucía', 'Fernández', 'Romero', 'Lucía Fernández Romero', 'Calle 15 #8-30', '6070123456', 'lucia.fernandez@componentes.com', '03003', 4800000, 87, 1009, TRUE),
(1000000011, 'Pedro', 'Hernández', 'Silva', 'Pedro Hernández Silva', 'Carrera 10 #5-25', '6071234567', 'pedro.hernandez@soluciones.co', '03001', 3900000, 86, 1010, TRUE),
(1000000012, 'María', 'López', 'García', 'María López García', 'Calle 72 #53-10', '6052345678', 'maria.lopez@equipos.com', '04001', 4200000, 89, 1011, TRUE),
(1000000013, 'Patricia', 'Mendoza', 'Rojas', 'Patricia Mendoza Rojas', 'Carrera 3 #31-45', '6053456789', 'patricia.mendoza@importaciones.co', '05001', 4100000, 88, 1012, TRUE),
(1000000014, 'Jorge', 'Díaz', 'Ramírez', 'Jorge Díaz Ramírez', 'Calle 19 #4-20', '6014567891', 'jorge.diaz@tecnoservis.com', '14001', 3800000, 84, 1013, TRUE),
(1000000015, 'Miguel', 'Suárez', 'Romero', 'Miguel Suárez Romero', 'Carrera 5 #11-30', '6015678902', 'miguel.suarez@mayoristas.com', '14001', 4700000, 90, 1014, TRUE),
(1000000016, 'Elena', 'Morales', 'Fernández', 'Elena Morales Fernández', 'Calle 80 #11-10', '6016789013', 'elena.morales@distribuciones.co', '14001', 4900000, 93, 1015, TRUE),
(1000000017, 'Isabel', 'Pérez', 'Morales', 'Isabel Pérez Morales', 'Carrera 9 #72-35', '6017890124', 'isabel.perez@hardwareshop.com', '14001', 3600000, 83, 1016, TRUE),
(1000000018, 'Fernando', 'Castro', 'Sánchez', 'Fernando Castro Sánchez', 'Calle 127 #15-40', '6018901235', 'fernando.castro@sistemasplus.co', '14001', 3700000, 82, 1017, TRUE),
(1000000019, 'Camila', 'Guerrero', 'Torres', 'Camila Guerrero Torres', 'Carrera 68 #26-50', '6019012346', 'camila.guerrero@ittech.com', '14001', 4300000, 87, 1018, TRUE),
(1000000020, 'Gonzalo', 'Blanco', 'Ríos', 'Gonzalo Blanco Ríos', 'Calle 26 #59-51', '6010123457', 'gonzalo.blanco@conectividad.co', '14001', 4400000, 88, 1019, TRUE);

-- 7. Catálogo de productos por proveedor
INSERT INTO tab_prod_prov (id_prov, id_prod, val_prod, ind_disp) VALUES
(1000000001, 1, 2500000, TRUE),
(1000000001, 2, 85000, TRUE),
(1000000001, 3, 120000, TRUE),
(1000000001, 4, 800000, TRUE),
(1000000001, 5, 410000, TRUE),
(1000000002, 1, 2450000, TRUE),
(1000000002, 6, 1150000, TRUE),
(1000000002, 7, 1750000, TRUE),
(1000000003, 17, 280000, TRUE),
(1000000003, 4, 800000, TRUE),
(1000000004, 6, 1200000, TRUE),
(1000000004, 7, 1800000, TRUE),
(1000000005, 18, 78000, TRUE),
(1000000005, 11, 575000, TRUE),
(1000000006, 17, 250000, TRUE),
(1000000007, 9, 3200000, TRUE),
(1000000008, 11, 600000, TRUE),
(1000000009, 9, 3050000, TRUE),
(1000000010, 8, 135000, TRUE),
(1000000010, 15, 315000, TRUE),
(1000000011, 6, 105000, TRUE),
(1000000012, 7, 1650000, TRUE),
(1000000013, 10, 1500000, TRUE),
(1000000014, 4, 690000, TRUE),
(1000000015, 13, 155000, TRUE),
(1000000015, 5, 395000, TRUE),
(1000000016, 1, 2300000, TRUE),
(1000000017, 16, 168000, TRUE),
(1000000018, 12, 450000, TRUE),
(1000000019, 10, 1400000, TRUE),
(1000000020, 14, 110000, TRUE);

-- 8. Órdenes de compra y detalle
INSERT INTO tab_orden_compra (id_orden, fec_orden, id_area) VALUES
(100001, '2024-01-15 08:30:00', 2),
(100002, '2024-01-16 09:15:00', 3),
(100003, '2024-01-17 10:00:00', 4),
(100004, '2024-01-18 11:30:00', 5);

INSERT INTO tab_det_orden (id_orden, id_prod, val_cant) VALUES
(100001, 1, 2),
(100001, 2, 5),
(100002, 7, 3),
(100003, 4, 4),
(100004, 11, 2);

-- 9. Facturas de compra
INSERT INTO tab_enc_compra (id_factura, fec_factura, id_prov, id_ciud_entrega, val_observa) VALUES
(200001, '2024-01-20', 1000000001, '14001', 'Entrega directa en oficina principal'),
(200002, '2024-01-22', 1000000001, '14001', 'Orden de compra parcial'),
(200003, '2024-01-25', 1000000014, '14001', 'Monitores para departamento TI'),
(200004, '2024-01-28', 1000000004, '14001', 'Equipos móviles'),
(200005, '2024-01-29', 1000000004, '14001', 'Tablets comerciales'),
(200006, '2024-01-30', 1000000004, '14001', 'Smartphones área ventas'),
(200007, '2024-01-30', 1000000003, '14001', 'Amplificación de memoria RAM'),
(200008, '2024-02-25', 1000000003, '14001', 'Puntos pendientes'),
(200010, '2024-02-05', 1000000002, '02001', 'Factura sede Medellín'),
(200013, '2024-02-10', 1000000014, '14001', 'Equipos soporte'),
(200016, '2024-02-15', 1000000004, '14001', 'Renovación de tablets'),
(200017, '2024-02-17', 1000000004, '14001', 'Lote Smartphones'),
(200019, '2024-02-20', 1000000011, '03001', 'Compra insumos Arauca'),
(200021, '2024-04-10', 1000000007, '07001', 'Factura en borrador'),
(200022, '2024-02-25', 1000000010, '03003', 'Componentes varios'),
(200024, '2024-04-15', 1000000008, '02004', 'Factura sin detalle 1'),
(200025, '2024-03-01', 1000000006, '14001', 'Memorias de servidor'),
(200026, '2024-03-05', 1000000006, '14001', 'Lote de componentes RAM'),
(200027, '2024-04-20', 1000000009, '03002', 'Factura sin detalle 2'),
(200028, '2024-03-10', 1000000008, '02004', 'Mobiliario para oficina'),
(200030, '2024-04-25', 1000000010, '03003', 'Factura sin detalle 3'),
(200031, '2024-03-10', 1000000011, '03001', 'Factura sin detalle 4'),
(200032, '2024-04-05', 1000000011, '03001', 'Factura sin detalle 5');

-- 10. Detalle de facturas (Incluye val_bruto, val_iva y val_neto calculados)
INSERT INTO tab_det_compra (id_factura, id_prod, val_cant, val_unit, val_descu, val_bruto, val_iva, val_neto) VALUES
(200001, 1, 2, 2500000, 250000, 5000000, 902500, 5652500),
(200001, 2, 10, 85000, 42500, 850000, 153425, 960925),
(200002, 1, 3, 2500000, 375000, 7500000, 1353750, 8478750),
(200003, 4, 4, 800000, 0, 3200000, 608000, 3808000),
(200004, 6, 3, 1200000, 0, 3600000, 684000, 4284000),
(200005, 6, 5, 1200000, 0, 6000000, 1140000, 7140000),
(200006, 7, 4, 1800000, 0, 7200000, 1368000, 8568000),
(200007, 17, 15, 280000, 0, 4200000, 798000, 4998000),
(200013, 4, 5, 690000, 0, 3450000, 655500, 4105500),
(200016, 6, 6, 1050000, 0, 6300000, 1197000, 7497000),
(200017, 7, 3, 1800000, 0, 5400000, 1026000, 6426000),
(200019, 15, 10, 315000, 0, 3150000, 598500, 3748500),
(200022, 8, 10, 135000, 0, 1350000, 256500, 1606500),
(200025, 17, 15, 250000, 0, 3750000, 712500, 4462500),
(200026, 17, 11, 250000, 0, 2750000, 522500, 3272500),
(200028, 11, 10, 600000, 0, 6000000, 1140000, 7140000);

-- 11. Pagos
INSERT INTO tab_pagos (id_factura, id_pago, fec_pago, val_pago) VALUES
(200001, 1, '2024-02-05', 2000000),
(200001, 2, '2024-02-15', 2000000),
(200001, 3, '2024-02-25', 2613425),
(200002, 1, '2024-03-05', 4000000),
(200002, 2, '2024-03-15', 4000000),
(200002, 3, '2024-03-25', 1157050),
(200007, 1, '2024-02-10', 3000000);

COMMIT;