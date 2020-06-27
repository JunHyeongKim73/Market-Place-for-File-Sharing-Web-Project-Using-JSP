package bill;

import java.util.ArrayList;

public class Bill {
	private ArrayList<String> itemNameList;
	private String ID;
	private String charge_date;
	private int amount_charge;
	public ArrayList<String> getItemNameList() {
		return itemNameList;
	}
	public void setItemNameList(ArrayList<String> itemNameList) {
		this.itemNameList = itemNameList;
	}
	public String getCharge_date() {
		return charge_date;
	}
	public void setCharge_date(String charge_date) {
		this.charge_date = charge_date;
	}
	public int getAmount_charge() {
		return amount_charge;
	}
	public void setAmount_charge(int amount_charge) {
		this.amount_charge = amount_charge;
	}
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	
	
}
