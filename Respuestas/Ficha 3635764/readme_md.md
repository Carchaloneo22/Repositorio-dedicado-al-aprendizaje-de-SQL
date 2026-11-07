# Sistema de Gestión de Compras y Proveedores — Consultas SQL

## Descripción General

Este repositorio contiene **30 consultas SQL** más **1 consulta compleja de auditoría/analytics** diseñadas para la base de datos del *Sistema de Gestión de Compras y Proveedores* (optimizado para PostgreSQL). El conjunto abarca desde operaciones básicas hasta análisis avanzados de volumetría, auditoría de datos e integración multicriterio.

> **Nota pedagógica:** La consulta `#1` (`SELECT * FROM tab_prov`) se incluye únicamente con fines didácticos. Extraer todos los registros sin filtrado o proyección explicita es una práctica desaconsejada en entornos de producción.

---

## Estructura de Tablas (Referencia)

El modelo relacional está compuesto por las siguientes entidades principales:

| Tabla | Descripción |
|---|---|
| `tab_prov` | Registro maestro de proveedores |
| `tab_prod` | Catálogo de productos disponibles |
| `tab_prod_prov` | Tabla asociativa de relación Producto-Proveedor |
| `tab_ciud` | Catálogo de ciudades |
| `tab_dptos` | Catálogo de departamentos o provincias |
| `tab_areas` | Áreas organizacionales solicitantes |
| `tab_orden_compra` | Registro de órdenes de compra solicitadas |
| `tab_det_compra` | Detalle ítem por ítem de cada compra realizada |
| `tab_enc_compra` | Encabezados de facturación / comprobantes de compra |
| `tab_pagos` | Histórico y registro de transacciones de pago |

---

## Listado de Consultas

### Fundamentos (1–11)

| # | Tipo | Descripción |
|---|---|---|
| 1 | `SELECT *` | Extracción total de `tab_prov` *(referencia educativa)* |
| 2 | `SELECT + WHERE` | Filtrado de productos activos (`ind_estado = true`) |
| 3 | `SELECT + ORDER BY` | Proveedores ordenados alfabéticamente |
| 4 | `SELECT + LIMIT` | Selección de las primeras 10 ciudades registradas |
| 5 | `COUNT()` | Total general de órdenes de compra |
| 6 | `SUM()` | Cálculo del total facturado neto en detalles de compra |
| 7 | `AVG()` | Promedio de cupo de crédito otorgado a proveedores |
| 8 | `GROUP BY` | Conteo de ciudades agrupadas por departamento |
| 9 | `INSERT` | Inserción de una nueva área organizacional ("Auditoría") |
| 10 | `UPDATE` | Actualización de puntos de fidelización o scoring de proveedor |
| 11 | `DELETE` | Eliminación de una orden de compra específica |

### Consultas Avanzadas (12–23)

| # | Tipo | Descripción |
|---|---|---|
| 12 | `JOIN` | Relación de ciudades con su respectivo departamento |
| 13 | Subconsulta | Productos cuyo valor supera los $2,000,000 |
| 14 | `CASE` | Clasificación dinámica de cupo de crédito (Alto / Medio / Bajo) |
| 15 | `UNION` | Consolidación de IDs de productos únicos entre órdenes y detalles |
| 16 | `UNION ALL` | Listado completo de IDs de ciudad entre proveedores y encabezados |
| 17 | `HAVING` | Identificación de facturas con más de 1 ítem registrado |
| 18 | `EXISTS` | Validación de proveedores que tienen al menos una orden asociada |
| 19 | `LIKE` | Búsqueda de proveedores cuyo correo contiene el patrón `"tecnosum"` |
| 20 | `BETWEEN` | Filtrado de facturas emitidas en el periodo de febrero 2024 |
| 21 | Volumetría | Conteo consolidado de registros por tabla principal |
| 22 | Auditoría | Detección de espacios en blanco al inicio o final de nombres de productos |
| 23 | Auditoría | Detección de caracteres corruptos o no imprimibles en observaciones |

### Consultas de Auditoría y Análisis (24–30)

| # | Tipo | Descripción |
|---|---|---|
| 24 | `information_schema` | Inspección y catálogo de constraints en `tab_det_compra` |
| 25 | Composite Type | Desempaquetado del tipo de dato compuesto `datos_prov` (PostgreSQL) |
| 26 | Agregación financiera | Resumen de total abonado y saldo pendiente por factura |
| 27 | Cruce múltiple | Análisis de productos tipo "Gamer"/"Oficina" por proveedor disponible |
| 28 | Agregación temporal | Conteo de facturas e inversión total agrupados por mes |
| 29 | Órdenes por área | Métricas de cantidad de órdenes y total de unidades solicitadas por área |
| **30** | **Analytics / Compleja** | **Auditoría integral de inversión por área** (JOINs múltiples, agregaciones y ranking) |

---

## Consulta Compleja #30 — Auditoría de Inversión por Área

Esta consulta integra las tablas del sistema para consolidar la inversión ejecutada por área organizacional, evaluando la cantidad de órdenes procesadas, ítems adquiridos, monto total gastado y promedio por orden.

```sql
SELECT 
    a.nom_area AS area_organizacional,
    COUNT(DISTINCT oc.id_orden) AS total_ordenes,
    SUM(dc.can_prod) AS total_unidades_compradas,
    SUM(dc.can_prod * dc.val_unitario) AS inversion_total,
    ROUND(AVG(dc.can_prod * dc.val_unitario), 2) AS promedio_inversion_por_item
FROM tab_areas a
INNER JOIN tab_orden_compra oc ON a.id_area = oc.id_area
INNER JOIN tab_enc_compra ec ON oc.id_orden = ec.id_orden
INNER JOIN tab_det_compra dc ON ec.id_encabezado = dc.id_encabezado
WHERE ec.ind_estado = 'APROBADO'
GROUP BY a.id_area, a.nom_area
HAVING SUM(dc.can_prod * dc.val_unitario) > 0
ORDER BY inversion_total DESC;
```

---

## Requisitos e Instalación

* **Motor de Base de Datos:** PostgreSQL 12.0 o superior (compatible con MySQL/MariaDB ajustando tipos compuestos).
* **Herramientas recomendadas:** DBeaver, pgAdmin 4 o cliente de línea de comandos `psql`.

### Ejecución

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu-usuario/gestion-compras-sql.git
   ```
2. Importa el esquema de la base de datos y la carga de datos inicial previa a la ejecución de las consultas.
3. Ejecuta los scripts de consulta en la secuencia deseada.