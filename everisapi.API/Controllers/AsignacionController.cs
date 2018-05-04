using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using everisapi.API.Models;
using everisapi.API.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using AutoMapper;

namespace everisapi.API.Controllers
{
    [Route("api/asignaciones")]
    public class AsignacionController : Controller
    {

        //Creamos un logger
        private ILogger<AsignacionController> _logger;
        private IAsignacionInfoRepository _asignacionInfoRepository;

        public AsignacionController(ILogger<AsignacionController> logger, IAsignacionInfoRepository asignacionInfoRepository)
        {
            _logger = logger;
            _asignacionInfoRepository = asignacionInfoRepository;

        }

        //Introduciendo la petición de la route devuelve todas las asignaciones y sus preguntas 
        [HttpGet()]
        public IActionResult GetAsignaciones()
        {
            try
            {
                var AsignacionEntities = _asignacionInfoRepository.GetAsignaciones();

                var results = Mapper.Map<IEnumerable<AsignacionSinPreguntasDto>>(AsignacionEntities);

                return Ok(results);
            }
            catch(Exception ex)
            {
                _logger.LogCritical("Se recogio un error al recibir todos los datos de las asignaciones: "+ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }
            
        }

        //Introduciendo la id de la asignacion devuelve una asignación especifica
        [HttpGet("{id}")]
        public IActionResult GetAsignacion(int id, bool IncluirPreguntas = false)
        {
            try {
                //Recoge si existe la asignación si es asi la devuelve si no es así muestra un error
                var Asignacion = _asignacionInfoRepository.GetAsignacion(id, IncluirPreguntas);

                if (Asignacion == null)
                {
                    _logger.LogInformation("La asignación con id "+id+" no pudo ser encontrado.");
                    return NotFound();
                }

                //Si tenemos como parametro recibir sus preguntas las incluira
                //sino lo devolvera sin preguntas
                if (IncluirPreguntas)
                {
                    var AsignacionResult = Mapper.Map<AsignacionDto>(Asignacion);

                    return Ok(AsignacionResult);

                }
                else
                {
                    var AsignacionSinPregunta = Mapper.Map<AsignacionSinPreguntasDto>(Asignacion);

                    return Ok(AsignacionSinPregunta);
                }

            }catch(Exception ex)
            {
                _logger.LogCritical("Se recogio un error al recibir la asignación con id "+id+": "+ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }
        }
    }
}
