package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.repository.UserRepository;
import com.cheatsheet.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    UserRepository repo = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || password == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            email = email.trim();
            password = password.trim();

            User user = repo.login(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                
                // ✅ ထည့်ပေးရမယ့် အပိုင်း (ဒီနေရာက ပြင်ရမယ်)
                session.setAttribute("loginUser", user);
                session.setAttribute("userId", user.getId());        // 🔥 ADD THIS
                session.setAttribute("userEmail", user.getEmail());  // 🔥 ADD THIS (optional)
                session.setAttribute("userRole", user.getRole());    // 🔥 ADD THIS (optional)
                
                // Debug အတွက်
                System.out.println("=== LOGIN SUCCESS ===");
                System.out.println("User ID: " + user.getId());
                System.out.println("User Email: " + user.getEmail());
                System.out.println("Session ID: " + session.getId());
                
                if ("admin".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("adminDashboard");
                } else {
                    response.sendRedirect("home.jsp");
                }
            } else {
                request.setAttribute("error", "Invalid Email or Password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System Error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}