<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>예약자 - 예약</title>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> <!-- 카카오 주소 API -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
    <style>
        /* 예약 화면 스타일 */
        .container { width: 80%; margin: 0 auto; }
        .header, .content { margin-bottom: 20px; }
        .form-row { display: flex; margin-bottom: 10px; }
        .form-row label { width: 150px; font-weight: bold; }
        .form-row input, .form-row select { flex: 1; padding: 5px; }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table th, .table td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        .btn { margin: 10px; padding: 10px 20px; background: orange; color: white; border: none; cursor: pointer; }
        .btn:hover { background: darkorange; }
    </style>
</head>
<body>
<div class="container">
    <h1>예약</h1>

    <!-- 예약 정보 -->
    <div class="header">
        <form action="<c:url value='/reservation/save' />" method="post">
            <input type="hidden" name="schedulePk" value="${schedule.schedulePk}" />
            <div class="form-row">
                <label>체험명</label>
                <input type="text" value="${schedule.programName}" readonly />
            </div>
            <div class="form-row">
                <label>날짜</label>
                <input type="text" value="${schedule.date}" readonly />
            </div>
            <div class="form-row">
                <label>시간</label>
                <input type="text" value="${schedule.time}" readonly />
            </div>
            <div class="form-row">
                <label>대표 예약자</label>
                <input type="text" name="memberName" value="${member.name}" readonly />
            </div>
            <div class="form-row">
                <label>전화번호</label>
                <input type="text" name="phoneNumber" value="${member.phoneNumber}" readonly />
            </div>
            <div class="form-row">
                <label>예약 구분</label>
                <select name="reservationType">
                    <option value="P">개인</option>
                    <option value="G">단체</option>
                </select>
            </div>

            <!-- 체험 인원 정보 -->
            <h2>체험 인원 정보 (예약 가능 인원: <span id="availableCapacity">${availableCapacity}</span>명)</h2>
            <table class="table">
                <thead>
                <tr>
                    <th>이름</th>
                    <th>성별</th>
                    <th>구분</th>
                    <th>거주지</th>
                    <th>상세주소</th>
                    <th>장애 여부</th>
                    <th>외국인 여부</th>
                    <th>삭제</th>
                </tr>
                </thead>
                <tbody id="participant-list">
                <!-- JavaScript로 인원 추가 -->
                </tbody>
            </table>
            <button type="button" class="btn" id="add-participant">인원 추가하기</button>

			<!-- 엑셀 다운 업로드 버튼 영역 -->
			<div>
				<button type="button" class="btn" onclick="downloadExcelTemplate()">엑셀 양식 다운로드</button>
				<button type="button" id="upload-excel-button" class="btn">엑셀 업로드</button>
	    		<input type="file" id="excel-upload" accept=".xlsx" style="display: none;" />
			</div>

            <!-- 저장 버튼 -->
			<div class="form-row">
			    <button type="submit" class="btn" id="submitReservation">저장</button>
			</div>
        </form>
        <form method="get" action="<c:url value='/' />">
		    <input type="hidden" name="programPk" value="${programPk}" />
		    <input type="hidden" name="date" value="${date}" />
		    <button type="submit" class="btn btn-back">돌아가기</button>
		</form>
    </div>
</div>
<script>
	//공통: 한 줄 생성하는 함수
	function createParticipantRow(index) {
	    return `
	        <tr>
	            <td><input type="text" name="participants[\${index}].name" maxlength="20" required/></td>
	            <td>
	                <select name="participants[\${index}].gender">
	                    <option value="남자">남자</option>
	                    <option value="여자">여자</option>
	                </select>
	            </td>
	            <td>
	                <select name="participants[\${index}].targetType">
	                    <option value="K">미취학</option>
	                    <option value="E">초등</option>
	                </select>
	            </td>
	            <td>
	                <input type="text" id="residence-\${index}" name="participants[\${index}].residence" placeholder="주소를 검색하세요" maxlength="50" required/>
	                <button type="button" onclick="searchAddress(\${index})">주소 검색</button>
	            </td>
	            <td><input type="text" id="detailedAddress-\${index}" name="participants[\${index}].detailedAddress" placeholder="상세 주소를 입력하세요" maxlength="50"/></td>
	            <td>
	                <input type="checkbox" id="disabled-\${index}" />
	                <input type="hidden" name="participants[\${index}].isDisabled" value="false" />
	            </td>
	            <td>
	                <input type="checkbox" id="foreigner-\${index}" />
	                <input type="hidden" name="participants[\${index}].isForeigner" value="false" />
	            </td>
	            <td><button type="button" onclick="removeParticipant(this)">삭제</button></td>
	        </tr>
	    `;
	}

	// 첫 번째 줄 생성 함수
	function initializeParticipantRow() {
	    const tbody = document.getElementById('participant-list');
	    const row = createParticipantRow(0); // 첫 번째 줄은 index=0
	    tbody.insertAdjacentHTML('beforeend', row);
	
	    // 체크박스 상태 동기화 추가
	    document.getElementById(`disabled-0`).addEventListener('change', function () {
	        this.nextElementSibling.value = this.checked ? 'true' : 'false';
	    });
	    document.getElementById(`foreigner-0`).addEventListener('change', function () {
	        this.nextElementSibling.value = this.checked ? 'true' : 'false';
	    });
	}
	
	// 체험 인원 추가 함수
	document.getElementById('add-participant').addEventListener('click', function () {
	    const tbody = document.getElementById('participant-list');
	    const index = tbody.rows.length; // 현재 테이블에 있는 행의 수
	    const row = createParticipantRow(index);
	    tbody.insertAdjacentHTML('beforeend', row);
	
	    // 체크박스 상태 동기화 추가
	    document.getElementById(`disabled-\${index}`).addEventListener('change', function () {
	        this.nextElementSibling.value = this.checked ? 'true' : 'false';
	    });
	    document.getElementById(`foreigner-\${index}`).addEventListener('change', function () {
	        this.nextElementSibling.value = this.checked ? 'true' : 'false';
	    });
	});
	
	// 첫 번째 줄 초기화
	document.addEventListener('DOMContentLoaded', function () {
	    initializeParticipantRow();
	});
	
	// 체험 인원 삭제 및 인덱스 재정렬 함수
	function removeParticipant(button) {
	    const row = button.closest('tr'); // 삭제할 행
	    row.remove(); // 행 삭제 후 재정렬 실행
	    reIndexParticipants(); // 🔹 인덱스 재정렬 함수 호출
	}

	// 인덱스 재정렬 함수
	function reIndexParticipants() {
	    const tbody = document.getElementById('participant-list');
	    const rows = tbody.children;

	    for (let i = 0; i < rows.length; i++) {
	        // 각 행의 input name 속성을 변경하여 index 유지
	        rows[i].querySelectorAll('input, select, button').forEach(element => {
	            let nameAttr = element.getAttribute('name');
	            let idAttr = element.getAttribute('id');
	            let onclickAttr = element.getAttribute('onclick');

	            // name 속성 업데이트
	            if (nameAttr) {
	                element.setAttribute('name', nameAttr.replace(/\[\d+\]/, `[\${i}]`));
	            }

	            // id 속성 업데이트
	            if (idAttr) {
	                if (idAttr.includes("residence-")) {
	                    element.setAttribute("id", `residence-\${i}`);
	                } else if (idAttr.includes("detailedAddress-")) {
	                    element.setAttribute("id", `detailedAddress-\${i}`);
	                } else if (idAttr.includes("disabled-")) {
	                    element.setAttribute("id", `disabled-\${i}`);
	                } else if (idAttr.includes("foreigner-")) {
	                    element.setAttribute("id", `foreigner-\${i}`);
	                }
	            }

	            // onclick 속성 업데이트 (주소 검색 버튼)
	            if (onclickAttr && onclickAttr.includes("searchAddress(")) {
	                element.setAttribute("onclick", `searchAddress(\${i})`);
	            }
	        });

	        // 체크박스 hidden 값 name 속성도 업데이트
	        const disabledCheckbox = rows[i].querySelector(`#disabled-\${i}`);
	        if (disabledCheckbox) {
	            disabledCheckbox.nextElementSibling.setAttribute("name", `participants[\${i}].isDisabled`);
	        }

	        const foreignerCheckbox = rows[i].querySelector(`#foreigner-\${i}`);
	        if (foreignerCheckbox) {
	            foreignerCheckbox.nextElementSibling.setAttribute("name", `participants[\${i}].isForeigner`);
	        }
	    }
	}

	
	// 카카오 주소 검색 API 호출
    function searchAddress(index) {
        new daum.Postcode({
            oncomplete: function (data) {
                // 도로명 주소를 residence 필드에 입력
                document.getElementById(`residence-\${index}`).value = data.roadAddress;
                // 상세 주소로 포커스 이동
                document.getElementById(`detailedAddress-\${index}`).focus();
            }
        }).open();
    }
	
	//엑셀양식다운
    async function downloadExcelTemplate() {
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('체험인원 양식');

    // 헤더 추가
    worksheet.columns = [
        { header: '이름', key: 'name', width: 15 },
        { header: '성별', key: 'gender', width: 10 },
        { header: '구분', key: 'targetType', width: 10 },
        { header: '거주지', key: 'residence', width: 30 },
        { header: '상세주소', key: 'detailedAddress', width: 30 },
        { header: '장애 여부', key: 'isDisabled', width: 10 },
        { header: '외국인 여부', key: 'isForeigner', width: 10 }
    ];

    // 데이터 유효성 검사 설정
    const rowsToGenerate = 20; // 드롭다운을 추가할 행 수
    for (let i = 2; i <= rowsToGenerate + 1; i++) {
        // 성별 드롭다운 (남자/여자)
        worksheet.getCell(`B\${i}`).dataValidation = {
            type: 'list',
            allowBlank: true,
            formulae: ['"남자,여자"'],
            showErrorMessage: true,
            errorTitle: '잘못된 입력',
            error: '성별은 남자 또는 여자로 입력하세요.'
        };

        // 구분 드롭다운 (미취학/초등)
        worksheet.getCell(`C\${i}`).dataValidation = {
            type: 'list',
            allowBlank: true,
            formulae: ['"미취학,초등"'],
            showErrorMessage: true,
            errorTitle: '잘못된 입력',
            error: '구분은 미취학 또는 초등으로 입력하세요.'
        };

        // 장애 여부
        worksheet.getCell(`F\${i}`).dataValidation = {
            type: 'list',
            allowBlank: true,
            formulae: ['"예,아니요"'],
            showErrorMessage: true,
            errorTitle: '잘못된 입력',
            error: '장애 여부는 예 또는 아니요로 입력하세요.'
        };

        // 외국인 여부
        worksheet.getCell(`G\${i}`).dataValidation = {
            type: 'list',
            allowBlank: true,
            formulae: ['"예,아니요"'],
            showErrorMessage: true,
            errorTitle: '잘못된 입력',
            error: '외국인 여부는 예 또는 아니요로 입력하세요.'
        };
    }

    // 파일 다운로드
    const buffer = await workbook.xlsx.writeBuffer();
    const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = '체험인원_양식.xlsx';
    link.click();
	}

	// 엑셀 업로드 버튼 누르기
    document.getElementById('upload-excel-button').addEventListener('click', function () {
        const fileInput = document.getElementById('excel-upload');
        fileInput.click(); // 숨겨진 파일 입력 창 열기
    });
	
 	// 엑셀 파일 업로드 처리
    document.getElementById('excel-upload').addEventListener('change', async function (event) {
        const file = event.target.files[0];
        if (!file) {
            alert('엑셀 파일을 선택해주세요.');
            return;
        }

        const reader = new FileReader();
        reader.onload = async function (e) {
            const data = new Uint8Array(e.target.result);
            const workbook = new ExcelJS.Workbook();
            await workbook.xlsx.load(data);

            const worksheet = workbook.getWorksheet('체험인원 양식');
            const rows = worksheet.getRows(2, worksheet.rowCount - 1); // 헤더 이후의 데이터 가져오기

            const tbody = document.getElementById('participant-list');
            let currentIndex = tbody.rows.length; // 현재 테이블의 행 개수로 index 시작
            
            rows.forEach((row) => {
                if (!row.getCell(1).value) return; // 이름이 비어있으면 건너뛰기

                const newRow = `
                    <tr>
                        <td><input type="text" name="participants[\${currentIndex}].name" value="\${row.getCell(1).value}" /></td>
                        <td>
                            <select name="participants[\${currentIndex}].gender">
                                <option value="남자" \${row.getCell(2).value === '남자' ? 'selected' : ''}>남자</option>
                                <option value="여자" \${row.getCell(2).value === '여자' ? 'selected' : ''}>여자</option>
                            </select>
                        </td>
                        <td>
                            <select name="participants[\${currentIndex}].targetType">
                                <option value="K" \${row.getCell(3).value === '미취학' ? 'selected' : ''}>미취학</option>
                                <option value="E" \${row.getCell(3).value === '초등' ? 'selected' : ''}>초등</option>
                            </select>
                        </td>
                        <td>
                        	<input type="text" name="participants[\${currentIndex}].residence" value="\${row.getCell(4).value || ''}" />
                       		<button type="button" onclick="searchAddress(\${currentIndex})">주소 검색</button>
                       	</td>
                        <td><input type="text" name="participants[\${currentIndex}].detailedAddress" value="\${row.getCell(5).value || ''}" /></td>
                        <td>
                            <input type="checkbox" id="disabled-\${currentIndex}" \${row.getCell(6).value === '예' ? 'checked' : ''} />
                            <input type="hidden" name="participants[\${currentIndex}].isDisabled" value="\${row.getCell(6).value === '예'}" />
                        </td>
                        <td>
                            <input type="checkbox" id="foreigner-\${currentIndex}" \${row.getCell(7).value === '예' ? 'checked' : ''} />
                            <input type="hidden" name="participants[\${currentIndex}].isForeigner" value="\${row.getCell(7).value === '예'}" />
                        </td>
                        <td><button type="button" onclick="removeParticipant(this)">삭제</button></td>
                    </tr>`;
                tbody.insertAdjacentHTML('beforeend', newRow);
                currentIndex++; // 다음 행에 사용할 index 증가
            });
        };
        reader.readAsArrayBuffer(file);
    });

    document.getElementById("submitReservation").addEventListener("click", function (event) {
        const tbody = document.getElementById("participant-list");
        const participantCount = tbody.rows.length; // 현재 추가된 체험 인원 수
        const availableCapacity = parseInt(document.getElementById("availableCapacity").textContent); // 예약 가능 인원

        // 예약 가능 인원 초과 확인
        if (participantCount > availableCapacity) {
            alert("예약 가능 인원을 초과했습니다!");
            event.preventDefault(); // POST 요청 차단
        }
    });
	
</script>
</body>
</html>
