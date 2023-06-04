using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Validaciones_Creditos.Models;
using Validaciones_Creditos.Models.Views;

namespace Validaciones_Creditos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventosInfoPostController : ControllerBase
    {
        private readonly Contexto _context;

        public EventosInfoPostController(Contexto context)
        { 
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<EventosInfoPost>>> GetEventos()
        {
            var eventos = await _context.InfoEventosPost.ToListAsync();
            foreach (var evento in eventos)
            {
                var tipoCertificado = await _context.TipoCertificados.FindAsync(evento.IdTipo);
                evento.NombreTc = tipoCertificado?.NombreTc;
            }
            return eventos;
        }

        [HttpGet("{idEvento}")]
        public async Task<ActionResult<EventosInfoPost>> GetEvento(int idEvento)
        {
            var evento = await _context.InfoEventosPost.FirstOrDefaultAsync(e => e.IdEvento == idEvento);

            if (evento == null)
            {
                return NotFound();
            }

            var tipoCertificado = await _context.TipoCertificados.FindAsync(evento.IdTipo);
            evento.NombreTc = tipoCertificado?.NombreTc;

            return evento;
        }

        [HttpPost]
        [Route("CrearEvento")]
        public async Task<ActionResult<Evento>> PostEvento(Evento evento)
        {
            _context.Eventos.Add(evento);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetEvento), new { idEvento = evento.IdEvento }, evento);

        }
        [HttpPut]
        [Route("EditarEvento/{idEvento}")]
        public async Task<IActionResult> PutEvento(int idEvento, Evento evento)
        {
            if (idEvento != evento.IdEvento)
            {
                return BadRequest();
            }

            _context.Entry(evento).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EventoExists(idEvento))
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

        private bool EventoExists(int id)
        {
            return _context.Eventos.Any(e => e.IdEvento == id);
        }
    }
}
