package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.repository.CheatsheetRepository;
import com.cheatsheet.model.CheatSheet;

@WebServlet("/cheat_list")
public class CheatListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("cat");
        List<CheatSheet> list;
        CheatsheetRepository dao = new CheatsheetRepository();

        try {
            // category က null ဖြစ်နေရင် ဒါမှမဟုတ် context မရှိရင် အကုန်ပြမယ်
            if (category == null || category.isEmpty()) {
                list = dao.getAllCheatSheets(); // countCheatsheets() အစား ဒါကို သုံးရပါမယ်
            } else {
                list = dao.getCheatSheetsByCategory(category);
            }

            request.setAttribute("cheatSheetList", list);
            request.getRequestDispatcher("cheat_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error!");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }


}
