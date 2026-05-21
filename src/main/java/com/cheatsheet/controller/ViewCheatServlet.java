package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.CheatSheet;

@WebServlet("/view_cheat")
public class ViewCheatServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("community");
            return;
        }

        int id = Integer.parseInt(idStr);

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM cheatsheets WHERE id=? AND delete_flag=0";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                CheatSheet c = new CheatSheet();

                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setContent(rs.getString("content"));
                c.setIsPublic(rs.getInt("is_public"));

                request.setAttribute("cheat", c);

                request.getRequestDispatcher("view_cheat.jsp")
                       .forward(request, response);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("community");
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
