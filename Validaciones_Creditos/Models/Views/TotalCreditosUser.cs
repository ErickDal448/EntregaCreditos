using System.ComponentModel.DataAnnotations;

namespace Validaciones_Creditos.Models.Views
{
    public class TotalCreditosUser
    {
        [Key]
        public string NumeroCuenta { get; set; }
        public decimal CreditosTotales { get; set; }
        public int TopeCreditos { get; set; }
    }
}
