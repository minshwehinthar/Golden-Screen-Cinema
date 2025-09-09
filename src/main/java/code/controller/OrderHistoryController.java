package code.controller;

import code.dao.MyConnection;
import code.dao.OrderHistoryDAO;
import code.model.OrderHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;


@WebServlet("/order-history")
public class OrderHistoryController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = MyConnection.getConnection(); // your connection method
            OrderHistoryDAO dao = new OrderHistoryDAO(conn);

            List<OrderHistory> orders = dao.getAllOrderHistory();

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("order-history.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
