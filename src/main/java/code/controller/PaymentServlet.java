package code.controller;

import code.dao.OrderDAO;
import code.model.CartItem;
import code.model.Order;
import code.model.OrderItem;
import code.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String payment = request.getParameter("payment");
        int theaterId = Integer.parseInt(request.getParameter("theaterId"));

        // Get cart items from session
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        if(cartItems == null || cartItems.isEmpty()){
            response.sendRedirect("cart.jsp");
            return;
        }

        // Prepare order items and calculate total
        double totalAmount = 0;
        List<OrderItem> orderItems = new ArrayList<>();
        for(CartItem c : cartItems){
            totalAmount += c.getFood().getPrice() * c.getQuantity();
            OrderItem oi = new OrderItem();
            oi.setFood(c.getFood());
            oi.setQuantity(c.getQuantity());
            oi.setPrice(c.getFood().getPrice());
            orderItems.add(oi);
        }

        // Create Order object
        Order order = new Order();
        order.setUserId(user.getId());
        order.setTheaterId(theaterId);
        order.setPaymentMethod(payment);
        order.setStatus("pending");
        order.setTotalAmount(totalAmount);
        order.setItems(orderItems);

        // Place order
        OrderDAO orderDAO = new OrderDAO();
        boolean placed = orderDAO.placeOrder(order); // use your original method

        if(placed){
            session.removeAttribute("cartItems"); // clear cart
            response.sendRedirect("order-success.jsp?orderId=" + order.getId());
        } else {
            response.getWriter().println("Payment failed, please try again.");
        }
    }
}
