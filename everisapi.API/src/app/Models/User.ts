export class User{

	public nombreUsuario: string;
	public passwordUsuario: string;
	public role: any;

	constructor(
		public nombre: string, 
        public password: string
		){
			this.nombreUsuario = nombre;
			this.passwordUsuario = password
		
		}
}