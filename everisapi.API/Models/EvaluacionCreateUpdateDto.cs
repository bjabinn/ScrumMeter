using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace everisapi.API.Models
{
    public class EvaluacionCreateUpdateDto
    {
    public int Id { get; set; }

    [Required]
    public DateTime Fecha { get; set; } = DateTime.Now;

    [Required]
    public bool Estado { get; set; }

    [Required]
    public int ProyectoId { get; set; }
  }
}
