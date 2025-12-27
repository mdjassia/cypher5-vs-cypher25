PROFILE
MATCH p = (s:Supplier)-[*..5]->(c:Client)
WHERE ALL(r IN relationships(p) WHERE coalesce(r.lead_time,0) < 30)
RETURN p
LIMIT 5;

CYPHER 25
PROFILE
MATCH p = (s:Supplier)-[*..5]->(c:Client)
WHERE allReduce(total=0, r IN relationships(p) | total + coalesce(r.lead_time,0), total + coalesce(r.lead_time,0) < 100)
RETURN p
LIMIT 5;



MATCH p = shortestPath(
  (s:Supplier {name:'Supplier 3'})-[*..5]->(c:Client {demographic:'Non-binary'})
)
RETURN p;

CYPHER 25
MATCH p = shortestPath(
  (s:Supplier {name:'Supplier 3'})-[*..5]->(c:Client {demographic:'Non-binary'})
)
RETURN p;

#on cherche tout les chemins qui ont un cout inferieur a 200.
#on doit parcourir 2 fois tout les chemins avec cypher 5 et utilisation du not EXISTS
PROFILE
MATCH p = (s:Supplier)-[*..5]->(c:Client)
WHERE
  NOT EXISTS {
    MATCH (s)-[*..5]->(c)
    WITH p,
         reduce(total = 0, r IN relationships(p) |
           CASE
             WHEN total + coalesce(r.manufacturing_cost,0)
                  + coalesce(r.shipping_cost,0)
                  + coalesce(r.route_cost,0) > 200
             THEN 1
             ELSE 0
           END
         ) AS invalid
    WHERE invalid = 1
  }
RETURN p
LIMIT 5;

#avec cypher 25, on utilise allReduce qui permet d'etre beaucoup plus efficace et plus lisible
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