/*19. En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
 Codigo de producto
 Detalle del producto
 Codigo de la familia del producto
 Detalle de la familia actual del producto
 Codigo de la familia sugerido para el producto
 Detalla de la familia sugerido para el producto
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente
*/

SELECT
    p.prod_codigo,
    p.prod_detalle,
    f.fami_id AS familia_actual_codigo,
    f.fami_detalle AS familia_actual_detalle,
    (
        SELECT
            TOP 1 f2.fami_id
        FROM
            Familia f2
                INNER JOIN Producto p2 ON
                f2.fami_id = p2.prod_familia
        WHERE
        LEFT(p2.prod_detalle,
    5) = LEFT(p.prod_detalle,
    5)
GROUP BY
    f2.fami_id
ORDER BY
    COUNT(*) DESC, f2.fami_id ASC) AS familia_sugerida_codigo,
    (
SELECT
    TOP 1 f2.fami_detalle
FROM
    Familia f2
    INNER JOIN Producto p2 ON
    f2.fami_id = p2.prod_familia
WHERE
    LEFT(p2.prod_detalle,
    5) = LEFT(p.prod_detalle,
    5)
GROUP BY
    f2.fami_id, f2.fami_detalle
ORDER BY
    COUNT(*) DESC, f2.fami_id ASC) AS familia_sugerida_detalle
FROM
    Producto p
    INNER JOIN Familia f ON
    p.prod_familia = f.fami_id
WHERE
    p.prod_familia <> (
    SELECT
    TOP 1 f3.fami_id
    FROM
    Familia f3
    INNER JOIN Producto p3 ON
    f3.fami_id = p3.prod_familia
    WHERE
    LEFT(p3.prod_detalle,
    5) = LEFT(p.prod_detalle,
    5)
    GROUP BY
    f3.fami_id
    ORDER BY
    COUNT(*) DESC, f3.fami_id ASC)
ORDER BY
    p.prod_detalle ASC
