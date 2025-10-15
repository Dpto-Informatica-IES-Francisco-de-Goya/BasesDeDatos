# Sin título

# 🧩 Práctica: SOLO INNER JOIN (construir el resultado a mano)

## Tablas base

### `alumnos`

| id_alumno | nombre |
| --- | --- |
| 1 | Ana |
| 2 | Bruno |
| 3 | Cris |
| 4 | Dani |
| 5 | Eva |

### `cursos`

| id_curso | nombre_curso |
| --- | --- |
| 101 | BBDD |
| 102 | Programación |
| 103 | Sistemas |
| 104 | Redes |

### `matriculas`

| id_matricula | id_alumno | id_curso |
| --- | --- | --- |
| 1001 | 1 | 101 |
| 1002 | 1 | 102 |
| 1003 | 3 | 101 |
| 1004 | 6 | 103 |
| 1005 | 4 | 105 |

> Consigna: en cada ejercicio dibuja manualmente la tabla resultado.
> 
> 
> Tratamos como distintos **A JOIN B** y **B JOIN A** (cambian las columnas).
> 

---

## Ejercicios (todos INNER JOIN)

### 1) `alumnos` JOIN `matriculas` (A ⋈ M)

```jsx
SELECT a.id_alumno, a.nombre, m.id_matricula, m.id_curso
FROM alumnos a
INNER JOIN matriculas m ON a.id_alumno = m.id_alumno;
```

### 2) matriculas JOIN alumnos (M ⋈ A)

```jsx
SELECT m.id_matricula, m.id_alumno, a.nombre
FROM matriculas m
INNER JOIN alumnos a ON m.id_alumno = a.id_alumno;
```

### 3) cursos JOIN matriculas (C ⋈ M)

```jsx
SELECT c.id_curso, c.nombre_curso, m.id_matricula, m.id_alumno
FROM cursos c
INNER JOIN matriculas m ON c.id_curso = m.id_curso;
```

### 4) matriculas JOIN cursos (M ⋈ C)

```jsx
SELECT m.id_matricula, m.id_curso, c.nombre_curso
FROM matriculas m
INNER JOIN cursos c ON m.id_curso = c.id_curso;
```

### 5) alumnos JOIN matriculas (A ⋈ M) — proyección distinta

```jsx
SELECT a.nombre, m.id_curso
FROM alumnos a
INNER JOIN matriculas m ON a.id_alumno = m.id_alumno;
```

### 6) matriculas JOIN alumnos (M ⋈ A) — proyección distinta

```jsx
SELECT m.id_matricula, a.id_alumno, a.nombre
FROM matriculas m
INNER JOIN alumnos a ON m.id_alumno = a.id_alumno;
```

### 7) cursos JOIN matriculas (C ⋈ M) — filtrando cursos

```jsx
SELECT c.id_curso, c.nombre_curso, m.id_matricula
FROM cursos c
INNER JOIN matriculas m ON c.id_curso = m.id_curso
WHERE c.id_curso IN (101,102);
```

### 8) matriculas JOIN cursos (M ⋈ C) — filtrando matrículas

```jsx
SELECT m.id_matricula, m.id_curso, c.nombre_curso
FROM matriculas m
INNER JOIN cursos c ON m.id_curso = c.id_curso
WHERE m.id_curso <> 105;
```

### 9) JOIN “doble” (3 tablas) — alumnos ⋈ matriculas ⋈ cursos

```jsx
SELECT a.nombre AS alumno, c.nombre_curso AS curso, m.id_matricula
FROM alumnos a
INNER JOIN matriculas m ON a.id_alumno = m.id_alumno
INNER JOIN cursos c ON c.id_curso = m.id_curso;
```

### 10) JOIN “doble” (3 tablas) — cursos ⋈ matriculas ⋈ alumnos

```jsx
SELECT c.id_curso, c.nombre_curso, a.nombre AS alumno
FROM cursos c
INNER JOIN matriculas m ON c.id_curso = m.id_curso
INNER JOIN alumnos a ON a.id_alumno = m.id_alumno;
```