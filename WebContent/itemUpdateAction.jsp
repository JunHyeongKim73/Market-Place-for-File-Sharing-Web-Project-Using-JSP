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
		String item_ID = null;
		if(request.getParameter("item_ID") != null){
			item_ID = request.getParameter("item_ID");
		}
		if(item.getName() == null || item.getType() == null || item.getPrice() == 0 ||
				item.getVersion() == null || item.getDescription() == null || item_detail.getItem_keyword() == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else{
			ItemDAO itemDAO = new ItemDAO(userID);
			int result = itemDAO.update(item_ID, item, item_detail);
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
				script.println("alert('아이템 업데이트가 완료되었습니다. ')");
				script.println("location.href = 'myitem.jsp' ");
				script.println("</script>");
			}
		}
	%>
</body>
</html>