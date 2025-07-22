package Ultils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;

public class ImageServices {
    
    private static final String UPLOAD_DIR = "Image";

    public static String saveImageToLocal(byte[] imageData, String fileName, String baseUrl) throws IOException {
        // Lấy đường dẫn thực tế của webapp
        String webPath = System.getProperty("user.dir");
        String directoryPath = webPath + File.separator + "web" + File.separator + UPLOAD_DIR;
        
        File directory = new File(directoryPath);
        if (!directory.exists()) {
            directory.mkdirs();
        }
        
        File file = new File(directory, fileName);
        try (FileOutputStream fos = new FileOutputStream(file)) {
            fos.write(imageData);
        }
        
        return baseUrl + "/" + UPLOAD_DIR + "/" + fileName;
    }

    public static String saveImageToLocal2(byte[] imageData, String fileName, 
            String baseUrl, String runtimePath) throws IOException {
        
        // 1. Lưu vào thư mục runtime (build/web/Image) để trình duyệt truy cập được
        File runtimeDir = new File(runtimePath, UPLOAD_DIR);
        if (!runtimeDir.exists()) {
            runtimeDir.mkdirs();
        }
        File fileRuntime = new File(runtimeDir, fileName);
        try (FileOutputStream fos = new FileOutputStream(fileRuntime)) {
            fos.write(imageData);
        }

        // 2. Lưu thêm vào thư mục source (web/Image) để không mất khi rebuild
        try {
            String projectRoot = System.getProperty("user.dir");
            File sourceDir = new File(projectRoot, "web" + File.separator + UPLOAD_DIR);
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
            }
            File fileSource = new File(sourceDir, fileName);
            try (FileOutputStream fos = new FileOutputStream(fileSource)) {
                fos.write(imageData);
            }
        } catch (Exception e) {
            System.out.println("Warning: Could not save to source directory: " + e.getMessage());
        }

        // Trả về URL để client hiển thị
        return baseUrl + "/" + UPLOAD_DIR + "/" + URLEncoder.encode(fileName, "UTF-8");
    }
}
