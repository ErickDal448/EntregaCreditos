using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Validaciones_Creditos.Models;

namespace Validaciones_Creditos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InfoEventosController : ControllerBase
    {
        [HttpGet]
        [Route("api/EventosInfo")]
        public IActionResult GetCreditos([FromQuery] int IdEvento)
        {
            using (var db = new Contexto())
            {
                var IdEventoParam = new SqlParameter("@IdEvento", IdEvento);
                var creditos = db.FiltroEventos.FromSqlRaw("EXEC InfoEventos @IdEvento", IdEventoParam).ToList();
                return Ok(creditos);
            }
        }
    }
}
