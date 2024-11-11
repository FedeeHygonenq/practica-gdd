-- 9. Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
--   mismo y la cantidad de depósitos que ambos tienen asignados.


USE [GD2015C1]
GO

SELECT e.empl_jefe, e.empl_codigo, e.empl_nombre, COUNT(d.depo_codigo)
FROM dbo.Empleado e
JOIN dbo.Empleado j ON j.empl_codigo = e.empl_jefe
JOIN dbo.DEPOSITO d on depo_encargado = e.empl_codigo OR depo_encargado = j.empl_codigo
GROUP BY  e.empl_jefe, e.empl_codigo, e.empl_nombre, e.empl_apellido