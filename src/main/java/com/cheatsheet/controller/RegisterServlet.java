package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.repository.UserRepository;
import com.cheatsheet.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    UserRepository repo = new UserRepository();

    // Show Register Page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    // Handle Register Form Submit
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username").trim();
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password");

        // ✅ ၁။ Email ရှိပြီးသားလား အရင်စစ်မယ်
        if (repo.isEmailExists(email)) {
            request.setAttribute("error", "This email is already registered. Please login.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return; // ရှေ့ဆက်မသွားတော့ဘဲ ဒီမှာတင် ရပ်လိုက်မယ်
        }

        // ၂။ Email မရှိသေးရင် ပုံမှန်အတိုင်း Register ဆက်လုပ်မယ်
        try {
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            user.setRole("user");

            int result = repo.register(user);
            if (result > 0) {
                response.sendRedirect("login.jsp?msg=success");
            } else {
                request.setAttribute("error", "Registration failed. Try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
