package com.cheatsheet.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.repository.CheatsheetRepository;
import com.cheatsheet.model.Category;
import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.config.DBConnection;

@WebServlet("/edit_cheat")
public class EditCheatServlet extends HttpServlet {

    // =========================
    // LOAD DATA (EDIT PAGE)
    // =========================
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("myCheats");
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
                c.setExampleCode(rs.getString("example_code"));  // ✅ ထပ်ထည့်
                c.setCategoryId(rs.getInt("category_id"));
                c.setStatus(rs.getString("status")); 
                c.setIsPublic(rs.getInt("is_public"));

                request.setAttribute("cheat", c);

                CheatsheetRepository repo = new CheatsheetRepository();
                List<Category> categories = repo.getAllCategories();
                request.setAttribute("categories", categories);

                request.getRequestDispatcher("edit_cheat.jsp")
                       .forward(request, response);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("myCheats");
    }

    // =========================
    // UPDATE DATA
    // =========================
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("myCheats");
            return;
        }

        int id = Integer.parseInt(idStr);
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String exampleCode = request.getParameter("example_code");  // ✅ ထပ်ထည့်
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        String status = request.getParameter("status"); 
        if (status == null) status = "PRIVATE";

        int isPublic = status.equalsIgnoreCase("PUBLIC") ? 1 : 0;

        try (Connection con = DBConnection.getConnection()) {

            // ✅ example_code ပါအောင် SQL ပြင်ပါ
            String sql = "UPDATE cheatsheets SET title=?, content=?, example_code=?, category_id=?, is_public=?, status=? " +
                         "WHERE id=? AND delete_flag=0";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, exampleCode);  // ✅ ထပ်ထည့်
            ps.setInt(4, categoryId);   
            ps.setInt(5, isPublic);
            ps.setString(6, status);
            ps.setInt(7, id);

            int rows = ps.executeUpdate();
            System.out.println("DEBUG: Update Success, Rows affected: " + rows);
            System.out.println("DEBUG: New Status sent to DB: " + status);
            response.sendRedirect("myCheats");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}