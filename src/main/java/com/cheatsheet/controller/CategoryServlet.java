package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/category")
public class CategoryServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("name");

        if(category == null || category.trim().isEmpty()){
            category = "All";
        }

        CheatsheetRepository repo = new CheatsheetRepository();

        List<CheatSheet> list;

        try {
            if("All".equals(category)){
                list = repo.getAllCheatSheets();
            } else {
                list = repo.getCheatSheetsByCategory(category);
            }

            request.setAttribute("list", list);
            request.setAttribute("type", category);

            request.getRequestDispatcher("user_allCheat.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
