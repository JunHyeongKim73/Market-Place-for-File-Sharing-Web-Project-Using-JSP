<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bill.Bill"%>
<%@ page import="bill.BillDAO"%>
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
		
		Bill bill = new BillDAO(userID).getProviderBill();
		String nameList = "";
		for(int i=0; i<bill.getItemNameList().size(); i++){
			if(i == bill.getItemNameList().size() -1)
				nameList += bill.getItemNameList().get(i);
			else
				nameList += bill.getItemNameList().get(i) + " , ";
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
			<a class="navbar-brand" href="providermain.jsp">DB 웹사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="providermain.jsp">메인</a>
				<li><a href="item.jsp">아이템 검색</a>
				<li><a href="itemAdd.jsp">아이템 추가</a>
				<li><a href="myitem.jsp">내 아이템 보기</a>
				<li class="active"><a href="providerbill.jsp">청구서</a>
				<li><a href="providerStatistics.jsp">통계</a>
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
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">청구서 세부사항</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>아이템 목록</td>
						<td colspan="2"><%= nameList %></td>
					</tr>
					<tr>
						<td>청구 날짜</td>
						<td colspan="2"><%= bill.getCharge_date() %></td>
					</tr>
					<tr>
						<td>청구 요금</td>
						<td colspan="2"><%= bill.getAmount_charge() %></td>
					</tr>
				</tbody>
			</table>
			<a href="providerSend.jsp" class="btn btn-primary">송금</a>
		</div>
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>