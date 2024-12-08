# Estación espacial - Sistema de Monitoreo y Control

Este proyecto permite orbitar un satélite con sensores para monitorear variables climáticas como la temperatura, humedad, presión, velocidad del viento y más. Además, integra un sistema de control para realizar cálculos de Evapotranspiración y control del CubeSat.

## Índice
- [Requisitos previos](#requisitos-previos)
- [Instalación](#instalación)
- [Ejecución](#ejecución)
- [Interfaces del Sistema](#interfaces-del-sistema)
- [Créditos](#créditos)

## Requisitos previos

Antes de comenzar, asegúrate de tener lo siguiente:
- **Arduino** con los sensores instalados (Temperatura, Humedad, Presión, Radiación, etc.).
- **Python** instalado en tu sistema.
- **Servidor local** (Apache o similar).
- **Apache Ignite** y **GlassFish** para la parte del servidor de cálculos de evapotranspiración.
- **Conexión a una red local** para la sincronización de datos.

### Dependencias de software
- Python 3.x
- Flask
- PySerial
- Chart.js (para los gráficos de la interfaz)
- MySQL para la base de datos (si es necesario)

## Instalación

1. **Clona el repositorio:**

   ```bash
   git clone https://github.com/usuario/estacion-meteorologica.git
   cd estacion-meteorologica

## Interfaz
![Sign Language Alphabet Charts](documentacion/imagenes/interface-1.png)
