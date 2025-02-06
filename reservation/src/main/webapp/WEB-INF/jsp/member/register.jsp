<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
body {
	font-family: Arial, sans-serif;
	text-align: center;
	margin-top: 50px;
}

.register-container {
	width: 400px;
	margin: 0 auto;
	text-align: left;
}

label {
	font-weight: bold;
	display: block;
	margin-top: 15px;
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 10px;
	margin: 5px 0;
	border: 1px solid #ccc;
	border-radius: 5px;
}

.buttons {
	margin-top: 20px;
	text-align: center;
}

button {
	padding: 10px 20px;
	margin: 5px;
	border: none;
	border-radius: 5px;
	font-size: 16px;
}

.cancel {
	display: inline-block;
	padding: 10px 20px;
	background-color: #f44336;
	color: white;
	border: none;
	text-decoration: none;
	font-size: 14px;
	cursor: pointer;
	border-radius: 4px;
}

.cancel:hover {
	background-color: #d32f2f;
}

.register {
	background-color: red;
	color: white;
}
</style>
</head>
<body>
	<div class="register-container">
		<h1>회원정보 입력</h1>
		<form action="<c:url value='/member/register' />" method="post">
			<div>
				<label for="memberId">아이디 <span style="color: red;">*</span></label>
				<input type="text" id="memberId" name="memberId"
					placeholder="아이디를 입력해주세요" maxlength="20" required>
				<button type="button" id="checkDuplicate">중복확인</button>
				<small>한글, 특수문자를 제외한 5~15자의 영문과 숫자로 입력해주세요.</small>
			</div>
			<div>
				<label for="password">비밀번호 <span style="color: red;">*</span></label>
				<input type="password" id="password" name="password"
					placeholder="비밀번호를 입력해주세요" maxlength="25" required> <small>숫자,
					영문자, 특수문자를 포함하여 10자 이상 입력해야 합니다. (최대 25자)</small>
			</div>
			<div>
				<label for="confirmPassword">비밀번호 확인 <span
					style="color: red;">*</span></label> <input type="password"
					id="confirmPassword" name="confirmPassword"
					placeholder="비밀번호를 다시 입력해주세요" maxlength="25" required>
			</div>
			<div>
				<label>이름 <span style="color: red;">*</span></label> <input
					type="text" id="name" name="name" placeholder="이름을 입력하세요." maxlength="20" required />
			</div>
			<div>
				<label for="phoneNumber">전화번호 <span style="color: red;">*</span></label>
				<input type="text" id="phoneNumber" name="phoneNumber"
					placeholder="전화번호를 입력해주세요" maxlength="13" required> <small> 예:
					010-xxxx-xxxx</small>
			</div>

			<div class="buttons">
				<button type="button"
					onclick="location.href='<c:url value="/member/login"/>'">
					취소</button>
				<button type="submit" class="register">가입</button>
			</div>
		</form>
	</div>

	<script>
		// 폼 제출 이벤트에 validateForm 연결
		document.querySelector("form").addEventListener("submit", async function(event) {
    event.preventDefault(); // 기본 폼 제출 동작 중단

    const isValid = await validateForm(); // 폼 검증 함수 호출
    if (isValid) {
        this.submit(); // 검증 성공 시 폼 제출
    }
});

		async function validateForm() {
		    console.log("Validation started...");

		    const memberId = document.getElementById("memberId").value.trim();
		    const password = document.getElementById("password").value;
		    const confirmPassword = document.getElementById("confirmPassword").value;
		    const name = document.getElementById("name").value.trim();
		    const phoneNumber = document.getElementById("phoneNumber").value.trim(); // 전화번호 값 가져오기

		    // 아이디 조건: 한글, 특수문자를 제외한 5~15자의 영문과 숫자
		    const memberIdRegex = /^[a-zA-Z0-9]{5,15}$/;
		    if (!memberIdRegex.test(memberId)) {
		        alert("아이디는 한글, 특수문자를 제외한 5~15자의 영문과 숫자로 입력해주세요.");
		        return false;
		    }

		    // **중복 확인 Ajax 요청**
		    const isDuplicate = await checkDuplicateId(memberId);
		    if (isDuplicate) {
		        alert("이미 사용 중인 아이디입니다.");
		        return false;
		    }

		    // 비밀번호 조건: 10자 이상, 영문자, 숫자, 특수문자 포함
		    const passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{10,25}$/;
		    if (!passwordRegex.test(password)) {
		        alert("비밀번호는 영문자, 숫자, 특수문자를 포함하여 10자 이상 25자 이하로 입력해야 합니다.");
		        return false;
		    }

		    // 비밀번호 확인 일치 여부
		    if (password !== confirmPassword) {
		        alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		        return false;
		    }

		    // 이름 조건: 빈 값 금지 및 최대 50자 제한
		    if (name === "") {
		        alert("이름을 입력해주세요.");
		        return false;
		    }
		    if (name.length > 50) {
		        alert("이름은 최대 50자까지 입력 가능합니다.");
		        return false;
		    }
		    
		 	// 전화번호 조건: 010-xxxx-xxxx 형태
		    const phoneNumberRegex = /^010-\d{4}-\d{4}$/;
		    if (!phoneNumberRegex.test(phoneNumber)) {
		        alert("전화번호는 010-xxxx-xxxx 형식으로 입력해주세요.");
		        return false;
		    }

		    return true; // 모든 조건을 만족하면 true 반환
		}

		// 중복확인 버튼 클릭 시
		document.getElementById("checkDuplicate").addEventListener(
				"click",
				function() {
					const memberId = document.getElementById("memberId").value
							.trim();

					// 1) 먼저 아이디가 비어있는지 확인
					if (memberId === "") {
						alert("아이디를 입력해주세요.");
						return;
					}

					// 2) 아이디 정규식 검사 (이미 validateForm에 있는 로직과 동일하게)
					//    한글, 특수문자를 제외한 5~15자의 영문과 숫자
					const memberIdRegex = /^[a-zA-Z0-9]{5,15}$/;
					if (!memberIdRegex.test(memberId)) {
						alert("아이디는 한글, 특수문자를 제외한 5~15자의 영문과 숫자로 입력해주세요.");
						return; // 조건을 만족하지 않으면 중복확인을 진행하지 않음
					}

					// 3) 여기까지 통과하면 Ajax로 중복 체크
					$.ajax({
						url : "<c:url value='/member/checkId' />",
						type : "GET",
						data : {
							memberId : memberId
						},
						success : function(isExists) {
							if (isExists) {
								alert("이미 사용 중인 아이디입니다.");
							} else {
								alert("사용 가능한 아이디입니다.");
							}
						},
						error : function() {
							alert("중복 확인 중 오류가 발생했습니다. 다시 시도해주세요.");
						},
					});
				});
				
				// 전역에 함수 정의
				async function checkDuplicateId(memberId) {
				    try {
				        const response = await $.ajax({
				            url: "<c:url value='/member/checkId' />", // 서버의 중복 확인 API URL
				            type: "GET",
				            data: { memberId: memberId },
				        });

				        // 서버에서 반환한 값에 따라 true(중복) 또는 false(사용 가능) 반환
				        return response === true;
				    } catch (error) {
				        alert("중복 확인 중 오류가 발생했습니다. 다시 시도해주세요.");
				        console.error("Ajax Error: ", error);
				        return true; // 오류가 발생하면 기본적으로 중복된 것으로 간주
				    }
				}
				
				document.getElementById("phoneNumber").addEventListener("input", function (event) {
				    let value = event.target.value.replace(/[^0-9]/g, ""); // 숫자만 남김
				    if (value.length > 3 && value.length <= 7) {
				        value = value.slice(0, 3) + "-" + value.slice(3);
				    } else if (value.length > 7) {
				        value = value.slice(0, 3) + "-" + value.slice(3, 7) + "-" + value.slice(7);
				    }
				    event.target.value = value;
				});
	</script>
</body>
</html>