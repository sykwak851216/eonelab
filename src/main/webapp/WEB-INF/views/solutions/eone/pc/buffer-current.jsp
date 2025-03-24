<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.ELocType" %>

<script>
$(function(){

	var params = Dialog.getParams();
	window.BufferCurrent = (function($){
		var init = function(){
			_setForm();
			_bindEvent();
			list();
			setInterval(list, 2000);// 2초당 한번씩 갱신 처리
		}
		, _bindEvent = function(){
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
		}
		, _setForm = function(){

		}
		, list = function(){
// 			console.dir(params);
// 			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordertray/getList'/>", { orderId : params.orderId }, function(list) {
<%-- 			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getList'/>", { locTypeCd : '<%=ELocType.BUFFER.name()%>' }, function(list) { --%>
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getBufferTrayLocationListIncludeSensor'/>", null, function(list) {

				$("ul#buffer-current-template > li").removeClass("sensing");
				$("ul#buffer-current-template > li span").text("");

				list.forEach(function(element){
// 					console.dir(element);
					var $li = $("#BC-00"+element.bufferId);
					if(element.sensor === "1"){
						$li.find("span.status").addClass("sensing");
					}else if(element.sensor === "0"){
						$li.find("span.status").removeClass("sensing");
					}
					$li.find(".card-cont span").text(element.trayId);
				});

// 				$("#BC-004").find("span.status").addClass("sensing");
// 				$("#BC-003").find("span.status").addClass("sensing");
// 				$("#BC-002").find("span.status").addClass("sensing");
// 				$("#BC-001").find("span.status").addClass("sensing");

// 				$("#BC-004").find(".card-cont span").text("TRAY0011");
// 				$("#BC-003").find(".card-cont span").text("TRAY0013");
// 				$("#BC-002").find(".card-cont span").text("TRAY0016");
// 				$("#BC-001").find(".card-cont span").text("TRAY0021");

			});
		}
		;
		init();
		return {
			list : list
		}
	})(jQuery);
});
</script>
<style>
.fix-card h3 {
	padding-left: 10px;
	padding-top: 10px;
}
.fix-card .card-cont{
	min-height: 80px;
	height: 80px;
	line-height: 60px;
}

.fix-card .card-cont span{ font-size: 30px; padding-left: 10px;}
#buffer-current-template{ height: 530px; }
.sensing h3{ background-color: #219244; color: #fff; }

.fix-card h3 .status { margin-top: -14px; }
.fix-card .status { width: 25px; height: 25px; }
.fix-card .status.sensing { background-color: #219244; }

.sensor{ width: 10%; height : 100px; }
.buffer-cell{ width: 45%; height : 100px; }
.tray-info{ width: 45%; height : 100px; }

</style>

<main>
	<header>
		<h2><s:interpret word='Buffer Shuttle 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="fix-card oee-list two-col">
				<ul id="buffer-current-template">
					<li id="BC-008"><h3>BC-008<span class="status"></span></h3><div class="card-cont"><span></span></div></li>
					<li id="BC-004"><h3>BC-004<span class="status"></span></h3><div class="card-cont"><span></span></div></li>
					<li id="BC-007"><h3>BC-007<span class="status"></span></h3><div class="card-cont"><span></span></div></li>
					<li id="BC-003"><h3>BC-003<span class="status"></span></h3><div class="card-cont"><span></span></div></li>
					<li id="BC-006"><h3>BC-006<span class="status"></span></h3><div class="card-cont"><span></span></div></li>
					<li id="BC-002"><h3>BC-002<span class="status"></span></h3><div class="card-cont"><span></span></div></li>
					<li id="BC-005"><h3>BC-005<span class="status"></span></h3><div class="card-cont"><span></span></div></li>
					<li id="BC-001"><h3>BC-001<span class="status"></span></h3><div class="card-cont"><span></span></div></li>
				</ul>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>