-- Active: 1721019939146@@127.0.0.1@5432@desafio3_matias_albina_558
CREATE DATABASE desafio3_matias_albina_558;

CREATE TABLE usuarios(
    id SERIAL PRIMARY KEY ,
    email VARCHAR ,
    nombre VARCHAR ,
    apellido VARCHAR ,
    rol VARCHAR CHECK (rol IN ('administrador' , 'usuario'))
);


INSERT INTO usuarios (email , nombre , apellido , rol) VALUES
('carlos1534@gmail.com' , 'carlos' , 'hernandez' , 'usuario') ,
('pamela1995@gmail.com' , 'pamela' , 'gonzalez' , 'usuario') ,
('matias1994@gmail.com' , 'matias' , 'enriquez' , 'administrador') ,
('camilo@gmail.com' , 'camilo' , 'perez' , 'usuario') ,
('camila@gmail.com' , 'camila' , 'toro' , 'administrador');

SELECT *FROM usuarios;

CREATE TABLE post(
    id SERIAL PRIMARY KEY ,
    titulo VARCHAR ,
    contenido text ,
    fecha_creacion TIMESTAMP ,
    fecha_actualizado TIMESTAMP ,
    destacado BOOLEAN ,
    usuario_id BIGINT
);

INSERT INTO post (titulo , contenido , fecha_creacion , fecha_actualizado , destacado ,  usuario_id) VALUES
(
'como crear un perfil en Linkedin' , 
'paso1 -debes registrarte , paso2 - debes llenar con tus datos', 
'2024-02-01' , '2024-03-03' , true , 
3
) ,
(
'tutorial para crear un  curriculum' , 
'primero debes ordenar las ideas y escribir', 
'2024-02-02' , '2024-03-04' , 
false , 
3
) ,
(
'como estar saludable' , 
'para estar saludable hay que hacer ejercicio constantemente, luego buscar alimentos saludables' , 
'2024-03-03' , '2024-04-04' , 
true , 
1
) ,
(
'como cuidar a tu mascota' , 
'debes darle mucho amor, debes comprarle juguetes, debes sacarlo a pasear constantemente' , 
'2024-04-01' , '2024-05-04' , 
false , 
2
) ,
(
'como andar en bicicleta' , 
'paso numero uno hay que tener una bicicleta, despues debes subirte y pedalear' , 
'2024-06-04' , 
'2024-07-05' , 
true , 
null
);

SELECT * FROM post;

CREATE TABLE comentarios(
    id SERIAL PRIMARY KEY ,
    contenido varchar ,
    fecha_creacion TIMESTAMP ,
    usuario_id BIGINT ,
    post_id BIGINT
);

INSERT into comentarios (contenido , fecha_creacion , usuario_id , post_id) VALUES
(
'hola como estas , yo muy bien y tu' , 
'2024-01-01' ,
1 , 
1 
) ,
(
'tengo muchas dudas sobre su forma de actuar' , 
'2024-01-02' ,
2 , 
1 
) ,
(
'logramos resolver todas las dudas, muchas gracias' , 
'2024-01-04' ,
3 , 
1 
) ,
(
'para la proxima yo invito' , 
'2024-01-05' ,
1 , 
2 
) ,
(
'la comida estaba horrible, no vengo mas a este restaurant' , 
'2024-01-06' ,
2 , 
2 
);

SELECT * FROM comentarios;

-- ejercicio 2
SELECT u.nombre, u.email , p.titulo , p.contenido
FROM usuarios AS u
INNER JOIN post AS p ON p.usuario_id = u.id;

-- ejercicio 3
SELECT p.id, p.titulo, p.contenido
FROM post AS P
LEFT JOIN usuarios AS u ON u.id = p.usuario_id
WHERE u.rol = 'administrador';

-- ejercicio 4
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios AS u
LEFT JOIN post AS p ON u.id = p.usuario_id
GROUP BY u.id;

-- ejercicio 5
SELECT  u.email
FROM usuarios AS u
INNER JOIN (
    SELECT p.usuario_id, COUNT(p.id) AS cantidad_posts
    FROM post As p
    GROUP BY p.usuario_id
) AS post_counts ON u.id = post_counts.usuario_id
ORDER BY post_counts.cantidad_posts DESC
LIMIT 1;

-- ejercicio 6
SELECT u.nombre, MAX(p.fecha_creacion) AS ultima_fecha
FROM usuarios AS u
LEFT JOIN post AS p ON u.id = p.usuario_id
GROUP BY u.id, u.nombre
ORDER BY ultima_fecha DESC;

-- ejercicio 7
SELECT p.titulo , p.contenido
FROM post AS p
INNER JOIN (
    SELECT c.post_id , COUNT(c.id) AS cantidad_comentarios
    FROM comentarios AS c
    GROUP BY c.post_id
) AS total_comentarios
ON total_comentarios.post_id = p.id
ORDER BY total_comentarios.cantidad_comentarios DESC LIMIT 1;

-- ejercicio 8
SELECT p.titulo , p.contenido , c.contenido , u.email
FROM post AS p
INNER JOIN comentarios AS c ON c.post_id = p.id
INNER JOIN usuarios AS u ON u.id = c.usuario_id;

-- ejercicio 9
SELECT u.nombre, c.contenido
FROM usuarios AS u
LEFT JOIN (
    SELECT c1.usuario_id, c1.contenido, c1.fecha_creacion
    FROM comentarios AS c1
    JOIN (
        SELECT usuario_id, MAX(fecha_creacion) AS ultima_fecha
        FROM comentarios
        GROUP BY usuario_id
    ) AS c2 ON c1.usuario_id = c2.usuario_id AND c1.fecha_creacion = c2.ultima_fecha
) AS c ON u.id = c.usuario_id;

-- ejercicio 10
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios AS u
LEFT JOIN post AS p ON u.id = p.usuario_id
GROUP BY u.id, u.email
HAVING COUNT(p.id) = 0;

