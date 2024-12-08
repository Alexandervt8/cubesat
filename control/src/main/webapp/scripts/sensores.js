async function fetchSensorData() {
    try {
        const response = await fetch('http://localhost:8080/control/bmp280');
        if (response.ok) {
            const data = await response.json();
            updateBars(data);
        } else {
            console.error('Error al obtener datos del sensor:', response.statusText);
        }
    } catch (error) {
        console.error('Error al conectar con el servlet:', error);
    }
}

function updateBars(data) {
    console.log('updateBars: Actualizando barras con datos:', data);

    // Parsear los valores de las cadenas recibidas
    const temp = parseFloat(data.temperature.split('=')[1]) || 0;
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

    const pressure = parseFloat(data.pressure.split('=')[1]) || 800;
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

    const humidity = parseFloat(data.humidity.split('=')[1]) || 0;
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
}


// Actualizar cada 2 segundos
setInterval(fetchSensorData, 2000);