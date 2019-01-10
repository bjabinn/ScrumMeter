using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using everisapi.API.Entities;
using everisapi.API.Models;
using Microsoft.EntityFrameworkCore;

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

        //Metodo que devuelve la lista de respuestas de las preguntas que pertenecen a una pregunta hablitante de una evaluacion
        public IEnumerable<RespuestaEntity> GetAnswersByEnablingQuestion(int evaluationId, int enablingQuestionId)
        {
            return _context.Respuestas.Where(r => r.PreguntaEntity.PreguntaHabilitanteId == enablingQuestionId
            && r.EvaluacionId == evaluationId).ToList();
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
        public bool UpdateRespuesta(RespuestaDto Respuesta)
        {
            RespuestaEntity respuestaAnterior = _context.Respuestas.Where(r => r.Id == Respuesta.Id).FirstOrDefault();
            EvaluacionEntity currentEvaluation = _context.Evaluaciones.First(x => x.Id == respuestaAnterior.EvaluacionId);

            if (respuestaAnterior != null)
            {
                respuestaAnterior.Estado = Respuesta.Estado;
                respuestaAnterior.Notas = Respuesta.Notas;
                respuestaAnterior.NotasAdmin = Respuesta.NotasAdmin;

                currentEvaluation.LastQuestionUpdated = respuestaAnterior.PreguntaId;

                return SaveChanges();
            }
            else
            {
                return false;
            }
        }

        //Metodo que actualiza la respuesta de una pregunta habilitante a No y la de sus preguntas habilitadas a SinResponder
        public bool UpdateRespuestasAsignacion(int evaluationId, int enablingQuestionId)
        {
            List<RespuestaEntity> disabledsAnswers = GetAnswersByEnablingQuestion(evaluationId, enablingQuestionId).ToList();
            RespuestaEntity enablingAnswer = _context.Respuestas.First(r => r.PreguntaEntity.Id == enablingQuestionId && r.EvaluacionId == evaluationId);
            EvaluacionEntity evaluation = _context.Evaluaciones.First(e => e.Id == evaluationId);

            if (disabledsAnswers != null)
            {
                disabledsAnswers.ForEach(r => r.Estado = 0);
                enablingAnswer.Estado = 2;
                evaluation.LastQuestionUpdated = enablingQuestionId;
                
                return SaveChanges();
            }
            else
            {
                return false;
            }
        }

        //Introduciendo la id de evaluacion sacaremos una lista con todas las respuestas 
        public IEnumerable<RespuestaConNotasDto> GetRespuestasConNotas(int idEvaluacion, int? assessmentId)
        {
            List<RespuestaEntity> respuestas;
            if (assessmentId != null || assessmentId != 0)
            {
                respuestas = _context.Respuestas.
                    Include(r => r.PreguntaEntity).
                      ThenInclude(p => p.AsignacionEntity).
                      ThenInclude(p => p.SectionEntity).
                      // ThenInclude(p => p.AssessmentId == assessmentId).
                    Where(r => r.EvaluacionId == idEvaluacion && r.PreguntaEntity.AsignacionEntity.SectionEntity.AssessmentId == assessmentId).ToList();
            }
            else
            {
                respuestas = _context.Respuestas.
                       Include(r => r.PreguntaEntity).
                         ThenInclude(p => p.AsignacionEntity).
                         ThenInclude(p => p.SectionEntity).
                         ThenInclude(p => p.Assessment).
                       Where(r => r.EvaluacionId == idEvaluacion).ToList();
            }



            List<RespuestaConNotasDto> lista = new List<RespuestaConNotasDto>();

            foreach (RespuestaEntity resp in respuestas)
            {
                lista.Add(new RespuestaConNotasDto
                {
                    Id = resp.Id,
                    Estado = resp.Estado,
                    Correcta = resp.PreguntaEntity.Correcta,
                    Notas = resp.Notas,
                    NotasAdmin = resp.NotasAdmin,
                    Asignacion = resp.PreguntaEntity.AsignacionEntity.Nombre,
                    Section = resp.PreguntaEntity.AsignacionEntity.SectionEntity.Nombre,
                    Pregunta = resp.PreguntaEntity.Pregunta
                });
            }

            return lista;
        }

        //Aqui introducimos una nueva respuesta
        public bool AddRespuesta(RespuestaEntity respuesta)
        {
            _context.Respuestas.Add(respuesta);
            return SaveChanges();
        }

        //Elimina una respuesta
        public bool DeleteRespuesta(RespuestaEntity respuesta)
        {
            _context.Respuestas.Remove(_context.Respuestas.Where(r => r == respuesta).FirstOrDefault());
            return SaveChanges();
        }

        //Muestra si existe la respuesta
        public bool ExiteRespuesta(int idRespuesta)
        {
            return _context.Respuestas.Any(r => r.Id == idRespuesta);
        }


    }
}
