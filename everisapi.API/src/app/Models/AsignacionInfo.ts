
import { PreguntaInfo } from 'app/Models/PreguntaInfo';

export class AsignacionInfo {
  constructor(
    public id: number,
    public nombre: string,
    public preguntas: Array<PreguntaInfo>
  ) { }
}
