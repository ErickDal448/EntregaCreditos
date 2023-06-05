namespace Validaciones_Creditos.Models.Views
{
    public class CreditosPorTipo
    {
        public string NumeroCuenta { get; set; } = null!;

        public int IdTipoCertificado { get; set; }

        public string? NombreTipoCertificado { get; set; }

        public decimal? CreditosTotales { get; set; }

        public decimal? TopeCreditos { get; set; }
    }
}
