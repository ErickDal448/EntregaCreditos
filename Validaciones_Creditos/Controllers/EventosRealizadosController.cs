using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Validaciones_Creditos.Models;

namespace Validaciones_Creditos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventosRealizadosController : ControllerBase
    {
        [HttpGet]
        [Route("api/EventosRealizados")]
        public IActionResult GetCreditos([FromQuery] int NumUsuario)
        {
            using (var db = new Contexto())
            {
                var NumUsuarioParam = new SqlParameter("@NumUsuario", NumUsuario);
                var creditos = db.FiltroEventos.FromSqlRaw("EXEC EventosRealizadosFiltro @NumUsuario", NumUsuarioParam).ToList();
                return Ok(creditos);
            }
        }
    }
}
