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
import javax.servlet.http.HttpSession;

@MultipartConfig
@WebServlet("/post")
public class PostServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/mergui";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String postType = request.getParameter("postType");
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String phone = request.getParameter("phone");
        String priceStr = request.getParameter("price");
        String offPercentageStr = request.getParameter("offPercentage");
        String coadminIdStr = request.getParameter("coadminId");
        String category = request.getParameter("category");
        String content = request.getParameter("content");

        int coadminID = 0;
        if(coadminIdStr != null) {
        	coadminID = Integer.parseInt(coadminIdStr);
        }
        double price = priceStr != null ? Double.parseDouble(priceStr) : 0;
        double offPercentage = offPercentageStr != null ? Double.parseDouble(offPercentageStr) : 0;

        // Retrieve CoadminID from the session
//        int coadminID;
//        try {
//            coadminID = getCoadminID(request);
//        } catch (ServletException e) {
//            throw new ServletException("Failed to get CoadminID.", e);
//        }

        // Insert post into the database
        int postID;
        String jdbcURL = "jdbc:mysql://localhost:3306/mergui";
        String dbUser = "root";
        String dbPassword = "root";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String sql = "INSERT INTO Post (CoadminID, PostType, Title, Description, Location, Price, RoomType, TableNumber, VehicleType, VehicleNumber, OffPercentage, category, content, CreatedAt) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, coadminID);
                stmt.setString(2, postType);
                stmt.setString(3, title);
                stmt.setString(4, description);
                stmt.setString(5, location);
                stmt.setDouble(6, price);
                stmt.setNull(7, java.sql.Types.VARCHAR); // RoomType, TableNumber, VehicleType, VehicleNumber will be set as null if not applicable
                stmt.setNull(8, java.sql.Types.INTEGER);
                stmt.setNull(9, java.sql.Types.VARCHAR);
                stmt.setNull(10, java.sql.Types.VARCHAR);
                stmt.setDouble(11, offPercentage);
                stmt.setString(12, category);
                stmt.setString(13, content);

                stmt.executeUpdate();

                // Retrieve the generated PostID
                try (var generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        postID = generatedKeys.getInt(1);
                    } else {
                        throw new ServletException("Creating post failed, no ID obtained.");
                    }
                }
            }

            // Handle file uploads
            Collection<Part> fileParts = request.getParts();
            for (Part filePart : fileParts) {
                if ("images".equals(filePart.getName())) {
                    try (InputStream fileInputStream = filePart.getInputStream()) {
                        saveFile(fileInputStream, postID, coadminID);
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("Database error: " + e.getMessage());
        }

        response.sendRedirect("coadmin.jsp?message=\"Success\""); // Redirect to a success page
    }

//    private int getCoadminID(HttpServletRequest request) throws ServletException {
//        HttpSession session = request.getSession(false);
//        if (session != null) {
//            Integer coadminID = (Integer) session.getAttribute("coadminId");
//            if (coadminID != null) {
//                return coadminID;
//            }
//        }
//        throw new ServletException("CoadminID not found in session.");
//    }

    private void saveFile(InputStream fileInputStream, int postID, int coadminID) throws ServletException {
        String sql = "INSERT INTO Image (PostID, CoadminID, ImageData) VALUES (?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, postID);
            stmt.setInt(2, coadminID); // Assuming this method exists or is implemented elsewhere
            stmt.setBlob(3, fileInputStream);
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Error saving file: " + e.getMessage());
        }
    }

}
