package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatsheetRepository; // သင့် file အမည်အတိုင်း သေချာပါစေ

@WebServlet("/manageSheets")
public class ManageCheatServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    // Repository object ကို တည်ဆောက်မယ်
    CheatsheetRepository repo = new CheatsheetRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // DB ကနေ CheatSheets စာရင်းအားလုံးကို ယူမယ်
        	List<CheatSheet> sheets = repo.getAllCheatSheets();
        	System.out.println("Total sheets found: " + (sheets != null ? sheets.size() : 0)); // ဒါလေးထည့်ကြည့်ပါ
        	request.setAttribute("sheets", sheets);

            // JSP ကို ပို့မယ်။ admin folder ထဲမှာ ရှိတယ်လို့ ယူဆပြီး ရေးထားပါတယ်
            request.getRequestDispatcher("admin/manage_cheat.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}