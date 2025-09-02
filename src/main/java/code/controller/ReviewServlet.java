package code.controller;

import code.dao.ReviewDAO;
import code.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("reviews.jsp?msg=loginfirst");
            return;
        }

        String reviewText = request.getParameter("reviewText");
        String isGood = request.getParameter("isGood");

        if (reviewText == null || reviewText.trim().isEmpty()) {
            response.sendRedirect("reviews.jsp?msg=empty");
            return;
        }

        if (!"yes".equals(isGood) && !"no".equals(isGood)) {
            isGood = "yes"; // default to yes if invalid
        }

        ReviewDAO dao = new ReviewDAO();
        boolean success = dao.addReview(user.getId(), reviewText.trim(), isGood);

        if (success) {
            response.sendRedirect("reviews.jsp?msg=success");
        } else {
            response.sendRedirect("reviews.jsp?msg=fail");
        }
    }
}
