<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.MachineStatusHistoryCrud = (function($){
		var init = function(){
			$("#machine-status-history-grid").grid({
				header:[
					[
						{name : "<s:interpret word='이력번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='설비ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='설비상태코드' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='상태시작일시' abbr='' /><span class='required'></span>"},
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
				$("#machine-status-history-grid").grid("addRows", { delYn : "N" });
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/machinestatushistory/getList'/>", null
				, function(list) {
					$("#machine-status-history-grid").grid("draw", list, function(row){
						row.propReadonly = row.historySeq != undefined ? 'readonly="readonly"' : "";
					});
			});
		}
		, _saveList = function(){
			var $contents = $("#machine-status-history-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/machinestatushistory/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
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
		<h2><s:interpret word='설비 상태 이력' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
			</div>
			<div id="machine-status-history-grid"></div>
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

<script type="text/sfp-template" data-model="machine-status-history-grid">
<tr>
	<td><input type="text" name="historySeq" placeholder="<s:interpret word='이력번호' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="mcId" placeholder="<s:interpret word='설비ID' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="mcStatusCd" placeholder="<s:interpret word='설비상태코드' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><select name="delYn" class="delYn"></select></td>
</tr>
</script>
