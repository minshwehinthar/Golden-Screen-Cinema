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
            response.sendRedirect("login.jsp");
            return;
        }

        ReviewDAO dao = new ReviewDAO();

        // --- DELETE REVIEW LOGIC ---
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int theaterId = Integer.parseInt(request.getParameter("theaterId"));
                dao.deleteReviewById(reviewId, user.getId());
                response.sendRedirect("reviews.jsp?theaterId=" + theaterId);
                return; // stop here after deletion
            } catch (NumberFormatException e) {
                response.sendRedirect("moduleReview.jsp");
                return;
            }
        }
        // --- END DELETE LOGIC ---

        // --- EXISTING ADD REVIEW LOGIC (unchanged) ---
        String reviewText = request.getParameter("reviewText");
        String isGood = request.getParameter("isGood");
        String theaterIdParam = request.getParameter("theaterId");
        String ratingParam = request.getParameter("rating");

        int theaterId = 0;
        int rating = 0;

        try {
            theaterId = Integer.parseInt(theaterIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("moduleReview.jsp");
            return;
        }

        try {
            rating = Integer.parseInt(ratingParam);
        } catch (NumberFormatException e) {
            rating = 0;
        }

        dao.addReview(user.getId(), theaterId, reviewText.trim(), isGood, rating);

        response.sendRedirect("reviews.jsp?theaterId=" + theaterId);
        // --- END EXISTING LOGIC ---
    }
}
