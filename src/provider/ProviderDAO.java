package provider;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;


public class ProviderDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public ProviderDAO() {
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
		String SQL = "SELECT PW FROM PROVIDER WHERE ID = ?";
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
	
	public int join(Provider provider) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		String year = Character.toString(format_time.charAt(0)) + Character.toString(format_time.charAt(1)) + Character.toString(format_time.charAt(2)) + Character.toString(format_time.charAt(3));
	    String month = Character.toString(format_time.charAt(5)) + Character.toString(format_time.charAt(6));
	    int m = Integer.parseInt(month);
	    m = (m+1)%13;
	    month = Integer.toString(m);
		int providerNum = 0;
		String SQL = "SELECT providerNUM FROM NUMTABLE";
		
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				providerNum = Integer.parseInt(rs.getString(1));
				providerNum += 1;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		SQL = "SELECT ID FROM PROVIDER";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				String ID = rs.getString(1);
				if(ID.equals(provider.getID())){
					return -1;
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		
		String provider_ID = "p"+Integer.toString(providerNum);
		SQL = "INSERT INTO PROVIDER VALUES (?, ?, ?, ? ,?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID); // user_ID
			pstmt.setString(2, provider.getName()); // name
			pstmt.setString(3, provider.getAddress()); // address
			pstmt.setString(4, provider.getAcc_no()); // acc_no
			pstmt.setInt(5, 30000); // join_fee
			pstmt.setInt(6, 0); // amount_due
			pstmt.setInt(7, 30000); // amount_left
			pstmt.setString(8, format_time);
			pstmt.setString(9, provider.getID());
			pstmt.setString(10, provider.getPW());
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "INSERT INTO PROVIDERPAYMENT VALUES (?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			pstmt.setString(2, year+"-"+month+"-01"+" 00:00:00");
			pstmt.setInt(3, 0);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "INSERT INTO PROVIDERBILL VALUES (?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			pstmt.setString(2, year+"-"+month+"-01"+" 00:00:00");
			pstmt.setInt(3, 30000);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "UPDATE NUMTABLE SET providerNum = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, providerNum);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		System.out.println("HI");
		return -1;
	}
	
	public ArrayList<Provider> getProviders() {
		ArrayList<Provider> list = new ArrayList<Provider>();
		String SQL = "SELECT * FROM PROVIDER";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Provider provider = new Provider();
				provider.setProvider_ID(rs.getString(1));
				provider.setName(rs.getString(2));
				provider.setAcc_no(rs.getString(4));
				provider.setDate_joined(rs.getString(8));
				provider.setAmount_due(rs.getInt(6));
				provider.setAmount_left(rs.getInt(7));
				list.add(provider);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int delete(String provider_ID) {
		// provider 테이블의 row만 지우면 
		// provider payment 테이블 
		// provider bill 테이블
		// storage 테이블 
		// item 테이블
		// item_detail 테이블 자동적으로 삭제됨
		String SQL = "DELETE FROM PROVIDER WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
}
