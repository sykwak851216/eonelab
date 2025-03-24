<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.WorkPlanTrayCrud = (function($){
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
				, height : "500px"
				, addClasses : "small"
				, isCRUD : true
				, isFocus : true
			});
			_setForm();
			_bindEvent();
			list();
		}
		, _setForm = function(){

		}
		, _bindEvent = function(){
			$(".btn-save").click(function() {
				_saveList();
			});
			$(".btn-cancel").click(function() {
				Dialog.cancel();
			});
			$(".grid-line-add").click(function() {
				$("#work-plan-tray-grid").grid("addRows", {});
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/getList'/>", null
				, function(list) {
					$("#work-plan-tray-grid").grid("draw", list, function(row){
						row.propReadonly = row.planNo != undefined ? 'readonly="readonly"' : "";
					});
			});
		}
		, _saveList = function(){
			var $contents = $("#work-plan-tray-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
					alert("저장에 성공하였습니다.");
					Dialog.close();
				});
			}
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
			</div>
			<div id="work-plan-tray-grid"></div>
			<div class="table-btn-wrap">
				<button class="grid-line-add"><s:interpret word='추가 등록' abbr='' /></button>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-cancel"><s:interpret word='닫기' abbr='' /></button>
				<button class="btn-save blue"><s:interpret word='저장' abbr='' /></button>
			</div>
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
