<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderOperationHistoryCrud = (function($){
		var init = function(){
			$("#order-operation-history-grid").grid({
				header:[
					[
						{name : "<s:interpret word='지시번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드단계ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드단계순서' abbr='' />"},
						{name : "<s:interpret word='시작일시' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='완료일시' abbr='' />"},
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
				$("#order-operation-history-grid").grid("addRows", {});
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderoperationhistory/getList'/>", null
				, function(list) {
					$("#order-operation-history-grid").grid("draw", list, function(row){
						row.propReadonly = row.orderId != undefined ? 'readonly="readonly"' : "";
						row.propReadonly = row.systemOperationModeId != undefined ? 'readonly="readonly"' : "";
						row.propReadonly = row.systemOperationModeStepId != undefined ? 'readonly="readonly"' : "";
					});
			});
		}
		, _saveList = function(){
			var $contents = $("#order-operation-history-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderoperationhistory/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
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
		<h2><s:interpret word='지시별 동작 히스토리' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
			</div>
			<div id="order-operation-history-grid"></div>
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

<script type="text/sfp-template" data-model="order-operation-history-grid">
<tr>
	<td><input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="systemOperationModeId" placeholder="<s:interpret word='시스템동작모드ID' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="systemOperationModeStepId" placeholder="<s:interpret word='시스템동작모드단계ID' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="systemOperationModeStepSort" placeholder="<s:interpret word='시스템동작모드단계순서' abbr='' />" data-valid-min='' data-valid-max=''  data-valid="number"  /></td>
	<td><input type="text" name="operationStartDt" placeholder="<s:interpret word='시작일시' abbr='' />" data-valid-max-size='23' data-required="true"   /></td>
	<td><input type="text" name="operationEndDt" placeholder="<s:interpret word='완료일시' abbr='' />" data-valid-max-size='23'    /></td>
</tr>
</script>
