/*
4. Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año.
*/
USE [GD2015C1]
GO
DROP PROCEDURE Ejercicio4;
GO

create PROCEDURE Ejercicio4
AS
BEGIN
    UPDATE E
    SET E.empl_comision = (
        SELECT SUM(F.fact_total)
        FROM FACTURA F
        WHERE F.fact_vendedor = E.empl_codigo
        AND YEAR(F.fact_fecha) = (SELECT MAX(YEAR(fact_fecha)) FROM FACTURA)
    )
    FROM EMPLEADO E

    SELECT TOP 1 E.empl_codigo, E.empl_comision [total]
    FROM EMPLEADO E
    ORDER BY E.empl_comision DESC
END
GO