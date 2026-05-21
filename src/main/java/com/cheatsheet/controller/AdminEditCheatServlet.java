package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.cheatsheet.model.Category;
import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/editSheet")
public class AdminEditCheatServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            CheatsheetRepository repo = new CheatsheetRepository();

            // ✅ getCheatsheetByIdWithExample ကိုသုံးပါ (example_code ပါ)
            CheatSheet sheet = repo.getCheatsheetByIdWithExample(id);

            List<Category> categories = repo.getAllCategories();

            request.setAttribute("sheet", sheet);
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/admin/edit_cheat.jsp")
                    .forward(request, response);
                    
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manageSheets?error=notfound");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String content = request.getParameter("content");
            String exampleCode = request.getParameter("example_code");
            String status = request.getParameter("status");
            
            if (status == null || status.isEmpty()) {
                status = "PUBLIC";
            }

            CheatsheetRepository repo = new CheatsheetRepository();
            
            repo.updateSheetWithExample(id, title, categoryId, content, exampleCode, status);

            response.sendRedirect(request.getContextPath() + "/manageSheets?success=edit");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manageSheets?error=update");
        }
    }
}