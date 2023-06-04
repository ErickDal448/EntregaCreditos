/* Compatibilidad con github pages */
/* direccionamiento de archivos js de bootstrap */
function getBootstrapBundlePath() {
  let path = '/Bootstrap/node_modules/bootstrap/dist/js/bootstrap.bundle.js';
  if (window.location.hostname === 'erickdal448.github.io') {
    path = '/Proyecto-Creditos' + path;
  }
  return path;
}

function Validar(){
  var numCuenta = document.getElementById("InputNumCuenta1").value;
  var NIP = document.getElementById("NIP1").value;

  fetch(`https://localhost:7220/api/ValidarUsuario/Validar-Usuario?numCuenta=${numCuenta}&nip=${NIP}`,{
  method: "GET"
  })
  .then(Response => Response.json())
  .then(result => {
  // Procesar la respuesta de la API
  if (result.length > 0) {
    // La cuenta del usuario es válida
    console.log("exist");
    console.log(result[0].rol);
    UserInstitucion = result[0].institucion;
    console.log(UserInstitucion);
    if(result[0].rol === "Alumno"){
        console.log(result[0].rol);
        let path = '/Inicio.html';
        window.location.href = path;
    }
    if(result[0].rol === "Editor"){
        console.log(result[0].rol);
        let path = '/InicioEditor.html';
        window.location.href = path; 
    }
    // Dentro de la función Validar, después de obtener los datos de la API
    localStorage.setItem('UserNumCuenta', numCuenta);
    localStorage.setItem('UserInstitucion', result[0].institucion);
    localStorage.setItem('UserRol', result[0].rol);
    localStorage.setItem('UserName', result[0].nombre);
    localStorage.setItem('UserApellidos', result[0].apellidos);
  } else {
  // La cuenta del usuario no es válida
  // Mostrar un mensaje de error al usuario
  alert("Número de cuenta o NIP incorrecto");
  }
  })
  .catch(error => {
  console.error('Error:', error);
  });

}
function handleInputFocusNum(input) {
  if (input.value === "Número de cuenta") {
    input.value = "";
  }
}
function handleInputBlurNum(input) {
  if (input.value === "") {
    input.value = "Número de cuenta";
  }
}

/* mostrar value del apartado NIP y uso del check */
function handleInputFocusNIP(input) {
  if (input.value === "NIP") {
    input.value = "";
  }
  input.type = "password";
}
function handleInputBlurNIP(input) {
  if (input.value === "") {
    input.value = "NIP";
    input.type = "text";
  }
}
function handleCheckboxChange(checkbox) {
  var input = document.getElementById('NIP1');
  if (input.value !== "NIP") {
    if (checkbox.checked) {
      input.type = "text";
    } else {
      input.type = "password";
    }
  }
}

//Actualizar la info de la barra de progreso general
function actualizarBarraDeProgreso() {
  var buttonImage = document.getElementById('button-image');
  var InfoMedalla = document.getElementById('infoMedalla');
  let tope = localStorage.getItem('TopeCreditos');
  let creditos = localStorage.getItem('UserCreditos');
  let Porcentaje = (creditos/tope) * 100;
  // Calcular el porcentaje y actualizar la barra de progreso
  let porcentaje = (creditos / tope) * 100;
  document.getElementById("progress-bar1").style.width = porcentaje + "%";

  if(Porcentaje == 0){
  pathMed = '/Imagenes/FondoMedallas.png'
  document.getElementById("progress-bar1").style.backgroundColor = '#6c6d6c';
  InfoMedalla.textContent = "Nada como empezar a hacer actividades no...";
  }
  else if (Porcentaje <= 20) {
      pathMed = '/Imagenes/MedallaGen1.png';
      document.getElementById("progress-bar1").style.backgroundColor = '#205f14';
      InfoMedalla.textContent = "Vas por el buen camino sigue así...";
  } else if (Porcentaje <= 40) {
      pathMed = '/Imagenes/MedallaGen2.png';
      document.getElementById("progress-bar1").style.backgroundColor = '#736e46';
      InfoMedalla.textContent = "Un buen comienzo, haz lo posible por seguir...";
  } else if (Porcentaje <= 60) {
      pathMed = '/Imagenes/MedallaGen3.png';
      document.getElementById("progress-bar1").style.backgroundColor = '#6e93a3';
      InfoMedalla.textContent = "Ya llevas un poco mas de la mitad, tu puedes...";
  } else if (Porcentaje <= 80) {
      pathMed = '/Imagenes/MedallaGen4.png';
      document.getElementById("progress-bar1").style.backgroundColor = '#bbad44';
      InfoMedalla.textContent = "Ya falta poco un poco más y lo consigues...";
  } else if (Porcentaje >= 80){
      pathMed = '/Imagenes/MedallaGen5.png';
      document.getElementById("progress-bar1").style.backgroundColor = '#0F77A4';
      InfoMedalla.textContent = "Bien hecho haz logrado terminar los creditos...";
  }
  buttonImage.src = pathMed;
}
// Ejecutar la función actualizarBarraDeProgreso cuando la página se cargue
window.onload = actualizarBarraDeProgreso;
// Ejecutar la función actualizarBarraDeProgreso cada 5 segundos


 
