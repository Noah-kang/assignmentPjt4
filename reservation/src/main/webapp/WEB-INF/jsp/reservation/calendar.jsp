<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>사용자 - 예약일정</title>
    <style>
	    header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 10px;
		background-color: #f4f4f4;
		}
	
		header h1 {
			margin: 0;
		}

		header .auth-buttons button {
			margin-left: 10px;
			border: 1px solid #007BFF;
			padding: 5px 10px;
			background-color: transparent;
			border-radius: 5px;
			cursor: pointer;
		}
    
        body {
            font-family: Arial, sans-serif;
        }
        .program-cards {
            display: flex;
            justify-content: space-around;
            margin: 20px 0;
        }
        .program-card {
            width: 200px;
            text-align: center;
            cursor: pointer;
        }
        .program-card img {
            width: 100%;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .calendar-container {
            width: 100%;
        }
        .calendar-header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            text-align: center;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .calendar {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
        }
        .day {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
            background-color: #f9f9f9;
        }
        .holiday {
            background-color: #ffe5e5;
        }
        .schedule-info {
            margin-top: 5px;
            padding: 5px;
            background-color: #ff9800;
            color: white;
            border-radius: 4px;
        }
        .schedule-info:hover {
            background-color: #e68900;
        }
        .nav-btn {
            margin: 5px;
            padding: 5px 10px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        .nav-btn:hover {
            background-color: #0056b3;
        }
        .schedule-info.disabled {
        background-color: #ccc;
        color: #666;
        cursor: not-allowed;
    	}
    </style>
</head>
<body>
	<header>
		<h1>예약일정</h1>
		<div class="auth-buttons">
			<c:choose>
				<c:when test="${empty loginMemberId}">
					<button onclick="location.href='<c:url value='/member/login' />'">로그인</button>
				</c:when>
				<c:otherwise>
					<span>${loginMemberId}님 안녕하세요.</span>
					<form action="<c:url value='/member/logout' />" method="post"
						style="display: inline;">
						<button type="submit">로그아웃</button>
					</form>
					<form method="get" action="<c:url value='/reservation/myReservations' />">
				        <input type="hidden" name="programPk" value="${selectedProgramPk}" />
						<input type="hidden" name="date" value="${currentDate}" />
				        <button type="submit">
				        	내예약 
			        	</button>
				    </form>
				</c:otherwise>
			</c:choose>
		</div>
	</header>
    <div class="program-cards">
        <c:forEach var="program" items="${programs}">
            <div class="program-card" onclick="window.location.href='?programPk=${program.programPk}'">
                <img src="${pageContext.request.contextPath}/resources/images/${program.programPk}.png" alt="${program.name}">
                <div>${program.name}</div>
            </div>
        </c:forEach>
    </div>

    <div>
        <form method="get" style="display: inline;">
            <input type="hidden" name="programPk" value="${selectedProgramPk}">
            <input type="hidden" name="date" value="${currentDate.minusMonths(1)}">
            <button type="submit" class="nav-btn">이전 월</button>
        </form>
        <span>${currentDate.format(dateFormatter)}</span>
        <form method="get" style="display: inline;">
            <input type="hidden" name="programPk" value="${selectedProgramPk}">
            <input type="hidden" name="date" value="${currentDate.plusMonths(1)}">
            <button type="submit" class="nav-btn">다음 월</button>
        </form>
    </div>

    <div class="calendar-container">
        <div class="calendar-header">
            <div>월</div>
            <div>화</div>
            <div>수</div>
            <div>목</div>
            <div>금</div>
            <div>토</div>
            <div>일</div>
        </div>
        <div class="calendar">
            <c:forEach var="day" begin="1" end="${currentDate.lengthOfMonth() + (currentDate.withDayOfMonth(1).dayOfWeek.value - 1)}">
                <c:set var="emptyDays" value="${currentDate.withDayOfMonth(1).dayOfWeek.value - 1}" />
                <c:choose>
                    <c:when test="${day <= emptyDays}">
                        <div class="day"></div>
                    </c:when>
                    <c:otherwise>
                        <c:set var="currentDay" value="${day - emptyDays}" />
                        <div class="day ${currentDate.withDayOfMonth(currentDay).dayOfWeek.value == 1 ? 'holiday' : ''}">
                            <span>${currentDay}</span>
                            <c:if test="${currentDate.withDayOfMonth(currentDay).dayOfWeek.value == 1}">
                                <div>휴관일</div>
                            </c:if>
                            <c:forEach var="schedule" items="${schedules}">
                            
                                <c:if test="${schedule.date == currentDate.withDayOfMonth(currentDay)}">
                                    <div>
                                    	<c:choose>
							                <%-- 날짜가 null인지 먼저 확인 --%>
    										<c:when test="${schedule.date <= today || schedule.reservationCount >= schedule.maxCapacity || schedule.hasDraft}">
							                    <button class="schedule-info disabled" disabled>${schedule.time} 마감 (${schedule.reservationCount}/${schedule.maxCapacity}명)</button>
							                </c:when>
                                    		<%-- 오늘 이후 날짜 --%>
                							<c:otherwise>
											    <form method="get" action="<c:url value='/reservation' />">
											        <input type="hidden" name="schedulePk" value="${schedule.schedulePk}" />
											        <input type="hidden" name="programPk" value="${selectedProgramPk}" />
		                							<input type="hidden" name="date" value="${currentDate}" />
											        <button type="submit" class="schedule-info">
											        	${schedule.time} 예약 (${schedule.reservationCount}/${schedule.maxCapacity}명)
										        	</button>
											    </form>
											</c:otherwise>
										</c:choose>
									</div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
    </div>
</body>
</html>
