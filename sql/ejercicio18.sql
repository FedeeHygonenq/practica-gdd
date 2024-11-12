/*18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
  La consulta debe retornar:
  DETALLE_RUBRO: Detalle del rubro
  VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
  PROD1: Código del producto más vendido de dicho rubro
  PROD2: Código del segundo producto más vendido de dicho rubro
  CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
  días
  La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
  por cantidad de productos diferentes vendidos del rubro
  */






SELECT
	r.rubr_detalle,
	ISNULL(SUM(i.item_cantidad * i.item_precio),
	0) AS ventas,
	ISNULL((
	SELECT
		TOP 1 p2.prod_codigo
	FROM
		Producto p2
	INNER JOIN Item_Factura i2 ON
		p2.prod_codigo = i2.item_producto
	WHERE
		p2.prod_rubro = r.rubr_id
	GROUP BY
		p2.prod_codigo
	ORDER BY
		SUM(i2.item_cantidad * i2.item_precio) DESC),
	0) AS primer_prod_mas_vendido,
	ISNULL((
	SELECT
		TOP 1 p.prod_codigo
	FROM
		Producto p
	INNER JOIN Item_Factura i ON
		p.prod_codigo = i.item_producto
	WHERE
		p.prod_rubro = r.rubr_id
		AND p.prod_codigo <> (
		SELECT
			TOP 1 p.prod_codigo
		FROM
			Producto p
		INNER JOIN Item_Factura i ON
			p.prod_codigo = i.item_producto
		WHERE
			p.prod_rubro = r.rubr_id
		GROUP BY
			p.prod_codigo
		ORDER BY
			SUM(i.item_cantidad * i.item_precio) DESC)
	GROUP BY
		p.prod_codigo
	ORDER BY
		SUM(i.item_cantidad * i.item_precio) DESC),
	0) AS segundo_prod_mas_vendido,
	ISNULL((
	SELECT
		TOP 1 f3.fact_cliente
	FROM
		Factura f3
	INNER JOIN Item_Factura i3 ON
		f3.fact_tipo = i3.item_tipo
		AND f3.fact_sucursal = i3.item_sucursal
		AND f3.fact_numero = i3.item_numero
	INNER JOIN Producto p3 ON
		i3.item_producto = p3.prod_codigo
	WHERE
		p3.prod_rubro = r.rubr_id
		AND f3.fact_fecha BETWEEN DATEADD(DAY,-30,(SELECT MAX(f4.fact_fecha) FROM Factura f4)) AND (
		SELECT
			MAX(f5.fact_fecha)
		FROM
			Factura f5)
	GROUP BY
		f3.fact_cliente
	ORDER BY
		SUM(i3.item_cantidad) DESC ),
	0)AS cliente_mas_comprador_30_dias
FROM
	Rubro r
INNER JOIN Producto p ON
	rubr_id = p.prod_rubro
LEFT JOIN Item_Factura i ON
	p.prod_codigo = i.item_producto
LEFT JOIN Factura f ON
	i.item_numero = f.fact_numero
	AND i.item_tipo = f.fact_tipo
	AND i.item_sucursal = f.fact_sucursal
GROUP BY
	r.rubr_id,
	r.rubr_detalle
ORDER BY
	COUNT(DISTINCT p.prod_codigo)