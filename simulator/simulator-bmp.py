import requests
import random
import time
import math

# URL del servlet BMP280ReceiverServlet (ajusta la URL según la configuración de tu servidor)
url = 'http://192.168.0.7:8080/control/bmp280'

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
        data = f"data=tmp={round(temperatura, 1)},hmd={round(random.uniform(30.0, 70.0), 1)},prs={round(presion, 1)},alt={round(altitud, 1)}"
        
        headers = {"Content-Type": "application/x-www-form-urlencoded"}

        try:
            response = requests.post(url, data=data, headers=headers)
            if response.status_code == 200:
                print(f"Datos enviados exitosamente: {data}")
                print(f"Respuesta del servidor: {response.json()}")
            else:
                print(f"Error al enviar datos: {response.status_code} - {response.text}")
        except Exception as e:
            print(f"Error en la conexión: {e}")

        tiempo += 1
        time.sleep(1)

enviar_datos()
