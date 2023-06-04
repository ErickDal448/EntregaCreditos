using System.ComponentModel.DataAnnotations;

namespace Validaciones_Creditos.Models.Views
{
    public class CertificadosFiltro
    {
        [Key]
        public int IdEnvio { get; set; }

        public int? IdTipo { get; set; }

        public string? NombreTC { get; set; }

        public string? NumUsuario { get; set; }

        public string? Nombre { get; set; }

        public string? Apellidos { get; set; }

        public string? TituloCertificado { get; set; }

        public DateTime? Fecha { get; set; }

        public string? Estado { get; set; }

        public string? Comentario { get; set; }

        public string? Drive { get; set; }

        public decimal? Creditos { get; set; }
    }
}
