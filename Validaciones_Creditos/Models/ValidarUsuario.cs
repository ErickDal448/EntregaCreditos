using System.ComponentModel.DataAnnotations;

namespace Validaciones_Creditos.Models
{
    public class ValidarUsuario
    {
        [Key]
        public string NumeroCuenta { get; set; } = null!;
        public string Nip { get; set; }
        public string Nombre { get; set; }
        public string Apellidos { get; set; }
        public string Rol { get; set; }
        public string Institucion { get; set; }
    }
}
