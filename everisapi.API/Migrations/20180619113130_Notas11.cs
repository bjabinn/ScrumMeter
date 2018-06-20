using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Collections.Generic;

namespace everisapi.API.Migrations
{
    public partial class Notas11 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.AddColumn<string>(
                name: "Correcta",
                table: "Preguntas",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NotasEvaluacion",
                table: "Evaluaciones",
                maxLength: 1000,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NotasObjetivos",
                table: "Evaluaciones",
                maxLength: 1000,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Peso",
                table: "Asignaciones",
                maxLength: 50,
                nullable: false,
                defaultValue: 0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Correcta",
                table: "Preguntas");

            migrationBuilder.DropColumn(
                name: "NotasEvaluacion",
                table: "Evaluaciones");

            migrationBuilder.DropColumn(
                name: "NotasObjetivos",
                table: "Evaluaciones");

            migrationBuilder.DropColumn(
                name: "Peso",
                table: "Asignaciones");
        }
    }
}
