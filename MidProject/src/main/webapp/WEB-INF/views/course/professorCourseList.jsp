<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>courseList.do</title>
</head>
<body>
	<h1>수강정보 목록</h1>
	<c:if test="${role eq student }">
		<table class="table">
			<tr>
				<td>수강연도</td>
				<td>수강학기</td>
				<td>강의명</td>
				<td>중간고사 성적</td>
				<td>기말고사 성적</td>
				<td>평점</td>
			</tr>
			<c:forEach var="course" items="${courseList }">
				<tr class="course">
					<td>${course.lectureId }</td>
					<td>${course.studentId }</td>
					<td>${course.courseYear }</td>
					<td>${course.courseSemester }</td>
					<td>${course.courseMid}</td>
					<td>${course.courseFinal }</td>
					<td>${course.courseScore }</td>
				</tr>
			</c:forEach>
		</table>
	</c:if>
	
	
	
	
	<script>
		const today = new Date();
		const thisSemester = today.getFullYear() + '-' + today.getMonth()+1   
		
		function getGrade(thisSemester) {
			fetch('ajaxTotalGrade.do?', {
				method: 'post',
				headers: {'Content-Type': 'application/x-www-form-urlencoded'},
				body: 'thisSemester=' + thisSemester
			})
			.then(response => response.json())
			.then(result => {
				
			})
		}
		
		const courses = document.querySelectorAll('.course');
		courses.forEach((element)=>{
			element.addEventListener('click', () => {
				const lectureId = element.children[0].innerText;
				const studentId = element.children[1].innerText;
				
				location.href="courseDetail.do?lectureId=" + lectureId + "&studentId=" + studentId;
			})
		})
	</script>
	
</body>
</html>