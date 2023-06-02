using System;
using System.Collections.Generic;

namespace Validaciones_Creditos.Models;

public partial class Usuario
{
    public string NumeroCuenta { get; set; } = null!;

    public string? Nip { get; set; }

    public string? Nombre { get; set; }

    public string? Apellidos { get; set; }

    public decimal? CreditosTotales { get; set; }

    public string? Rol { get; set; }

    public string? Institucion { get; set; }

    public int? Grado { get; set; }

    public int? Grupo { get; set; }
    public int? TopeCreditos { get; set; }

}
