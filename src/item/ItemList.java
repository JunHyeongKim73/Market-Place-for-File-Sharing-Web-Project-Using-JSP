package item;

import java.util.ArrayList;

public class ItemList {
	private String ID;
	private String name;
	private String keyword;
	private int price;
	private String version;
	private int download_no;
	private ArrayList<String> userIdList;
	
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public int getDownload_no() {
		return download_no;
	}
	public void setDownload_no(int download_no) {
		this.download_no = download_no;
	}
	public ArrayList<String> getUserIdList() {
		return userIdList;
	}
	public void setUserIdList(ArrayList<String> userIdList) {
		this.userIdList = userIdList;
	}
	
	
}
