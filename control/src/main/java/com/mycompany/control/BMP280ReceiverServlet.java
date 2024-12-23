package com.mycompany.control;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import utils.Router;

@WebServlet(name = "BMP280ReceiverServlet", urlPatterns = {Router.ATMOSPHERE_ENDPOINT})
public class BMP280ReceiverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
 
    // Variables para almacenar los datos del sensor
    private Sensor_BMP data;

    public BMP280ReceiverServlet() {
        super();
    }

    /**
    * @brief Método para recibir datos del BMP280, datos se reciben del Request en formato: 
    * {data: "<temperature>, <pressure>, <altitude>"}
    * @param request Request del Servlet
    * @param response Response del Servlet
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            // Si no se reciben datos
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No se recibieron datos");
        }
    }

    
    /**
     * @brief Método para obtener datos almacenados en formato .json
     * @param request Request del Servlet
     * @param response Response dl Servelet
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Crear un objeto JSON con los datos almacenados
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("tmp", data.temperature != null ? data.temperature : "0");
        jsonResponse.put("prs", data.pressure != null ? data.pressure : "0");
        jsonResponse.put("alt", data.altitude != null ? data.altitude : "0");
        jsonResponse.put("hmd", data.humidity != null ? data.humidity : "0");

        // Enviar respuesta en formato JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.println(jsonResponse.toString());
    }
}
