import requests
import time
import random

# URL del servlet
url = 'http://192.168.56.1:8080/control/lora'

# Parámetros para el ruido
noise_factor_accel = 0.1  # Ruido para aceleración
noise_factor_gyro = 5.0    # Ruido para giroscopio

# Función para generar datos simulados del MPU6050
def simulate_mpu6050_data():
    # Simula la aceleración en X, Y, Z (en g)
    ax = random.uniform(-1.5, 1.5) + random.uniform(-noise_factor_accel, noise_factor_accel)
    ay = random.uniform(-1.5, 1.5) + random.uniform(-noise_factor_accel, noise_factor_accel)
    az = random.uniform(-1.5, 1.5) + random.uniform(-noise_factor_accel, noise_factor_accel)

    # Simula la rotación en X, Y, Z (en grados/segundo)
    gx = random.uniform(-200, 200) + random.uniform(-noise_factor_gyro, noise_factor_gyro)
    gy = random.uniform(-200, 200) + random.uniform(-noise_factor_gyro, noise_factor_gyro)
    gz = random.uniform(-200, 200) + random.uniform(-noise_factor_gyro, noise_factor_gyro)

    # Crear una cadena con los datos simulados
    data = f"{ax:.2f},{ay:.2f},{az:.2f},{gx:.2f},{gy:.2f},{gz:.2f}"
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

    # Esperar 1 segundo antes de enviar nuevamente
    time.sleep(1)

