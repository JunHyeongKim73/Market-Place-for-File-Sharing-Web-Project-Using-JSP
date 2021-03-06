<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %> 
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
			<a class="navbar-brand" href="usermain.jsp">DB 웹사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="usermain.jsp">메인</a>
				<li class="active"><a href="manageUser.jsp">유저 관리</a>
				<li><a href="manageProvider.jsp">공급자 관리</a>
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
						<th colspan="6" style="background-color: #eeeeee; text-align: center;">다운로드 5회 이상 유저</th>
					</tr>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">이름</th>
						<th style="background-color: #eeeeee; text-align: center;">계좌번호</th>
						<th style="background-color: #eeeeee; text-align: center;">가입날짜</th>
						<th style="background-color: #eeeeee; text-align: center;">다운로드 횟수</th>
						<th style="background-color: #eeeeee; text-align: center;">지불한 금액</th>
						<th style="background-color: #eeeeee; text-align: center;">삭제</th>
					</tr>
				</thead>
				<tbody>
					<%
						UserDAO userDAO = new UserDAO();
						ArrayList<User> list = userDAO.getUsers();
						for(int i=0; i<list.size(); i++){
							if(list.get(i).getDownload_no()>=5){
					%>
					<tr>
						<td><%= list.get(i).getName() %></td>
						<td><%= list.get(i).getAcc_no() %></td>
						<td><%= list.get(i).getDate_joined() %></td>
						<td><%= list.get(i).getDownload_no() %></td>
						<td><%= list.get(i).getAmount_due() %></td>
						<td><a href="userDeleteAction.jsp?user_ID=<%= list.get(i).getUser_ID() %>">유저 삭제</a>
					</tr>
					<%
							}
						}
					%>
				</tbody>
				<tbody>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
				<thead>
					<tr>
						<th colspan="6" style="background-color: #eeeeee; text-align: center;">다운로드 5회 미만 유저</th>
					</tr>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">이름</th>
						<th style="background-color: #eeeeee; text-align: center;">계좌번호</th>
						<th style="background-color: #eeeeee; text-align: center;">가입날짜</th>
						<th style="background-color: #eeeeee; text-align: center;">다운로드 횟수</th>
						<th style="background-color: #eeeeee; text-align: center;">지불한 금액</th>
						<th style="background-color: #eeeeee; text-align: center;">삭제</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(int i=0; i<list.size(); i++){
							if(list.get(i).getDownload_no()<5){
					%>
					<tr>
						<td><%= list.get(i).getName() %></td>
						<td><%= list.get(i).getAcc_no() %></td>
						<td><%= list.get(i).getDate_joined() %></td>
						<td><%= list.get(i).getDownload_no() %></td>
						<td><%= list.get(i).getAmount_due() %></td>
						<td><a href="userDeleteAction.jsp?user_ID=<%= list.get(i).getUser_ID() %>">유저 삭제</a>
					</tr>
					<%
							}
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