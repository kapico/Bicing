import MarcarCasillas from "./functions/MarcarCasillas.js";

const respuestas = [
    ["Campo nombre de usuario vacío","usuario"],
    ["Campo contraseña vacío","pass1"],
    ["Contraseña incorrecta","pass1"],
    ["Usuario no registrado en nuestra app","usuario"]
];


// script que recoge los datos del form de registro
// y lo envia a una ruta configurada en el servidor 
// La validacion del formato (vacio, email ok), más adelante!

// escucha el evento de que todos los elementos de HTML se han acabado de cargar o pintar
addEventListener("DOMContentLoaded", () => {
    // cogemos el boton del form por DOM id
    const btn = document.getElementById("regBTN");
    btn.addEventListener("click", () => {
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
        // console.log(data);
        // Método asincrono moderno que gestiona peticiones y respuestas 
        // para el envio de los datos del form a una ruta de nuestro server

        fetch('/bicing_login', {
            method: 'POST',
            body: JSON.stringify(data),
            headers: { 'Content-Type': 'application/json' }
        })
            .then((res) => res.json())
            .then((data) => {
                const cajaValidacion = document.getElementById("insertarCAJA");
                cajaValidacion.textContent = data;
                if (data === " ") {
                    location.href = "/perfil_usuario";
                } else {
                    cajaValidacion.classList.add("error");
                }

                MarcarCasillas(respuestas,data);

            });
    });
});