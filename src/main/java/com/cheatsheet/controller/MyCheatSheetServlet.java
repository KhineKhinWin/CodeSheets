package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.model.User;

import com.cheatsheet.repository.CheatsheetRepository;

@WebServlet("/myCheats")
public class MyCheatSheetServlet extends HttpServlet {

    CheatsheetRepository repo = new CheatsheetRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ၁။ Session ထဲကနေ Login ဝင်ထားတဲ့ User Object ကို ယူပါ
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            // Login မဝင်ထားရင် Login Page ကို ပြန်လွှတ်ပါ
            response.sendRedirect("login.jsp");
            return;
        }

        // ၂။ LoginUser ရဲ့ ID ကို သုံးပြီး Repository ကနေ data လှမ်းယူပါ
        CheatsheetRepository dao = new CheatsheetRepository();
        try {
            // userId ကို parameter အနေနဲ့ ထည့်ပေးရပါမယ်
            List<CheatSheet> userCheats = dao.getCheatsByUserId(loginUser.getId());
            
            request.setAttribute("list", userCheats);
            request.getRequestDispatcher("myCheats.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    
 }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
