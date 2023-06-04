using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Validaciones_Creditos.Models;

namespace Validaciones_Creditos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValidarUsuarioController : ControllerBase
    {

        [HttpGet]
        [Route("Validar-Usuario")]
        public IActionResult ValidarGet([FromQuery] string numCuenta, [FromQuery] string nip)
        {
            Contexto db = new Contexto();
            var numCuentaParam = new SqlParameter("@numCuenta", numCuenta);
            var nipParam = new SqlParameter("@nip", nip);
            var enviados = db.ValidarUsuarios.FromSqlRaw("Exec ValidarUsuario @numCuenta, @nip", numCuentaParam, nipParam).ToList();
            return Ok(enviados);
        }


    }
}
