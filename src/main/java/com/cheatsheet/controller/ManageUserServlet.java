package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.User;
import com.cheatsheet.repository.UserRepository;

@WebServlet("/manageUsers")
public class ManageUserServlet extends HttpServlet {

    UserRepository repo = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // Repository object
            UserRepository repo = new UserRepository();

            // DB ကနေ users list ယူမယ်
            List<User> users = repo.getAllUsers();

            // JSP ကို data ပို့မယ်
            request.setAttribute("users", users);

            // JSP forward
            request.getRequestDispatcher(
                    "admin/manage_users.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            // error page or fallback
            response.sendRedirect("error.jsp");
        }
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
