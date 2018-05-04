using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Collections.Generic;

namespace everisapi.API.Migrations
{
    public partial class MigrationRespuestas2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "RespuestaId",
                table: "Proyectos");

            migrationBuilder.DropColumn(
                name: "RespuestaId",
                table: "Preguntas");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "RespuestaId",
                table: "Proyectos",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "RespuestaId",
                table: "Preguntas",
                nullable: false,
                defaultValue: 0);
        }
    }
}
