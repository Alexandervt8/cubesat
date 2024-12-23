// descent.js

// Variables básicas para Three.js
let descentScene, descentCamera, descentRenderer, descentCubesat;
let descentSpeed = 0.2; // Velocidad de descenso (metros por frame)

// Esperar a que el DOM esté completamente cargado
document.addEventListener("DOMContentLoaded", function () {
    // Inicializar la escena
    function init() {
        // Crear la escena
        descentScene = new THREE.Scene();
        descentCamera = new THREE.PerspectiveCamera(75, 400 / 800, 0.1, 1000);
        descentRenderer = new THREE.WebGLRenderer();
        descentRenderer.setSize(400, 600); // Ajustar tamaño del renderizado al contenedor

        // Agregar el renderer al contenedor
        const cubesatContainer = document.getElementById('cubesat-descent-container');
        if (cubesatContainer) {
            cubesatContainer.appendChild(descentRenderer.domElement);  // Usar 'descentRenderer' en lugar de 'renderer'
        } else {
            console.error("El contenedor 'cubesat-descent-container' no existe.");
            return;
        }

        // Crear un Cubesat
        const geometry = new THREE.BoxGeometry(10, 10, 10);
        const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 }); // Un solo color para el Cubesat
        descentCubesat = new THREE.Mesh(geometry, material);
        descentScene.add(descentCubesat);

        // Crear y añadir los ejes
        const axesHelper = new THREE.AxesHelper(50);  // Crea los ejes X, Y, Z
        descentScene.add(axesHelper);

        // Crear etiquetas para los ejes
        createAxisLabels();

        // Configurar la posición inicial del Cubesat y la cámara
        descentCubesat.position.set(0, 100, 0); // Altura inicial de 100 metros
        descentCamera.position.set(110, 110, 110); // Cámara situada para observar el descenso
        descentCamera.lookAt(0, 70, 0);

        animate();
    }

    // Crear las etiquetas para los ejes X, Y y Z
    function createAxisLabels() {
        const fontLoader = new THREE.FontLoader();
        fontLoader.load('https://cdn.jsdelivr.net/npm/three@0.152.0/examples/fonts/helvetiker_regular.typeface.json', function (font) {
            const labelSize = 5;
            const labelHeight = 1;

            // Crear etiquetas principales (X, Y, Z)
            const axesLabels = [
                { text: 'X', position: [60, 0, 0], color: 0x0000ff },
                { text: 'Y', position: [0, 60, 0], color: 0x00ff00 },
                { text: 'Z', position: [0, 0, 60], color: 0xff0000 },
            ];

            axesLabels.forEach(label => {
                const geometry = new THREE.TextGeometry(label.text, {
                    font,
                    size: labelSize,
                    height: labelHeight,
                });
                const material = new THREE.MeshBasicMaterial({ color: label.color });
                const mesh = new THREE.Mesh(geometry, material);
                mesh.position.set(...label.position);
                descentScene.add(mesh);
            });

            // Crear numeración para los ejes
            const numberColor = 0xffffff;

            function createAxisNumbers(axis, range, step, color, font, offset) {
                for (let i = -range; i <= range; i += step) {
                    if (i === 0) continue; // Evitar añadir un 0 en el origen
                    const numberText = i.toString();
                    const numberGeometry = new THREE.TextGeometry(numberText, {
                        font,
                        size: 3, // Tamaño más pequeño para números
                        height: 0.5, // Altura más pequeña
                    });
                    const numberMaterial = new THREE.MeshBasicMaterial({ color });
                    const numberMesh = new THREE.Mesh(numberGeometry, numberMaterial);

                    if (axis === 'x') {
                        numberMesh.position.set(i, offset, 0);
                    } else if (axis === 'y') {
                        numberMesh.position.set(0, i, offset);
                    } else if (axis === 'z') {
                        numberMesh.position.set(offset, 0, i);
                    }

                    descentScene.add(numberMesh);
                }
            }

            // Crear números para cada eje
            const range = 100; // Rango de numeración
            const step = 10; // Incremento entre números
            const offset = 2; // Desplazamiento para evitar superposición

            createAxisNumbers('x', range, step, numberColor, font, 2);
            createAxisNumbers('y', range, step, numberColor, font, 2);
            createAxisNumbers('z', range, step, numberColor, font, 2);
        });
    }


    // Animación del Cubesat
    function animate() {
        requestAnimationFrame(animate);

        // Animar el descenso del Cubesat
        if (descentCubesat.position.y > 0) {
            descentCubesat.position.y -= descentSpeed;
        } else {
            descentCubesat.position.y = 0; // Detenerse al llegar a 0
        }

        descentRenderer.render(descentScene, descentCamera);  // Usar 'descentRenderer' y 'descentScene'
    }

    // Inicializar la escena solo si el contenedor existe
    const cubesatContainer = document.getElementById('cubesat-descent-container');
    if (cubesatContainer) {
        init();
    } else {
        console.error("El contenedor 'cubesat-container' no existe en el DOM.");
    }
});



