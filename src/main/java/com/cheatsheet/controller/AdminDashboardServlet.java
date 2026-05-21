package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.repository.AdminRepository;
import com.cheatsheet.repository.UserRepository;
import com.cheatsheet.repository.RatingRepository;  // ✅ ADD THIS

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    try {
	        AdminRepository adminRepo = new AdminRepository();
	        UserRepository userRepo = new UserRepository();
	        com.cheatsheet.repository.CheatsheetRepository cheatRepo = new com.cheatsheet.repository.CheatsheetRepository();
	        RatingRepository ratingRepo = new RatingRepository();  // ✅ ADD THIS

	        int totalUsers = userRepo.countUsers();
	        int totalSheets = cheatRepo.countCheatsheets(); 
	        int totalComments = adminRepo.getCount("comments");
	        int totalLikes = adminRepo.getCount("likes");
	        
	        // ✅ ADD THIS - Total Ratings
	        int totalRatings = ratingRepo.getTotalRatingCount();
	        System.out.println("DEBUG: Total Ratings from DB = " + totalRatings); 
	        java.util.List<com.cheatsheet.model.CheatSheet> allSheets = cheatRepo.getAllCheatSheetsForAdmin();

	        request.setAttribute("totalUsers", totalUsers);
	        request.setAttribute("totalSheets", totalSheets);
	        request.setAttribute("totalComments", totalComments);
	        request.setAttribute("totalLikes", totalLikes);
	        request.setAttribute("totalRatings", totalRatings);  // ✅ ADD THIS
	        request.setAttribute("allSheets", allSheets);

	        RequestDispatcher rd = request.getRequestDispatcher("/admin/dashboard.jsp");
	        rd.forward(request, response);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}