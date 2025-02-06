<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>기안문 작성</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .header h1 {
            margin: 0;
        }
        .buttons button {
            margin-left: 10px;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-gray {
            background-color: #6c757d;
            color: white;
        }
        table {
            width: 100%;
            margin-bottom: 20px;
        }
        table th, table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        textarea {
            width: 100%;
            height: 150px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .file-upload {
        border: 2px dashed #ccc;
        padding: 20px;
        text-align: center;
        cursor: pointer;
    	}

	    .file-upload:hover {
	        border-color: blue;
	    }
	
	    .file-item {
	        margin-top: 5px;
	        display: flex;
	        align-items: center;
	    }
	
	    .file-item button {
	        background-color: red;
	        color: white;
	        border: none;
	        padding: 5px;
	        cursor: pointer;
	    }
	
	    .file-item button:hover {
	        background-color: darkred;
	    }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>기안문 작성</h1>
        <div class="buttons">
            <button type="button" class="btn-primary" onclick="window.open('<c:url value='/admin/approver/search' />', '결재라인지정', 'width=800,height=600,scrollbars=yes');">
			    결재라인 지정
			</button>
            <button class="btn-primary" onclick="submitDraft()">결재요청</button>
            <button class="btn-gray" onclick="window.close()">닫기</button>
        </div>
    </div>

    <form id="draftForm" action="<c:url value='/admin/draft/save' />" method="post" enctype="multipart/form-data">    
    	<!-- Hidden으로 SchedulePK 포함 -->
    	<input type="hidden" name="schedulePk" value="${schedulePk}" />
    	<input type="hidden" name="date" value="${currentDate}" />
    	<input type="hidden" name="memberPk" value="${member.memberPk}">
        <table>
            <tr>
                <th>성명</th>
                <td>${member.name}</td>
                <th>기안일자</th>
                <td>${currentDate}</td>
            </tr>
            <tr>
                <th>부서</th>
                <td>${member.departmentName}</td>
                <th>직급</th>
                <td>${member.rankName}</td>
            </tr>
            <tr>
                <th>제목</th>
                <td colspan="3"><input type="text" name="title" style="width: 100%;" maxlength="100" required /></td>
            </tr>
        </table>

		<h3>결재자 목록</h3>
        <div id="approvers" style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
            <!-- 선택된 결재자 목록 표시 -->
        </div>
        
        <h3>내용</h3>
        <textarea name="content" maxlength="500" required></textarea>

        <h3>첨부파일</h3>
    <div id="dropZone" class="file-upload" onclick="document.getElementById('fileInput').click()">
        이곳에 파일을 드래그 앤 드롭하거나, 클릭하여 업로드하세요. (50MB 이하)
        <input type="file" id="fileInput" name="files" multiple style="display: none;" />
    </div>
    <div id="fileList" style="margin-top: 10px;">
        <!-- 첨부된 파일 목록 -->
    </div>
    </form>
</div>

<script>

	//선택한 결재자 목록 가져오기
	function setApprovers(approvers) {
    const approverContainer = document.getElementById("approvers");
    approverContainer.innerHTML = ""; // 기존 목록 초기화

    approvers.forEach((approver, index) => {
    	
        const [memberPk, memberName, department, rank] = approver.split(",");
        const order = index + 1; // 순서를 부모 창에서 부여
		
     	// 화면에 표시할 결재자 정보
        const div = document.createElement("div");
        div.textContent = `순서: \${order}, \${department} / \${rank} / \${memberName}`;
        approverContainer.appendChild(div);

     	// **여기가 가장 중요** : name="approvers" 로 반복!
        // 서버에서는 이 파라미터들을 List<String> 으로 받게 됨
        const inputPk = document.createElement("input");
        inputPk.type = "hidden";
        inputPk.name = "approvers"; // <-- "approvers"만 반복해서 전송
        inputPk.value = memberPk;   // 예) "3" 같은 숫자 문자열
        approverContainer.appendChild(inputPk);

        // (lineOrder를 서버단에서 i+1 로 쓸 거라면, 굳이 넘기지 않아도 됨)
        // 만약 클라이언트 쪽에서 라인 순서를 직접 지정하고 싶다면
        // “approvers”에 "memberPk:lineOrder" 형태로 담아 보내거나,
        // 별도의 @RequestParam("lineOrders") List<Integer> 로 보내도 됩니다.
    	});
	}
	
	const dropZone = document.getElementById("dropZone");
    const fileInput = document.getElementById("fileInput");
    const fileList = document.getElementById("fileList");
    let filesArray = [];

    // 드래그 앤 드롭 이벤트 핸들러
    dropZone.addEventListener("dragover", (event) => {
        event.preventDefault();
        dropZone.style.borderColor = "blue";
    });

    dropZone.addEventListener("dragleave", () => {
        dropZone.style.borderColor = "#ccc";
    });

    dropZone.addEventListener("drop", (event) => {
        event.preventDefault();
        dropZone.style.borderColor = "#ccc";
        handleFiles(event.dataTransfer.files);
    });

    // 파일 선택 이벤트 핸들러
    fileInput.addEventListener("change", (event) => {
        handleFiles(event.target.files);
    });

    // 파일 처리 함수
    function handleFiles(selectedFiles) {
        for (const file of selectedFiles) {
            if (filesArray.some((f) => f.name === file.name)) {
                alert("이미 추가된 파일입니다: " + file.name);
                continue;
            }
            if (file.size > 50 * 1024 * 1024) { // 50MB 제한
                alert("파일 크기가 초과되었습니다: " + file.name);
                continue;
            }

            filesArray.push(file);
            const div = document.createElement("div");
            div.className = "file-item";
            div.textContent = `\${file.name} (\${(file.size / 1024 / 1024).toFixed(2)} MB)`;

            const removeButton = document.createElement("button");
            removeButton.textContent = "삭제";
            removeButton.style.marginLeft = "10px";
            removeButton.onclick = () => {
                filesArray = filesArray.filter((f) => f.name !== file.name);
                fileList.removeChild(div);
            };

            div.appendChild(removeButton);
            fileList.appendChild(div);
        }

        // 입력창 초기화 (같은 파일 재선택 가능하게)
        fileInput.value = "";
    }

    
    function submitDraft() {
        const form = document.getElementById("draftForm");

        // 제목 유효성 검사
        const title = form.querySelector("input[name='title']").value.trim();
        if (title === "") {
            alert("제목을 입력해주세요.");
            return;
        }

        // 결재라인 유효성 검사
        const approverInputs = form.querySelectorAll("input[name='approvers']");
        if (approverInputs.length === 0) {
            alert("결재자를 추가해주세요.");
            return;
        }

        // 내용 유효성 검사
        const content = form.querySelector("textarea[name='content']").value.trim();
        if (content === "") {
            alert("내용을 입력해주세요.");
            return;
        }

        // FormData 생성
        const formData = new FormData(form);

        // filesArray에 저장된 파일들을 FormData에 추가
        filesArray.forEach((file) => {
            formData.append("files", file);
        });

        // contextPath 가져오기
        const contextPath = '<c:url value="/" />';

        // Ajax 요청
        fetch('<c:url value="/admin/draft/save" />', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (response.ok) {
                return response.json(); // 성공 시 JSON 응답 처리
            } else {
                throw new Error('결재 요청 중 오류가 발생했습니다.');
            }
        })
        .then(data => {
            if (data.success) {
                alert('결재 요청이 성공적으로 완료되었습니다.');
                const schedulePk = document.querySelector("input[name='schedulePk']").value;

                // 부모창에서 리다이렉트
                window.opener.location.href = `\${contextPath}admin/scheduleDetail?schedulePk=\${schedulePk}`;
                window.close(); // 팝업 닫기
            } else {
                alert('결재 요청 처리 중 문제가 발생했습니다.');
            }
        })
        .catch(error => {
            console.error(error);
            alert('결재 요청에 실패했습니다. 다시 시도해주세요.');
        });
    }

</script>
</body>
</html>
