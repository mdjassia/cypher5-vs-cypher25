

#on reprend la requetes qui trouve des chemins avec cout inferieur a 200 et qui fait max 5 arretes.
CYPHER 25
PROFILE
MATCH p = (s:Supplier)-[*..5]->(c:Client)
WHERE allReduce(
  cost = 0,
  r IN relationships(p) |
    cost + coalesce(r.manufacturing_cost,0)
         + coalesce(r.shipping_cost,0)
         + coalesce(r.route_cost,0),
  cost < 200
)
RETURN p
LIMIT 5;

#écrite en sql cela donne : 


EXPLAIN ANALYZE
WITH RECURSIVE SupplyChainPath AS (
    SELECT
        s.id_supplier,
        p.SKU AS current_node,
        NULL::INT AS carrier_id,
        NULL::INT AS client_id,
        COALESCE(sp.manufacturing_cost,0) AS total_cost,
        1 AS depth
    FROM Supplier s
    JOIN Supplier_Product sp ON s.id_supplier = sp.supplier_id
    JOIN Product p ON sp.product_sku = p.SKU

    UNION ALL

    SELECT
        scp.id_supplier,
        scp.current_node,
        cc.carrier_id,
        cc.client_id,
        scp.total_cost
            + COALESCE(pc.shipping_cost,0)
            + COALESCE(cr.route_cost,0) AS total_cost,
        scp.depth + 1
    FROM SupplyChainPath scp
    JOIN Product_Carrier pc ON scp.current_node = pc.product_sku
    JOIN Carrier_Client cc ON pc.carrier_id = cc.carrier_id
    LEFT JOIN Carrier_Route cr ON cc.carrier_id = cr.carrier_id
    WHERE scp.depth < 5
)
SELECT DISTINCT
    s.name AS supplier,
    c.demographic AS client,
    scp.total_cost,
    scp.depth
FROM SupplyChainPath scp
JOIN Supplier s ON scp.id_supplier = s.id_supplier
JOIN Client c ON scp.client_id = c.id_client
WHERE scp.total_cost < 200
LIMIT 5;
