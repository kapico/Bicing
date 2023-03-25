import MarcarCasillas from "./functions/MarcarCasillas.js";
$('#tabla').paginate({ limit: 3 });

const respuestas = [
    ["Campo contraseña vacío","pass1"],
    ["Contraseña incorrecta","pass1"]
];

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
        
        fetch('/perfil_usuario', {
            method: 'POST',
            body: JSON.stringify(data),
            headers: {'Content-Type':'application/json'}
        })
        .then(res => res.json())
        .then(data => {
            document.getElementById("insertarCAJA").textContent = data;

            if(data==" "){
                alert("¡Tu cuenta ha sido eliminada correctamente!");
                location.href = "/logout";
            }

            MarcarCasillas(respuestas,data);

        });
    });
});