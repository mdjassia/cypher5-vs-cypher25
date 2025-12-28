// VRAIE clé primaire
CREATE CONSTRAINT product_sku_key IF NOT EXISTS
FOR (p:Product)
REQUIRE p.SKU IS NODE KEY;

// Unicité métier
CREATE CONSTRAINT supplier_name_unique IF NOT EXISTS
FOR (s:Supplier)
REQUIRE s.name IS UNIQUE;

CREATE CONSTRAINT carrier_name_unique IF NOT EXISTS
FOR (t:Carrier)
REQUIRE t.name IS UNIQUE;

CREATE CONSTRAINT route_name_unique IF NOT EXISTS
FOR (r:Route)
REQUIRE r.name IS UNIQUE;

CREATE CONSTRAINT location_city_unique IF NOT EXISTS
FOR (l:Location)
REQUIRE l.city IS UNIQUE;

