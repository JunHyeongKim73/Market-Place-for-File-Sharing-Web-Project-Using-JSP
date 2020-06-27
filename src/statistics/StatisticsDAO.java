package statistics;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class StatisticsDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private String provider_ID;
	
	public StatisticsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/db";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch(Exception e) {
			e.printStackTrace();
		}	
	}
	
	public StatisticsDAO(String ID) {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/db";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch(Exception e) {
			e.printStackTrace();
		}	
		String SQL = "SELECT provider_ID FROM PROVIDER WHERE ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, ID.substring(1));
			rs = pstmt.executeQuery();
			if(rs.next())
				provider_ID = rs.getString(1);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public Statistics getProviderStatistics() {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		String month = Character.toString(format_time.charAt(5)) + Character.toString(format_time.charAt(6));
	    int m = Integer.parseInt(month);
	    
		Statistics stat = new Statistics();
		
		// 몇 개월 회원이었는지
		String date = null;
		int monthNum = 0;
		String SQL = "SELECT date_joined FROM PROVIDER WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				date = rs.getString(1);
			}
			month = Character.toString(date.charAt(5)) + Character.toString(date.charAt(6));
			monthNum = m - Integer.parseInt(month) + 1;
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		// Profit은  price * download_no * 0.8 
		int Sum = 0;
		SQL = "SELECT price, download_no FROM ITEM WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				int price = rs.getInt(1);
				int download_no = rs.getInt(2);
				Sum += price * download_no;
			}
			month = Character.toString(date.charAt(5)) + Character.toString(date.charAt(6));
			monthNum = m - Integer.parseInt(month) + 1;
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		stat.setProfit(Sum);
		
		// Loss는 date_joined x cost + join_fee
		SQL = "SELECT cost FROM STORAGE WHERE provider_ID = ?";
		int cost = 0;
		int join_fee = 30000;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				cost += rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		stat.setLoss(cost * monthNum + join_fee);
		return stat;
	}
	
	public Statistics getStatistics() {
		Statistics stat = new Statistics();
		
		String SQL = "SELECT profit, loss FROM INCOME";
		int loss = 0;
		int profit = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				profit += rs.getInt(1);
				loss += rs.getInt(2);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		stat.setLoss(loss);
		stat.setProfit(profit);
		return stat;
	}
}
