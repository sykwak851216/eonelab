<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.ELocType" %>

<script>
$(function(){
	window.BufferCurrent = (function($){
		var lineNo = Dialog.getParams();
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
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getBufferTrayLocationListIncludeSensor'/>", {lineNo:lineNo}, function(list) {

				$("ul#buffer-current-template > li").removeClass("sensing");
				$("ul#buffer-current-template > li span").text("");

				list.forEach(function(element){
					var $li = $("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0'));
					if(element.sensor === "1"){
						$li.find("span.status").addClass("sensing");
					}else if(element.sensor === "0"){
						$li.find("span.status").removeClass("sensing");
					}
// 					$li.find(".card-cont span").text(element.trayId);
				});
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
	min-height: 50px;
	height: 50px;
	line-height: 50px;
	display: flex;
	align-items: center;
}

.fix-card .card-cont span{ font-size: 30px; padding-left: 10px; }
.fix-card .card-cont .card-cont-left{ width: 100%; float: left; padding-left: 10px; padding-right: 10px; }
.fix-card .card-cont .card-cont-right{ width:20%; float: right; padding-left: 10px; }
.fix-card .card-cont .card-cont-left .trayInfo{ width: 100%; }
.fix-card .card-cont .card-cont-left .rackInfo{ width: 25%; margin-left: 20px; }

.fix-card.two-col > ul > li {
	width: 32%;
	border: 5px solid #fff;
}
.fix-card.two-col > ul > li.selected {
	background-color: #F89406;
	color: #fff;
}

#buffer-current-template{ height: 300px; }
.sensing h3{ background-color: #219244; color: #fff; }

.fix-card h3 .status { margin-top: -14px; }
.fix-card .status { width: 25px; height: 25px; }
.fix-card .status.sensing { background-color: #219244; }

.sensor{ width: 10%; height : 100px; }
.buffer-cell{ width: 45%; height : 100px; }
.tray-info{ width: 45%; height : 100px; }

</style>

<main class="pop-view">
	<header>
		<h2><s:interpret word='Shuttle 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="fix-card oee-list two-col">
				<ul id="buffer-current-template">
					<li id="BC-010" data-buffer-id="10"><h3>BC-010<span class="status"></span></h3></li>
					<li id="BC-011" data-buffer-id="11"><h3>BC-011<span class="status"></span></h3></li>
					<li id="BC-012" data-buffer-id="12"><h3>BC-012<span class="status"></span></h3></li>
					<li id="BC-007" data-buffer-id="7"><h3>BC-007<span class="status"></span></h3></li>
					<li id="BC-008" data-buffer-id="8"><h3>BC-008<span class="status"></span></h3></li>
					<li id="BC-009" data-buffer-id="9"><h3>BC-009<span class="status"></span></h3></li>
					<li id="BC-004" data-buffer-id="4"><h3>BC-004<span class="status"></span></h3></li>
					<li id="BC-005" data-buffer-id="5"><h3>BC-005<span class="status"></span></h3></li>
					<li id="BC-006" data-buffer-id="6"><h3>BC-006<span class="status"></span></h3></li>
					<li id="BC-001" data-buffer-id="1"><h3>BC-001<span class="status"></span></h3></li>
					<li id="BC-002" data-buffer-id="2"><h3>BC-002<span class="status"></span></h3></li>
					<li id="BC-003" data-buffer-id="3"><h3>BC-003<span class="status"></span></h3></li>
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