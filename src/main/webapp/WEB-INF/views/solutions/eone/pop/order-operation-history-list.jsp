<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderOperationHistoryList = (function($){
		var lineNo = Dialog.getParams();
		var init = function(){
			$("#order-operation-history-grid").grid({
				header:[
					[
						{name : "<s:interpret word='지시번호' abbr='' />"},
						{name : "<s:interpret word='지시유형' abbr='' />"},
						{name : "<s:interpret word='지시별 단계' abbr='' />"},
						{name : "<s:interpret word='지시별 단계순서' abbr='' />"},
						{name : "<s:interpret word='시작일시' abbr='' />"},
						{name : "<s:interpret word='완료일시' abbr='' />"}
					]
				]
				, height : "532px"
			});
			_setForm();
			_bindEvent();
			$(".footer-wrap").pager({"click" : list, "btnSearch" : ".btn-srch"});
			//setInterval(list, 2000);
		}
		, _bindEvent = function(){
			$(".btn-srch").on("touchend click", function(e){
				e.preventDefault();
				list();
			});
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
		}
		, _setForm = function(){
			$("#schLineNo").val(lineNo);
			BoxTag.selectBox.draw([
				{
					selector : "#systemOperationModeId",
					firstTxt : "지시유형",
					masterCd : "order_type_cd"
				}
			]);
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderoperationhistory/getOrderOperationHistoryPagingList'/>"
				, $.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
				$("#order-operation-history-grid").grid("draw", data.list, function(row){
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
</style>

<main class="pop-view">
	<header>
		<h2><s:interpret word='시스템 로그' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area horizontal">
				<div class="align-left">
					<span>
						<input type="hidden" name="schLineNo" id="schLineNo" value=""/>
						<label class="label-text"><s:interpret word='지시번호' abbr='' /></label>
						<input type="text" name="orderId" id="orderId" placeholder="<s:interpret word='지시번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시유형' abbr='' /></label>
						<select name="systemOperationModeId" id="systemOperationModeId"></select>
					</span>
<%-- 					<span> --%>
<%-- 						<label class="label-text"><s:interpret word='지시일자' abbr='' /></label> --%>
<%-- 						<input type="text" name="operationDt" class="calendar" placeholder="<s:interpret word='지시일자' abbr='' />" data-nokeypad='true' readonly='readonly'> --%>
<%-- 					</span> --%>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="order-operation-history-grid"></div>
			<div class="footer-wrap"></div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="order-operation-history-grid">
<tr>
	<td>@{orderId}</td>
	<td>@{systemOperationModeNameCache}</td>
	<td>@{systemOperationModeStepNameCache}</td>
	<td>@{systemOperationModeStepSort}</td>
	<td>@{operationStartDt}</td>
	<td>@{operationEndDt}</td>
</tr>
</script>
