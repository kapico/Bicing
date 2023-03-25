fetch("/getCoordenadas")
    .then((res) => res.json())
    .then((data) => {
        //console.log(data);
        // All the code for the leaflet map will come here
        const map = L.map("map", {
            center: [41.38879, 2.15899],
            zoom: 14,
        });

        L.tileLayer("https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png", {minZoom: 10}).addTo(map);

        var onMarkerClick = function(){
            //location.href = "/filtrar_bicis";
            //console.log(this.getLatLng());
            fetch("/getBicis", {
                method: 'POST',
                body: JSON.stringify({coord: this.getLatLng()}),
                headers: {'Content-Type':'application/json'}
            })
                .then((res) => res.json())
                .then((data) => {
                    console.log(data);
                     document.querySelector("#bici").style.display = "inline";
                     document.querySelector("#regBTN").style.display = "inline";

                    
                    if(!data[0].Fecha_devolucion){
                        addOptions("bici", data);
                    
                    

                         function addOptions(domElement,data) {
                         var select = document.getElementsByName(domElement)[0];
                         
                        if(select.options.length!=0){
                            for(let i=select.options.length;i>=0;i--){
                                select.remove(i);
                            }
                        }
                        
                            for (value in data) {
                                var option = document.createElement("option");
                                 option.text = data[value].ID_Bici;
                                 select.add(option);
                             }
                        
                        
    
                        }
                    }
                 
                })
        };

        var Icono = L.icon({
            iconUrl: '../Imagenes/popup_icon.png',
        
            iconSize:     [45, 45], // size of the icon
            iconAnchor:   [23.5, 42.5], // point of the icon which will correspond to marker's location
            popupAnchor:  [0, -40] // point from which the popup should open relative to the iconAnchor
        });


        data.forEach(coord => {
            let coma_pos = coord.Coordenadas.search(",");
            let coord1 = coord.Coordenadas.substr(0, coma_pos);
            let coord2 = coord.Coordenadas.substr(coma_pos + 1);
            

            L.marker([coord1, coord2], {icon: Icono}).on('click', onMarkerClick).addTo(map).bindPopup("<b>"+coord.ID_Estacion+"</b><br>"+coord.Localizacion+".");
        });
        
    });
