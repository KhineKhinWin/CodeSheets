package com.cheatsheet.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.Comment;
import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.model.User;
import com.cheatsheet.repository.CommentRepository;
import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/manageComments")
public class ManageCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CommentRepository commentRepo = new CommentRepository();
    private CheatsheetRepository cheatsheetRepo = new CheatsheetRepository();
    
    public ManageCommentServlet() {
        super();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        
        // Check if admin is logged in
        if(loginUser == null || !"admin".equals(loginUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        // Handle delete action
        if("delete".equals(action)) {
            try {
                int commentId = Integer.parseInt(request.getParameter("commentId"));
                boolean deleted = commentRepo.deleteComment(commentId);
                if(deleted) {
                    response.sendRedirect(request.getContextPath() + "/manageComments?success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/manageComments?error=delete");
                }
            } catch(Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manageComments?error=delete");
            }
            return;
        }
        
        try {
            // Get all cheatsheets for filter dropdown
            List<CheatSheet> allCheatsheets = cheatsheetRepo.getAllCheatSheetsForAdmin();
            
            // Handle filter by cheatsheet
            String filterCheatsheetId = request.getParameter("cheatsheetId");
            List<Comment> allComments = new ArrayList<>();
            
            if(filterCheatsheetId != null && !filterCheatsheetId.isEmpty()) {
                int csId = Integer.parseInt(filterCheatsheetId);
                // Get comments for specific cheatsheet
                allComments = commentRepo.getCommentsByCheatsheetId(csId);
            } else {
                // Get all comments from all cheatsheets
                for(CheatSheet cs : allCheatsheets) {
                    allComments.addAll(commentRepo.getCommentsByCheatsheetId(cs.getId()));
                }
            }
            
            // Build comment tree structure for replies
            List<Comment> topLevelComments = commentRepo.buildCommentTree(allComments);
            
            // Sort top level comments by date (newest first)
            topLevelComments.sort((a, b) -> {
                if(a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
                if(a.getCreatedAt() == null) return 1;
                if(b.getCreatedAt() == null) return -1;
                return b.getCreatedAt().compareTo(a.getCreatedAt());
            });
            
            // Calculate statistics
            int totalComments = allComments.size();
            int totalReplies = 0;
            for(Comment c : allComments) {
                if(c.getParentCommentId() != null) totalReplies++;
            }
            
            // Get unique users count
            java.util.Set<String> uniqueUsers = new java.util.HashSet<>();
            for(Comment c : allComments) {
                uniqueUsers.add(c.getUserName());
            }
            
            // Calculate today's comments
            int todayCount = 0;
            java.time.LocalDate today = java.time.LocalDate.now();
            for(Comment c : allComments) {
                if(c.getCreatedAt() != null) {
                    java.time.LocalDate commentDate = c.getCreatedAt().toLocalDateTime().toLocalDate();
                    if(commentDate.equals(today)) todayCount++;
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("topLevelComments", topLevelComments);
            request.setAttribute("cheatsheets", allCheatsheets);
            request.setAttribute("filterCheatsheetId", filterCheatsheetId);
            request.setAttribute("totalComments", totalComments);
            request.setAttribute("totalReplies", totalReplies);
            request.setAttribute("totalCheatsheets", allCheatsheets.size());
            request.setAttribute("uniqueUsers", uniqueUsers.size());
            request.setAttribute("todayComments", todayCount);
            
            // Forward to JSP
            request.getRequestDispatcher("/admin/manage_comment.jsp").forward(request, response);
            
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminDashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}