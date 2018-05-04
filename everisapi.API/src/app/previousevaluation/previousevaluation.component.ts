import { Component, OnInit } from '@angular/core';
import { Proyecto } from 'app/login/Proyecto';

declare var $:any;

@Component({
  selector: 'app-previousevaluation',
  templateUrl: './previousevaluation.component.html',
  styleUrls: ['./previousevaluation.component.scss']
})
export class PreviousevaluationComponent implements OnInit {
  public clicked: boolean = true;
  public ProyectoBuscado = new Proyecto(null, '', '', null, null, '');
  public ListaDeProyectos: Array<Proyecto>;
  public puntuacion: string;
  public FiltrarCompletados: boolean;
  

  constructor() { }

  ngOnInit() {
    this.Restablecer();
    this.ListaDeProyectos = [new Proyecto(1, 'TESCO', 'User', 100, 100, "12/11/2018"),
      new Proyecto(2, 'BSA', 'Admin', 65, 55, "24/10/2015"),
      new Proyecto(3, 'FacePalms', 'Admin', 100, 100, "09/03/2012"),
      new Proyecto(4, 'NextDay', 'User', 50, 32, "11/01/2016")];
    
  }

  public Restablecer() {
    if (this.clicked) {
      this.clicked = false;
      this.ProyectoBuscado.fecha = "";
      this.ProyectoBuscado.nombre = "";
      this.ProyectoBuscado.usuario = "";
      this.puntuacion = "";
      this.ProyectoBuscado.totalpreguntas = null;
      this.ProyectoBuscado.usuario = "";
      this.FiltrarCompletados = null;
    } else {
      this.clicked = true;
    }
  }

  public Busqueda() {
    var BuscaPersonalizada: Array<Proyecto> = this.ListaDeProyectos;
    if (this.FiltrarCompletados == null) {
      BuscaPersonalizada = this.ListaDeProyectos.filter(x => x.fecha.includes(this.ProyectoBuscado.fecha) &&
        x.nombre.includes(this.ProyectoBuscado.nombre) &&
        x.usuario.includes(this.ProyectoBuscado.usuario) &&
        String(x.puntuacion).includes(this.puntuacion));
    } else {
      if (this.FiltrarCompletados) {
        BuscaPersonalizada = this.ListaDeProyectos.filter(x => x.fecha.includes(this.ProyectoBuscado.fecha) &&
          x.nombre.includes(this.ProyectoBuscado.nombre) &&
          x.usuario.includes(this.ProyectoBuscado.usuario) &&
          String(x.puntuacion).includes(this.puntuacion) &&
          x.puntuacion == x.totalpreguntas);
      } else {
        BuscaPersonalizada = this.ListaDeProyectos.filter(x => x.fecha.includes(this.ProyectoBuscado.fecha) &&
          x.nombre.includes(this.ProyectoBuscado.nombre) &&
          x.usuario.includes(this.ProyectoBuscado.usuario) &&
          String(x.puntuacion).includes(this.puntuacion) &&
          x.puntuacion != x.totalpreguntas);
      }

    }
    
    return BuscaPersonalizada;
  }


  public ChangeFiltro(estado: boolean) {
    this.FiltrarCompletados = estado;
  }

}
