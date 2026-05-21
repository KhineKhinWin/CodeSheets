package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/userAllCheat")
public class UserAllCheatServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            CheatsheetRepository repo = new CheatsheetRepository();

            String type = request.getParameter("name");

            // ✅ FIX 1: null + empty + "All" safe check
            if (type == null || type.trim().isEmpty() || type.equalsIgnoreCase("All")) {
                type = "All";
            }

            List<CheatSheet> list;

            if (type.equals("All")) {
                list = repo.getAllCheatSheets();
            } else {

                // ✅ FIX 2: trim လုပ် (space bug မဖြစ်အောင်)
                type = type.trim();

                list = repo.getCheatSheetsByCategory(type);
            }

            // JSP data
            request.setAttribute("list", list);
            request.setAttribute("type", type);

            request.getRequestDispatcher("user_allCheat.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}