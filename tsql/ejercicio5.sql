/*
5. Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada Fact_table tiene las siguiente definición:
Create table Fact_table
( anio char(4),
mes char(2),
familia char(3),
rubro char(4),
zona char(3),
cliente char(6),
producto char(8),
cantidad decimal(12,2),
monto decimal(12,2)
)
Alter table Fact_table
Add constraint primary key(anio,mes,familia,rubro,zona,cliente,producto)

*/
IF OBJECT_ID('Fact_table','U') IS NOT NULL 
DROP TABLE Fact_table
GO

CREATE TABLE Fact_table
( anio char(4),
mes char(2),
familia char(3),
rubro char(4),
zona char(3),
cliente char(6),
producto char(8),
cantidad decimal(12,2),
monto decimal(12,2)
)
Alter table Fact_table
Add constraint pk_Fact_table_ID primary key(anio,mes,familia,rubro,zona,cliente,producto)
GO

CREATE PROCEDURE [dbo].[Ejercicio5]
AS
BEGIN
INSERT INTO Fact_table
SELECT YEAR(f.fact_fecha), MONTH(f.fact_fecha), p.prod_familia ,d.depa_zona , f.fact_cliente, i.item_producto, sum(i.item_cantidad),sum(i.item_precio)
FROM dbo.Factura f
JOIN dbo.Item_Factura i on i.item_numero = f.fact_numero
JOIN dbo.Producto p on p.prod_codigo = i.item_producto
JOIN dbo.Empleado e on e.empl_codigo = f.fact_vendedor
JOIN dbo.Departamento d on e.empl_departamento = d.depa_codigo
GROUP BY YEAR(f.fact_fecha), MONTH(f.fact_fecha), p.prod_familia ,d.depa_zona , f.fact_cliente, i.item_producto
END
EXEC Ejercicio5
SELECt * 
FROM Fact_table
