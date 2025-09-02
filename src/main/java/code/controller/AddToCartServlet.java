package code.controller;

import code.model.FoodOrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int foodId = Integer.parseInt(req.getParameter("foodId"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        int price = Integer.parseInt(req.getParameter("price"));

        HttpSession session = req.getSession();
        List<FoodOrderItem> cart = (List<FoodOrderItem>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();

        boolean found = false;
        for(FoodOrderItem item : cart){
            if(item.getFoodId() == foodId){
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }
        if(!found){
            cart.add(new FoodOrderItem(foodId, quantity, price));
        }

        session.setAttribute("cart", cart);
        resp.sendRedirect("view-cart");
    }
}
