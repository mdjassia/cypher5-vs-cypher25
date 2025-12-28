// Scénario : chemins à coûts croissants


PROFILE
MATCH p = (prod:Product)-[:EXPEDIE|EMPRUNTE*2..4]->(r:Route)
WHERE NOT EXISTS {
  MATCH (a)-[r1]->(b)-[r2]->(c)
  WHERE r1 IN relationships(p)
    AND r2 IN relationships(p)
    AND r1.shipping_cost >= r2.route_cost
}
RETURN prod.SKU, p;


CYPHER 25
PROFILE
MATCH p = (prod:Product)-[:EXPEDIE|EMPRUNTE*2..4]->(r:Route)
WHERE allReduce(
    acc = true,
    i IN range(0, size(relationships(p)) - 2) |
        acc AND relationships(p)[i].shipping_cost < relationships(p)[i + 1].route_cost,
    true
)
RETURN prod.SKU, p;
