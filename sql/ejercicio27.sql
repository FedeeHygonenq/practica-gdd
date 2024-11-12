/*
 27. Escriba una consulta sql que retorne una estadística basada en la facturacion por año y
envase devolviendo las siguientes columnas:
 Año
 Codigo de envase
 Detalle del envase
 Cantidad de productos que tienen ese envase
 Cantidad de productos facturados de ese envase
 Producto mas vendido de ese envase
 Monto total de venta de ese envase en ese año
 Porcentaje de la venta de ese envase respecto al total vendido de ese año

 */
USE [GD2015C1]
 GO
SELECT
    YEAR(f.fact_fecha) [Anio],
    e.enva_codigo [Codigo de envase],
    e.enva_detalle [Detalle del envase],
    COUNT(DISTINCT p.prod_codigo) [Cantidad de productos que tienen ese envase],
    COUNT(DISTINCT i.item_producto) [Cantidad de productos facturados de ese envase],
    (
    SELECT TOP 1 p2.prod_codigo
    FROM Producto p2
    INNER JOIN Item_Factura i2 ON
    p2.prod_codigo = i2.item_producto
    INNER JOIN Factura f2 ON
    f2.fact_numero = i2.item_numero AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_tipo = i2.item_tipo
    WHERE p2.prod_envase = e.enva_codigo AND YEAR(f2.fact_fecha) = YEAR(F.fact_fecha)
    GROUP BY p2.prod_codigo
    ORDER BY COUNT(i2.item_numero) DESC
    ) [Producto mas vendido de ese envase],
    SUM(i.item_cantidad * i.item_precio) [Monto total de venta de ese envase en ese anio],
    SUM(i.item_cantidad * i.item_precio) * 100 / (
    SELECT SUM(i2.item_cantidad * i2.item_precio)
    FROM Factura f2
    INNER JOIN Item_Factura i2 ON
    f2.fact_numero = i2.item_numero AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_tipo = i2.item_tipo
    WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)
    ) [Porcentaje de la venta de ese envase respecto al total vendido de ese anio]
FROM dbo.Factura f
    JOIN dbo.Item_factura i on i.item_numero = f.fact_numero and i.item_sucursal = f.fact_sucursal and i.item_tipo = f.fact_tipo
    JOIN dbo.Producto p on p.prod_codigo = i.item_producto
    JOIN dbo.Envases e on e.enva_codigo = p.prod_envase
--where year(f.fact_fecha) = YEAR(GETDATE())
GROUP BY YEAR(f.fact_fecha), e.enva_codigo, e.enva_detalle
