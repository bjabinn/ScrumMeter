export class Proyecto{
	constructor(
		public id: number, 
    public nombre: string,
		public fecha: Date,
		public numFinishedEvals:number,
		public numPendingEvals: number
		){}
}
