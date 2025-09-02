package code.controller;

import code.dao.UserDAO;
import code.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO dao = new UserDAO();

        // Get current user from session
        Object userObj = request.getSession().getAttribute("user");
        if (userObj != null) {
            String email = ((User) userObj).getEmail();
            dao.updateStatus(email, "banned"); // mark user inactive
        }

        // Invalidate session
        request.getSession().invalidate();

        // Redirect to login with message
        response.sendRedirect("login.jsp?msg=logout");
    }
}
