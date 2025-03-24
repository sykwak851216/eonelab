<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.TrayLocationChangeHistoryCrud = (function($){
		var init = function(){
			$("#tray-location-change-history-grid").grid({
				header:[
					[
						{name : "<s:interpret word='이력SEQ' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='트레이번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='출발위치유형' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='도착위치유형' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='버퍼번호' abbr='' />"},
						{name : "<s:interpret word='렉셀ID' abbr='' />"},
						{name : "<s:interpret word='랙ID' abbr='' />"},
						{name : "<s:interpret word='랙셀X축' abbr='' />"},
						{name : "<s:interpret word='랙셀Y축' abbr='' />"},
						{name : "<s:interpret word='지시번호' abbr='' />"},
						{name : "<s:interpret word='지시그룹ID' abbr='' />"},
						{name : "<s:interpret word='변경일시' abbr='' /><span class='required'></span>"},
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
				$("#tray-location-change-history-grid").grid("addRows", {});
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocationchangehistory/getList'/>", null
				, function(list) {
					$("#tray-location-change-history-grid").grid("draw", list, function(row){
						row.propReadonly = row.historySeq != undefined ? 'readonly="readonly"' : "";
					});
			});
		}
		, _saveList = function(){
			var $contents = $("#tray-location-change-history-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocationchangehistory/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
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
		<h2><s:interpret word='트레이 위치 변경 이력' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
			</div>
			<div id="tray-location-change-history-grid"></div>
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

<script type="text/sfp-template" data-model="tray-location-change-history-grid">
<tr>
	<td><input type="text" name="historySeq" placeholder="<s:interpret word='이력SEQ' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />" data-valid-max-size='100' data-required="true"   /></td>
	<td><input type="text" name="fromLocTypeCd" placeholder="<s:interpret word='출발위치유형' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="toLocTypeCd" placeholder="<s:interpret word='도착위치유형' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="bufferId" placeholder="<s:interpret word='버퍼번호' abbr='' />" data-valid-max-size='30'    /></td>
	<td><input type="text" name="rackCellId" placeholder="<s:interpret word='렉셀ID' abbr='' />" data-valid-max-size='30'    /></td>
	<td><input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />" data-valid-max-size='30'    /></td>
	<td><input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀X축' abbr='' />" data-valid-min='' data-valid-max=''  data-valid="number"  /></td>
	<td><input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀Y축' abbr='' />" data-valid-min='' data-valid-max=''  data-valid="number"  /></td>
	<td><input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />" data-valid-max-size='30'    /></td>
	<td><input type="text" name="orderGroupId" placeholder="<s:interpret word='지시그룹ID' abbr='' />" data-valid-max-size='30'    /></td>
	<td><input type="text" name="changeDt" placeholder="<s:interpret word='변경일시' abbr='' />" data-valid-max-size='23' data-required="true"   /></td>
</tr>
</script>
