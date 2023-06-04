--// Procedimientos Almacenados de Creditos //-- 

-- Validar Alumno/Editor
alter PROCEDURE ValidarUsuario
    @numCuenta varchar(10),
    @nip varchar(10)
AS
BEGIN
    SELECT NumeroCuenta, Nip, Nombre, Apellidos, Institucion, Rol FROM Usuarios WHERE NumeroCuenta = @numCuenta AND Nip = @nip
END
-- Identificar alumnos por grado, grupo e institucion -- 
create PROCEDURE MostrarAlumnosGradoGrupo @Grado int, @Grupo int, @Institucion varchar(50)
AS
BEGIN
    SELECT Grado, Grupo, Nombre, Apellidos, NumeroCuenta
    FROM Usuarios
    WHERE Grado = @Grado AND Grupo = @Grupo AND Institucion = @Institucion
    ORDER BY Grado, Grupo;
END;

-- Mostrar todos los grados --
CREATE PROCEDURE MostrarGradosPorInstitucion @Institucion varchar(50)
AS
BEGIN
    SELECT DISTINCT Grado
    FROM Usuarios
    WHERE Institucion = @Institucion AND Grado <> 0
    ORDER BY Grado;
END;

--Mostrar todos los grupos --
CREATE PROCEDURE MostrarGruposPorInstitucion @Institucion varchar(50)
AS
BEGIN
    SELECT DISTINCT Grupo
    FROM Usuarios
    WHERE Institucion = @Institucion AND Grupo <> 0
    ORDER BY Grupo;
END;


-- Ver Tabla de Creditos
create Procedure TablaCreditos
	@institucion varchar(50)
as 
Begin
	select * from TipoCertificado 
	Where Institucion = @institucion;
END

-- Calcular el total de creditos del alumno --
alter PROCEDURE sp_ActualizarCreditosTotales
    @NumeroCuenta varchar(10)
AS
BEGIN
    DECLARE @CreditosTotales decimal(10,2);
    DECLARE @CreditosCertificados decimal(10,2);
    
    -- Calcular la suma de los créditos obtenidos por los eventos realizados
    SELECT @CreditosTotales = SUM(Creditos)
    FROM EventosRealizados ER
    JOIN Eventos E ON ER.idEvento = E.idEvento
    WHERE ER.NumUsuario = @NumeroCuenta;
    
    -- Calcular la suma de los créditos obtenidos por los certificados enviados
    SELECT @CreditosCertificados = SUM(Creditos)
    FROM CertificadosEnviados
    WHERE NumUsuario = @NumeroCuenta;
    
    -- Sumar los créditos obtenidos por los certificados enviados si no son NULL
    IF @CreditosCertificados IS NOT NULL
        SET @CreditosTotales = @CreditosTotales + @CreditosCertificados;
    
    -- Establecer el valor de los créditos totales en 0 si es NULL
    IF @CreditosTotales IS NULL
        SET @CreditosTotales = 0;
    
    -- Actualizar el valor de los créditos totales en la tabla de Usuarios
    UPDATE Usuarios
    SET CreditosTotales = @CreditosTotales
    WHERE NumeroCuenta = @NumeroCuenta;
END;



-- Ver el total de creditos del alumno --
alter procedure TotalCreditos 
	@numeroCuenta varchar(20)
AS
BEGIN
	select NumeroCuenta, CreditosTotales, TopeCreditos from Usuarios 
	where NumeroCuenta = @numeroCuenta;
END

--Filtrar Eventos --
-- Eventos Pasados --
create procedure EventosPasados 
	@institucion varchar(50)
AS 
Begin 
	SELECT E.*, TC.NombreTC
    FROM Eventos E
    JOIN TipoCertificado TC
    ON E.idTipo = TC.Id
	where Fecha < GETDATE()
	and E.Institucion = @institucion;
END

--Eventos Proximos --
Create procedure EventosProximos
	@institucion varchar(50)
AS 
Begin 
	SELECT E.*, TC.NombreTC
    FROM Eventos E
    JOIN TipoCertificado TC
    ON E.idTipo = TC.Id
	where Fecha >= GETDATE()
	and E.Institucion = @institucion;
END

-- Eventos realizados --
create procedure EventosRealizadosFiltro
	@numUsuario varchar(10)
as 
begin
	SELECT E.*, TC.NombreTC
    FROM Eventos E
    JOIN TipoCertificado TC ON E.idTipo = TC.Id
    JOIN EventosRealizados ER ON E.idEvento = ER.idEvento
    WHERE ER.NumUsuario = @NumUsuario;
END

--Informacion de eventos --
create procedure InfoEventos 
	@IdEvento int
as
begin
	SELECT E.*, TC.NombreTC
    FROM Eventos E
    JOIN TipoCertificado TC
    ON E.idTipo = TC.Id
	where IdEvento = @IdEvento;
END

-- Certificados Filtros -- 
-- Certificados Info --
alter procedure CertificadosInfo
	@idEnvio int
as 
begin
	select CE.*, TC.NombreTC, U.Nombre, U.Apellidos
	from CertificadosEnviados CE
	JOIN TipoCertificado TC
	ON CE.idTipo = TC.Id
	join Usuarios U
	ON CE.NumUsuario = U.NumeroCuenta
	where CE.idEnvio = @idEnvio
end

-- Certificados Enviados (Usuarios) --
alter procedure CertificadosEnviadosFiltro 
	@numUsuario varchar(10)
as 
begin
	select CE.*, TC.NombreTC, U.Nombre, U.Apellidos
	from CertificadosEnviados CE
	JOIN TipoCertificado TC
	ON CE.idTipo = TC.Id
	join Usuarios U
	ON CE.NumUsuario = U.NumeroCuenta
	where CE.Estado = 'Pendiente'
	and CE.NumUsuario = @numUsuario
end

-- Certificados Revisados (Usuarios) --
alter PROCEDURE CertificadosRevisados 
    @numUsuario varchar(10)
AS 
BEGIN
    SELECT CE.*, TC.NombreTC, U.Nombre, U.Apellidos
    FROM CertificadosEnviados CE
    JOIN TipoCertificado TC
    ON CE.idTipo = TC.Id
	join Usuarios U
	ON CE.NumUsuario = U.NumeroCuenta
    WHERE (CE.Estado = 'Aceptado' OR CE.Estado = 'Rechazado')
    AND CE.NumUsuario = @numUsuario
END

-- Certificados Por Revisar (Editor) -- 
alter procedure CertificadosPorRevisar 
	@institucion varchar(50)
AS 
BEGIN
    SELECT CE.*, TC.NombreTC, U.Nombre, U.Apellidos
    FROM CertificadosEnviados CE
    JOIN TipoCertificado TC
    ON CE.idTipo = TC.Id
	join Usuarios U
	ON CE.NumUsuario = U.NumeroCuenta
    WHERE CE.Estado = 'Pendiente'
    AND TC.Institucion = @institucion
END

-- Certificados Revisados (Editor) --
alter procedure CertificadosRevisadosEditor
	@institucion varchar(50)
AS 
BEGIN
    SELECT CE.*, TC.NombreTC, U.Nombre, U.Apellidos
    FROM CertificadosEnviados CE
    JOIN TipoCertificado TC
    ON CE.idTipo = TC.Id
	join Usuarios U
	ON CE.NumUsuario = U.NumeroCuenta
    WHERE (CE.Estado = 'Aceptado' OR CE.Estado = 'Rechazado')
    AND TC.Institucion = @institucion
END


-- Medallas --
-- Creditos por medalla --
create procedure CreditosPorTipo
	@numUsuario varchar(20)
As 
begin
	SELECT Usuarios.NumeroCuenta, Usuarios.Nombre, TipoCertificado.NombreTC, SUM(TipoCertificado.CreditosValor) AS Creditos
	FROM CertificadosEnviados
	INNER JOIN TipoCertificado ON CertificadosEnviados.idTipo = TipoCertificado.Id
	INNER JOIN Usuarios ON CertificadosEnviados.NumUsuario = Usuarios.NumeroCuenta
	where Usuarios.NumeroCuenta = @numUsuario
	GROUP BY Usuarios.NumeroCuenta, Usuarios.Nombre, TipoCertificado.NombreTC;
end

-- Pruebas de SP --
Exec ValidarUsuario @numCuenta = '12345', @nip = '12345'

Exec MostrarGradosPorInstitucion @institucion= 'Licenciatura en Gastronomía'
Exec MostrarGradosPorInstitucion @institucion= 'Licenciatura en Informática'

Exec MostrarGruposPorInstitucion @institucion= 'Licenciatura en Gastronomía'
Exec MostrarGruposPorInstitucion @institucion= 'Licenciatura en Informática' 

exec MostrarAlumnosGradoGrupo @Grado= 3,  @Grupo=3 , @Institucion= 'Licenciatura en Informática'  
exec MostrarAlumnosGradoGrupo @Grado= 3,  @Grupo=3 , @Institucion= 'Licenciatura en Informática'  
exec MostrarAlumnosGradoGrupo @Grado= 4,  @Grupo=4 , @Institucion= 'Licenciatura en Gastronomía'
exec MostrarAlumnosGradoGrupo @Grado= 4,  @Grupo=2 , @Institucion= 'Licenciatura en Gastronomía'

Exec TablaCreditos @institucion= 'Licenciatura en Gastronomía'
Exec TablaCreditos @institucion= 'Licenciatura en Informática'

exec sp_ActualizarCreditosTotales @NumeroCuenta = '23456'

Exec TotalCreditos @numeroCuenta = '12345'
Exec TotalCreditos @numeroCuenta = '23456'
Exec TotalCreditos @numeroCuenta = '34567'
Exec TotalCreditos @numeroCuenta = '45678'

Exec EventosPasados @institucion ='Licenciatura en Informática'
Exec EventosPasados @institucion ='Licenciatura en Gastronomía'

exec EventosProximos @institucion ='Licenciatura en Informática'
exec EventosProximos @institucion ='Licenciatura en Gastronomía'

exec EventosRealizadosFiltro @numUsuario = '12345'
exec EventosRealizadosFiltro @numUsuario = '45678'

exec CertificadosInfo @idEnvio = 3

exec CertificadosEnviadosFiltro @numUsuario = '12345'

exec CertificadosRevisados @numUsuario = '12345'

exec CreditosPorTipo @numUsuario = '12345'

exec CertificadosPorRevisar @institucion = 'Licenciatura en Informática'

exec CertificadosRevisadosEditor @institucion = 'Licenciatura en Informática'

-- Vistas de tablas --
select * from Usuarios 
select * from TipoCertificado
select * from Eventos
select * from EventosRealizados
select * from TipoCertificado
select * from CertificadosEnviados

insert into CertificadosEnviados (idTipo, NumUsuario, TituloCertificado, Estado, Comentario, Drive) values
(2, '12345', 'Diplomado Finanzas','Enviado', '- - -', 'https://drive.google.com/file/d/17oL_42M0jQar6nNIZ-5pXK_Y86dJudFK/view?usp=sharing')