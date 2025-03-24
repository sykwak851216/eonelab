<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderGroupSearch = (function($){
		var init = function(){
			$("#order-group-grid").grid({
				header:[
					[
						{name : "<s:interpret word='지시그룹번호' abbr='' />"},
						{name : "<s:interpret word='지시그룹유형' abbr='' />"},
						{name : "<s:interpret word='지시그룹일자' abbr='' />"},
						{name : "<s:interpret word='지시그룹시작일시' abbr='' />"},
						{name : "<s:interpret word='지시그룹완료일시' abbr='' />"},
						{name : "<s:interpret word='지시그룹상태코드' abbr='' />"},
						{name : "<s:interpret word='지시그룹완료유형' abbr='' />"},
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
			$("#order-group-grid").on("click", ".btn-select", function() {
				var data = $("#order-group-grid").grid("getData", this);
				Dialog.close(data);
			});
			$(".btn-close").click(function() {
				Dialog.cancel();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/getList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), { delYn : "N" })
				, function(data) {
					$("#order-group-grid").grid("draw", data);
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
		<h2><s:interpret word='지시그룹' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='지시그룹번호' abbr='' /></label>
						<input type="text" name="orderGroupId" placeholder="<s:interpret word='지시그룹번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시그룹유형' abbr='' /></label>
						<input type="text" name="orderGroupTypeCd" placeholder="<s:interpret word='지시그룹유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시그룹일자' abbr='' /></label>
						<input type="text" name="orderGroupDate" placeholder="<s:interpret word='지시그룹일자' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시그룹시작일시' abbr='' /></label>
						<input type="text" name="orderGroupStartDt" placeholder="<s:interpret word='지시그룹시작일시' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시그룹완료일시' abbr='' /></label>
						<input type="text" name="orderGroupEndDt" placeholder="<s:interpret word='지시그룹완료일시' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시그룹상태코드' abbr='' /></label>
						<input type="text" name="orderGroupStatusCd" placeholder="<s:interpret word='지시그룹상태코드' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시그룹완료유형' abbr='' /></label>
						<input type="text" name="orderGroupFinishTypeCd" placeholder="<s:interpret word='지시그룹완료유형' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="order-group-grid"></div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="order-group-grid">
<tr>
	<td>@{orderGroupId}</td>
	<td>@{orderGroupTypeCd}</td>
	<td>@{orderGroupDate}</td>
	<td>@{orderGroupStartDt}</td>
	<td>@{orderGroupEndDt}</td>
	<td>@{orderGroupStatusCd}</td>
	<td>@{orderGroupFinishTypeCd}</td>
	<td><button type="button" class="btn-select"><s:interpret word='선택' abbr='' /></button></td>
</tr>
</script>
</body>
</html>