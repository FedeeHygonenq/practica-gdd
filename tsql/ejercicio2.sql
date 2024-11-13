/*2. Realizar una función que dado un artículo y una fecha, retorne el stock que
existía a esa fecha*/
DROP FUNCTION Ejercicio2
CREATE FUNCTION Ejercicio2 (@art varchar(8),@date datetime)
RETURNS decimal(12,2)
AS
BEGIN
RETURN
	(
		SELECT SUM(stoc_cantidad)
		FROM STOCK S
		WHERE S.stoc_producto = @art
	)
	+
	(
		SELECT SUM(i.item_cantidad)
		FROM Item_Factura i
			 JOIN Factura F
				ON F.fact_numero = i.item_numero
		WHERE i.item_producto = @art AND F.fact_fecha <= @date
	) 
END
GO

SELECT dbo.Ejercicio2('00000102',(SELECT TOP 1 
f.fact_fecha
FROM dbo.Factura f
ORDER BY f.fact_total desc
)
)
