export class EvaluacionInfo {
  constructor(
    public id: number,
    public nombre: string,
    public userNombre: string,
    public nPreguntas: number,
    public nRespuestas: number,
    public fecha: string,
    public estado: boolean
  ) { }
}
