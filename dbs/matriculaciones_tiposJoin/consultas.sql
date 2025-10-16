use ejemplos_tipos_join;



SELECT a.id_alumno, a.nombre, m.id_matricula, m.id_curso
FROM alumnos a
INNER JOIN matriculas m ON a.id_alumno = m.id_alumno;


SELECT m.id_matricula, m.id_alumno, a.nombre
FROM matriculas m
INNER JOIN alumnos a ON m.id_alumno = a.id_alumno;


SELECT c.id_curso, c.nombre_curso, m.id_matricula, m.id_alumno
FROM cursos c
INNER JOIN matriculas m ON c.id_curso = m.id_curso;


SELECT m.id_matricula, m.id_curso, c.nombre_curso
FROM matriculas m
INNER JOIN cursos c ON m.id_curso = c.id_curso;


SELECT a.nombre, m.id_curso
FROM alumnos a
INNER JOIN matriculas m ON a.id_alumno = m.id_alumno;


SELECT m.id_matricula, a.id_alumno, a.nombre
FROM matriculas m
INNER JOIN alumnos a ON m.id_alumno = a.id_alumno;


SELECT c.id_curso, c.nombre_curso, m.id_matricula
FROM cursos c
INNER JOIN matriculas m ON c.id_curso = m.id_curso
WHERE c.id_curso IN (101,102);


SELECT m.id_matricula, m.id_curso, c.nombre_curso
FROM matriculas m
INNER JOIN cursos c ON m.id_curso = c.id_curso
WHERE m.id_curso <> 105;


SELECT a.nombre AS alumno, c.nombre_curso AS curso, m.id_matricula
FROM alumnos a
INNER JOIN matriculas m ON a.id_alumno = m.id_alumno
INNER JOIN cursos c ON c.id_curso = m.id_curso;


SELECT c.id_curso, c.nombre_curso, a.nombre AS alumno
FROM cursos c
INNER JOIN matriculas m ON c.id_curso = m.id_curso
INNER JOIN alumnos a ON a.id_alumno = m.id_alumno;
