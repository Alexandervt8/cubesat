/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.control;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import utils.P_Physics;
import utils.Router;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "AlturaServlet", urlPatterns = {Router.ALTURA_ENDPOINT})

public class AlturaServlet extends HttpServlet {
    
    private double h1 = -1, h2 = -1;
    private double speed = -1;
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Altura_Servlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Altura_Servlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String receivedData = request.getParameter("data");

        if (receivedData != null && !receivedData.isEmpty()) {
        
            String[] sensorData = receivedData.split(",");
            double pActual = Double.parseDouble(sensorData[0]);
            double hActual = P_Physics.Calc_Altura_Actual(
                    P_Physics.Calc_Altura_from_Presion(pActual)
            );
            double vActual = -1;
            if(h2 != -1){
                vActual = P_Physics.Calc_Velocidad_from_Distancia_and_Tiempo(
                        P_Physics.Calc_Distancia_from_Alturas(h1, h2),
                        1
                );
            }
            h2 = h1;
            h1 = hActual;
            speed = vActual;
            System.out.println("[LOG] Altura Actual : " + hActual + " m");
            doGet(request, response);
        } else {
            // Si no se reciben datos
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No se recibieron datos");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("velocidad", speed != -1 ? "" + speed : "0");
        jsonResponse.put("altura", h1 != -1 ? "" + h1 : "0");

        // Enviar respuesta en formato JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.println(jsonResponse.toString());
    }
   
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
