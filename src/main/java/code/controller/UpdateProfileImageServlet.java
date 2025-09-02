package code.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import code.dao.UserDAO;
import code.model.User;

@WebServlet("/updateProfileImage")
@MultipartConfig
public class UpdateProfileImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            // Save path
            String uploadPath = getServletContext().getRealPath("") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            // Unique file name
            String fileName = "user_" + user.getId() + "_" + System.currentTimeMillis() + ".jpg";
            File file = new File(uploadDir, fileName);

            // Save file
            Files.copy(filePart.getInputStream(), file.toPath(), StandardCopyOption.REPLACE_EXISTING);

            // Delete old file
            if (user.getImage() != null) {
                File oldFile = new File(uploadDir, user.getImage());
                if (oldFile.exists()) oldFile.delete();
            }

            // Update DB
            UserDAO dao = new UserDAO();
            dao.updateField(user.getId(), "image", fileName);

            // Update session
            user.setImage(fileName);
            request.getSession().setAttribute("user", user);
        }

        response.sendRedirect("profile.jsp");
    }
}
