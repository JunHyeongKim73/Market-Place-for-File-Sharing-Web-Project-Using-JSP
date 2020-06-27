package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

public class UserDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
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
	
	public int login(String userID, String userPassword) {
		String SQL = "SELECT PW FROM USER WHERE ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword))
					return 1; // 로그인 성공
				else
					return 0; // 비밀번호 불일치
			}
			return -1; // 아이디 없음
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}
	
	public int join(User user) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		String year = Character.toString(format_time.charAt(0)) + Character.toString(format_time.charAt(1)) + Character.toString(format_time.charAt(2)) + Character.toString(format_time.charAt(3));
	    String month = Character.toString(format_time.charAt(5)) + Character.toString(format_time.charAt(6));
	    int m = Integer.parseInt(month);
	    m = (m+1)%13;
	    month = Integer.toString(m);
		int userNum = 0;
		String SQL = "SELECT userNUM FROM NUMTABLE";
		
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				userNum = Integer.parseInt(rs.getString(1));
				userNum += 1;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		SQL = "SELECT ID FROM USER";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				String ID = rs.getString(1);
				if(ID.equals(user.getID())){
					return -1;
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		String user_ID = "u"+Integer.toString(userNum);
		SQL = "INSERT INTO USER VALUES (?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID); // user_ID
			pstmt.setString(2, user.getName()); // name
			pstmt.setString(3, user.getAddress()); // address
			pstmt.setString(4, user.getAcc_no()); // acc_no
			pstmt.setString(5, user.getPhone_no()); // phone_no
			pstmt.setString(6, user.getBirthday()); // birthday
			pstmt.setString(7, format_time); // date_joined
			pstmt.setString(8, user.getID()); // ID
			pstmt.setString(9, user.getPW()); // PW
			pstmt.setInt(10, 0); // viewer
			pstmt.setInt(11, 0); // audio
			pstmt.setInt(12, 0);  // download_no
			pstmt.setInt(13, 0); // amount_due
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "INSERT INTO SUBSCRIBE VALUES (?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			pstmt.setInt(2, 5000);
			pstmt.setString(3,  format_time);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "INSERT INTO USERBILL VALUES (?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			pstmt.setString(2, year+"-"+month+"-01"+" 00:00:00");
			pstmt.setInt(3,  5000);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "UPDATE NUMTABLE SET userNum = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, userNum);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int isUserSubcribe(String ID) {
		String user_ID = null;
		String SQL = "SELECT user_ID FROM USER WHERE ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, ID.substring(1));
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user_ID = rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		SQL = "SELECT * FROM SUBSCRIBE WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return 1;
			}
			else {
				return 0;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public int userCancle(String ID) {
		String user_ID = null;
		String SQL = "SELECT user_ID FROM USER WHERE ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, ID.substring(1));
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user_ID = rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		int amount_charge = 1000;
		SQL = "SELECT amount_charge FROM USERBILL WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_charge = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		if(amount_charge != 0) {
			return 0;
		}
		
		SQL = "DELETE FROM SUBSCRIBE WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -2;
	}
	
	public int userSubscribe(String ID) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		
		String user_ID = null;
		String SQL = "SELECT user_ID FROM USER WHERE ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, ID.substring(1));
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user_ID = rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		SQL = "INSERT INTO SUBSCRIBE VALUES (?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			pstmt.setInt(2, 5000);
			pstmt.setString(3,  format_time);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public ArrayList<User> getUsers() {
		ArrayList<User> list = new ArrayList<User>();
		String SQL = "SELECT * FROM USER";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				User user = new User();
				user.setUser_ID(rs.getString(1));
				user.setName(rs.getString(2));
				user.setAcc_no(rs.getString(4));
				user.setDate_joined(rs.getString(7));
				user.setDownload_no(rs.getInt(12));
				user.setAmount_due(rs.getInt(13));
				list.add(user);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int delete(String user_ID) {
		// user 테이블의 row만 지우면 
		// subscribe 테이블 
		// user bill 테이블
		// 하지만 download 테이블은 지워지지 않음
		String SQL = "DELETE FROM USER WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
}
