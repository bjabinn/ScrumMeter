using everisapi.API.Entities;
using everisapi.API.Models;
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
    public int GetNumPreguntasFromSection(int idSection, int idEvaluacion)
    {
      return _context.Respuestas.Where(r => r.EvaluacionId == idEvaluacion && r.PreguntaEntity.AsignacionEntity.SectionId == idSection).Count();
    }

    //Devolvemos el numero de preguntas respondidas de la seccion filtrada por proyecto
    public int GetRespuestasCorrectasFromSection(int idSection, int idEvaluacion)
    {
      return _context.Respuestas.Where(r => r.EvaluacionId == idEvaluacion && r.Estado == true && r.PreguntaEntity.AsignacionEntity.SectionId == idSection).Count();
    }

    //Devuelve un objeto estado con información extendida
    public IEnumerable<SectionInfoDto> GetSectionsInfoFromEval(int idEvaluacion)
    {
      //Recoge las respuestas de la evaluación
      List<SectionInfoDto> ListadoSectionInformacion = new List<SectionInfoDto>();
      var Respuestas = _context.Respuestas.
        Include(r => r.PreguntaEntity).
        ThenInclude(rp => rp.AsignacionEntity).
        ThenInclude(rpa => rpa.SectionEntity).
        Where(r => r.EvaluacionId == idEvaluacion).ToList();

      //Saca las en que secciones estuvo en ese momento
      var SectionsUtilizadas = Respuestas.Select(r => r.PreguntaEntity.AsignacionEntity.SectionEntity).Distinct().ToList();


      //Rellena los datos y los añade a la lista para cada sección
      foreach (var section in SectionsUtilizadas)
      {
        SectionInfoDto SectionAdd = new SectionInfoDto();
        SectionAdd.Id = section.Id;
        SectionAdd.Nombre = section.Nombre;
        SectionAdd.Preguntas = Respuestas.Where(r => r.PreguntaEntity.AsignacionEntity.SectionEntity.Id == section.Id).Count();
        SectionAdd.Respuestas = Respuestas.Where(r => r.Estado && r.PreguntaEntity.AsignacionEntity.SectionEntity.Id == section.Id).Count();
        ListadoSectionInformacion.Add(SectionAdd);
      }

      return ListadoSectionInformacion;
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
        //Si no es así devolveremos solo la section
        return _context.Sections.Where(p => p.Id == id).FirstOrDefault();
      }
    }

    //Recoge todas las sections
    IEnumerable<SectionEntity> ISectionsInfoRepository.GetSections()
    {
      return _context.Sections.ToList();
    }

    //Este metodo nos permite persistir los cambios en las entidades
    public bool SaveChanges()
    {
      return (_context.SaveChanges() >= 0);
    }

    //Aqui introducimos una nueva section
    public bool AddSection(SectionEntity section)
    {

      _context.Sections.Add(section);

      return SaveChanges();
    }

    //Nos permite modificar una section
    public bool AlterSection(SectionEntity section)
    {
      var SectionAlter = _context.Sections.Where(s => s.Id == section.Id).FirstOrDefault();

      SectionAlter.Nombre = section.Nombre;

      return SaveChanges();
    }

    //Elimina una section
    public bool DeleteSection(SectionEntity section)
    {

      _context.Sections.Remove(_context.Sections.Where( s => s == section).FirstOrDefault());

      return SaveChanges();
    }

  }
}
