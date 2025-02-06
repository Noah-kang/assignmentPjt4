<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.container {
    width: 90%;
    margin: 0 auto;
    padding: 20px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.header h1 {
    font-size: 24px;
    margin-bottom: 20px;
    color: #333;
    text-align: center;
}

.return-button {
    font-size: 14px;
    padding: 8px 15px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.return-button:hover {
    background-color: #0056b3;
}

.table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
    color: #333;
}

.table th,
.table td {
    text-align: left;
    padding: 10px;
    border-bottom: 1px solid #ddd;
}

.table th {
    background-color: #f4f4f4;
    font-weight: bold;
}

.table tr:hover {
    background-color: #f9f9f9;
}

.table td {
    vertical-align: middle;
}

.table td:last-child {
    text-align: center;
}

</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>결재함 목록</h1>
             <button class="btn-primary return-button" onclick="location.href='<c:url value="/admin/calendar" />';">
                관리자 홈
            </button>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th style="width: 10%;">문서번호</th>
                    <th style="width: 40%;">문서제목</th>
                    <th style="width: 20%;">기안자</th>
                    <th style="width: 20%;">기안일자</th>
                    <th style="width: 10%;">결재상태</th>
                </tr>
            </thead>
            <tbody>
            
            	<c:if test="${empty drafts}">
                    <tr>
                        <td colspan="5">결재함이 비었습니다.</td>
                    </tr>
                </c:if>
                
                <c:forEach var="draft" items="${drafts}">
                    <tr onclick="openDraftDetailPopup(${draft.draftDocumentPk})" style="cursor: pointer;">
                        <td>${draft.draftDocumentPk}</td>
                        <td>${draft.title}</td>
                        <td>${draft.drafterName}</td>
                        <td>${draft.date}</td>
                        <td>${draft.approvalStatusName}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    
    <script>
        function openDraftDetailPopup(draftDocumentPk) {
            const url = '<c:url value="/admin/approval/draft/detail" />?draftDocumentPk=' + draftDocumentPk;
            window.open(url, '결재상세보기', 'width=800,height=600,scrollbars=yes');
        }
    </script>
</body>
</html>