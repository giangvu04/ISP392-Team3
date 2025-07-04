package Controller.imagelist;

import dal.ImageDAO;
import model.Image;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.UUID;

@WebServlet(name = "ImageList", urlPatterns = {"/ImageList"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // Giới hạn file upload tối đa 10MB
public class ImageList extends HttpServlet {
    private static final String UPLOAD_DIR = "Image";
    private ImageDAO imageDAO;

    @Override
    public void init() throws ServletException {
        imageDAO = new ImageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String houseId = request.getParameter("houseId");
        String roomId = request.getParameter("roomId");

        System.out.println("doGet - houseId: " + houseId + ", roomId: " + roomId);

        try {
            if (houseId != null && !houseId.isEmpty()) {
                int hId = Integer.parseInt(houseId);
                request.setAttribute("houseID", houseId);
                request.setAttribute("imageList", imageDAO.getImagesByHouse(hId));
            } else if (roomId != null && !roomId.isEmpty()) {
                int rId = Integer.parseInt(roomId);
                request.setAttribute("roomID", roomId);
                request.setAttribute("imageList", imageDAO.getImagesByRoom(rId));
            } else {
                request.setAttribute("error", "Vui lòng cung cấp houseId hoặc roomId.");
            }

            request.getRequestDispatcher("/ImagesAssets/ImagesAsset.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ. Vui lòng cung cấp houseId hoặc roomId hợp lệ.");
            request.getRequestDispatcher("/ImagesAssets/ImagesAsset.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String houseId = request.getParameter("houseId");
        String roomId = request.getParameter("roomId");
        String imageId = request.getParameter("imageId");
        HttpSession session = request.getSession();

        System.out.println("doPost - action: " + action + ", houseId: " + houseId + ", roomId: " + roomId + ", imageId: " + imageId);

        if ("add".equals(action)) {
            Part filePart = request.getPart("imageFile");

            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("error", "Vui lòng chọn một file ảnh.");
                response.sendRedirect("ManagerHomepage");
                return;
            }

            try {
                String contentType = filePart.getContentType();
                if (!contentType.equals("image/png") && !contentType.equals("image/jpeg") &&
                    !contentType.equals("image/jpg") && !contentType.equals("image/webp")) {
                    session.setAttribute("error", "Chỉ hỗ trợ định dạng ảnh png, jpeg, jpg, webp.");
                    response.sendRedirect("ManagerHomepage");
                    return;
                }

                String fileName = UUID.randomUUID().toString() + "_" + filePart.getSubmittedFileName();
                InputStream fileContent = filePart.getInputStream();
                byte[] imageData = fileContent.readAllBytes();

                String baseUrl = request.getContextPath();
                String imageUrl = saveImageToLocal(imageData, fileName, baseUrl);

                Image image = new Image();
                if (houseId != null && !houseId.isEmpty()) {
                    image.setRentalId(Integer.parseInt(houseId));
                } else if (roomId != null && !roomId.isEmpty()) {
                    image.setRoomId(Integer.parseInt(roomId));
                } else {
                    session.setAttribute("error", "Vui lòng cung cấp houseId hoặc roomId.");
                    response.sendRedirect("ManagerHomepage");
                    return;
                }
                image.setUrlImage(imageUrl);

                boolean success = imageDAO.addImage(image);
                if (success) {
                    session.setAttribute("success", "Tải ảnh lên thành công!");
                } else {
                    session.setAttribute("error", "Lỗi khi tải ảnh lên.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID không hợp lệ. Vui lòng cung cấp houseId hoặc roomId hợp lệ.");
            } catch (IOException e) {
                session.setAttribute("error", "Lỗi khi xử lý file ảnh.");
            }
        } else if ("delete".equals(action)) {
            if (imageId != null && !imageId.isEmpty()) {
                try {
                    int imgId = Integer.parseInt(imageId);
                    Image image = imageDAO.getImageById(imgId); // Giả định có phương thức này
                    System.out.println(image.getUrlImage());
                    if (image != null) {
                        boolean deleted = imageDAO.deleteImage(imgId);
                        if (deleted) {
                            // Xóa file ảnh khỏi thư mục
                            String filePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR + File.separator + 
                                            new File(image.getUrlImage()).getName();
                            File file = new File(filePath);
                            if (file.exists()) {
                                file.delete();
                            }
                            session.setAttribute("success", "Xóa ảnh thành công!");
                        } else {
                            session.setAttribute("error", "Lỗi khi xóa ảnh.");
                        }
                    } else {
                        session.setAttribute("error", "Không tìm thấy ảnh để xóa.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "ID ảnh không hợp lệ.");
                }
            } else {
                session.setAttribute("error", "Vui lòng cung cấp ID ảnh.");
            }
        } else {
            session.setAttribute("error", "Hành động không hợp lệ.");
        }

        // Redirect về ImageList với tham số
        String redirectUrl = "ImageList?" + (houseId != null && !houseId.isEmpty() ? "houseId=" + houseId : "roomId=" + roomId);
        response.sendRedirect(redirectUrl);
    }

    private String saveImageToLocal(byte[] imageData, String fileName, String baseUrl) throws IOException {
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File directory = new File(uploadPath);
        if (!directory.exists()) {
            directory.mkdirs();
        }
        File file = new File(directory, fileName);
        try (FileOutputStream fos = new FileOutputStream(file)) {
            fos.write(imageData);
        }
        return baseUrl + "/" + UPLOAD_DIR + "/" + fileName;
    }
}