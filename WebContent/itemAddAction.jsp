<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="item.ItemDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="item" class="item.Item" scope="page"/>
<jsp:useBean id="item_detail" class="item.Item_detail" scope="page"/>
<jsp:setProperty name="item" property="name" />
<jsp:setProperty name="item" property="type" />
<jsp:setProperty name="item_detail" property="item_keyword" />
<jsp:setProperty name="item" property="size" />
<jsp:setProperty name="item" property="language" />
<jsp:setProperty name="item_detail" property="machine_required" />
<jsp:setProperty name="item_detail" property="os_required" />
<jsp:setProperty name="item_detail" property="viewer_need" />
<jsp:setProperty name="item" property="price" />
<jsp:setProperty name="item" property="version" />
<jsp:setProperty name="item" property="description" />
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
		
		if(item.getName() == null || item.getType() == null || item.getSize() == 0 || item.getPrice() == 0 ||
				item.getVersion() == null || item.getDescription() == null || item_detail.getItem_keyword() == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else{
			ItemDAO itemDAO = new ItemDAO(userID);
			int result = itemDAO.add(item, item_detail);
			if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이템입니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('아이템 추가가 완료되었습니다. ')");
				script.println("location.href = 'providermain.jsp' ");
				script.println("</script>");
			}
		}
	%>
</body>
</html>