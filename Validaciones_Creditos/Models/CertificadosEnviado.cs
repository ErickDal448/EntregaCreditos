using System;
using System.Collections.Generic;

namespace Validaciones_Creditos.Models;

public partial class CertificadosEnviado
{
    public int IdEnvio { get; set; }

    public int? IdTipo { get; set; }

    public string? NumUsuario { get; set; }

    public string? TituloCertificado { get; set; }

    public DateTime? Fecha { get; set; }

    public string? Estado { get; set; }

    public string? Comentario { get; set; }

    public string? Drive { get; set; }

    public decimal? Creditos { get; set; }
}
