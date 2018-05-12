using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Threading.Tasks;
using everisapi.API.Entities;
using everisapi.API.Models;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;

namespace everisapi.API.Services
{
    public class EvaluacionInfoRepository : IEvaluacionInfoRepository
    {

        private AsignacionInfoContext _context;

        //Le damos un contexto en el constructor
        public EvaluacionInfoRepository(AsignacionInfoContext context)
        {
            _context = context;
        }

        //Recoge una evaluación incluyendo o no las respuestas
        public EvaluacionEntity GetEvaluacion(int IdEvaluacion, bool IncluirRespuestas)
        {
            if (IncluirRespuestas)
            {
              return _context.Evaluaciones.Include(e => e.Respuestas)
                .Where(e => e.Id == IdEvaluacion).FirstOrDefault();
            }
            else
            {
              return _context.Evaluaciones.Where(e => e.Id == IdEvaluacion).FirstOrDefault();
            }
        }

    //Recoge una lista de evaluaciones con datos de información de muchas tablas
    public List<EvaluacionInfoDto> GetEvaluationInfo(int IdProject)
    {
      List<EvaluacionInfoDto> EvaluacionesInformativas = new List<EvaluacionInfoDto>();
      var Evaluaciones = _context.Evaluaciones.Where(e => e.ProyectoId == IdProject).ToList();

      //Encuentra la informacion de la evaluacion y lo introduce en un objeto
      foreach (var evaluacion in Evaluaciones)
      {
        EvaluacionInfoDto EvaluacionInfo = _context.Respuestas.
        Include(r => r.EvaluacionEntity).
        ThenInclude(e => e.ProyectoEntity).
        ThenInclude(p => p.UserEntity).
        Where(e => e.EvaluacionId == evaluacion.Id)
        .Select(r => new EvaluacionInfoDto
        {
          Id = r.EvaluacionEntity.Id,
          Fecha = r.EvaluacionEntity.Fecha.Date,
          Estado = r.EvaluacionEntity.Estado,
          Nombre = r.EvaluacionEntity.ProyectoEntity.Nombre,
          UserNombre = r.EvaluacionEntity.ProyectoEntity.UserNombre
        })
          .FirstOrDefault<EvaluacionInfoDto>();
        //Calcula el número de preguntas y el número de respuestas de esa evaluación
        EvaluacionInfo.NPreguntas = _context.Respuestas.Where(r => r.EvaluacionId == evaluacion.Id).Count();
        EvaluacionInfo.NRespuestas = _context.Respuestas.Where(r => r.Estado == true && r.EvaluacionId == evaluacion.Id).Count();

        //Añade el objeto en la lista
        EvaluacionesInformativas.Add(EvaluacionInfo);
      }
      return EvaluacionesInformativas;
    }

    //Recoge una lista de evaluaciones con datos de información de muchas tablas filtrandola por paginado
    public List<EvaluacionInfoDto> GetEvaluationInfoAndPage(int IdProject, int pageNumber)
    {
      //Recogemos las evaluaciones y la paginamos
      List<EvaluacionInfoDto> EvaluacionesInformativas = new List<EvaluacionInfoDto>();
      var Evaluaciones = _context.Evaluaciones.Where(e => e.ProyectoId == IdProject).Skip(5 * pageNumber).Take(5)
        .ToList();
      //Encuentra la informacion de la evaluacion y lo introduce en un objeto
      foreach (var evaluacion in Evaluaciones)
      {
        EvaluacionInfoDto EvaluacionInfo = _context.Respuestas.
        Include(r => r.EvaluacionEntity).
        ThenInclude(e => e.ProyectoEntity).
        ThenInclude(p => p.UserEntity).
        Where(e => e.EvaluacionId == evaluacion.Id)
        .Select(r => new EvaluacionInfoDto
        {
          Id = r.EvaluacionEntity.Id,
          Fecha = r.EvaluacionEntity.Fecha.Date,
          Estado = r.EvaluacionEntity.Estado,
          Nombre = r.EvaluacionEntity.ProyectoEntity.Nombre,
          UserNombre = r.EvaluacionEntity.ProyectoEntity.UserNombre
        })
          .FirstOrDefault<EvaluacionInfoDto>();
        //Calcula el número de preguntas y el número de respuestas de esa evaluación
        EvaluacionInfo.NPreguntas = _context.Respuestas.Where(r => r.EvaluacionId == evaluacion.Id).Count();
        EvaluacionInfo.NRespuestas = _context.Respuestas.Where(r => r.Estado == true && r.EvaluacionId == evaluacion.Id).Count();

        //Añade el objeto en la lista
        EvaluacionesInformativas.Add(EvaluacionInfo);
      }

      return EvaluacionesInformativas;
    }

    //Recoge todas las evaluaciones
    public IEnumerable<EvaluacionEntity> GetEvaluaciones()
        {
          return _context.Evaluaciones.ToList();
        }

        //Recoge todas las evaluaciones de un proyecto
        public IEnumerable<EvaluacionEntity> GetEvaluacionesFromProject(int IdProject)
        {
          return _context.Evaluaciones.Where(e => e.ProyectoId == IdProject).ToList();
        }

        //Devuelve una evaluacion si existiera una inacabada en la base de datos filtrado por id de projecto
        public EvaluacionEntity EvaluationIncompletaFromProject(int IdProject)
        {
          return _context.Evaluaciones.Where(e => e.ProyectoId == IdProject && !e.Estado).FirstOrDefault();
        }


        //Incluye una nueva evaluación a la base de datos
        public void IncluirEvaluacion(EvaluacionEntity evaluacion)
        {
           _context.Add(evaluacion);

           this.SaveChanges();
        }

        //Modifica el estado de una evaluacion
        public void ModificarEvaluacion(int IdEvaluacion, EvaluacionEntity evaluacion)
        {
            EvaluacionEntity evoluacionAnterior = _context.Evaluaciones.Where(e => e.Id == IdEvaluacion).FirstOrDefault();

            evoluacionAnterior.Estado = evaluacion.Estado;
            this.SaveChanges();
        }

        //Guarda todos los cambios en la base de datos
        public bool SaveChanges()
        {
          return (_context.SaveChanges() >= 0);
        }
  }
}
