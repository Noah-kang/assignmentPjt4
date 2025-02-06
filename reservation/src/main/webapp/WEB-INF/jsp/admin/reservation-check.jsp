<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 - 예약확인</title>
    <style>
        .form-container {
            width: 80%;
            margin: 0 auto;
        }
        .form-row { display: flex; margin-bottom: 10px; }
        .form-row label { width: 150px; font-weight: bold; }
        .form-row input, .form-row select { flex: 1; padding: 5px; }
        .btn { padding: 10px 20px; background: orange; color: white; border: none; cursor: pointer; }
        .btn:hover { background: darkorange; }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table th, .table td { border: 1px solid #ccc; padding: 10px; text-align: center; }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>예약확인</h1>
        <form method="get" action="<c:url value='/admin/reservation/check' />">
            <div class="form-row">
                <label>이름</label>
                <input type="text" name="name" placeholder="예약자 이름" maxlength="20"/>
            </div>
            <div class="form-row">
                <label>대표 연락처</label>
                <input type="text" name="phoneNumber" placeholder="전화번호" maxlength="13"/>
            </div>
            <div class="form-row">
                <label>날짜</label>
                <input type="date" name="date" />
            </div>
            <div class="form-row">
                <label>프로그램명</label>
                <select name="programPk">
                    <option value="">선택</option>
                    <c:forEach var="program" items="${programs}">
                        <option value="${program.programPk}">${program.name}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn">확인</button>
        </form>

        <table class="table">
            <thead>
                <tr>
                    <th>예약자 이름</th>
                    <th>전화번호</th>
                    <th>날짜</th>
                    <th>시간</th>
                    <th>프로그램명</th>
                    <th>예약 구분</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="reservation" items="${reservations}">
                    <tr onclick="goToScheduleManagement(${reservation.schedulePk})" style="cursor: pointer;">
                        <td>${reservation.memberName}</td>
                        <td>${reservation.phoneNumber}</td>
                        <td>${reservation.date}</td>
                        <td>${reservation.time}</td>
                        <td>${reservation.programName}</td>
                        <td>${reservation.reservationTypeName}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty reservations}">
                    <tr>
                        <td colspan="6">검색 결과가 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        <button onclick="location.href='<c:url value='/admin/calendar' />'" class="btn">뒤로가기</button>
    </div>
    
    <script>
    // 일정 관리페이지로
    function goToScheduleManagement(schedulePk) {
        location.href = contextPath + '/admin/scheduleDetail?schedulePk=' + schedulePk;
    }
    
 	// JSP에서 contextPath를 JavaScript 변수로 전달
    const contextPath = "${pageContext.request.contextPath}";
    
	</script>
</body>
</html>
