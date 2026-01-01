

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

-- on parcours le graphe avec with recursive
WITH RECURSIVE SupplyChainPath AS (
-- étape de base : on part des fournisseurs et on récupère les produits qu'ils fournissent
    SELECT
    -- initialisation des valeurs
        s.id_supplier,
        p.SKU AS current_node,
        NULL::INT AS carrier_id,
        NULL::INT AS client_id,
        sp.manufacturing_cost
            + COALESCE(pc.shipping_cost, 0)
            + COALESCE(cr.route_cost, 0) AS total_cost,
            -- profondeur initiale
        1 AS depth
    FROM Supplier s
    JOIN Supplier_Product sp ON s.id_supplier = sp.supplier_id
    JOIN Product p ON sp.product_sku = p.SKU
    LEFT JOIN Product_Carrier pc ON p.SKU = pc.product_sku
    LEFT JOIN Carrier_Route cr ON pc.carrier_id = cr.carrier_id
    -- étape récursive : on étend les chemins en ajoutant des transporteurs et des clients
    UNION ALL

    SELECT
    -- valeurs récursives
        scp.id_supplier,
        scp.current_node,
        cc.carrier_id,
        cc.client_id,
        scp.total_cost
            + COALESCE(pc.shipping_cost, 0)
            + COALESCE(cr.route_cost, 0) AS total_cost,
        -- incrémentation de la profondeur
        scp.depth + 1
        -- jointures pour étendre le chemin
    FROM SupplyChainPath scp
    JOIN Product_Carrier pc ON scp.current_node = pc.product_sku
    JOIN Carrier_Client cc ON pc.carrier_id = cc.carrier_id
    LEFT JOIN Carrier_Route cr ON cc.carrier_id = cr.carrier_id
    -- condition d'arrêt : on s'arrête si on atteint un client ou si la profondeur maximale est atteinte et on filtre sur le cout
    WHERE scp.depth < 5
      AND scp.total_cost < 200
)

-- sélection finale des chemins valides avec coût total inférieur à 200
SELECT DISTINCT
    s.name AS supplier,
    c.demographic AS client,
    total_cost,
    depth
FROM SupplyChainPath scp
JOIN Supplier s ON scp.id_supplier = s.id_supplier
JOIN Client c ON scp.client_id = c.id_client
WHERE total_cost < 200
LIMIT 5;
