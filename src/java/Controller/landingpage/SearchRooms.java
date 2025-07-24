/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.landingpage;

import dal.DAORentalPost;
import model.RentalPost;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Ultils.ReadFile;

@WebServlet(name="SearchRooms", urlPatterns={"/searchRooms"})
public class SearchRooms extends HttpServlet {
    
    private static final int POSTS_PER_PAGE = 9;
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            DAORentalPost rentalPostDAO = new DAORentalPost();
            
            // Get search parameters
            String keyword = request.getParameter("keyword");
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");
            String pageStr = request.getParameter("page");
            
            // Parse price range
            Double minPrice = null;
            Double maxPrice = null;
            try {
                if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                    minPrice = Double.parseDouble(minPriceStr);
                }
                if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                    maxPrice = Double.parseDouble(maxPriceStr);
                }
            } catch (NumberFormatException e) {
                // Invalid price format, ignore
            }
            
            // Parse page number
            int currentPage = 1;
            try {
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
            
            // Search posts
            List<RentalPost> allPosts = searchRentalPosts(
                rentalPostDAO, keyword, province, district, ward, minPrice, maxPrice
            );
            
            // Calculate pagination
            int totalPosts = allPosts.size();
            int totalPages = (int) Math.ceil((double) totalPosts / POSTS_PER_PAGE);
            int startIndex = (currentPage - 1) * POSTS_PER_PAGE;
            int endIndex = Math.min(startIndex + POSTS_PER_PAGE, totalPosts);
            
            // Get posts for current page
            List<RentalPost> posts = new ArrayList<>();
            if (startIndex < totalPosts) {
                posts = allPosts.subList(startIndex, endIndex);
            }
            
            // Load provinces for search form
            List<String> provinces = ReadFile.loadAllProvinces(request);
            
            // Set attributes for JSP
            request.setAttribute("searchResults", posts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalResults", totalPosts);
            request.setAttribute("provinces", provinces);
            
            // Preserve search parameters
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("searchProvince", province);
            request.setAttribute("searchDistrict", district);
            request.setAttribute("searchWard", ward);
            request.setAttribute("searchMinPrice", minPriceStr);
            request.setAttribute("searchMaxPrice", maxPriceStr);
            
            // Create search params string for pagination
            StringBuilder searchParams = new StringBuilder();
            if (keyword != null && !keyword.trim().isEmpty()) {
                searchParams.append("keyword=").append(java.net.URLEncoder.encode(keyword, "UTF-8")).append("&");
            }
            if (province != null && !province.trim().isEmpty()) {
                searchParams.append("province=").append(java.net.URLEncoder.encode(province, "UTF-8")).append("&");
            }
            if (district != null && !district.trim().isEmpty()) {
                searchParams.append("district=").append(java.net.URLEncoder.encode(district, "UTF-8")).append("&");
            }
            if (ward != null && !ward.trim().isEmpty()) {
                searchParams.append("ward=").append(java.net.URLEncoder.encode(ward, "UTF-8")).append("&");
            }
            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                searchParams.append("minPrice=").append(minPriceStr).append("&");
            }
            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                searchParams.append("maxPrice=").append(maxPriceStr).append("&");
            }
            
            // Remove trailing &
            String searchParamsString = searchParams.toString();
            if (searchParamsString.endsWith("&")) {
                searchParamsString = searchParamsString.substring(0, searchParamsString.length() - 1);
            }
            request.setAttribute("searchParams", searchParamsString);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tìm kiếm: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/LandingPage/SeachRoom.jsp").forward(request, response);
    }
    
    private List<RentalPost> searchRentalPosts(DAORentalPost dao, String keyword, 
            String province, String district, String ward, Double minPrice, Double maxPrice) {
        
        // Use existing search method and filter by price if needed
        List<RentalPost> posts = dao.searchPosts(keyword, province, district, ward);
        
        // Filter by price range if specified
        if (minPrice != null || maxPrice != null) {
            posts = posts.stream()
                    .filter(post -> {
                        double roomPrice = post.getRoomPrice();
                        if (minPrice != null && roomPrice < minPrice) return false;
                        if (maxPrice != null && roomPrice > maxPrice) return false;
                        return true;
                    })
                    .toList();
        }
        
        return posts;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Search Rooms Servlet";
    }
}
