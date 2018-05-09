using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using everisapi.API.Entities;
using everisapi.API.Models;
using Microsoft.EntityFrameworkCore;

namespace everisapi.API.Services
{
    public class AsignacionInfoRepository : IAsignacionInfoRepository
    {

        private AsignacionInfoContext _context;

        //Le damos un contexto en el constructor
        public AsignacionInfoRepository(AsignacionInfoContext context)
        {
            _context = context;
        }

        //Comprobamos si una asignación concreta existe
        public bool AsignacionExiste(int AsignacionId)
        {
            return _context.Asignaciones.Any(a => a.Id == AsignacionId);
        }

        //Recogemos una asignación con o sin preguntas incluidas
        public AsignacionEntity GetAsignacion(int AsignacionId, Boolean IncluirPreguntas)
        {
            
            if (IncluirPreguntas)
            {
                //Si se quiere incluir las preguntas de la asignación entrara aquí
                //Incluimos las preguntas de la asignación especificada (Include extiende de Microsoft.EntityFrameworkCore)
                return _context.Asignaciones.Include(c => c.PreguntasDeAsignacion).
                    Where(c => c.Id == AsignacionId).FirstOrDefault();
            }
            else
            {
                //Si no es así devolveremos solo la asignación
                return _context.Asignaciones.Where(c => c.Id == AsignacionId).FirstOrDefault();
            }
        }

        //Recogemos una lista completa de asignaciones
        public IEnumerable<AsignacionEntity> GetAsignaciones()
        {
            //Devolvemos todas las asignaciones ordenadas por Nombre
            return _context.Asignaciones.OrderBy(c => c.Nombre).ToList();
        }

        //Devuelve todas las asignaciones con datos extendidos filtrado por proyecto
        public IEnumerable<AsignacionInfoDto> GetAsignFromProject(int idEval)
        {
          //return _context.Asignaciones.Where(a => a.PreguntasDeAsignacion.Any(p => p.))

          return null;
        }

        //Recogemos una pregunta de una asignación
        public PreguntaEntity GetPreguntaDeAsignacion(int AsignacionId, int PreguntaId)
        {
            //Devolvemos una pregunta especifica de una Asignación
            return _context.Preguntas.Where(p => p.AsignacionId == AsignacionId && p.Id == PreguntaId).FirstOrDefault();
        }

        //Recogemos la lista de preguntas de una asignación
        //En el caso de que no exista devolvera un array vacio e igualmente si la lista de la ciudad esta vacia
        public IEnumerable<PreguntaEntity> GetPreguntaPorAsignacion(int AsignacionId)
        {
            //Devolvemos una lista de preguntas de una asignación especifica
            return _context.Preguntas.Where(p => p.AsignacionId == AsignacionId).ToList();
        }

        /*INTRODUCIR DATOS*/

        //Aqui encontramos la asignación y le incluimos la pregunta
        public void IncluirPreguntaParaAsignacion(int asignacionId, PreguntaEntity pregunta)
        {
            var asignacion = GetAsignacion(asignacionId, false);
            asignacion.PreguntasDeAsignacion.Add(pregunta);
        }

        //Este metodo nos permite persistir los cambios en las entidades
        public bool SaveChanges()
        {
            return (_context.SaveChanges() >= 0);
        }

        /*ELIMINAR DATOS*/
        //Elimina una pregunta concreta de una asignación
        public void EliminarPreguntaDeAsignacion(PreguntaEntity pregunta)
        {
            _context.Preguntas.Remove(pregunta);
        }
  }
}
