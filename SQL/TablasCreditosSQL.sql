
Create Database Creditos

Use Creditos

Create table Usuarios(
NumeroCuenta varchar(10) primary key,
Nip varchar(10),
Nombre varchar(50),
Apellidos varchar(50),
CreditosTotales decimal(10,2),
Rol varchar(20),
Institucion varchar(50),
Grado int,
Grupo int,
TopeCreditos int
)

create table TipoCertificado(
Id int identity (1,1) primary key,
Institucion varchar(50),
NombreTC varchar(150), --NombreTC = Nombre Tipo Certificado
CreditosMax decimal,
CreditosValor decimal(10,2) --Los creditos que vale el evento o certificado
)

create table Eventos(
idEvento int identity(1,1) primary key,
Nombre varchar(50),
idTipo int,
Descripcion varchar(150),
Fecha datetime,
Estado varchar(20),
Creditos decimal(10,2),
Mapa varchar(100),
Institucion varchar(50)
)

create table EventosRealizados(
idEvento int foreign key references Eventos(idEvento),
NumUsuario varchar(10) foreign key references Usuarios(NumeroCuenta),
)

create table CertificadosEnviados(
idEnvio int identity (1,1) primary key,
idTipo int foreign key references TipoCertificado(Id),
NumUsuario varchar(10) foreign key references Usuarios(NumeroCuenta),
TituloCertificado varchar(50),
Fecha datetime default Getdate(), 
Estado varchar(20),
Comentario varchar(200),
Drive varchar(100)
) 


--Datos para Usuarios
Insert into Usuarios (NumeroCuenta, Nip, Nombre, Apellidos, CreditosTotales, Rol, Institucion, Grado, Grupo, TopeCreditos)values 
('12345', '12345', 'Erick', 'Alba Leon', 26, 'Alumno', 'Licenciatura en Informática', 3, 3, 35),
('23456', '34567', 'Joshua', 'Duarte Escareño', 13, 'Alumno', 'Licenciatura en Gastronomía', 4, 2, 40),
('34567', '45678', 'Randu', 'Quintero', 0, 'Editor', 'Licenciatura en Informática', 0, 0, 35),
('45678', '56789', 'Jorge', 'Fabian Felix', 0, 'Editor', 'Licenciatura en Gastronomía', 0, 0, 40),
('56789', '56789', 'Sergio Michel','Pérez Mendoza',0,'Editor','Licenciatura en Informática',0,0, 35)

--Datos de Eventos
insert into Eventos(Nombre, idTipo, Descripcion, Fecha, Estado, Creditos, Mapa, Institucion) values 
('Conferencia de Coppel', 13, 'Se realizara una conferencia por parte de trabajadores de coppel', '2023-05-27 19:22:49.110', 'Activo', 0.2, 'link','Licenciatura en Informática'),
('Actividad deportiva', 12, 'Se realizara un torneo de futbol ', '2023-05-27 19:22:49.110', 'Activo', 0.5, 'link','Licenciatura en Informática'),
('Moderador',26,'' ,'2023-05-27 19:22:49.110', 'Finalizado', 1, 'link','Licenciatura en Gastronomía'),
('Conferencia de NAZA',13, 'Se realizara una conferencia por parte de trabajadores de la NAZA', '2023-07-27 19:22:49.110', 'Activo', 0.2, 'link','Licenciatura en Informática'),
('Conferencia de Bill',13, 'Se realizara una conferencia por parte del CEO de Microsoft', '2025-05-27 19:22:49.110', 'Terminado', 0.2, 'link','Licenciatura en Informática')


--Datos de tipo certificado solo de Informatica
Insert into TipoCertificado (Institucion, NombreTC, CreditosMax, CreditosValor) values
('Licenciatura en Informática', 'Certificación de Software de Ofimática', 5, 1),
('Licenciatura en Informática', 'Diplomado de Especialización (120 horas)', 6, 6),
('Licenciatura en Informática', 'Curso de Especialización (20 horas)', 10, 1),
('Licenciatura en Informática', 'Certificación Internacional de Competencia Técnica', 15, 3),
('Licenciatura en Informática', 'Dominio del Idioma Inglés', 20, 20),
('Licenciatura en Informática', 'Estancia Académica (50 horas)', 4, 1),
('Licenciatura en Informática', 'Estancia Académica Nacional (1 Semestre)', 5, 5),
('Licenciatura en Informática', 'Estancia Académica Internacional (1 Semestre)', 7, 7),
('Licenciatura en Informática', 'Verano de Investigación Científica (Nacional)', 5, 5),
('Licenciatura en Informática', 'Verano de Investigación Científica (Internacional)', 7, 7),
('Licenciatura en Informática', 'Estancia en la Industria (1 mes)', 5, 5),
('Licenciatura en Informática', 'Asistencia a Eventos Académicos (Congreso, Simposium, Foro, Otros)', 3, 1),
('Licenciatura en Informática', 'Asistencia a Conferencias', 3, 0.2),
('Licenciatura en Informática', 'Organización de Eventos Académicos, Culturales y/o Deportivos', 3, 1),
('Licenciatura en Informática', 'Presentación de Ponencia en Congresos', 6, 2),
('Licenciatura en Informática', 'Elaboración y defensa de Tesis', 15, 15),
('Licenciatura en Informática', 'Participación en Actividades Deportivas, Artísticas y Culturales', 2, 0.2),
('Licenciatura en Informática', 'Representación de la Institución en Competencias Deportivas y Eventos Artísticos y Culturales', 6, 2),
('Licenciatura en Informática', 'Participación y/o Representación en Autoridades Colegiadas (H. Consejo Universitario, H. Consejo Técnico, otros) (1 año)', 8, 2),
('Licenciatura en Informática', 'Publicación de Artículos Científicos', 10, 5),
('Licenciatura en Informática', 'Participación en Proyectos de Investigación (50 horas)', 10, 1)
--Para gastronomia (Solo puse algunos de aqui)
Insert into TipoCertificado (Institucion, NombreTC, CreditosMax, CreditosValor) values
('Licenciatura en Gastronomía', 'Promoción y difusión de valores mediante teatro, guiñol, canto, música, danza, pintura (por presentación)', 2, 2),
('Licenciatura en Gastronomía', 'Participar como jefe (a) de grupo (por año)', 5, 1),
('Licenciatura en Gastronomía', 'Participación en actividades de promoción sobre equidad de género (por actividad)', 2, 1),
('Licenciatura en Gastronomía', 'Participación en actividades del cuidado y  promoción del medio ambiente (por evento)', 3, 1),
('Licenciatura en Gastronomía', 'Organizador de actividades culturales', 2, 2),
('Licenciatura en Gastronomía', 'Participación en brigadas para población vulnerable', 2, 2),
('Licenciatura en Gastronomía', 'Participación en brigadas de desastres naturales', 3, 3),
('Licenciatura en Gastronomía', 'Consejero técnico o universitario (por periodo)', 15, 3)

--Eventos Realizados
insert into EventosRealizados values
(1, '12345'),
(3, '45678')

--Certificados enviados
insert into CertificadosEnviados (idTipo, NumUsuario, TituloCertificado, Estado, Comentario, Drive) values
(3, '12345','Certificado Cursos', 'Validado', 'Todo bien oiga', 'https://drive.google.com/file/d/17oL_42M0jQar6nNIZ-5pXK_Y86dJudFK/view?usp=sharing'),
(2, '12345', 'Diplomado Finanzas','Enviado', '- - -', 'https://drive.google.com/file/d/17oL_42M0jQar6nNIZ-5pXK_Y86dJudFK/view?usp=sharing')

-------------------------------------------------------
--Instrucciones que se pueden utilizar

--Varios datos tienen acento por si quieres hacer consultas individuales es necesario poner el acento si no, no aparece
--Ver datos
Select * from Usuarios where Institucion = 'Licenciatura en gastronomía'
Select * from Usuarios 
select * from EventosRealizados
Select * from Eventos
Select * from TipoCertificado
select * from CertificadosEnviados


-- PRECAUCION NO TOQUE --
-- PUCHAR CON CUIDAOH --
-- DE SER NECESARIO HAGA UNA COPIA ANTES --
--Eliminar solo datos
delete from Eventos
delete from Usuarios
delete from TipoCertificado
delete from EventosRealizados
delete from CertificadosEnviados
--Eliminar todo
drop table Usuarios
drop table Eventos
drop table TipoCertificado
drop table EventosRealizados
drop table CertificadosEnviados
 

 -- Posibles SP --
 CREATE PROCEDURE ValidarCreditosMax(IN numUsuario VARCHAR(10), IN idTipo INT)
BEGIN
  DECLARE creditosMax INT;
  DECLARE creditosUsuario INT;
  SELECT CreditosMax INTO creditosMax FROM TipoCertificado WHERE Id = idTipo;
  SELECT SUM(CreditosValor) INTO creditosUsuario FROM CertificadosEnviados
  INNER JOIN TipoCertificado ON CertificadosEnviados.idTipo = TipoCertificado.Id
  WHERE NumUsuario = numUsuario AND idTipo = idTipo;
  IF creditosUsuario >= creditosMax THEN
    SELECT 'Límite alcanzado';
  ELSE
    SELECT 'Límite no alcanzado';
  END IF;
END;

/*Este procedimiento almacenado llamado ValidarCreditosMax acepta dos parámetros: numUsuario, que es el número de cuenta del usuario, y idTipo, que es el ID del tipo de certificado.

El procedimiento almacenado primero obtiene el valor de CreditosMax para el tipo de certificado especificado. Luego, calcula la suma de los créditos obtenidos por el usuario para ese tipo de certificado utilizando una consulta SELECT con una cláusula INNER JOIN para unir las tablas CertificadosEnviados y TipoCertificado.

Finalmente, el procedimiento almacenado compara la suma de los créditos obtenidos por el usuario con el valor de CreditosMax y devuelve un mensaje indicando si el usuario ha alcanzado o no el límite máximo de créditos.

Puedes llamar a este procedimiento almacenado desde tu aplicación para validar si un usuario ha alcanzado el límite máximo de créditos antes de permitirle obtener más créditos por un evento o certificado.

Este es solo un ejemplo básico para mostrarte cómo podrías hacerlo. Deberás adaptarlo a tus necesidades específicas y asegurarte de que la lógica y las consultas sean correctas.
*/







insert into Eventos (Nombre, Tipo, Descripcion, Fecha, Estado, Creditos, Mapa, Institucion) values 
('Conferencia de Bill','conferencia', 'Se realizara una conferencia por parte del CEO de Microsoft', '2025-05-27 19:22:49.110', 'Terminado', 0.2, 'link','Licenciatura en Informática')





