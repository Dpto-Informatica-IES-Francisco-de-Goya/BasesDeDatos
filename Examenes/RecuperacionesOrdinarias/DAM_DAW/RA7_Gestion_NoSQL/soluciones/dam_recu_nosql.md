# Soluciones Recuperación RA7 NoSQL (DAM/DAW)

## T.1 — Bloque Teórico (2 pts)

**Respuesta esperada:**  
MongoDB permite que cada documento dentro de una colección tenga una estructura diferente (_schema-less_). Un documento de cliente particular puede incluir únicamente `dni`, mientras que uno de empresa incluye `cif`, `nombre_fiscal` y `num_empleados`, sin que ninguno tenga columnas `NULL` ni haya que crear tablas extra.

En el modelo relacional habría que elegir entre: (a) una tabla única con muchas columnas `NULL`, o (b) una tabla padre + tablas especializadas con JOINs. Ambas opciones añaden complejidad de diseño y de consulta.

La ventaja documental es que el modelo de datos se adapta al objeto de negocio sin imponer estructura fija, lo que es especialmente útil cuando los tipos de entidad son heterogéneos o evolucionan con el tiempo.

---

## P.R1 — Redis: Control de Sesiones y Contadores (2,5 pts)

```bash
# Crear token con expiración de 30 minutos (1800 segundos)
SET sesion:token:XYZ "user_id:101" EX 1800

# Incrementar contador de sesiones de forma atómica
INCR stats:sesiones

# Consultar segundos restantes del token
TTL sesion:token:XYZ
```

---

## P.M1 — MongoDB: Operaciones CRUD (3 pts)

### a) insertOne (1 pt)

```javascript
db.experiencias.insertOne({
  nombre: "Cata de vinos",
  tipo: "Gastronomia",
  precio: 45,
  tags: ["romantico", "adultos"]
})
```

### b) find con $exists y proyección (1 pt)

```javascript
db.experiencias.find(
  { detalles: { $exists: true } },
  { nombre: 1, precio: 1, _id: 0 }
)
```

### c) updateOne con $push (1 pt)

```javascript
db.experiencias.updateOne(
  { nombre: "Cata de vinos" },
  { $push: { tags: "maridaje" } }
)
```

---

## P.N1 — Neo4j: Consulta de Grafo (2,5 pts)

```cypher
MATCH (victor:Usuario {nombre: 'Víctor'})-[:SIGUE]->(amigo)-[v:VALORO]->(g:Guia)
WHERE v.estrellas = 4
  AND NOT (victor)-[:VALORO]->(g)
RETURN DISTINCT g.nombre
```

**Explicación:**  
El patrón busca guías valorados con 4 estrellas por personas a las que Víctor sigue. La cláusula `AND NOT` excluye los guías que el propio Víctor ya ha valorado. `DISTINCT` evita duplicados si varios amigos han valorado al mismo guía con 4 estrellas.
