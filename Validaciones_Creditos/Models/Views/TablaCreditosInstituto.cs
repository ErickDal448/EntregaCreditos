using System.ComponentModel.DataAnnotations;

namespace Validaciones_Creditos.Models.Views
{
    public class TablaCreditosInstituto
    {
        [Key]
        public int Id { get; set; }
        public string Institucion { get; set; }
        public string NombreTC { get; set; }
        public decimal CreditosMax { get; set; }
        public decimal CreditosValor { get; set; }
    }

}
