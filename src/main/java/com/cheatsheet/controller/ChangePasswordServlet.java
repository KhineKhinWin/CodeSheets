package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.User;
import com.cheatsheet.repository.UserRepository;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserRepository userRepo;
    
    @Override
    public void init() throws ServletException {
        userRepo = new UserRepository();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        
        if(loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        
        if(loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if(currentPassword == null || currentPassword.trim().isEmpty()) {
            session.setAttribute("error", "Please enter your current password.");
            response.sendRedirect("changePassword");
            return;
        }
        
        if(newPassword == null || newPassword.trim().isEmpty()) {
            session.setAttribute("error", "Please enter a new password.");
            response.sendRedirect("changePassword");
            return;
        }
        
        if(newPassword.length() < 4) {
            session.setAttribute("error", "Password must be at least 4 characters long.");
            response.sendRedirect("changePassword");
            return;
        }
        
        if(!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "New password and confirm password do not match.");
            response.sendRedirect("changePassword");
            return;
        }
        
        try {
            // Verify current password
            boolean passwordValid = userRepo.verifyPassword(loginUser.getId(), currentPassword);
            if(!passwordValid) {
                session.setAttribute("error", "Current password is incorrect.");
                response.sendRedirect("changePassword");
                return;
            }
            
            // Update password
            boolean updated = userRepo.updatePassword(loginUser.getId(), newPassword);
            if(updated) {
                session.setAttribute("success", "Password changed successfully! Please login again.");
                session.invalidate(); // Logout user
                response.sendRedirect("login.jsp");
            } else {
                session.setAttribute("error", "Failed to change password. Please try again.");
                response.sendRedirect("changePassword");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred. Please try again.");
            response.sendRedirect("changePassword");
        }
    }
}