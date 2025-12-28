
// 3.2 Scénario : trouver le plus court chemin fournisseur → client


MATCH p = shortestPath(
  (s:Supplier {name:'Supplier 3'})-[*..5]->(c:Client {demographic:'Non-binary'})
)
RETURN p;

CYPHER 25
MATCH p = shortestPath(
  (s:Supplier {name:'Supplier 3'})-[*..5]->(c:Client {demographic:'Non-binary'})
)
RETURN p;


// avant de faire la projection faut creer la prop cost 

// FOURNIT
MATCH ()-[r:FOURNIT]->()
SET r.cost = r.lead_time;

// EXPEDIE
MATCH ()-[r:EXPEDIE]->()
SET r.cost = r.shipping_time;

// LIVRE
MATCH ()-[r:LIVRE]->()
SET r.cost = 1;

CALL gds.graph.project(
  'supplyGraphWeighted',          // nom du graphe en mémoire
  ['Supplier','Product','Carrier','Client'],  // les types de noeuds
  {                               // types de relations et propriétés
    FOURNIT: {properties: 'cost'},
    EXPEDIE: {properties: 'cost'},
    LIVRE:   {properties: 'cost'}
  }
);


MATCH (s:Supplier {name:'Supplier 3'}),
      (c:Client {demographic:'Non-binary'})
WITH s AS sourceId, c AS targetId
CALL gds.shortestPath.dijkstra.stream(
  'supplyGraphWeighted', 
  { sourceNode: sourceId, targetNode: targetId, relationshipWeightProperty: 'cost' }
)
YIELD totalCost, nodeIds
RETURN totalCost, [nodeId IN nodeIds | gds.util.asNode(nodeId).SKU] AS chemin;
