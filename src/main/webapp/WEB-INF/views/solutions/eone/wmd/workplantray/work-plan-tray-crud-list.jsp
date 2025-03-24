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
						{name : "<s:interpret word='계획번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='트레이번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시유형' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시순서' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='긴급여부' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='입고일자' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙셀x축' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙셀y축' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='실행여부' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='트레이상태' abbr='' /><span class='required'></span>"},
					]
				]
				, addClasses : "small"
				, isCRUD : true
				, isFocus : true
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
			$(".btn-save").click(function() {
				_saveList();
			});
			$(".btn-add").click(function() {
				$("#work-plan-tray-grid").grid("addRows", {});
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
						row.propReadonly = row.planNo != undefined ? 'readonly="readonly"' : "";
					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, _saveList = function(){
			var $contents = $("#work-plan-tray-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
					alert("저장에 성공하였습니다.");
					list();
				});
			}
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
			</div>
			<div class="function-area no-border">
				<div class="align-right">
					<button class="btn-add ico"><s:interpret word='추가' abbr='' /></button>
					<button class="btn-save ico"><s:interpret word='저장' abbr='' /></button>
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
	<td><input type="text" name="planNo" placeholder="<s:interpret word='계획번호' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="orderTypeCd" placeholder="<s:interpret word='지시유형' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="trayOrderSort" placeholder="<s:interpret word='지시순서' abbr='' />" data-valid-max-size='23' data-required="true"   /></td>
	<td><input type="text" name="emergencyYn" placeholder="<s:interpret word='긴급여부' abbr='' />" data-valid-max-size='1' data-required="true"   /></td>
	<td><input type="text" name="inputDate" placeholder="<s:interpret word='입고일자' abbr='' />" data-valid-max-size='10' data-required="true"   /></td>
	<td><input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀x축' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀y축' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><input type="text" name="excuteYn" placeholder="<s:interpret word='실행여부' abbr='' />" data-valid-max-size='1' data-required="true"   /></td>
	<td><input type="text" name="trayStatusCd" placeholder="<s:interpret word='트레이상태' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
</tr>
</script>
