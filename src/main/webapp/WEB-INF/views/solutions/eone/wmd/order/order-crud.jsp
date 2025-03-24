<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderCrud = (function($){
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
				$("#order-grid").grid("addRows", {});
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/order/getList'/>", null
				, function(list) {
					$("#order-grid").grid("draw", list, function(row){
						row.propReadonly = row.orderId != undefined ? 'readonly="readonly"' : "";
					});
			});
		}
		, _saveList = function(){
			var $contents = $("#order-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/order/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
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
		<h2><s:interpret word='지시' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
			</div>
			<div id="order-grid"></div>
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
