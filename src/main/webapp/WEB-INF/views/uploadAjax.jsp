<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 150px;
}

.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.bigPicture img {
	width: 600px;
}

.uploadResult ul li span {
	color: white;
}
</style>
</head>
<body>
	<h1>파일 업로드 AJAX로 해보기</h1>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<div class="uploadResult">
		<ul>
			<!-- 업로드 파일 리스트 -->


		</ul>

	</div>

	<div class="bigPictureWrapper">
		<div class="bigPicture"></div>
	</div>
	<button id="uploadBtn">파일 업로드</button>
	<script src="https://code.jquery.com/jquery-3.6.0.js"
		integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
		crossorigin="anonymous"></script>
	<script>
//원본이미지를 보여주는 함수
//jquery로드 안된 상황에서도 사용할수 있도록 밖에다가 작성


function showImage(filePath){
	//alert(filePath);
	$(".bigPictureWrapper").css("display","flex").show();
	
	//html코드로 img태그를 삽입
	$(".bigPicture")
	.html("<img src='/display?filename=" + encodeURI(filePath)+ "'>")
	.animate({width:'100%' , height:'100%'},1000);
	
		$(".bigPictureWrapper").on("click",function(e){
			//이미지크기만 0으로 줄이고
			$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
			//1초후에 숨기기
					setTimeout(function(){
						$(".bigPictureWrapper").hide();
					},1000);
		})		
		
}
			    
		$(".uploadResult").on("click", "span", function(e){
			//삭제대상파일
			let targetFile = $(this).data("file");
			//삭제대상 파일의 타입
			let type = $(this).data("type");
			
			$.ajax({
				url : '/deleteFile',
			    type:'POST',
			    data:{filename : targetFile, type:type},
			    dataType : 'text',
			    success : function(result){
			    	alert("result");
			    	}
			})
		})
$(document).ready(function(){
	//여기서 확장자 제한
	//exe,압축파일 제한
	//파일 크기 제한까지
	//확장자를 검사하는 제일 간단한 방법=>String함수를 이용해서
	//파일 이름 안에 exe?zip?alz?sh?이런것들이 포함되여있는지 검사
			//includes
			//우아한 엘레강스한 방법 ==> 표현식(정규식))
			//파일이름.exe파일이름.zip..
			let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			let maxSize = 5242880;//파일크기 5MB
			
			var cloneObj = $(".uploadDiv").clone();
			
			var uploadResult =$(".uploadResult ul");
			
			
			//우리가  찾아온 ul 태그안에 업로드한 파일들의 정보를 동적으로 생성하여 추가
			function showUploadedFile(uArr){
				
				let uploadHtml = "";
				
				//업로드 차일 한개 =<li>태그 한개
				for(let i =0; i<uArr.length; i++){
					if(uArr[i].image == false){
						
						//이미지 파일이 아닌경우에
						//li태그 앞에다가 파일 아이콘을  붙여주겠습니다
					
						let fileCallPath = encodeURIComponent("/" + uArr[i].uuid+"_" + uArr[i].filename);
						
						
						uploadHtml += "<li>"
						+"<a href='/download?filename=" + fileCallPath + "'>"
						+"<img src='/resources/img/star.png'>"
						+ uArr[i].filename + "</a>"
						+"<span data-file=\'"+ fileCallPath + "\' data-type='file'> x </span>"
						+"</li>";
					}else{
						
						//이미지 파일인 경우에
						//IMG태그의 추가하는데 이거를 올린 이미지로
						
						//uploadHtml += "<li>" + uArr[i].filename + "</li>";
						//우리가 첨부파일을 이미지로 올리면
						//원본파일 올리고 추가로 섬네일 이미지가 생성됨
						//여기서 사용할거는 섬네일 이미지
						//섬네일 이미지는 파일이름
						//업로드경로 +S_+UUID+원래파일이름
						//한글이름이 문제가 될수있어서 ENCODING처리를 해준다
						let fileCallPath
						= encodeURIComponent(
								"s_"
								+uArr[i].uuid
								+"_"
								+uArr[i].filename);
						
						let originPath = uArr[i].uuid + "_" + uArr[i].filename;
						//역슬래쉬 두개있는 문자열을 슬래쉬 하나로 모두 바꿔준다
						originPath = originPath.replace(new RegExp(/\\/g), "/");
						
						uploadHtml += "<li>"
						+"<a href=\"javascript:showImage(\'" + originPath + "\')\">"
						+"<img src='/display?filename=" + fileCallPath + "'></a><span data-file=\'"+ fileCallPath + "\' data-type='image'> x </span></li>";
					}
					
				}
				//ul태그 밑에 li태그 붙이기
				uploadResult.append(uploadHtml);
			}
			
			function checkFile(FileName, fileSize){
				//파일크기검사
				if(fileSize > maxSize){
					alert("파일 최대크기초과");
					return false;
				}
				//파일 확장자 검사: 정규식과 파일이름이 일치하는 패턴이면  false를 리턴
				if(regex.test(FileName)){
					alert("해당 종류의 파일은 업로드 불가");
					 return false;
				}
				//두개 모두 통과했다면
				return true;
			}


	$("#uploadBtn").on("click" , function(e){
		//from태그없이 form을 만들어서 보내는 방법
		let formData = new FormData();
		
		let file = $("input[name='uploadFile']");
		
		let files = file[0].files;
		
		
		console.log(files);
		//formData 에 파일 추가
		for(let i=0; i<files.length; i++){
			//파일검사중에 false가 나오면 파일 업로드를 중단시킨다
			if(checkFile(files[i].name, files[i].size) == false){
				
				return false;//함수실행을 중단
			}
		
			formData.append("uploadFile" , files[i]);
		
		}
		
		//input type="file" 초기화준비
		//초기화는 언제?
		//ajax요청 보내기
		$.ajax({
			url : "/uploadAjaxAction",
			processData : false,
			contentType : false,
			data : formData,
			type : "POST",
			success : function(result){
				console.log(result);
				//li태그 추가
				showUploadedFile(result);
				//요청보내놓고 성공하면은 input file을 초기화 시켜준다는것
				$(".uploadDiv").html(cloneObj.html());
			}
			
			
		});//ajax end
	})
	
})
</script>
</body>
</html>