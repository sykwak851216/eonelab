<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	var params = Dialog.getParams();
	window.OrderDetail = (function($){
		var init = function(){
			$(".contents-wrap").setData(Dialog.getParams());
			$("#tray-info-grid").grid({
				header:[
					[
						{name : "<s:interpret word='No' abbr='' />", width: "40px"},
						{name : "<s:interpret word='Rack번호' abbr='' />"},
						{name : "<s:interpret word='From' abbr='' />"},
						{name : "<s:interpret word='To' abbr='' />"}
					]
				]
				, height : "400px"
			});
// 			$("#tray-info-history-grid").grid({
// 				header:[
// 					[
// 						{name : "<s:interpret word='No' abbr='' />", width: "40px"},
// 						{name : "<s:interpret word='Rack번호' abbr='' />"},
// 						{name : "<s:interpret word='From' abbr='' />"},
// 						{name : "<s:interpret word='To' abbr='' />"}
// 					]
// 				]
// 				, height : "400px"
// 			});
			_setForm();
			_bindEvent();
			getOrderWorkList();
// 			getOrderWorkHistoryList();
		}
		, _bindEvent = function(){
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
		}
		, _setForm = function(){

		}
		, getOrderWorkList = function(){
			var param = { orderGroupId : params.orderGroupId }
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderwork/getOrderWorkListByOrderGroupId'/>", param , function(data) {
				$("#tray-info-grid").grid("draw", data, function(row){

				});
			});
		}
		, getOrderWorkHistoryList = function(){
			var param = { orderGroupId : params.orderGroupId }
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderwork/getOrderWorkHistoryListByOrderGroupId'/>", param , function(data) {
				$("#tray-info-history-grid").grid("draw", data, function(row){

				});
			});
		};
		init();
		return {
		}
	})(jQuery);
});
</script>
<style>
.grid-title.big{ font-size: 20px;}
.register-table .cont .line-wrap {
	text-align: center;
}
</style>

<main class="pop-view">
	<header>
		<h2><s:interpret word='작업지시 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table right-scroll">
				<h3 class="grid-title big"><s:interpret word='지시정보' abbr='' /></h3>
				<ul>
					<li class="vertical">
						<div class="title"><s:interpret word='지시번호' abbr='' /></div>
						<div class="title"><s:interpret word='지시일자' abbr='' /></div>
						<div class="title"><s:interpret word='업무유형' abbr='' /></div>
						<div class="title"><s:interpret word='지시Rack(개)' abbr='' /></div>
						<div class="title"><s:interpret word='처리Rack(개)' abbr='' /></div>
					</li>
					<li class="vertical">
						<div class="cont"><div class="line-wrap"><span id="orderGroupId"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderGroupDate"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderGroupTypeNameCache"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderTrayQty"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="workTrayQty"></span></div></div>
					</li>
					<li class="vertical">
						<div class="title"><s:interpret word='시작시점' abbr='' /></div>
						<div class="title"><s:interpret word='완료시점' abbr='' /></div>
						<div class="title"><s:interpret word='소요(초)' abbr='' /></div>
						<div class="title"><s:interpret word='지시상태' abbr='' /></div>
						<div class="title"><s:interpret word='완료유형' abbr='' /></div>
					</li>
					<li class="vertical">
						<div class="cont"><div class="line-wrap"><span id="orderGroupStartHms"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderGroupEndHms"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="takeSeconds"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderGroupStatusNameCache"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderGroupFinishTypeNameCache"></span></div></div>
					</li>
				</ul>
			</div>
<!-- 			<div class="col-2-wrap mgt20"> -->
				<div id="tray-info-grid"><h3 class="grid-title big"><s:interpret word='Rack정보' abbr='' /></h3></div>
<%-- 				<div id="tray-info-history-grid"><h3 class="grid-title big"><s:interpret word='작업내역' abbr='' /></h3></div> --%>
<!-- 			</div> -->
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="tray-info-grid">
<tr>
	<td>@{rowNum}</td>
	<td>@{showPopTrayId}</td>
	<td>@{fromLocation}</td>
	<td>@{toLocation}</td>
</tr>
</script>
<script type="text/sfp-template" data-model="tray-info-history-grid">
<tr>
	<td>@{rowNum}</td>
	<td>@{showPopTrayId}</td>
	<td>@{fromLocation}</td>
	<td>@{toLocation}</td>
</tr>
</script>
