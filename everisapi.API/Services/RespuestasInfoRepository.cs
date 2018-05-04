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

    public RespuestaEntity GetRespuesta(int RespuestaId)
    {
      return _context.Respuestas.Where(r => r.Id == RespuestaId).FirstOrDefault();
    }

    public IEnumerable<RespuestaEntity> GetRespuestas()
    {
      return _context.Respuestas.ToList();
    }

    public IEnumerable<RespuestaEntity> GetRespuestasFromPregProy(int IdProyecto, int IdPregunta)
    {
      return _context.Respuestas.Where(r => r.PreguntaId == IdPregunta && r.ProyectoId == IdProyecto).ToList();
    }

    public IEnumerable<RespuestaEntity> GetRespuestasFromAsigProy(int IdProyecto, int IdAsignacion)
    {
      return _context.Respuestas.Where(r => r.PreguntaEntity.AsignacionId == IdAsignacion && r.ProyectoId == IdProyecto).ToList();
    }

    public bool SaveChanges()
    {
      return (_context.SaveChanges() >= 0);
    }

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
