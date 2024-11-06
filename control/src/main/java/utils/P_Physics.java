/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author ASUS
 */
public class P_Physics {
    
    public static double local_Pressure_hPa = 0;
    public static double local_Height_m = 0;
    
    public static double global_seaPressure_hPa = 1013;
    public static double global_airdensity_kgm3 = 1.2; 
    public static double global_gravityAcceleration_ms = 9.8;
    
    /**
     * 
     * @param x Presion medida en la atmosfera
     * @return double
     */
    public static double Calc_Altura_from_Presion(double x){
        double height = (x - global_seaPressure_hPa) / (global_airdensity_kgm3 * global_gravityAcceleration_ms);
        return height;
    }
    
    public static double Calc_Velocidad_from_Distancia_and_Tiempo(double d, double t){
        double speed = (2 * d + global_gravityAcceleration_ms * t * t) / (2 * t);
        return speed;
    }
    
    public static double Calc_Distancia_from_Alturas(double h1, double h2){
        return h1 - h2;
    }
    
    public static double Calc_Altura_Actual(double h){
        return Calc_Distancia_from_Alturas(h,local_Height_m);
    }
}
