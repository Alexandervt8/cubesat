import requests
import random
import time
import math

# URLs de destino
url_netbeans = 'http://192.168.0.7:8080/control/bmp280'  # URL del servlet en NetBeans
url_nodejs = 'http://localhost:3001/control/bmp280'  # URL del servidor Node.js
#url = 'http://192.168.3.64:8080/control/bmp280'

# Constantes de la simulación
g = 9.81  # Aceleración debido a la gravedad (m/s²)
m = 0.3  # Masa del cubesat en kg
Cd = 1.1  # Coeficiente de arrastre del paracaídas
A = 0.4  # Área de sección transversal del paracaídas en m² (ajustar según el paracaídas real)
h_inicial = 100  # Altitud inicial en metros

# Variables de simulación
altitud = h_inicial  # Altitud inicial
velocidad = 0  # Velocidad inicial en m/s
tiempo = 0  # Tiempo transcurrido en segundos

# Función para generar los datos simulados de temperatura y presión
def generar_datos_simulados():
    temperatura = round(random.uniform(0.0, 100.0), 2)  # Temperatura entre 0 y 100 grados Celsius
    presion = round(random.uniform(950, 1050.0), 2)   # Presión entre 950 y 1050 hPa
    return temperatura, presion

# Función para generar los datos simulados de radiación solar y velocidad del viento
def generar_datos_simulados_radiacion_viento():
    radiacion_solar = round(random.uniform(0.0, 30.0), 2)  # Radiación solar entre 0 y 30 MJ/m²/día
    velocidad_viento = round(random.uniform(0.0, 20.0), 2)  # Velocidad del viento entre 0 y 20 m/s
    return radiacion_solar, velocidad_viento

# Función para calcular la altitud de acuerdo a la simulación de caída con paracaídas
def calcular_altitud(t):
    global altitud, velocidad
    velocidad_terminal = (g * m) / (Cd * A)
    velocidad = velocidad_terminal * (1 - math.exp(-Cd * A * t / m))
    altitud = h_inicial - velocidad * t
    if altitud < 0:
        altitud = 0
    return altitud, velocidad

# Función para enviar los datos al servlet
def enviar_datos():
    global tiempo
    while True:
        altitud, velocidad = calcular_altitud(tiempo)
        temperatura, presion = generar_datos_simulados()
        radiacion, velocidad_viento = generar_datos_simulados_radiacion_viento()
        # Construir la cadena de datos con todos los valores
        data = (
            f"data=tmp={round(temperatura, 1)},"
            f"prs={round(presion, 1)},"
            f"hmd={round(random.uniform(30.0, 70.0), 1)},"
            f"rad={round(radiacion, 1)},"
            f"vnt={round(velocidad_viento, 1)},"
            f"alt={round(altitud, 1)}"
        )
        
        headers = {"Content-Type": "application/x-www-form-urlencoded"}

        # Enviar datos al servlet en NetBeans
        try:
            response_netbeans = requests.post(url_netbeans, data=data, headers=headers)
            if response_netbeans.status_code == 200:
                print(f"✅ Datos enviados a NetBeans: {data}")
            else:
                print(f"⚠️ Error NetBeans: {response_netbeans.status_code} - {response_netbeans.text}")
        except Exception as e:
            print(f"❌ Error al conectar con NetBeans: {e}")

        # Enviar datos al servidor Node.js
        try:
            response_nodejs = requests.post(url_nodejs, data=data, headers=headers)
            if response_nodejs.status_code == 200:
                print(f"✅ Datos enviados a Node.js: {data}")
            else:
                print(f"⚠️ Error Node.js: {response_nodejs.status_code} - {response_nodejs.text}")
        except Exception as e:
            print(f"❌ Error al conectar con Node.js: {e}")

        tiempo += 1
        time.sleep(1)

enviar_datos()
