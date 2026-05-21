package com.cheatsheet.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.cheatsheet.repository.CheatsheetRepository;
import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.Category;
import com.cheatsheet.model.User;

@WebServlet("/create_cheat")
public class CreateCheatServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM categories";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){

                Category c = new Category();

                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));

                categories.add(c);
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        request.setAttribute("categories", categories);

        request.getRequestDispatcher("create_cheat.jsp")
               .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String title = request.getParameter("title");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String content = request.getParameter("content");
            String exampleCode = request.getParameter("example_code");
            String status = request.getParameter("status");

            // အကယ်၍ status က null ဖြစ်နေရင် default "PUBLIC" ပေးမယ်
            if (status == null || status.isEmpty()) {
                status = "PUBLIC";
            }

            /* LOGIN USER */
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("loginUser");

            if (loginUser == null) {
                response.sendRedirect("login.jsp"); // login မဝင်ထားရင် login page ပြန်လွှတ်မယ်
                return;
            }

            int userId = loginUser.getId();

            CheatsheetRepository repo = new CheatsheetRepository();

            // ✅ ပြင်ရမယ့်နေရာ: Parameter ၅ ခုပဲ ပို့ပါ (isPublic ကို ဖယ်လိုက်ပါ)
            // Repository ထဲမှာ status ကို ကြည့်ပြီး 0/1 အလိုအလျောက် ပြောင်းသွားပါလိမ့်မယ်။
            repo.createCheatSheet(
                title,
                categoryId,
                content,
                exampleCode,
                userId,
                status
            );

            response.sendRedirect(request.getContextPath() + "/myCheats");

        } catch (Exception e) {
            e.printStackTrace();
            // လိုအပ်ရင် error page တစ်ခုခုကို forward လုပ်လို့ရပါတယ်
        }
}
}