import MarcarCasillas from "./functions/MarcarCasillas.js";

const respuestas = [
    ["Campo nombre vacío","usuario"],
    ["El nombre de usuario* introducido ya existe!","usuario"],
    ["El email* introducido ya existe!", "email"],
    ["Campo email vacío","email"],
    ["Campo email con formato incorrecto","email"],
    ["Campo contraseña vacío","pass1"],
    ["Campo contraseña con formato incorrecto","pass1"],
    ["Campo confirmar contraseña vacío","pass2"],
    ["Las contraseñas no coinciden","pass2"]
];






// script que recoge los datos del form de registro
// y lo envia a una ruta configurada en el servidor 
// La validacion del formato (vacio, email ok), más adelante!

// escucha el evento de que todos los elementos de HTML se han acabado de cargar o pintar
addEventListener("DOMContentLoaded", () => {
    // cogemos el boton del form por DOM id
    const btn = document.getElementById("regBTN");
    const form = document.querySelectorAll("form");

    btn.addEventListener("click", () =>{
        // guardamos el formulario mediante tag name.Ya que devuelve un array,
        // posicionamos en 0
        const form = document.getElementsByTagName("form")[1];
        // formdata: enviamos en la intancia de la clase, el form, y devuelve
        // un objecto con el mapeo (key:value) del formaulario
        // IMPORTANTE!: la key la configuramos con el atributo "name" en el form HTML
        const formDATA = new FormData(form);
        // convierte esa variable (key:value) en objecto JS
        const data = Object.fromEntries(formDATA);
        // comprobacion

        // Método asincrono moderno que gestiona peticiones y respuestas 
        // para el envio de los datos del form a una ruta de nuestro server
        
        fetch('/bicing_register', {
            method: 'POST',
            body: JSON.stringify(data),
            headers: {'Content-Type':'application/json'}
        })
        .then(res => res.json())
        .then(data => {
            document.getElementById("insertarCAJA").textContent = data;

            if(data==" "){
                location.href = "/bicing_datos_usuario";
            }

            MarcarCasillas(respuestas,data);

        });
    });
});
