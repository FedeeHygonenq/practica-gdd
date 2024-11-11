--8. Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
--  artículo, stock del depósito que más stock tiene.
USE [GD2015C1]

SELECT p.prod_detalle, max(s.stoc_cantidad)
FROM dbo.Producto p
JOIN dbo.STOCK s ON s.stoc_producto = p.prod_codigo
JOIN dbo.DEPOSITO d ON d.depo_codigo = s.stoc_deposito
GROUP BY d.depo_detalle, p.prod_detalle, s.stoc_cantidad,  s.stoc_deposito
HAVING s.stoc_deposito >= (SELECT COUNT(*) FROM dbo.DEPOSITO)

