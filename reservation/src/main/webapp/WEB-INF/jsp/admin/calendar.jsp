<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 - 예약일정 관리</title>
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
        .register-btn {
            margin-top: 10px;
            padding: 5px 10px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        .register-btn:hover, .nav-btn:hover, .logout-btn:hover {
            background-color: #0056b3;
        }
        .register-btn.disabled {
        background-color: #ccc;
        color: #666;;
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
        
        .bulk-create-btn {
		    text-align: right;
		    margin: 10px 0;
		    
		}
		
    </style>
</head>
<body>
	<header>
    <h1>예약일정 관리</h1>
    <div class="header-actions">
        <div class="auth-buttons">
            <c:choose>
                <c:when test="${empty loginMemberId}">
                    <button onclick="location.href='<c:url value='/member/login' />'">로그인</button>
                </c:when>
                <c:otherwise>
                    <span>${loginMemberId}님 안녕하세요.</span>
                    <form action="<c:url value='/member/logout' />" method="post" style="display: inline;">
                        <button type="submit">로그아웃</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
        <button onclick="location.href='<c:url value='/admin/reservation/check' />'" class="nav-btn">예약확인</button>
        <button onclick="location.href='<c:url value='/admin/approval/inbox' />'" class="nav-btn">결재함</button>
    </div>
	</header>
    <form method="get">
        <label for="program">프로그램 선택:</label>
        <select name="programPk" id="program" onchange="this.form.submit()">
            <c:forEach var="program" items="${programs}">
                <option value="${program.programPk}" ${program.programPk == param.programPk ? 'selected' : ''}>
                    ${program.name}
                </option>
            </c:forEach>
        </select>
    </form>

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
	    <div class="bulk-create-btn">
		    <form method="get" action="<c:url value='/admin/schedule/bulk' />" style="display: inline;">
		        <!-- programPk 전달 -->
		        <input type="hidden" name="programPk" value="${selectedProgramPk}" />
		        <!-- yearMonth 전달 -->
		        <input type="hidden" name="yearMonth" value="${currentDate.format(dateFormatter)}" />
		        <button type="submit" class="nav-btn">일괄 생성</button>
		    </form>
		</div>
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
			        <%--  빈 칸 삽입: 첫 날의 요일이 월요일(1)부터 시작 --%>
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
			                        <c:choose>
							            <%-- 예약 마감 조건: 날짜가 과거이거나, 예약 인원 초과, 기안문이 있으면 마감 --%>
							            <c:when test="${schedule.date <= today || schedule.reservationCount >= schedule.maxCapacity || schedule.hasDraft}">

							                <form action="<c:url value='/admin/scheduleDetail' />" method="get">
									            <input type="hidden" name="schedulePk" value="${schedule.schedulePk}" />
									            <button type="submit" class="register-btn disabled">
									                ${schedule.time} 마감 (${schedule.reservationCount}/${schedule.maxCapacity}명)
									            </button>
									        </form>
							            </c:when>
			                            
			                            <c:otherwise>
				                            <form action="<c:url value='/admin/scheduleDetail' />" method="get">
									            <input type="hidden" name="schedulePk" value="${schedule.schedulePk}" />
									            <button type="submit" class="register-btn">
									                ${schedule.time} 예약 (${schedule.reservationCount}/${schedule.maxCapacity}명)
									            </button>
									        </form>
									    </c:otherwise>
								    </c:choose>
		                        </c:if>
		                    </c:forEach>
			                <c:if test="${currentDate.withDayOfMonth(currentDay).dayOfWeek.value != 1}">
			                    <form action="<c:url value='/admin/schedule' />" method="get">
	                                <input type="hidden" name="programPk" value="${selectedProgramPk}" />
	                                <input type="hidden" name="date" value="${currentDate.withDayOfMonth(currentDay)}" />
	                                <button type="submit" class="register-btn">신규등록</button>
                            	</form>
			                </c:if>
			            </div>
			        </c:otherwise>
			    </c:choose>
			</c:forEach>
        </div>
    </div>
</body>
</html>
