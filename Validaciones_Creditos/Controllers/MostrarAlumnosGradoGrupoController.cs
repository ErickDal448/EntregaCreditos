using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Validaciones_Creditos.Models;
using Validaciones_Creditos.Models.Views;

namespace Validaciones_Creditos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MostrarAlumnosGradoGrupoController : ControllerBase
    {
        private readonly Contexto _context;

        public MostrarAlumnosGradoGrupoController(Contexto context)
        {
            _context = context;
        }

        [HttpGet("AlumnoGradoGrupo/{grado}/{grupo}/{institucion}")]
        public async Task<ActionResult<IEnumerable<MostrarAlumnosGradoGrupo>>> MostrarAlumnosPorGradoGrupo( int grado, int grupo, string institucion)
        {
            try
            {
                var gradoParam = new SqlParameter("@Grado", grado);
                var grupoParam = new SqlParameter("@Grupo", grupo);
                var institucionParam = new SqlParameter("@Institucion", institucion);

                var usuarios = await _context.MostrarAlumnosGradoGrupo
                    .FromSqlRaw("EXEC MostrarAlumnosGradoGrupo @Grado, @Grupo, @Institucion", gradoParam, grupoParam, institucionParam)
                    .ToListAsync();

                return usuarios;
            }
            catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("MostrarGrados/{institucion}")]
        public async Task<ActionResult<IEnumerable<VerGrados>>> MostrarGradosPorInstitucion(string institucion)
        {
            try
            {
                var gradoParam = new SqlParameter("@Institucion", institucion);

                var grados = await _context.MostrarGradosPorInstitucion
                    .FromSqlRaw("EXEC MostrarGradosPorInstitucion @Institucion", gradoParam)
                    .ToListAsync();

                return grados;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("MostrarGrupos/{institucion}")]
        public async Task<ActionResult<IEnumerable<VerGrupos>>> MostrarGruposPorInstitucion(string institucion)
        {
            try
            {
                var grupoParam = new SqlParameter("@Institucion", institucion);

                var grupos = await _context.MostrarGruposPorInstitucion
                    .FromSqlRaw("EXEC MostrarGruposPorInstitucion @Institucion", grupoParam)
                    .ToListAsync();

                return grupos;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
