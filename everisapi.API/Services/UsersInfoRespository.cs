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
      List<ProyectoEntity> proyectos = new List<ProyectoEntity>();
      
      UserEntity usuario = _context.Users.Where(u => u.Nombre == userNombre).FirstOrDefault();
      
      if(usuario.RoleId == (int)Roles.Admin)
      {
        proyectos = _context.Proyectos.OrderBy(p => p.Nombre).ToList();
      }
      else
      {
        var ProyectosUsuario = _context.UserProyectos.Where(up => up.UserNombre == userNombre).ToList();
      
        foreach (UserProyectoEntity userProyecto in ProyectosUsuario){
          var proyecto = _context.Proyectos.Where(p => p.Id == userProyecto.ProyectoId).FirstOrDefault();
          proyectos.Add(proyecto);          
        }  
      }
     
      return proyectos;

    }

    //Recoge todos los proyectos de todos los usuarios
    public IEnumerable<ProyectoEntity> GetFullProyectos()
    {
      return _context.Proyectos.OrderBy(p => p.Nombre).ToList();
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
        return _context.Users.Where(u => u.Nombre == userNombre).FirstOrDefault();
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
    public RoleEntity GetRolesUsuario(UserEntity usuario)
    {
      RoleEntity RolUsuario = new RoleEntity();
      
      RolUsuario = _context.Roles.Where(r => r.Id == usuario.RoleId).FirstOrDefault();        
      
      return RolUsuario;
    }

    //Devuelve una lista con todos los datos del proyecto por su id
    public ProyectoEntity GetFullProject(int id)
    {
      return _context.Proyectos.Include(p => p.Evaluaciones).
               ThenInclude(Evaluacion => Evaluacion.Respuestas).
               Where(p => p.Id == id).FirstOrDefault();
    }

    //Devuelve si el usuario esta bien logeado o no
    public bool UserAuth(UsersSinProyectosDto UserForAuth)
    {
      return _context.Users.Any(u => u.Nombre == UserForAuth.Nombre);
    }

    /*GUARDAR DATOS EN USUARIO*/
    //Aqui introducimos un nuevo usuario
    public bool AddUser(UserEntity usuario)
    {
      _context.Users.Add(usuario);
      return SaveChanges();
    }

    //Este metodo nos permite persistir los cambios en las entidades
    public bool SaveChanges()
    {
      return (_context.SaveChanges() >= 0);
    }

    /*UPDATE USER*/
    //Nos permite modificar un usuario
    public bool AlterUser(UserEntity usuario)
    {
      var UserAlter = _context.Users.Where(u => u.Nombre == usuario.Nombre).FirstOrDefault();
      UserAlter.Nombre = usuario.Nombre;
      UserAlter.Password = usuario.Password;
      
      return SaveChanges();
    }

    /*ELIMINAR DATOS*/
    //Elimina una pregunta concreta de una asignación
    public bool DeleteUser(UserEntity usuario)
    {
      _context.Users.Remove(usuario);
      return SaveChanges();

    }

    //Elimina todos los proyectos y roles de los que depende el usuario
    public void DeleteRolesOrProjects(UserEntity usuario)
    {
      var Usuario = _context.Users.Include(u => u.ProyectosDeUsuario).ThenInclude(p => p.Evaluaciones).Where(u => u.Nombre == usuario.Nombre).FirstOrDefault();
      if (Usuario.ProyectosDeUsuario.Count != 0)
      {        

        foreach (var proyecto in Usuario.ProyectosDeUsuario)
        {
          foreach (var evaluacion in proyecto.Evaluaciones)
          {
            _context.Evaluaciones.Remove(evaluacion);
          }
          _context.Proyectos.Remove(proyecto);
        }
        SaveChanges();
      }
    }

    //Aqui introducimos un nuevo proyecto
    public bool AddProj(ProyectoEntity proyecto)
    {
      _context.Proyectos.Add(proyecto);
      return SaveChanges();
    }

    //Nos permite modificar un proyecto
    public bool AlterProj(ProyectoEntity proyecto)
    {
      var AlterProject = _context.Proyectos.Where(p => p.Id == proyecto.Id).FirstOrDefault();

      AlterProject.Nombre = proyecto.Nombre;
      AlterProject.Fecha = proyecto.Fecha;
      AlterProject.UserNombre = proyecto.UserNombre;

      return SaveChanges();
    }

    //Elimina un proyecto
    public bool DeleteProj(ProyectoEntity proyecto)
    {
      _context.Proyectos.Remove(proyecto);
      return SaveChanges();
    }

    //Devuelve si existe un proyecto
    public bool ProyectoExiste(int ProyectoId)
    {
      return _context.Proyectos.Any(p => p.Id == ProyectoId);
    }

    public bool AddUserToProject(UserEntity usuario, int ProyectoId)
    { 
      UserProyectoEntity userProyecto = new UserProyectoEntity();

      userProyecto.Id = _context.UserProyectos.OrderByDescending(u => u.Id).FirstOrDefault().Id + 1;
      userProyecto.UserNombre = usuario.Nombre;
      userProyecto.ProyectoId = ProyectoId;

      _context.UserProyectos.Add(userProyecto);

      return SaveChanges();
    }

  }
}


