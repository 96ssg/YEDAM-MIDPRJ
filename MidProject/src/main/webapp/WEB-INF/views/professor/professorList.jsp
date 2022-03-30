<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="container-md">
	<div class="fs-2 px-3 my-3" align="center">교수리스트</div>
	<form id="frm" method="post">
	<table class="table table-bordered">
				
		<thead>
		    <tr align="center">
		      <th scope="col">교번</th>
		      <th scope="col">교수 이름</th>
		      <th scope="col">생년월일</th>
		      <th scope="col">휴대전화</th>
		    </tr>
		</thead>
	<c:forEach items="${professors }" var="professor">
		<tbody>
		<c:if test="${role eq 'admin' }">
		<tr onClick="profcheck('${professor.profId }')" align="center">
		</c:if>
		
		<td>${professor.profId }</td> 
		
		<td>${professor.profName }</td> 
		
		<td>${professor.profBirth }</td>
		
		<td>${professor.profPhone}</td>
		
		<%--<td>${professor.profImg }</td>
		
		<td>${professor.deptId }</td> --%>
		
		</tr>

	</c:forEach>

	</tbody>
	</table><br>
	<div></div>
	<div></div><br>
	<div></div><br>
	<div></div><br>
	<div></div><br>
	<div></div><br>
	<div></div><br>
	<div></div><br>
	<div></div>
	<input type="hidden" id="professorId" name="professorId">
</form>
</div>
<script type="text/javascript">
function profcheck(n){
	console.log(n)
	frm.professorId.value=n;
	frm.action = "professorUpdateForm.do";
	frm.submit();
	
}


</script>

