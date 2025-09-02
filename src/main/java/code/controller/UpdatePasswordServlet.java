package code.controller;

import code.dao.UserDAO;
import code.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/updatePassword")
public class UpdatePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        UserDAO dao = new UserDAO();
        boolean success = false;

        if (user.getPassword().equals(oldPassword)) {
            success = dao.updateField(user.getId(), "password", newPassword);
            if (success) {
                user.setPassword(newPassword);
                request.getSession().setAttribute("user", user);
            }
        }

        if (success) {
            response.sendRedirect("profile.jsp?msg=passwordUpdated");
        } else {
            response.sendRedirect("profile.jsp?msg=passwordError");
        }
    }
}
