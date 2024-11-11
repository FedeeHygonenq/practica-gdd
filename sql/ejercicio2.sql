--2. Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por
--cantidad vendida.

USE [GD2015C1]
GO
SELECT
    p.prod_codigo,
    p.prod_detalle,
    Sum(i.item_cantidad)
FROM
dbo.Factura f
JOIN
    dbo.Item_Factura i ON f.fact_numero = i.item_numero
JOIN
    dbo.Producto p ON i.item_producto = p.prod_codigo
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY
    p.prod_codigo,
    p.prod_detalle
ORDER BY
    Sum(i.item_cantidad) DESC;