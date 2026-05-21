package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/allCheatSheets")
public class AllCheatServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        CheatsheetRepository repo = new CheatsheetRepository();

        String type = request.getParameter("type");

        List<CheatSheet> list;

        if(type == null || type.trim().isEmpty()){
            list = repo.getAllCheatSheets();
        }else{
            list = repo.getCheatSheetsByCategory(type);
        }

        request.setAttribute("list", list);

        request.getRequestDispatcher("/admin/allCheat.jsp")
               .forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}