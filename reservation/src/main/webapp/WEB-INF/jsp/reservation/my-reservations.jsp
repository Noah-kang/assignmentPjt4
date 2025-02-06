<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>예약 정보 확인</title>
    <style>
	    .reservation-table {
	        width: 100%;
	        border-collapse: separate; /* 테이블 테두리 유지 */
	        border-spacing: 10px; /* ⬅️ cellspacing을 대체 */
	    }
	
	    .reservation-table th, .reservation-table td {
	        padding: 10px; /* ⬅️ cellpadding을 대체 */
	        border: 1px solid #ccc;
	        text-align: center;
	    }
        .btn {
            padding: 5px 10px;
            border: none;
            color: white;
            cursor: pointer;
        }
        .btn-info { background-color: blue; }
        .btn-cancel { background-color: red; }
        .btn-info:hover, .btn-cancel:hover { opacity: 0.8; }
    </style>
</head>
<body>
    <h1>예약 정보 확인</h1>
    <table class="reservation-table">
        <thead>
            <tr>
                <th>체험명</th>
                <th>예약 시간</th>
                <th>예약자 수</th>
                <th>확인</th>
                <th>취소</th>
            </tr>
        </thead>
        <tbody>
            	<c:if test="${empty reservations}">
                    <tr>
                        <td colspan="5">예약 정보가 없습니다.</td>
                    </tr>
                </c:if>
            <c:forEach var="reservation" items="${reservations}">
                <tr>
                    <td>${reservation.programName}</td>
                    <td>${reservation.date} ${reservation.time}</td>
                    <td>${reservation.experiencePersonCount}</td>
                    <td>
                        <button class="btn btn-info" onclick="openExperiencePersonPopup(${reservation.reservationPk})">예약정보</button>
                    </td>
                    <td>
                        <c:if test="${reservation.date > currentTime}">
					        <button class="btn btn-danger" onclick="cancelReservation(${reservation.reservationPk})">예약취소</button>
					    </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <div class="buttons">
    	<form method="get" action="<c:url value='/' />">
		    <input type="hidden" name="programPk" value="${programPk}" />
		    <input type="hidden" name="date" value="${date}" />
		    <button type="submit" class="btn btn-info">돌아가기</button>
		</form>
	</div>
	

    <script>
    // 체험인원 상세 가져오기
    function openExperiencePersonPopup(reservationPk) {
        const popupUrl = `<c:url value='/reservation/experiencePersonsPopup' />?reservationPk=\${reservationPk}`;
        window.open(popupUrl, '체험인원목록', 'width=800,height=600,scrollbars=yes');
    }
	
    // 예약취소 버튼(예약내역 삭제)
    function cancelReservation(reservationPk) {
        if (confirm("예약을 취소하시겠습니까?")) {
            fetch(`<c:url value='/reservation/cancel/' />\${reservationPk}`, {
                method: "DELETE",
            })
            .then((response) => {
                if (response.ok) {
                    alert("예약이 취소되었습니다.");
                    location.reload(); // 페이지 새로고침
                } else {
                    alert("예약 취소 중 오류가 발생했습니다.");
                }
            })
            .catch((error) => {
                console.error("Error:", error);
                alert("시스템 오류가 발생했습니다. 관리자에게 문의하세요.");
            });
        }
    }
    
    </script>
</body>
</html>
