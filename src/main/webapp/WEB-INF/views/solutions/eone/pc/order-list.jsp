<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderList = (function($){
		var init = function(){
			$("#order-list-grid").grid({
				header:[
					[
						{name : "<s:interpret word='No' abbr='' />", width: "80px"},
						{name : "<s:interpret word='지시번호' abbr='' />"},
						{name : "<s:interpret word='지시일자' abbr='' />", width: "90px"},
						{name : "<s:interpret word='업무유형' abbr='' />", width: "140px"},
						{name : "<s:interpret word='긴급여부' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Line번호' abbr='' />", width: "80px"},
						{name : "<s:interpret word='지시Rack(개)' abbr='' />", width: "130px"},
						{name : "<s:interpret word='처리Rack(개)' abbr='' />", width: "130px"},
						{name : "<s:interpret word='시작시점' abbr='' />", width: "80px"},
						{name : "<s:interpret word='완료시점' abbr='' />", width: "80px"},
						{name : "<s:interpret word='소요(s)' abbr='' />", width: "80px"},
						{name : "<s:interpret word='지시상태' abbr='' />", width: "80px"},
						{name : "<s:interpret word='완료유형' abbr='' />", width: "80px"}
					]
				]
				, height : "532px"
			});
			_setForm();
			_bindEvent();
			$(".footer-wrap").pager({"click" : list, "btnSearch" : ".btn-srch"});
		}
		, _bindEvent = function(){
			$(".btn-srch").on("touchend click", function(e){
				list();
			});
			$("#order-list-grid").on("touchend click", "tr", function(e) {
				e.preventDefault();
				Dialog.open("<c:url value='/solutions/eone/pc/order-detail.dialog' />", { width: "1800px", height: "900px" }, $("#order-list-grid").grid("getData", this), function(){					
					list();
				});
				$(this).blur();
			});
		}
		, _setForm = function(){
			BoxTag.selectBox.draw([
				{
					selector : "#orderGroupTypeCd",
					firstTxt : "업무유형",
					masterCd : "order_type_cd"
				}
			]);
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/getPagingList'/>"
				, $.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
				var varStatus = 0;
				$("#order-list-grid").grid("draw", data.list, function(row){
					row.rowNum = (data.paging.totalElements-varStatus++) - ( (data.paging.number) * data.paging.size );
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

<main>
	<header>
		<h2><s:interpret word='현황 - 작업 지시 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area horizontal">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='Line번호' abbr='' /></label>
						<select name="lineNo" id="lineNo">
							<option value="">Line번호</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
						</select>
					</span>
					<span>
						<label class="label-text"><s:interpret word='업무유형' abbr='' /></label>
						<select name="orderGroupTypeCd" id="orderGroupTypeCd"></select>
					</span>
					<span>
						<label class="label-text"><s:interpret word='긴급여부' abbr='' /></label>
						<select name="emergencyYn" id="emergencyYn">
							<option value="">긴급여부</option>
							<option value="N">N</option>
							<option value="Y">Y</option>
						</select>
					</span>
					<span>
						<label class="label-text"><s:interpret word='Rack번호' abbr='' /></label>
						<input type="text" name="searchTrayId" id="searchTrayId" placeholder="<s:interpret word='Rack번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시번호' abbr='' /></label>
						<input type="text" name="orderGroupId" id="orderGroupId" placeholder="<s:interpret word='지시번호' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="order-list-grid"></div>
			<div class="footer-wrap"></div>
		</section>
	</div>
</main>

<script type="text/sfp-template" data-model="order-list-grid">
<tr>
	<td>@{rowNum}</td>
	<td>@{orderGroupId}</td>
	<td>@{orderGroupDate}</td>
	<td>@{orderGroupTypeNameCache}</td>
	<td>@{emergencyYn}</td>
	<td>@{lineNo}</td>
	<td>@{orderTrayQty}</td>
	<td>@{workTrayQty}</td>
	<td>@{orderGroupStartHms}</td>
	<td>@{orderGroupEndHms}</td>
	<td data-number-comma>@{takeSeconds}</td>
	<td>@{orderGroupStatusNameCache}</td>
	<td>@{orderGroupFinishTypeNameCache}</td>
</tr>
</script>
