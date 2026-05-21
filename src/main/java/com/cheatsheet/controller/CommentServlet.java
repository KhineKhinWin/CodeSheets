package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.Comment;
import com.cheatsheet.repository.CommentRepository;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CommentRepository commentRepo = new CommentRepository();
    
    // Helper method to escape JSON strings
    private String escapeJson(String s) {
        if(s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if("get".equals(action)) {
            int cheatsheetId = Integer.parseInt(request.getParameter("cheatsheetId"));
            
            try {
                List<Comment> comments = commentRepo.getCommentsByCheatsheetId(cheatsheetId);
                
                StringBuilder json = new StringBuilder("[");
                for(int i = 0; i < comments.size(); i++) {
                    Comment c = comments.get(i);
                    
                    json.append("{")
                        .append("\"id\":").append(c.getId()).append(",")
                        .append("\"userName\":\"").append(escapeJson(c.getUserName())).append("\",")
                        .append("\"content\":\"").append(escapeJson(c.getContent())).append("\",")
                        .append("\"createdAt\":\"").append(c.getCreatedAt()).append("\",")
                        .append("\"parent_comment_id\":").append(c.getParentCommentId() == null ? "null" : c.getParentCommentId())
                        .append("}");
                    
                    if(i < comments.size() - 1) json.append(",");
                }
                json.append("]");
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json.toString());
                
            } catch(Exception e) {
                e.printStackTrace();
                response.setStatus(500);
                response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
            }
            return;
        }
        
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            com.cheatsheet.model.User loginUser = (com.cheatsheet.model.User) session.getAttribute("loginUser");
            
            if (loginUser == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Not logged in\"}");
                return;
            }
            
            int userId = loginUser.getId();
            String action = request.getParameter("action");
            String cheatsheetIdStr = request.getParameter("cheatsheetId");
            
            System.out.println("=== DEBUG ===");
            System.out.println("action: " + action);
            System.out.println("cheatsheetIdStr: " + cheatsheetIdStr);
            
            if(cheatsheetIdStr == null || cheatsheetIdStr.isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Missing cheatsheetId\"}");
                return;
            }
            
            int cheatsheetId = Integer.parseInt(cheatsheetIdStr);
            
            if ("add".equals(action)) {
                String content = request.getParameter("content");
                
                // ✅ Get parent_comment_id parameter
                String parentIdParam = request.getParameter("parent_comment_id");
                System.out.println("parent_comment_id from request: " + parentIdParam);
                
                Integer parentId = null;
                if (parentIdParam != null && !parentIdParam.isEmpty() && !parentIdParam.equals("null")) {
                    parentId = Integer.parseInt(parentIdParam);
                }
                
                System.out.println("content: " + content);
                System.out.println("parentId: " + parentId);
                
                if (content != null && !content.trim().isEmpty()) {
                    Comment comment = new Comment(userId, cheatsheetId, content.trim(), parentId);
                    boolean success = commentRepo.addComment(comment);
                    System.out.println("Comment added success: " + success);
                    
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": " + success + "}");
                    return;
                } else {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"error\": \"Content is empty\"}");
                    return;
                }
            }
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"error\": \"Unknown action\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}