--5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
--stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
--fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.

USE [GD2015C1];
GO

SELECT
    p.prod_codigo,
    p.prod_detalle,
    SUM(i.item_cantidad) AS TotalCantidad
FROM
    dbo.Factura f
JOIN
    dbo.Item_Factura i ON f.fact_numero = i.item_numero
JOIN
    dbo.Producto p ON i.item_producto = p.prod_codigo
WHERE
    YEAR(f.fact_fecha) = 2012
GROUP BY
    p.prod_codigo, p.prod_detalle
HAVING SUM(I.item_cantidad) >  (
		SELECT SUM(I2.item_cantidad)

		FROM FACTURA F2
		JOIN Item_Factura I2
			ON I2.item_numero = F2.fact_numero
		WHERE YEAR(F2.fact_fecha) = 2011 AND I2.item_producto = P.prod_codigo
		)
