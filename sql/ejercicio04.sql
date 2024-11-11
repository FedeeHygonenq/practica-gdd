--4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
--artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
--promedio por depósito sea mayor a 100
USE [GD2015C1]
GO
SELECT p.prod_codigo, p.prod_detalle, Sum(s.stoc_cantidad), Avg(s.stoc_cantidad) stock_promedio
FROM dbo.Item_Factura i
JOIN dbo.Producto p ON i.item_producto = p.prod_codigo
JOIN dbo.STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY p.prod_codigo, p.prod_detalle
HAVING Avg(s.stoc_cantidad) > 100