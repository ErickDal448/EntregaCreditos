using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Validaciones_Creditos.Models;

namespace Validaciones_Creditos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TablaCreditosController : ControllerBase
    {
        [HttpGet]
        [Route("api/TablaCertificados")]
        public IActionResult GetCreditos([FromQuery] string institucion)
        {
            using (var db = new Contexto())
            {
                var institucionParam = new SqlParameter("@institucion", institucion);
                var creditos = db.TablaCreditos.FromSqlRaw("EXEC TablaCreditos @institucion", institucionParam).ToList();
                return Ok(creditos);
            }
        }
    }
}
