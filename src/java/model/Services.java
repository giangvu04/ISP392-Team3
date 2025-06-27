/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Services {
    private int serviceId;
    private int rentalAreaId;
    private String serviceName;
    private double unitPrice;
    private String unitName;
    private int calculationMethod; // 0: Theo đồng hồ, 1: Cố định hàng tháng

    // Constructors
    public Services() {
    }

    public Services(int serviceId, int rentalAreaId, String serviceName, double unitPrice, String unitName, int calculationMethod) {
        this.serviceId = serviceId;
        this.rentalAreaId = rentalAreaId;
        this.serviceName = serviceName;
        this.unitPrice = unitPrice;
        this.unitName = unitName;
        this.calculationMethod = calculationMethod;
    }

    // Getters and Setters
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public int getRentalAreaId() {
        return rentalAreaId;
    }

    public void setRentalAreaId(int rentalAreaId) {
        this.rentalAreaId = rentalAreaId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public int getCalculationMethod() {
        return calculationMethod;
    }

    public void setCalculationMethod(int calculationMethod) {
        this.calculationMethod = calculationMethod;
    }

    @Override
    public String toString() {
        return "Services{" +
                "serviceId=" + serviceId +
                ", rentalAreaId=" + rentalAreaId +
                ", serviceName='" + serviceName + '\'' +
                ", unitPrice=" + unitPrice +
                ", unitName='" + unitName + '\'' +
                ", calculationMethod=" + calculationMethod +
                '}';
    }
}
