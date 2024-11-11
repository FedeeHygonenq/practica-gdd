/*14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que
debe retornar son:
Código del cliente
Cantidad de veces que compro en el último año
Promedio por compra en el último año
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en
el último año.
No se deberán visualizar NULLs en ninguna columna*/

USE [GD2015C1]
GO
SELECT c.clie_codigo [cod_cliente] , AVG (i.item_precio) [precio_promedio],count (f.fact_cliente)[cantidad_de_veces], count (DISTINCT i.item_producto)[compras_prod_distintos], max(i.item_precio)[max_compra]
FROM dbo.Cliente c
JOIN dbo.Factura f on f.fact_cliente = c.clie_codigo
JOIN dbo.Item_Factura i on i.item_numero = f.fact_numero
GROUP BY c.clie_codigo
ORDER BY count (f.fact_cliente) DESC