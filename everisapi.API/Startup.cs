using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;
using everisapi.API.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using everisapi.API.Services;
using System.IO;

namespace everisapi.API
{
    public class Startup
    {
        //Almacenaremos la configuración de las direcciones
        public static IConfiguration DireccionesConf { get; private set; }

        public Startup(IConfiguration configuracion)
        {
            DireccionesConf = configuracion;
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {

            //MVC
            services.AddMvc();

            //Conexión con DB
            var ConexionActualBD = Startup.DireccionesConf["connectionStrings:DBConnectionString"];
            services.AddDbContext<AsignacionInfoContext>(options =>
            options.UseMySql(ConexionActualBD));

            services.AddScoped<IAsignacionInfoRepository, AsignacionInfoRepository>();
            services.AddScoped<IUsersInfoRepository, UsersInfoRespository>();
            services.AddScoped<ISectionsInfoRepository, SectionsInfoRepository>();
            services.AddScoped<IRespuestasInfoRepository, RespuestasInfoRepository>();
            services.AddScoped<IEvaluacionInfoRepository, EvaluacionInfoRepository>();

    }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory,
            AsignacionInfoContext asignacionInfoContext)
        {
            //Registra eventos en la consola
            loggerFactory.AddConsole();
             
            loggerFactory.AddDebug();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler();
            }

            //Creamos la estructura de la base de datos con sus datos
            asignacionInfoContext.EnsureSeedDataForContext();

            //La aplicación utiliza los codigos para redirigirnos a diferentes vistas
            app.UseStatusCodePages();

            //Realizamos un mapeo de nuestros Dto's y entidades
            AutoMapper.Mapper.Initialize(cfg =>
            {
                cfg.CreateMap<Models.AsignacionSinPreguntasDto, Entities.AsignacionEntity>();
                cfg.CreateMap<Models.EvaluacionCreateUpdateDto, Entities.EvaluacionEntity>();
                cfg.CreateMap<Models.EvaluacionesWithoutRespuestasDto, Entities.EvaluacionEntity>();
                cfg.CreateMap<Models.EvaluacionDto, Entities.EvaluacionEntity>();
                cfg.CreateMap<Models.AsignacionDto, Entities.AsignacionEntity>();
                cfg.CreateMap<Models.PreguntaDto, Entities.PreguntaEntity>();
                cfg.CreateMap<Models.PreguntaWithOneRespuestasDto, Entities.PreguntaEntity>();
                cfg.CreateMap<Models.PreguntaCreateDto, Entities.PreguntaEntity>();
                cfg.CreateMap<Models.PreguntaUpdateDto, Entities.PreguntaEntity>();
                cfg.CreateMap<Models.UsersDto, Entities.UserEntity>();
                cfg.CreateMap<Models.UsersSinProyectosDto, Entities.UserEntity>();
                cfg.CreateMap<Models.ProyectoDto, Entities.ProyectoEntity>();
                cfg.CreateMap<Models.RoleDto, Entities.RoleEntity>();
                cfg.CreateMap<Models.User_RoleDto, Entities.User_RoleEntity>();
                cfg.CreateMap<Models.SectionWithoutAreaDto, Entities.SectionEntity>();
                cfg.CreateMap<Models.SectionDto, Entities.SectionEntity>();
                cfg.CreateMap<Models.RespuestaDto, Entities.RespuestaEntity>();
            });

            //Incluimos todos los cors
            app.UseCors(builder => builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials());

            //Utiliza el modelo MVC
            //app.UseMvc();

            app.Use(async (context, next) => {
                await next();
                if (context.Response.StatusCode == 404 &&
                   !Path.HasExtension(context.Request.Path.Value) &&
                   !context.Request.Path.Value.StartsWith("/api/"))
                {
                    context.Request.Path = "/index.html";
                    await next();
                }
            });

            app.UseMvcWithDefaultRoute();

            app.UseDefaultFiles();
            app.UseStaticFiles();



            //app.Run((context) =>
            //{
            //   throw new Exception("Example exception");
            //});
            // app.Run(async (context) =>
            // {
            //     await context.Response.WriteAsync("Hello World!");
            // });
        }
    }
}
