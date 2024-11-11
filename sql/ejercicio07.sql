-- Generar una consulta que muestre para cada artículo código, detalle, mayor precio
--  menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
--  10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean
--  stock.
USE [GD2015C1]

SELECT p.prod_codigo, p.prod_detalle, MIN (i.item_precio) minimo, MAX (i.item_precio) maximo, (MAX(i.item_precio) - MIN(i.item_precio))*100 / MIN(i.item_precio) difPorcentaje
FROM Producto p
JOIN STOCK s On s.stoc_producto = p.prod_codigo
JOIN dbo.Item_Factura i on i.item_producto = p.prod_codigo
WHERE s.stoc_cantidad > 0
GROUP BY p.prod_codigo, p.prod_detalle