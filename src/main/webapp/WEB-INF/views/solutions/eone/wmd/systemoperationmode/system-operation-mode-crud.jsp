<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.SystemOperationModeCrud = (function($){
		var init = function(){
			$("#system-operation-mode-grid").grid({
				header:[
					[
						{name : "<s:interpret word='시스템동작모드ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드명' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='시스템동작모드설명' abbr='' />"},
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
				$("#system-operation-mode-grid").grid("addRows", { delYn : "N" });
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmode/getList'/>", null
				, function(list) {
					$("#system-operation-mode-grid").grid("draw", list, function(row){
						row.propReadonly = row.systemOperationModeId != undefined ? 'readonly="readonly"' : "";
					});
			});
		}
		, _saveList = function(){
			var $contents = $("#system-operation-mode-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmode/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
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
		<h2><s:interpret word='시스템 동작 모드' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
			</div>
			<div id="system-operation-mode-grid"></div>
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

<script type="text/sfp-template" data-model="system-operation-mode-grid">
<tr>
	<td><input type="text" name="systemOperationModeId" placeholder="<s:interpret word='시스템동작모드ID' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="systemOperationModeName" placeholder="<s:interpret word='시스템동작모드명' abbr='' />" data-valid-max-size='100' data-required="true"   /></td>
	<td><input type="text" name="systemOperationModeDesc" placeholder="<s:interpret word='시스템동작모드설명' abbr='' />" data-valid-max-size='4000'    /></td>
	<td><select name="delYn" class="delYn"></select></td>
</tr>
</script>
