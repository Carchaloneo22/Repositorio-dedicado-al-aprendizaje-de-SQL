# Taller práctico de SQL - Sistema de compras y proveedores

**Estudiante:** Jose David Gomez Saavedra
**Programa:** SENA - Análisis y Desarrollo de Software
**Asignatura:** Bases de Datos Relacionales
**Motor:** PostgreSQL
**Fecha:** 9 de noviembre de 2026

## Bloque I: consultas básicas, filtros y agregaciones

### Ejercicio 1: SELECT básico

Traer todos los campos y registros de la tabla de proveedores.

```sql
SELECT \*
FROM tab\_prov;
```

El asterisco trae todas las columnas y como no hay WHERE salen todas las filas.

### Ejercicio 2: SELECT con WHERE

Productos que estén activos.

```sql
SELECT \*
FROM tab\_prod
WHERE ind\_estado = TRUE;
```

El WHERE deja solo los productos donde ind\_estado es verdadero.

### Ejercicio 3: SELECT con ORDER BY

Proveedores ordenados alfabéticamente por el primer nombre.

```sql
SELECT \*
FROM tab\_prov
ORDER BY nom\_prov ASC;
```

ASC ordena de la A a la Z.

### Ejercicio 4: SELECT con LIMIT

Los primeros 10 registros de ciudades, con id y nombre.

```sql
SELECT id\_ciud, nom\_ciud
FROM tab\_ciud
LIMIT 10;
```

Solo se piden dos columnas y LIMIT corta el resultado en 10 filas.

### Ejercicio 5: COUNT

Total de órdenes de compra registradas.

```sql
SELECT COUNT(\*) AS total\_ordenes
FROM tab\_orden\_compra;
```

COUNT(\*) cuenta todas las filas de la tabla.

### Ejercicio 6: SUM

Monto total del valor neto en el detalle de compra.

```sql
SELECT SUM(val\_neto) AS total\_valor\_neto
FROM tab\_det\_compra;
```

SUM suma toda la columna val\_neto y devuelve una sola fila.

### Ejercicio 7: AVG

Promedio del cupo de crédito de los proveedores.

```sql
SELECT AVG(val\_cupocre) AS promedio\_cupo
FROM tab\_prov;
```

AVG saca el promedio de val\_cupocre de todos los proveedores.

### Ejercicio 8: GROUP BY

Cantidad de ciudades por departamento.

```sql
SELECT id\_dpto, COUNT(\*) AS cantidad\_ciudades
FROM tab\_ciud
GROUP BY id\_dpto
ORDER BY id\_dpto;
```

Se agrupan las ciudades por departamento y COUNT cuenta cuántas hay en cada grupo.

### Ejercicio 9: INSERT

Insertar en tab\_areas el área 9 llamada Auditoría con encargada Elena Beltrán.

```sql
INSERT INTO tab\_areas (id\_area, nom\_area, nom\_encarg)
VALUES (9, 'Auditoría', 'Elena Beltrán');
```

Los valores van en el mismo orden que las columnas.

### Ejercicio 10: UPDATE

Cambiar a 98 los puntos del proveedor 1000000001.

```sql
UPDATE tab\_prov
SET val\_puntos = 98
WHERE id\_prov = 1000000001;
```

El WHERE es importante, sin él se actualizarían todos los proveedores.

