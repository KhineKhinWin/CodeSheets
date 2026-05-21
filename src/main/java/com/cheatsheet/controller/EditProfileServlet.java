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

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Forward to JSP (not direct access)
        request.getRequestDispatcher("/WEB-INF/views/editProfile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        
        if(loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        
        // Validation
        if(username == null || username.trim().isEmpty()) {
            session.setAttribute("error", "Username cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/editProfile");
            return;
        }
        
        if(email == null || email.trim().isEmpty()) {
            session.setAttribute("error", "Email cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/editProfile");
            return;
        }
        
        try {
            // Check if username already exists (for another user)
            User existingUser = userRepo.getUserByUsername(username);
            if(existingUser != null && existingUser.getId() != loginUser.getId()) {
                session.setAttribute("error", "Username already taken.");
                response.sendRedirect(request.getContextPath() + "/editProfile");
                return;
            }
            
            // Check if email already exists (for another user)
            User existingEmail = userRepo.getUserByEmail(email);
            if(existingEmail != null && existingEmail.getId() != loginUser.getId()) {
                session.setAttribute("error", "Email already registered.");
                response.sendRedirect(request.getContextPath() + "/editProfile");
                return;
            }
            
            // Update user
            loginUser.setUsername(username);
            loginUser.setEmail(email);
            
            boolean updated = userRepo.updateUser(loginUser);
            if(updated) {
                session.setAttribute("loginUser", loginUser);
                session.setAttribute("success", "Profile updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update profile. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred. Please try again.");
        }
        
        response.sendRedirect(request.getContextPath() + "/editProfile");
    }
}