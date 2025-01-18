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
    <script src="scripts/descent.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script src="scripts/sensores.js"></script>


  
</head>
<body>

<div class="container">
    <div id="sidebar"></div>
    <div id="content">
        <h1>Lecturas en Tiempo Real del MPU6050</h1>
        <div class="two-columns">
            <div>
                <div class="chart-container">
                    <h2>Aceleración en Ejes X, Y, Z</h2>
                    <canvas class="canvas-400px" id="accelerationChart"></canvas>
                </div>

                <div id="data">
                    <div>
                        <p id="ax">Aceleración X:</p>
                        <input type="text" id="inputAx" placeholder="Valor Aceleración X">
                    </div>
                    <div>
                        <p id="ay">Aceleración Y:</p>
                        <input type="text" id="inputAy" placeholder="Valor Aceleración Y">
                    </div>
                    <div>
                        <p id="az">Aceleración Z:</p>
                        <input type="text" id="inputAz" placeholder="Valor Aceleración Z">
                    </div>
                    <div>
                        <p id="gx">Giroscopio X:</p>
                        <input type="text" id="inputGx" placeholder="Valor Giroscopio X">
                    </div>
                    <div>
                        <p id="gy">Giroscopio Y:</p>
                        <input type="text" id="inputGy" placeholder="Valor Giroscopio Y">
                    </div>
                    <div>
                        <p id="gz">Giroscopio Z:</p>
                        <input type="text" id="inputGz" placeholder="Valor Giroscopio Z">
                    </div>
                </div>
            </div>
            <div>
                <div id="cubesat-container" style="width: 600px; height: 600px; background-color: #000;"></div>
                <!-- Contenedor para Velocímetro de Viento -->
                
            </div>
        </div>

        <!-- Indicadores en tres columnas -->
        <div class="two-columns">
            <div class="sensor-container">
                <div class="sensor">
                    <label>Temperatura (°C):</label>
                    <div class="bar-container">
                        <div class="bar" id="temperature-bar"></div>
                    </div>
                    <span id="temperature-value">100 °C</span>
                </div>
                <div class="sensor">
                    <label>Presión (hPa):</label>
                    <div class="bar-container">
                        <div class="bar" id="pressure-bar"></div>
                    </div>
                    <span id="pressure-value">800 hPa</span>
                </div>
                <div class="sensor">
                    <label>Humedad (%):</label>
                    <div class="bar-container">
                        <div class="bar" id="humidity-bar"></div>
                    </div>
                    <span id="humidity-value">0 %</span>
                </div>
                <div class="sensor">
                    <label>Radiacion Solar (MJ/m&sup2;/día):</label>
                    <div class="bar-container">
                        <div class="bar" id="radiacion-bar"></div>
                    </div>
                    <span id="radiacion-value">0 MJ/m&sup2;/día</span>
                </div>
                <div class="sensor">
                    <label>Velocidad del Viento (m/s):</label>
                    <div class="bar-container">
                        <div class="bar" id="velocidad-viento-bar"></div>
                    </div>
                    <span id="velocidad-viento-value">10 m/s</span>
                </div>
            </div>
            <div>
                <h2>Simulación de Descenso del CubeSat</h2>
                <div id="cubesat-descent-container" style="width: 600px; height: 600px; background-color: #000;"></div>
            </div>

        </div>

        <h2>Respuesta del Servidor</h2>
        <pre id="responseDisplay"></pre>
        
    </div>
</div>

<script src="menu.js"></script>
</body>
</html>








