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
      var Evaluaciones = _context.Evaluaciones.
        Include(r => r.ProyectoEntity).
        ThenInclude(p => p.UserEntity).OrderByDescending(e => e.Fecha)
        .Where(e => e.ProyectoId == IdProject).ToList();

      //Encuentra la informacion de la evaluacion y lo introduce en un objeto
      foreach (var evaluacion in Evaluaciones)
      {
        EvaluacionInfoDto EvaluacionInfo = new EvaluacionInfoDto
        {
          Id = evaluacion.Id,
          Fecha = evaluacion.Fecha,
          Estado = evaluacion.Estado,
          Nombre = evaluacion.ProyectoEntity.Nombre,
          UserNombre = evaluacion.ProyectoEntity.UserNombre
        };


        EvaluacionInfo.Puntuacion = calculaPuntuacion(evaluacion.Id);

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
      var Evaluaciones = _context.Evaluaciones.
        Include(r => r.ProyectoEntity).
        ThenInclude(p => p.UserEntity).
        Where(e => e.ProyectoId == IdProject).Skip(5 * pageNumber).Take(5)
        .OrderByDescending(e => e.Fecha).ToList();
      //Encuentra la informacion de la evaluacion y lo introduce en un objeto
      foreach (var evaluacion in Evaluaciones)
      {
        EvaluacionInfoDto EvaluacionInfo = new EvaluacionInfoDto
        {
          Id = evaluacion.Id,
          Fecha = evaluacion.Fecha,
          Estado = evaluacion.Estado,
          Nombre = evaluacion.ProyectoEntity.Nombre,
          UserNombre = evaluacion.ProyectoEntity.UserNombre
        };

        EvaluacionInfo.Puntuacion = calculaPuntuacion(evaluacion.Id);

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
    public bool ModificarEvaluacion(int IdEvaluacion, EvaluacionEntity evaluacion)
    {
      EvaluacionEntity evoluacionAnterior = _context.Evaluaciones.Where(e => e.Id == IdEvaluacion).FirstOrDefault();

      evoluacionAnterior.Estado = evaluacion.Estado;
      return SaveChanges();
    }

    //Guarda todos los cambios en la base de datos
    public bool SaveChanges()
    {
      return (_context.SaveChanges() >= 0);
    }

    //Metodo que devuelve un filtrado de evaluaciones y proyecto paginada
    public List<EvaluacionInfoDto> GetEvaluationInfoAndPageFiltered(int IdProject, int pageNumber, EvaluacionInfoPaginationDto Evaluacion)
    {
      //Recogemos las evaluaciones y la paginamos
      List<EvaluacionInfoDto> EvaluacionesInformativas = new List<EvaluacionInfoDto>();
      List<EvaluacionEntity> Evaluaciones;
      if (Evaluacion.Estado != null && Evaluacion.Estado != "")
      {
        Evaluaciones = _context.Evaluaciones.
        Include(r => r.ProyectoEntity).
        ThenInclude(p => p.UserEntity).
        Where(e => e.ProyectoId == IdProject &&
        e.Estado == Boolean.Parse(Evaluacion.Estado) &&
        e.Fecha.Date.ToString("yyyyMMdd").Contains(Evaluacion.Fecha) &&
        e.ProyectoEntity.UserNombre.ToLower().Contains(Evaluacion.UserNombre.ToLower())
        ).OrderByDescending(e => e.Fecha).ToList();
      }
      else
      {
        Evaluaciones = _context.Evaluaciones.
        Include(r => r.ProyectoEntity).
        ThenInclude(p => p.UserEntity).
        Where(e => e.ProyectoId == IdProject &&
        e.Fecha.Date.ToString("yyyyMMdd").Contains(Evaluacion.Fecha) &&
        e.ProyectoEntity.UserNombre.ToLower().Contains(Evaluacion.UserNombre.ToLower())
        ).OrderByDescending(e => e.Fecha).ToList();
      }
      //Encuentra la informacion de la evaluacion y lo introduce en un objeto
      foreach (var evaluacion in Evaluaciones)
      {
        EvaluacionInfoDto EvaluacionInfo = new EvaluacionInfoDto
        {
          Id = evaluacion.Id,
          Fecha = evaluacion.Fecha,
          Estado = evaluacion.Estado,
          Nombre = evaluacion.ProyectoEntity.Nombre,
          UserNombre = evaluacion.ProyectoEntity.UserNombre
        };

        EvaluacionInfo.Puntuacion = calculaPuntuacion(evaluacion.Id);
        //Añade el objeto en la lista
        EvaluacionesInformativas.Add(EvaluacionInfo);
      }


      return EvaluacionesInformativas.Skip(5 * pageNumber).Take(5).ToList();
    }

    //Metodo que devuelve un filtrado de evaluaciones paginada sin proyectos
    public List<EvaluacionInfoDto> GetEvaluationInfoAndPageFilteredAdmin(int pageNumber, EvaluacionInfoPaginationDto Evaluacion)
    {
      //Recogemos las evaluaciones y la paginamos
      List<EvaluacionInfoDto> EvaluacionesInformativas = new List<EvaluacionInfoDto>();
      List<EvaluacionEntity> Evaluaciones;
      if (Evaluacion.Estado != null && Evaluacion.Estado != "")
      {
        Evaluaciones = _context.Evaluaciones.
        Include(r => r.ProyectoEntity).
        ThenInclude(p => p.UserEntity).
        Where(e => e.Estado == Boolean.Parse(Evaluacion.Estado) &&
        e.Fecha.Date.ToString("yyyyMMdd").Contains(Evaluacion.Fecha) &&
        e.ProyectoEntity.UserNombre.ToLower().Contains(Evaluacion.UserNombre.ToLower())
        ).OrderByDescending(e => e.Fecha).ToList();
      }
      else
      {
        Evaluaciones = _context.Evaluaciones.
        Include(r => r.ProyectoEntity).
        ThenInclude(p => p.UserEntity).
        Where(e => e.Fecha.Date.ToString("yyyyMMdd").Contains(Evaluacion.Fecha) &&
        e.ProyectoEntity.Nombre.Contains(Evaluacion.Nombre) &&
        e.ProyectoEntity.UserNombre.ToLower().Contains(Evaluacion.UserNombre.ToLower())
        ).OrderByDescending(e => e.Fecha).ToList();
      }


      //Encuentra la informacion de la evaluacion y lo introduce en un objeto
      foreach (var evaluacion in Evaluaciones)
      {
        EvaluacionInfoDto EvaluacionInfo = new EvaluacionInfoDto
        {
          Id = evaluacion.Id,
          Fecha = evaluacion.Fecha,
          Estado = evaluacion.Estado,
          Nombre = evaluacion.ProyectoEntity.Nombre,
          UserNombre = evaluacion.ProyectoEntity.UserNombre
        };

        EvaluacionInfo.Puntuacion = calculaPuntuacion(evaluacion.Id);
        //Añade el objeto en la lista
        EvaluacionesInformativas.Add(EvaluacionInfo);
      }
      return EvaluacionesInformativas;
    }

    //Devuelve el número de proyectos de un proyecto o de todos los proyectos
    public int GetNumEval(int idProject)
    {
      //Si es distinto de cero filtra sino filtra por todos
      if (idProject != 0)
      {
        return _context.Evaluaciones.Where(e => e.ProyectoId == idProject).Count();
      }
      else
      {
        return _context.Evaluaciones.Count();
      }
    }


    //Este metodo nos permite eliminar una evaluacion en concreto
    public bool DeleteEvaluacion(EvaluacionEntity evaluacion)
    {
      _context.Evaluaciones.Remove(_context.Evaluaciones.Where(e => e == evaluacion).FirstOrDefault());
      return SaveChanges();
    }

    private double calculaPuntuacion(int idEvaluacion)
    {
      //Calcula la puntuacion de esa evaluación
      var listaRespuestas = _context.Respuestas.
        Include(r => r.PreguntaEntity).
        ThenInclude(rp => rp.AsignacionEntity).
        ThenInclude(rpa => rpa.SectionEntity).
        Where(r => r.EvaluacionId == idEvaluacion).ToList();

      double suma = 0;
      double puntosCorrectos = 0;

      foreach (var resp in listaRespuestas)
      {

        if (resp.PreguntaEntity.Correcta != null)
        {
          var maxPuntos = listaRespuestas.Where(r => r.PreguntaEntity.Correcta != null &&
          r.PreguntaEntity.AsignacionId == resp.PreguntaEntity.AsignacionId).Count();

          var puntos = (double)resp.PreguntaEntity.AsignacionEntity.Peso / maxPuntos;

          puntosCorrectos += puntos;

          if (resp.Estado == 1 && resp.PreguntaEntity.Correcta.Equals("Si"))
          {
            suma += puntos;
          }

          else if (resp.Estado == 2 && resp.PreguntaEntity.Correcta.Equals("No"))
          {
            suma += puntos;
          }

        }
      }

      return Math.Round(100 * suma / puntosCorrectos, 1); ;
    }
  }
}
