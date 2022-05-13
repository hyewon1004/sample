<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Modify</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>

<div class="row">
	<div class="col-log-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Modify Page</div>

			<div class="panel-body">
				<form role="form" action="/board/modify" method="post">
				<input type="hidden" name=${_csrf.parameterName }"
				value=${_csrf.token }"/>
					<input type="hidden" name="pageNum"
						value='<c:out value="${cri.pageNum }"/>'> <input
						type="hidden" name="amount"
						value='<c:out value="${cri.amount }"/>'> <input
						type="hidden" name="keyword"
						value='<c:out value="${cri.keyword }"/>'> <input
						type="hidden" name="type" value='<c:out value="${cri.type }"/>'>
					<div class="form-group">
						<label>Bno</label><input class="form-control" name="bno"
							value='<c:out value="${board.bno }"/>' readonly>
					</div>
					<div class="form-group">
						<label>Title</label><input class="form-control" name="title"
							value='<c:out value="${board.title }"/>'>
					</div>
					<div class="form-group">
						<label>Text Area</label>
						<textarea class="form-control" rows="3" name="content"><c:out
								value="${board.content }" />
               </textarea>
					</div>
					<div class="form-group">
						<label>Writer</label><input class="form-control" name="writer"
							value='<c:out value="${board.writer }"/>' readonly>
					</div>

					<div class="form-group">
						<label>RegDate</label><input class="form-control" name="regdate"
							value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate }"/>'
							readonly>
					</div>
					<div class="form-group">
						<label>RegDate</label><input class="form-control"
							name="updateDate"
							value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate }"/>'
							readonly>
					</div>
					<sec:authentication property="principal" var="principal"/>
				<sec:authorize access="isAuthenticated()">
				<c:if test="${principal.username eq board.writer }">
					<button data-oper="modify" type="submit" class="btn btn-default">Modify</button>
					<button data-oper="delete" type="submit" class="btn btn-danger">Delete</button>
					</c:if>
				</sec:authorize>
					<button data-oper="list" type="submit" class="btn btn-info">List</button>


				</form>
			</div>
		</div>

	</div>
	<script type="text/javascript">
		$(document).ready(
				function() {
					// 어떤 submit 인지 확인후 종류에 맞는 요청을 보낸다

					let formObj = $("form"); // form 태그 가져오기

					// 버튼에 클릭 이벤트 추가하기 
					$("button").on(
							"click",
							function(e) {
								// e = 이벤트 객체 추가
								// 이 객체에 존재하던 기본 이벤트를 제거 (submit)
								e.preventDefault();

								// 이 버튼이 어떤일을 할지 알아본다.
								// 이 버튼의 data-oper 속성을 가져온다.
								var operation = $(this).data("oper");

								// 이 operation 이 modify,delete,list 구별
								// delete ==> action="/board/delete" method="post"
								// modify ==> action="/board/modify" method="post"
								// list ==> action="/board/list" method="get"
								if (operation == "modify") {
									// attr() => 태그의 속성을 변경할수있다
									// formObj.attr("action", "/board/modify")
								} else if (operation == "delete") {
									formObj.attr("action", "/board/remove")
								} else if (operation == "list") {
									// 그저 화면이동만 시킨다.
									//self.location="/board/list";
									//form을 통해서 가도록 만들기
									formObj.attr("action", "/board/list").attr(
											"method", "get");
									//input에 저장해놓은 pageNum 값을 복제
									var pageNumTag = $("input[name='pageNum']")
											.clone();
									//input에 저장해놓은 amount 값을 복제
									var amountTag = $("input[name='amount']")
											.clone();
									var typeTag=$("input[name='type']").clone();
			                           var keywordTag=$("input[name='keyword']").clone();
									formObj.empty(); //form 요소 내용 지우기(input 내용 지우기)
									//모두 지운 상태에서 page 정보를 가진 input tag만 추가
									formObj.append(pageNumTag).append(amountTag).append(typeTag).append(keywordTag);
								}
								// 전송
								formObj.submit();

							})
				})
	</script>

	<%@ include file="../includes/footer.jsp"%>