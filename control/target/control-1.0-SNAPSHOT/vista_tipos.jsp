<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Visualización de Datos Meteorológicos</title>
    <link rel="stylesheet" href="css/styles.css">
    <!-- Chart.js para gráficos -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Plotly.js para el gráfico de burbujas y dispersión -->
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    <!-- Leaflet.js para el mapa geoespacial -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <!-- Google Charts para velocímetro -->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
</head>
<body>
    <div id="sidebar"></div>
    <div id="content">
    <div id="graficos">
        <h1>Visualización de Datos Meteorológicos</h1>

        <!-- Gráfico de Línea (Temperatura a lo largo del tiempo) -->
        <div class="chart-container">
            <h2>Gráfico de Línea (Evolución de la Temperatura)</h2>
            <canvas id="lineChart"></canvas>
        </div>

        <!-- Gráfico de Barras Apiladas -->
        <div class="chart-container">
            <h2>Gráfico de Barras Apiladas (Radiación Solar y Temperatura)</h2>
            <canvas id="stackedBarChart"></canvas>
        </div>

        <!-- Gráfico de Radar (Comparación de Parámetros Meteorológicos) -->
        <div class="chart-container">
            <h2>Gráfico de Radar (Comparación de Parámetros)</h2>
            <canvas id="radarChart"></canvas>
        </div>

        <!-- Gráfico de Dona (Distribución de Sensores Utilizados) -->
        <div class="chart-container">
            <h2>Gráfico de Dona (Distribución de Sensores)</h2>
            <canvas id="doughnutChart"></canvas>
        </div>

        <!-- Gráfico de Burbuja (Relación Velocidad del Viento, Temperatura, Humedad) -->
        <div id="bubbleChart" class="chart-container">
            <h2>Gráfico de Burbuja (Relación Velocidad del Viento, Temperatura, Humedad)</h2>
        </div>

        <!-- Gráfico de Dispersión (Relación entre Temperatura y Humedad) -->
        <div id="scatterChart" class="chart-container">
            <h2>Gráfico de Dispersión (Temperatura vs Humedad)</h2>
        </div>

        <!-- Contenedor para Mapa Geoespacial -->
        <div class="chart-container">
            <h2>Mapa Geoespacial</h2>
            <div id="map" style="width: 100%; height: 400px;"></div>
        </div>

        <!-- Contenedor para Velocímetro de Viento -->
        <div class="chart-container">
            <h2>Velocímetro de Viento</h2>
            <div id="velocimetro" style="width: 400px; height: 120px;"></div>
        </div>

        <!-- Contenedor para Mapa de Calor -->
        <div class="chart-container">
            <h2>Mapa de Calor de Temperatura</h2>
            <canvas id="heatmap"></canvas>
        </div>

        <!-- Contenedor para Diagrama de Caja y Bigotes -->
        <div id="boxplot" class="chart-container">
            <h2>Diagrama de Caja y Bigotes</h2>
        </div>
    </div>
    </div>

    <script>
        // Gráfico de Barras Apiladas (Chart.js)
        const ctxBar = document.getElementById('stackedBarChart').getContext('2d');
        const stackedBarChart = new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: ['Enero', 'Febrero', 'Marzo', 'Abril'],
                datasets: [{
                    label: 'Temperatura',
                    data: [10, 20, 30, 40],
                    backgroundColor: 'rgba(255, 99, 132, 0.7)'
                }, {
                    label: 'Radiación Solar',
                    data: [15, 25, 35, 45],
                    backgroundColor: 'rgba(54, 162, 235, 0.7)'
                }]
            },
            options: {
                scales: {
                    x: { stacked: true },
                    y: { stacked: true }
                }
            }
        });

        // Mapa Geoespacial (Leaflet.js)
        const map = L.map('map').setView([-12.0464, -77.0428], 13); // Lima, Perú
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);
        L.marker([-12.0464, -77.0428]).addTo(map).bindPopup('Estación Meteorológica').openPopup();

        // Velocímetro (Google Charts)
        google.charts.load('current', {'packages':['gauge']});
        google.charts.setOnLoadCallback(drawGauge);
        function drawGauge() {
            var data = google.visualization.arrayToDataTable([['Label', 'Value'], ['Viento (m/s)', 12]]);
            var options = { width: 400, height: 120, redFrom: 15, redTo: 20, yellowFrom: 10, yellowTo: 15, minorTicks: 5 };
            var chart = new google.visualization.Gauge(document.getElementById('velocimetro'));
            chart.draw(data, options);
        }

        // Mapa de Calor (Chart.js)
        const ctxHeatmap = document.getElementById('heatmap').getContext('2d');
        const heatmapChart = new Chart(ctxHeatmap, {
            type: 'bar', // Usamos 'bar' como representación de un heatmap
            data: {
                labels: ['Lunes', 'Martes', 'Miércoles', 'Jueves'],
                datasets: [{
                    label: 'Temperatura',
                    data: [10, 20, 30, 40],
                    backgroundColor: function(ctx) {
                        const value = ctx.dataset.data[ctx.dataIndex];
                        return value > 30 ? 'red' : 'blue';
                    }
                }]
            },
            options: {
                scales: {
                    x: { ticks: { callback: value => value + '°C' } }
                }
            }
        });

        // Diagrama de Caja y Bigotes (Plotly.js)
        var dataBoxPlot = [{
            y: [10, 15, 13, 17, 22, 25, 30],
            type: 'box',
            name: 'Temperatura',
            boxpoints: 'all'
        }];
        Plotly.newPlot('boxplot', dataBoxPlot);

        // Gráfico de Línea (Chart.js)
        const ctxLine = document.getElementById('lineChart').getContext('2d');
        const lineChart = new Chart(ctxLine, {
            type: 'line',
            data: {
                labels: ['10:00', '12:00', '14:00', '16:00', '18:00'],
                datasets: [{
                    label: 'Temperatura (°C)',
                    data: [20, 22, 25, 28, 24],
                    borderColor: 'rgba(75, 192, 192, 1)',
                    fill: false
                }]
            }
        });

        // Gráfico de Radar (Chart.js)
        const ctxRadar = document.getElementById('radarChart').getContext('2d');
        const radarChart = new Chart(ctxRadar, {
            type: 'radar',
            data: {
                labels: ['Temperatura', 'Humedad', 'Radiación', 'Viento', 'Presión'],
                datasets: [{
                    label: 'Parámetros Meteorológicos',
                    data: [25, 70, 800, 12, 1015],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)'
                }]
            }
        });

        // Gráfico de Dona (Chart.js)
        const ctxDoughnut = document.getElementById('doughnutChart').getContext('2d');
        const doughnutChart = new Chart(ctxDoughnut, {
            type: 'doughnut',
            data: {
                labels: ['Temperatura', 'Humedad', 'Radiación Solar', 'Velocidad del Viento', 'Presión'],
                datasets: [{
                    data: [10, 20, 15, 30, 25],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)'
                    ]
                }]
            }
        });

        // Gráfico de Burbuja (Plotly.js)
        var dataBubble = [{
            x: [1, 2, 3, 4, 5],
            y: [10, 15, 13, 17, 22],
            mode: 'markers',
            marker: {
                size: [40, 60, 80, 100, 120],
                color: 'rgba(75, 192, 192, 0.5)'
            }
        }];
        Plotly.newPlot('bubbleChart', dataBubble);

        // Gráfico de Dispersión (Plotly.js)
        var dataScatter = [{
            x: [1, 2, 3, 4, 5],
            y: [10, 15, 13, 17, 22],
            mode: 'markers',
            type: 'scatter'
        }];
        Plotly.newPlot('scatterChart', dataScatter);
    </script>
    <script src="menu.js"></script> <!-- Ruta correcta al archivo JavaScript del menú -->
</body>
</html>
