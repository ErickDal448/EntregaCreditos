using System;
using System.Collections.Generic;

namespace Validaciones_Creditos.Models;

public partial class TipoCertificado
{
    public int Id { get; set; }

    public string? Institucion { get; set; }

    public string? NombreTc { get; set; }

    public decimal? CreditosMax { get; set; }

    public decimal? CreditosValor { get; set; }

}
