package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.Rating;
import com.cheatsheet.model.User;
import com.cheatsheet.repository.RatingRepository;

@WebServlet("/rate")
public class RatingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("userAllCheat");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("loginUser");

            System.out.println("=== DEBUG: RatingServlet doPost ===");
            System.out.println("loginUser from session: " + loginUser);

            if (loginUser == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Not logged in\"}");
                return;
            }

            int userId = loginUser.getId();
            String c = request.getParameter("cheatsheetId");
            String r = request.getParameter("rating");

            System.out.println("cheatsheetId param: " + c);
            System.out.println("rating param: " + r);

            if (c == null || r == null || c.trim().isEmpty() || r.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Missing parameters\"}");
                return;
            }

            int cheatsheetId = Integer.parseInt(c.trim());
            int ratingValue = Integer.parseInt(r.trim());

            RatingRepository repo = new RatingRepository();
            Rating rating = new Rating(userId, cheatsheetId, ratingValue);

            boolean success = false;
            if (repo.hasUserRated(userId, cheatsheetId)) {
                System.out.println("User already rated, updating...");
                success = repo.updateRating(rating);
            } else {
                System.out.println("User not rated yet, adding...");
                success = repo.addRating(rating);
            }
            
            System.out.println("Rating operation success: " + success);

            // ✅ Always return JSON for AJAX requests
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": " + success + "}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}