<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>일괄 예약 생성</title>
    <style>
        .form-container {
            max-width: 600px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background: #fff;
        }
        .form-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        .form-row label {
            width: 40%;
            text-align: right;
            margin-right: 10px;
        }
        .form-row input {
            width: 50%;
            padding: 5px;
        }
        .btn-container {
            text-align: center;
            margin-top: 20px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-save {
            background-color: #28a745;
            color: white;
        }
        .btn-back {
            background-color: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <h1>일괄 예약 생성</h1>
    <div class="form-container">
        <form action="<c:url value='/admin/schedule/bulk/save' />" method="post">
            <input type="hidden" name="programPk" value="${programPk}" />
            <div class="form-row">
                <label>체험명:</label>
                <input type="text" value="${programName}" readonly />
            </div>
            <div class="form-row">
                <label>월:</label>
                <input type="text" name="yearMonth" value="${yearMonth}" readonly />
            </div>
            <div class="form-row">
			    <label for="time">시간:</label>
			    <input type="text" id="time" name="time" placeholder="예: 10:00" required pattern="^([01][0-9]|2[0-3]):([0-5][0-9])$" maxlength="5"/>
			</div>
            <div class="form-row">
                <label>제한인원:</label>
                <input type="number" name="maxCapacity" placeholder="최대 인원수 입력" required />
            </div>
            <div class="btn-container">
                <button type="submit" class="btn btn-save">저장</button>
                <button type="button" class="btn btn-back" onclick="location.href='<c:url value='/admin/calendar' />'">돌아가기</button>
            </div>
        </form>
    </div>
    
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
