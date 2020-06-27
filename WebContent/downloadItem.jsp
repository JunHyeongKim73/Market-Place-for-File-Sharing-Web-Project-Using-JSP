<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="item.ItemDAO"%>
<%@ page import="item.ItemList"%>
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
			<a class="navbar-brand">DB 웹사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<%
					if(userID.charAt(0)=='u'){
				%>
				<li><a href="usermain.jsp">메인</a>
				<%
					}
				%>
				<%
					if(userID.charAt(0)=='p'){
				%>
				<li><a href="providermain.jsp">메인</a>
				<%
					}
				%>
				<li><a href="item.jsp">아이템 검색</a>
				<li class="active"><a href="downloadItem.jsp">다운로드한 아이템</a>
				<li><a href="userbill.jsp">청구서</a>
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
						<th style="background-color: #eeeeee; text-align: center;">키워드</th>
						<th style="background-color: #eeeeee; text-align: center;">크기</th>
						<th style="background-color: #eeeeee; text-align: center;">버전</th>
						<th style="background-color: #eeeeee; text-align: center;">다운로드 횟수</th>
					</tr>
				</thead>
				<tbody>
					<%
						ItemDAO itemDAO = new ItemDAO();
						ArrayList<ItemList> list = itemDAO.getdownloadList(userID);
						for(int i=0; i<list.size(); i++){
					%>
					<tr>
						<td><a href="itemDetail.jsp?item_ID=<%= list.get(i).getID() %>"><%= list.get(i).getName() %></a></td>
						<td><%= list.get(i).getKeyword() %></td>
						<td><%= list.get(i).getPrice() %></td>
						<td><%= list.get(i).getVersion() %></td>
						<td><%= list.get(i).getDownload_no() %></td>
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