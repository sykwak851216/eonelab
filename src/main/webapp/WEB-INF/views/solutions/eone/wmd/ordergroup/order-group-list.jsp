<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderGroupList = (function($){
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
			});
			$(".footer-wrap").pager({"click" : list});
			_setForm();
			_bindEvent();
		}
		, _setForm = function(){

		}
		, _bindEvent = function(){
			$(".btn-srch").click(function() {
				list();
			});
			$("#order-group-grid").on("click", ".btn-mod", function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/ordergroup/order-group-modify.dialog' />",750, $("#order-group-grid").grid("getData", this), function(){
					list();
				});
			});
			$(".btn-add").click(function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/ordergroup/order-group-add.dialog' />",750, null, function(){
					list();
				});
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#order-group-grid").grid("draw", data.list, function(row){

					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, deleteList = function(){
			var paramList = [];
			$("#order-group-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { orderGroupId : $("#order-group-grid").grid("getData", this).orderGroupId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/deleteList'/>", paramList, function(data) {
				alert("삭제에 성공하였습니다.");
				list();
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
				<div class="align-right">
					<button class="btn-add ico"><s:interpret word='등록' abbr='' /></button>
				</div>
			</div>
			<div id="order-group-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
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
	<td><button type="button" class="btn-mod"><s:interpret word='수정' abbr='' /></button></td>
</tr>
</script>
