package coadmin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/businessProfile")
public class BusinessProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/mergui";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "root";
    private static final Logger LOGGER = Logger.getLogger(BusinessProfileServlet.class.getName());

    Connection conn = null;
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createBusinessProfile(request, response);
                    break;
                case "update":
                    updateBusinessProfile(request, response);
                    break;
                case "delete":
                    deleteBusinessProfile(request, response);
                    break;
                default:
                    throw new ServletException("Unknown action: " + action);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing request", e);
            String errorMessage = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
        }
    }

    private void createBusinessProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException {
        String businessName = request.getParameter("businessName");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String coadminIdStr = request.getParameter("coadminId");

        if (businessName == null || location == null || coadminIdStr == null ||
            businessName.isEmpty() || location.isEmpty() || coadminIdStr.isEmpty()) {
            String errorMessage = URLEncoder.encode("Missing required fields", StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
            return;
        }

        int coadminId;
        try {
            coadminId = Integer.parseInt(coadminIdStr);
        } catch (NumberFormatException e) {
            String errorMessage = URLEncoder.encode("Invalid coadmin ID format", StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
            return;
        }

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the connection
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
            PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO businessprofile (BusinessName, Location, Description, CoadminID) VALUES (?, ?, ?, ?)");

            stmt.setString(1, businessName);
            stmt.setString(2, location);
            stmt.setString(3, description);
            stmt.setInt(4, coadminId);

            stmt.executeUpdate();
            response.sendRedirect("coamdin.jsp?message=" + URLEncoder.encode("Business profile created successfully", StandardCharsets.UTF_8.toString()));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error during profile creation", e);
            String errorMessage = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
        }
    }

    private void updateBusinessProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            String errorMessage = URLEncoder.encode("Invalid ID format", StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
            return;
        }

        String businessName = request.getParameter("businessName");
        String location = request.getParameter("location");
        String description = request.getParameter("description");

        if (businessName == null || location == null ||
            businessName.isEmpty() || location.isEmpty()) {
            String errorMessage = URLEncoder.encode("Missing required fields", StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
            return;
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement stmt = conn.prepareStatement(
                     "UPDATE businessprofile SET BusinessName = ?, Location = ?, Description = ? WHERE BusinessProfileID = ?")) {

            stmt.setString(1, businessName);
            stmt.setString(2, location);
            stmt.setString(3, description);
            stmt.setInt(4, id);

            stmt.executeUpdate();
            response.sendRedirect("coamdin.jsp?message=" + URLEncoder.encode("Business profile updated successfully", StandardCharsets.UTF_8.toString()));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error during profile update", e);
            String errorMessage = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
        }
    }

    private void deleteBusinessProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            String errorMessage = URLEncoder.encode("Invalid ID format", StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
            return;
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM businessprofile WHERE BusinessProfileID = ?")) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
            response.sendRedirect("coamdin.jsp?message=" + URLEncoder.encode("Business profile deleted successfully", StandardCharsets.UTF_8.toString()));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error during profile deletion", e);
            String errorMessage = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8.toString());
            response.sendRedirect("error.jsp?message=" + errorMessage);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for reading business profiles can be added here
    }
}
