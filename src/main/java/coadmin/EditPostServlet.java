package coadmin;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet("/editpost")
public class EditPostServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/mergui";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String postIdStr = request.getParameter("postId");
        String postType = request.getParameter("postType");
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String phone = request.getParameter("phone");
        String priceStr = request.getParameter("price");
        String offPercentageStr = request.getParameter("offPercentage");
        String category = request.getParameter("category");
        String content = request.getParameter("content");

        if (postIdStr == null || postIdStr.isEmpty()) {
            throw new ServletException("Post ID is required for editing.");
        }

        int postID = Integer.parseInt(postIdStr);
        double price = priceStr != null ? Double.parseDouble(priceStr) : 0;
        double offPercentage = offPercentageStr != null ? Double.parseDouble(offPercentageStr) : 0;

        // Initialize RoomType, TableNumber, VehicleType, VehicleNumber, and ArticleContent as null
        String roomType = null;
        Integer tableNumber = null;
        String vehicleType = null;
        String vehicleNumber = null;

        // Handle different post types
        if ("hotel".equalsIgnoreCase(postType)) {
            roomType = request.getParameter("roomType");
        } else if ("restaurant".equalsIgnoreCase(postType)) {
            tableNumber = request.getParameter("tableNumber") != null ? Integer.parseInt(request.getParameter("tableNumber")) : null;
        } else if ("transportation".equalsIgnoreCase(postType)) {
            vehicleType = request.getParameter("vehicleType");
            vehicleNumber = request.getParameter("vehicleNumber");
        }

        // Update post in the database
        String jdbcURL = "jdbc:mysql://localhost:3306/mergui";
        String dbUser = "root";
        String dbPassword = "root";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            String sql = "UPDATE Post SET PostType = ?, Title = ?, Description = ?, Location = ?, Price = ?, RoomType = ?, TableNumber = ?, VehicleType = ?, VehicleNumber = ?, OffPercentage = ?, category = ?, content = ?, UpdatedAt = NOW() WHERE PostID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, postType);
                stmt.setString(2, title);
                stmt.setString(3, description);
                stmt.setString(4, location);
                stmt.setDouble(5, price);
                stmt.setString(6, roomType);
                stmt.setObject(7, tableNumber, java.sql.Types.INTEGER);
                stmt.setString(8, vehicleType);
                stmt.setString(9, vehicleNumber);
                stmt.setDouble(10, offPercentage);
                stmt.setString(11, category);
                stmt.setString(12, content);
                stmt.setInt(13, postID);

                stmt.executeUpdate();
            }

            // Handle file uploads
            Collection<Part> fileParts = request.getParts();
            for (Part filePart : fileParts) {
                if ("images".equals(filePart.getName())) {
                    try (InputStream fileInputStream = filePart.getInputStream()) {
                        saveFile(fileInputStream, postID);
                    }
                }
            }

            response.sendRedirect("coadmin.jsp?message=Post updated successfully");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("Database error: " + e.getMessage());
        }
    }

    private void saveFile(InputStream fileInputStream, int postID) throws ServletException {
        String sql = "INSERT INTO Image (PostID, ImageData) VALUES (?, ?)";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, postID);
            stmt.setBlob(2, fileInputStream);
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Error saving file: " + e.getMessage());
        }
    }
}
