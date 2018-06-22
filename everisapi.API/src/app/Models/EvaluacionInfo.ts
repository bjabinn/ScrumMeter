export class EvaluacionInfo {
  constructor(
    public id: number,
    public nombre: string,
    public userNombre: string,
    public puntuacion: number,
    public fecha: string,
    public notasEv: string,
    public notasOb: string,
    public estado: boolean
  ) { }
}
