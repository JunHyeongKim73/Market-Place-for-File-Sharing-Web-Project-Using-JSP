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
		String user_ID = null;
		if(request.getParameter("user_ID") != null){
			user_ID = request.getParameter("user_ID");
		}
		
		UserDAO userDAO = new UserDAO();
		int result = userDAO.delete(user_ID);
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유저가 삭제되었습니다. ')");
			script.println("location.href = 'manageUser.jsp'");
			script.println("</script>");
		}
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유저가 존재하지 않습니다. ')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>