using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using everisapi.API.Entities;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using everisapi.API.Models;

namespace everisapi.API.Services
{
    public class UsersInfoRespository : IUsersInfoRepository
    {

        private AsignacionInfoContext _context;

        //Le damos un contexto en el constructor
        public UsersInfoRespository(AsignacionInfoContext context)
        {
            _context = context;
        }

        //Devuelve un solo proyecto de un usuario
        public ProyectoEntity GetOneProyecto(string userNombre, int proyectoId)
        {
            return _context.Proyectos.Where(p => p.UserNombre == userNombre && p.Id == proyectoId).FirstOrDefault();
        }

        //Recoge todos los proyectos de un usuario
        public IEnumerable<ProyectoEntity> GetProyectosDeUsuario(string userNombre)
        {
            return _context.Proyectos.Where(p => p.UserNombre == userNombre).ToList();
        }

        //Recoge todos los proyectos de todos los usuarios
        public IEnumerable<ProyectoEntity> GetFullProyectos()
        {
            return _context.Proyectos.ToList();
        }

        //Recoge un usuario por su nombre 
        public UserEntity GetUser(string userNombre, bool IncluirProyectos = true)
        {
            if (IncluirProyectos)
            {
                //Si se quiere incluir los proyectos del usuario entrara aquí
                //Incluimos los proyectos del usuario especificada (Include extiende de Microsoft.EntityFrameworkCore)
                return _context.Users.Include(u => u.ProyectosDeUsuario).
                    Where(u => u.Nombre == userNombre).FirstOrDefault();
            }
            else
            {
                //Si no es así devolveremos solo el usuario
                return _context.Users.Include(u => u.User_Role).Where(u => u.Nombre == userNombre).FirstOrDefault();
            }
        }

        //Recoge todos los usuarios
        public IEnumerable<UserEntity> GetUsers()
        {
            //Devolvemos todos los usuarios ordenadas por Nombre
            return _context.Users.OrderBy(c => c.Nombre).ToList();
        }

        //Devuelve si el usuario existe
        public bool UserExiste(string userNombre)
        {
            return _context.Users.Any(u => u.Nombre == userNombre);
        }

        //Devuelve todos los roles de usuario
        public IEnumerable<RoleEntity> GetRolesUsuario(UserEntity usuario)
        {
            var RolesAsignados = _context.User_Roles.Where(ur => ur.User == usuario).ToList();
            List<RoleEntity> RolesEntregar = new List<RoleEntity>();
            foreach (User_RoleEntity usuario_roles in RolesAsignados)
            {
                var Resolver = _context.Roles.Where(r => r.Id == usuario_roles.RoleId).FirstOrDefault();
                RolesEntregar.Add(Resolver);

            }
            return RolesEntregar;
        }

        //Devuelve una lista con todos los datos del proyecto por su id
        public ProyectoEntity GetFullProject(int id)
        {
           return _context.Proyectos.Include(p => p.Evaluaciones).
                    ThenInclude(Evaluacion => Evaluacion.Respuestas).
                    Where(p => p.Id == id).FirstOrDefault();
        }
  }
}
