--// Procedimientos Almacenados de Creditos //-- 

-- Validar Alumno/Editor
create PROCEDURE ValidarUsuario
    @numCuenta INT,
    @nip INT
AS
BEGIN
    SELECT NumeroCuenta, Nip, Nombre, Apellidos, Institucion, Rol FROM Usuarios WHERE NumeroCuenta = @numCuenta AND Nip = @nip
END


-- Ver Tabla de Creditos
create Procedure TablaCreditos
	@institucion varchar(50)
as 
Begin
	select * from TipoCertificado 
	Where Institucion = @institucion;
END

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
alter procedure EventosRealizadosFiltro
	@numUsuario int
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
-- Certificados Enviados --
Create procedure CertificadosEnviadosFiltro 
	@numUsuario int
as 
begin
	select * from CertificadosEnviados
	where Estado = 'Enviado'
	and NumUsuario = @numUsuario
end

-- Certificados Revisados --
Create procedure CertificadosRevisados 
	@numUsuario int
as 
begin
	select * from CertificadosEnviados
	where (Estado = 'Validado' or Estado = 'NO Validado')
	and NumUsuario = @numUsuario
end

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

Exec TablaCreditos @institucion= 'Licenciatura en Gastronomía'
Exec TablaCreditos @institucion= 'Licenciatura en Informática'

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

exec CertificadosEnviadosFiltro @numUsuario = '12345'

exec CertificadosRevisados @numUsuario = '12345'

exec CreditosPorTipo @numUsuario = '12345'

-- Vistas de tablas --
select * from Usuarios 
select * from TipoCertificado
select * from Eventos
select * from EventosRealizados
select * from TipoCertificado
select * from CertificadosEnviados

insert into CertificadosEnviados (idTipo, NumUsuario, TituloCertificado, Estado, Comentario, Drive) values
(2, '12345', 'Diplomado Finanzas','Enviado', '- - -', 'https://drive.google.com/file/d/17oL_42M0jQar6nNIZ-5pXK_Y86dJudFK/view?usp=sharing')