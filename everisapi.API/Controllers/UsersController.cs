using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using everisapi.API.Services;
using everisapi.API.Models;
using Microsoft.Extensions.Logging;

namespace everisapi.API.Controllers
{
    [Route("api/users")]
    public class UsersController : Controller
    {

        //Creamos un logger
        private ILogger<UsersController> _logger;
        private IUsersInfoRepository _userInfoRepository;

        public UsersController(ILogger<UsersController> logger, IUsersInfoRepository userInfoRepository)
        {
            _logger = logger;
            _userInfoRepository = userInfoRepository;

        }

        //Introduciendo la petición de la route devuelve todos los usuarios 
        [HttpGet()]
        public IActionResult GetUsers()
        {
            try
            {
                var UsersEntities = _userInfoRepository.GetUsers();

                var results = Mapper.Map<IEnumerable<UsersSinProyectosDto>>(UsersEntities);
                
                _logger.LogInformation("Mandamos correctamente todos los usuarios");

                return Ok(results);
            }
            catch (Exception ex)
            {
                _logger.LogCritical($"Se recogio un error al recibir todos los datos de los usuarios: "+ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }

        }

        //Introduciendo el nombre de usuario encuentra todos los datos de este si existe
        [HttpGet("{Nombre}")]
        public IActionResult GetUser(String Nombre, bool IncluirProyectos = false)
        {
            try
            {
                //Recoge si existe el usuario si es así la devuelve si no es así muestra un error
                var Usuario = _userInfoRepository.GetUser(Nombre, IncluirProyectos);

                if (Usuario == null)
                {
                    _logger.LogInformation("El usuario con nombre "+Nombre+" no pudo ser encontrado.");
                    return NotFound();
                }

                //Si tenemos como parametro recibir sus proyectos los incluirá
                //sino lo devolverá sin proyectos
                if (IncluirProyectos)
                {
                    var UserResult = Mapper.Map<UsersDto>(Usuario);

                    return Ok(UserResult);

                }
                else
                {
                    var UserSinProyectosResult = Mapper.Map<UsersSinProyectosDto>(Usuario);

                    return Ok(UserSinProyectosResult);
                }

            }
            catch (Exception ex)
            {
                _logger.LogCritical("Se recogio un error al recibir el usuario con nombre "+Nombre+": "+ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }
        }

        //Introduciendo el nombre del usuario recogemos todos sus roles
        [HttpGet("{Nombre}/roles")]
        public IActionResult GetRoles(String Nombre)
        {
            
            try
            {
                //Recoge si existe el usuario y si no es así devolvera un error
                var Usuario = _userInfoRepository.GetUser(Nombre, false);

                if (Usuario == null)
                {
                    _logger.LogInformation("El usuario con nombre " + Nombre + " no pudo ser encontrado recogiendo roles.");
                    return NotFound();
                }
                //Recoge todos los roles para este usuario en específico
                var RolesAsignados = _userInfoRepository.GetRolesUsuario(Usuario);

                //Devolvera sus roles aunque esten vacios
                var RolesResult = Mapper.Map<List<RoleDto>>(RolesAsignados);

                return Ok(RolesResult);

            }
            catch (Exception ex)
            {
                _logger.LogCritical("Se recogio un error al recibir los roles de usuario con nombre " + Nombre + ": " + ex);
                return StatusCode(500, "Un error a ocurrido mientras se procesaba su petición.");
            }
        }
    }
}
