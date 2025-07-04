
package Ultils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class ImageServices {
    public static String saveImageToLocal(byte[] imageData, String fileName, String baseUrl) throws IOException {
        
        String currentDir = new File("").getAbsolutePath();
        String directoryPath = currentDir + File.separator + "Image";
        File directory = new File(directoryPath);  
        if (!directory.exists()) {
            directory.mkdirs();
        }        
        File file = new File(directory, fileName);        
        try (FileOutputStream fos = new FileOutputStream(file)) {
            fos.write(imageData);
        }       
        return baseUrl + "/Image/" + file.getName();
    }
}
