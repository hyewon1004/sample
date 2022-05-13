<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>Custom Login Page</h1>
<h2><c:out value="${error }"/></h2>
<h2><c:out value="${logout }"/></h2>
<form method="post" action="/login">
<div>
<input type="text" name="username">
</div>
<div>
<input type="password" name="password">
</div>
<div>
<input type="submit" value="login">
</div>
<!-- csrf사이트 위조방지를 목적으로 측정한 값의 토큰을 사용
cross site request forgery
2008년에 옥션 쇼핑몰이 이방법으로 털렸다(개인정보유출)
서버에서 받아들이는 정보가 특별히 사전조건을 검증하지 않는다는 단점을 이용해서 공격하는 방식 -->
<input type="hidden" name="${_csrf.parameterName }"
value="${_csrf.token }">
</form>
</body>
</html>