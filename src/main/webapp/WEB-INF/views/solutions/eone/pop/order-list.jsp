<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderList = (function($){
		var lineNo = Dialog.getParams();
		var init = function(){
			$("#order-list-grid").grid({
				header:[
					[
						{name : "<s:interpret word='No' abbr='' />", width: "80px"},
						{name : "<s:interpret word='지시번호' abbr='' />"},
						{name : "<s:interpret word='지시일자' abbr='' />", width: "140px"},
						{name : "<s:interpret word='업무유형' abbr='' />", width: "140px"},
						{name : "<s:interpret word='긴급여부' abbr='' />", width: "120px"},
						{name : "<s:interpret word='지시Rack(개)' abbr='' />", width: "160px"},
						{name : "<s:interpret word='처리Rack(개)' abbr='' />", width: "160px"},
						{name : "<s:interpret word='시작시점' abbr='' />", width: "140px"},
						{name : "<s:interpret word='완료시점' abbr='' />", width: "140px"},
						{name : "<s:interpret word='소요(s)' abbr='' />", width: "140px"},
						{name : "<s:interpret word='지시상태' abbr='' />", width: "120px"},
						{name : "<s:interpret word='완료유형' abbr='' />", width: "120px"}
					]
				]
				, height : "532px"
			});
			_setForm();
			_bindEvent();
			$(".footer-wrap").pager({"click" : list, "btnSearch" : ".btn-srch"});
		}
		, _bindEvent = function(){
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
			$(".btn-srch").on("touchend click", function(e){
				list();
			});
			//작업지시 상세
			$("#order-list-grid").on("touchend click", ".sfp-template-el", function(e) {
				e.preventDefault();
				Dialog.open("<c:url value='/solutions/eone/pop/order-detail.pdialog' />", { width: "1600px", height: "900px" }, $("#order-list-grid").grid("getData", this), function(){

				});
				$(this).blur();
			});
		}
		, _setForm = function(){
			BoxTag.selectBox.draw([
				{
					selector : "#orderGroupTypeCd",
					firstTxt : "-전체-",
					masterCd : "order_type_cd"
				}
			]);
		}
		, list = function(paging){
			$("#lineNo").val(lineNo);
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/getPagingList'/>"
				, $.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
				$("#order-list-grid").grid("draw", data.list, function(row){
				});
				$(".footer-wrap").pager("setPage", data.paging);
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
.sfp-grid tbody td { cursor: pointer; }
</style>

<main class="pop-view">
	<header>
		<h2><s:interpret word='작업지시 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area horizontal">
				<div class="align-left">
					<input type="hidden" name="lineNo" id="lineNo" value=''/>
					<span>
						<label class="label-text"><s:interpret word='지시일자' abbr='' /></label>
						<input type="text" name="orderGroupDate" id="orderGroupDate" class="calendar" placeholder="<s:interpret word='지시일자' abbr='' />" data-nokeypad='true' readonly='readonly'>
					</span>
					<span>
						<label class="label-text"><s:interpret word='업무유형' abbr='' /></label>
						<select name="orderGroupTypeCd" id="orderGroupTypeCd"></select>
					</span>
<%-- 					<span> --%>
<%-- 						<label class="label-text"><s:interpret word='Rack번호' abbr='' /></label> --%>
<%-- 						<input type="text" name="trayId" id="trayId" placeholder="<s:interpret word='Rack번호' abbr='' />"> --%>
<%-- 					</span> --%>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="order-list-grid"></div>
			<div class="footer-wrap"></div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="order-list-grid">
<tr>
	<td>@{rowNum}</td>
	<td>@{orderGroupId}</td>
	<td>@{orderGroupDate}</td>
	<td>@{orderGroupTypeNameCache}</td>
	<td>@{emergencyYn}</td>
	<td>@{orderTrayQty}</td>
	<td>@{workTrayQty}</td>
	<td>@{orderGroupStartHms}</td>
	<td>@{orderGroupEndHms}</td>
	<td data-number-comma>@{takeSeconds}</td>
	<td>@{orderGroupStatusNameCache}</td>
	<td>@{orderGroupFinishTypeNameCache}</td>
</tr>
</script>
