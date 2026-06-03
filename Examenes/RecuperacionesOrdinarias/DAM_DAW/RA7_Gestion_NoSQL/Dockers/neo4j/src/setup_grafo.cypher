// 1. Limpieza total (ADVERTENCIA: Usar MATCH DETACH DELETE solo en entornos de laboratorio/pequeños. 
// En producción, borrar millones de nodos de golpe colgaría el servidor por desbordamiento de transacciones).
MATCH (n) DETACH DELETE n;

// 2. Creación de todo el grafo en un solo paso atómico
CREATE 
  (victor:Usuario {nombre: 'Víctor', ciudad: 'Madrid'}),
  (ana:Usuario    {nombre: 'Ana',    ciudad: 'Segovia'}),
  (juan:Usuario   {nombre: 'Juan',   ciudad: 'Madrid'}),
  (pedro:Usuario  {nombre: 'Pedro',  ciudad: 'Burgos'}),
  (sofia:Usuario  {nombre: 'Sofía',  ciudad: 'Madrid'}),
  (elena:Usuario  {nombre: 'Elena',  ciudad: 'Bilbao'}),
  (carlos:Guia {nombre: 'Carlos', especialidad: 'Historia', precio: 50}),
  (marie:Guia  {nombre: 'Marie',  especialidad: 'Arte',     precio: 60}),
  (paolo:Guia  {nombre: 'Paolo',  especialidad: 'Cocina',   precio: 40}),

  // Relaciones de Amistad
  (victor)-[:SIGUE]->(ana),
  (victor)-[:SIGUE]->(juan),
  (ana)-[:SIGUE]->(pedro),
  (juan)-[:SIGUE]->(sofia),
  (pedro)-[:SIGUE]->(elena),
  (sofia)-[:SIGUE]->(elena),

  // Relaciones de Valoración
  (ana)-[:VALORO {estrellas: 5, fecha: '2024-01-10'}]->(carlos),
  (juan)-[:VALORO {estrellas: 4, fecha: '2024-02-15'}]->(marie),
  (pedro)-[:VALORO {estrellas: 5}]->(paolo),
  (sofia)-[:VALORO {estrellas: 2}]->(carlos),
  (victor)-[:VALORO {estrellas: 3}]->(paolo);
