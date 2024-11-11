/*
5. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.


Ejemplo de lo que retornaría la consulta:
PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2
*/
USE [GD2015C1]
GO
SELECT p.prod_codigo [PROD1], p.prod_detalle [DETALLE1], p2.prod_codigo [PROD2], p2.prod_detalle [DETALLE2], count( i.item_numero) [VECES]
FROM dbo.Item_Factura i
JOIN dbo.Producto p on p.prod_codigo = i.item_producto
JOIN dbo.Producto p2 on p.prod_codigo = i.item_producto and p.prod_detalle != p2.prod_detalle
group by p.prod_codigo, p.prod_detalle, p2.prod_codigo, p2.prod_detalle
HAVING count(i.item_numero) > 500