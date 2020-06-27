<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="item.ItemDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB 웹사이트</title>
</head>
<body>
	<%
		ItemDAO itemDAO = new ItemDAO();
	
		int result = itemDAO.thresholdPurse();
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('처리를 완료하였습니다. ')");
			script.println("location.href = 'item.jsp'");
			script.println("</script>");
		}
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('오류가 발생하였습니다. ')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>