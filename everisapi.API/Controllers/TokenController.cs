using everisapi.API.Models;
using everisapi.API.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Novell.Directory.Ldap;


namespace everisapi.API.Controllers
{

    [Route("api/Token")]
    public class TokenController : Controller
    {

        private IConfiguration Configuration;
        private IUsersInfoRepository _usersInfoRespository;

        public TokenController(IConfiguration config, IUsersInfoRepository usersInfoRespository)
        {
            Configuration = config;
            _usersInfoRespository = usersInfoRespository;
        }

        [HttpPost()]
        public IActionResult CreateToken([FromBody] UsersSinProyectosDto UserAuth)
        {
            //In real example use LoginModel, this is just for dummy purpose so that
            //we can focus on relevant code            

            //Comprueba que el body del json es correcto sino devolvera null
            //Si esto ocurre devolveremos un error
            if (UserAuth == null)
            {
                return BadRequest();
            }

            //Si no cumple con el modelo de creación devuelve error
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            //Encriptamos la contraseña
            // using (var sha256 = SHA256.Create())
            // {
            //     // Le damos la contraseña
            //     var hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(UserAuth.Password));
            //     // Recogemos el hash como string
            //     var hash = BitConverter.ToString(hashedBytes).Replace("-", "").ToLower();
            //     // Y se lo damos 
            //     UserAuth.Password = hash;
            // }

            IActionResult response = Unauthorized();

            if (IsUserExistsLDAP(UserAuth.Nombre, UserAuth.Password))
            {
                //Check customer if exists in our database
                if (_usersInfoRespository.UserAuth(UserAuth))
                {
                    //create jwt token here and send it with response
                    var jwtToken = JwtTokenBuilder();
                    response = Ok(new { access_token = jwtToken });
                }else{
                  Entities.UserEntity newUser = new Entities.UserEntity();
                  newUser.Nombre = UserAuth.Nombre;
                  newUser.Password = "default-password";
                  newUser.RoleId = (int)Roles.User;
                  _usersInfoRespository.AddUser(newUser);
                  _usersInfoRespository.AddUserToProject(newUser,5);
                  var jwtToken = JwtTokenBuilder();
                  response = Ok(new { access_token = jwtToken });
                }
            }

            return response;
        }

        private bool IsUserExistsLDAP(string name, string pwd)
        {
            // Metemos los valores de configuración para conectarnos al ldap de Everis.
            int LdapPort = LdapConnection.DEFAULT_PORT;
            //int searchScope = LdapConnection.SCOPE_ONE;
            int LdapVersion = LdapConnection.Ldap_V3;
            //bool attributeOnly=true;
            String[] attrs = { LdapConnection.NO_ATTRS };
            LdapConnection lc = new LdapConnection();
            bool resultado = false;
            // Vamos a meter una restricción de tiempo.
            LdapSearchConstraints constraints = new LdapSearchConstraints();
            constraints.TimeLimit = 10000; // ms
            try
            {
                // Nos conectamos al servidor.
                lc.Connect(Configuration["connectionStrings:LDAPConection"], LdapPort);
                // Accedemos con las credenciales del usuario para ver si está.
                lc.Bind(LdapVersion, Configuration["connectionStrings:LDAPDomain"] + name, pwd);
                lc.Disconnect();
                resultado = true;
            }
            catch (LdapException e)
            {
                if (e.ResultCode == 49)
                {
                    Console.WriteLine("Nombre de usuario correcto, password incorrecto");
                }

                Console.WriteLine($"Error trying LDAP checking. LDAP resultCode message: {e.resultCodeToString()} ; ResultCode: {e.ResultCode}  ;  Error LDAP message: {e.LdapErrorMessage}");
                resultado = false;
            }
            catch (Exception)
            {
                resultado = false;
            }
            return resultado;
        }

        //Metodo para crear tokens
        private object JwtTokenBuilder()
        {
            //Preparamos la clave y las credenciales
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["JWT:key"]));

            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var jwtToken = new JwtSecurityToken(issuer: Configuration["JWT:issuer"],
              audience: Configuration["JWT:audience"], signingCredentials: credentials,
              expires: DateTime.Now.AddYears(19));

            return new JwtSecurityTokenHandler().WriteToken(jwtToken);
        }
    }
}
