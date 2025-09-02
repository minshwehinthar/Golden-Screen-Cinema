package code.controller;

//import code.dao.FoodDAO;
import code.model.Food;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/admin-add-food")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class AdminAddFoodServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        int price = Integer.parseInt(req.getParameter("price"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        String category = req.getParameter("category");

        // handle file upload
        Part filePart = req.getPart("image");
        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            String appPath = req.getServletContext().getRealPath("");
            String savePath = appPath + File.separator + UPLOAD_DIR;
            File uploadDir = new File(savePath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            filePart.write(savePath + File.separator + fileName);
        }

        Food food = new Food();
        food.setName(name);
        food.setDescription(description);
        food.setPrice(price);
        food.setQuantity(quantity);
        food.setCategory(category);
        food.setImage(fileName);

//        FoodDAO dao = new FoodDAO();
//        boolean success = dao.addFood(food);
//
//        if (success) {
//            resp.sendRedirect("admin_add_food.jsp?msg=success");
//        } else {
//            resp.sendRedirect("admin_add_food.jsp?msg=error");
//        }
    }
}
