<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.ELocType" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/sfp/sfp-ui-messagebox.css' />">
<script>
$(function(){
	window.OrderDetail = (function($){
		var params = Dialog.getParams();
		
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
// 			});\
			
			// '진행' 상태가 아니면 완료버튼 숨김 (2025.04.05 - by MOON.)
			if(params.orderGroupStatusNameCache != "진행"){
				$('#btn_complete').css('display', 'none');
			}else{
				$('#btn_complete').css('display', 'display');				
			}
			_setForm();
			_bindEvent();
			getOrderWorkList();
// 			getOrderWorkHistoryList();
		}
		, _bindEvent = function(){
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
			
			$(".btn-add").on("touchend click", function(e){
				// 완료처리 
				e.preventDefault();
				_completeOrder();
			});
		}
		// 작업지시 완료 처리 함수 (2025.04.10 - by MOON.)
		, _completeOrder = function(){
			var param = { orderGroupId : params.orderGroupId }
			//alert(param.orderGroupId);
			const _pwd = prompt("해당 작업을 완료하시기 위해서 비밀번호를 입력하십시요.");
			if(_pwd == null || _pwd == undefined) { return; } // 취소버튼 클릭
			if(_pwd == "") {alert("비밀번호를 입력하지 않았습니다."); return;} // 비번 입력없이 확인버튼 클릭
			
			if(_pwd != "1234"){
				alert("비밀번호가 틀립니다.");
				return;
			}
			
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/forceCompleteOrderGroup'/>", param, function(data) {
					//if(data === true){
					//	alert("true");						
					//}else if(data === false){
					//	alert("false");
					//}
					alert("작업을 완료하였습니다.");
					Dialog.close(true);
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

<main>
	<header>
		<h2><s:interpret word='현황 - 작업지시 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table right-scroll">
				<h3 class="grid-title big"><s:interpret word='지시정보' abbr='' /></h3>
				<ul>
					<li class="vertical">
						<div class="title"><s:interpret word='지시번호' abbr='' /></div>
						<div class="title"><s:interpret word='지시일자' abbr='' /></div>
						<div class="title"><s:interpret word='지시유형' abbr='' /></div>
						<div class="title"><s:interpret word='긴급여부' abbr='' /></div>
						<div class="title"><s:interpret word='Line번호' abbr='' /></div>
						<div class="title"><s:interpret word='지시Rack(개)' abbr='' /></div>
						
					</li>
					<li class="vertical">
						<div class="cont"><div class="line-wrap"><span id="orderGroupId"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderGroupDate"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderGroupTypeNameCache"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="emergencyYn"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="lineNo"></span></div></div>
						<div class="cont"><div class="line-wrap"><span id="orderTrayQty"></span></div></div>
						
					</li>
					<li class="vertical">
						<div class="title"><s:interpret word='처리Rack(개)' abbr='' /></div>
						<div class="title"><s:interpret word='시작시점' abbr='' /></div>
						<div class="title"><s:interpret word='완료시점' abbr='' /></div>
						<div class="title"><s:interpret word='소요(초)' abbr='' /></div>
						<div class="title"><s:interpret word='지시상태' abbr='' /></div>
						<div class="title"><s:interpret word='완료유형' abbr='' /></div>
					</li>
					<li class="vertical">
						<div class="cont"><div class="line-wrap"><span id="workTrayQty"></span></div></div>
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
				<button class="btn-add" id="btn_complete"><s:interpret word='완료' abbr='' /></button>
			</div>						
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="tray-info-grid">
<tr>
	<td>@{rowNum}</td>
	<td>@{trayId}</td>
	<td>@{fromLocation}</td>
	<td>@{toLocation}</td>
</tr>
</script>
<script type="text/sfp-template" data-model="tray-info-history-grid">
<tr>
	<td>@{rowNum}</td>
	<td>@{trayId}</td>
	<td>@{fromLocation}</td>
	<td>@{toLocation}</td>
</tr>
</script>
