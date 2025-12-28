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