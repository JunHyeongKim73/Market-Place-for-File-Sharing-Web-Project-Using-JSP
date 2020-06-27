<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
			if(userID.charAt(0) == 'u'){
	%>
			<script>
				location.href = 'usermain.jsp';	
			</script>
	<%
			}
			else if(userID.charAt(0) == 'p'){
	%>
			<script>
				location.href = 'providermain.jsp';	
			</script>
	<%
			}
			else if(userID.charAt(0) == 'a'){
	%>
			<script>
				location.href = 'adminmain.jsp';	
			</script>
	<% 	
			} 
			else{
	%>
			<script>
				location.href = 'main.jsp';
			</script>
	<% 	
			}
		}
		else{
	%>
		<script>
				location.href = 'main.jsp';	
		</script>
	<% 		
		}
	%>
</body>
</html>