package download;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class DownloadDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private String provider_ID;
	
	public DownloadDAO() {
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
	
	public String download(String ID, String item_ID) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		String user_ID = null;
		int viewer = -1;
		int audio = -1;
		String type = null;
		String name = null;
		
		String SQL = "SELECT user_ID, viewer, audio FROM USER WHERE ID = ?";
		String item_address = null;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, ID.substring(1)); // user_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user_ID = rs.getString(1);
				viewer = rs.getInt(2);
				audio = rs.getInt(3);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}

		// item price
		SQL = "SELECT provider_ID, name, type, price, download_no FROM ITEM WHERE item_ID = ?";
		int price = 0;
		provider_ID = null;
		int itemDownload = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID); // item_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				provider_ID = rs.getString(1);
				name = rs.getString(2);
				type = rs.getString(3);
				price = rs.getInt(4);
				itemDownload = rs.getInt(5);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		if(type.equals(".mp3") && audio == 0) {
			return "nomp3";
		}
		else if(type.equals(".mp4") && viewer == 0) {
			return "nomp4";
		}
		
		SQL = "INSERT INTO DOWNLOAD VALUES (?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID); // user_ID
			pstmt.setString(2, item_ID); // item_ID
			pstmt.setString(3, format_time);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		}
		
		if(name.equals("비디오 프로그램") && viewer == 0) {
			SQL = "UPDATE USER SET viewer = ? where user_ID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, 1); // viewer
				pstmt.setString(2, user_ID); // user_ID
				pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
				return null;
			}
		}
		else if(name.equals("음악 프로그램") && audio == 0) {
			SQL = "UPDATE USER SET audio = ? where user_ID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, 1); // audio
				pstmt.setString(2, user_ID); // user_ID
				pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
				return null;
			}
		}
		SQL = "SELECT item_address FROM STORAGE WHERE item_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				item_address = rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		// amount_charge
		SQL = "SELECT amount_charge FROM USERBILL WHERE user_ID = ?";
		int amount_charge = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID); // user_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_charge = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		amount_charge += price;
		// userBill 업데이트
		SQL = "UPDATE USERBILL SET amount_charge = ? WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_charge);
			pstmt.setString(2, user_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		// amount_send
		SQL = "SELECT amount_send FROM PROVIDERPAYMENT WHERE provider_ID = ?";
		int amount_send = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID); // provider_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_send = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}		
		amount_send += price * 0.8;
		// ProviderPayment 업데이트
		SQL = "UPDATE PROVIDERPAYMENT SET amount_send = ? WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_send);
			pstmt.setString(2, provider_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		// select loss
		int loss = 0;
		SQL = "SELECT loss FROM INCOME";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				loss = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		loss += amount_send;
		
		// loss 업데이트
		SQL = "UPDATE INCOME SET loss = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, loss);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		// 유저 다운로드 횟수 증가
		SQL = "SELECT download_no FROM USER WHERE user_ID = ?";
		int userDownload = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID); // user_ID
			rs = pstmt.executeQuery();
			if(rs.next()) {
				userDownload = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}		
		userDownload += 1;
		
		SQL = "UPDATE USER SET download_no = ? WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, userDownload);
			pstmt.setString(2, user_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		// 아이템 다운로드 횟수 증가
		itemDownload += 1;
		SQL = "UPDATE ITEM SET download_no = ? WHERE item_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, itemDownload);
			pstmt.setString(2, item_ID);
			pstmt.executeUpdate();
			return item_address;
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
}
