/*16. Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar:
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.

Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.*/

USE [GD2015C1]
GO

SELECT c.clie_razon_social AS NombreCliente,
       SUM(i.item_cantidad) AS UnidadesTotalesVendidas,
(select top 1 p.prod_codigo
from dbo.Cliente cli
JOIN dbo.Factura f on f.fact_cliente = cli.clie_codigo
JOIN dbo.Item_Factura i on i.item_numero = f.fact_numero and i.item_sucursal = f.fact_sucursal and i.item_tipo = f.fact_tipo
JOIN dbo.Producto p on p.prod_codigo = i.item_producto
where YEAR(f.fact_fecha) = 2012 and f.fact_cliente = c.clie_codigo
group by i.item_producto, i.item_cantidad,  p.prod_codigo
order by count(i.item_producto) DESC
)
FROM dbo.Cliente c
JOIN dbo.Factura f ON f.fact_cliente = c.clie_codigo
JOIN dbo.Item_Factura i ON i.item_numero = f.fact_numero
                       AND i.item_sucursal = f.fact_sucursal
                       AND i.item_tipo = f.fact_tipo
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY c.clie_razon_social, c.clie_codigo
HAVING SUM(i.item_cantidad) <
       (
           -- Cálculo del promedio de ventas del producto más vendido en 2012 dividido por 3
           SELECT AVG(Ventas.TotalVendido) / 3
           FROM (
               SELECT TOP 1 SUM(i2.item_cantidad) AS TotalVendido
               FROM dbo.Item_Factura i2
               JOIN dbo.Factura f2 ON i2.item_numero = f2.fact_numero
                                   AND i2.item_sucursal = f2.fact_sucursal
                                   AND i2.item_tipo = f2.fact_tipo
               WHERE YEAR(f2.fact_fecha) = 2012
               GROUP BY i2.item_producto
               ORDER BY TotalVendido DESC, i2.item_producto ASC
           ) AS Ventas
       )
ORDER BY c.clie_razon_social;

