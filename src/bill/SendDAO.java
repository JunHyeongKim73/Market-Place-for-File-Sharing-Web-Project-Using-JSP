package bill;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class SendDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private String provider_ID;
	private String user_ID;
	
	public SendDAO() {
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
	
	public SendDAO(String ID) {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/db";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch(Exception e) {
			e.printStackTrace();
		}
		String SQL = null;
		if(ID.charAt(0) == 'u')
			SQL = "SELECT user_ID FROM USER WHERE ID = ?";
		else if(ID.charAt(0) == 'p')
			SQL = "SELECT provider_ID FROM PROVIDER WHERE ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, ID.substring(1));
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(ID.charAt(0) == 'u')
					user_ID = rs.getString(1);
				else if(ID.charAt(0) == 'p')
					provider_ID = rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public int providerSend(int money) {
		int amount_due=0, amount_left=0;
		// amount_due and amount_left
		String SQL = "SELECT amount_due, amount_left FROM PROVIDER WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID); // provider_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_due = rs.getInt(1);
				amount_left = rs.getInt(2);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		amount_due += money;
		amount_left -= money;
		// update provider
		SQL = "UPDATE PROVIDER SET amount_due = ?, amount_left = ? WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_due);
			pstmt.setInt(2, amount_left);
			pstmt.setString(3, provider_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		int amount_charge = 0;
		// amount_charge
		SQL = "SELECT amount_charge FROM PROVIDERBILL WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID); // provider_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_charge = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		amount_charge -= money;
		// update provider
		SQL = "UPDATE PROVIDERBILL SET amount_charge = ? WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_charge);
			pstmt.setString(2, provider_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		// select profit
		SQL = "SELECT profit FROM INCOME";
		int profit = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				profit = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		profit += money;
		// update profit
		SQL = "UPDATE INCOME SET profit = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, profit);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return -1;
	}
	
	public int userSend(int money) {
		int amount_due = 0;
		// amount_due and amount_left
		String SQL = "SELECT amount_due FROM USER WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID); // user_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_due = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		amount_due += money;
		// update user
		SQL = "UPDATE USER SET amount_due = ? WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_due);
			pstmt.setString(2, user_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		int amount_charge = 0;
		// amount_charge
		SQL = "SELECT amount_charge FROM USERBILL WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID); // provider_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_charge = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		amount_charge -= money;
		// update userbill
		SQL = "UPDATE USERBILL SET amount_charge = ? WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_charge);
			pstmt.setString(2, user_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		// select profit
		SQL = "SELECT profit FROM INCOME";
		int profit = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				profit = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		profit += money;
		// update profit
		SQL = "UPDATE INCOME SET profit = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, profit);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}
