package com.mycompany.control;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "LoRaReceiverServlet", urlPatterns = {"/lora"})
public class LoRaReceiverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Variables para almacenar los datos del sensor
    private String ax, ay, az, gx, gy, gz;

    public LoRaReceiverServlet() {
        super();
    }

    // Método para recibir datos de sensores
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String receivedData = request.getParameter("data");

        if (receivedData != null && !receivedData.isEmpty()) {
            String[] sensorData = receivedData.split(",");
            if (sensorData.length == 6) {
                // Procesar los datos
                ax = sensorData[0];
                ay = sensorData[1];
                az = sensorData[2];
                gx = sensorData[3];
                gy = sensorData[4];
                gz = sensorData[5];

                System.out.println("Datos del MPU6050 recibidos:");
                System.out.println("Aceleración X: " + ax + " Aceleración Y: " + ay + " Aceleración Z: " + az);
                System.out.println("Giroscopio X: " + gx + " Giroscopio Y: " + gy + " Giroscopio Z: " + gz);

                // Crear un objeto JSON con los datos
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("ax", ax);
                jsonResponse.put("ay", ay);
                jsonResponse.put("az", az);
                jsonResponse.put("gx", gx);
                jsonResponse.put("gy", gy);
                jsonResponse.put("gz", gz);

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
        jsonResponse.put("ax", ax != null ? ax : "0");
        jsonResponse.put("ay", ay != null ? ay : "0");
        jsonResponse.put("az", az != null ? az : "0");
        jsonResponse.put("gx", gx != null ? gx : "0");
        jsonResponse.put("gy", gy != null ? gy : "0");
        jsonResponse.put("gz", gz != null ? gz : "0");

        // Enviar respuesta en formato JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.println(jsonResponse.toString());
    }
}

