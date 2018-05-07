using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using everisapi.API.Entities;

namespace everisapi.API.Services
{
  public class RespuestasInfoRepository : IRespuestasInfoRepository
  {

    private AsignacionInfoContext _context;

    //Le damos un contexto en el constructor
    public RespuestasInfoRepository(AsignacionInfoContext context)
    {
      _context = context;
    }

    //Recoge una unica respuesta filtrada por id
    public RespuestaEntity GetRespuesta(int RespuestaId)
    {
      return _context.Respuestas.Where(r => r.Id == RespuestaId).FirstOrDefault();
    }

    //Recoge todas las respuestas existentes
    public IEnumerable<RespuestaEntity> GetRespuestas()
    {
      return _context.Respuestas.ToList();
    }

    //Introduciendo el id de evaluacion y el id de pregunta te da la lista de respuestas
    public IEnumerable<RespuestaEntity> GetRespuestasFromPregEval(int idEvaluacion, int IdPregunta)
    {
      return _context.Respuestas.Where(r => r.PreguntaId == IdPregunta && r.EvaluacionId == idEvaluacion).ToList();
    }

    //Introduciendo la id de asignacion y la id de evaluacion sacaremos una lista con todas las respuestas
    public IEnumerable<RespuestaEntity> GetRespuestasFromAsigEval(int idEvaluacion, int IdAsignacion)
    {
      return _context.Respuestas.Where(r => r.PreguntaEntity.AsignacionId == IdAsignacion && r.EvaluacionId == idEvaluacion).ToList();
    }

    //Guarda todos los cambios en la base de datos
    public bool SaveChanges()
    {
      return (_context.SaveChanges() >= 0);
    }

    //Realiza un update de la respuesta por el id de la respuesta y el estado que se desea cambiar
    public void UpdateRespuesta(bool Opcion, int RespuestaId)
    {
      RespuestaEntity respuestaAnterior = _context.Respuestas.Where(r => r.Id == RespuestaId).FirstOrDefault();
      if (respuestaAnterior != null)
      {
        respuestaAnterior.Estado = Opcion;
        this.SaveChanges();
      }
    }
  }
}
