package coadmin;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
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

@WebServlet("/getPosts")
public class GetPostsServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/mergui";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        // Retrieve query parameters
        String postType = request.getParameter("postType");
        String category = request.getParameter("category"); // Optional filtering
        String coadminId = request.getParameter("coadminId"); // Optional filtering

        StringBuilder sqlBuilder = new StringBuilder();

        // Always start with the base query
        sqlBuilder.append("SELECT * FROM Post ");
        sqlBuilder.append("JOIN Coadmin ON Post.CoadminID = Coadmin.CoadminID ");

        // Check if any conditions are present
        boolean hasCondition = false;

        if (postType != null || category != null || coadminId != null) {
            sqlBuilder.append("WHERE ");
            
            if (postType != null) {
                sqlBuilder.append("Post.PostType = ?");
                hasCondition = true; // Indicates that a condition has been added
            }

            if (category != null) {
                if (hasCondition) {
                    sqlBuilder.append(" AND ");
                }
                sqlBuilder.append("Post.category = ?");
                hasCondition = true; // Indicates that a condition has been added
            }

            if (coadminId != null) {
                if (hasCondition) {
                    sqlBuilder.append(" AND ");
                }
                sqlBuilder.append("Post.CoadminID = ?");
            }
        }

        // Add ordering clause
        sqlBuilder.append(" ORDER BY Post.CreatedAt DESC");

        // Log or print the query for debugging
        System.out.println("Constructed SQL Query: " + sqlBuilder.toString());

        JsonArray postsArray = new JsonArray();
        
        String jdbcURL = "jdbc:mysql://localhost:3306/mergui";
        String dbUser = "root";
        String dbPassword = "root";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

             PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString());

            int paramIndex = 1;
            
            // Set parameters in the PreparedStatement
            if (postType != null) {
                stmt.setString(paramIndex++, postType);
            }
            if (category != null) {
                stmt.setString(paramIndex++, category);
            }
            if (coadminId != null) {
                stmt.setString(paramIndex++, coadminId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    JsonObject post = new JsonObject();
                    post.addProperty("PostID", rs.getInt("PostID"));
                    post.addProperty("CoadminID", rs.getInt("CoadminID"));
                    post.addProperty("CoadminName", rs.getString("username")); // Add coadmin name
                    post.addProperty("PostType", rs.getString("PostType"));
                    post.addProperty("Title", rs.getString("Title"));
                    post.addProperty("Description", rs.getString("Description"));
                    post.addProperty("Location", rs.getString("Location"));
                    post.addProperty("Price", rs.getBigDecimal("Price").toString());
                    post.addProperty("RoomType", rs.getString("RoomType"));
                    post.addProperty("TableNumber", rs.getObject("TableNumber") != null ? rs.getInt("TableNumber") : null);
                    post.addProperty("VehicleType", rs.getString("VehicleType"));
                    post.addProperty("VehicleNumber", rs.getString("VehicleNumber"));
                    post.addProperty("CreatedAt", rs.getTimestamp("CreatedAt").toString());
                    post.addProperty("offPercentage", rs.getBigDecimal("offPercentage").toString());
                    post.addProperty("contact", rs.getString("contact"));
                    post.addProperty("category", rs.getString("category"));
                    post.addProperty("content", rs.getString("content"));

                    postsArray.add(post);
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
        out.print(gson.toJson(postsArray));
        out.flush();
    }
}
