package Ultils;
import java.security.SecureRandom;

public class RandomStringGenerator {
    private static final String UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String DIGITS = "0123456789";
    private static final String SPECIAL_CHARS = "!@#$%^&*()_+-=[]{}|;:,.<>?";
    private static final String ALL_CHARS = UPPERCASE + LOWERCASE + DIGITS + SPECIAL_CHARS;
    private static final SecureRandom random = new SecureRandom();

    public static String generateRandomString(int minLength) {
        if (minLength < 8) {
            minLength = 8; // Đảm bảo độ dài tối thiểu là 8
        }

        StringBuilder sb = new StringBuilder();

        // Đảm bảo ít nhất 1 ký tự từ mỗi loại
        sb.append(UPPERCASE.charAt(random.nextInt(UPPERCASE.length()))); // 1 chữ hoa
        sb.append(LOWERCASE.charAt(random.nextInt(LOWERCASE.length()))); // 1 chữ thường
        sb.append(DIGITS.charAt(random.nextInt(DIGITS.length())));       // 1 số
        sb.append(SPECIAL_CHARS.charAt(random.nextInt(SPECIAL_CHARS.length()))); // 1 ký tự đặc biệt

        // Thêm các ký tự ngẫu nhiên để đạt độ dài tối thiểu
        for (int i = 4; i < minLength; i++) {
            sb.append(ALL_CHARS.charAt(random.nextInt(ALL_CHARS.length())));
        }

        // Xáo trộn chuỗi để các ký tự không theo thứ tự cố định
        char[] chars = sb.toString().toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }

        return new String(chars);
    }

    // Ví dụ sử dụng
    public static void main(String[] args) {
        String randomString = generateRandomString(8);
        System.out.println("Chuỗi ngẫu nhiên: " + randomString);
    }
}