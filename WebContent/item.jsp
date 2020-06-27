<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="item.ItemDAO"%>
<%@ page import="item.ItemList"%>
<%@ page import="java.util.ArrayList"%>
<% request.setCharacterEncoding("UTF-8"); %>

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
			<a class="navbar-brand" href="main.jsp">DB 웹사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<%
					if(userID.charAt(0)=='u'){
				%>
				<li><a href="usermain.jsp">메인</a>
				<li class="active"><a href="item.jsp">아이템 검색</a>
				<li><a href="downloadItem.jsp">다운로드한 아이템</a>
				<li><a href="userbill.jsp">청구서</a>
				<%
					}
				%>
				<%
					if(userID.charAt(0)=='p'){
				%>
				<li><a href="providermain.jsp">메인</a>
				<li class="active"><a href="item.jsp">아이템 검색</a>
				<li><a href="itemAdd.jsp">아이템 추가</a>
				<li><a href="myitem.jsp">내 아이템 보기</a>
				<li><a href="providerbill.jsp">청구서</a>
				<li><a href="providerStatistics.jsp">통계</a>
				<%
					}
				%>
				<%
					if(userID.charAt(0)=='a'){
				%>
				<li><a href="adminmain.jsp">메인</a>
				<li><a href="manageUser.jsp">유저 관리</a>
				<li><a href="manageProvider.jsp">공급자 관리</a>
				<li class="active"><a href="item.jsp">아이템 관리</a>
				<li><a href="manageBill.jsp">청구서 관리</a>
				<li><a href="statistic.jsp">통계</a>
				<%
					}
				%>
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
			<ul class="nav navbar-nav navbar-left">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">아이템 고급 검색<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="item.jsp?type=0">가장 많이 다운로드 된 아이템</a></li>
						<li><a href="item.jsp?type=1">가장 적게 다운로드 된 아이템</a></li>
						<li><a href="droppeditem.jsp">드롭된 아이템</a></li>
					</ul>
				</li>
			</ul>
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">이름</th>
						<th style="background-color: #eeeeee; text-align: center;">키워드</th>
						<th style="background-color: #eeeeee; text-align: center;">가격</th>
						<th style="background-color: #eeeeee; text-align: center;">버전</th>
						<th style="background-color: #eeeeee; text-align: center;">다운로드 횟수</th>
					</tr>
				</thead>
				<tbody>
					<%
						String opt = null;
						String condition = null;
						String type = null;
						if(request.getParameter("opt") != null){
							opt = request.getParameter("opt");
						}
						if(request.getParameter("condition") != null){
							condition = request.getParameter("condition");
						}
						if(request.getParameter("type") != null){
							type = request.getParameter("type");
						}
						ItemDAO itemDAO = new ItemDAO(userID);
						ArrayList<ItemList> list = new ArrayList<ItemList>();
						if(opt != null && condition != null){
							list = itemDAO.getCategoryList(opt, condition);
						}
						else if(type != null){
							list = itemDAO.getTypeList(type);
						}
						else{
							list = itemDAO.getAllList();
						}
						for(int i=0; i<list.size(); i++){
					%>
					<tr>
						<%
							if(userID.charAt(0) == 'a'){
						%>
						<td><a href="itemDetail.jsp?item_ID=<%= list.get(i).getID() %>&myitem=0"><%= list.get(i).getName() %></a></td>
						<%
							}else{
						%>
						<td><a href="itemDetail.jsp?item_ID=<%= list.get(i).getID() %>"><%= list.get(i).getName() %></a></td>
						<%
							}
						%>
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
			<%
				if(userID.charAt(0) == 'a'){
			%>
			<a href="thresholdAction.jsp" class="btn btn-primary">Threshold Purse</a>
			<% 
				}
			%>
			<div id="seachForm" style="text-align: center;">
				<form>
					<select name="opt">
						<option value="0">키워드</option>
						<option value="1">하드웨어</option>
						<option value="2">운영체제</option>
					</select>
					<input type="text" size="20" name="condition"/>&nbsp;
					<input type="submit" value="검색"/>
				</form>
			</div>
		</div>
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>