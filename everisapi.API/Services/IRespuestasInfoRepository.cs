using everisapi.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace everisapi.API.Services
{
    public interface IRespuestasInfoRepository
    {
    //Devuelve todas las respuestas
    IEnumerable<RespuestaEntity> GetRespuestas();

    //Devuelve una respuesta
    RespuestaEntity GetRespuesta(int RespuestaId);

    //Devuelve todas las respuestas filtrada por proyecto y asignacion
    IEnumerable<RespuestaEntity> GetRespuestasFromPregEval(int IdProyecto, int IdAsignacion);

    //Devuelve todas las respuestas filtrada por proyecto y pregunta
    IEnumerable<RespuestaEntity> GetRespuestasFromAsigEval(int IdProyecto, int IdPregunta);

    //Update de una respuesta
    void UpdateRespuesta(bool Opcion, int RespuestaId);

    //Guardar cambio de las entidades
    bool SaveChanges();
  }
}
