<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lecturas en Tiempo Real del MPU6050</title>
    <link rel="stylesheet" href="css/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="scripts/funciones_servidor.js"></script>
</head>
<body>

<div class="container">
    <div id="sidebar"></div>
    <div id="content">
        <h1>Lecturas en Tiempo Real del MPU6050</h1>

        <div class="chart-container">
            <h2>Aceleración en Ejes X, Y, Z</h2>
            <canvas id="accelerationChart" width="400" height="200"></canvas>
        </div>
        
        <h2>Datos del Sensor</h2>
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


        <h2>Respuesta del Servidor</h2>
        <pre id="responseDisplay"></pre>
    </div>
</div>
   

<script>
    const ctx = document.getElementById('accelerationChart').getContext('2d');
    const accelerationChart = new Chart(ctx, {
        type: 'line', // Puedes cambiar el tipo de gráfico según lo necesites
        data: {
            labels: [], // Etiquetas del eje X, que puedes llenar dinámicamente
            datasets: [{
                label: 'Aceleración X',
                data: [], // Datos de aceleración X
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1,
                fill: false,
            },
            {
                label: 'Aceleración Y',
                data: [], // Datos de aceleración Y
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1,
                fill: false,
            },
            {
                label: 'Aceleración Z',
                data: [], // Datos de aceleración Z
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1,
                fill: false,
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    function getData() {
        //const baseURL = 'http://localhost:8080'; // Ajusta según tu entorno
        const baseURL = getBaseURL();
        fetch(`${baseURL}/control/lora`)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Error en la respuesta del servidor");
                }
                return response.json();
            })
            .then(data => {
                console.log("Datos recibidos del servidor:", data);
                // Actualizar el DOM con los datos
                document.getElementById("ax").innerText = `Aceleración X: ${data.ax}`;
                document.getElementById("ay").innerText = `Aceleración Y: ${data.ay}`;
                document.getElementById("az").innerText = `Aceleración Z: ${data.az}`;
                document.getElementById("gx").innerText = `Giroscopio X: ${data.gx}`;
                document.getElementById("gy").innerText = `Giroscopio Y: ${data.gy}`;
                document.getElementById("gz").innerText = `Giroscopio Z: ${data.gz}`;

                // Actualizar los campos de texto
                document.getElementById("inputAx").value = data.ax; // Actualiza el campo de texto para Aceleración X
                document.getElementById("inputAy").value = data.ay; // Actualiza el campo de texto para Aceleración Y
                document.getElementById("inputAz").value = data.az; // Actualiza el campo de texto para Aceleración Z
                document.getElementById("inputGx").value = data.gx; // Actualiza el campo de texto para Giroscopio X
                document.getElementById("inputGy").value = data.gy; // Actualiza el campo de texto para Giroscopio Y
                document.getElementById("inputGz").value = data.gz; // Actualiza el campo de texto para Giroscopio Z
                // Actualizar gráfico
                updateChart(data.ax, data.ay, data.az);
            })
            .catch(error => {
                console.error("Error:", error);
            });
    }

    function updateChart(ax, ay, az) {
        // Agregar nuevas etiquetas y datos al gráfico
        const timestamp = new Date().toLocaleTimeString(); // Usa el timestamp o alguna otra etiqueta
        accelerationChart.data.labels.push(timestamp);
        accelerationChart.data.datasets[0].data.push(ax);
        accelerationChart.data.datasets[1].data.push(ay);
        accelerationChart.data.datasets[2].data.push(az);
        accelerationChart.update(); // Actualiza el gráfico
    }

    // Llama a la función getData cuando la página esté completamente cargada
    window.onload = () => {
        getData(); // Obtener datos al cargar
        setInterval(getData, 2000); // Obtener datos cada 2 segundos
    };
</script>

<script src="menu.js"></script>
</body>
</html>







