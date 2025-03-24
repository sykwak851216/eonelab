<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.SystemOperationModeList = (function($){
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
				$("#system-operation-mode-grid").grid("addRows", { delYn : "N" });
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmode/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#system-operation-mode-grid").grid("draw", data.list, function(row){
						row.propReadonly = row.systemOperationModeId != undefined ? 'readonly="readonly"' : "";
					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, _saveList = function(){
			var $contents = $("#system-operation-mode-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmode/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
					alert("저장에 성공하였습니다.");
					list();
				});
			}
		}
		, deleteList = function(){
			var paramList = [];
			$("#system-operation-mode-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { systemOperationModeId : $("#system-operation-mode-grid").grid("getData", this).systemOperationModeId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmode/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='시스템 동작 모드' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='시스템동작모드ID' abbr='' /></label>
						<input type="text" name="systemOperationModeId" placeholder="<s:interpret word='시스템동작모드ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='시스템동작모드명' abbr='' /></label>
						<input type="text" name="systemOperationModeName" placeholder="<s:interpret word='시스템동작모드명' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='시스템동작모드설명' abbr='' /></label>
						<input type="text" name="systemOperationModeDesc" placeholder="<s:interpret word='시스템동작모드설명' abbr='' />">
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
			<div id="system-operation-mode-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
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
