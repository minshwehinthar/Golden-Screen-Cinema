package code.controller;

import code.dao.FoodDAO;
import code.model.FoodItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet("/add-food")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class AddFoodServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/add-food.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        Part filePart = request.getPart("image");
        String fileName = filePart.getSubmittedFileName();

        // Save file to server
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // Save food info to DB
        FoodItem food = new FoodItem();
        food.setName(name);
        food.setPrice(price);
        food.setImage(UPLOAD_DIR + "/" + fileName);

        FoodDAO dao = new FoodDAO();
        boolean success = dao.addFood(food);

        if (success) {
            response.sendRedirect("add-food.jsp?msg=success");
        } else {
            response.sendRedirect("add-food.jsp?msg=error");
        }
    }
}
