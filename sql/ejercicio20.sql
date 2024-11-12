USE [GD2015C1];
GO

SELECT TOP 3 
    e.empl_codigo AS legajo,
        e.empl_nombre + ' ' + e.empl_apellido AS nombre_completo,
       e.empl_ingreso AS anio_ingreso,

       -- Puntaje 2011
       CASE
           WHEN (SELECT COUNT(f.fact_numero) FROM Factura f WHERE f.fact_vendedor = e.empl_codigo AND YEAR(f.fact_fecha) = 2011) >= 50
            THEN (SELECT COUNT(f2.fact_numero) FROM Factura f2 WHERE f2.fact_vendedor = e.empl_codigo AND YEAR(f2.fact_fecha) = 2011 AND f2.fact_total_impuestos > 100)
    ELSE COALESCE((SELECT COUNT(f3.fact_numero) * 1 / 2 FROM Factura f3 WHERE f3.fact_vendedor  IN (SELECT s.empl_codigo FROM Empleado s WHERE s.empl_jefe = e.empl_codigo)  AND YEAR(f3.fact_fecha) = 2011), 0)
END AS puntaje_2011,
    
    -- Puntaje 2012
    CASE 
        WHEN (SELECT COUNT(f4.fact_numero) FROM Factura f4 WHERE f4.fact_vendedor = e.empl_codigo AND YEAR(f4.fact_fecha) = 2012) >= 50
            THEN (SELECT COUNT(f5.fact_numero) FROM Factura f5 WHERE f5.fact_vendedor = e.empl_codigo AND YEAR(f5.fact_fecha) = 2012 AND f5.fact_total > 100)
            ELSE COALESCE((SELECT COUNT(f6.fact_numero) * 0.5 FROM Factura f6 WHERE f6.fact_vendedor IN (SELECT s.empl_codigo FROM Empleado s WHERE s.empl_jefe = e.empl_codigo) AND YEAR(f6.fact_fecha) = 2012), 0)
END AS puntaje_2012

FROM 
    Empleado e
ORDER BY 
    puntaje_2012 DESC;


	--otra version, da valores diferentes en 2011
SELECT
    TOP 3 e.empl_codigo AS legajo,
        e.empl_nombre,
    e.empl_apellido,
    e.empl_ingreso,
    CASE
        WHEN(
            SELECT
                COUNT(DISTINCT f2.fact_numero + f2.fact_tipo + f2.fact_sucursal)
            FROM
                Factura f2
            WHERE
                f2.fact_vendedor = e.empl_codigo
                    AND YEAR(f2.fact_fecha) = 2011) >= 50 THEN (
SELECT
    COUNT(DISTINCT f3.fact_numero + f3.fact_tipo + f3.fact_sucursal)
FROM
    Factura f3
WHERE
    f3.fact_vendedor = e.empl_codigo
  AND YEAR(f3.fact_fecha) = 2011
  AND f3.fact_total > 100 )
    ELSE 0.5 * (
SELECT
    COUNT(DISTINCT f4.fact_numero + f4.fact_tipo + f4.fact_sucursal)
FROM
    Factura f4
    INNER JOIN Empleado e2 ON
    f4.fact_vendedor = e2.empl_codigo
WHERE
    YEAR(f4.fact_fecha) = 2011
  AND e2.empl_jefe = e.empl_codigo )
END AS puntaje_2011,
	CASE
		WHEN(
		SELECT
			COUNT(DISTINCT f5.fact_numero + f5.fact_tipo + f5.fact_sucursal)
		FROM
			Factura f5
		WHERE
			f5.fact_vendedor = e.empl_codigo
			AND YEAR(f5.fact_fecha) = 2012) >= 50 THEN (
		SELECT
			COUNT(DISTINCT f6.fact_numero + f6.fact_tipo + f6.fact_sucursal)
		FROM
			Factura f6
		WHERE
			f6.fact_vendedor = e.empl_codigo
			AND YEAR(f6.fact_fecha) = 2012
			AND f6.fact_total > 100 )
		ELSE 0.5 * (
		SELECT
			COUNT(DISTINCT f7.fact_numero + f7.fact_tipo + f7.fact_sucursal)
		FROM
			Factura f7
		INNER JOIN Empleado e2 ON
			f7.fact_vendedor = e2.empl_codigo
		WHERE
			YEAR(f7.fact_fecha) = 2012
			AND e2.empl_jefe = e.empl_codigo )
END AS puntaje_2012
FROM
	Empleado e
ORDER BY
	puntaje_2012 DESC