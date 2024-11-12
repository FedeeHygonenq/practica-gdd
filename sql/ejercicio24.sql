/*24. Escriba una consulta que considerando solamente las facturas correspondientes a los
dos vendedores con mayores comisiones, retorne los productos con composición
facturados al menos en cinco facturas,
La consulta debe retornar las siguientes columnas:
-Código de Producto
-Nombre del Producto
-Unidades facturadas
El resultado deberá ser ordenado por las unidades facturadas descendente.*/
USE[GD2015C1]
GO
SELECT p.prod_codigo, p.prod_detalle, sum(i.item_cantidad) [unidades_facturadas]
FROM dbo.Producto p
JOIN dbo.Composicion c on c.comp_producto = p.prod_codigo
JOIN dbo.Item_Factura i on i.item_producto = p.prod_codigo
JOIN dbo.Factura f on f.fact_numero = i.item_numero
WHERE f.fact_vendedor in (select top 2 e.empl_codigo FROM dbo.Empleado e order by e.comision desc)
group by p.prod_codigo, p.prod_detalle
order by count(i.item_numero) desc