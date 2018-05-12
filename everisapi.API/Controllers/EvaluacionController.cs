using everisapi.API.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using everisapi.API.Models;

namespace everisapi.API.Controllers
{
    [Route("api/evaluaciones")]
    public class EvaluacionController: Controller
    {

    //Inyectamos un logger
    private ILogger<EvaluacionController> _logger;
    private IEvaluacionInfoRepository _evaluacionInfoRepository;

    //Utilizamos el constructor para inicializar el logger
    public EvaluacionController(ILogger<EvaluacionController> logger, IEvaluacionInfoRepository evaluacionInfoRepository)
    {
      _logger = logger;
      _evaluacionInfoRepository = evaluacionInfoRepository;
    }

    [HttpGet()]
    public IActionResult GetEvaluaciones()
    {
      try
      {
        var EvaluacionesEntities = _evaluacionInfoRepository.GetEvaluaciones();

        var results = Mapper.Map<IEnumerable<EvaluacionesWithoutRespuestasDto>>(EvaluacionesEntities);

        return Ok(results);
      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir todos los datos de las evaluaciones: " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    //Introduciendo la id de la evaluación devuelve una evaluación especifica
    [HttpGet("{id}")]
    public IActionResult GetEvaluacion(int id, bool IncluirRespuestas = false)
    {
      try
      {
        //Recoge si existe la evaluación si es asi la devuelve si no es así muestra un error
        var Evaluacion = _evaluacionInfoRepository.GetEvaluacion(id, IncluirRespuestas);

        if (Evaluacion == null)
        {
          _logger.LogInformation("La evaluación con id " + id + " no pudo ser encontrado.");
          return NotFound();
        }

        //Si tenemos como parametro recibir sus preguntas las incluira
        //sino lo devolvera sin respuestas
        if (IncluirRespuestas)
        {
          var EvaluacionResult = Mapper.Map<EvaluacionDto>(Evaluacion);

          return Ok(EvaluacionResult);

        }
        else
        {
          var EvaluacionResult = Mapper.Map<EvaluacionesWithoutRespuestasDto>(Evaluacion);

          return Ok(EvaluacionResult);
        }

      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir la evaluación con id " + id + ": " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    //Introduciendo la id de la evaluación devuelve una evaluación especifica
    [HttpGet("proyecto/{id}/info")]
    public IActionResult GetEvaluacionInfo(int id)
    {
      try
      {
        //Recoge si existe la evaluación si es asi la devuelve si no es así muestra un error
        var EvaluacionInfo = _evaluacionInfoRepository.GetEvaluationInfo(id);

        if (EvaluacionInfo == null)
        {
          _logger.LogInformation("La evaluación información con id " + id + " no pudo ser encontrado.");
          return NotFound();
        }

        return Ok(EvaluacionInfo);
      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir la evaluación con toda su información con id " + id + ": " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    //Introduciendo la id de la evaluación devuelve una evaluación especifica
    [HttpGet("proyecto/{id}/info/page/{pageNumber}")]
    public IActionResult GetEvaluacionInfoAndPage(int id, int pageNumber)
    {
      try
      {
        //Recoge si existe la evaluación si es asi la devuelve si no es así muestra un error
        var EvaluacionInfo = _evaluacionInfoRepository.GetEvaluationInfoAndPage(id, pageNumber);

        if (EvaluacionInfo == null)
        {
          _logger.LogInformation("La evaluación información con id " + id + " no pudo ser encontrado.");
          return NotFound();
        }

        return Ok(EvaluacionInfo);
      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir la evaluación con toda su información con id " + id + ": " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    [HttpGet("proyecto/{id}")]
    public IActionResult GetEvaluacionFromProject(int id)
    {
      try
      {
        //Recoge si existe la evaluación si es asi la devuelve si no es así muestra un error
        var Evaluacion = _evaluacionInfoRepository.GetEvaluacionesFromProject(id);

        if (Evaluacion == null)
        {
          _logger.LogInformation("La evaluación con id " + id + " no pudo ser encontrado.");
          return NotFound();
        }

          return Ok(Evaluacion);

      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir la evaluación con id " + id + ": " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    [HttpGet("proyecto/{id}/continue")]
    public IActionResult GetIncompleteEvaluationFromProject(int id)
    {
      try
      {
        //Recoge si existe la evaluación si es asi la devuelve si no es así muestra un error
        var Evaluacion = _evaluacionInfoRepository.EvaluationIncompletaFromProject(id);

        return Ok(Evaluacion);

      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir la evaluación con id " + id + ": " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    //Este metodo nos permite introducir una evaluación
    [HttpPost()]
    public IActionResult CreateEvaluacion([FromBody] EvaluacionCreateUpdateDto EvaluacionRecogida)
    {
      try
      {
        //Comprueba que el body del json es correcto sino devolvera null
        //Si esto ocurre devolveremos un error
        if (EvaluacionRecogida == null)
        {
          return BadRequest();
        }


        //Hacemos un mapeo de la evaluación que recogimos
        var IngresarEvaluacion = Mapper.Map<Entities.EvaluacionEntity>(EvaluacionRecogida);

        //La incluimos en la evaluación
        _evaluacionInfoRepository.IncluirEvaluacion(IngresarEvaluacion);

        //Guardamos los cambios a la entidad y esta debera devolver si es correcta o no
        if (!_evaluacionInfoRepository.SaveChanges())
        {
          _logger.LogCritical("Ocurrio un error al guardar los cambios cuando intentamos incluir una evaluacion");
          return StatusCode(500, "Ocurrio un problema en la petición.");
        }

        var EvaluationIngresada = Mapper.Map<Models.EvaluacionesWithoutRespuestasDto>(IngresarEvaluacion);

        return Ok(EvaluationIngresada);
      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir la petición de creación de evaluacion: " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

    //Este metodo nos permite cambiar una evaluación
    [HttpPut()]
    public IActionResult UpdateEvaluacion([FromBody] EvaluacionCreateUpdateDto EvaluacionRecogida)
    {
      try
      {
        //Comprueba que el body del json es correcto sino devolvera null
        //Si esto ocurre devolveremos un error
        if (EvaluacionRecogida == null)
        {
          return BadRequest();
        }

        //Si no cumple con el modelo de update devuelve error
        if (!ModelState.IsValid)
        {
          return BadRequest(ModelState);
        }

        //Hacemos un mapeo de la evaluación que recogimos
        var ModificarEvaluacion = Mapper.Map<Entities.EvaluacionEntity>(EvaluacionRecogida);

        //La incluimos en la evaluación
        _evaluacionInfoRepository.ModificarEvaluacion(ModificarEvaluacion.Id, ModificarEvaluacion);

        //Guardamos los cambios a la entidad y esta debera devolver si es correcta o no
        if (!_evaluacionInfoRepository.SaveChanges())
        {
          _logger.LogCritical("Ocurrio un error al guardar los cambios cuando intentamos modificar una evaluacion con id: "+ ModificarEvaluacion.Id);
          return StatusCode(500, "Ocurrio un problema en la petición.");
        }


        return Ok("La evaluación fue modificada correctamente.");
      }
      catch (Exception ex)
      {
        _logger.LogCritical("Se recogio un error al recibir la petición de modificacion de evaluacion: " + ex);
        return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
      }
    }

  }
}
