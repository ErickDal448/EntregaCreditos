using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Validaciones_Creditos.Models;

namespace Validaciones_Creditos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CreditosTotalesController : ControllerBase
    {
        [HttpGet]
        [Route("api/CreditosTotales")]
        public IActionResult GetCreditos([FromQuery] string numCuenta)
        {
            using (var db = new Contexto())
            {
                var CuentaParam = new SqlParameter("@numeroCuenta", numCuenta);
                var creditos = db.TotalCreditosUsuarios.FromSqlRaw("EXEC TotalCreditos @numeroCuenta", CuentaParam).ToList();
                return Ok(creditos);
            }
        }
    }
}
