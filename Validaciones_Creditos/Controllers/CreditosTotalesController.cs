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

        [HttpPut("actualizarCreditosTotales/{numeroCuenta}")]
        public IActionResult ActualizarCreditosTotales(string numeroCuenta)
        {
            using (var context = new Contexto())
            {
                // Ejecutar el procedimiento almacenado
                context.Database.ExecuteSqlRaw("EXEC sp_ActualizarCreditosTotales @NumeroCuenta={0}", numeroCuenta);
            }

            return Ok();
        }


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

        [HttpGet]
        [Route("api/CreditosTotalesPorTipo")]
        public IActionResult GetCreditosPorTipo([FromQuery] string numCuenta)
        {
            using (var db = new Contexto())
            {
                var CuentaParam = new SqlParameter("@numeroCuenta", numCuenta);
                var creditos = db.CreditosPorTipos.FromSqlRaw("EXEC sp_CreditosPorTipoCertificado @numeroCuenta", CuentaParam).ToList();
                return Ok(creditos);
            }
        }
    }
}
