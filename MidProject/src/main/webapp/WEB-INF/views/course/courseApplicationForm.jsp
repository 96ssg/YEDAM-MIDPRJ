<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>course application</title>
</head>
<body>
	<h1>수강신청</h1>
	
	<!-- 강의 검색 -->
	<div>
		<div>
			학번 :  <input type="text" value="${user.studentId }" disabled>
		</div>
		<div>
			최대이수학점 : <input type="text" value="${user.studentScore }" disabled>
		</div>
		<div>
			과목코드 : <input type="text" name="lectureId" id="lectureId" required>
		</div>
		<div>
			<input type="button" value="신청" id="applyBtn">
		</div>
	</div>
	
	<!-- 검색한 강의 정보 출력 -->
	<div>
		<h2>강의 검색</h2>
		<div>
			과목코드 : <input type="text" name="lectureId" id="searchLectureId" required>
		</div>
		<div>
			<input type="button" value="검색" id="searchLectureBtn">
		</div>
		<table class="table">
			<thead>
				<tr>
					<th>강의번호</th>
					<th>강의명</th>
					<th>학점</th>
					<th>교수명</th>
					<th>강의실</th>
					<th>신청인원</th>
					<th>수강정원</th>
				</tr>
			</thead>
			<tbody id="searchResult"></tbody>
		</table>
	</div>
	
	<!-- 내 수강 신청 현황 -->
	<div>
		<h2>수강신청 강의 목록</h2>
		<table class="table">
			<thead>
				<tr>
					<th>강의번호</th>
					<th>강의명</th>
					<th>학점</th>
					<th>교수명</th>
					<th>강의실</th>
					<th>수강정원</th>
					<th>신청취소</th>
				</tr>
			</thead>
			<tbody id="applicationInfo"></tbody>
		</table>
	</div>
	
	<script>
		// 최초 페이지 로드 시 현재 수강신청 목록 출력
		window.onload = semesterCourseList;
		
		
		// 수강신청
		function applyCourse() {
			const maxCredit = ${user.studentScore}
			
			fetch('ajaxCourseInsert.do?', {
				method: 'post',
				headers: {'Content-Type': 'application/x-www-form-urlencoded'},
				body: 'lectureId=' + document.getElementById('lectureId').value
			})
			.then(response => response.text())
			.then(result => {
				if (result == 'capacity') {
					alert('수강정원이 초과되었습니다.')
					return;
				}
				if (result == 'credit') {
					alert('최대이수학점을 초과해서 신청할 수 없습니다.')
					return;
				}
				
				// 수강신청 후 목록 재호출
				semesterCourseList();
			})
		}
		
		applyBtn.addEventListener('click', () => applyCourse());
		
		
		// 수강신청 목록 출력
		function semesterCourseList() {
			
			// 기존 수강신청 목록 삭제
			applicationInfo.innerHTML = '';
			
			fetch('ajaxSemesterCourseList.do')
			.then(response => response.text())
			.then(result => {
				
				// 신청한 강의가 없을 경우
				if (result === 'noResult') {
					
					const td = document.createElement('td');
					td.setAttribute('colspan', '7');
					td.setAttribute('align', 'center');
					td.innerText = '신청한 강의가 없습니다.';
					
					applicationInfo.append(td);
					return;
				}
				
				// 수강신청 강의 목록, 교수명
				const lectureList = JSON.parse(result.split('~')[0]);
				const professorName = JSON.parse(result.split('~')[1]);
				
				// 결과 출력
				for (let i=0; i<lectureList.length; i++) {
					const tr = document.createElement('tr');
					
					const lectureId = document.createElement('td');
					lectureId.innerText = lectureList[i].lectureId;
					
					const lectureName = document.createElement('td');
					lectureName.innerText = lectureList[i].lectureName;
					
					const lectureCredit = document.createElement('td');
					lectureCredit.innerText = lectureList[i].lectureCredit;
					
					const profName = document.createElement('td');
					profName.innerText = professorName[i];
					
					const lectureRoom = document.createElement('td');
					lectureRoom.innerText = lectureList[i].lectureRoom;
					
					const lectureCapacity = document.createElement('td');
					lectureCapacity.innerText = lectureList[i].lectureCapacity;
					
					const cancel = document.createElement('td');
					const cancelBtn = document.createElement('input');
					cancelBtn.setAttribute('type', 'button');
					cancelBtn.setAttribute('id', 'cancelBtn');
					cancelBtn.setAttribute('value', '취소하기');
					cancelBtn.addEventListener('click', () => cancelCourse(lectureList[i].lectureId));
					cancel.append(cancelBtn);
					
					tr.append(lectureId);
					tr.append(lectureName);
					tr.append(lectureCredit);
					tr.append(profName);
					tr.append(lectureRoom);
					tr.append(lectureCapacity);
					tr.append(cancel);
					
					applicationInfo.append(tr);
				}
				
			})
		}
		
		
		// 수강신청 취소
		function cancelCourse(lectureId) {
			const isCancel = confirm('강의를 수강취소 하시겠습니까?');
			if (isCancel == false) return;
			
			fetch('ajaxCourseDelete.do?', {
				method: 'post',
				headers: {'Content-Type': 'application/x-www-form-urlencoded'},
				body: 'lectureId=' + lectureId
			})
			.then(response => response.text())
			.then(result => {
				if (result != 'deleted') {
					alert('수강신청 취소 중 오류가 발생했습니다.')
					return;
				}
				
				// 취소 후 수강신청 목록 재호출
				semesterCourseList();
			})
		}
		
		
		// 강의 검색
		function searchLecture() {
			fetch('ajaxApplicationSearch.do?', {
				method: 'post',
				headers: {'Content-Type': 'application/x-www-form-urlencoded'},
				body: 'val=' + document.getElementById('searchLectureId').value
			})
			.then(response => response.text())
			.then(result => {
				// 기존 검색결과 삭제
				searchResult.innerHTML = '';
				
				// 검색결과가 없을 경우
				if (result === 'noResult') {
					const td = document.createElement('td');
					td.setAttribute('colspan', '7');
					td.setAttribute('align', 'center');
					td.innerText = '검색결과가 없습니다.';
					
					searchResult.append(td);
					return;
				}

				// 검색 결과 출력
				// 강의정보, 교수명, 현재 수강신청 인원 결과
				const lecture = JSON.parse(result.split('~')[0]);
				const professorName = result.split('~')[1];
				const currentApplications = result.split('~')[2];
				
				const tr = document.createElement('tr');
				
				const lectureId = document.createElement('td');
				lectureId.innerText = lecture.lectureId;
				
				const lectureName = document.createElement('td');
				lectureName.innerText = lecture.lectureName;
				
				const lectureCredit = document.createElement('td');
				lectureCredit.innerText = lecture.lectureCredit;
				
				const profName = document.createElement('td');
				profName.innerText = professorName;
				
				const lectureRoom = document.createElement('td');
				lectureRoom.innerText = lecture.lectureRoom;
				
				const currentNum = document.createElement('td');
				currentNum.innerText = currentApplications;
				
				const lectureCapacity = document.createElement('td');
				lectureCapacity.innerText = lecture.lectureCapacity;
				
				tr.append(lectureId);
				tr.append(lectureName);
				tr.append(lectureCredit);
				tr.append(profName);
				tr.append(lectureRoom);
				tr.append(currentNum);
				tr.append(lectureCapacity);
				
				searchResult.append(tr);
			})
		}
		
		searchLectureBtn.addEventListener('click', () => searchLecture())
		
	</script>
</body>
</html>