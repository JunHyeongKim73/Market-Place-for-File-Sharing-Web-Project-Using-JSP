package bill;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BillDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private String provider_ID;
	private String user_ID;
	
	public BillDAO() {
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
	
	public BillDAO(String ID) {
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
	
	public Bill getProviderBill() {
		String SQL = "SELECT name FROM ITEM WHERE provider_ID = ?";
		Bill bill = new Bill();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			ArrayList<String> list = new ArrayList<String>();
			while(rs.next()) {
				list.add(rs.getString(1));
			}
			bill.setItemNameList(list);
		} catch(Exception e) {
			e.printStackTrace();
		}
		SQL = "SELECT charge_date, amount_charge FROM PROVIDERBILL WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				bill.setCharge_date(rs.getString(1));
				bill.setAmount_charge(rs.getInt(2));
				return bill;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Bill getUserBill() {
		Bill bill = new Bill();
		String SQL = "SELECT charge_date, amount_charge FROM USERBILL WHERE user_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				bill.setCharge_date(rs.getString(1));
				bill.setAmount_charge(rs.getInt(2));
				return bill;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public ArrayList<Bill> getUserBills() {
		ArrayList<Bill> list = new ArrayList<Bill>();
		String SQL = "SELECT * FROM USERBILL";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bill bill = new Bill();
				bill.setID(rs.getString(1));
				bill.setCharge_date(rs.getString(2));
				bill.setAmount_charge(rs.getInt(3));
				SQL = "with itemid(item_ID) as (select item_ID from download where user_ID = ?) select name from item, itemid where item.item_ID = itemid.item_ID";
				try {
					pstmt = conn.prepareStatement(SQL);
					pstmt.setString(1, bill.getID());
					ResultSet rs2 = pstmt.executeQuery();
					ArrayList<String> namelist = new ArrayList<String>();
					while(rs2.next()) {
						namelist.add(rs2.getString(1));
					}
					bill.setItemNameList(namelist);
				} catch(Exception e) {
					e.printStackTrace();
				}
				list.add(bill);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<Bill> getProviderBills() {
		ArrayList<Bill> list = new ArrayList<Bill>();
		String SQL = "SELECT * FROM PROVIDERBILL";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bill bill = new Bill();
				bill.setID(rs.getString(1));
				bill.setCharge_date(rs.getString(2));
				bill.setAmount_charge(rs.getInt(3));
				SQL = "SELECT name FROM ITEM WHERE provider_ID = ?";
				try {
					pstmt = conn.prepareStatement(SQL);
					pstmt.setString(1, bill.getID());
					ResultSet rs2 = pstmt.executeQuery();
					ArrayList<String> namelist = new ArrayList<String>();
					while(rs2.next()) {
						namelist.add(rs2.getString(1));
					}
					
					bill.setItemNameList(namelist);
				} catch(Exception e) {
					e.printStackTrace();
				}
				list.add(bill);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}
