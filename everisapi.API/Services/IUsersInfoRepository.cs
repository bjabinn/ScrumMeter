using everisapi.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace everisapi.API.Services
{
    public interface IUsersInfoRepository
    {
        //Devuelve todos los usuarios
        IEnumerable<UserEntity> GetUsers();

        //Devuelve un usuario
        UserEntity GetUser(string userNombre, Boolean IncluirProyectos);

        //Devuelve todos los proyectos de un usuario
        IEnumerable<ProyectoEntity> GetProyectosDeUsuario(string userNombre);

        //Devuelve un proyecto de un usuario
        ProyectoEntity GetOneProyecto(string userNombre, int proyectoId);

        //Devuelve si un usuario existe o no
        bool UserExiste(string userNombre);

        //Devuelve todos los roles de este usuario
        IEnumerable<RoleEntity> GetRolesUsuario(UserEntity usuario);

        //Devuelve todos los proyectos de todos los usuarios
        IEnumerable<ProyectoEntity> GetFullProyectos();

        //Devuelve un proyecto con todos sus datos
        ProyectoEntity GetFullProject(int id);
  }
}
