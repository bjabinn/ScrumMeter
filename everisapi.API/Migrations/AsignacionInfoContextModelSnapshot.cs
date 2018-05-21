﻿// <auto-generated />
using everisapi.API.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.EntityFrameworkCore.Storage.Internal;
using System;

namespace everisapi.API.Migrations
{
    [DbContext(typeof(AsignacionInfoContext))]
    partial class AsignacionInfoContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn)
                .HasAnnotation("ProductVersion", "2.0.2-rtm-10011");

            modelBuilder.Entity("everisapi.API.Entities.AsignacionEntity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("Nombre")
                        .IsRequired()
                        .HasMaxLength(50);

                    b.Property<int>("SectionId");

                    b.HasKey("Id");

                    b.HasIndex("SectionId");

                    b.ToTable("Asignaciones");
                });

            modelBuilder.Entity("everisapi.API.Entities.EvaluacionEntity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn);

                    b.Property<bool>("Estado");

                    b.Property<DateTime>("Fecha");

                    b.Property<int>("ProyectoId");

                    b.HasKey("Id");

                    b.HasIndex("ProyectoId");

                    b.ToTable("Evaluaciones");
                });

            modelBuilder.Entity("everisapi.API.Entities.PreguntaEntity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn);

                    b.Property<int>("AsignacionId");

                    b.Property<string>("Pregunta")
                        .IsRequired()
                        .HasMaxLength(120);

                    b.HasKey("Id");

                    b.HasIndex("AsignacionId");

                    b.ToTable("Preguntas");
                });

            modelBuilder.Entity("everisapi.API.Entities.ProyectoEntity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn);

                    b.Property<DateTime>("Fecha");

                    b.Property<string>("Nombre")
                        .IsRequired()
                        .HasMaxLength(50);

                    b.Property<string>("UserNombre");

                    b.HasKey("Id");

                    b.HasIndex("UserNombre");

                    b.ToTable("Proyectos");
                });

            modelBuilder.Entity("everisapi.API.Entities.RespuestaEntity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn);

                    b.Property<bool>("Estado")
                        .HasMaxLength(120);

                    b.Property<int>("EvaluacionId");

                    b.Property<int>("PreguntaId");

                    b.HasKey("Id");

                    b.HasIndex("EvaluacionId");

                    b.HasIndex("PreguntaId");

                    b.ToTable("Respuestas");
                });

            modelBuilder.Entity("everisapi.API.Entities.RoleEntity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("Role")
                        .IsRequired();

                    b.HasKey("Id");

                    b.ToTable("Roles");
                });

            modelBuilder.Entity("everisapi.API.Entities.SectionEntity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("Nombre")
                        .IsRequired()
                        .HasMaxLength(120);

                    b.HasKey("Id");

                    b.ToTable("Sections");
                });

            modelBuilder.Entity("everisapi.API.Entities.User_RoleEntity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn);

                    b.Property<int>("RoleId");

                    b.Property<string>("UserNombre")
                        .IsRequired();

                    b.HasKey("Id");

                    b.HasIndex("RoleId");

                    b.HasIndex("UserNombre");

                    b.ToTable("User_Roles");
                });

            modelBuilder.Entity("everisapi.API.Entities.UserEntity", b =>
                {
                    b.Property<string>("Nombre");

                    b.Property<string>("Password")
                        .IsRequired();

                    b.HasKey("Nombre");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("everisapi.API.Entities.AsignacionEntity", b =>
                {
                    b.HasOne("everisapi.API.Entities.SectionEntity", "SectionEntity")
                        .WithMany("Asignaciones")
                        .HasForeignKey("SectionId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("everisapi.API.Entities.EvaluacionEntity", b =>
                {
                    b.HasOne("everisapi.API.Entities.ProyectoEntity", "ProyectoEntity")
                        .WithMany("Evaluaciones")
                        .HasForeignKey("ProyectoId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("everisapi.API.Entities.PreguntaEntity", b =>
                {
                    b.HasOne("everisapi.API.Entities.AsignacionEntity", "AsignacionEntity")
                        .WithMany("PreguntasDeAsignacion")
                        .HasForeignKey("AsignacionId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("everisapi.API.Entities.ProyectoEntity", b =>
                {
                    b.HasOne("everisapi.API.Entities.UserEntity", "UserEntity")
                        .WithMany("ProyectosDeUsuario")
                        .HasForeignKey("UserNombre");
                });

            modelBuilder.Entity("everisapi.API.Entities.RespuestaEntity", b =>
                {
                    b.HasOne("everisapi.API.Entities.EvaluacionEntity", "EvaluacionEntity")
                        .WithMany("Respuestas")
                        .HasForeignKey("EvaluacionId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.HasOne("everisapi.API.Entities.PreguntaEntity", "PreguntaEntity")
                        .WithMany()
                        .HasForeignKey("PreguntaId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("everisapi.API.Entities.User_RoleEntity", b =>
                {
                    b.HasOne("everisapi.API.Entities.RoleEntity", "Role")
                        .WithMany("User_Role")
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.HasOne("everisapi.API.Entities.UserEntity", "User")
                        .WithMany("User_Role")
                        .HasForeignKey("UserNombre")
                        .OnDelete(DeleteBehavior.Cascade);
                });
#pragma warning restore 612, 618
        }
    }
}
