<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.MachineStatusHistoryList = (function($){
		var init = function(){
			$("#machine-status-history-grid").grid({
				header:[
					[
						{name : "<s:interpret word='이력번호' abbr='' />"},
						{name : "<s:interpret word='설비ID' abbr='' />"},
						{name : "<s:interpret word='설비상태코드' abbr='' />"},
						{name : "<s:interpret word='상태시작일시' abbr='' />"},
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
			$("#machine-status-history-grid").on("click", ".btn-mod", function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/machinestatushistory/machine-status-history-modify.dialog' />",750, $("#machine-status-history-grid").grid("getData", this), function(){
					list();
				});
			});
			$(".btn-add").click(function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/machinestatushistory/machine-status-history-add.dialog' />",750, null, function(){
					list();
				});
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/machinestatushistory/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#machine-status-history-grid").grid("draw", data.list, function(row){

					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, deleteList = function(){
			var paramList = [];
			$("#machine-status-history-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { historySeq : $("#machine-status-history-grid").grid("getData", this).historySeq};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/machinestatushistory/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='설비 상태 이력' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='이력번호' abbr='' /></label>
						<input type="text" name="historySeq" placeholder="<s:interpret word='이력번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='설비ID' abbr='' /></label>
						<input type="text" name="mcId" placeholder="<s:interpret word='설비ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='설비상태코드' abbr='' /></label>
						<input type="text" name="mcStatusCd" placeholder="<s:interpret word='설비상태코드' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right">
					<button class="btn-add ico"><s:interpret word='등록' abbr='' /></button>
				</div>
			</div>
			<div id="machine-status-history-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="machine-status-history-grid">
<tr>
	<td>@{historySeq}</td>
	<td>@{mcId}</td>
	<td>@{mcStatusCd}</td>
	<td name="delYn" data-grid-checked="true"></td>
	<td><button type="button" class="btn-mod"><s:interpret word='수정' abbr='' /></button></td>
</tr>
</script>
