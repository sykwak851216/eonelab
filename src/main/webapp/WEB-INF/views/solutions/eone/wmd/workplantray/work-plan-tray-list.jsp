<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.WorkPlanTrayList = (function($){
		var init = function(){
			$("#work-plan-tray-grid").grid({
				header:[
					[
						{name : "<s:interpret word='계획번호' abbr='' />"},
						{name : "<s:interpret word='트레이번호' abbr='' />"},
						{name : "<s:interpret word='지시유형' abbr='' />"},
						{name : "<s:interpret word='지시순서' abbr='' />"},
						{name : "<s:interpret word='긴급여부' abbr='' />"},
						{name : "<s:interpret word='입고일자' abbr='' />"},
						{name : "<s:interpret word='랙ID' abbr='' />"},
						{name : "<s:interpret word='랙셀x축' abbr='' />"},
						{name : "<s:interpret word='랙셀y축' abbr='' />"},
						{name : "<s:interpret word='실행여부' abbr='' />"},
						{name : "<s:interpret word='트레이상태' abbr='' />"},
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
			$("#work-plan-tray-grid").on("click", ".btn-mod", function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/workplantray/work-plan-tray-modify.dialog' />",750, $("#work-plan-tray-grid").grid("getData", this), function(){
					list();
				});
			});
			$(".btn-add").click(function() {
				Dialog.open("<c:url value='/solutions/eone/wmd/workplantray/work-plan-tray-add.dialog' />",750, null, function(){
					list();
				});
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#work-plan-tray-grid").grid("draw", data.list, function(row){

					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, deleteList = function(){
			var paramList = [];
			$("#work-plan-tray-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { planNo : $("#work-plan-tray-grid").grid("getData", this).planNo};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='작업 계획 트레이' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='계획번호' abbr='' /></label>
						<input type="text" name="planNo" placeholder="<s:interpret word='계획번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='트레이번호' abbr='' /></label>
						<input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시유형' abbr='' /></label>
						<input type="text" name="orderTypeCd" placeholder="<s:interpret word='지시유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시순서' abbr='' /></label>
						<input type="text" name="trayOrderSort" placeholder="<s:interpret word='지시순서' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='긴급여부' abbr='' /></label>
						<input type="text" name="emergencyYn" placeholder="<s:interpret word='긴급여부' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='입고일자' abbr='' /></label>
						<input type="text" name="inputDate" placeholder="<s:interpret word='입고일자' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙ID' abbr='' /></label>
						<input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀x축' abbr='' /></label>
						<input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀x축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀y축' abbr='' /></label>
						<input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀y축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='실행여부' abbr='' /></label>
						<input type="text" name="excuteYn" placeholder="<s:interpret word='실행여부' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='트레이상태' abbr='' /></label>
						<input type="text" name="trayStatusCd" placeholder="<s:interpret word='트레이상태' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right">
					<button class="btn-add ico"><s:interpret word='등록' abbr='' /></button>
				</div>
			</div>
			<div id="work-plan-tray-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="work-plan-tray-grid">
<tr>
	<td>@{planNo}</td>
	<td>@{trayId}</td>
	<td>@{orderTypeCd}</td>
	<td>@{trayOrderSort}</td>
	<td>@{emergencyYn}</td>
	<td>@{inputDate}</td>
	<td>@{rackId}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{excuteYn}</td>
	<td>@{trayStatusCd}</td>
	<td><button type="button" class="btn-mod"><s:interpret word='수정' abbr='' /></button></td>
</tr>
</script>
