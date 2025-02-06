<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>사용자 검색</title>
    <style>
        .form-row { margin-bottom: 10px; }
        .btn { padding: 5px 10px; background-color: orange; color: white; border: none; cursor: pointer; }
        .btn:hover { background-color: darkorange; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
    </style>
</head>
<body>
    <h1>사용자 검색</h1>
    <form method="get" action="<c:url value='/admin/member/search' />">
        <div class="form-row">
            <label>이름</label>
            <input type="text" name="keyword" placeholder="이름을 입력하세요" />
            <button type="submit" class="btn">검색</button>
        </div>
    </form>

    <table>
        <thead>
            <tr>
                <th>이름</th>
                <th>전화번호</th>
                <th>선택</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="member" items="${members}">
                <tr>
                    <td>${member.name}</td>
                    <td>${member.phoneNumber}</td>
                    <td>
                        <button type="button" onclick="selectMember('${member.memberPk}', '${member.name}', '${member.phoneNumber}')">선택</button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <script>
        function selectMember(memberPk, memberName, memberPhoneNumber) {
            window.opener.setMember(memberPk, memberName, memberPhoneNumber);
            window.close();
        }
    </script>
</body>
</html>
