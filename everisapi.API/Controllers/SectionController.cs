using everisapi.API.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using AutoMapper;
using everisapi.API.Models;
using everisapi.API.Entities;

namespace everisapi.API.Controllers
{
  [Route("api/sections")]
  public class SectionController: Controller
  {

    //Creamos un logger
    private ILogger<SectionController> _logger;
    private ISectionsInfoRepository _sectionInfoRepository;

    //Utilizamos el constructor para inicializar el logger
    public SectionController(ILogger<SectionController> logger, ISectionsInfoRepository sectionInfoRepository)
    {
      _logger = logger;
      _sectionInfoRepository = sectionInfoRepository;
    }

    //Recogemos todas las sections de la base de datos
    [HttpGet()]
    public IActionResult GetSections()
    {
      try
      {
        var SectionEntities = _sectionInfoRepository.GetSections();

        var results = Mapper.Map<IEnumerable<SectionWithoutAreaDto>>(SectionEntities);

        _logger.LogInformation("Mandamos correctamente todas las sections.");

        return Ok(results);
      }
      catch (Exception ex)
      {
        _logger.LogCritical($"Se recogio un error al recibir todos los datos de las sections: " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    //Introduciendo el nombre de usuario encuentra todos los datos de este si existe
    [HttpGet("{id}")]
    public IActionResult GetSection(int id, bool IncluirAsignaciones = false)
    {
      try
      {
        //Recoge si existe el usuario si es así la devuelve si no es así muestra un error
        var Section = _sectionInfoRepository.GetSection(id, IncluirAsignaciones);

        if (Section == null)
        {
          _logger.LogInformation("La section con id " + id + " no pudo ser encontrado.");
          return NotFound();
        }

        //Si tenemos como parametro recibir sus proyectos los incluirá
        //sino lo devolverá sin proyectos
        if (IncluirAsignaciones)
        {
          var SectionResult = Mapper.Map<SectionDto>(Section);

          return Ok(SectionResult);

        }
        else
        {
          var SectionWithoutAreaResult = Mapper.Map<SectionWithoutAreaDto>(Section);

          return Ok(SectionWithoutAreaResult);
        }

      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir la section con id " + id + ": " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    //Introduciendo el nombre del usuario recogemos todos sus roles
    [HttpGet("{id}/asignaciones")]
    public IActionResult GetAsignacionesFromSection(int id)
    {

      try
      {
        //Comprueba si existe asignación y si existe manda un json con la información
        //si no existe mandara un error 404 el error 500 aparecera si el servidor falla
        SectionEntity sectionExist = _sectionInfoRepository.GetSection(id, true);
        if (sectionExist == null)
        {
          _logger.LogInformation($"La section con id "+ id +" no pudo ser encontrado.");
          return NotFound();
        }

        //Recogemos una lista de preguntas de la asignacion
        var asignacionesDeSection = _sectionInfoRepository.GetAsignacionesFromSection(sectionExist);

        //Transformamos la lista anterior en una nueva con los datos que necesitamos
        //Ya que otros son relevantes
        var AsignacionesResult = Mapper.Map<IEnumerable<AsignacionDto>>(asignacionesDeSection);
        return Ok(AsignacionesResult);

      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir las asignaciones de la section con id " + id + ": " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

  }
}
