USE [GD2015C1]
  SELECT f.fami_detalle, COUNT (p.prod_codigo), SUM(i.item_cantidad)
  FROM dbo.Producto p
  JOIN dbo.Item_Factura i ON i.item_producto = p.prod_codigo
  JOIN dbo.Familia f on f.fami_id = p.prod_familia
  JOIN dbo.Factura f2 on f2.fact_numero = i.item_numero
  GROUP BY f.fami_detalle, i.item_precio, f2.fact_fecha
  HAVING sum() > 20000 and YEAR(f2.fact_fecha) = 2012
  ORDER BY COUNT (p.prod_codigo)