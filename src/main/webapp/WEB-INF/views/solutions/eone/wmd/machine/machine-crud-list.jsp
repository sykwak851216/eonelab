<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.MachineList = (function($){
		var init = function(){
			$("#machine-grid").grid({
				header:[
					[
						{name : "<s:interpret word='설비ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='설비명' abbr='' /><span class='required'></span>"},
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
				$("#machine-grid").grid("addRows", { delYn : "N" });
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/machine/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#machine-grid").grid("draw", data.list, function(row){
						row.propReadonly = row.mcId != undefined ? 'readonly="readonly"' : "";
					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, _saveList = function(){
			var $contents = $("#machine-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/machine/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
					alert("저장에 성공하였습니다.");
					list();
				});
			}
		}
		, deleteList = function(){
			var paramList = [];
			$("#machine-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { mcId : $("#machine-grid").grid("getData", this).mcId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/machine/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='설비' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='설비ID' abbr='' /></label>
						<input type="text" name="mcId" placeholder="<s:interpret word='설비ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='설비명' abbr='' /></label>
						<input type="text" name="mcName" placeholder="<s:interpret word='설비명' abbr='' />">
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
			<div id="machine-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="machine-grid">
<tr>
	<td><input type="text" name="mcId" placeholder="<s:interpret word='설비ID' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="mcName" placeholder="<s:interpret word='설비명' abbr='' />" data-valid-max-size='100' data-required="true"   /></td>
	<td><select name="delYn" class="delYn"></select></td>
</tr>
</script>
