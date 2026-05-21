package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.repository.CheatsheetRepository;
import com.cheatsheet.model.CheatSheet;

@WebServlet("/searchCheatsheet")
public class SearchCheatServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        CheatsheetRepository repo = new CheatsheetRepository();
        List<CheatSheet> list = new ArrayList<>();

        try {
            // Keyword ရှိရင် ရှာမယ်၊ မရှိရင် အကုန်ပြမယ်
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = repo.search(keyword);
            } else {
                list = repo.getAllCheatSheets();
            }

            // ✅ အရေးကြီးသည်- JSP မှာ 'sheets' လို့ သုံးထားရင် ဒီမှာ 'sheets' လို့ပဲ ပေးရပါမယ်
            request.setAttribute("sheets", list); 
            request.setAttribute("keyword", keyword);

            // search.jsp ကို ပို့ပေးမယ်
            request.getRequestDispatcher("/search.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error : " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}