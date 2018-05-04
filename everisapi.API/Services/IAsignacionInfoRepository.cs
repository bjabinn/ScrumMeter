﻿using everisapi.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace everisapi.API.Services
{
   public interface IAsignacionInfoRepository
    {
        //Devuelve todas las asignaciones
        IEnumerable<AsignacionEntity> GetAsignaciones();

        //Devuelve una asignación
        AsignacionEntity GetAsignacion(int AsignacionId, Boolean IncluirPreguntas);

        //Devuelve todas las preguntas de una asignación
        IEnumerable<PreguntaEntity> GetPreguntaPorAsignacion(int AsignacionId);

        //Devuelve una pregunta concreta de una asignación
        PreguntaEntity GetPreguntaDeAsignacion(int AsignacionId, int PreguntaId);

        //Devuelve si una asignación existe o no
        bool AsignacionExiste(int AsignacionId);

        //Añadir una pregunta a una ciudad
        void IncluirPreguntaParaAsignacion(int asignacionId, PreguntaEntity pregunta);

        //Guardar cambio de las entidades
        bool SaveChanges();

        //Eliminar preguntas de una asignación
        void EliminarPreguntaDeAsignacion(PreguntaEntity pregunta);
    }
}
