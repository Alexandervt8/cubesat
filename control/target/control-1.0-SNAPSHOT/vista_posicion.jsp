<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lecturas en Tiempo Real del MPU6050</title>
    <link rel="stylesheet" href="css/styles.css">
    <script src="scripts/funciones_servidor.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="scripts/cubeSat.js"></script>

    <!-- Google Charts para velocímetro, temperatura y presion -->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  
</head>
<body>

<div class="container">
    <div id="sidebar"></div>
    <div id="content">
        <h1>Lecturas en Tiempo Real del MPU6050</h1>
        <div id="graficos">
            <div>
                <div class="chart-container">
                    <h2>Aceleración en Ejes X, Y, Z</h2>
                    <canvas id="accelerationChart"></canvas>
                </div>

                <div id="data" style="display: flex; flex-wrap: wrap; gap: 10px;">
                    <div style="display: flex; align-items: center;">
                        <p id="ax">Aceleración X:</p>
                        <input type="text" id="inputAx" placeholder="Valor Aceleración X" style="margin-left: 10px;">
                    </div>
                    <div style="display: flex; align-items: center;">
                        <p id="ay">Aceleración Y:</p>
                        <input type="text" id="inputAy" placeholder="Valor Aceleración Y" style="margin-left: 10px;">
                    </div>
                    <div style="display: flex; align-items: center;">
                        <p id="az">Aceleración Z:</p>
                        <input type="text" id="inputAz" placeholder="Valor Aceleración Z" style="margin-left: 10px;">
                    </div>
                    <div style="display: flex; align-items: center;">
                        <p id="gx">Giroscopio X:</p>
                        <input type="text" id="inputGx" placeholder="Valor Giroscopio X" style="margin-left: 10px;">
                    </div>
                    <div style="display: flex; align-items: center;">
                        <p id="gy">Giroscopio Y:</p>
                        <input type="text" id="inputGy" placeholder="Valor Giroscopio Y" style="margin-left: 10px;">
                    </div>
                    <div style="display: flex; align-items: center;">
                        <p id="gz">Giroscopio Z:</p>
                        <input type="text" id="inputGz" placeholder="Valor Giroscopio Z" style="margin-left: 10px;">
                    </div>
                </div>
            </div>
            <div>
                <div id="cubesat-container" style="width: 600px; height: 300px;"></div>
                <!-- Contenedor para Velocímetro de Viento -->
                <div id="graficos-3">
                    <div>
                    <h4>Medidor de <br>Temperatura</h4>
                    <div id="temperatura-g" style="width: 120px; height: 120px;"></div>
                    </div>
                    <div>
                    <h4>Medidor de <br>Presion</h4>
                    <div id="presion-g" style="width: 120px; height: 120px;"></div>
                    </div>
                    <div>
                    <h4>Medidor de <br>de Altitud</h4>
                    <div id="altitud-g" style="width: 120px; height: 120px;"></div>
                    </div>
                </div>
            </div>
        </div>

        <h2>Respuesta del Servidor</h2>
        <pre id="responseDisplay"></pre>
        
    </div>
</div>
  
<script>
    let altitudChart, temperaturaChart, presionChart; 
    let altitudData, temperaturaData, presionData; 

    google.charts.load('current', {'packages':['gauge']});
    google.charts.setOnLoadCallback(inicializarDatos); // Llamar a inicializar primero

    // Opciones de los gráficos
    let gaugeOptions = {
        width: 120,
        height: 120,
        minorTicks: 5
    };

    // Inicializar los datos
    function inicializarDatos() {
        // Datos iniciales para los gráficos
        temperaturaData = google.visualization.arrayToDataTable([
            ['Label', 'Value'],
            ['Temperatura', 0]  // Valor inicial
        ]);

        presionData = google.visualization.arrayToDataTable([
            ['Label', 'Value'],
            ['Presión', 0]  // Valor inicial
        ]);

        altitudData = google.visualization.arrayToDataTable([
            ['Label', 'Value'],
            ['Altitud', 0]  // Valor inicial
        ]);

        drawCharts(); // Ahora dibuja los gráficos
    }

    // Crear y dibujar los gráficos
    function drawCharts() {
        // Gráfico de Temperatura
        temperaturaChart = new google.visualization.Gauge(document.getElementById('temperatura-g'));
        temperaturaChart.draw(temperaturaData, {
            ...gaugeOptions,
            redFrom: 35,
            redTo: 50,
            yellowFrom: 25,
            yellowTo: 35,
            min: 0,
            max: 50,
            animation: {
                duration: 1000,   // Duración de la animación en milisegundos
                easing: 'out'     // Tipo de animación
            }
        });

        // Gráfico de Presión
        presionChart = new google.visualization.Gauge(document.getElementById('presion-g'));
        presionChart.draw(presionData, {
            ...gaugeOptions,
            greenFrom: 950,
            greenTo: 1050,
            yellowFrom: 850,
            yellowTo: 950,
            redFrom: 800,
            redTo: 850,
            min: 0,
            max: 1050,
            animation: {
                duration: 1000,   // Duración de la animación en milisegundos
                easing: 'out'     // Tipo de animación
            }
        });

        // Gráfico de Altitud
        altitudChart = new google.visualization.Gauge(document.getElementById('altitud-g'));
        altitudChart.draw(altitudData, {
            ...gaugeOptions,
            redFrom: 450,
            redTo: 500,
            yellowFrom: 300,
            yellowTo: 450,
            min: 0,
            max: 500,
            animation: {
                duration: 1000,   // Duración de la animación en milisegundos
                easing: 'out'     // Tipo de animación
            }
        });
        

    }

    // Función para actualizar los datos
    async function actualizarDatos() {
        try {
            const response = await fetch('http://192.168.56.1:8080/control/bmp280');
            if (response.ok) {
                const data = await response.json();

                // Actualizar los gráficos con los nuevos valores
                actualizarTemperatura(data.pressure || 0);  
                actualizarPresion(data.temperature || 0);  
                actualizarAltitud(data.altitude || 0);  

                // Mostrar la respuesta del servidor
                document.getElementById('responseDisplay').textContent = JSON.stringify(data, null, 2);
            } else {
                console.error('Error en la solicitud: ' + response.status);
                document.getElementById('responseDisplay').textContent = 'Error al obtener los datos: ' + response.status;
            }
        } catch (error) {
            console.error('Error en la conexión: ', error);
            document.getElementById('responseDisplay').textContent = 'Error en la conexión: ' + error;
        }
    }

    // Funciones para actualizar los gráficos
    function actualizarTemperatura(temperatura) {
        temperaturaData.setValue(0, 1, temperatura);
        temperaturaChart.draw(temperaturaData);
    }

    function actualizarPresion(presion) {
        presionData.setValue(0, 1, presion);
        presionChart.draw(presionData);
    }

    function actualizarAltitud(altitud) {
        altitudData.setValue(0, 1, altitud);
        altitudChart.draw(altitudData);
    }

    // Actualiza los datos cada 1 segundo
    setInterval(actualizarDatos, 1000);

</script>

<script src="menu.js"></script>
</body>
</html>








