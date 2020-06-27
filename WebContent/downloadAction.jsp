<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="download.DownloadDAO" %>
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
		String ID = null;
		String item_ID = null;
		if(request.getParameter("ID") != null){
			ID = request.getParameter("ID");
		}
		if(request.getParameter("item_ID") != null){
			item_ID = request.getParameter("item_ID");
		}
		
		DownloadDAO downloadDAO = new DownloadDAO();
		
		String item_address = downloadDAO.download(ID, item_ID);
		if(item_address == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 다운받은 아이템입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(item_address == "nomp3"){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('mp3프로그램이 없습니다. mp3프로그램을 다운로드 받으세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(item_address == "nomp4"){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('mp4프로그램이 없습니다. mp4프로그램을 다운로드 받으세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>alert('주소 :" + item_address + "');</script>");
			script.println("<script>");
			script.println("alert('다운이 완료되었습니다. ')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>