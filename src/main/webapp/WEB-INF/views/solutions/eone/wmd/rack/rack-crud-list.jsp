<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.RackList = (function($){
		var init = function(){
			$("#rack-grid").grid({
				header:[
					[
						{name : "<s:interpret word='랙ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙명' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙X축 사이즈' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙Y축 사이즈' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='창고ID' abbr='' />"},
						{name : "<s:interpret word='설비ID' abbr='' />"},
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
				$("#rack-grid").grid("addRows", { delYn : "N" });
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/rack/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#rack-grid").grid("draw", data.list, function(row){
						row.propReadonly = row.rackId != undefined ? 'readonly="readonly"' : "";
					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, _saveList = function(){
			var $contents = $("#rack-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/rack/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
					alert("저장에 성공하였습니다.");
					list();
				});
			}
		}
		, deleteList = function(){
			var paramList = [];
			$("#rack-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { rackId : $("#rack-grid").grid("getData", this).rackId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/rack/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='랙' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='랙ID' abbr='' /></label>
						<input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙명' abbr='' /></label>
						<input type="text" name="rackName" placeholder="<s:interpret word='랙명' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙X축 사이즈' abbr='' /></label>
						<input type="text" name="rackXAxisSize" placeholder="<s:interpret word='랙X축 사이즈' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙Y축 사이즈' abbr='' /></label>
						<input type="text" name="rackYAxisSize" placeholder="<s:interpret word='랙Y축 사이즈' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='창고ID' abbr='' /></label>
						<input type="text" name="warehouseId" placeholder="<s:interpret word='창고ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='설비ID' abbr='' /></label>
						<input type="text" name="mcId" placeholder="<s:interpret word='설비ID' abbr='' />">
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
			<div id="rack-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="rack-grid">
<tr>
	<td><input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="rackName" placeholder="<s:interpret word='랙명' abbr='' />" data-valid-max-size='100' data-required="true"   /></td>
	<td><input type="text" name="rackXAxisSize" placeholder="<s:interpret word='랙X축 사이즈' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><input type="text" name="rackYAxisSize" placeholder="<s:interpret word='랙Y축 사이즈' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><input type="text" name="warehouseId" placeholder="<s:interpret word='창고ID' abbr='' />" data-valid-max-size='30'    /></td>
	<td><input type="text" name="mcId" placeholder="<s:interpret word='설비ID' abbr='' />" data-valid-max-size='30'    /></td>
	<td><select name="delYn" class="delYn"></select></td>
</tr>
</script>
