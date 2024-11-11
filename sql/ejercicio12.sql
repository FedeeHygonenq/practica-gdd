--12. Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe
--promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del
--producto y stock actual del producto en todos los depósitos. Se deberán mostrar
--aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
--ordenarse de mayor a menor por monto vendido del producto

USE [GD2015C1]
GO
SELECT p.prod_detalle, COUNT (distinct c.clie_codigo) [compradores], avg(i.item_precio)[precio_promedio], COUNT (distinct s.stoc_deposito)[depositos], sum(s.stoc_cantidad)[cantidad_total]
FROM dbo.Producto p
JOIN dbo.Item_Factura i on i.item_producto = p.prod_codigo
JOIN dbo.Factura f on f.fact_numero = i.item_numero
JOIN dbo.Cliente c on c.clie_codigo = f.fact_cliente
JOIN dbo.STOCK s on s.stoc_producto = p.prod_codigo
WHERE YEAR ( f.fact_fecha) = 2012
GROUP BY p.prod_detalle