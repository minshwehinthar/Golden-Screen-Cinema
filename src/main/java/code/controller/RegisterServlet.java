package code.controller;

import code.dao.UserDAO;
import code.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Get form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Create User object
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        user.setRole("user");       // default role
        user.setStatus("active");   // default status

        // Call DAO
        UserDAO dao = new UserDAO();

        try {
            // Check if email exists
            if (dao.existsByEmail(email)) {
                response.sendRedirect("register.jsp?msg=exists");
                return;
            }

            // Register user
            boolean success = dao.register(user);

            if (success) {
                response.sendRedirect("login.jsp?msg=success");
            } else {
                response.sendRedirect("register.jsp?msg=fail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?msg=fail");
        }
    }
}
