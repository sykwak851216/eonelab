<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderOperationHistorySearch = (function($){
		var init = function(){
			$("#order-operation-history-grid").grid({
				header:[
					[
						{name : "<s:interpret word='지시번호' abbr='' />"},
						{name : "<s:interpret word='시스템동작모드ID' abbr='' />"},
						{name : "<s:interpret word='시스템동작모드단계ID' abbr='' />"},
						{name : "<s:interpret word='시스템동작모드단계순서' abbr='' />"},
						{name : "<s:interpret word='시작일시' abbr='' />"},
						{name : "<s:interpret word='완료일시' abbr='' />"},
						{name : "<s:interpret word='작업' abbr='' />", width : "120px"}
					]
				]
				, addClasses : "small"
				, height : "300px"
			});
			_setForm();
			_bindEvent();
			list();
		}
		, _setForm = function(){

		}
		, _bindEvent = function(){
			$(".btn-srch").click(function() {
				list();
			});
			$("#order-operation-history-grid").on("click", ".btn-select", function() {
				var data = $("#order-operation-history-grid").grid("getData", this);
				Dialog.close(data);
			});
			$(".btn-close").click(function() {
				Dialog.cancel();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderoperationhistory/getList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), { delYn : "N" })
				, function(data) {
					$("#order-operation-history-grid").grid("draw", data);
			});
		};
		init();
		return {
			list : list
		}
	})(jQuery);
});

</script>
<style></style>

<main>
	<header>
		<h2><s:interpret word='지시별 동작 히스토리' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='지시번호' abbr='' /></label>
						<input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='시스템동작모드ID' abbr='' /></label>
						<input type="text" name="systemOperationModeId" placeholder="<s:interpret word='시스템동작모드ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='시스템동작모드단계ID' abbr='' /></label>
						<input type="text" name="systemOperationModeStepId" placeholder="<s:interpret word='시스템동작모드단계ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='시스템동작모드단계순서' abbr='' /></label>
						<input type="text" name="systemOperationModeStepSort" placeholder="<s:interpret word='시스템동작모드단계순서' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='시작일시' abbr='' /></label>
						<input type="text" name="operationStartDt" placeholder="<s:interpret word='시작일시' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='완료일시' abbr='' /></label>
						<input type="text" name="operationEndDt" placeholder="<s:interpret word='완료일시' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="order-operation-history-grid"></div>
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
	<td>@{systemOperationModeId}</td>
	<td>@{systemOperationModeStepId}</td>
	<td>@{systemOperationModeStepSort}</td>
	<td>@{operationStartDt}</td>
	<td>@{operationEndDt}</td>
	<td><button type="button" class="btn-select"><s:interpret word='선택' abbr='' /></button></td>
</tr>
</script>
</body>
</html>