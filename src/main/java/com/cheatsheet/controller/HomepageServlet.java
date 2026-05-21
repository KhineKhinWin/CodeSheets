package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.repository.CheatsheetRepository;
import com.cheatsheet.model.Category;
import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.model.User;

@WebServlet("/homepage")
public class HomepageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
    public HomepageServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loginUser") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user =
            (User) session.getAttribute("loginUser");

        if ("admin".equals(user.getRole())) {

            response.sendRedirect("adminDashboard.jsp");

        } else {

            CheatsheetRepository repo =
                    new CheatsheetRepository();

            // categories
            List<Category> categories =
                    repo.getAllCategories();

            // cheatsheets
            List<CheatSheet> cheats =
                    repo.getAllCheatSheets();

            request.setAttribute("categories",
                    categories);

            request.setAttribute("cheats",
                    cheats);

            RequestDispatcher rd =
                    request.getRequestDispatcher("home.jsp");

            rd.forward(request, response);
        }
        }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
