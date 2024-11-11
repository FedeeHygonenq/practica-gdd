/*13. Realizar una consulta que retorne para cada producto que posea composición nombre
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad
de los productos que lo componen. Solo se deberán mostrar los productos que estén
compuestos por más de 2 productos y deben ser ordenados de mayor a menor por
cantidad de productos que lo componen.  */


USE [GD2015C1]
GO
SELECT p.prod_detalle, p.prod_precio, sum(p.prod_precio *c.comp_cantidad) [precio de la sumatoria de los precios por la cantidad]
FROM dbo.Producto p
JOIN dbo.Composicion c on c.comp_producto = p.prod_codigo
JOIN dbo.Producto p2 on p.prod_codigo = c.comp_producto
GROUP BY p.prod_detalle, p.prod_precio, c.comp_cantidad
HAVING c.comp_cantidad > 2
ORDER BY c.comp_cantidad DESC
