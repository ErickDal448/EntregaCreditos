using System;
using System.Collections.Generic;

namespace Validaciones_Creditos.Models;

public partial class Evento
{
    public int IdEvento { get; set; }

    public string? Nombre { get; set; }

    public int? IdTipo { get; set; }

    public string? Descripcion { get; set; }

    public DateTime? Fecha { get; set; }

    public string? Estado { get; set; }

    public decimal? Creditos { get; set; }

    public string? Mapa { get; set; }

    public string? Institucion { get; set; }
}
