package com.mycompany.control;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "BMP280ReceiverServlet", urlPatterns = {"/bmp280"})
public class BMP280ReceiverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Variables para almacenar los datos del sensor
    private String temperature, pressure, altitude;

    public BMP280ReceiverServlet() {
        super();
    }

    // Método para recibir datos del BMP280
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String receivedData = request.getParameter("data");

        if (receivedData != null && !receivedData.isEmpty()) {
            String[] sensorData = receivedData.split(",");
            if (sensorData.length == 3) {
                // Procesar los datos
                temperature = sensorData[0];
                pressure = sensorData[1];
                altitude = sensorData[2];

                System.out.println("Datos del BMP280 recibidos:");
                System.out.println("Temperatura: " + temperature + " °C");
                System.out.println("Presión: " + pressure + " hPa");
                System.out.println("Altitud: " + altitude + " m");

                // Crear un objeto JSON con los datos
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("temperature", temperature);
                jsonResponse.put("pressure", pressure);
                jsonResponse.put("altitude", altitude);

                // Enviar respuesta en formato JSON
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.println(jsonResponse.toString());
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Formato de datos incorrecto");
            }
        } else {
            // Si no se reciben datos
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No se recibieron datos");
        }
    }

    // Método para obtener datos almacenados
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Crear un objeto JSON con los datos almacenados
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("temperature", temperature != null ? temperature : "0");
        jsonResponse.put("pressure", pressure != null ? pressure : "0");
        jsonResponse.put("altitude", altitude != null ? altitude : "0");

        // Enviar respuesta en formato JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.println(jsonResponse.toString());
    }
}
