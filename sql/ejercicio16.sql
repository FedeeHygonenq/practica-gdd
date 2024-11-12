
USE [GD2015C1]
GO
SELECT YEAR(f.fact_fecha),
    (select top 1 p2.prod_familia from producto p2
    JOIN dbo.Item_Factura i3 on i3.item_producto = p2.prod_codigo and p2.prod_familia = f2.fami_id
    order by count(i.item_numero) desc),
    count(distinct p.prod_rubro),
    (SELECT COUNT(*) FROM Composicion c2 WHERE c2.comp_producto = i.item_producto),
    (SELECT COUNT(*) FROM Item_Factura i2 WHERE i2.item_producto = p.prod_codigo),
    (SELECT top 1 c.clie_codigo from cliente c ORDER BY sum(i.item_cantidad) desc),
    sum(i.item_cantidad) / (SELECT sum(i.item_cantidad) FROM dbo.Item_Factura i4)
FROM dbo.Factura f
JOIN dbo.Item_Factura i ON f.fact_numero = i.item_numero
JOIN dbo.Producto p ON i.item_producto = p.prod_codigo
JOIN dbo.Familia f2 on f2.fami_id = p.prod_familia
GROUP BY YEAR(f.fact_fecha), f2.fami_id
ORDER BY sum(i.item_cantidad) DESC