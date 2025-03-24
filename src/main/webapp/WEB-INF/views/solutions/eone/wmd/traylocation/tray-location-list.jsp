<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.TrayLocationList = (function($){
		var init = function(){
			$("#tray-location-grid").grid({
				header:[
					[
						{name : "<s:interpret word='트레이번호' abbr='' />"},
						{name : "<s:interpret word='입고일자' abbr='' />"},
						{name : "<s:interpret word='위치유형' abbr='' />"},
						{name : "<s:interpret word='버퍼번호' abbr='' />"},
						{name : "<s:interpret word='랙셀ID' abbr='' />"},
						{name : "<s:interpret word='랙ID' abbr='' />"},
						{name : "<s:interpret word='렉셀X축' abbr='' />"},
						{name : "<s:interpret word='렉셀Y축' abbr='' />"},
						{name : "<s:interpret word='작업' abbr='' />", width : "120px"}
					]
				]
				, addClasses : "small"
			});
			$(".footer-wrap").pager({"click" : list, "btnSearch" : ".btn-srch"});
			_setForm();
			_bindEvent();
		}
		, _setForm = function(){

		}
		, _bindEvent = function(){
			$(".btn-srch").click(function() {
				list();
			});
			$("#tray-location-grid").on("click", ".btn-mod", function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/traylocation/tray-location-modify.dialog' />",750, $("#tray-location-grid").grid("getData", this), function(){
					list();
				});
			});
			$(".btn-add").click(function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/traylocation/tray-location-add.dialog' />",750, null, function(){
					list();
				});
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#tray-location-grid").grid("draw", data.list, function(row){

					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, deleteList = function(){
			var paramList = [];
			$("#tray-location-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { trayId : $("#tray-location-grid").grid("getData", this).trayId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='트레이 위치' abbr='' /></h2>
	</header>

	<div class="contents-wrap no-footer">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='트레이번호' abbr='' /></label>
						<input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='입고일자' abbr='' /></label>
						<input type="text" name="inputDate" placeholder="<s:interpret word='입고일자' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='위치유형' abbr='' /></label>
						<input type="text" name="locTypeCd" placeholder="<s:interpret word='위치유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='버퍼번호' abbr='' /></label>
						<input type="text" name="bufferId" placeholder="<s:interpret word='버퍼번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀ID' abbr='' /></label>
						<input type="text" name="rackCellId" placeholder="<s:interpret word='랙셀ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙ID' abbr='' /></label>
						<input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='렉셀X축' abbr='' /></label>
						<input type="text" name="rackCellXAxis" placeholder="<s:interpret word='렉셀X축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='렉셀Y축' abbr='' /></label>
						<input type="text" name="rackCellYAxis" placeholder="<s:interpret word='렉셀Y축' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right">
					<button class="btn-add ico"><s:interpret word='등록' abbr='' /></button>
				</div>
			</div>
			<div id="tray-location-grid"></div>
			<div class="footer-wrap"></div>
		</section>
<!-- 		<footer> -->
<!-- 			<div class="footer-wrap"></div> -->
<!-- 		</footer> -->
	</div>
</main>

<script type="text/sfp-template" data-model="tray-location-grid">
<tr>
	<td>@{trayId}</td>
	<td>@{inputDate}</td>
	<td>@{expirationDay}</td>
	<td>@{locTypeCd}</td>
	<td>@{bufferId}</td>
	<td>@{rackCellId}</td>
	<td>@{rackId}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{rackCellYAxis}</td>
	<td><button type="button" class="btn-mod"><s:interpret word='수정' abbr='' /></button></td>
</tr>
</script>
