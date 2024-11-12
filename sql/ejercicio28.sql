/*
 28. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:
 Año.
 Codigo de Vendedor
 Detalle del Vendedor
 Cantidad de facturas que realizó en ese año
 Cantidad de clientes a los cuales les vendió en ese año.
 Cantidad de productos facturados con composición en ese año
 Cantidad de productos facturados sin composicion en ese año.
 Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.

 */
USE [GD2015C1]
 GO
SELECT
    YEAR(f.fact_fecha) [Anio],
    e.empl_codigo [Cod_vendedor],
    (SELECT COUNT(*) FROM Factura f2 where YEAR(f2.fact_fecha) = YEAR(f.fact_fecha) and f2.fact_vendedor = e.empl_codigo)[cant_clientes],
    (SELECT COUNT(DISTINCT f2.fact_cliente) FROM Factura f2 where YEAR(f2.fact_fecha) = YEAR(f.fact_fecha) and f2.fact_vendedor = e.empl_codigo) [cant_clientes],
    sum(i.item_cantidad),
    sum(i2.item_cantidad),
    sum(f.fact_total)
FROM dbo.Factura f
    JOIN dbo.Empleado e on e.empl_codigo = f.fact_vendedor
    JOIN dbo.Item_factura i on i.item_numero = f.fact_numero and i.item_sucursal = f.fact_sucursal and i.item_tipo = f.fact_tipo
    JOIN dbo.Item_factura i2 on i2.item_numero = f.fact_numero and i2.item_sucursal = f.fact_sucursal and i2.item_tipo = f.fact_tipo
    JOIN dbo.Composicion c on c.comp_producto = i2.item_producto
    JOIN dbo.Producto p on p.prod_codigo = i.item_producto and p.prod_codigo != c.comp_componente
GROUP BY YEAR(f.fact_fecha), e.empl_codigo,  F.fact_vendedor
ORDER BY 1, (
    SELECT COUNT(DISTINCT prod_codigo)
    FROM Producto
    INNER JOIN Item_Factura
    ON item_producto = prod_codigo
    INNER JOIN Factura
    ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
    WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha) AND fact_vendedor = F.fact_vendedor
    ) DESC
