using everisapi.API.Models;
using everisapi.API.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using everisapi.API.Entities;

namespace everisapi.API.Controllers
{
    [Route("api/users")]
    public class ProyectosController : Controller
    {
        //Inyectamos un logger
        private ILogger<ProyectosController> _logger;
        private IUsersInfoRepository _usersInfoRepository;

        //Utilizamos el constructor para inicializar el logger
        public ProyectosController(ILogger<ProyectosController> logger, IUsersInfoRepository usersInfoRepository)
        {
            _logger = logger;
            _usersInfoRepository = usersInfoRepository;
        }

        /*METODOS GET DE PREGUNTAS*/

        [HttpGet("fullproyectos")]
        public IActionResult GetFullProyectos()
        {
            try
            {

                //Recogemos una lista de proyecto del usuario
                var TodosLosProyectos = _usersInfoRepository.GetFullProyectos();

                //Transformamos la lista anterior en una nueva con los datos que necesitamos
                //Ya que otros son relevantes
                var FullResult = Mapper.Map<IEnumerable<ProyectoDto>>(TodosLosProyectos);
                return Ok(FullResult);
            }
            catch (Exception ex)
            {
                _logger.LogCritical("Ocurrio un error al pedir todos los proyectos de todos los usuarios: " + ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }
        }

        //Recoge todos los proyecto de un usuario mediante su nombre
        [HttpGet("{nombreUsuario}/proyectos")]
        public IActionResult GetProyectosUsuario(string nombreUsuario)
        {
            try
            {
                //Comprueba si existe el usuario y si existe manda un json con la información
                //si no existe mandara un error 404 el error 500 aparecera si el servidor falla
                if (!_usersInfoRepository.UserExiste(nombreUsuario))
                {
                    _logger.LogInformation("El usuario con nombre "+ nombreUsuario + " no pudo ser encontrado.");
                    return NotFound();
                }

                //Recogemos una lista de proyecto del usuario
                var ProyectosDeUsuario = _usersInfoRepository.GetProyectosDeUsuario(nombreUsuario);

                //Transformamos la lista anterior en una nueva con los datos que necesitamos
                //Ya que otros son relevantes
                var ProyectosDeUsuarioResult = Mapper.Map<IEnumerable<ProyectoDto>>(ProyectosDeUsuario);
                return Ok(ProyectosDeUsuarioResult);
            }
            catch (Exception ex)
            {
                _logger.LogCritical("Se recogio un error al recibir la petición de proyectos de usuario con nombre " + nombreUsuario + ": " + ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }
        }

        //Este metodo nos permite recoger un proyecto especifico de un usuario
        [HttpGet("{nombreUsuario}/proyectos/{id}", Name = "GetProyecto")]
        public IActionResult GetProyectoUsuario(string nombreUsuario, int id)
        {
            try
            {
                //Comprueba si existe el usuario
                if (!_usersInfoRepository.UserExiste(nombreUsuario))
                {
                    _logger.LogInformation("El usuario con nombre " + nombreUsuario + " no pudo ser encontrado.");
                    return NotFound();
                }

                //Comprueba que el proyecto existe
                var proyectoDeUsuario = _usersInfoRepository.GetOneProyecto(nombreUsuario, id);

                if (proyectoDeUsuario == null)
                {
                    _logger.LogInformation("El proyecto con id " + id + " no pudo ser encontrado.");
                    return NotFound();
                }

                //Creamos un proyecto nuevo con los  datos estrictamente necesarios
                var ProyectoEncontrado = Mapper.Map<ProyectoDto>(proyectoDeUsuario);

                return Ok(ProyectoEncontrado);
            }
            catch (Exception ex)
            {
                _logger.LogCritical("Se recogio un error al recibir la petición de proyecto de usuario con id " + id + " del usuario " + nombreUsuario + ": " + ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }
        }

        [HttpGet("proyecto/{id}")]
        public IActionResult GetProyecto( int id)
        {
            try
            {

                //Comprueba que el proyecto existe
                ProyectoEntity proyectoDeUsuario = _usersInfoRepository.GetFullProject(id);

                if (proyectoDeUsuario == null)
                {
                    _logger.LogInformation("El proyecto con id " + id + " no pudo ser encontrado.");
                    return NotFound();
                }

                //Creamos un proyecto nuevo con los  datos estrictamente necesarios
                var ProyectoEncontrado = Mapper.Map<ProyectoWithEvaluacionesDto>(proyectoDeUsuario);

                return Ok(ProyectoEncontrado);
            }
            catch (Exception ex)
            {
                _logger.LogCritical("Se recogio un error al recibir la petición de proyecto de usuario con id " + id + ": " + ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }
        }
        
    }
}
