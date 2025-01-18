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
    private String tmp, prs, hmd, rad, vnt, alt;

    public BMP280ReceiverServlet() {
        super();
    }

    // Método para recibir datos de sensores
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener datos enviados en la solicitud
        String receivedData = request.getParameter("data");

        if (receivedData != null && !receivedData.isEmpty()) {
            String[] sensorData = receivedData.split(",");
            if (sensorData.length == 6) {
                // Procesar los datos
                tmp = sensorData[0].split("=")[1];
                prs = sensorData[1].split("=")[1];
                hmd = sensorData[2].split("=")[1];
                rad = sensorData[3].split("=")[1];
                vnt = sensorData[4].split("=")[1];
                alt = sensorData[5].split("=")[1];

                System.out.println("Datos del BMP280 recibidos:");
                System.out.println("Temperatura (tmp): " + tmp + "°C");
                System.out.println("Presión (prs): " + prs + " hPa");
                System.out.println("Humedad (hmd): " + hmd + "%");
                System.out.println("Radiación Solar (rad): " + rad + " MJ/m²/día");
                System.out.println("Velocidad del Viento (vel): " + vnt + " m/s");
                System.out.println("Altitud (alt): " + alt + " m");

                // Crear un objeto JSON con claves abreviadas
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("tmp", tmp);
                jsonResponse.put("prs", prs);
                jsonResponse.put("hmd", hmd);
                jsonResponse.put("rad", rad); 
                jsonResponse.put("vnt", vnt); 
                jsonResponse.put("alt", alt);

                // Enviar respuesta en formato JSON
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.println(jsonResponse.toString());
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Formato de datos incorrecto");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No se recibieron datos");
        }
    }

    // Método para obtener datos almacenados
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Crear un objeto JSON con las claves abreviadas y datos almacenados
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("tmp", tmp != null ? tmp : "0");
        jsonResponse.put("prs", prs != null ? prs : "0");
        jsonResponse.put("hmd", hmd != null ? hmd : "0");
        jsonResponse.put("rad", rad != null ? rad : "0"); 
        jsonResponse.put("vnt", vnt != null ? vnt : "0"); 
        jsonResponse.put("alt", alt != null ? alt : "0");

        // Enviar respuesta en formato JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.println(jsonResponse.toString());
    }
}


