import requests
import time
import math
import random  # Asegúrate de que esta línea esté incluida

# URL del servlet
url_netbeans = 'http://192.168.0.7:8080/control/lora'  # NetBeans (Servidor A)
url_nodejs = 'http://localhost:3001/control/lora'  # Node.js (Servidor B)

# Parámetros para el ruido y el movimiento
noise_factor_accel = 0.1  # Ruido para aceleración
noise_factor_gyro = 5.0   # Ruido para giroscopio
amplitude_accel = 1.5     # Amplitud del movimiento de aceleración
amplitude_gyro = 200.0    # Amplitud del movimiento del giroscopio
frequency = 0.5           # Frecuencia del movimiento (oscilaciones por segundo)

# Inicializa el tiempo base
start_time = time.time()

# Función para generar datos simulados del MPU6050
def simulate_mpu6050_data(current_time):
    # Calcula el tiempo transcurrido
    elapsed_time = current_time - start_time

    # Simula la aceleración en X, Y (en g)
    ax = amplitude_accel * math.sin(2 * math.pi * frequency * elapsed_time)
    ay = amplitude_accel * math.cos(2 * math.pi * frequency * elapsed_time)

    # Oscila entre 45° y -45° para Z
    az = math.sin(2 * math.pi * frequency * elapsed_time) * 0.707  # 0.707 = sin(45°)

    # Añadir ruido a X, Y, Z
    ax += random.uniform(-noise_factor_accel, noise_factor_accel)
    ay += random.uniform(-noise_factor_accel, noise_factor_accel)
    az += random.uniform(-noise_factor_accel, noise_factor_accel)

    # Simula la rotación en X, Y, Z (en grados/segundo)
    gx = amplitude_gyro * math.sin(2 * math.pi * frequency * elapsed_time)
    gy = amplitude_gyro * math.cos(2 * math.pi * frequency * elapsed_time)
    gz = amplitude_gyro * math.sin(2 * math.pi * frequency * elapsed_time)

    # Añadir ruido
    gx += random.uniform(-noise_factor_gyro, noise_factor_gyro)
    gy += random.uniform(-noise_factor_gyro, noise_factor_gyro)

    # Crear una cadena con los datos simulados
    data = f"{ax:.2f},{ay:.2f},{az:.2f},{gx:.2f},{gy:.2f},{gz:.2f}"
    return data

# Función para enviar datos a un servidor con reintentos
def enviar_datos_servidor(url, data, nombre_servidor, intentos=3):
    for intento in range(intentos):
        try:
            response = requests.post(url, data={'data': data}, timeout=5)
            if response.status_code == 200:
                print(f"✅ [{nombre_servidor}] Datos enviados correctamente.")
                return True
            else:
                print(f"⚠️ [{nombre_servidor}] Error {response.status_code}: {response.text}")
        except requests.exceptions.RequestException as e:
            print(f"❌ [{nombre_servidor}] Error de conexión: {e}. Reintentando...")
            time.sleep(2)  # Esperar antes de reintentar
    return False

# Bucle para enviar datos simulados a ambos servidores
while True:
    current_time = time.time()
    simulated_data = simulate_mpu6050_data(current_time)

    # Enviar a NetBeans
    enviar_datos_servidor(url_netbeans, simulated_data, "NetBeans")

    # Enviar a Node.js
    enviar_datos_servidor(url_nodejs, simulated_data, "Node.js")

    # Esperar 1 segundo antes de enviar nuevamente
    time.sleep(1)
