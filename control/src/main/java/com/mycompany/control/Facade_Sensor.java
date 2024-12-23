/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.control;

/**
 *
 * @author ASUS
 */
public class Facade_Sensor {
    private static Facade_Sensor instance;
    
    private Facade_Sensor(){ 
    
    };
    
    public static Facade_Sensor getInstance(){
        if(instance == null){
            instance = new Facade_Sensor();
        }
        return instance;
    }
    
    public Sensor_BMP ProcessBMP(Sensor_BMP data){ 
        System.out.println("Datos del BMP280 recibidos:");
        System.out.println("Temperatura: " + data.temperature + " °C");
        System.out.println("Presión: " + data.pressure + " hPa");
        System.out.println("Altitud: " + data.altitude + " m");
        return data;
    }
    
    public Sensor_BMP ProcessBMP(Adapter_StrToBMP280 data){
        Sensor_BMP sen = new Sensor_BMP(data);
        if(data.isValid()){
            return ProcessBMP(sen);
        }
        
        return null;
    }
    
    public void ProcessAltura(String data){
        
    }
    
    public void ProcessGPS(String data){
        
    }
}
