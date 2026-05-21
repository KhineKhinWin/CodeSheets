package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.cheatsheet.config.DBConnection;

public class AdminRepository {

    Connection con;

    public int getCount(String table) throws Exception {

        con = DBConnection.getConnection();

        String sql;

        if(table.equals("cheatsheets")){
            sql = "SELECT COUNT(*) FROM cheatsheets WHERE delete_flag = 0";
        } else {
            sql = "SELECT COUNT(*) FROM " + table;
        }

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        if(rs.next()){
            return rs.getInt(1);
        }

        return 0;
    }
}