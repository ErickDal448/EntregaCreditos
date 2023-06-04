using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Validaciones_Creditos.Models;

namespace Validaciones_Creditos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CertificadosController : ControllerBase
    {
        private readonly Contexto _context;

        public CertificadosController(Contexto context)
        {
            _context = context;
        }

        [HttpGet]
        [Route("CertificadosEnviados")]
        public IActionResult GetCertificadosEnviados([FromQuery] string NumeroCuenta)
        {
            using (var db = new Contexto())
            {
                var NumeroCuentaParam = new SqlParameter("@numUsuario", NumeroCuenta);
                var certificados = db.CertificadosFiltros.FromSqlRaw("EXEC CertificadosEnviadosFiltro @numUsuario", NumeroCuentaParam).ToList();
                return Ok(certificados);
            }
        }

        [HttpGet]
        [Route("CertificadosRevisados")]
        public IActionResult GetCertificadosRevizados([FromQuery] string NumeroCuenta)
        {
            using (var db = new Contexto())
            {
                var NumeroCuentaParam = new SqlParameter("@numUsuario", NumeroCuenta);
                var certificados = db.CertificadosFiltros.FromSqlRaw("EXEC CertificadosRevisados @numUsuario", NumeroCuentaParam).ToList();
                return Ok(certificados);
            }
        }

        [HttpGet]
        [Route("CertificadosInfo")]
        public IActionResult GetCertificadosInfo([FromQuery] int idEvento)
        {
            using (var db = new Contexto())
            {
                var idEventoParam = new SqlParameter("@numUsuario", idEvento);
                var certificados = db.CertificadosFiltros.FromSqlRaw("EXEC CertificadosInfo @numUsuario", idEventoParam).ToList();
                return Ok(certificados);
            }
        }

        [HttpGet]
        [Route("CertificadosPorRevisar")]
        public IActionResult GetCertificadosPorRevisar([FromQuery] string Institucion)
        {
            using (var db = new Contexto())
            {
                var institucionParam = new SqlParameter("@institucion", Institucion);
                var certificados = db.CertificadosFiltros.FromSqlRaw("EXEC CertificadosPorRevisar @institucion", institucionParam).ToList();
                return Ok(certificados);
            }
        }

        [HttpGet]
        [Route("CertificadosYaRevisados")]
        public IActionResult GetCertificadosYaRevisados([FromQuery] string Institucion)
        {
            using (var db = new Contexto())
            {
                var institucionParam = new SqlParameter("@institucion", Institucion);
                var certificados = db.CertificadosFiltros.FromSqlRaw("EXEC CertificadosRevisadosEditor @institucion", institucionParam).ToList();
                return Ok(certificados);
            }
        }

        [HttpPost]
        [Route("EnviarCertificado")]
        public async Task<ActionResult<CertificadosEnviado>> PostCertificadoEnviado(CertificadosEnviado certificadoEnviado)
        {
            // Agregar el objeto certificadoEnviado a la base de datos
            _context.CertificadosEnviados.Add(certificadoEnviado);
            await _context.SaveChangesAsync();

            // Devolver una respuesta 201 Created con la información del objeto creado
            return CreatedAtAction(nameof(GetCertificadosInfo), new { id = certificadoEnviado.IdEnvio }, certificadoEnviado);
        }

        [HttpPut]
        [Route("ActualizarCertificadoUsuario")]
        public async Task<IActionResult> PutCertificadoUsuario(int idEnvio, CertificadosEnviado certificadoEnviado)
        {
            // Obtener el objeto CertificadosEnviado de la base de datos
            var certificadoEnviadoDb = await _context.CertificadosEnviados.FindAsync(idEnvio);

            if (certificadoEnviadoDb == null)
            {
                return NotFound();
            }

            // Actualizar solo los campos estado y comentario
            certificadoEnviadoDb.TituloCertificado = certificadoEnviado.TituloCertificado;
            certificadoEnviadoDb.IdTipo = certificadoEnviado.IdTipo;
            certificadoEnviadoDb.Drive = certificadoEnviado.Drive;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CertificadoEnviadoExists(idEnvio))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpPut]
        [Route("ActualizarCertificadoEnviado")]
        public async Task<IActionResult> PutCertificadoEnviado(int idEnvio, CertificadosEnviado certificadoEnviado)
        {
            // Obtener el objeto CertificadosEnviado de la base de datos
            var certificadoEnviadoDb = await _context.CertificadosEnviados.FindAsync(idEnvio);

            if (certificadoEnviadoDb == null)
            {
                return NotFound();
            }

            // Actualizar solo los campos estado y comentario
            certificadoEnviadoDb.Estado = certificadoEnviado.Estado;
            certificadoEnviadoDb.Comentario = certificadoEnviado.Comentario;

            //Dar valor al certificado segun el estado
            // Si el estado es "Aceptado", actualizar el valor de los créditos
            if (certificadoEnviado.Estado == "Aceptado")
            {
                // Obtener el valor de los créditos según el idTipo
                var tipoCertificado = await _context.TipoCertificados.FindAsync(certificadoEnviadoDb.IdTipo);
                if (tipoCertificado != null)
                {
                    certificadoEnviadoDb.Creditos = tipoCertificado.CreditosValor;
                }
            }
            if(certificadoEnviado.Estado == "Rechazado")
            {
                certificadoEnviadoDb.Creditos = 0;
            }

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CertificadoEnviadoExists(idEnvio))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        private bool CertificadoEnviadoExists(int id)
        {
            return _context.CertificadosEnviados.Any(e => e.IdEnvio == id);
        }

    }
}
