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
    public class EventosRealizadosController : ControllerBase
    {

        private readonly Contexto _context;

        public EventosRealizadosController(Contexto context)
        {
            _context = context;
        }
        [HttpGet]
        [Route("api/EventosRealizados")]
        public IActionResult GetCreditos([FromQuery] string NumUsuario)
        {
            using (var db = new Contexto())
            {
                var NumUsuarioParam = new SqlParameter("@NumUsuario", NumUsuario);
                var creditos = db.FiltroEventos.FromSqlRaw("EXEC EventosRealizadosFiltro @NumUsuario", NumUsuarioParam).ToList();
                return Ok(creditos);
            }
        }

        [HttpPost]
        [Route("CrearEventoRealizadoDesdeVista")]
        public async Task<ActionResult<EventosRealizado>> PostEventoRealizadoDesdeVista(VistaEventosRealizados vistaEventosRealizados)
        {
            // Mapear los datos del objeto VistaEventosRealizados a un objeto EventosRealizados
            var eventoRealizado = new EventosRealizado
            {
                IdEvento = vistaEventosRealizados.IdEvento,
                NumUsuario = vistaEventosRealizados.NumUsuario
                // Mapear otras propiedades aquí
            };

            // Agregar el objeto eventoRealizado a la base de datos
            _context.EventosRealizados.Add(eventoRealizado);
            await _context.SaveChangesAsync();

            // Devolver una respuesta 201 Created con la información del objeto creado
            return CreatedAtAction(nameof(GetCreditos), new { id = eventoRealizado.idEventoRealizado }, eventoRealizado);
        }



    }
}
