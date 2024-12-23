/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.control;

/**
 *
 * @author ASUS
 */
public class Sensor_BMP { 
    public String temperature;
    public String pressure;
    public String altitude;
    public String humidity;
    
    public Sensor_BMP(String tmp, String pres, String alt, String hum){
        temperature = tmp;
        pressure = pres;
        altitude = alt;
        humidity = hum;
    }
    
    public Sensor_BMP(IAdapter_ToStringArr data){
        String[] info = data.getData();
        if(info == null){
            return;
        }
        
        temperature = info[0];
        pressure = info[2];
        altitude = info[3];
        humidity = info[1];
    }
}
