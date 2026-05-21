package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatsheetRepository;
import com.cheatsheet.repository.RatingRepository;

@WebServlet("/cheatsheetDetails")
public class CheatDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if(idParam == null || idParam.isEmpty()){
                response.sendRedirect("error.jsp");
                return;
            }

            int id = Integer.parseInt(idParam);

            CheatsheetRepository repo = new CheatsheetRepository();
            RatingRepository rrepo = new RatingRepository();

            // ✅ ပြင်ဆင်ချက် - getCheatsheetById ကို getCheatsheetById လို့ ပြောင်းပါ
            CheatSheet cs = repo.getCheatsheetById(id);  // s ကိုဖြုတ်ပါ

            if(cs == null){
                response.sendRedirect("error.jsp");
                return;
            }

            double avg = rrepo.getAverageRating(id);

            request.setAttribute("cheatsheet", cs);
            request.setAttribute("avg", avg);

            request.getRequestDispatcher("rating.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}