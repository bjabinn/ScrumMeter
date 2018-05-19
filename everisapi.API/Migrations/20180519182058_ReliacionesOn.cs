using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Collections.Generic;

namespace everisapi.API.Migrations
{
    public partial class ReliacionesOn : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Proyectos_Users_UserNombre",
                table: "Proyectos");

            migrationBuilder.AlterColumn<string>(
                name: "UserNombre",
                table: "Proyectos",
                nullable: true,
                oldClrType: typeof(string));

            migrationBuilder.AddForeignKey(
                name: "FK_Proyectos_Users_UserNombre",
                table: "Proyectos",
                column: "UserNombre",
                principalTable: "Users",
                principalColumn: "Nombre",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Proyectos_Users_UserNombre",
                table: "Proyectos");

            migrationBuilder.AlterColumn<string>(
                name: "UserNombre",
                table: "Proyectos",
                nullable: false,
                oldClrType: typeof(string),
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Proyectos_Users_UserNombre",
                table: "Proyectos",
                column: "UserNombre",
                principalTable: "Users",
                principalColumn: "Nombre",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
