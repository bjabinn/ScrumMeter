using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Collections.Generic;

namespace everisapi.API.Migrations
{
    public partial class EvaluacionesOn : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Respuestas_Proyectos_ProyectoId",
                table: "Respuestas");

            migrationBuilder.RenameColumn(
                name: "ProyectoId",
                table: "Respuestas",
                newName: "EvaluacionId");

            migrationBuilder.RenameIndex(
                name: "IX_Respuestas_ProyectoId",
                table: "Respuestas",
                newName: "IX_Respuestas_EvaluacionId");

            migrationBuilder.CreateTable(
                name: "Evaluaciones",
                columns: table => new
                {
                    Id = table.Column<int>(nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    Estado = table.Column<bool>(nullable: false),
                    Fecha = table.Column<DateTime>(nullable: false),
                    ProyectoId = table.Column<int>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Evaluaciones", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Evaluaciones_Proyectos_ProyectoId",
                        column: x => x.ProyectoId,
                        principalTable: "Proyectos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Evaluaciones_ProyectoId",
                table: "Evaluaciones",
                column: "ProyectoId");

            migrationBuilder.AddForeignKey(
                name: "FK_Respuestas_Evaluaciones_EvaluacionId",
                table: "Respuestas",
                column: "EvaluacionId",
                principalTable: "Evaluaciones",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Respuestas_Evaluaciones_EvaluacionId",
                table: "Respuestas");

            migrationBuilder.DropTable(
                name: "Evaluaciones");

            migrationBuilder.RenameColumn(
                name: "EvaluacionId",
                table: "Respuestas",
                newName: "ProyectoId");

            migrationBuilder.RenameIndex(
                name: "IX_Respuestas_EvaluacionId",
                table: "Respuestas",
                newName: "IX_Respuestas_ProyectoId");

            migrationBuilder.AddForeignKey(
                name: "FK_Respuestas_Proyectos_ProyectoId",
                table: "Respuestas",
                column: "ProyectoId",
                principalTable: "Proyectos",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
