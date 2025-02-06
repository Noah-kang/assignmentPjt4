<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>예약 생성</title>
    <style>
        .form-container {
            width: 50%;
            margin: auto;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
        }
        .form-header {
            font-weight: bold;
            margin-bottom: 10px;
        }
        .form-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        .form-row label {
            width: 30%;
            text-align: right;
            margin-right: 10px;
        }
        .form-row input {
            width: 60%;
            padding: 5px;
        }
        .btn-container {
            display: flex;
            justify-content: space-between;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            color: white;
            cursor: pointer;
            border-radius: 5px;
        }
        .btn-save {
            background-color: #28a745;
        }
        .btn-back {
            background-color: #6c757d;
        }
    </style>
</head>
<body>
    <h1>예약 생성</h1>
    <div class="form-container">
        <div class="form-header">예약정보 확인</div>
        <form action="<c:url value='/admin/schedule/save' />" method="post">
        	<input type="hidden" name="programPk" value="${programPk}" />
            <div class="form-row">
                <label for="programName">체험명</label>
                <input type="text" id="programName" name="programName" value="${programName}" readonly />
            </div>
            <div class="form-row">
                <label for="date">날짜</label>
                <input type="date" id="date" name="date" value="${date}" readonly />
            </div>
            <div class="form-row">
			    <label for="time">시간</label>
			    <input type="text" id="time" name="time" placeholder="예: 10:00" required pattern="^([01][0-9]|2[0-3]):([0-5][0-9])$" maxlength="5" />
			</div>
            <div class="form-row">
                <label for="maxCapacity">제한인원수</label>
                <input type="number" id="maxCapacity" name="maxCapacity" placeholder="최대 인원수 입력" required />
            </div>
            <div class="btn-container">
                <button type="submit" class="btn btn-save">저장</button>
                
            </div>
        </form>
        <div class="btn-container">
	        <form action="<c:url value='/admin/calendar' />" method="get">
	        	<input type="hidden" name="programPk" value="${programPk}" />
		    	<input type="hidden" name="date" value="${date}" />
	            <button type="submit" class="btn btn-back">돌아가기</button>
	        </form>
	    </div>
    </div>
    <c:if test="${not empty errorMessage}">
    <script>
        alert("${errorMessage}");
    </script>
	</c:if>
	
	<script>
	document.querySelector("form").addEventListener("submit", function(event) {
	    const timeInput = document.getElementById("time").value;
	    const timePattern = /^([01][0-9]|2[0-3]):([0-5][0-9])$/; // 00:00 ~ 23:59 형식
	
	    if (!timePattern.test(timeInput)) {
	        alert("시간을 HH:MM 형식으로 입력해주세요. 예: 10:00, 23:45");
	        event.preventDefault(); // 제출 방지
	    }
	});
	</script>
	
</body>
</html>
