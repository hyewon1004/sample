<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>
	<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<div class="panel-body">
				<div class="form-group">
					<label>Bno</label><input class="form-control" name="bno"
						value='<c:out value="${board.bno }"/>' readonly>
				</div>
				<div class="form-group">
					<label>Title</label><input class="form-control" name="title"
						value='<c:out value="${board.title }"/>' readonly>
				</div>
				<div class="form-group">
					<label>Text area</label>
					<textarea class="form-control" rows="3" name="content" readonly>
					<c:out value="${board.content }" /></textarea>
				</div>
				<div class="form-group">
					<label>Writer</label><input class="form-control" name="wirter"
						value='<c:out value="${board.writer }"/>' readonly>
				</div>
				<!-- 리스트 화면으로 되돌아가는 버튼 + 수정화면으로 가는 버튼  -->
				<sec:authentication property="principal" var="principal"/>
				<sec:authorize access="isAuthenticated()">
				<c:if test="${principal.username eq board.writer }">
				<button data-oper="modify" class="btn btn-default">Modify</button>
				</c:if>
				</sec:authorize>
				
				<!-- 속성 선택자 button[data-oper='modify'] -->
				<button data-oper="list" class="btn btn-info">List</button>
				<form id="operForm" action="/board/modify" method="get">
					<!-- 게시물 번호 bno 숨겨놓기 -->
					<input type="hidden" id="bno" name="bno"
						value='<c:out value="${board.bno}"/>'>
					<!-- 우리가 보고 있던 페이지 정보 숨겨놓기 -->
					<input type="hidden" name="pageNum"
						value='<c:out value="${cri.pageNum }"/>'> <input
						type="hidden" name="amount"
						value='<c:out value="${cri.amount }"/>'> <input
						type="hidden" name="keyword"
						value='<c:out value="${cri.keyword }"/>'> <input
						type="hidden" name="type" value='<c:out value="${cri.type }"/>'>
				</form>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panal-default">

			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>Reply
				<sec:authorize access="isAuthenticated()">
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New
					Reply</button>
					</sec:authorize>
			</div>
			<div class="panal-body">
				<!-- 댓글시작 -->
				<ul class="chat">

				</ul>
			</div>
			<div class="panal-footer">
			<!-- 여기에 페이지버튼이 들어올거다 -->
			
			</div>
		</div>
	</div>
</div>
<!-- 댓글등록용 새창 model -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labeledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dissmiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label> <input class="form-control" name="reply"
						value="New REPLY!">
				</div>
				<div class="form-group">
					<label>Replyer</label> <input class="form-control" name="replyer"
						value="replyer!">
				</div>
			</div>
			<!-- 버튼모음 -->
			<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
			<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
			<button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
			<button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
		</div>
	</div>
</div>




<script type="text/javascript" src="/resources/js/reply.js"></script>

<script type="text/javascript">
	var replyService = (function() {

		function add(reply, callback, error) {
			//reply : 댓글 객체
			//callback : 함수를 실행시키고 난 후에 결과를 받을 수 있는 함수 또는 그 다음에 실행할 함수
			console.log("add reply");

			$.ajax({
				type : 'post',
				url : '/replies/new',
				data : JSON.stringify(reply),
				contentType : "application/json; charset = utf-8",
				success : function(result, status, xhr) {
					// 성공했으면 실행할 함수
					if (callback) { //콜백함수가 있으면
						callback(result); //콜백함수 실행

					}
				},
				error : function(xhr, status, er) {
					//에러가 발생하면 실행할 함수
					if (error) { //에러를 처리하는 함수가 있으면
						error(er); //에러 함수 실행
					}
				}
			})
		}
		//댓글목록을 불러오는 함수
		function getList(param, callback, error) {
			var page = param.page || 1;
			//페이지정보가 5페이지=> 그대로 쓰고
			//만약 페이지 정보가 없으면 1로 세팅
			var bno = param.bno;
			//요청을 보낼 주소=/replies/pages/게시물번호/페이지번호
			$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
					function(data) {

						//요청처리 성공시 실행되는 함수

						//콜백함수가 잇으면 콜백함수를 실행
						if (callback) {
							//callback(data);
							//data자리에list가 온다
							callback(data.replyCnt, data.list);
						}

					}).fail(function(xhr, status, err) {
				//요청처리실패시 싫행되는 함수
				//에러처리 함수가 있으면 에러 함수를 실행
				if (error) {
					error();
				}

			});
		}//get리스트 함수끝

		//댓글지우기
		//댓글 지울떄 필요한 값: 댓글의 번호(rno)
		function remove(rno, replyer,  callback, error) {

			$.ajax({
				type : 'delete',
				url : '/replies/' + rno,
				data: JSON.stringify({rno : rno, replyer:replyer}),
				contentType: "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					//성공하면  callback호출
					if (callback) {
						callback(result);
					}
				},
				error : function(xhr, status, err) {
					//실패하면 error함수 호출
					if (error) {
						error(err);
					}
				}

			})

		}//remove 함수끝

		//댓글수정
		function update(reply, callback, error) {
			console.log("rno : " + reply.rno);

			$.ajax({
				type : 'put',
				url : '/replies/' + reply.rno,
				data : JSON.stringify(reply),
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result);
					}
				},
				error : function(xhr, status, err) {
					//실패하면 error함수 호출
					if (error) {
						error(err);
					}
				}

			})
		}//update끝

		//댓글하나 조회하는 함수
		//댓글하나 조회하려면 필요한거?rno 댓글번호
		function get(rno, callback, error) {
			$.get("/replies/" + rno + ".json", function(result) {
				if (callback) {
					callback(result);
				}

			}).fail(function(xhr, status, err) {
				if (error) {
					error();
				}
			});
		}//get함수끝

		//날짜 변환가능
		function displayTime(timeValue) {
			//오늘 작성한 댓글
			//어제 이전에 작성한 댓글
			//오늘 작성한 댓글은 시간으로 표시해주고
			//어제 이전에 작성한 댓글은 날짜로 표시해주기

			//오늘날짜
			var today = new Date();

			//오늘날짜와 댓글의 날짜가 얼마나 차이나는지
			var gap = today.getTime() - timeValue;
			//gap 값도 밀리초 단위로 저장
			//몇 밀리초가 하루일까요?
			//1000*60*60*24
			//밀리초*1분=60초 * 1시간=60분 *하루=24시간

			//댓글날짜
			var dateObj = new Date(timeValue);

			var str = "";

			//오늘 작성한 댓글이면 시간
			if (gap < (1000 * 60 * 60 * 24)) {
				//시간
				var hh = dateObj.getHours();
				//분
				var mi = dateObj.getMinutes();
				//초
				var ss = dateObj.getSeconds();

				//9시
				//09시
				//현재시간이 9보다 크면 앞에 아무것도 안붙여줄거고
				//9이하이면 0을 붙여준다
				//현재시간이 만약10시면 앞에다가 0을 붙여줄필요가없음
				str = [ (hh > 9 ? '' : '0') + hh, ':',
						(mi > 9 ? '' : '0') + mi, ':',
						(ss > 9 ? '' : '0') + ss, ':' ].join("");

				//배열안에 원소들이 이어붙여진다
				//시간
			} else {
				//여기는 24시간 이전에 작성한 댓글
				//날짜로 보여주기
				//년도
				var yy = dateObj.getFullYear();//4자리로 된 년도
				//월
				var mm = dateObj.getMonth() + 1;//컴퓨터는  달을 0부터 샌다
				//일
				var dd = dateObj.getDate();
				//여기도 똑같이 한자리로 된 숫자는 앞에 0 붙여주기
				str += yy + "/";
				str += (mm > 9 ? '' : '0') + mm + "/";
				str += (dd > 9 ? '' : '0') + dd + "/";
			}
			return str;
		}
		return {
			add : add,
			getList : getList,
			remove : remove,
			update : update,
			get : get,
			displayTime : displayTime

		};
		//replyservice() 함수를 부르고 나서 그 결과값에 객체가 들어오는데
		//그 안에 add를 가져오면 댓글 등록 기능 함수를 사용할 수 있다.
		//var service = replyservice();
		//service.add();
		//service.getList();
	})();
	/*console.log("===== JS TEST =====");
	
	var bnoValue= '<c:out value="${board.bno}"/>';
	
	//add(reply, callback, error)
	 /*replyService.add(
	{reply: "JS TEST", replyer : "tester", bno:bnoValue },
	function(result) {
		alert("RESULT : " + result);
	}
	);
	
	 */
	//getList 함수
	/*replyService.getList({bno:bnoValue,page:1} , function(list){
		//현재 게시글의 댓글목록을 콘솔에 출력
		for(let i =0;  i<list.length; i++){
			console.log(list[i]);
		}
	})*/

	//remove함수
	/* replyService.remove(1,function(count){
		console.log(count);
	if(count =="success"){
		alert("removed");
	}
	},
	function(err){
		alert("뭔가 잘못됨");
	}
	);*/

	//update
	/*replyService.update({
		rno : 3,
		bno : bnoValue,
		reply : "modified reply..."
	},
	
	function(result){
		alert("수정완료!");
	}
	);*/

	/*replyService.get(3, function(data){
		//data 에는 9번 댓글이 들어가 있음
		console.log(data);
	})*/

	$(document)
			.ready(
					function() {
						var bnoValue = '<c:out value="${board.bno}"/>';
						//우리가 li태그를 동적으로 추가한다는 말은
						//ul태그를 찾아서 그 태그의 자손으로 붙여주겟다
						//ul.html(ddddddd):ul태그의 안의 html코드를 수정
						var replyUL = $(".chat");
						showList(1);

						//동적으로 댓글을 만들어서 붙여주는 함수
						//요청이 성공했으면 그때 댓글을 만들어서 붙여주면 된다
						//요청이 성공했으면 그때 댓글을 만든다==>callback함수에서 처리하면 된다
						function showList(page) {

							//params: 페이지 정보랑 게시글 번호가 포함되어있음
							replyService
									.getList(
											{

												bno : bnoValue,
												page : page || 1
											},
											function(replyCnt, list) {
												//요청성공시 callback함수에 list를 받아온다
												console.log("replyCnt :" + replyCnt);
												console.log("list:" + list);
												
												//만약페이지 번호가 -1로 전달되면 마지막페이지로 가도록
												if(page == -1){
													//댓글개수가 7개일떄 페이지 몇개?(1페이지 10개라고하면 ) 페이지개수1
															
												pageNum = Math.ceil(replyCnt/10.0);
												 showList(pageNum);
												 return;
												}
												var comments = "";//여기에 html코드를 조립
												if (list == null
														|| list.length == 0) {
													//해당게시물에는 댓글이 없다
													//html코드를 조립할 필요가 없다
													replyUL.html("");
													return;//함수 바로 종료
												}
												//여기로 오면 댓글이 있다는 의미
												//for문을 이용해서 list안에 있는 댓글 목록을
												//<li>태그로 만들어서 조립해주면 된다
												for (let i = 0; i < list.length; i++) {
													comments += "<li class='left clesrfix' data-rno='" + list[i].rno + "'>";
													comments += "<div>";
													comments += "<div>";
													comments += "<div class='header'>";
													comments += "<strong class='primary-font'>"
															+ list[i].replyer
															+ "</strong>";
													comments += "<small class='pull-right text-muted'>";
													comments += replyService
															.displayTime(list[i].replyDate);
													comments += "</small>";
													comments += "</div>";
													comments += "<p>"
															+ list[i].reply
															+ "</p>";
													comments += "</div>";
													comments += "</li>";
												}
												replyUL.html(comments);
												
												//댓글페이지 보여주기
												showReplyPage(replyCnt);

											})
						}//end showList

						//아까우리가 추가한 div요소를 먼저 가져와 놓기
						//여기 안에다가 html코드 조립해서 페이지 버튼 만들겠따
						var pageNum = 1;
						var replyPageFooter = $(".panal-footer")
						
						function showReplyPage(replyCnt){
							var endNum = Math.ceil(pageNum / 10.0) * 10;
							var startNum = endNum - 9;
							
							//앞페이지가 존재하는지?
									let prev = startNum != 1;
							//댓글은 마지막페이지부터 보여주니까 일단 다음페이지는 없는것으로
							let next = false;
							//만약 endNum(마지막페이지)포함댓글 개수가 댓글개수보다 많으면
							if(endNum * 10 >= replyCnt){
								endNum = Math.ceil(replyCnt/10.0);
							}
							//endNum가 댓글개수보다 적으면 다음페이지가 있다 next=true
							if(endNum *10 < replyCnt){
								next = true;
							}
							//댓글페이지 html 코드조립
							let pageHtml = "<ul class='pagination pull-right'>";
							
							//이전페이지가 존재하면 prev버튼활성화
							if(prev){
								pageHtml += "<li class='page-item'>";
								pageHtml += "<a class='page-link' href='" + (startNum -1 )+ "'>"
								pageHtml += "prev</a></li>";
							}
							//페이지숫자버튼만들기
							for(let i = startNum ; i<=endNum; i++){
								//active:현재페이지번호 추가
								let active = pageNum == i ? "active" : "";
							pageHtml += "<li class='page-item " + active + "'>";
							pageHtml += "<a class='page-link' href='" + i + "'>";
							pageHtml += i + "</a></li>";
							
							}
							//다음페이지가 존재하면 (10개단위) next버튼 활성화
							if(next){
								pageHtml += "<li class='page-item'>";
								pageHtml += "<a class='page-link' href='" + (endNum +1 ) + "'>";
								pageHtml += "Next</a></li>";
								
							}
							pageHtml += "</ul>";
							//html코드 붙이기
							replyPageFooter.html(pageHtml);
							console.log(pageHtml);
							
							
							
							
						}//end showReplyPage

						//모달div 가져오기
						var modal = $(".modal");
						
						//사용지 위조 방지토큰
						var csrfHeaderName = "${_csrf.headerName}";
						var csrfTokenValue = "${_csrf.token}";
						
						//앞으로 보낼 모든 ajax요청의 헤더에 csrf토큰 정보를 담아서 보낼수 있도록 설정
						$(document).ajaxSend(function(e,xhr,option){
							xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
						})//xhr = xmlHttpRequest 의 줄임말

						//사용자이름 가져오기
						var replyer = null;
						<sec:authorize access="isAuthenticated()">
						replyer = '<sec:authentication property="principal.username"/>';
						</sec:authorize>
						
						
						$("#addReplyBtn").on("click", function(e) {
							//#addReplyBtn은 덧글 추가하기 이느로 수정,삭제버튼 필요없음
							//보여줄필요가 없다
							//close버튼 이외의 다른 버튼을 다 숨기고
							//name이 replyer인 input tag의값을 우리가 위에서 가쟈온 replyer로 실행
							modal.find("button[id != 'modalCloseBtn']").hide();
							//등록버튼을 필요하니까 다시보이게 해준다
							$("#modalRegisterBtn").show();
							$(".close").show();

							modal.modal("show");
						});

						//댓글창닫기 이벤트
						$("#modalCloseBtn").on("click", function(e) {
							modal.modal("hide");
						})
						$(".close").on("click", function(e) {
							modal.modal("hide");
						})
						//댓글추가이벤트
						//name값이  reply인input 태그 찾아오기
						var modalInputReply = modal.find("input[name='reply']");
						//name값이  replyer인input 태그찾아오기
						var modalInputReplyer = modal
								.find("input[name='replyer']");
						$("#modalRegisterBtn").on("click", function(e) {
							//name속성이  reply인input찾아오기
							//name속성이  replyer인input찾아오기
							//게시글번호 bno가져와서reply객체 만든뒤애 댓글 달기 기능 실행
							var reply = {
								reply : modalInputReply.val(),
								replyer : modalInputReplyer.val(),
								bno : bnoValue
							}
							//add
							replyService.add(reply, function(result) {
								alert(result);
							})
							modal.find("input").val("");
							modal.modal("hide");

							showList(-1);
						})

						$(".chat").on(
								"click",
								"li",
								function(e) {
									//나중에 동적으로 생기는 <li>태그들에게 이벤트가 발생하도록 한다
									var rno = $(this).data("rno");

									//댓글가져와서 modal에 띄워주면 된다
									replyService.get(rno, function(reply) {
										modalInputReply.val(reply.reply);
										modalInputReplyer.val(reply.replyer);
										//modal의 data()
										modal.data("rno", reply.rno);
										//여기는 register버튼이 필요없음
										//일단close버튼빼고 다 숨기고
										//수정버튼과 제거버튼만 남겨놓기
										modal.find(
												"button[id!='modalCloseBtn']")
												.hide();

										$("#modalModBtn").show();
										$("#modalRemoveBtn").show();
										$(".modal").modal("show");
									})

								})
								
								//댓글 수정처리
								$("#modalModBtn").on("click" , function(e){
									//댓글수정버튼(modify버튼)
									let originalReplyer = modalInputReplyer.val();
									
									var reply ={
										rno : modal.data("rno"),
										reply : modalInputReply.val(),
										replyer: originalReplyer
									};
									
									if(replyer != originalReplyer){
										alert("자신이 작성한 댓글만 수정이 가능합니다.");
				                        modal.modal("hide");
				                        return; 
									}
									
								replyService.update(reply, function(result){
									
										alert(result);
										//modal 창 숨기고
										modal.modal("hide");
										//댓글 목록 다시 가져오기
										//pageNum은 현재페이지 번호 저장
										
										showList(pageNum);
										//댓글수정하고 나서 input 값 비우기
										modal.find("input").val("");
										
									})
									
								})
								//댓글 삭제처리
								$("#modalRemoveBtn").on("click" , function(e){
									//댓글삭제버튼(remove버튼)
									//삭제하기 위해 필요한거]
									var rno = modal.data("rno");
									
									let originalReplyer = modalInputReplyer.val();
									
									if(replyer != originalReplyer){
										alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				                        modal.modal("hide");
				                        return; 
									}
									
									
									replyService.remove(rno, originalReplyer, function(result){
									alert(result);
									modal.modal("hide");
									showList(pageNum);
									
									})
									})
									//replyPageFooter한테 이벤트위임
									//replyPageFooter안의 li a요소 에다가 이벤트 대상 변경해주기
									replyPageFooter.on("click" , "li a", function(e){
										e.preventDefault();//a태그의기본동작제거
										console.log("page click");
										//이동할 페이지 번호
										//href 속성에 페이지번호를 저장 해놨으므로 꺼내서 쓰자
										let target = $(this).attr("href");
										console.log("target page: " + target);
										pageNum = target;
										showList(pageNum);
									})
									
									
					})
	//댓글수정 이벤트
	//여기서 li태그를 찾아봤자 못찾는다
	//동적으로 ajax를 통해서<li>태그들이 만들어지면
	//그 <li>태그들은 스크립트 안에서는 찾을수가 없다
	//<li>태그가 생성된 이후에 이벤트를 달아야한다
	//지금여기서 <li>태그에 이벤트를 달라고 하면 찾을수가 없다

	//이벤트 위임
	//동적으로 생성되는 이벤트요소에 이벤트를 직접달라주는게 아니라 동적으로 생성될 요소에 부모 또는 형제 요소에다가 달아준다음
	//나중에 이벤트 대상을 변경해준다

	//<li>태그가 동적으로 생성될건데 여기다 달면 안된다
	//이미 존재하는 (부모 또는 형제)==> <ul>
</script>

<script type="text/javascript">
	$(document).ready(function() {
		var operForm = $("#operForm");
		$("button[data-oper='modify']").on("click", function() {
			operForm.submit();

		});
		$("button[data-oper='list']").on("click", function() {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();

		});

	});
</script>
<%@ include file="../includes/footer.jsp"%>