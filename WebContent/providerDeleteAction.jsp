<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="provider.ProviderDAO" %>
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
		String provider_ID = null;
		if(request.getParameter("provider_ID") != null){
			provider_ID = request.getParameter("provider_ID");
		}
		
		ProviderDAO providerDAO = new ProviderDAO();
		int result = providerDAO.delete(provider_ID);
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('공급자가 삭제되었습니다. ')");
			script.println("location.href = 'manageProvider.jsp'");
			script.println("</script>");
		}
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('공급자가 존재하지 않습니다. ')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>