function getSensorData() {
    const baseURL = getBaseURL();  // Obtener la URL base
    fetch(`${baseURL}/control/bmp280`)  // Endpoint para los datos del sensor
        .then(response => {
            if (!response.ok) {
                throw new Error("Error en la respuesta del servidor");
            }
            return response.json();
        })
        .then(data => {
            console.log("Datos recibidos del servidor:", data);
            
            // Actualizar las barras con los valores del sensor
            updateBars(data);

        })
        .catch(error => {
            console.error("Error:", error);
        });
}

function updateBars(data) {
    console.log('updateBars: Actualizando barras con datos:', data);

    // Temperatura
    const temp = parseFloat(data.tmp) || 0; // Directamente desde data.tmp
    console.log(`updateBars: Temperatura recibida: ${temp}`);
    const tempPercentage = Math.min((temp / 100) * 100, 100);
    const tempBar = document.getElementById('temperature-bar');
    if (tempBar) {
        tempBar.style.width = `${tempPercentage}%`;
        tempBar.style.backgroundColor = temp < 40 ? 'green' : temp < 45 ? 'yellow' : 'red';
        document.getElementById('temperature-value').textContent = `${temp}°C`;
    } else {
        console.error('updateBars: No se encontró el elemento temperature-bar');
    }

    // Presión
    const pressure = parseFloat(data.prs) || 800; // Directamente desde data.prs
    console.log(`updateBars: Presión recibida: ${pressure}`);
    const pressurePercentage = Math.min(((pressure - 800) / 400) * 100, 100);
    const pressureBar = document.getElementById('pressure-bar');
    if (pressureBar) {
        pressureBar.style.width = `${pressurePercentage}%`;
        pressureBar.style.backgroundColor =
            pressure < 900 || pressure > 1100
                ? 'red'
                : pressure < 950 || pressure > 1050
                ? 'yellow'
                : 'green';
        document.getElementById('pressure-value').textContent = `${pressure} hPa`;
    } else {
        console.error('updateBars: No se encontró el elemento pressure-bar');
    }

    // Humedad
    const humidity = parseFloat(data.hmd) || 0; // Directamente desde data.hmd
    console.log(`updateBars: Humedad recibida: ${humidity}`);
    const humidityPercentage = Math.min((humidity / 100) * 100, 100);
    const humidityBar = document.getElementById('humidity-bar');
    if (humidityBar) {
        humidityBar.style.width = `${humidityPercentage}%`;
        humidityBar.style.backgroundColor =
            humidity < 20 || humidity > 80
                ? 'red'
                : humidity < 30 || humidity > 60
                ? 'yellow'
                : 'green';
        document.getElementById('humidity-value').textContent = `${humidity}%`;
    } else {
        console.error('updateBars: No se encontró el elemento humidity-bar');
    }
    
    // Radiación Solar
    const radiacion = parseFloat(data.rad) || 0; // Directamente desde data.rad
    console.log(`updateBars: Radiación Solar recibida: ${radiacion}`);
    const radiacionPercentage = Math.min((radiacion / 40) * 100, 100); // Asumiendo un valor máximo de 40 MJ/m²/día
    const radiacionBar = document.getElementById('radiacion-bar');
    if (radiacionBar) {
        radiacionBar.style.width = `${radiacionPercentage}%`;
        radiacionBar.style.backgroundColor =
            radiacion < 10
                ? 'red'
                : radiacion < 20
                ? 'yellow'
                : 'green';
        document.getElementById('radiacion-value').textContent = `${radiacion} MJ/m²/día`;
    } else {
        console.error('updateBars: No se encontró el elemento radiacion-bar');
    }

    // Velocidad del Viento
    const viento = parseFloat(data.vnt) || 0; // Directamente desde data.vnt
    console.log(`updateBars: Velocidad del Viento recibida: ${viento}`);
    const vientoPercentage = Math.min((viento / 20) * 100, 100); // Asumiendo un valor máximo de 20 m/s
    const vientoBar = document.getElementById('velocidad-viento-bar');
    if (vientoBar) {
        vientoBar.style.width = `${vientoPercentage}%`;
        vientoBar.style.backgroundColor =
            viento < 5
                ? 'green'
                : viento < 10
                ? 'yellow'
                : 'red';
        document.getElementById('velocidad-viento-value').textContent = `${viento} m/s`;
    } else {
        console.error('updateBars: No se encontró el elemento velocidad-viento-bar');
    }
}



// Actualizar cada 2 segundos
setInterval(getSensorData, 2000);