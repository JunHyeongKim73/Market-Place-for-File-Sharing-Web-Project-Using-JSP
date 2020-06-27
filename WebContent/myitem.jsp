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
			<a class="navbar-brand" href="providermain.jsp">DB 웹사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="providermain.jsp">메인</a>
				<li><a href="item.jsp">아이템 검색</a>
				<li><a href="itemAdd.jsp">아이템 추가</a>
				<li class="active"><a href="myitem.jsp">내 아이템 보기</a>
				<li><a href="providerbill.jsp">청구서</a>
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
						<th style="background-color: #eeeeee; text-align: center;">이름</th>
						<th style="background-color: #eeeeee; text-align: center;">키워드</th>
						<th style="background-color: #eeeeee; text-align: center;">가격</th>
						<th style="background-color: #eeeeee; text-align: center;">버전</th>
						<th style="background-color: #eeeeee; text-align: center;">다운로드 횟수</th>
						<th style="background-color: #eeeeee; text-align: center;">유저 아이디</th>
					</tr>
				</thead>
				<tbody>
					<%
						ItemDAO itemDAO = new ItemDAO(userID);
						ArrayList<ItemList> list = itemDAO.getList();
						for(int i=0; i<list.size(); i++){
							String userIdList = "";
							for(int j=0; j<list.get(i).getUserIdList().size(); j++){
								if(j == list.get(i).getUserIdList().size() - 1){
									userIdList += list.get(i).getUserIdList().get(j);
								}else{
									userIdList += list.get(i).getUserIdList().get(j) + " , ";
								}
							}
					%>
					<tr>
						<td><a href="itemDetail.jsp?item_ID=<%= list.get(i).getID() %>&myitem=1"><%= list.get(i).getName() %></a></td>
						<td><%= list.get(i).getKeyword() %></td>
						<td><%= list.get(i).getPrice() %></td>
						<td><%= list.get(i).getVersion() %></td>
						<td><%= list.get(i).getDownload_no() %></td>
						<td><%= userIdList %></td>
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