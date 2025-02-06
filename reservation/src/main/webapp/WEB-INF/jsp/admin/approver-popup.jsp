<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결재라인 선택</title>
    <style>
        .container {
            font-family: Arial, sans-serif;
            width: 80%;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2);
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .search-section {
            margin-bottom: 20px;
        }
        .form-row {
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }
        .form-row label {
            width: 80px;
            font-weight: bold;
        }
        .form-row input, .form-row select {
            flex: 1;
            padding: 5px;
            margin-right: 10px;
        }
        .btn-primary, .btn-red {
            padding: 8px 12px;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-primary {
            background-color: #007bff;
        }
        .btn-red {
            background-color: #ff4d4d;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        #approver-list {
            list-style: none;
            padding: 0;
        }
        #approver-list li {
            padding: 5px;
            border: 1px solid #ccc;
            margin-bottom: 5px;
            cursor: pointer;
        }
        #approver-list li:hover {
            background-color: #f8f9fa; /* 마우스 오버 시 회색 배경 */
        }
        .actions {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }
        
        #approver-list li.selected {
        background-color: #d1e7ff; /* 선택 시 밝은 파란색 배경 */
        border: 1px solid #0d6efd; /* 선택된 항목에 파란 테두리 */
        border-radius: 4px;
        padding: 5px;
        margin: 2px 0;
    	}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>결재라인 선택</h1>
        </div>
        <div class="search-section">
            <form method="get" class="search-form">
                <div class="form-row">
			        <label for="department">부서:</label>
			        <select id="department" name="department">
			            <option value="">전체</option>
			            <c:forEach var="department" items="${departments}">
			                <option value="${department.codeValue}">${department.codeName}</option>
			            </c:forEach>
			        </select>
			    </div>
			    <div class="form-row">
			        <label for="rank">직급:</label>
			        <select id="rank" name="rank">
			            <option value="">전체</option>
			            <c:forEach var="rank" items="${ranks}">
			                <option value="${rank.codeValue}">${rank.codeName}</option>
			            </c:forEach>
			        </select>
			    </div>
                <div class="form-row">
                    <label for="name">이름:</label>
                    <input type="text" id="name" name="name" placeholder="이름을 입력하세요" maxlength="20"/>
                </div>
                <button type="submit" class="btn-primary">검색</button>
            </form>
        </div>
        <div class="approver-list">
            <h2>결재자 목록</h2>
            <table>
                <thead>
                    <tr>
                        <th>부서</th>
                        <th>직급</th>
                        <th>이름</th>
                        <th>추가</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="member" items="${members}">
				        <tr>
				            <td>${member.departmentName}</td>
				            <td>${member.rankName}</td>
				            <td>${member.name}</td>
				            <td>
				                <button class="btn-primary" onclick="addApprover('${member.memberPk}', '${member.name}', '${member.departmentName}', '${member.rankName}')">추가</button>
				            </td>
				        </tr>
				    </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="selected-approvers">
            <h2>선택된 결재자</h2>
            <ul id="approver-list">
                <!-- 선택된 결재자 리스트가 추가됨 -->
            </ul>
            <div class="actions">
                <button class="btn-red" onclick="removeSelectedApprover()">삭제</button>
                <button class="btn-primary" onclick="confirmApprovers()">결재자 선택</button>
            </div>
        </div>
    </div>
    <script>
    function addApprover(id, name, department, rank) {
        const list = document.getElementById("approver-list");

        // 중복 확인: 이미 추가된 결재자인지 체크
        const existingApprover = Array.from(list.children).find(li => li.dataset.id === id);
        if (existingApprover) {
            alert("이미 결재라인에 있습니다.");  // 중복 추가 방지
            return;
        }

        // 새로운 결재자 추가
        const li = document.createElement("li");
        li.textContent = `\${department} / \${rank} / \${name}`;
        
        // 데이터 속성 추가
        li.dataset.id = id;
        li.dataset.name = name;
        li.dataset.department = department;
        li.dataset.rank = rank;
        
        // 클릭 시 선택 클래스 추가
        li.addEventListener("click", function () {
            const items = list.querySelectorAll("li");
            items.forEach((item) => item.classList.remove("selected")); // 다른 항목 선택 해제
            this.classList.add("selected"); // 현재 항목 선택
        });

        list.appendChild(li); // 목록에 추가
    }

		
        // 선택한 결재라인 삭제
        function removeSelectedApprover() {
            const list = document.getElementById("approver-list");
            const selected = list.querySelector("li.selected");
            if (selected) {
                list.removeChild(selected); // 선택된 항목 삭제
            } else {
                alert("삭제할 결재자를 선택해주세요."); // 선택되지 않았을 때 경고
            }
        }

        // 선택된 결재자 확정 후 부모 창으로 전송
        function confirmApprovers() {
            const approvers = [];
            const listItems = document.getElementById("approver-list").children;
            
            for (const item of listItems) {
                const approverData = [
                    item.dataset.id,
                    item.dataset.name,
                    item.dataset.department,
                    item.dataset.rank
                ].join(",");
                approvers.push(approverData);
            }
            // 부모 창으로 데이터 전송
            window.opener.setApprovers(approvers);
            window.close();
        }
    </script>
</body>
</html>

