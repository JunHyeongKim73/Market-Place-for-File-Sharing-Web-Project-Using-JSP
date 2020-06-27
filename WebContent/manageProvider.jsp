<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="provider.ProviderDAO" %>
<%@ page import="provider.Provider" %> 
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
				<li class="active"><a href="manageProvider.jsp">공급자 관리</a>
				<li><a href="item.jsp">아이템 관리</a>
				<li><a href="manageBill.jsp">청구서 관리</a>
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
						<th style="background-color: #eeeeee; text-align: center;">이름</th>
						<th style="background-color: #eeeeee; text-align: center;">계좌번호</th>
						<th style="background-color: #eeeeee; text-align: center;">가입날짜</th>
						<th style="background-color: #eeeeee; text-align: center;">지불한 금액</th>
						<th style="background-color: #eeeeee; text-align: center;">지불할 금액</th>
						<th style="background-color: #eeeeee; text-align: center;">삭제</th>
					</tr>
				</thead>
				<tbody>
					<%
						ProviderDAO providerDAO = new ProviderDAO();
						ArrayList<Provider> list = providerDAO.getProviders();
						for(int i=0; i<list.size(); i++){
					%>
					<tr>
						<td><%= list.get(i).getName() %></td>
						<td><%= list.get(i).getAcc_no() %></td>
						<td><%= list.get(i).getDate_joined() %></td>
						<td><%= list.get(i).getAmount_due() %></td>
						<td><%= list.get(i).getAmount_left() %></td>
						<td><a href="providerDeleteAction.jsp?provider_ID=<%= list.get(i).getProvider_ID() %>">공급자 삭제</a>
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