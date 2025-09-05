package code.controller;

import code.dao.OrderDAO;
import code.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/orders")
public class AdminOrderController extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get pending orders
        List<Order> pendingOrders = orderDAO.getPendingOrders();
        request.setAttribute("pendingOrders", pendingOrders);

        // Get completed orders for history
        List<Order> completedOrders = orderDAO.getCompletedOrders();
        request.setAttribute("completedOrders", completedOrders);

        request.getRequestDispatcher("orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin confirms order
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        orderDAO.confirmOrder(orderId);

        response.sendRedirect("orders");
    }
}
