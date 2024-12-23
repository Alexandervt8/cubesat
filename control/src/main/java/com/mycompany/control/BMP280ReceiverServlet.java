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
    private Sensor_BMP data;

    public BMP280ReceiverServlet() {
        super();
    }

    // Método para recibir datos de sensores
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener datos enviados en la solicitud
        String receivedData = request.getParameter("data");

        if (receivedData != null && !receivedData.isEmpty()) {
            
            Adapter_StrToBMP280 adp = new Adapter_StrToBMP280();
            adp.setData(receivedData);
            Sensor_BMP received = Facade_Sensor.getInstance().ProcessBMP(adp);
            
            if (received != null) {
                data = received;
                doGet(request, response);
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
        // Procesar los datos
        

        jsonResponse.put("tmp", data.temperature != null ? data.temperature : "0");
        jsonResponse.put("hmd", data.humidity != null ? data.humidity : "0");
        jsonResponse.put("prs", data.pressure != null ? data.pressure : "0");
        jsonResponse.put("alt", data.altitude != null ? data.altitude : "0");

        // Enviar respuesta en formato JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.println(jsonResponse.toString());
    }
}


