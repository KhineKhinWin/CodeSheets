package com.cheatsheet.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.cheatsheet.model.User;
import com.cheatsheet.repository.FavoriteRepository;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Repository ကို တစ်ခါတည်း Initialize လုပ်ထားမယ်
    private FavoriteRepository favoriteRepository = new FavoriteRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        
        // ၁။ Login Check
        if (loginUser == null) {
            out.print("{\"status\":\"error\", \"message\":\"Please login first\"}");
            return;
        }
        
        // ၂။ Parameter Check
        String cheatsheetIdParam = request.getParameter("cheatsheetId");
        if (cheatsheetIdParam == null || cheatsheetIdParam.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\":\"Missing cheatsheetId\"}");
            return;
        }
        
        try {
            int userId = loginUser.getId();
            int cheatsheetId = Integer.parseInt(cheatsheetIdParam);
            
            // ၃။ Repository ကို အသုံးပြု၍ Business Logic ကို စစ်ဆေးခြင်း
            if (favoriteRepository.isFavoriteExists(userId, cheatsheetId)) {
                // ရှိပြီးသားမို့ ပြန်ဖျက်မယ်
                boolean removed = favoriteRepository.removeFavorite(userId, cheatsheetId);
                if (removed) {
                    out.print("{\"status\":\"success\", \"action\":\"removed\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Failed to remove favorite\"}");
                }
            } else {
                // မရှိသေးလို့ အသစ်ထည့်မယ်
                boolean added = favoriteRepository.addFavorite(userId, cheatsheetId);
                if (added) {
                    out.print("{\"status\":\"success\", \"action\":\"added\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Failed to add favorite\"}");
                }
            }
        } catch (NumberFormatException e) {
            out.print("{\"status\":\"error\", \"message\":\"Invalid Cheatsheet ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\", \"message\":\"Server error occurred\"}");
        }
    }
}