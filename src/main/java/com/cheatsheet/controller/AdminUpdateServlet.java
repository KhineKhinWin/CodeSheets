package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/updateSheet")
public class AdminUpdateServlet extends HttpServlet {
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    int id = Integer.parseInt(request.getParameter("id"));
    String title = request.getParameter("title");
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
    String content = request.getParameter("content");

    // ✅ status ကို လက်ခံပါ၊ မပါလာရင် PUBLIC လို့ Default ထားပါ
    String status = request.getParameter("status");
    if (status == null || status.isEmpty()) {
        status = "PUBLIC"; 
    }

    CheatsheetRepository repo = new CheatsheetRepository();
    
    // ✅ Parameter ၅ ခုလုံး ပြည့်အောင် ထည့်ပေးလိုက်ပါ
    repo.updateSheet(id, title, categoryId, content, status);

    response.sendRedirect(request.getContextPath() + "/adminDashboard");
    }
}