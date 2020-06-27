package item;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;

public class ItemDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private String provider_ID;
	private String user_ID;
	
	public ItemDAO() {
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
	
	public ItemDAO(String ID) {
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
	
	public int cal(int num) {
		if(num % 1000 == 0) {
			return num / 1000;
		}
		else {
			return num / 1000 + 1;
		}
	}
	
	public int add(Item item, Item_detail item_detail) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		int itemNum = 0;
		String SQL = "SELECT itemNUM FROM NUMTABLE";
		
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				itemNum = Integer.parseInt(rs.getString(1));
				itemNum += 1;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		String item_ID = "i"+Integer.toString(itemNum);
		SQL = "INSERT INTO ITEM VALUES (?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID); // item_ID
			pstmt.setString(2, provider_ID); // provider_ID
			pstmt.setString(3, item.getName()); // name
			pstmt.setString(4, item.getType()); // type
			pstmt.setInt(5, item.getSize()); // size
			pstmt.setString(6, item.getLanguage()); // language
			pstmt.setInt(7, item.getPrice()); // price
			pstmt.setInt(8, 0); // download_no
			pstmt.setString(9, item.getVersion()); // version
			pstmt.setString(10, item.getDescription()); // description
			pstmt.setString(11, format_time); // last_update
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "INSERT INTO ITEM_DETAIL VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID); // item_ID
			pstmt.setString(2, item_detail.getItem_keyword()); // item_keyword
			pstmt.setString(3, item_detail.getMachine_required()); // machine_required
			pstmt.setString(4, item_detail.getOs_required()); // os_required
			pstmt.setString(5, item_detail.getViewer_need()); // viewer_need
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "INSERT INTO STORAGE VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID); // item_ID
			pstmt.setString(2, provider_ID); // provider_ID
			pstmt.setString(3, "https://"+item_ID); // address
			pstmt.setInt(4, cal(item.getSize()) * 1000); // disk_space
			pstmt.setInt(5, cal(item.getSize()) * 1000 * 20); // cost
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		// Provider update
		SQL = "SELECT amount_left FROM PROVIDER WHERE provider_ID = ?";
		int amount_left = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_left = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		amount_left += cal(item.getSize()) * 1000 * 20;
		SQL = "UPDATE PROVIDER SET amount_left = ? WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_left);
			pstmt.setString(2, provider_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		// ProviderBill update
		SQL = "SELECT amount_charge FROM PROVIDERBILL WHERE provider_ID = ?";
		int amount_charge = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_charge = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		amount_charge += cal(item.getSize()) * 1000 * 20;
		SQL = "UPDATE PROVIDERBILL SET amount_charge = ? WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_charge);
			pstmt.setString(2, provider_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "UPDATE NUMTABLE SET itemNum = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, itemNum);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int update(String item_ID, Item item, Item_detail item_detail) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		String SQL = "UPDATE ITEM SET name = ?, type = ?, language = ?, price = ?, version = ?, description = ?, last_update = ? WHERE item_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item.getName());
			pstmt.setString(2, item.getType());
			pstmt.setString(3, item.getLanguage());
			pstmt.setInt(4, item.getPrice());
			pstmt.setString(5, item.getVersion());
			pstmt.setString(6, item.getDescription());
			pstmt.setString(7, format_time);
			pstmt.setString(8, item_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		SQL = "UPDATE ITEM_DETAIL SET item_keyword = ?, machine_required = ?, os_required = ?, viewer_need = ? WHERE item_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_detail.getItem_keyword());
			pstmt.setString(2, item_detail.getMachine_required());
			pstmt.setString(3, item_detail.getOs_required());
			pstmt.setString(4, item_detail.getViewer_need());
			pstmt.setString(5, item_ID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int delete(String item_ID) {
		String provider_ID = null;
		int cost = 0;
		
		// cost
		String SQL = "SELECT provider_ID, cost FROM STORAGE WHERE ITEM_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				provider_ID = rs.getString(1);
				cost = rs.getInt(2);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		// Provider update
		SQL = "SELECT amount_left FROM PROVIDER WHERE provider_ID = ?";
		int amount_left = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_left = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		amount_left -= cost;
		SQL = "UPDATE PROVIDER SET amount_left = ? WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_left);
			pstmt.setString(2, provider_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		// ProviderBill update
		SQL = "SELECT amount_charge FROM PROVIDERBILL WHERE provider_ID = ?";
		int amount_charge = 0;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				amount_charge = rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		amount_charge -= cost;
		SQL = "UPDATE PROVIDERBILL SET amount_charge = ? WHERE provider_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, amount_charge);
			pstmt.setString(2, provider_ID);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		// 아이템 테이블의 row만 지우면 
		// item_detail 
		// dropped_table
		// storage 테이블은 저절로 지워짐
		// 하지만 download 테이블은 지워지지 않음
				
		SQL = "DELETE FROM ITEM WHERE item_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	public ArrayList<ItemList> getList(){
		String SQL = "SELECT * FROM ITEM NATURAL JOIN ITEM_DETAIL WHERE provider_ID = ?";
		ArrayList<ItemList> list = new ArrayList<ItemList>();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, provider_ID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ItemList item = new ItemList();
				item.setID(rs.getString(1));
				item.setName(rs.getString(3));
				item.setKeyword(rs.getString(12));
				item.setPrice(rs.getInt(7));
				item.setVersion(rs.getString(9));
				item.setDownload_no(rs.getInt(8));
				if(item.getDownload_no() >=0) {
					SQL = "SELECT user_ID FROM DOWNLOAD WHERE item_ID = ?";
					try {
						pstmt = conn.prepareStatement(SQL);
						pstmt.setString(1, item.getID());
						ResultSet rs2 = pstmt.executeQuery();
						ArrayList<String> namelist = new ArrayList<String>();
						while(rs2.next()) {
							namelist.add(rs2.getString(1));
						}
						item.setUserIdList(namelist);
					} catch(Exception e) {
						e.printStackTrace();
					}
				}else {
					item.setUserIdList(null);
				}
				list.add(item);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<ItemList> getAllList(){
		String SQL = "SELECT * FROM ITEM NATURAL JOIN ITEM_DETAIL";
		ArrayList<ItemList> list = new ArrayList<ItemList>();
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ItemList item = new ItemList();
				item.setID(rs.getString(1));
				item.setName(rs.getString(3));
				item.setKeyword(rs.getString(12));
				item.setPrice(rs.getInt(7));
				item.setVersion(rs.getString(9));
				item.setDownload_no(rs.getInt(8));
				list.add(item);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public Item getItem(String item_ID) {
		String SQL = "SELECT * FROM ITEM WHERE item_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Item item = new Item();
				item.setItem_ID(rs.getString(1));
				item.setProvider_ID(rs.getString(2));
				item.setName(rs.getString(3));
				item.setType(rs.getString(4));
				item.setSize(rs.getInt(5));
				item.setLanguage(rs.getString(6));
				item.setPrice(rs.getInt(7));
				item.setDownload_no(rs.getInt(8));
				item.setVersion(rs.getString(9));
				item.setDescription(rs.getString(10));
				item.setLast_update(rs.getString(11));
				return item;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Item_detail getItemDetail(String item_ID) {
		String SQL = "SELECT * FROM ITEM_DETAIL WHERE item_ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, item_ID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Item_detail item_detail = new Item_detail();
				item_detail.setItem_ID(rs.getString(1));
				item_detail.setItem_keyword(rs.getString(2));
				item_detail.setMachine_required(rs.getString(3));
				item_detail.setOs_required(rs.getString(4));
				item_detail.setViewer_need(rs.getString(5));
				return item_detail;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public ArrayList<ItemList> getdownloadList(String ID){
		
		String SQL = "SELECT user_ID FROM USER WHERE ID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, ID.substring(1));
			rs = pstmt.executeQuery();
			if(rs.next())
				user_ID = rs.getString(1);
		} catch(Exception e) {
			e.printStackTrace();
		}
		SQL = "SELECT item_ID FROM DOWNLOAD WHERE user_ID = ?";
		ArrayList<String> itemIdList = new ArrayList<String>();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_ID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				itemIdList.add(rs.getString(1));
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		ArrayList<ItemList> list = new ArrayList<ItemList>();
		for(int i=0; i<itemIdList.size(); i++) {
			SQL = "SELECT * FROM ITEM NATURAL JOIN ITEM_DETAIL WHERE item_ID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, itemIdList.get(i));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					ItemList item = new ItemList();
					item.setID(rs.getString(1));
					item.setName(rs.getString(3));
					item.setKeyword(rs.getString(12));
					item.setPrice(rs.getInt(7));
					item.setVersion(rs.getString(9));
					item.setDownload_no(rs.getInt(8));
					list.add(item);
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return list;
	}
	
	public ArrayList<ItemList> getCategoryList(String opt, String condition){
		// 조건에 맞는 item id 가져오기
		ArrayList<String> itemIdList = new ArrayList<String>();
		String SQL = null;
		if(opt.equals("0")) {
			SQL = "SELECT item_ID FROM ITEM_DETAIL WHERE item_keyword = ?";
		}
		else if(opt.equals("1")) {
			SQL = "SELECT item_ID FROM ITEM_DETAIL WHERE machine_required = ?";
		}
		else if(opt.equals("2")) {
			SQL = "SELECT item_ID FROM ITEM_DETAIL WHERE os_required = ?";
		}
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, condition);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				itemIdList.add(rs.getString(1));
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		ArrayList<ItemList> list = new ArrayList<ItemList>();
		for(int i=0; i<itemIdList.size(); i++) {
			SQL = "SELECT * FROM ITEM NATURAL JOIN ITEM_DETAIL WHERE item_ID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, itemIdList.get(i));
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ItemList item = new ItemList();
					item.setID(rs.getString(1));
					item.setName(rs.getString(3));
					item.setKeyword(rs.getString(12));
					item.setPrice(rs.getInt(7));
					item.setVersion(rs.getString(9));
					item.setDownload_no(rs.getInt(8));
					list.add(item);
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		return list;
	}
	
	public ArrayList<ItemList> getTypeList(String type){
		ArrayList<String> itemIdList = new ArrayList<String>();
		String SQL = null;
		// 가장 많이 다운로드한 아이템
		if(type.equals("0")) {
			SQL = "with maxDown(max_download) as"
					+ " (select max(download_no) as max_download from item) "
					+ "select item_ID from item, maxDown"
					+ " where item.download_no = maxDown.max_download";
		}
		// 가장 적게 다운로드한 아이템
		else if(type.equals("1")) {
			SQL = "with minDown(min_download) as"
					+ " (select min(download_no) as min_download from item) "
					+ "select item_ID from item, minDown"
					+ " where item.download_no = minDown.min_download";
		}
		
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				itemIdList.add(rs.getString(1));
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		ArrayList<ItemList> list = new ArrayList<ItemList>();
		
		for(int i=0; i<itemIdList.size(); i++) {
			SQL = "SELECT * FROM ITEM NATURAL JOIN ITEM_DETAIL WHERE item_ID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, itemIdList.get(i));
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ItemList item = new ItemList();
					item.setID(rs.getString(1));
					item.setName(rs.getString(3));
					item.setKeyword(rs.getString(12));
					item.setPrice(rs.getInt(7));
					item.setVersion(rs.getString(9));
					item.setDownload_no(rs.getInt(8));
					list.add(item);
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		return list;
	}
	
	public ArrayList<DroppedItem> getdroppedItem(){
		ArrayList<DroppedItem> list = new ArrayList<DroppedItem>();
		String SQL = "SELECT item_ID, dropped_date, dropped_reason FROM DROPPED_ITEM";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				DroppedItem item = new DroppedItem();
				item.setItem_ID(rs.getString(1));
				item.setDropped_date(rs.getString(2));
				item.setDropped_reason(rs.getString(3));
				list.add(item);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int thresholdPurse() {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		HashSet<String> itemList = new HashSet<String>(); 
		// 다운로드 수가 2가 넘지 않는 아이템의 provider_ID 찾기
		String SQL = "SELECT item_ID FROM ITEM WHERE download_no < 2";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				itemList.add(rs.getString(1));
			}
		} catch(Exception e) {
			e.printStackTrace();
			return 0;
		}
		
		for(String item_ID : itemList) {
			SQL = "DELETE FROM ITEM WHERE item_ID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, item_ID);
				pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
				return 0;
			}
		}
		for(String item_ID : itemList) {
			SQL = "INSERT INTO DROPPED_ITEM VALUES (?, ?, ?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, item_ID);
				pstmt.setString(2, format_time);
				pstmt.setString(3, "thresholdPurged");
				pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
				return 0;
			}
		}
		
		return 1;
	}
}
