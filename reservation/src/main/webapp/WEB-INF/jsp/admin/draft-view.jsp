<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f9f9f9;
    }

    .container {
        max-width: 800px;
        margin: 0 auto;
        background: #fff;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .header h1 {
        text-align: center;
        margin-bottom: 20px;
        color: #333;
    }

    .info-table, .approval-line-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }

    .info-table th, .approval-line-table th {
        background-color: #f5f5f5;
        text-align: left;
        padding: 10px;
        border-bottom: 1px solid #ddd;
        font-weight: bold;
        color: #333;
    }

    .info-table td, .approval-line-table td {
        padding: 10px;
        border-bottom: 1px solid #ddd;
        color: #555;
    }
    
    .content-box {
        width: 100%;
        height: 200px;
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 10px;
        background-color: #f9f9f9;
        resize: none;
        white-space: pre-wrap; /* 줄바꿈 처리 */
        overflow: auto;
    }

    .approval-line-table th, .approval-line-table td {
        text-align: center;
    }

    .file-list ul {
        list-style-type: none;
        padding: 0;
    }

    .file-list li {
        margin: 5px 0;
    }

    .file-list a {
        color: #007bff;
        text-decoration: none;
    }

    .file-list a:hover {
        text-decoration: underline;
    }

    .buttons {
        text-align: center;
    }

    .btn-gray {
        background-color: #ccc;
        border: none;
        padding: 10px 20px;
        color: #333;
        cursor: pointer;
        border-radius: 4px;
        font-size: 14px;
    }

    .btn-gray:hover {
        background-color: #bbb;
    }
</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>기안문 상세보기</h1>
        </div>
        <div class="document-info">
            <table class="info-table">
                <tr>
                    <th>문서번호</th>
                    <td>${draftDocument.draftDocumentPk}</td>
                    <th>기안일자</th>
                    <td>${draftDocument.date}</td>
                </tr>
                <tr>
                    <th>성명</th>
                    <td>${draftDocument.memberName}</td>
                    <th>부서/직위</th>
                    <td>${draftDocument.departmentName} / ${draftDocument.rankName}</td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td colspan="3">${draftDocument.title}</td>
                </tr>
            </table>
        </div>
        
        <h3>내용</h3>
        <textarea class="content-box" readonly>${draftDocument.content}</textarea>
        
        <h3>결재라인</h3>
        <table class="approval-line-table">
            <thead>
                <tr>
                    <th>순서</th>
                    <th>결재자</th>
                    <th>결재 상태</th>
                    <th>결재일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="line" items="${approvalLines}">
                    <tr>
                        <td>${line.lineOrder}</td>
                        <td>${line.memberName} (${line.rankName})</td>
                        <td>${line.lineStatusName}</td>
                        <td>${line.approvedAt != null ? line.approvedAt : "-"}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <h3>첨부파일</h3>
        <div class="file-list">
            <ul>
                <c:forEach var="file" items="${attachedFiles}">
                    <li>
                        <a href="<c:url value='/admin/draft/file/download?filePk=${file.filePk}' />">${file.fileName}</a>
                    </li>
                </c:forEach>
            </ul>
        </div>
        
        <div class="buttons">
            <button class="btn-gray" onclick="window.close()">닫기</button>
        </div>
    </div>
</body>

</html>