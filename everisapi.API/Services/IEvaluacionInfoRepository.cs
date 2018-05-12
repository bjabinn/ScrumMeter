using everisapi.API.Entities;
using everisapi.API.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace everisapi.API.Services
{
   public interface IEvaluacionInfoRepository
  {
        //Devuelve todas las evaluaciones
        IEnumerable<EvaluacionEntity> GetEvaluaciones();

        //Devuelve una evaluación
        EvaluacionEntity GetEvaluacion(int IdEvaluacion, Boolean IncluirRespuestas);

        //Devuelve información detallada de las evaluaciones
        List<EvaluacionInfoDto> GetEvaluationInfo(int IdProject);

        //Recoge una lista de evaluaciones con datos de información de muchas tablas filtrandola por paginado
        List<EvaluacionInfoDto> GetEvaluationInfoAndPage(int IdProject, int pageNumber);

        //Devuelve todas las evaluaciones de un proyecto
        IEnumerable<EvaluacionEntity> GetEvaluacionesFromProject(int IdProject);

        //Devuelve una evaluacion si existiera una evaluacion inacabada en la base de datos filtrado por id de projecto
        EvaluacionEntity EvaluationIncompletaFromProject(int IdProject);

        //Añadir una evaluación en un proyecto
        void IncluirEvaluacion( EvaluacionEntity evaluacion);

        //Guardar cambio de las entidades
        bool SaveChanges();

        //Modifica una evaluación concreta de un proyecto
        void ModificarEvaluacion(int IdProject, EvaluacionEntity evaluacion);
    }
}
