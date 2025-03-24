<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.SystemOperationModeStepCrud = (function($){
		var init = function(){
			$("#system-operation-mode-step-grid").grid({
				header:[
					[
						{name : "<s:interpret word='시스템동작모드ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드단계ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드단계명' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드단계순서' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드단계설명' abbr='' />"},
						{name : "<s:interpret word='병행처리여부' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='삭제여부' abbr='' /><span class='required'></span>"},
					]
				]
				, height : "500px"
				, addClasses : "small"
				, isCRUD : true
				, isFocus : true
				, boxTag : [
					{
						selector : ".delYn",
						firstTxt : "-<s:interpret word='삭제여부' abbr='' />-",
						type : "selectBox",
						masterCd : "del_yn"
					}
				]
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
				$("#system-operation-mode-step-grid").grid("addRows", { delYn : "N" });
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmodestep/getList'/>", null
				, function(list) {
					$("#system-operation-mode-step-grid").grid("draw", list, function(row){
						row.propReadonly = row.systemOperationModeId != undefined ? 'readonly="readonly"' : "";
						row.propReadonly = row.systemOperationModeStepId != undefined ? 'readonly="readonly"' : "";
					});
			});
		}
		, _saveList = function(){
			var $contents = $("#system-operation-mode-step-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmodestep/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
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
		<h2><s:interpret word='시스템 동작 모드 단계' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
			</div>
			<div id="system-operation-mode-step-grid"></div>
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

<script type="text/sfp-template" data-model="system-operation-mode-step-grid">
<tr>
	<td><input type="text" name="systemOperationModeId" placeholder="<s:interpret word='시스템동작모드ID' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="systemOperationModeStepId" placeholder="<s:interpret word='시스템동작모드단계ID' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="systemOperationModeStepName" placeholder="<s:interpret word='시스템동작모드단계명' abbr='' />" data-valid-max-size='100' data-required="true"   /></td>
	<td><input type="text" name="systemOperationModeStepSort" placeholder="<s:interpret word='시스템동작모드단계순서' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><input type="text" name="systemOperationModeStepDesc" placeholder="<s:interpret word='시스템동작모드단계설명' abbr='' />" data-valid-max-size='4000'    /></td>
	<td><input type="text" name="parallelProcessYn" placeholder="<s:interpret word='병행처리여부' abbr='' />" data-valid-max-size='1' data-required="true"   /></td>
	<td><select name="delYn" class="delYn"></select></td>
</tr>
</script>
