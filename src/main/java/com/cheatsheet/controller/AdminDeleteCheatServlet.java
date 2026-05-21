package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/deleteSheet")
public class AdminDeleteCheatServlet extends HttpServlet {

    CheatsheetRepository repo = new CheatsheetRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            repo.deleteCheatSheet(id);

            // 👉 manageSheets ကို redirect ပြန်ပို့
            response.sendRedirect(request.getContextPath() + "/manageSheets?success=delete");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

}
