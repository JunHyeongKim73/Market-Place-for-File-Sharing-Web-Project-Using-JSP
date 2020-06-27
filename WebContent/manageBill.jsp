<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bill.BillDAO" %>
<%@ page import="bill.Bill" %> 
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>DB 웹사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("ID") != null){
			userID = (String) session.getAttribute("ID");
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>	
			</button>
			<a class="navbar-brand" href="adminmain.jsp">DB 웹사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="adminmain.jsp">메인</a>
				<li><a href="manageUser.jsp">유저 관리</a>
				<li><a href="manageProvider.jsp">공급자 관리</a>
				<li><a href="item.jsp">아이템 관리</a>
				<li class="active"><a href="manageBill.jsp">청구서 관리</a>
				<li><a href="statistic.jsp">통계</a>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	
    <div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="4" style="background-color: #eeeeee; text-align: center;">유저 청구서</th>
					</tr>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">유저 아이디</th>
						<th style="background-color: #eeeeee; text-align: center;">청구 날짜</th>
						<th style="background-color: #eeeeee; text-align: center;">청구 금액</th>
						<th style="background-color: #eeeeee; text-align: center;">다운로드한 아이템</th>
					</tr>
				</thead>
				<tbody>
					<%
						BillDAO billDAO = new BillDAO();
						ArrayList<Bill> list = billDAO.getUserBills();
						for(int i=0; i<list.size(); i++){
							String nameList = "";
							for(int j=0; j<list.get(i).getItemNameList().size(); j++){
								if(j == list.get(i).getItemNameList().size() -1)
									nameList += list.get(i).getItemNameList().get(j);
								else
									nameList += list.get(i).getItemNameList().get(j) + " , ";
							}
					%>
					<tr>
						<td><%= list.get(i).getID() %></td>
						<td><%= list.get(i).getCharge_date() %></td>
						<td><%= list.get(i).getAmount_charge() %></td>
						<td><%= nameList %></td>
					</tr>
					<%
						}
					%>
				</tbody>
				<tbody>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
				<thead>
					<tr>
						<th colspan="4" style="background-color: #eeeeee; text-align: center;">공급자 청구서</th>
					</tr>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">공급자 아이디</th>
						<th style="background-color: #eeeeee; text-align: center;">청구 날짜</th>
						<th style="background-color: #eeeeee; text-align: center;">청구 금액</th>
						<th style="background-color: #eeeeee; text-align: center;">아이템 리스트</th>
					</tr>
				</thead>
				<tbody>
					<%
						list = billDAO.getProviderBills();
						for(int i=0; i<list.size(); i++){
							String nameList = "";
							for(int j=0; j<list.get(i).getItemNameList().size(); j++){
								if(j == list.get(i).getItemNameList().size() -1)
									nameList += list.get(i).getItemNameList().get(j);
								else
									nameList += list.get(i).getItemNameList().get(j) + " , ";
							}
					%>
					<tr>
						<td><%= list.get(i).getID() %></td>
						<td><%= list.get(i).getCharge_date() %></td>
						<td><%= list.get(i).getAmount_charge() %></td>
						<td><%= nameList %></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>