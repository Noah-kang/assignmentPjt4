<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 - 예약일정관리</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1 {
            margin-bottom: 20px;
        }
        .info-section, .reservation-section {
            margin-bottom: 30px;
        }
        .info-section table, .reservation-section table {
            width: 100%;
            border-collapse: collapse;
        }
        .info-section td, .reservation-section th, .reservation-section td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        .info-section th, .reservation-section th {
            background-color: #f4f4f4;
        }
        .buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .buttons button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .buttons button:hover {
            background-color: #0056b3;
        }
        .btn-red {
            background-color: #dc3545;
        }
        .btn-red:hover {
            background-color: #b02a37;
        }
        .btn-gray {
            background-color: #6c757d;
        }
        .btn-gray:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <h1>예약일정 관리</h1>

    <!-- 예약정보 변경 -->
    <div class="info-section">
    <h2>예약정보 확인</h2>
    <form action="<c:url value='/admin/schedule/updateCapacity' />" method="post">
        <input type="hidden" name="schedulePk" value="${schedule.schedulePk}" />
        <table>
            <tr>
                <th>체험명</th>
                <td>${schedule.programName}</td>
                <th>날짜</th>
                <td>${schedule.date}</td>
            </tr>
            <tr>
                <th>시간</th>
                <td>${schedule.time}</td>
                <th>제한인원수</th>
                <td>
                    <!-- 제한인원수 입력 필드 -->
                    <input type="number" id="maxCapacity" name="maxCapacity" value="${schedule.maxCapacity}" required />
                </td>
            </tr>
            <tr>
                <td colspan="4">예약건수: ${schedule.reservationCount}, 예약 인원: ${schedule.experiencePersonCount}</td>
            </tr>
        </table>
        <div class="buttons">
            <!-- 돌아가기 버튼 -->
            <button type="button" class="btn-gray" onclick="location.href='<c:url value='/admin/calendar' />'">홈으로</button>
            <div>
                <!-- R 상태: 예약마감 버튼 -->
		        <c:if test="${status == 'R'}">
		            <button type="button" class="btn-red" onclick="openDraftPopup(${schedule.schedulePk})">예약마감</button>
		        </c:if>
		
		        <!-- P 상태: 기안확인 버튼 -->
		        <c:if test="${status == 'P'}">
		            <button type="button" class="btn-blue" onclick="viewDraft(${draftDocumentPk})">기안확인</button>
		        </c:if>
		
		        <!-- C 상태: 결재완료 버튼 -->
		        <c:if test="${status == 'C'}">
		            <button type="button" class="btn-green" onclick="viewDraft(${draftDocumentPk})">결재완료</button>
		        </c:if>
                <!-- 저장 버튼 -->
                <button type="submit" class="btn">저장</button>
            </div>
        </div>
    </form>
	</div>


    <!-- 예약 리스트 -->
    <div class="reservation-section">
        <h2>예약 리스트</h2>
        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>체험명</th>
                    <th>예약구분</th>
                    <th>예약시간</th>
                    <th>예약자명</th>
                    <th>예약자수</th>
                    <th>예약자확인</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
            	<c:if test="${empty reservations}">
                    <tr>
                        <td colspan="8">예약자가 없습니다.</td>
                    </tr>
                </c:if>
            
                <c:forEach var="reservation" items="${reservations}">
                    <tr>
                        <td>${reservation.rowNum}</td>
                        <td>${schedule.programName}</td>
                        <td>${reservation.reservationTypeName}</td>
                        <td>${schedule.date}(${schedule.time})</td>
                        <td>${reservation.memberName}</td>
                        <td>${reservation.experiencePersonCount}</td>
                        <td><button onclick="openExperiencePersonPopup(${reservation.reservationPk})">확인</button></td>
                        <td><button class="btn-red" onclick="confirmDelete(${reservation.reservationPk})">삭제</button></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <div class="buttons">
		    <form action="<c:url value='/admin/reservation/create' />" method="get">
		        <input type="hidden" name="schedulePk" value="${schedule.schedulePk}" />
		        <button type="submit">예약자 추가</button>
		    </form>
		</div>
    </div>
    
    <script>
 	// JSP에서 contextPath를 JavaScript 변수로 전달
    const contextPath = "${pageContext.request.contextPath}";
    
    // 예약자 확인 팝업
	function openExperiencePersonPopup(reservationPk) {
		// 팝업 JSP로 연결
	    const popupUrl = contextPath + "/admin/reservation/experiencePersonsPopup?reservationPk=" + reservationPk;
	    window.open(popupUrl, '체험인원목록', 'width=800,height=600,scrollbars=yes');
	}
    
    // 삭제버튼
	function confirmDelete(reservationPk) {
        if (confirm('삭제하시겠습니까?')) {
            // 삭제 요청
            fetch(`\${contextPath}/admin/reservation/delete/\${reservationPk}`, {
                method: 'DELETE'
            })
            .then(response => {
                if (response.ok) {
                    alert('삭제되었습니다.');
                    location.reload(); // 삭제 후 페이지 새로고침
                } else {
                    alert('삭제 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('삭제 중 오류:', error);
                alert('삭제 중 오류가 발생했습니다.');
            });
        }
    }
    
	// 예약마감 버튼 클릭 시 팝업 열기
    function openDraftPopup(schedulePk) {
        const url = '<c:url value="/admin/draft" />?schedulePk=' + schedulePk;
        window.open(url, 'draftPopup', 'width=800,height=600,scrollbars=yes');
    }
	
 	// 기안문 보기 팝업 열기
    function viewDraft(draftDocumentPk) {
        const url = `<c:url value='/admin/draft/view?draftDocumentPk=' />` + draftDocumentPk;
        window.open(url, '기안문 보기', 'width=800,height=600,scrollbars=yes');
    }
 	
 	// 제한인원 저장 유효성검사
    document.querySelector("form").addEventListener("submit", function (event) {
        const maxCapacityInput = document.getElementById("maxCapacity"); // 제한인원수 입력 필드
        const maxCapacity = parseInt(maxCapacityInput.value); // 입력된 제한 인원수
        const experiencePersonCount = parseInt(${schedule.experiencePersonCount}); // 현재 예약 인원수

        // 유효성 검사
        if (isNaN(maxCapacity) || maxCapacity <= 0) {
            alert("제한인원수는 0보다 큰 숫자여야 합니다.");
            event.preventDefault(); // 폼 제출 차단
            return;
        }

        if (maxCapacity < experiencePersonCount) {
            alert(`제한인원수는 현재 예약 인원(\${experiencePersonCount})보다 작을 수 없습니다.`);
            event.preventDefault(); // 폼 제출 차단
            return;
        }
    });
	</script>
</body>
</html>
