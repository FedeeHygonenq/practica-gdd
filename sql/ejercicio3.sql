--3. Realizar una consulta que muestre código de producto, nombre de producto y el stock
--total, sin importar en que deposito se encuentre, los datos deben ser ordenados por
--nombre del artículo de menor a mayor.
USE [GD2015C1]
GO
SELECT p.prod_codigo, p.prod_detalle, SUM(s.stoc_cantidad)
FROM dbo.Producto p
JOIN dbo.STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY
p.prod_codigo,
p.prod_detalle
ORDER BY p.prod_detalle DESC