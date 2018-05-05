using everisapi.API.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace everisapi.API.Services
{
  public class SectionsInfoRepository : ISectionsInfoRepository
  {

    private AsignacionInfoContext _context;

    //Constructor genera el context
    public SectionsInfoRepository(AsignacionInfoContext context)
    {
      _context = context;
    }

    //Devolvemos el numero de preguntas de la seccion filtrada por proyecto
    public int GetNumPreguntasFromSection(int idSection, int idProyecto)
    {
      return _context.Respuestas.Where( r => r.ProyectoId == idProyecto && r.PreguntaEntity.AsignacionEntity.SectionId == idSection).Count();
    }

    //Devolvemos el numero de preguntas respondidas de la seccion filtrada por proyecto
    public int GetRespuestasCorrectasFromSection(int idSection, int idProyecto)
    {
      return _context.Respuestas.Where(r => r.ProyectoId == idProyecto && r.Estado == true && r.PreguntaEntity.AsignacionEntity.SectionId == idSection).Count();
    }

    //Devolvemos las asignaciones de una section
    IEnumerable<AsignacionEntity> ISectionsInfoRepository.GetAsignacionesFromSection(SectionEntity section)
    {
      var sectionSelected = _context.Sections.Where(p => p == section).FirstOrDefault();
      return sectionSelected.Asignaciones;
    }

    //Encuentra una asignacion filtrada por una section y la id de esa asignación
    AsignacionEntity ISectionsInfoRepository.GetAsignacionFromSection(SectionEntity section, int idAsignacion)
    {
      var sectionSelected = _context.Sections.Where(p => p == section).FirstOrDefault();
      return sectionSelected.Asignaciones.Where(a => a.Id == idAsignacion).FirstOrDefault();
    }


    //Recoge una sección por su id y puedes incluir las sections o no
    SectionEntity ISectionsInfoRepository.GetSection(int id, bool IncluirAsignaciones)
    {

      if (IncluirAsignaciones)
      {
        //Si se quiere incluir las asignaciones de la section entrara aquí
        //Incluimos las asignaciones de la section especificada (Include extiende de Microsoft.EntityFrameworkCore)
        return _context.Sections.Include(s => s.Asignaciones).
            Where(s => s.Id == id).FirstOrDefault();
      }
      else
      {
        //Si no es así devolveremos solo el usuario
        return _context.Sections.Where(p => p.Id == id).FirstOrDefault();
      }
    }

    //Recoge todas las sections
    IEnumerable<SectionEntity> ISectionsInfoRepository.GetSections()
    {
      return _context.Sections.ToList();
    }
  }
}
