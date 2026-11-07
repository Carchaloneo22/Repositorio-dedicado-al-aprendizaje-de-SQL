DROP TABLE IF EXISTS tab_pagos;
DROP TABLE IF EXISTS tab_det_compra;
DROP TABLE IF EXISTS tab_enc_compra;
DROP TABLE IF EXISTS tab_prod_prov;
DROP TABLE IF EXISTS tab_prov;
DROP TABLE IF EXISTS tab_orden_compra;
DROP TABLE IF EXISTS tab_areas;
DROP TABLE IF EXISTS tab_prod;
DROP TABLE IF EXISTS tab_ciud;
DROP TABLE IF EXISTS tab_dptos;
DROP TYPE IF EXISTS datos;
DROP TABLE IF EXISTS tab_pmtros;

CREATE TABLE IF NOT EXISTS tab_pmtros
(
	id_empresa	DECIMAL(10,0)	NOT NULL,
	dia_pagos1	DECIMAL(1,0)	NOT NULL,
	dia_pagos2	DECIMAL(1,0)	NOT NULL,
	dia_pagos3	DECIMAL(1,0)	NOT NULL,
	num_orden	DECIMAL(6,0)	NOT NULL,
	PRIMARY KEY(id_empresa)
);

CREATE TYPE datos AS
(
	direccion	VARCHAR,
	telefono	DECIMAL(10,0),
	correo		VARCHAR
);

CREATE TABLE IF NOT EXISTS tab_dptos
(
	id_dpto		VARCHAR(2)	NOT NULL,
	nom_dpto	VARCHAR		NOT NULL,
	PRIMARY KEY(id_dpto)
);

CREATE TABLE IF NOT EXISTS tab_ciud
(
	id_ciud		VARCHAR(5) 		NOT NULL,
	nom_ciud	VARCHAR			NOT NULL,
	id_dpto		VARCHAR(2)		NOT NULL,
	PRIMARY KEY(id_ciud),
	FOREIGN KEY(id_dpto)	REFERENCES tab_dptos(id_dpto)
);

CREATE TABLE IF NOT EXISTS tab_prov
(
	id_prov		DECIMAL(10,0)	NOT NULL,
	nom_prov	VARCHAR			NOT NULL,
	ape_prov	VARCHAR			NOT NULL,
	nom_comp	VARCHAR			NOT NULL,
	datos_prov	datos,
	id_ciud		VARCHAR(5)		NOT NULL,
	val_cupocre	DECIMAL(10,0)	NOT NULL DEFAULT 0,
	val_puntos	DECIMAL(3,0)	NOT NULL,
	num_fact	DECIMAL(6,0)	NOT NULL,
	ind_estado	BOOLEAN			NOT NULL DEFAULT TRUE,
	PRIMARY KEY(id_prov),
	FOREIGN KEY(id_ciud)	REFERENCES tab_ciud(id_ciud)
);

CREATE TABLE IF NOT EXISTS tab_prod
(
	id_prod		SMALLINT		NOT NULL,
	id_ref		VARCHAR			NOT NULL,
	nom_prod	VARCHAR			NOT NULL,
	ind_estado	BOOLEAN			NOT NULL,
	PRIMARY KEY(id_prod)
);
CREATE UNIQUE INDEX idx_id_ref ON tab_prod(id_ref);

CREATE TABLE IF NOT EXISTS tab_prod_prov
(
	id_prov		DECIMAL(10,0)	NOT NULL,
	id_prod		SMALLINT		NOT NULL,
	val_prod	DECIMAL(10,0)	NOT NULL,
	ind_disp	BOOLEAN			NOT NULL,
	PRIMARY KEY(id_prov,id_prod),
	FOREIGN KEY(id_prov)	REFERENCES tab_prov(id_prov),
	FOREIGN KEY(id_prod)	REFERENCES tab_prod(id_prod)
);

CREATE TABLE tab_areas
(
	id_area		DECIMAL(2,0)	NOT NULL,
	nom_area	VARCHAR			NOT NULL,
	nom_ecarg	VARCHAR			NOT NULL,
	PRIMARY KEY(id_area)
);

CREATE TABLE IF NOT EXISTS tab_orden_compra
(
	id_orden	DECIMAL(6,0)	NOT NULL,
	fec_orden	DATE,
	id_area		DECIMAL(2,0)	NOT NULL,
	id_prod		SMALLINT		NOT NULL,
	val_cant	SMALLINT		NOT NULL,
	PRIMARY KEY(id_orden),
	FOREIGN KEY(id_prod)	REFERENCES tab_prod(id_prod),
	FOREIGN KEY(id_area)	REFERENCES tab_areas(id_area)
);

CREATE TABLE IF NOT EXISTS tab_enc_compra
(
	id_factura	DECIMAL(6,0)	NOT NULL,
	fec_factura	DATE 			NOT NULL,
	id_ciud		VARCHAR(5)		NOT NULL,
	id_prov		DECIMAL(10,0)	NOT NULL,
	val_observa	TEXT,
	PRIMARY KEY(id_factura),
	FOREIGN KEY(id_ciud)	REFERENCES tab_ciud(id_ciud),
	FOREIGN KEY(id_prov)	REFERENCES tab_prov(id_prov)
);

CREATE TABLE IF NOT EXISTS tab_det_compra
(
	id_factura	DECIMAL(6,0)	NOT NULL,
	id_prod		SMALLINT		NOT NULL,
	val_cant	SMALLINT		NOT NULL,
	val_bruto	DECIMAL(10,0)	NOT NULL,
	val_descu	DECIMAL(10,0)	NOT NULL,
	val_iva		DECIMAL(10,0)	NOT NULL,
	val_neto	DECIMAL(10,0)	NOT NULL,
	PRIMARY KEY(id_factura,id_prod),
	FOREIGN KEY(id_factura)	REFERENCES tab_enc_compra(id_factura),
	FOREIGN KEY(id_prod)	REFERENCES tab_prod(id_prod)
);

CREATE TABLE IF NOT EXISTS tab_pagos
(
	id_factura	DECIMAL(6,0)	NOT NULL,
	id_pago		DECIMAL(2,0)	NOT NULL,
	fec_pago	DATE			NOT NULL,
	val_pago	DECIMAL(10,0)	NOT NULL,
	val_saldo	DECIMAL(10,0)	NOT NULL,
	PRIMARY KEY(id_factura,id_pago),
	FOREIGN KEY(id_factura)	REFERENCES tab_enc_compra(id_factura)
);

-- INSERCIÓN DE DATOS EN ORDEN CORRECTO

-- 1. Insertar parámetros
INSERT INTO tab_pmtros (id_empresa, dia_pagos1, dia_pagos2, dia_pagos3, num_orden) 
VALUES (1, 1, 3, 5, 100001);

-- 2. Insertar departamentos colombianos (20 departamentos)
INSERT INTO tab_dptos (id_dpto, nom_dpto) VALUES
('01', 'Amazonas'), ('02', 'Antioquia'), ('03', 'Arauca'), ('04', 'Atlántico'), ('05', 'Bolívar'),
('06', 'Boyacá'), ('07', 'Caldas'), ('08', 'Caquetá'), ('09', 'Casanare'), ('10', 'Cauca'),
('11', 'Cesar'), ('12', 'Chocó'), ('13', 'Córdoba'), ('14', 'Cundinamarca'), ('15', 'Guainía'),
('16', 'Guaviare'), ('17', 'Huila'), ('18', 'La Guajira'), ('19', 'Magdalena'), ('20', 'Meta');

-- 3. Insertar ciudades (8 ciudades por departamento)
INSERT INTO tab_ciud (id_ciud, nom_ciud, id_dpto) VALUES
-- Amazonas (01)
('01001', 'Leticia', '01'), ('01002', 'Puerto Nariño', '01'), ('01003', 'Tarapacá', '01'), ('01004', 'Puerto Arica', '01'),
('01005', 'Puerto Santander', '01'), ('01006', 'La Pedrera', '01'), ('01007', 'Mirití', '01'), ('01008', 'El Encanto', '01'),

-- Antioquia (02)
('02001', 'Medellín', '02'), ('02002', 'Bello', '02'), ('02003', 'Itagüí', '02'), ('02004', 'Envigado', '02'),
('02005', 'Rionegro', '02'), ('02006', 'Marinilla', '02'), ('02007', 'Copacabana', '02'), ('02008', 'La Estrella', '02'),

-- Arauca (03)
('03001', 'Arauca', '03'), ('03002', 'Arauquita', '03'), ('03003', 'Saravena', '03'), ('03004', 'Fortul', '03'),
('03005', 'Tame', '03'), ('03006', 'Cravo Norte', '03'), ('03007', 'Puerto Rondón', '03'), ('03008', 'La Esmeralda', '03'),

-- Atlántico (04)
('04001', 'Barranquilla', '04'), ('04002', 'Soledad', '04'), ('04003', 'Malambo', '04'), ('04004', 'Sabanalarga', '04'),
('04005', 'Puerto Colombia', '04'), ('04006', 'Baranoa', '04'), ('04007', 'Galapa', '04'), ('04008', 'Usiacurí', '04'),

-- Bolívar (05)
('05001', 'Cartagena', '05'), ('05002', 'Magangué', '05'), ('05003', 'El Carmen de Bolívar', '05'), ('05004', 'Arjona', '05'),
('05005', 'Turbaco', '05'), ('05006', 'San Juan Nepomuceno', '05'), ('05007', 'María la Baja', '05'), ('05008', 'Santa Rosa', '05'),

-- Boyacá (06)
('06001', 'Tunja', '06'), ('06002', 'Sogamoso', '06'), ('06003', 'Duitama', '06'), ('06004', 'Chiquinquirá', '06'),
('06005', 'Paipa', '06'), ('06006', 'Samacá', '06'), ('06007', 'Villa de Leyva', '06'), ('06008', 'Nobsa', '06'),

-- Caldas (07)
('07001', 'Manizales', '07'), ('07002', 'La Dorada', '07'), ('07003', 'Chinchiná', '07'), ('07004', 'Villamaría', '07'),
('07005', 'Riosucio', '07'), ('07006', 'Salamina', '07'), ('07007', 'Aguadas', '07'), ('07008', 'Neira', '07'),

-- Caquetá (08)
('08001', 'Florencia', '08'), ('08002', 'San Vicente del Caguán', '08'), ('08003', 'Belén de los Andaquíes', '08'), ('08004', 'Curillo', '08'),
('08005', 'El Doncello', '08'), ('08006', 'El Paujíl', '08'), ('08007', 'Morelia', '08'), ('08008', 'Puerto Rico', '08'),

-- Casanare (09)
('09001', 'Yopal', '09'), ('09002', 'Aguazul', '09'), ('09003', 'Villanueva', '09'), ('09004', 'Tauramena', '09'),
('09005', 'Trinidad', '09'), ('09006', 'Maní', '09'), ('09007', 'Pore', '09'), ('09008', 'Orocué', '09'),

-- Cauca (10)
('10001', 'Popayán', '10'), ('10002', 'Santander de Quilichao', '10'), ('10003', 'Puerto Tejada', '10'), ('10004', 'Patía', '10'),
('10005', 'Guapi', '10'), ('10006', 'El Tambo', '10'), ('10007', 'Caldono', '10'), ('10008', 'Piendamó', '10'),

-- Cesar (11)
('11001', 'Valledupar', '11'), ('11002', 'Aguachica', '11'), ('11003', 'Agustín Codazzi', '11'), ('11004', 'Bosconia', '11'),
('11005', 'Curumaní', '11'), ('11006', 'La Paz', '11'), ('11007', 'Pailitas', '11'), ('11008', 'Pelaya', '11'),

-- Chocó (12)
('12001', 'Quibdó', '12'), ('12002', 'Istmina', '12'), ('12003', 'Nóvita', '12'), ('12004', 'Tadó', '12'),
('12005', 'Condoto', '12'), ('12006', 'Riosucio', '12'), ('12007', 'Bagadó', '12'), ('12008', 'Lloró', '12'),

-- Córdoba (13)
('13001', 'Montería', '13'), ('13002', 'Cereté', '13'), ('13003', 'Sahagún', '13'), ('13004', 'Lorica', '13'),
('13005', 'Planeta Rica', '13'), ('13006', 'Tierralta', '13'), ('13007', 'Montelíbano', '13'), ('13008', 'Puerto Escondido', '13'),

-- Cundinamarca (14)
('14001', 'Bogotá', '14'), ('14002', 'Soacha', '14'), ('14003', 'Girardot', '14'), ('14004', 'Facatativá', '14'),
('14005', 'Zipaquirá', '14'), ('14006', 'Chía', '14'), ('14007', 'Mosquera', '14'), ('14008', 'Madrid', '14'),

-- Guainía (15)
('15001', 'Inírida', '15'), ('15002', 'Barrancominas', '15'), ('15003', 'Mapiripana', '15'), ('15004', 'Cacahual', '15'),
('15005', 'Pana Pana', '15'), ('15006', 'Morichal', '15'), ('15007', 'Puerto Colombia', '15'), ('15008', 'San Felipe', '15'),

-- Guaviare (16)
('16001', 'San José del Guaviare', '16'), ('16002', 'Calamar', '16'), ('16003', 'Miraflores', '16'), ('16004', 'El Retorno', '16'),
('16005', 'Puerto Concordia', '16'), ('16006', 'Puerto Nare', '16'), ('16007', 'Puerto Triunfo', '16'), ('16008', 'Puerto López', '16'),

-- Huila (17)
('17001', 'Neiva', '17'), ('17002', 'Pitalito', '17'), ('17003', 'Garzón', '17'), ('17004', 'La Plata', '17'),
('17005', 'Campoalegre', '17'), ('17006', 'Aipe', '17'), ('17007', 'Palestina', '17'), ('17008', 'Tesalia', '17'),

-- La Guajira (18)
('18001', 'Riohacha', '18'), ('18002', 'Maicao', '18'), ('18003', 'Uribia', '18'), ('18004', 'Manaure', '18'),
('18005', 'Fonseca', '18'), ('18006', 'Barrancas', '18'), ('18007', 'San Juan del Cesar', '18'), ('18008', 'Dibulla', '18'),

-- Magdalena (19)
('19001', 'Santa Marta', '19'), ('19002', 'Ciénaga', '19'), ('19003', 'Fundación', '19'), ('19004', 'Aracataca', '19'),
('19005', 'El Retén', '19'), ('19006', 'Plato', '19'), ('19007', 'Pivijay', '19'), ('19008', 'Zona Bananera', '19'),

-- Meta (20)
('20001', 'Villavicencio', '20'), ('20002', 'Acacías', '20'), ('20003', 'Granada', '20'), ('20004', 'Puerto López', '20'),
('20005', 'Puerto Gaitán', '20'), ('20006', 'San Martín', '20'), ('20007', 'Cumaral', '20'), ('20008', 'Restrepo', '20');

-- 4. Insertar áreas
INSERT INTO tab_areas (id_area, nom_area, nom_ecarg) VALUES
(1, 'Administración', 'María González'),
(2, 'Compras', 'Carlos Rodríguez'),
(3, 'Ventas', 'Ana Martínez'),
(4, 'Recursos Humanos', 'Pedro López'),
(5, 'Tecnología', 'Laura Sánchez'),
(6, 'Operaciones', 'Jorge Díaz'),
(7, 'Calidad', 'Sofía Ramírez'),
(8, 'Logística', 'David Torres');

-- 5. Insertar productos (20 productos)
INSERT INTO tab_prod (id_prod, id_ref, nom_prod, ind_estado) VALUES
(1, 'PROD001', 'Laptop Gamer', true),
(2, 'PROD002', 'Mouse Inalámbrico', true),
(3, 'PROD003', 'Teclado Mecánico', true),
(4, 'PROD004', 'Monitor 24"', true),
(5, 'PROD005', 'Impresora Láser', true),
(6, 'PROD006', 'Tablet 10"', true),
(7, 'PROD007', 'Smartphone', true),
(8, 'PROD008', 'Auriculares Bluetooth', true),
(9, 'PROD009', 'Disco Duro SSD 1TB', true),
(10, 'PROD010', 'Memoria RAM 16GB', true),
(11, 'PROD011', 'Tarjeta Gráfica', true),
(12, 'PROD012', 'Fuente de Poder', true),
(13, 'PROD013', 'Cámara Web', true),
(14, 'PROD014', 'Micrófono USB', true),
(15, 'PROD015', 'Router WiFi', true),
(16, 'PROD016', 'Silla Ergonómica', true),
(17, 'PROD017', 'Escritorio Oficina', true),
(18, 'PROD018', 'Proyector', true),
(19, 'PROD019', 'Altavoces', true),
(20, 'PROD020', 'UPS', true);

-- 6. Insertar proveedores (20 proveedores)
INSERT INTO tab_prov (id_prov, nom_prov, ape_prov, nom_comp, datos_prov, id_ciud, val_cupocre, val_puntos, num_fact, ind_estado) VALUES
(1000000001, 'Carlos', 'Gómez', 'Carlos Gómez Hernández', ROW('Calle 100 #45-20', 6011234567, 'carlos@tecnosum.com'), '02001', 5000000, 95, 1000, true),
(1000000002, 'Ana', 'Martínez', 'Ana Martínez López', ROW('Cra 50 #25-30', 6047654321, 'ana@electroparts.com'), '02001', 3000000, 88, 2000, true),
(1000000003, 'Luis', 'Rodríguez', 'Luis Rodríguez Pérez', ROW('Av Boyacá #15-40', 6019876543, 'luis@compumundo.com'), '02001', 8000000, 92, 3000, true),
(1000000004, 'María', 'López', 'María López García', ROW('Calle 80 #10-15', 6051234567, 'maria@tecnoglobal.com'), '02001', 2500000, 85, 4000, true),
(1000000005, 'Jorge', 'Díaz', 'Jorge Díaz Ramírez', ROW('Cra 30 #40-50', 6024567890, 'jorge@digitalsol.com'), '02001', 4000000, 90, 5000, true),
(1000000006, 'Sofía', 'Ramírez', 'Sofía Ramírez González', ROW('Av 68 #25-60', 6012345678, 'sofia@techcorp.com'), '02001', 6000000, 94, 6000, true),
(1000000007, 'Pedro', 'Hernández', 'Pedro Hernández Silva', ROW('Calle 72 #35-25', 6076543210, 'pedro@innova.com'), '02001', 3500000, 87, 7000, true),
(1000000008, 'Laura', 'García', 'Laura García Torres', ROW('Cra 45 #55-10', 6089876543, 'laura@megaelec.com'), '02001', 4500000, 89, 8000, true),
(1000000009, 'David', 'Torres', 'David Torres Vargas', ROW('Av Caracas #22-30', 6031234567, 'david@compuexpress.com'), '02001', 5500000, 91, 9000, true),
(1000000010, 'Carmen', 'Vargas', 'Carmen Vargas Mendoza', ROW('Calle 90 #15-20', 6045678901, 'carmen@tecnoavance.com'), '02001', 3200000, 86, 10000, true),
(1000000011, 'Ricardo', 'Silva', 'Ricardo Silva Castro', ROW('Cra 60 #30-40', 6018765432, 'ricardo@electromundo.com'), '02001', 4800000, 93, 11000, true),
(1000000012, 'Patricia', 'Mendoza', 'Patricia Mendoza Rojas', ROW('Av 26 #45-15', 6054321098, 'patricia@techimport.com'), '02001', 2800000, 84, 12000, true),
(1000000013, 'Fernando', 'Castro', 'Fernando Castro Ortega', ROW('Calle 120 #50-25', 6023456789, 'fernando@digitalhouse.com'), '02001', 4200000, 88, 13000, true),
(1000000014, 'Gabriela', 'Rojas', 'Gabriela Rojas Pérez', ROW('Cra 70 #35-45', 6078901234, 'gabriela@computech.com'), '02001', 3800000, 87, 14000, true),
(1000000015, 'Andrés', 'Ortega', 'Andrés Ortega Navarro', ROW('Av 19 #60-30', 6034567890, 'andres@tecnoline.com'), '02001', 5200000, 92, 15000, true),
(1000000016, 'Isabel', 'Pérez', 'Isabel Pérez Morales', ROW('Calle 85 #25-35', 6046789012, 'isabel@electroplus.com'), '02001', 3400000, 85, 16000, true),
(1000000017, 'Roberto', 'Navarro', 'Roberto Navarro Suárez', ROW('Cra 40 #20-50', 6015678901, 'roberto@techmaster.com'), '02001', 5800000, 96, 17000,true),
(1000000018, 'Elena', 'Morales', 'Elena Morales Fernández', ROW('Av 72 #55-40', 6057890123, 'elena@digitalcorp.com'), '02001', 2900000, 83, 18000, true),
(1000000019, 'Miguel', 'Suárez', 'Miguel Suárez Romero', ROW('Calle 95 #30-45', 6026789012, 'miguel@compucenter.com'), '02001', 4600000, 90, 19000, true),
(1000000020, 'Lucía', 'Fernández', 'Lucía Fernández Romero', ROW('Cra 55 #45-60', 6079012345, 'lucia@tecnopro.com'), '02001', 3700000, 86, 20000, true);

-- 7. Insertar productos por proveedor (cada proveedor vende 5 productos)
INSERT INTO tab_prod_prov (id_prov, id_prod, val_prod, ind_disp) VALUES
-- Proveedor 1
(1000000001, 1, 2500000, true), (1000000001, 2, 85000, true), (1000000001, 3, 120000, true), (1000000001, 4, 800000, true), (1000000001, 5, 450000, true),
-- Proveedor 2
(1000000002, 2, 80000, true), (1000000002, 6, 1200000, true), (1000000002, 7, 1800000, true), (1000000002, 8, 150000, true), (1000000002, 9, 350000, true),
-- Proveedor 3
(1000000003, 3, 110000, true), (1000000003, 10, 280000, true), (1000000003, 11, 3200000, true), (1000000003, 12, 180000, true), (1000000003, 13, 90000, true),
-- Proveedor 4
(1000000004, 4, 750000, true), (1000000004, 14, 120000, true), (1000000004, 15, 200000, true), (1000000004, 16, 450000, true), (1000000004, 17, 600000, true),
-- Proveedor 5
(1000000005, 5, 420000, true), (1000000005, 18, 1500000, true), (1000000005, 19, 180000, true), (1000000005, 20, 400000, true), (1000000005, 1, 2450000, true),
-- Proveedor 6
(1000000006, 6, 1150000, true), (1000000006, 2, 82000, true), (1000000006, 7, 1750000, true), (1000000006, 8, 145000, true), (1000000006, 9, 340000, true),
-- Proveedor 7
(1000000007, 7, 1700000, true), (1000000007, 10, 270000, true), (1000000007, 11, 3150000, true), (1000000007, 12, 175000, true), (1000000007, 13, 85000, true),
-- Proveedor 8
(1000000008, 8, 140000, true), (1000000008, 14, 115000, true), (1000000008, 15, 190000, true), (1000000008, 16, 440000, true), (1000000008, 17, 590000, true),
-- Proveedor 9
(1000000009, 9, 330000, true), (1000000009, 18, 1450000, true), (1000000009, 19, 170000, true), (1000000009, 20, 390000, true), (1000000009, 1, 2400000, true),
-- Proveedor 10
(1000000010, 10, 260000, true), (1000000010, 2, 78000, true), (1000000010, 3, 105000, true), (1000000010, 4, 730000, true), (1000000010, 5, 410000, true),
-- Proveedor 11
(1000000011, 11, 3100000, true), (1000000011, 6, 1100000, true), (1000000011, 7, 1720000, true), (1000000011, 8, 142000, true), (1000000011, 9, 325000, true),
-- Proveedor 12
(1000000012, 12, 170000, true), (1000000012, 13, 82000, true), (1000000012, 14, 110000, true), (1000000012, 15, 185000, true), (1000000012, 16, 430000, true),
-- Proveedor 13
(1000000013, 13, 80000, true), (1000000013, 17, 580000, true), (1000000013, 18, 1420000, true), (1000000013, 19, 165000, true), (1000000013, 20, 385000, true),
-- Proveedor 14
(1000000014, 14, 108000, true), (1000000014, 1, 2350000, true), (1000000014, 2, 76000, true), (1000000014, 3, 100000, true), (1000000014, 4, 710000, true),
-- Proveedor 15
(1000000015, 15, 195000, true), (1000000015, 5, 405000, true), (1000000015, 6, 1080000, true), (1000000015, 7, 1680000, true), (1000000015, 8, 138000, true),
-- Proveedor 16
(1000000016, 16, 425000, true), (1000000016, 9, 320000, true), (1000000016, 10, 255000, true), (1000000016, 11, 3050000, true), (1000000016, 12, 168000, true),
-- Proveedor 17
(1000000017, 17, 575000, true), (1000000017, 13, 78000, true), (1000000017, 14, 105000, true), (1000000017, 15, 182000, true), (1000000017, 16, 420000, true),
-- Proveedor 18
(1000000018, 18, 1400000, true), (1000000018, 19, 160000, true), (1000000018, 20, 380000, true), (1000000018, 1, 2300000, true), (1000000018, 2, 74000, true),
-- Proveedor 19
(1000000019, 19, 155000, true), (1000000019, 3, 95000, true), (1000000019, 4, 690000, true), (1000000019, 5, 395000, true), (1000000019, 6, 1050000, true),
-- Proveedor 20
(1000000020, 20, 375000, true), (1000000020, 7, 1650000, true), (1000000020, 8, 135000, true), (1000000020, 9, 315000, true), (1000000020, 10, 250000, true);

-- 8. Insertar órdenes de compra
INSERT INTO tab_orden_compra (id_orden, fec_orden, id_area, id_prod, val_cant) VALUES
(100001, '2024-01-15 08:30:00', 2, 1, 5), (100002, '2024-01-16 09:15:00', 3, 2, 20), (100003, '2024-01-17 10:00:00', 5, 3, 15),
(100004, '2024-01-18 11:20:00', 6, 4, 8), (100005, '2024-01-19 14:30:00', 2, 5, 10), (100006, '2024-01-22 08:45:00', 3, 6, 12),
(100007, '2024-01-23 10:30:00', 5, 7, 6), (100008, '2024-01-24 13:15:00', 6, 8, 25), (100009, '2024-01-25 15:00:00', 2, 9, 18),
(100010, '2024-01-26 16:20:00', 3, 10, 30), (100011, '2024-02-01 09:00:00', 5, 11, 4), (100012, '2024-02-02 11:30:00', 6, 12, 22),
(100013, '2024-02-05 08:15:00', 2, 13, 35), (100014, '2024-02-06 14:00:00', 3, 14, 28), (100015, '2024-02-07 16:45:00', 5, 15, 15),
(100016, '2024-02-08 10:20:00', 6, 16, 7), (100017, '2024-02-09 13:30:00', 2, 17, 9), (100018, '2024-02-12 15:15:00', 3, 18, 3),
(100019, '2024-02-13 08:30:00', 5, 19, 20), (100020, '2024-02-14 11:00:00', 6, 20, 12),
(100021, '2024-02-15 14:30:00', 2, 1, 8), (100022, '2024-02-16 16:00:00', 3, 2, 15), (100023, '2024-02-19 09:45:00', 5, 3, 12),
(100024, '2024-02-20 11:30:00', 6, 4, 10), (100025, '2024-02-21 13:15:00', 2, 5, 7), (100026, '2024-02-22 15:00:00', 3, 6, 18),
(100027, '2024-02-23 08:20:00', 5, 7, 9), (100028, '2024-02-26 10:45:00', 6, 8, 30), (100029, '2024-02-27 12:30:00', 2, 9, 25),
(100030, '2024-02-28 14:15:00', 3, 10, 22);

-- 9. Insertar encabezados de compra (3 facturas por cada proveedor = 60 facturas)
INSERT INTO tab_enc_compra (id_factura, fec_factura, id_ciud, id_prov, val_observa) VALUES
-- Proveedor 1 (3 facturas)
(200001, '2024-01-20', '02001', 1000000001, 'Compra equipos oficina - Entrega urgente'),
(200002, '2024-02-15', '02001', 1000000001, 'Reposición stock laptops'),
(200003, '2024-03-10', '02001', 1000000001, 'Pedido especial área tecnología'),

-- Proveedor 2 (3 facturas)
(200004, '2024-01-25', '04001', 1000000002, 'Suministros tecnología - Revisar calidad'),
(200005, '2024-02-20', '04001', 1000000002, 'Compra tablets departamento ventas'),
(200006, '2024-03-15', '04001', 1000000002, 'Renovación equipos móviles'),

-- Proveedor 3 (3 facturas)
(200007, '2024-01-30', '14001', 1000000003, 'Equipos computo - Facturación correcta'),
(200008, '2024-02-25', '14001', 1000000003, 'Componentes actualización servidores'),
(200009, '2024-03-20', '14001', 1000000003, 'Hardware gamer área recreación'),

-- Proveedor 4 (3 facturas)
(200010, '2024-02-05', '05001', 1000000004, 'Mobiliario oficina - Instalación incluida'),
(200011, '2024-03-01', '05001', 1000000004, 'Monitores nuevas oficinas'),
(200012, '2024-03-25', '05001', 1000000004, 'Equipos audio videoconferencias'),

-- Proveedor 5 (3 facturas)
(200013, '2024-02-10', '17001', 1000000005, 'Dispositivos electrónicos - Garantía extendida'),
(200014, '2024-03-05', '17001', 1000000005, 'Proyectores sala juntas'),
(200015, '2024-03-30', '17001', 1000000005, 'Sistema respaldo energía'),

-- Proveedor 6 (3 facturas)
(200016, '2024-02-15', '02001', 1000000006, 'Insumos informáticos - Descuento por volumen'),
(200017, '2024-03-10', '02001', 1000000006, 'Tablets capacitación'),
(200018, '2024-04-05', '02001', 1000000006, 'Smartphones ejecutivos'),

-- Proveedor 7 (3 facturas)
(200019, '2024-02-20', '13001', 1000000007, 'Equipos red - Configuración requerida'),
(200020, '2024-03-15', '13001', 1000000007, 'Smartphones personal operativo'),
(200021, '2024-04-10', '13001', 1000000007, 'Tarjetas gráficas diseño'),

-- Proveedor 8 (3 facturas)
(200022, '2024-02-25', '06001', 1000000008, 'Audio y video - Pruebas funcionales'),
(200023, '2024-03-20', '06001', 1000000008, 'Auriculares call center'),
(200024, '2024-04-15', '06001', 1000000008, 'Micrófonos reuniones'),

-- Proveedor 9 (3 facturas)
(200025, '2024-03-01', '14001', 1000000009, 'Componentes PC - Compatibilidad verificar'),
(200026, '2024-03-25', '14001', 1000000009, 'SSD actualización equipos'),
(200027, '2024-04-20', '14001', 1000000009, 'Proyectores auditorio'),

-- Proveedor 10 (3 facturas)
(200028, '2024-03-05', '04001', 1000000010, 'Periféricos - Empaque original'),
(200029, '2024-03-30', '04001', 1000000010, 'Teclados mecánicos desarrollo'),
(200030, '2024-04-25', '04001', 1000000010, 'Monitores diseño gráfico'),

-- Proveedor 11 (3 facturas)
(200031, '2024-03-10', '02001', 1000000011, 'Hardware gamer - Especificaciones técnicas'),
(200032, '2024-04-05', '02001', 1000000011, 'Tablets demostraciones'),
(200033, '2024-05-01', '02001', 1000000011, 'Smartphones alta gama'),

-- Proveedor 12 (3 facturas)
(200034, '2024-03-15', '05001', 1000000012, 'Fuentes y estabilizadores - Certificación'),
(200035, '2024-04-10', '05001', 1000000012, 'Cámaras web teletrabajo'),
(200036, '2024-05-05', '05001', 1000000012, 'Micrófonos streaming'),

-- Proveedor 13 (3 facturas)
(200037, '2024-03-20', '17001', 1000000013, 'Equipos comunicación - Soporte técnico'),
(200038, '2024-04-15', '17001', 1000000013, 'Escritorios oficina'),
(200039, '2024-05-10', '17001', 1000000013, 'Sillas ergonómicas'),

-- Proveedor 14 (3 facturas)
(200040, '2024-03-25', '13001', 1000000014, 'Almacenamiento - Velocidades garantizadas'),
(200041, '2024-04-20', '13001', 1000000014, 'Laptops ejecutivas'),
(200042, '2024-05-15', '13001', 1000000014, 'Mouse inalámbricos'),

-- Proveedor 15 (3 facturas)
(200043, '2024-04-01', '14001', 1000000015, 'Redes y conectividad - Estándares internacionales'),
(200044, '2024-04-25', '14001', 1000000015, 'Impresoras área administrativa'),
(200045, '2024-05-20', '14001', 1000000015, 'Tablets ventas campo'),

-- Proveedor 16 (3 facturas)
(200046, '2024-04-05', '04001', 1000000016, 'Muebles oficina - Ergonomía certificada'),
(200047, '2024-04-30', '04001', 1000000016, 'SSD almacenamiento'),
(200048, '2024-05-25', '04001', 1000000016, 'Memorias RAM servidores'),

-- Proveedor 17 (3 facturas)
(200049, '2024-04-10', '02001', 1000000017, 'Equipos alta gama - Rendimiento verificado'),
(200050, '2024-05-05', '02001', 1000000017, 'Tarjetas gráficas IA'),
(200051, '2024-05-30', '02001', 1000000017, 'Fuentes poder gaming'),

-- Proveedor 18 (3 facturas)
(200052, '2024-04-15', '05001', 1000000018, 'Soluciones digitales - Integración sistemas'),
(200053, '2024-05-10', '05001', 1000000018, 'Laptops básicas'),
(200054, '2024-06-05', '05001', 1000000018, 'Monitores secundarios'),

-- Proveedor 19 (3 facturas)
(200055, '2024-04-20', '17001', 1000000019, 'Dispositivos móviles - Liberados'),
(200056, '2024-05-15', '17001', 1000000019, 'Altavoces salas'),
(200057, '2024-06-10', '17001', 1000000019, 'Teclados multimedia'),

-- Proveedor 20 (3 facturas)
(200058, '2024-04-25', '13001', 1000000020, 'Accesorios - Calidad premium'),
(200059, '2024-05-20', '13001', 1000000020, 'Router WiFi cobertura'),
(200060, '2024-06-15', '13001', 1000000020, 'UPS servidores críticos');

-- 10. Insertar detalles de compra (múltiples productos por factura)
INSERT INTO tab_det_compra (id_factura, id_prod, val_cant, val_bruto, val_descu, val_iva, val_neto) VALUES
-- Facturas Proveedor 1
(200001, 1, 2, 5000000, 250000, 855000, 5605000),
(200001, 2, 10, 850000, 42500, 137275, 944775),
(200002, 1, 3, 7500000, 375000, 1282500, 8412500),
(200002, 3, 5, 600000, 30000, 96900, 666900),
(200003, 4, 4, 3200000, 160000, 516800, 3556800),
(200003, 5, 2, 900000, 45000, 145350, 1000350),

-- Facturas Proveedor 2
(200004, 2, 15, 1200000, 60000, 193800, 1333800),
(200004, 6, 3, 3600000, 180000, 581400, 4001400),
(200005, 6, 5, 6000000, 300000, 969000, 6669000),
(200005, 7, 2, 3600000, 180000, 581400, 4001400),
(200006, 7, 4, 7200000, 360000, 1162800, 8002800),
(200006, 8, 8, 1200000, 60000, 193800, 1333800),

-- Continuar con más detalles para las demás facturas...
-- Facturas Proveedor 3
(200007, 3, 10, 1100000, 55000, 168300, 1213300),
(200007, 10, 15, 4200000, 210000, 678300, 4668300),
(200008, 11, 2, 6400000, 320000, 1033600, 7113600),
(200008, 12, 10, 1800000, 90000, 290700, 2000700),
(200009, 13, 20, 1800000, 90000, 290700, 2000700),

-- Facturas Proveedor 4
(200010, 4, 6, 4500000, 225000, 726750, 5001750),
(200010, 14, 12, 1440000, 72000, 232560, 1600560),
(200011, 15, 8, 1600000, 80000, 258400, 1778400),
(200012, 16, 5, 2250000, 112500, 363375, 2500875),

-- Facturas Proveedor 5
(200013, 5, 4, 1680000, 84000, 271320, 1867320),
(200013, 18, 1, 1500000, 75000, 242250, 1667250),
(200014, 19, 6, 1080000, 54000, 174420, 1200420),
(200015, 20, 3, 1200000, 60000, 193800, 1333800),

-- Facturas Proveedor 6
(200016, 6, 4, 4600000, 230000, 701500, 5071500),
(200016, 2, 20, 1640000, 82000, 250100, 1808100),
(200017, 7, 3, 5250000, 262500, 800625, 5793125),
(200018, 8, 15, 2175000, 108750, 331575, 2396325),

-- Agregar más detalles según sea necesario...
-- Solo muestro algunos ejemplos para no hacer el script demasiado largo

-- Facturas Proveedor 7
(200019, 7, 2, 3400000, 170000, 518500, 3748500),
(200020, 10, 8, 2160000, 108000, 329400, 2381400),

-- Facturas Proveedor 8
(200022, 8, 10, 1400000, 70000, 213500, 1543500),
(200023, 14, 15, 1725000, 86250, 263063, 1900313),

-- Facturas Proveedor 9
(200025, 9, 12, 3960000, 198000, 603900, 4365900),
(200026, 18, 2, 2900000, 145000, 442250, 3197250),

-- Facturas Proveedor 10
(200028, 10, 25, 6500000, 325000, 991250, 7166250),
(200029, 3, 8, 840000, 42000, 128100, 926100);

-- 11. Insertar pagos (para las primeras 20 facturas como ejemplo)
INSERT INTO tab_pagos (id_factura, id_pago, fec_pago, val_pago, val_saldo) VALUES
-- Pagos para factura 200001
(200001, 1, '2024-02-05', 2000000, 3605000),
(200001, 2, '2024-02-15', 2000000, 1605000),
(200001, 3, '2024-02-25', 1605000, 0),

-- Pagos para factura 200002
(200002, 1, '2024-03-05', 4000000, 4412500),
(200002, 2, '2024-03-15', 4000000, 412500),
(200002, 3, '2024-03-25', 412500, 0),

-- Pagos para factura 200003
(200003, 1, '2024-04-05', 2500000, 2057150),
(200003, 2, '2024-04-15', 2057150, 0),

-- Pagos para factura 200004
(200004, 1, '2024-03-05', 1500000, 3837600),
(200004, 2, '2024-03-15', 2000000, 1837600),
(200004, 3, '2024-03-25', 1837600, 0),

-- Pagos para factura 200005
(200005, 1, '2024-04-05', 5000000, 5670400),
(200005, 2, '2024-04-15', 5000000, 670400),
(200005, 3, '2024-04-25', 670400, 0),

-- Pagos para factura 200006
(200006, 1, '2024-05-05', 4000000, 5336600),
(200006, 2, '2024-05-15', 4000000, 1336600),
(200006, 3, '2024-05-25', 1336600, 0),

-- Continuar con más pagos...
-- Pagos para factura 200007
(200007, 1, '2024-04-05', 3000000, 2881600),
(200007, 2, '2024-04-15', 2881600, 0),

-- Pagos para factura 200008
(200008, 1, '2024-05-05', 4000000, 5034300),
(200008, 2, '2024-05-15', 4000000, 1034300),
(200008, 3, '2024-05-25', 1034300, 0),

-- Pagos para factura 200009
(200009, 1, '2024-06-05', 1000000, 1000700),
(200009, 2, '2024-06-15', 1000700, 0),

-- Pagos para factura 200010
(200010, 1, '2024-05-05', 3000000, 3602310),
(200010, 2, '2024-05-15', 3000000, 602310),
(200010, 3, '2024-05-25', 602310, 0);

