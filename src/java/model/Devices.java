
package model;

public class Devices{
    private int deviceId;
    private String deviceName;
    private String deviceCode;
    private String latestWarrantyDate;
    private String purchaseDate;
    private String warrantyExpiryDate;

    public Devices() {
    }

    public Devices(int deviceId, String deviceName) {
        this.deviceId = deviceId;
        this.deviceName = deviceName;
    }

    public Devices(int deviceId, String deviceName, String deviceCode, String latestWarrantyDate, 
                  String purchaseDate, String warrantyExpiryDate) {
        this.deviceId = deviceId;
        this.deviceName = deviceName;
        this.deviceCode = deviceCode;
        this.latestWarrantyDate = latestWarrantyDate;
        this.purchaseDate = purchaseDate;
        this.warrantyExpiryDate = warrantyExpiryDate;
    }

    // Getters and Setters
    public int getDeviceId() { return deviceId; }
    public void setDeviceId(int deviceId) { this.deviceId = deviceId; }
    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }
    public String getDeviceCode() { return deviceCode; }
    public void setDeviceCode(String deviceCode) { this.deviceCode = deviceCode; }
    public String getLatestWarrantyDate() { return latestWarrantyDate; }
    public void setLatestWarrantyDate(String latestWarrantyDate) { this.latestWarrantyDate = latestWarrantyDate; }
    public String getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(String purchaseDate) { this.purchaseDate = purchaseDate; }
    public String getWarrantyExpiryDate() { return warrantyExpiryDate; }
    public void setWarrantyExpiryDate(String warrantyExpiryDate) { this.warrantyExpiryDate = warrantyExpiryDate; }
}
