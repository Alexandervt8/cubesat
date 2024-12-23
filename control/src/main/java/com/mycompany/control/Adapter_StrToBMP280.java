/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.control;

/**
 *
 * @author ASUS
 */
public class Adapter_StrToBMP280 implements IAdapter_ToStringArr{

    private String data;
    private boolean isValid = false;
    @Override
    public String[] getData() {
        System.out.println(data);
        String[] sensorData = data.split(",");
        if(sensorData.length == 4){
            isValid = true;
            return sensorData;
        } else {
            isValid = false; 
            return null;
        }
    }

    @Override
    public void setData(String data) {
        this.data = data;
    }

    @Override
    public boolean isValid() {
        return isValid;
    } 
    
}
