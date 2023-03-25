function MarcarCasillas(respuestas,data){
    var casilla;
    for(let i=0;i<respuestas.length;i++){
        casilla = document.getElementById(respuestas[i][1]);
        casilla.style.border = '1px solid black';
        if(data == respuestas[i][0]){
            casilla.style.border = '2px solid red';
            break;
        }
    }
}

export default MarcarCasillas;