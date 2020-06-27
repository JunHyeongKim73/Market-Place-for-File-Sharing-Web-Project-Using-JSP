<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="provider.ProviderDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="provider" class="provider.Provider" scope="page"/>
<jsp:setProperty name="provider" property="ID" />
<jsp:setProperty name="provider" property="PW" />
<jsp:setProperty name="provider" property="name" />
<jsp:setProperty name="provider" property="address" />
<jsp:setProperty name="provider" property="acc_no" />
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
			userID = (String) session.getAttribute("pID");
		}
		if(userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		if(provider.getID() == null || provider.getPW() == null || provider.getName() == null || provider.getAddress() == null || provider.getAcc_no() == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else{
			ProviderDAO providerDAO = new ProviderDAO();
			int result = providerDAO.join(provider);
			if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else{
				session.setAttribute("ID", "p"+provider.getID());
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'providermain.jsp' ");
				script.println("</script>");
			}
		}
	%>
</body>
</html>