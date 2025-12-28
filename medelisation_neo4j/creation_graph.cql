
// 1. Création des Nœuds


// Produits
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MERGE (p:Product {SKU: row.SKU})
SET p.type = row.`Product type`,
    p.price = toFloat(row.Price),
    p.availability = toInteger(row.Availability),
    p.sold = toInteger(row.`Number of products sold`),
    p.revenue = toFloat(row.`Revenue generated`);

// Fournisseurs
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MERGE (s:Supplier {name: row.`Supplier name`})
SET s.location = row.Location;

// Clients
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MERGE (c:Client {demographic: row.`Customer demographics`});

// Transporteurs
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MERGE (t:Carrier {name: row.`Shipping carriers`});

// Itinéraires
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MERGE (r:Route {name: row.Routes});

// Localisations
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MERGE (l:Location {city: row.Location});

// Inspection
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MERGE (i:Inspection {result: row.`Inspection results`, defect_rate: toFloat(row.`Defect rates`)});

// 2. Création des relations 

// Fournisseur FOURNIT Produit
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MATCH (s:Supplier {name: row.`Supplier name`}), (p:Product {SKU: row.SKU})
MERGE (s)-[f:FOURNIT]->(p)
SET f.lead_time = toInteger(row.`Lead time`),
    f.production_volume = toInteger(row.`Production volumes`),
    f.manufacturing_cost = toFloat(row.`Manufacturing costs`);

// Fournisseur SITUE_A Localisation
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MATCH (s:Supplier {name: row.`Supplier name`}), (l:Location {city: row.Location})
MERGE (s)-[:SITUE_A]->(l);

// Produit EXPEDIE Transporteur
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MATCH (p:Product {SKU: row.SKU}), (t:Carrier {name: row.`Shipping carriers`})
MERGE (p)-[e:EXPEDIE]->(t)
SET e.shipping_time = toInteger(row.`Shipping times`),
    e.shipping_cost = toFloat(row.`Shipping costs`),
    e.transport_mode = row.`Transportation modes`;

// Transporteur LIVRE Client
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MATCH (t:Carrier {name: row.`Shipping carriers`}), (c:Client {demographic: row.`Customer demographics`})
MERGE (t)-[d:LIVRE]->(c)
SET d.order_quantity = toInteger(row.`Order quantities`);

// Transporteur EMPRUNTE Itinéraire
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MATCH (t:Carrier {name: row.`Shipping carriers`}), (r:Route {name: row.Routes})
MERGE (t)-[u:EMPRUNTE]->(r)
SET u.route_cost = toFloat(row.Costs);

// Produit A_RESULTAT_INSPECTION Inspection
LOAD CSV WITH HEADERS FROM 'file:///supply_chain_data.csv' AS row
MATCH (p:Product {SKU: row.SKU}), (i:Inspection {result: row.`Inspection results`, defect_rate: toFloat(row.`Defect rates`)})
MERGE (p)-[:A_RESULTAT_INSPECTION]->(i);
