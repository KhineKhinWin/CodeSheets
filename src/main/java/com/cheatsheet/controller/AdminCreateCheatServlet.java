package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.cheatsheet.model.Category;
import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/createSheet")
public class AdminCreateCheatServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        CheatsheetRepository repo =
                new CheatsheetRepository();

        List<Category> categories =
                repo.getAllCategories();

        request.setAttribute("categories", categories);

        request.getRequestDispatcher(
                "/admin/create_cheat.jsp")
                .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String content = request.getParameter("content");
        String exampleCode = request.getParameter("example_code");

        // ✅ ပြောင်းလဲလိုက်သောနေရာ: JSP ကနေ လှမ်းယူစရာမလိုဘဲ PUBLIC လို့ တိုက်ရိုက်သတ်မှတ်မယ်
        String status = "PUBLIC"; 

        // temporary user id (အကယ်၍ session ရှိရင် loginUser.getId() သုံးပါ)
        int userId = 1;

        CheatsheetRepository repo = new CheatsheetRepository();

        // Repository ကို ပို့တဲ့အခါ status နေရာမှာ "PUBLIC" ရောက်သွားပါလိမ့်မယ်
        repo.createCheatSheet(title, categoryId, content, exampleCode, userId, status);

        response.sendRedirect(request.getContextPath() + "/adminDashboard");
    }
}