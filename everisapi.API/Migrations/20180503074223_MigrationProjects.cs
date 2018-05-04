using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Collections.Generic;

namespace everisapi.API.Migrations
{
    public partial class MigrationProjects : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Respuesta",
                table: "Preguntas");

            migrationBuilder.AddColumn<DateTime>(
                name: "Fecha",
                table: "Proyectos",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Fecha",
                table: "Proyectos");

            migrationBuilder.AddColumn<bool>(
                name: "Respuesta",
                table: "Preguntas",
                nullable: false,
                defaultValue: false);
        }
    }
}
