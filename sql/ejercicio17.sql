/*17. Escriba una consulta que retorne una estadística de ventas por año y mes para cada
  producto.
  La consulta debe retornar:
  PERIODO: Año y mes de la estadística con el formato YYYYMM
  PROD: Código de producto
  DETALLE: Detalle del producto
  CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
  VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo
  pero del año anterior
  CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
  periodo
  La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
  por periodo y código de producto.
*/
USE [GD2015C1]
GO
SELECT YEAR(f.fact_fecha)*100 + MONTH(f.fact_fecha)[PERIODO], p.prod_codigo [PROD], sum(i.item_cantidad),
(SELECT COALESCE(sum(i2.item_cantidad) , 0)FROM dbo.Factura f2
JOIN dbo.Item_Factura i2 ON i2.item_numero = f2.fact_numero
                       AND i2.item_sucursal = f2.fact_sucursal
                       AND i2.item_tipo = f2.fact_tipo
WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)-1 and i2.item_producto = i.item_producto) [cant_ventas_anterior],
count(f.fact_numero)[CANT_FACTURAS]

FROM dbo.Factura f
JOIN dbo.Item_Factura i ON i.item_numero = f.fact_numero
                       AND i.item_sucursal = f.fact_sucursal
                       AND i.item_tipo = f.fact_tipo
JOIN dbo.Producto p on p.prod_codigo = i.item_producto
GROUP BY f.fact_fecha, p.prod_codigo, i.item_producto
