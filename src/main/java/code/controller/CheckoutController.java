package code.controller;

import code.dao.CartDAO;
import code.dao.OrderDAO;
import code.dao.TheaterDAO;
import code.model.CartItem;
import code.model.Order;
import code.model.OrderItem;
import code.model.Theater;
import code.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private TheaterDAO theaterDAO = new TheaterDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // prevent creating new session
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("login.jsp"); // no ?msg=unauthorized
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
        List<Theater> theaters = theaterDAO.getAllTheaters();

        request.setAttribute("cartItems", cartItems != null ? cartItems : new ArrayList<>());
        request.setAttribute("theaters", theaters != null ? theaters : new ArrayList<>());
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int theaterId = Integer.parseInt(request.getParameter("theaterId"));
            String paymentMethod = request.getParameter("paymentMethod");

            List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
            if (cartItems == null || cartItems.isEmpty()) {
                response.sendRedirect("checkout.jsp?error=emptycart");
                return;
            }

            double totalAmount = cartItems.stream()
                    .mapToDouble(c -> c.getFood().getPrice() * c.getQuantity())
                    .sum();

            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem c : cartItems) {
                OrderItem item = new OrderItem();
                item.setFood(c.getFood());
                item.setQuantity(c.getQuantity());
                item.setPrice(c.getFood().getPrice());
                orderItems.add(item);
            }

            Order order = new Order();
            order.setUserId(user.getId());
            order.setTheaterId(theaterId);
            order.setTotalAmount(totalAmount);
            order.setPaymentMethod(paymentMethod);
            order.setStatus("pending"); // initial status pending
            order.setItems(orderItems);

            boolean success = orderDAO.placeOrder(order);

            if (success) {
                cartDAO.clearCart(user.getId());
                response.sendRedirect("order-success.jsp?orderId=" + order.getId());
            } else {
                response.sendRedirect("checkout.jsp?error=true");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp?error=true");
        }
    }
}
