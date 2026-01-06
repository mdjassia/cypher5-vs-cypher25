MATCH p = (s:Supplier)-[*..6]->(c:Client)
WHERE allReduce(
  cost = 0,
  r IN relationships(p) | cost + coalesce(r.shipping_cost,0), cost < 200)
RETURN p
ORDER BY
  reduce(total = 0, r IN relationships(p) | total + coalesce(r.shipping_cost,0)) ASC
LIMIT 1;


# on explore les chemins possibles, accumule les coûts, filtre ceux dépassant un seuil
et sélectionne le chemin de coût minimal.

cependant, il n’y a ni file de priorité, ni relaxation progressive des distances.
