package code.controller;

import code.dao.CartDAO;
import code.model.CartItem;
import code.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Handle remove/update actions
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "remove":
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    cartDAO.removeItem(cartId);
                    break;
                case "update":
                    int updateCartId = Integer.parseInt(request.getParameter("cartId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    if (quantity < 1) quantity = 1;
                    cartDAO.updateQuantity(updateCartId, quantity);
                    break;
            }
            response.sendRedirect("cart");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
        double totalAmount = cartItems.stream().mapToDouble(CartItem::getTotalPrice).sum();

        int cartCount = cartDAO.getCartCount(user.getId());
        session.setAttribute("cartCount", cartCount);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int foodId = Integer.parseInt(request.getParameter("food_id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity < 1) quantity = 1;

            cartDAO.addToCart(user.getId(), foodId, quantity);

            int cartCount = cartDAO.getCartCount(user.getId());
            session.setAttribute("cartCount", cartCount);

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // Redirect back to the current food details page
        response.sendRedirect("foods?action=details&id=" + request.getParameter("food_id"));
    }

}
