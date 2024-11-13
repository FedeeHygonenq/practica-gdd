/*3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución.*/

CREATE PROCEDURE CorrectEmpleadoTable
AS
BEGIN
    DECLARE @EmpleadosSinJefe INT;

    -- Count the number of employees without a boss
    SELECT @EmpleadosSinJefe = COUNT(*)
    FROM Empleado
    WHERE empl_jefe IS NULL;

    -- If more than one employee without a boss, correct the table
    IF @EmpleadosSinJefe > 1
    BEGIN
        WITH RankedEmpleados AS (
            SELECT empl_codigo,
                   ROW_NUMBER() OVER (ORDER BY empl_salario DESC, empl_ingreso) AS rank
            FROM Empleado
            WHERE empl_jefe IS NULL
        )
        UPDATE Empleado
        SET empl_jefe = (SELECT empl_codigo FROM RankedEmpleados WHERE rank = 1)
        WHERE empl_codigo IN (SELECT empl_codigo FROM RankedEmpleados WHERE rank > 1);
    END

    -- Return the number of employees without a boss before the correction
    SELECT @EmpleadosSinJefe AS EmpleadosSinJefeAntesDeCorreccion;
END;
GO

EXEC CorrectEmpleadoTable