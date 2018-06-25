export class RespuestaConNotas {
  constructor(
    public estado: number,
    public pregunta: string,
    public notas: string,
    public section: string,
    public asignacion: string
  ) { }
}
