<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.TrayLocationChangeHistoryList = (function($){
		var init = function(){
			$("#tray-location-change-history-grid").grid({
				header:[
					[
						{name : "<s:interpret word='이력SEQ' abbr='' />"},
						{name : "<s:interpret word='트레이번호' abbr='' />"},
						{name : "<s:interpret word='출발위치유형' abbr='' />"},
						{name : "<s:interpret word='도착위치유형' abbr='' />"},
						{name : "<s:interpret word='버퍼번호' abbr='' />"},
						{name : "<s:interpret word='렉셀ID' abbr='' />"},
						{name : "<s:interpret word='랙ID' abbr='' />"},
						{name : "<s:interpret word='랙셀X축' abbr='' />"},
						{name : "<s:interpret word='랙셀Y축' abbr='' />"},
						{name : "<s:interpret word='지시번호' abbr='' />"},
						{name : "<s:interpret word='지시그룹ID' abbr='' />"},
						{name : "<s:interpret word='변경일시' abbr='' />"},
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
			$("#tray-location-change-history-grid").on("click", ".btn-mod", function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/traylocationchangehistory/tray-location-change-history-modify.dialog' />",750, $("#tray-location-change-history-grid").grid("getData", this), function(){
					list();
				});
			});
			$(".btn-add").click(function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/traylocationchangehistory/tray-location-change-history-add.dialog' />",750, null, function(){
					list();
				});
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocationchangehistory/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#tray-location-change-history-grid").grid("draw", data.list, function(row){

					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, deleteList = function(){
			var paramList = [];
			$("#tray-location-change-history-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { historySeq : $("#tray-location-change-history-grid").grid("getData", this).historySeq};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocationchangehistory/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='트레이 위치 변경 이력' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='이력SEQ' abbr='' /></label>
						<input type="text" name="historySeq" placeholder="<s:interpret word='이력SEQ' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='트레이번호' abbr='' /></label>
						<input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='출발위치유형' abbr='' /></label>
						<input type="text" name="fromLocTypeCd" placeholder="<s:interpret word='출발위치유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='도착위치유형' abbr='' /></label>
						<input type="text" name="toLocTypeCd" placeholder="<s:interpret word='도착위치유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='버퍼번호' abbr='' /></label>
						<input type="text" name="bufferId" placeholder="<s:interpret word='버퍼번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='렉셀ID' abbr='' /></label>
						<input type="text" name="rackCellId" placeholder="<s:interpret word='렉셀ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙ID' abbr='' /></label>
						<input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀X축' abbr='' /></label>
						<input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀X축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀Y축' abbr='' /></label>
						<input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀Y축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시번호' abbr='' /></label>
						<input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시그룹ID' abbr='' /></label>
						<input type="text" name="orderGroupId" placeholder="<s:interpret word='지시그룹ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='변경일시' abbr='' /></label>
						<input type="text" name="changeDt" placeholder="<s:interpret word='변경일시' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right">
					<button class="btn-add ico"><s:interpret word='등록' abbr='' /></button>
				</div>
			</div>
			<div id="tray-location-change-history-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="tray-location-change-history-grid">
<tr>
	<td>@{historySeq}</td>
	<td>@{trayId}</td>
	<td>@{fromLocTypeCd}</td>
	<td>@{toLocTypeCd}</td>
	<td>@{bufferId}</td>
	<td>@{rackCellId}</td>
	<td>@{rackId}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{orderId}</td>
	<td>@{orderGroupId}</td>
	<td>@{changeDt}</td>
	<td><button type="button" class="btn-mod"><s:interpret word='수정' abbr='' /></button></td>
</tr>
</script>
