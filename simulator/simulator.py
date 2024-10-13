import requests
import time
import random

# URL del servlet
url = 'http://192.168.56.1:8080/control/lora'

# Función para generar datos simulados del MPU6050
def simulate_mpu6050_data():
    ax = random.uniform(-2, 2)  # Simula la aceleración en X
    ay = random.uniform(-2, 2)  # Simula la aceleración en Y
    az = random.uniform(-2, 2)  # Simula la aceleración en Z
    gx = random.uniform(-250, 250)  # Simula la rotación en X
    gy = random.uniform(-250, 250)  # Simula la rotación en Y
    gz = random.uniform(-250, 250)  # Simula la rotación en Z

    # Crear una cadena con los datos simulados
    data = f"{ax},{ay},{az},{gx},{gy},{gz}"
    return data

# Bucle para enviar datos simulados en intervalos regulares
while True:
    simulated_data = simulate_mpu6050_data()
    # Enviar solicitud POST con los datos simulados
    response = requests.post(url, data={'data': simulated_data})

    # Mostrar el resultado
    if response.status_code == 200:
        print(f"Datos enviados: {simulated_data}")
        print(f"Respuesta del servidor: {response.text}")
    else:
        print(f"Error al enviar los datos: {response.status_code}")

    # Esperar 2 segundos antes de enviar nuevamente
    time.sleep(2)
