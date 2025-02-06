<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>체험 인원 목록</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
    <div class="popup-header">
	    <h2>체험 인원 목록</h2>
	    
	</div>

	<table border="1">
	    <thead>
	        <tr>
	            <th>이름</th>
	            <th>성별</th>
	            <th>대상 구분</th>
	            <th>거주지</th>
	            <th>상세 주소</th>
	            <th>장애 여부</th>
	            <th>외국인 여부</th>
	        </tr>
	    </thead>
	    <tbody>
	        <c:forEach var="person" items="${experiencePersons}">
	            <tr>
	                <td>${person.name}</td>
	                <td>${person.gender}</td>
	                <td>${person.targetTypeName}</td>
	                <td>${person.residence}</td>
	                <td>${person.detailedAddress}</td>
	                <td>${person.disabled ? '예' : '아니요'}</td>
	                <td>${person.foreigner ? '예' : '아니요'}</td>
	            </tr>
	        </c:forEach>
	    </tbody>
	</table>

	<button onclick="window.close()">닫기</button>
</body>
</html>
