import { Respuesta } from "app/newevaluation/Respuesta";

export class EvaluacionCreate {
  constructor(
    public estado: boolean,
    public proyectoid: number
  ) { }
}
