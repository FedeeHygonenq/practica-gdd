--6. Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese
--rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que
--tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.
USE [GD2015C1]
GO
SELECT r.rubr_id, r.rubr_detalle, COUNT(r.rubr_id), SUM(s.stoc_cantidad)
FROM dbo.Rubro r
JOIN dbo.Producto p ON p.prod_rubro = r.rubr_id
JOIN dbo.STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY r.rubr_id, r.rubr_detalle
select ST.stoc_cantidad from STOCK ST where ST.stoc_producto = '00000000' AND ST.stoc_deposito = '00'

