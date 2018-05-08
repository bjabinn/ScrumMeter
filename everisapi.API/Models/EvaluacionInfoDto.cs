using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace everisapi.API.Models
{
    public class EvaluacionInfoDto
    {
    public int Id { get; set; }

    public string Nombre { get; set; }

    public string UserNombre { get; set; }

    public int NPreguntas { get; set; }

    public int NRespuestas { get; set; }

    public DateTime Fecha { get; set; }

    public bool Estado { get; set; }

  }
}
