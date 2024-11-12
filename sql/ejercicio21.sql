/*21. Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. Se
considera que una factura es incorrecta cuando la diferencia entre el total de la factura
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de
los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar
son:
 Año
 Clientes a los que se les facturo mal en ese año
 Facturas mal realizadas en ese año
*/

USE [GD2015C1]
GO
SELECT YEAR(f.fact_fecha) [Anio],
    count(distinct f.fact_cliente) [Clientes a los que se les facturo mal en ese anio],
    count(distinct f.fact_numero) [Facturas mal realizadas en ese anio]
FROM dbo.Factura f
WHERE
    f.fact_total - f.fact_total_impuestos - (
    SELECT sum(i2.item_cantidad * i2.item_precio)
    From dbo.Item_Factura i2
    WHERE i2.item_numero = f.fact_numero
  AND i2.item_sucursal = f.fact_sucursal
  AND i2.item_tipo = f.fact_tipo
    )
    >1
GROUP BY YEAR(f.fact_fecha)
