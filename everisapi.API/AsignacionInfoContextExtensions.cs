using everisapi.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace everisapi.API
{
    public static class AsignacionInfoContextExtensions
    {
        public static void EnsureSeedDataForContext(this AsignacionInfoContext context)
        {

          /*  if (context.Preguntas.Any() && context.Proyectos.Any())
            {
        
              var Respuestas = new List<RespuestaEntity>
              {
                new RespuestaEntity()
                {
                  Id = 1,
                  Estado = false,
                  PreguntaId = 1,
                  ProyectoId = 1
                },
                new RespuestaEntity()
                {
                  Id = 2,
                  Estado = true,
                  PreguntaId = 2,
                  ProyectoId = 1
                },
                new RespuestaEntity()
                {
                  Id = 3,
                  Estado = false,
                  PreguntaId = 3,
                  ProyectoId = 1
                },
                new RespuestaEntity()
                {
                  Id = 4,
                  Estado = true,
                  PreguntaId = 4,
                  ProyectoId = 1
                },
                new RespuestaEntity()
                {
                  Id = 5,
                  Estado = true,
                  PreguntaId = 5,
                  ProyectoId = 1
                }
              };
                context.Respuestas.AddRange(Respuestas);
                context.SaveChanges();
              }*/
            
            if (context.Sections.Any())
            {
                return;
            }

      var Sections = new List<SectionEntity>()
            {
              new SectionEntity()
              {
                Id = 1,
                Nombre = "CEREMONIAS"
              },
              new SectionEntity()
              {
                Id = 2,
                Nombre = "ROLES"
              },
              new SectionEntity()
              {
                Id = 3,
                Nombre = "ARTEFACTOS"
              }
            };

      //var Asignaciones = new List<AsignacionEntity>(){ };

      /* var Asignaciones = new List<AsignacionEntity>()
       {
           new AsignacionEntity()
           {
               Id = 1,
               Nombre = "Asignacion Verano",
               PreguntasDeAsignacion = new List<PreguntaEntity>()
               {
                   new PreguntaEntity()
                   {
                       Id = 1,
                       Pregunta = "¿Tienes mas calor que en la comunión de charmander?"
                   },
                   new PreguntaEntity()
                   {
                       Id = 2,
                       Pregunta = "¿Vamos a ser contrataos del tiron?"
                   }
               }
           },
           new AsignacionEntity()
           {
               Id = 2,
               Nombre = "Asignacion Primavera"
           },
           new AsignacionEntity()
           {
               Id = 3,
               Nombre = "Asignacion Otoño"
           },
           new AsignacionEntity()
           {
               Id = 4,
               Nombre = "Asignacion Invierno"
           }
       };*/

      var Users = new List<UserEntity>()
            {
                new UserEntity()
                {
                    Nombre= "Admin",
                    Password= "Admin",
                    ProyectosDeUsuario= new List<ProyectoEntity>()
                    {
                        new ProyectoEntity()
                        {
                            Id = 1,
                            Nombre="BSA",
                            Fecha = DateTime.Now.Date,
                            /*Evaluaciones = new List<EvaluacionEntity>()
                            {
                              new EvaluacionEntity()
                              {
                                ProyectoId = 1,
                                Fecha = DateTime.Now,
                                Estado = false
                              },
                              new EvaluacionEntity()
                              {
                                ProyectoId = 1,
                                Fecha = DateTime.Now,
                                Estado = true
                              },
                            }*/
                        },
                        new ProyectoEntity()
                        {
                            Id=2,
                            Nombre="TESCO",
                            Fecha = DateTime.Now.Date
                        }
                    }
                },
                new UserEntity()
                {
                    Nombre= "User",
                    Password= "User",
                    ProyectosDeUsuario= new List<ProyectoEntity>()
                    {
                        new ProyectoEntity()
                        {
                            Id = 3,
                            Nombre="BestDay",
                            Fecha = DateTime.Now.Date
                        },
                        new ProyectoEntity()
                        {
                            Id=4,
                            Nombre="TVE",
                            Fecha = DateTime.Now.Date
                        }
                    }
                }
            };

            var Roles = new List<RoleEntity>()
            {
                new RoleEntity()
                {
                    Id = 1,
                    Role = "Usuario"
                },
                new RoleEntity()
                {
                    Id = 2,
                    Role = "Administrador",
                }
            };

            var User_Roles = new List<User_RoleEntity>()
            {
                new User_RoleEntity()
                {
                    RoleId= 1,
                    UserNombre= "User"
                },
                new User_RoleEntity()
                {
                    RoleId= 1,
                    UserNombre= "Admin"
                },
                new User_RoleEntity()
                {
                    RoleId= 2,
                    UserNombre= "Admin"
                },
            };



            context.Sections.AddRange(Sections);
           // context.Asignaciones.AddRange(Asignaciones);
            context.Users.AddRange(Users);
            context.Roles.AddRange(Roles);
            context.User_Roles.AddRange(User_Roles);
            context.SaveChanges();
        }
    }
}
