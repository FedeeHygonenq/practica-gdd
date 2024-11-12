/*22. Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por
trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1
por cada trimestre).
Se deben mostrar 4 columnas:
 Detalle del rubro
 Numero de trimestre del año (1 a 4)
 Cantidad de facturas emitidas en el trimestre en las que se haya vendido al
menos un producto del rubro
 Cantidad de productos diferentes del rubro vendidos en el trimestre
El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada
rubro primero el trimestre en el que mas facturas se emitieron.
No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas
no superen las 100.
En ningun momento se tendran en cuenta los productos compuestos para esta
estadistica.
*/
USE [GD2015C1]
GO

SELECT
    r.rubr_detalle,
    CASE
        WHEN MONTH(f.fact_fecha) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(f.fact_fecha) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(f.fact_fecha) BETWEEN 7 AND 9 THEN 3
        ELSE 4
END AS [Trimestre],
    COUNT(DISTINCT f.fact_numero) AS [Cantidad de facturas],
    sum(DISTINCT i.item_cantidad) AS [Cantidad de productos vendidos]
FROM
    dbo.Rubro r
JOIN
    dbo.Producto p ON p.prod_rubro = r.rubr_id
JOIN
    dbo.Item_Factura i ON i.item_producto = p.prod_codigo
JOIN
    dbo.Factura f ON f.fact_numero = i.item_numero
                  AND f.fact_tipo = i.item_tipo
                  AND f.fact_sucursal = i.item_sucursal
WHERE
    NOT EXISTS (
        SELECT 1
        FROM dbo.Composicion c
        WHERE i.item_producto = c.comp_componente OR i.item_producto = c.comp_producto
    )
GROUP BY
    r.rubr_detalle,
    CASE
        WHEN MONTH(f.fact_fecha) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(f.fact_fecha) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(f.fact_fecha) BETWEEN 7 AND 9 THEN 3
        ELSE 4
END
HAVING
    COUNT(DISTINCT f.fact_numero + CAST(f.fact_tipo AS VARCHAR(10)) + CAST(f.fact_sucursal AS VARCHAR(10))) >= 100
ORDER BY
    r.rubr_detalle,
    [Cantidad de facturas] DESC;
