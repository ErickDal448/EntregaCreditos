--// Procedimientos Almacenados de Creditos //-- 

-- Validar Alumno/Editor
create PROCEDURE ValidarUsuario
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
create PROCEDURE sp_ActualizarCreditosTotales
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
create procedure TotalCreditos 
	@numeroCuenta varchar(20)
AS
BEGIN
	select NumeroCuenta, CreditosTotales, TopeCreditos from Usuarios 
	where NumeroCuenta = @numeroCuenta;
END

							--Filtrar Eventos --
							-- Eventos Pasados --
							alter procedure EventosPasados 
								@institucion varchar(50)
							AS 
							Begin 
								SELECT E.*, TC.NombreTC
								FROM Eventos E
								JOIN TipoCertificado TC
								ON E.idTipo = TC.Id
								where Fecha < GETDATE()
								and E.Institucion = @institucion
								ORDER BY Fecha DESC;
							END

							--Eventos Proximos --
							alter procedure EventosProximos
								@institucion varchar(50)
							AS 
							Begin 
								SELECT E.*, TC.NombreTC
								FROM Eventos E
								JOIN TipoCertificado TC
								ON E.idTipo = TC.Id
								where Fecha >= GETDATE()
								and E.Institucion = @institucion
								ORDER BY Fecha ASC;
							END

							-- Eventos realizados --
							alter procedure EventosRealizadosFiltro
								@numUsuario varchar(10)
							as 
							begin
								SELECT E.*, TC.NombreTC
								FROM Eventos E
								JOIN TipoCertificado TC ON E.idTipo = TC.Id
								JOIN EventosRealizados ER ON E.idEvento = ER.idEvento
								WHERE ER.NumUsuario = @NumUsuario
								ORDER BY Fecha DESC;
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
create procedure CertificadosInfo
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
							ORDER BY Fecha DESC;
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
							ORDER BY Fecha DESC;
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
							ORDER BY Fecha ASC;
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
							ORDER BY Fecha DESC;
						END


-- Medallas --
-- Creditos por medalla --
create PROCEDURE sp_CreditosPorTipoCertificado
    @NumeroCuenta varchar(10)
AS
BEGIN
    -- Calcular los créditos obtenidos por los eventos realizados
    ;WITH CreditosEventos AS (
        SELECT E.idTipo, SUM(E.Creditos) AS Creditos
        FROM EventosRealizados ER
        JOIN Eventos E ON ER.idEvento = E.idEvento
        WHERE ER.NumUsuario = @NumeroCuenta
        GROUP BY E.idTipo
    ),
    -- Calcular los créditos obtenidos por los certificados enviados
    CreditosCertificados AS (
        SELECT TC.Id, SUM(CE.Creditos) AS Creditos
        FROM CertificadosEnviados CE
        JOIN TipoCertificado TC ON CE.idTipo = TC.Id
        WHERE CE.NumUsuario = @NumeroCuenta AND CE.Estado = 'Aceptado'
        GROUP BY TC.Id
    )
    -- Calcular los créditos totales por tipo de certificado
    SELECT @NumeroCuenta AS NumeroCuenta,
           TC.Id AS IdTipoCertificado,
           TC.NombreTC AS NombreTipoCertificado,
           ISNULL(CE.Creditos, 0) + ISNULL(CC.Creditos, 0) AS CreditosTotales,
           TC.CreditosMax AS TopeCreditos
    FROM TipoCertificado TC
    LEFT JOIN CreditosEventos CE ON TC.Id = CE.idTipo
    LEFT JOIN CreditosCertificados CC ON TC.Id = CC.Id
	WHERE ISNULL(CE.Creditos, 0) + ISNULL(CC.Creditos, 0) > 0;
END;


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

exec sp_CreditosPorTipoCertificado @NumeroCuenta = '12345'

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