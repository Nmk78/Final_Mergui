package auth;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/signup")
public class signup extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("usernameOrBusinessName");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String userType = request.getParameter("role");
        String location = request.getParameter("location");
        String activationCode = request.getParameter("activationCode");

        if (username == null || password == null || email == null || phone == null || userType == null || location == null ||
            username.isEmpty() || password.isEmpty() || phone.isEmpty() || location.isEmpty() || email.isEmpty() || userType.isEmpty()) {
            response.sendRedirect("/Mergui_Project/signup.html?err=missing_parameters");
            return;
        }

        String jdbcURL = "jdbc:mysql://localhost:3306/mergui";
        String dbUser = "root";
        String dbPassword = "root";

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            if (userType.equalsIgnoreCase("coadmin")) {
                System.out.println("//Coadmin");
                System.out.println("Activation Code: " + activationCode);

                String checkCodeSql = "SELECT CodeID FROM ActivationCode WHERE Code = ? AND IsUsed = 0";
                statement = connection.prepareStatement(checkCodeSql);
                statement.setString(1, activationCode);
                resultSet = statement.executeQuery();

                if (resultSet.next()) {
                    int codeId = resultSet.getInt("CodeID");

                    String insertSql = "INSERT INTO coadmin (UserName, PasswordHash, email, phone, Location) VALUES (?, ?, ?, ?, ?)";
                    statement = connection.prepareStatement(insertSql);
                    statement.setString(1, username);
                    statement.setString(2, password);
                    statement.setString(3, email);
                    statement.setString(4, phone);
                    statement.setString(5, location);

                    int rowsInserted = statement.executeUpdate();

                    if (rowsInserted > 0) {
                        String getAdmin = "SELECT CoadminID FROM coadmin WHERE Email = ?";
                        PreparedStatement getAdminStmt = connection.prepareStatement(getAdmin);
                        getAdminStmt.setString(1, email);

                        ResultSet adminResultSet = getAdminStmt.executeQuery();
                        int coadminId = 0;
                        if (adminResultSet.next()) {
                            coadminId = adminResultSet.getInt("CoadminID");
                            System.out.println("CoadminID: " + coadminId);
                        } else {
                            System.out.println("No CoadminID found for the provided email.");
                            response.sendRedirect("/Mergui_Project/signup.html?err=no_coadmin_found");
                            return;
                        }

                        adminResultSet.close();
                        getAdminStmt.close();

                        String updateCodeSql = "UPDATE ActivationCode SET IsUsed = 1 WHERE CodeID = ?";
                        statement = connection.prepareStatement(updateCodeSql);
                        statement.setInt(1, codeId);
                        statement.executeUpdate();

                        HttpSession session = request.getSession();
                        session.setAttribute("name", username);
                        session.setAttribute("email", email);
                        session.setAttribute("userType", "admin");
                        session.setAttribute("phone", phone);
                        session.setAttribute("coadminId", coadminId);
                        response.sendRedirect("/Mergui_Project/coadmin.jsp");
                    } else {
                        response.sendRedirect("/Mergui_Project/signup.html?err=signup_failed");
                    }
                } else {
                    response.sendRedirect("/Mergui_Project/signup.html?err=invalid_activation_code");
                }
            } else {
                System.out.println("//Customer");

                String sql = "INSERT INTO customer (username, PasswordHash, email, phone) VALUES (?, ?, ?, ?)";
                statement = connection.prepareStatement(sql);
                statement.setString(1, username);
                statement.setString(2, password);
                statement.setString(3, email);
                statement.setString(4, phone);

                int rowsInserted = statement.executeUpdate();

                HttpSession session = request.getSession();
                if (rowsInserted > 0) {
                    session.setAttribute("name", username);
                    session.setAttribute("email", email);
                    session.setAttribute("userType", "user");
                    session.setAttribute("phone", phone);
                    response.sendRedirect("/Mergui_Project/user.jsp");
                } else {
                    response.sendRedirect("/Mergui_Project/signup.html?err=signup_failed");
                }
            }
        } catch (SQLException | ClassNotFoundException ex) {
            ex.printStackTrace();
            response.sendRedirect("/Mergui_Project/signup.html?err=signup_error");
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("/Mergui_Project/signup.html");
    }
}
