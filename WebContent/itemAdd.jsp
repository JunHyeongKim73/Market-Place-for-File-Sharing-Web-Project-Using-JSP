<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>DB 웹사이트</title>
</head>
<body>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>	
			</button>
			<a class="navbar-brand" href="providermain.jsp">DB 웹사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="providermain.jsp">메인</a>
				<li><a href="item.jsp">아이템 검색</a>
				<li class="active"><a href="itemAdd.jsp">아이템 추가</a>
				<li><a href="myitem.jsp">내 아이템 보기</a>
				<li><a href="providerbill.jsp">청구서</a>
				<li><a href="providerStatistics.jsp">통계</a>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<div class="container">
  		<div class="col-lg-4"></div>
  		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
   				<form method="post" action="itemAddAction.jsp">
    				<h3 style="text-align: center;"> 아이템 추가 화면 </h3>
    				<div class="form-group">
     					<input type="text" class="form-control" placeholder="아이템 이름" name="name" maxlength="20">
    				</div>   
    				<div class="form-group">
						<input type="text" class="form-control" placeholder="아이템 종류(확장자)" name="type" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이템 키워드" name="item_keyword" maxlength="20" >
					</div>
    				<div class="form-group">
						<input type="text" class="form-control" placeholder="아이템 크기" name="size" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="프로그래밍 언어" name="language" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="필요한  machine" name="machine_required" maxlength="20" >
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="필요한 OS" name="os_required" maxlength="20" >
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="필요한  프로그램" name="viewer_need" maxlength="20" >
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="가격" name="price" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="버전" name="version" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이템 설명" name="description" maxlength="20" >
					</div>
					<input type="submit" class="btn btn-primary form-control" value="아이템 추가">
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>