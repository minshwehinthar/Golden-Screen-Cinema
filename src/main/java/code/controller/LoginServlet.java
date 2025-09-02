package code.controller;

import code.dao.UserDAO;
import code.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        if (user != null) {
            // Update last login
            dao.updateLastLogin(user.getId(), LocalDateTime.now());

            // Update status to active
            dao.updateStatus(email, "active");

            // Save user in session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Redirect based on role
            if ("admin".equals(user.getRole())|| "employee".equals(user.getRole())) {
                response.sendRedirect("index.jsp"); // admin dashboard
            } else {
                response.sendRedirect("index-user.jsp"); // regular user dashboard
            }

        } else {
            response.sendRedirect("login.jsp?msg=invalid");
        }
    }
}
