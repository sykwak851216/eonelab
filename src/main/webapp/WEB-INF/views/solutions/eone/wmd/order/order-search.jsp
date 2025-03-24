<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderSearch = (function($){
		var init = function(){
			$("#order-grid").grid({
				header:[
					[
						{name : "<s:interpret word='지시번호' abbr='' />"},
						{name : "<s:interpret word='지시유형' abbr='' />"},
						{name : "<s:interpret word='지시일자' abbr='' />"},
						{name : "<s:interpret word='지시트레이수' abbr='' />"},
						{name : "<s:interpret word='처리트레이수' abbr='' />"},
						{name : "<s:interpret word='시작일시' abbr='' />"},
						{name : "<s:interpret word='완료일시' abbr='' />"},
						{name : "<s:interpret word='지시상태' abbr='' />"},
						{name : "<s:interpret word='완료유형' abbr='' />"},
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
			$("#order-grid").on("click", ".btn-select", function() {
				var data = $("#order-grid").grid("getData", this);
				Dialog.close(data);
			});
			$(".btn-close").click(function() {
				Dialog.cancel();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/order/getList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), { delYn : "N" })
				, function(data) {
					$("#order-grid").grid("draw", data);
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
		<h2><s:interpret word='지시' abbr='' /></h2>
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
						<label class="label-text"><s:interpret word='지시유형' abbr='' /></label>
						<input type="text" name="orderTypeCd" placeholder="<s:interpret word='지시유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시일자' abbr='' /></label>
						<input type="text" name="orderDate" placeholder="<s:interpret word='지시일자' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시트레이수' abbr='' /></label>
						<input type="text" name="orderTrayQty" placeholder="<s:interpret word='지시트레이수' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='처리트레이수' abbr='' /></label>
						<input type="text" name="workTrayQty" placeholder="<s:interpret word='처리트레이수' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='시작일시' abbr='' /></label>
						<input type="text" name="orderStartDt" placeholder="<s:interpret word='시작일시' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='완료일시' abbr='' /></label>
						<input type="text" name="orderEndDt" placeholder="<s:interpret word='완료일시' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시상태' abbr='' /></label>
						<input type="text" name="orderStatusCd" placeholder="<s:interpret word='지시상태' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='완료유형' abbr='' /></label>
						<input type="text" name="orderFinishTypeCd" placeholder="<s:interpret word='완료유형' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="order-grid"></div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="order-grid">
<tr>
	<td>@{orderId}</td>
	<td>@{orderTypeCd}</td>
	<td>@{orderDate}</td>
	<td>@{orderTrayQty}</td>
	<td>@{workTrayQty}</td>
	<td>@{orderStartDt}</td>
	<td>@{orderEndDt}</td>
	<td>@{orderStatusCd}</td>
	<td>@{orderFinishTypeCd}</td>
	<td><button type="button" class="btn-select"><s:interpret word='선택' abbr='' /></button></td>
</tr>
</script>
</body>
</html>