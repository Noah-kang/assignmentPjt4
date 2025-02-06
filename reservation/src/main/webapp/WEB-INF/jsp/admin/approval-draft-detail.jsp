<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기안문 상세 및 결재</title>
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
     .btn-primary {
        background-color: #007bff; /* 기본 파란색 배경 */
        color: white; /* 텍스트 흰색 */
        border: none; /* 테두리 제거 */
        padding: 10px 20px; /* 내부 여백 */
        font-size: 14px; /* 글꼴 크기 */
        font-weight: bold; /* 글꼴 두께 */
        border-radius: 5px; /* 모서리 둥글게 */
        cursor: pointer; /* 마우스 포인터 */
        transition: background-color 0.3s ease; /* 배경색 변화 애니메이션 */
    }

    .btn-primary:hover {
        background-color: #0056b3; /* 마우스 오버 시 어두운 파란색 */
    }

    .btn-primary:active {
        background-color: #003d7a; /* 클릭 시 더 어두운 파란색 */
    }

    .btn-primary:disabled {
        background-color: #b8d4f1; /* 비활성화된 상태의 배경색 */
        cursor: not-allowed; /* 비활성화된 커서 */
    }
    
    .btn-danger {
    background-color: #dc3545; /* 빨간색 배경 */
    color: white; /* 글자 색 흰색 */
    border: none; /* 테두리 제거 */
    padding: 10px 20px; /* 버튼 내부 여백 */
    border-radius: 5px; /* 둥근 모서리 */
    font-size: 14px; /* 글자 크기 */
    cursor: pointer; /* 마우스 포인터 변경 */
    transition: background-color 0.3s ease; /* 배경색 전환 효과 */
	}
	
	.btn-danger:hover {
	    background-color: #c82333; /* 호버 시 더 어두운 빨간색 */
	}
	
	.btn-danger:active {
	    background-color: #bd2130; /* 클릭 시 색상 */
	    box-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.2); /* 클릭 시 내부 그림자 */
	}
    
	</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>기안문 상세</h1>
        </div>
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

        <!-- 결재 승인 버튼 -->
        <div class="buttons">
            <c:if test="${isCurrentApprover}">
                <button class="btn-primary" onclick="approveDraft(${draftDocument.draftDocumentPk})">승인</button>
                <button class="btn-danger" onclick="rejectDraft(${draftDocument.draftDocumentPk})">반려</button>
            </c:if>
            <button class="btn-gray" onclick="closePopup()">닫기</button>
        </div>
    </div>

    <script>
        function approveDraft(draftDocumentPk) {
            if (!confirm("결재를 승인하시겠습니까?")) return;

            fetch('<c:url value="/admin/approval/draft/approve" />', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ draftDocumentPk })
            })
            .then(response => {
                if (response.ok) {
                    alert("결재가 완료되었습니다.");
                    window.location.reload();
                } else {
                    alert("결재 처리 중 문제가 발생했습니다.");
                }
            })
            .catch(error => {
                console.error(error);
                alert("결재 요청 실패: " + error.message);
            });
        }
        
        function rejectDraft(draftDocumentPk) {
        	if (!confirm("결재를 반려하시겠습니까?")) return;

            fetch('<c:url value="/admin/approval/draft/reject" />', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ draftDocumentPk })
            })
            .then(response => {
                if (response.ok) {
                    alert("반려가 완료되었습니다.");
                    window.location.reload();
                } else {
                    alert("반려 처리 중 문제가 발생했습니다.");
                }
            })
            .catch(error => {
                console.error(error);
                alert("반려 요청 실패: " + error.message);
            });
        }
        
        function closePopup() {
            if (window.opener) {
                // 부모 창 새로고침
                window.opener.location.reload();
            }
            // 팝업 닫기
            window.close();
        }
    </script>
</body>
</html>