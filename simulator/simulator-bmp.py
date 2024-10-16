import requests
import random
import time

# URL del servlet BMP280ReceiverServlet (ajusta la URL según la configuración de tu servidor)
url = 'http://192.168.56.1:8080/control/bmp280'  

# Función para generar datos simulados de temperatura, presión y altitud
def generar_datos_simulados():
    temperatura = round(random.uniform(0.0, 35.0), 2)  # Temperatura entre 15 y 35 grados Celsius
    presion = round(random.uniform(0, 1050.0), 2)   # Presión entre 950 y 1050 hPa
    altitud = round(random.uniform(0, 500.0), 2)      # Altitud entre 0 y 500 metros
    return temperatura, presion, altitud

# Función para enviar los datos al servlet
def enviar_datos():
    while True:
        # Generar datos simulados
        temperatura, presion, altitud = generar_datos_simulados()
        data = f"{temperatura},{presion},{altitud}"

        # Enviar los datos al servlet usando una solicitud POST
        try:
            response = requests.post(url, data={'data': data})
            if response.status_code == 200:
                print(f"Datos enviados exitosamente: {data}")
                print(f"Respuesta del servidor: {response.json()}")
            else:
                print(f"Error al enviar datos: {response.status_code}")
        except Exception as e:
            print(f"Error en la conexión: {e}")
        
        # Esperar 5 segundos antes de enviar los próximos datos
        time.sleep(1)

enviar_datos()