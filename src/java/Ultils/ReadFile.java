package Ultils;

import com.google.gson.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import jakarta.servlet.http.HttpServletRequest;

public final class ReadFile {

    private static final String JSON_PATH = "/Image/Location/vietnamAddress.json";

    private static JsonArray getJsonArrayFromWebApp(HttpServletRequest request) throws IOException {
        // Lấy ServletContext từ HttpServletRequest
        jakarta.servlet.ServletContext servletContext = request.getServletContext();
        if (servletContext == null) {
            throw new IllegalStateException("ServletContext không được tìm thấy từ request!");
        }

        // Lấy context path để debug
        String contextPath = request.getContextPath();
        System.out.println("Đường dẫn đầy đủ: " + contextPath + JSON_PATH);

        // Đọc file từ thư mục web
        InputStream inputStream = servletContext.getResourceAsStream(JSON_PATH);
        if (inputStream == null) {
            throw new FileNotFoundException("Không tìm thấy file: " + JSON_PATH);
        }

        try (Reader reader = new InputStreamReader(inputStream, StandardCharsets.UTF_8)) {
            return JsonParser.parseReader(reader).getAsJsonArray();
        }
    }

    public static List<String> loadAllProvinces(HttpServletRequest request) throws IOException {
        JsonArray provincesArray = getJsonArrayFromWebApp(request);
        List<String> provinceNames = new ArrayList<>();
        for (JsonElement provinceElement : provincesArray) {
            provinceNames.add(provinceElement.getAsJsonObject().get("Name").getAsString());
        }
        return provinceNames;
    }

    public static List<String> loadDistrictsByProvince(HttpServletRequest request, String provinceName) throws IOException {
        JsonArray provincesArray = getJsonArrayFromWebApp(request);
        List<String> districtNames = new ArrayList<>();
        for (JsonElement provinceElement : provincesArray) {
            JsonObject provinceObj = provinceElement.getAsJsonObject();
            if (provinceObj.get("Name").getAsString().equalsIgnoreCase(provinceName)) {
                JsonArray districts = provinceObj.getAsJsonArray("Districts");
                for (JsonElement district : districts) {
                    districtNames.add(district.getAsJsonObject().get("Name").getAsString());
                }
                break;
            }
        }
        return districtNames;
    }

    public static List<String> loadWardsByDistrict(HttpServletRequest request, String districtName) throws IOException {
        JsonArray provincesArray = getJsonArrayFromWebApp(request);
        for (JsonElement province : provincesArray) {
            JsonArray districts = province.getAsJsonObject().getAsJsonArray("Districts");
            for (JsonElement district : districts) {
                JsonObject districtObj = district.getAsJsonObject();
                if (districtObj.get("Name").getAsString().equalsIgnoreCase(districtName)) {
                    List<String> wardNames = new ArrayList<>();
                    JsonArray wards = districtObj.getAsJsonArray("Wards");
                    for (JsonElement ward : wards) {
                        wardNames.add(ward.getAsJsonObject().get("Name").getAsString());
                    }
                    return wardNames;
                }
            }
        }
        return Collections.emptyList();
    }

    
}