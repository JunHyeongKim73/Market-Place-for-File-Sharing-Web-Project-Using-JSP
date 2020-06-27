<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="item.ItemDAO"%>
<%@ page import="item.Item" %>
<%@ page import="item.Item_detail" %>

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
		String item_ID = null;
		String myitem = "";
		if(request.getParameter("item_ID") != null){
			item_ID = request.getParameter("item_ID");
		}
		if(request.getParameter("myitem") != null){
			myitem = request.getParameter("myitem");
		}
		if(item_ID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 아이템입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		Item item = new ItemDAO().getItem(item_ID);
		Item_detail item_detail = new ItemDAO().getItemDetail(item_ID);
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
				<li><a href="manageUser.jsp">회원 관리</a>
				<li><a href="manageProvider.jsp">공급자 관리</a>
				<li class="active"><a href="item.jsp">아이템 관리</a>
				<li><a href="manageBill.jsp">청구서 관리</a>
				<li><a href="statistics.jsp">통계</a>
				<%
					}
				%>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	
	<div class="container">
		<div class="row">
			<form method="post" action="itemUpdateAction.jsp">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">아이템 상세보기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width: 20%;">아이템 이름</td>
							<td colspan="2"><%= item.getName() %></td>
						</tr>
						<tr>
							<td>아이템 키워드</td>
							<td colspan="2"><%= item_detail.getItem_keyword() %></td>
						</tr>
						<tr>
							<td>종류</td>
							<td colspan="2"><%= item.getType() %></td>
						</tr>
						<tr>
							<td>프로그래밍 언어</td>
							<td colspan="2"><%= item.getLanguage() %></td>
						</tr>
						<tr>
							<td>크기</td>
							<td colspan="2"><%= item.getSize() %></td>
						</tr>
						<tr>
							<td>가격</td>
							<td colspan="2"><%= item.getPrice() %></td>
						</tr>
						<tr>
							<td>버젼</td>
							<td colspan="2"><%= item.getVersion() %></td>
						</tr>
						<tr>
							<td>필요한  machine</td>
							<td colspan="2"><%= item_detail.getMachine_required() %></td>
						</tr>
						<tr>
							<td>필요한 OS</td>
							<td colspan="2"><%= item_detail.getOs_required() %></td>
						</tr>
						<tr>
							<td>필요한 프로그램</td>
							<td colspan="2"><%= item_detail.getViewer_need() %></td>
						</tr>
						<tr>
							<td>마지막 수정 날짜</td>
							<td colspan="2"><%= item.getLast_update() %></td>
						</tr>
						<tr>
							<td>설명</td>
							<td colspan="2" style="min-height: 100px; text-align: left"><%= item.getDescription() %></td>
						</tr>
					</tbody>
				</table>
			</form>
				<a href="item.jsp" class="btn btn-primary">목록</a>
			<%
				if(myitem.equals("1")){
			%>
				<a href="itemUpdate.jsp?item_ID=<%= item_ID %>" class="btn btn-primary">수정</a>
				<a href="itemDeleteAction.jsp?item_ID=<%= item_ID %>" class="btn btn-primary">삭제</a>
			<%
				} else if(myitem.equals("0")){
			%>
				<a href="itemDeleteAction.jsp?item_ID=<%= item_ID %>" class="btn btn-primary">삭제</a>
			<%
				}
				if(userID != null && userID.charAt(0) == 'u'){
			%>
				<a href="downloadAction.jsp?ID=<%= userID %>&item_ID=<%= item.getItem_ID() %>"class="btn btn-primary">다운로드</a>
			<%		
				}
			%>
		</div>
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>