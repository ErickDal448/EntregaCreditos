using System;
using System.Collections.Generic;

namespace Validaciones_Creditos.Models.Views;

public partial class EventosRealizado
{
    public int idEventoRealizado { get; set; }
    public int? IdEvento { get; set; }

    public string? NumUsuario { get; set; }

    public virtual Evento? IdEventoNavigation { get; set; }

    public virtual Usuario? NumUsuarioNavigation { get; set; }
}
