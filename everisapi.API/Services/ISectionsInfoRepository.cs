using everisapi.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace everisapi.API.Services
{
  public interface ISectionsInfoRepository
  {
    //Devuelve todos los sections
    IEnumerable<SectionEntity> GetSections();

    //Devuelve un section
    SectionEntity GetSection(int id, bool IncluirAsignaciones);

    //Devuelve todas las asignaciones del section
    AsignacionEntity GetAsignacionFromSection(SectionEntity section, int idAsignacion);

    //Devuelve todas las asignaciones de un sector
    IEnumerable<AsignacionEntity> GetAsignacionesFromSection(SectionEntity section);
  }
}
