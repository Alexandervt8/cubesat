// menu.js
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    sidebar.innerHTML =
    `
        <h3 style="color: white;">Menú</h3>
        <ul>
            <li><a href="index.html" class="menu-link">Inicio</a></li>
            <li><a href="monitoreo_satelite.html" class="menu-link">Monitoreo de Satélite</a></li>
            <li><a href="historial_datos.html" class="menu-link">Historial de Datos</a></li>
            <li><a href="vista_graficos.jsp" class="menu-link">Análisis de Parámetros</a></li>
            <li><a href="control_estacion.html" class="menu-link">Control de Estación</a></li>
            <li><a href="configuracion_satelite.html" class="menu-link">Configuración del Satélite</a></li>
            <li><a href="alertas.html" class="menu-link">Alertas</a></li>
        </ul>
    `;
});
