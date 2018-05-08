export class EvaluacionInfo {
  constructor(
    public id: number,
    public nombre: string,
    public userNombre: string,
    public npreguntas: number,
    public nrespuestas: number,
    public fecha: string,
    public estado: boolean
  ) { }
}
