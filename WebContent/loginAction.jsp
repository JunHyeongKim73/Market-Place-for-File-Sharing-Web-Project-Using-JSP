<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="provider.ProviderDAO" %>
<%@ page import="admin.AdminDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:useBean id="provider" class="provider.Provider" scope="page"/>
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
		if(userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		
		String type = request.getParameter("userType");
		String ID = request.getParameter("ID");
		String PW = request.getParameter("PW");
		String tp = "";
		
		int result = -1;
		if(type.equals("user")){
			tp = "u";
			UserDAO userDAO = new UserDAO();
			result = userDAO.login(ID, PW);
		}
		else if(type.equals("provider")){
			tp = "p";
			ProviderDAO providerDAO = new ProviderDAO();
			result = providerDAO.login(ID, PW);
		}
		else if(type.equals("admin")){
			tp = "a";
			AdminDAO adminDAO = new AdminDAO();
			result = adminDAO.login(ID, PW);
		}
		if(result == 1){
			session.setAttribute("ID", tp+ID);
			PrintWriter script = response.getWriter();
			script.println("<script>");
			if(type.equals("user")){
				script.println("location.href = 'usermain.jsp' ");
			}
			else if(type.equals("provider")){
				script.println("location.href = 'providermain.jsp' ");
			}
			else{
				script.println("location.href = 'adminmain.jsp' ");
			}
			script.println("</script>");
		}
		else if(result == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result == -2){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>