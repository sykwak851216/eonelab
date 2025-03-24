<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderWorkList = (function($){
		var init = function(){
			$("#order-work-grid").grid({
				header:[
					[
						{name : "<s:interpret word='작업번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='버퍼번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='입출유형' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='트레이번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙셀x축' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='랙셀y축' abbr='' /><span class='required'></span>"},
					]
				]
				, addClasses : "small"
				, isCRUD : true
				, isFocus : true
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
				$("#order-work-grid").grid("addRows", {});
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderwork/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#order-work-grid").grid("draw", data.list, function(row){
						row.propReadonly = row.workId != undefined ? 'readonly="readonly"' : "";
					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, _saveList = function(){
			var $contents = $("#order-work-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderwork/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
					alert("저장에 성공하였습니다.");
					list();
				});
			}
		}
		, deleteList = function(){
			var paramList = [];
			$("#order-work-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { workId : $("#order-work-grid").grid("getData", this).workId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/orderwork/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='지시별 작업 내역' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='작업번호' abbr='' /></label>
						<input type="text" name="workId" placeholder="<s:interpret word='작업번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시번호' abbr='' /></label>
						<input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='버퍼번호' abbr='' /></label>
						<input type="text" name="bufferId" placeholder="<s:interpret word='버퍼번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='입출유형' abbr='' /></label>
						<input type="text" name="inOutTypeCd" placeholder="<s:interpret word='입출유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='트레이번호' abbr='' /></label>
						<input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙ID' abbr='' /></label>
						<input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀x축' abbr='' /></label>
						<input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀x축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀y축' abbr='' /></label>
						<input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀y축' abbr='' />">
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
			<div id="order-work-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="order-work-grid">
<tr>
	<td><input type="text" name="workId" placeholder="<s:interpret word='작업번호' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="bufferId" placeholder="<s:interpret word='버퍼번호' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="inOutTypeCd" placeholder="<s:interpret word='입출유형' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀x축' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀y축' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
</tr>
</script>
