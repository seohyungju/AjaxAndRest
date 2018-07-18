<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<style>
	#modDiv {
		width:300px;
		height:100px;
		background-color : gray;
		position : absolute;
		top:50%;
		left:50%;
		margin-top : -50px;
		margin-left : -150px;
		padding : 10px;
		z-index : 1000;
	}
</style>
<body>
	<h2>ajax Test Page</h2>
	
	<div>
		<div>
			REPLYER <input type="text" name="replyer" id="newReplyWriter">
		</div>
		<div>
			REPLY TEXT <input type="text" name="replytext" id="newReplyText">
		</div>
		
		<button id="replyAddBtn">ADD REPLY</button>
	</div>
	
	<ul id="replies">
	
	</ul>
	
	<div id="modDiv" style="display: none;">
		<div class="modal-title">1</div>
		<div>
			<input type="text" id="replytext">
		</div>
		<div>
			<button type="button" id="replyModBtn">Modify</button>
			<button type="button" id="replyDelBtn">DELETE</button>
			<button type="button" id="closeBtn">Close</button>
		</div>
	</div>
	
<script src="/resources/jQuery/jQuery-2.1.4.min.js"></script>
<script>
		var bno = "12323";
		
		function getAllList(){
			
			$.getJSON("/replies/all/" + bno, function(data){
				
				var str = "";
				console.log(data.length);
				
				$(data).each(
						function(){
							str += "<li data-rno='" + this.rno + "' class='replyLi'>"
									+ this.rno + ":" + this.replytext + "<button>MOD</button></li>";
						});
				
				$("#replies").html(str);
			});
	
		};
		
		$("#replyAddBtn").on("click", function(){
			var replyer = $("#newReplyWriter").val();
			var replytext = $("#newReplyText").val();
			// $.post 로 사용을 하면 json 타입을 보낼 수 없어 $.ajax 로 사용 ! (controller 에서는 json 타입으로 받고 있기 때문)
			$.ajax({
				type : 'post',
				url : '/replies',
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				dataType : 'text',
				data : JSON.stringify({
					bno : bno,
					replyer : replyer,
					replytext : replytext
				}),
				
				success : function(result){
					if(result == 'SUCCESS'){
						alert("등록 되었습니다.");
						getAllList();
					}
				}
				
			});
		});
		
		$("#replies").on("click", ".replyLi button", function(){
			
			var reply = $(this).parent();
			
			var rno = reply.attr("data-rno");
			var replytext = reply.text();
			
			$(".modal-title").html(rno);
			$("#replytext").val(replytext);
			$("#modDiv").show("slow");
		});
		
		$("#replyDelBtn").on("click", function(){
			var rno = $(".modal-title").html();
			var replytext = $("#replytext").val();
			
			$.ajax({
				type : 'delete',
				url : '/replies/' + rno,
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "DELETE"
				},
				
				dataType : 'text',
				success : function(result){
					console.log("result : " + result);
					if(result == "SUCCESS"){
						alert("삭제 되었습니다.");
						$("#modDiv").hide("slow");
						getAllList();
					}
				}
			});
		});
		
		$("#replyModBtn").on("click", function(){
			var rno = $(".modal-title").html();
			var replytext = $("#replytext").val();
			
			$.ajax({
				type : 'put',
				url : '/replies' + rno,
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "PUT"
				},
				
				data:JSON.stringify({replytext:replytext}),
				dataType:'text',
				success:function(result){
					console.log("result: " + result);
					
					if(result == "SUCCESS"){
						alert("수정 되었습니다.");
						$("#modDiv").hide("slow");
						//getAllList();
						getPageList(replyPage);
					}
				}
			});
		});
				
	</script>
</body>
</html>
