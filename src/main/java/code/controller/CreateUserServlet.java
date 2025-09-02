package code.controller;

import code.dao.UserDAO;
import code.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.time.LocalDate;

@WebServlet("/CreateUserServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1,  // 1MB
                 maxFileSize = 1024 * 1024 * 10,       // 10MB
                 maxRequestSize = 1024 * 1024 * 15)    // 15MB
public class CreateUserServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            User user = new User();
            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setRole(request.getParameter("role"));
            user.setPassword(request.getParameter("password")); // Ideally, hash passwords

            // Birth date
            String birthDateStr = request.getParameter("birth_date");
            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                user.setBirthDate(LocalDate.parse(birthDateStr));
            }

            user.setGender(request.getParameter("gender"));
            user.setStatus("active"); // default status

            // Handle image upload
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
                user.setImage(UPLOAD_DIR + "/" + fileName);
            }

            // Insert user into DB
            UserDAO dao = new UserDAO();
            if (dao.createUser(user)) {
                response.sendRedirect("createUser.jsp?msg=User created successfully");
            } else {
                response.sendRedirect("createUser.jsp?msg=Error creating user");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("createUser.jsp?msg=Exception occurred: " + e.getMessage());
        }
    }
}
