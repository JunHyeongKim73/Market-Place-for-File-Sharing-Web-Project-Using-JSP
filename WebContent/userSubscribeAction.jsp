<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
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
		String userID = null;
		if(session.getAttribute("ID") != null){
			userID = (String) session.getAttribute("ID");
		}
		
		UserDAO userDAO = new UserDAO();
		int result = userDAO.userSubscribe(userID);
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('구독이 완료되었습니다.')");
			script.println("location.href = 'usermain.jsp'");
			script.println("</script>");
		}
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 구독을 하였습니다. ')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>