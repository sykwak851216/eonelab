<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.RackList = (function($){
		var init = function(){
			$("#rack-grid").grid({
				header:[
					[
						{name : "<s:interpret word='랙ID' abbr='' />"},
						{name : "<s:interpret word='랙명' abbr='' />"},
						{name : "<s:interpret word='랙X축 사이즈' abbr='' />"},
						{name : "<s:interpret word='랙Y축 사이즈' abbr='' />"},
						{name : "<s:interpret word='창고ID' abbr='' />"},
						{name : "<s:interpret word='설비ID' abbr='' />"},
						{name : "<s:interpret word='삭제여부' abbr='' />"},
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
			$("#rack-grid").on("click", ".btn-mod", function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/rack/rack-modify.dialog' />",750, $("#rack-grid").grid("getData", this), function(){
					list();
				});
			});
			$(".btn-add").click(function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/rack/rack-add.dialog' />",750, null, function(){
					list();
				});
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/rack/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#rack-grid").grid("draw", data.list, function(row){

					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, deleteList = function(){
			var paramList = [];
			$("#rack-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { rackId : $("#rack-grid").grid("getData", this).rackId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/rack/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='랙' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='랙ID' abbr='' /></label>
						<input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙명' abbr='' /></label>
						<input type="text" name="rackName" placeholder="<s:interpret word='랙명' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙X축 사이즈' abbr='' /></label>
						<input type="text" name="rackXAxisSize" placeholder="<s:interpret word='랙X축 사이즈' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙Y축 사이즈' abbr='' /></label>
						<input type="text" name="rackYAxisSize" placeholder="<s:interpret word='랙Y축 사이즈' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='창고ID' abbr='' /></label>
						<input type="text" name="warehouseId" placeholder="<s:interpret word='창고ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='설비ID' abbr='' /></label>
						<input type="text" name="mcId" placeholder="<s:interpret word='설비ID' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right">
					<button class="btn-add ico"><s:interpret word='등록' abbr='' /></button>
				</div>
			</div>
			<div id="rack-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="rack-grid">
<tr>
	<td>@{rackId}</td>
	<td>@{rackName}</td>
	<td>@{rackXAxisSize}</td>
	<td>@{rackYAxisSize}</td>
	<td>@{warehouseId}</td>
	<td>@{mcId}</td>
	<td name="delYn" data-grid-checked="true"></td>
	<td><button type="button" class="btn-mod"><s:interpret word='수정' abbr='' /></button></td>
</tr>
</script>
