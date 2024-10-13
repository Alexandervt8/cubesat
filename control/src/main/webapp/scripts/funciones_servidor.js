        function getBaseURL() {
            const isLocalhost = location.hostname === "localhost" || location.hostname === "127.0.0.1";
            return isLocalhost ? 'http://localhost:8080' : `http://${location.hostname}:8080`;
        }


        // Coeficientes de calibración (a y b) obtenidos de la calibración del LDR
        const a = 12345; // Valor de ejemplo para el coeficiente a
        const b = -1.234; // Valor de ejemplo para el coeficiente b

        // Función para convertir la resistencia del LDR (ohmios) a lux
        function ldrToLux(resistanceLDR) {
            return a * Math.pow(resistanceLDR, b);
        }

        // Función para convertir lux a irradiancia (W/m²)
        function luxToIrradiance(lux) {
            return lux * 0.0079; // Aproximación para luz solar
        }

        // Función para convertir irradiancia (W/m²) a radiación solar neta (MJ/m²/día)
        function irradianceToRn(irradiance) {
            return irradiance * 0.0864; // Conversión de W/m² a MJ/m²/día
        }

        // Función principal para convertir resistencia LDR a radiación solar neta (MJ/m²/día)
        function RadiacionSolar(resistanceLDR) {
            const lux = ldrToLux(resistanceLDR);
            const irradiance = luxToIrradiance(lux);
            const rad_solar = irradianceToRn(irradiance);
            return rad_solar;
        }

        function fetchPromedios() {
            const baseURL = getBaseURL();
            fetch(`${baseURL}/sensores/etr-data`)
                .then(response => response.json())
                .then(data => {
                    //document.getElementById('promedio-temperatura').textContent = data.temperatura_bmp280 || 'N/A';
                    document.getElementById('promedio-temperatura').textContent = (data.temperatura_dht22 + data.temperatura_bmp280 )/2 || 'N/A';
                    document.getElementById('promedio-humedad-relativa').textContent = data.humedad_relativa || 'N/A';
                    document.getElementById('promedio-radiacion-solar').textContent = RadiacionSolar(data.radiacion_solar) || 'N/A';
                    document.getElementById('promedio-velocidad-viento').textContent = metrosXseg(data.velocidad_viento) || 'N/A';
                    document.getElementById('promedio-presion-atmosferica').textContent = data.presion_atmosferica / 10 || 'N/A';
                })
                .catch(error => {
                    console.error('Error al obtener los promedios:', error);
                    document.getElementById('promedios').textContent = 'Error al obtener los promedios';
                });
        }
        
        function metrosXseg(val) {
            const res = 1000*val/3600;
            return res;
        }

        function fetchConstantes() {
            const baseURL = getBaseURL();
            fetch(`${baseURL}/sensores/constants`)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('constante-lambda').textContent = data.lambda || 'N/A';
                    document.getElementById('constante-delta').textContent = data.delta || 'N/A';
                    document.getElementById('constante-rho').textContent = data.rho || 'N/A';
                    document.getElementById('constante-cp').textContent = data.cp || 'N/A';
                    document.getElementById('constante-gamma').textContent = data.gamma || 'N/A';
                })
                .catch(error => {
                    console.error('Error al obtener las constantes:', error);
                    document.getElementById('constantes').textContent = 'Error al obtener las constantes';
                });
        }

        function calcularETo() {
            const baseURL = getBaseURL();
            const promedios = {
                temperatura: parseFloat(document.getElementById('promedio-temperatura').textContent),
                humedadRelativa: parseFloat(document.getElementById('promedio-humedad-relativa').textContent),
                radiacionSolar: parseFloat(document.getElementById('promedio-radiacion-solar').textContent),
                velocidadViento: parseFloat(document.getElementById('promedio-velocidad-viento').textContent),
                presionAtmosferica: parseFloat(document.getElementById('promedio-presion-atmosferica').textContent)
            };
            const constantes = {
                lambda: parseFloat(document.getElementById('constante-lambda').textContent),
                delta: parseFloat(document.getElementById('constante-delta').textContent),
                rho: parseFloat(document.getElementById('constante-rho').textContent),
                cp: parseFloat(document.getElementById('constante-cp').textContent),
                gamma: parseFloat(document.getElementById('constante-gamma').textContent)
            };

            const parametros = {...promedios, ...constantes};

            fetch(`${baseURL}/sensores/calculateETo`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(parametros)
            })
                .then(response => response.json())
                .then(data => {
                    document.getElementById('eto-calculada').textContent = data.eto || 'N/A';
                })
                .catch(error => {
                    console.error('Error al calcular ETo:', error);
                    document.getElementById('resultado-eto').textContent = 'Error al calcular ETo';
                });
        }
        
        function calcularKC() {
            const valorLisimetro = parseFloat(document.getElementById('valor-lisimetro').value);
            const etoCalculada = parseFloat(document.getElementById('eto-calculada').textContent);

            if (isNaN(valorLisimetro)) {
                alert('Por favor ingrese un valor numérico para el lisímetro.');
                return;
            }

            if (isNaN(etoCalculada)) {
                alert('No se ha calculado ETo aún. Por favor, obtenga primero los promedios y constantes.');
                return;
            }

            const kcCalculado = valorLisimetro / etoCalculada;

            document.getElementById('kc-calculado').textContent = kcCalculado.toFixed(2); // Ajustar según necesidades de formato
            document.getElementById('kc-calculado-2').textContent = kcCalculado.toFixed(2); // Ajustar según necesidades de formato
            document.getElementById('input-lisimetro').textContent = valorLisimetro.toFixed(2); // Mostrar el valor del lisímetro en el span correspondiente
        }
        
        function compararKC() {
            const baseURL = getBaseURL();
            const kcCalculado = parseFloat(document.getElementById('kc-calculado').textContent);
            //const kcCalculado = 0.2;

            if (isNaN(kcCalculado)) {
                alert('No se ha calculado KC aún. Por favor, calcule primero el KC.');
                return;
            }

            fetch(`${baseURL}/sensores/cultivos`)
                .then(response => response.json())
                .then(data => {
                    const cultivosMismoKC = data.filter(cultivo => Math.abs(cultivo[10] - kcCalculado) <= 0.07);
                    const tablaCuerpo = document.getElementById('tabla-cuerpo');
                    tablaCuerpo.innerHTML = '';

                    if (cultivosMismoKC.length > 0) {
                        cultivosMismoKC.forEach(cultivo => {
                            const fila = document.createElement('tr');
                            const cultivoCell = document.createElement('td');
                            cultivoCell.textContent = cultivo[2]; // Nombre del cultivo
                            const variedadCell = document.createElement('td');
                            variedadCell.textContent = cultivo[3]; // Variedad del cultivo
                            const regionCell = document.createElement('td');
                            regionCell.textContent = cultivo[1]; // Región del cultivo
                            const kcCell = document.createElement('td');
                            kcCell.textContent = cultivo[10]; // KC Incial
                            fila.appendChild(cultivoCell);
                            fila.appendChild(variedadCell);
                            fila.appendChild(regionCell);
                            fila.appendChild(kcCell);
                            tablaCuerpo.appendChild(fila);
                        });
                    } else {
                        const filaVacia = document.createElement('tr');
                        const cellVacia = document.createElement('td');
                        cellVacia.colSpan = 4;
                        cellVacia.textContent = 'No se encontraron cultivos con el mismo KC inicial.';
                        filaVacia.appendChild(cellVacia);
                        tablaCuerpo.appendChild(filaVacia);
                    }
                })
                .catch(error => {
                    console.error('Error al obtener los cultivos:', error);
                    document.getElementById('tabla-cultivos').textContent = 'Error al obtener los cultivos';
                });
        }


