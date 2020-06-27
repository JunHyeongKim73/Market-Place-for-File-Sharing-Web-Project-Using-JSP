<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="ID" />
<jsp:setProperty name="user" property="PW" />
<jsp:setProperty name="user" property="name" />
<jsp:setProperty name="user" property="address" />
<jsp:setProperty name="user" property="acc_no" />
<jsp:setProperty name="user" property="phone_no" />
<jsp:setProperty name="user" property="birthday" />
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
			userID = (String) session.getAttribute("uID");
		}
		if(userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}	
	
		if(user.getID() == null || user.getPW() == null || user.getName() == null || user.getAddress() == null || user.getAcc_no() == null ||
				user.getPhone_no() == null || user.getBirthday() == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else{
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user);
			if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else{
				session.setAttribute("ID", "u"+user.getID());
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'usermain.jsp' ");
				script.println("</script>");
			}
		}
	%>
</body>
</html>