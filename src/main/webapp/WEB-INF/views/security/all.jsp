<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>/security/all page</h1>
<sec:authentication access="isAuthenticated()">
<a href="/customLogout">Logout</a>
</sec:authentication>

<sec:authentication access="isAnonymous()">
<a href="/customLogout">Login</a>
</sec:authentication>
</body>
</html>