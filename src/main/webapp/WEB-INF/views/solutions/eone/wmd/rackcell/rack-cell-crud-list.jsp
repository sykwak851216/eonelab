<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.RackCellList = (function($){
		var init = function(){
			$("#rack-cell-grid").grid({
				header:[
					[
						{name : "<s:interpret word='랙셀ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙셀명' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙셀X축' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙셀Y축' abbr='' /><span class='required'></span>"},
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
				$("#rack-cell-grid").grid("addRows", { delYn : "N" });
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/rackcell/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#rack-cell-grid").grid("draw", data.list, function(row){
						row.propReadonly = row.rackCellId != undefined ? 'readonly="readonly"' : "";
					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, _saveList = function(){
			var $contents = $("#rack-cell-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/rackcell/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
					alert("저장에 성공하였습니다.");
					list();
				});
			}
		}
		, deleteList = function(){
			var paramList = [];
			$("#rack-cell-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { rackCellId : $("#rack-cell-grid").grid("getData", this).rackCellId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/rackcell/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='랙셀' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='랙셀ID' abbr='' /></label>
						<input type="text" name="rackCellId" placeholder="<s:interpret word='랙셀ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀명' abbr='' /></label>
						<input type="text" name="rackCellName" placeholder="<s:interpret word='랙셀명' abbr='' />">
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
			<div id="rack-cell-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="rack-cell-grid">
<tr>
	<td><input type="text" name="rackCellId" placeholder="<s:interpret word='랙셀ID' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="rackCellName" placeholder="<s:interpret word='랙셀명' abbr='' />" data-valid-max-size='100' data-required="true"   /></td>
	<td><input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀X축' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀Y축' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><select name="delYn" class="delYn"></select></td>
</tr>
</script>
