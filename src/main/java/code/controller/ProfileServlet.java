package code.controller;

import code.dao.UserDAO;
import code.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp?msg=loginRequired");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp?msg=loginRequired");
            return;
        }

        String field = request.getParameter("field"); // name, email, phone, birth_date, gender
        String value = request.getParameter("value");

        UserDAO dao = new UserDAO();
        boolean updated = false;

        try {
            switch (field) {
                case "name":
                    user.setName(value);
                    updated = dao.updateField(user.getId(), "name", value);
                    break;
                case "email":
                    user.setEmail(value);
                    updated = dao.updateField(user.getId(), "email", value);
                    break;
                case "phone":
                    user.setPhone(value);
                    updated = dao.updateField(user.getId(), "phone", value);
                    break;
                case "birth_date":
                    if (value != null && !value.isEmpty()) {
                        user.setBirthDate(LocalDate.parse(value));
                    }
                    updated = dao.updateField(user.getId(), "birth_date", value);
                    break;
                case "gender":
                    user.setGender(value);
                    updated = dao.updateField(user.getId(), "gender", value);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (updated) {
            request.getSession().setAttribute("user", user); // refresh session
            response.sendRedirect("profile.jsp?msg=updated");
        } else {
            response.sendRedirect("profile.jsp?msg=error");
        }
    }
}
