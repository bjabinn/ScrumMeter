using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using everisapi.API.Entities;
using Microsoft.EntityFrameworkCore;

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
