<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
body {
	font-family: Arial, sans-serif;
	text-align: center;
	margin-top: 50px;
}

.login-container {
	width: 300px;
	margin: 0 auto;
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 10px;
	margin: 10px 0;
	border: 1px solid #ccc;
	border-radius: 5px;
}

button {
	width: 100%;
	padding: 10px;
	background-color: red;
	color: white;
	border: none;
	border-radius: 5px;
	font-size: 16px;
}

.register-link {
	margin-top: 10px;
	display: block;
	color: #666;
	text-decoration: none;	
}
 /* 목록 버튼을 조금 구분하고 싶다면 별도 클래스 지정 가능 */
        .list-button {
            background-color: #4CAF50; /* 초록색 예시 */
            margin-top: 10px;
        }
</style>
</head>
<body>
<div class="login-container">
        <h1>로그인</h1>
        <form action="<c:url value='/member/login' />" method="post">
            <input type="text" name="memberId" placeholder="아이디" maxlength="20" required />
            <input type="password" name="password" placeholder="비밀번호" maxlength="25" required />
            <button type="submit">로그인</button>
        </form>
        <br>
        <button type="button"
                onclick="location.href='<c:url value="/member/register"/>'">
            회원가입
        </button>
        
        <!-- 홈으로 이동 버튼 -->
        <button type="button" class="list-button"
                onclick="location.href='<c:url value="/"/>'">
            홈으로
        </button>
    </div>
</body>
</html>