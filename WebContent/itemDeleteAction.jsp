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
		String userID = null;
		if(session.getAttribute("ID") != null){
			userID = (String) session.getAttribute("ID");
		}
		String item_ID = null;
		if(request.getParameter("item_ID") != null){
			item_ID = request.getParameter("item_ID");
		}
		ItemDAO itemDAO = new ItemDAO(userID);
		int result = itemDAO.delete(item_ID);
		if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('에러가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('아이템 삭제가 완료되었습니다. ')");
			script.println("location.href = 'myitem.jsp' ");
			script.println("</script>");
		}
	%>
</body>
</html>