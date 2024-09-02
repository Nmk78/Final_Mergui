package coadmin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/deletePost")
public class DeletePostServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/mergui";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String postIdStr = request.getParameter("postId");

        if (postIdStr == null) {
            throw new ServletException("Post ID is required.");
        }

        int postID = Integer.parseInt(postIdStr);

        // Delete post from the database
        String jdbcURL = "jdbc:mysql://localhost:3306/mergui";
        String dbUser = "root";
        String dbPassword = "root";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Start a transaction
            conn.setAutoCommit(false);
            
            // Delete associated images first (if needed)
            String deleteImagesSql = "DELETE FROM Image WHERE PostID = ?";
            try (PreparedStatement deleteImagesStmt = conn.prepareStatement(deleteImagesSql)) {
                deleteImagesStmt.setInt(1, postID);
                deleteImagesStmt.executeUpdate();
            }

            // Delete the post
            String deletePostSql = "DELETE FROM Post WHERE PostID = ?";
            try (PreparedStatement deletePostStmt = conn.prepareStatement(deletePostSql)) {
                deletePostStmt.setInt(1, postID);
                deletePostStmt.executeUpdate();
            }

            // Commit the transaction
            conn.commit();
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("Database error: " + e.getMessage());
        }

        response.sendRedirect("coadmin.jsp?message=Post deleted successfully");
    }
}
