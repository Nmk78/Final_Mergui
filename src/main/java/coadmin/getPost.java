package coadmin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/getPost")
public class getPost extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/mergui";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        // Get the post ID from the request
        String postIdStr = request.getParameter("id");
        int postID = postIdStr != null ? Integer.parseInt(postIdStr) : 0;

        if (postID <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Invalid post ID");
            out.print(gson.toJson(error));
            out.flush();
            return;
        }

        // Fetch post details from the database
        JsonObject postDetails = new JsonObject();
        String sql = "SELECT * FROM Post WHERE PostID = ?";
        
        String jdbcURL = "jdbc:mysql://localhost:3306/mergui";
        String dbUser = "root";
        String dbPassword = "root";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
             PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, postID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    postDetails.addProperty("postID", rs.getInt("PostID"));
                    postDetails.addProperty("postType", rs.getString("PostType"));
                    postDetails.addProperty("title", rs.getString("Title"));
                    postDetails.addProperty("description", rs.getString("Description"));
                    postDetails.addProperty("location", rs.getString("Location"));
                    postDetails.addProperty("price", rs.getDouble("Price"));
                    postDetails.addProperty("offPercentage", rs.getDouble("OffPercentage"));
                    postDetails.addProperty("category", rs.getString("category"));
                    postDetails.addProperty("content", rs.getString("content"));
                    postDetails.addProperty("createdAt", rs.getTimestamp("CreatedAt").toString());
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    JsonObject error = new JsonObject();
                    error.addProperty("error", "Post not found");
                    out.print(gson.toJson(error));
                    out.flush();
                    return;
                }
            }
            
            // Fetch images associated with the post
            String imageSql = "SELECT * FROM Image WHERE PostID = ?";
            try (PreparedStatement imgStmt = conn.prepareStatement(imageSql)) {
                imgStmt.setInt(1, postID);
                try (ResultSet imgRs = imgStmt.executeQuery()) {
                    JsonObject images = new JsonObject();
                    int i = 0;
                    while (imgRs.next()) {
                        // Convert the image blob to a Base64 encoded string (simplified for demonstration)
                        byte[] imgBytes = imgRs.getBytes("ImageData");
                        String base64Image = java.util.Base64.getEncoder().encodeToString(imgBytes);
                        images.addProperty("image" + i, base64Image);
                        i++;
                    }
                    postDetails.add("images", images);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Database error: " + e.getMessage());
            out.print(gson.toJson(error));
            out.flush();
            return;
        }

        // Write the JSON response
        out.print(gson.toJson(postDetails));
        out.flush();
    }
}
