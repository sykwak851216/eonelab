<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderList = (function($){
		var init = function(){
			$("#order-grid").grid({
				header:[
					[
						{name : "<s:interpret word='지시번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시유형' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시일자' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시트레이수' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='처리트레이수' abbr='' />"},
						{name : "<s:interpret word='시작일시' abbr='' />"},
						{name : "<s:interpret word='완료일시' abbr='' />"},
						{name : "<s:interpret word='지시상태' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='완료유형' abbr='' /><span class='required'></span>"},
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
				$("#order-grid").grid("addRows", {});
			});
			$(".btn-del").click(function() {
				deleteList();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/order/getPagingList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), paging)
				, function(data) {
					$("#order-grid").grid("draw", data.list, function(row){
						row.propReadonly = row.orderId != undefined ? 'readonly="readonly"' : "";
					});
					$(".footer-wrap").pager("setPage", data.paging);
			});
		}
		, _saveList = function(){
			var $contents = $("#order-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/order/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
					alert("저장에 성공하였습니다.");
					list();
				});
			}
		}
		, deleteList = function(){
			var paramList = [];
			$("#order-grid input[type='checkbox']:checked").each(function(){
				paramList[paramList.length] = { orderId : $("#order-grid").grid("getData", this).orderId};
			});
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/order/deleteList'/>", paramList, function(data) {
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
		<h2><s:interpret word='지시' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='지시번호' abbr='' /></label>
						<input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시유형' abbr='' /></label>
						<input type="text" name="orderTypeCd" placeholder="<s:interpret word='지시유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시일자' abbr='' /></label>
						<input type="text" name="orderDate" placeholder="<s:interpret word='지시일자' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시트레이수' abbr='' /></label>
						<input type="text" name="orderTrayQty" placeholder="<s:interpret word='지시트레이수' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='처리트레이수' abbr='' /></label>
						<input type="text" name="workTrayQty" placeholder="<s:interpret word='처리트레이수' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='시작일시' abbr='' /></label>
						<input type="text" name="orderStartDt" placeholder="<s:interpret word='시작일시' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='완료일시' abbr='' /></label>
						<input type="text" name="orderEndDt" placeholder="<s:interpret word='완료일시' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시상태' abbr='' /></label>
						<input type="text" name="orderStatusCd" placeholder="<s:interpret word='지시상태' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='완료유형' abbr='' /></label>
						<input type="text" name="orderFinishTypeCd" placeholder="<s:interpret word='완료유형' abbr='' />">
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
			<div id="order-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="order-grid">
<tr>
	<td><input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="orderTypeCd" placeholder="<s:interpret word='지시유형' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="orderDate" placeholder="<s:interpret word='지시일자' abbr='' />" data-valid-max-size='10' data-required="true"   /></td>
	<td><input type="text" name="orderTrayQty" placeholder="<s:interpret word='지시트레이수' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number"  /></td>
	<td><input type="text" name="workTrayQty" placeholder="<s:interpret word='처리트레이수' abbr='' />" data-valid-min='' data-valid-max=''  data-valid="number"  /></td>
	<td><input type="text" name="orderStartDt" placeholder="<s:interpret word='시작일시' abbr='' />" data-valid-max-size='23'    /></td>
	<td><input type="text" name="orderEndDt" placeholder="<s:interpret word='완료일시' abbr='' />" data-valid-max-size='23'    /></td>
	<td><input type="text" name="orderStatusCd" placeholder="<s:interpret word='지시상태' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="orderFinishTypeCd" placeholder="<s:interpret word='완료유형' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
</tr>
</script>
