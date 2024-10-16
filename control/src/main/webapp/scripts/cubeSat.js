// cubeSat.js

    // Variables básicas para Three.js
    let scene, camera, renderer, cubesat;
    
document.addEventListener("DOMContentLoaded", function() {


    function init() {
        // Crear la escena
        scene = new THREE.Scene();
        camera = new THREE.PerspectiveCamera(75, 600 / 400, 0.1, 1000);
        renderer = new THREE.WebGLRenderer();
        renderer.setSize(600, 400);
        
        // Asegurarse de que el contenedor esté disponible antes de intentar agregar el renderer
        const cubesatContainer = document.getElementById('cubesat-container');
        if (cubesatContainer) {
            cubesatContainer.appendChild(renderer.domElement);
        } else {
            console.error("El contenedor 'cubesat-container' no existe.");
            return; // Salir si el contenedor no se encuentra
        }

        // Crear un cubo que representa el Cubesat
        const geometry = new THREE.BoxGeometry(3, 3, 3);
        const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
        cubesat = new THREE.Mesh(geometry, material);
        scene.add(cubesat);
        
        // Crear bordes del Cubesat
        const edges = new THREE.EdgesGeometry(geometry);
        const edgeMaterial = new THREE.LineBasicMaterial({ color: 0x0000ff }); // Color azul
        const edgeMesh = new THREE.LineSegments(edges, edgeMaterial);
        cubesat.add(edgeMesh);

        camera.position.z = 5;
        animate();
    }

    function animate() {
        requestAnimationFrame(animate);
        renderer.render(scene, camera);
    }

    function updateCubesatRotation(gx, gy, gz) {
        cubesat.rotation.x = gx * Math.PI / 180; // Convertir grados a radianes
        cubesat.rotation.y = gy * Math.PI / 180;
        cubesat.rotation.z = gz * Math.PI / 180;
    }

    // Llama a la función getData cada 2 segundos
    setInterval(getData, 2000);

    const ctx = document.getElementById('accelerationChart').getContext('2d');
    const accelerationChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [
                { label: 'Aceleración X', data: [], borderColor: 'rgba(75, 192, 192, 1)', borderWidth: 1, fill: false },
                { label: 'Aceleración Y', data: [], borderColor: 'rgba(255, 99, 132, 1)', borderWidth: 1, fill: false },
                { label: 'Aceleración Z', data: [], borderColor: 'rgba(54, 162, 235, 1)', borderWidth: 1, fill: false }
            ]
        },
        options: {
            scales: {
                y: { beginAtZero: true }
            }
        }
    });

    function getData() {
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
                //document.getElementById("ax").innerText = `Aceleración X: ${data.ax}`;
                document.getElementById("ax").innerText = `Aceleración X: `;
                document.getElementById("ay").innerText = `Aceleración Y: `;
                document.getElementById("az").innerText = `Aceleración Z: `;
                document.getElementById("gx").innerText = `Giroscopio X: `;
                document.getElementById("gy").innerText = `Giroscopio Y: `;
                document.getElementById("gz").innerText = `Giroscopio Z: `;
                
                // Actualizar los campos de texto
                document.getElementById("inputAx").value = data.ax;
                document.getElementById("inputAy").value = data.ay;
                document.getElementById("inputAz").value = data.az;
                document.getElementById("inputGx").value = data.gx;
                document.getElementById("inputGy").value = data.gy;
                document.getElementById("inputGz").value = data.gz;
                // Actualizar gráfico
                updateChart(data.ax, data.ay, data.az);

                // Actualizar la rotación del Cubesat
                updateCubesatRotation(data.gx, data.gy, data.gz);
            })
            .catch(error => {
                console.error("Error:", error);
            });
    }

    function updateChart(ax, ay, az) {
        const timestamp = new Date().toLocaleTimeString(); 
        accelerationChart.data.labels.push(timestamp);
        accelerationChart.data.datasets[0].data.push(ax);
        accelerationChart.data.datasets[1].data.push(ay);
        accelerationChart.data.datasets[2].data.push(az);
        accelerationChart.update();
    }
    // Inicializa la aplicación
    init();
});
