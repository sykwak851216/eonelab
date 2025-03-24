<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderGroupCrud = (function($){
		var init = function(){
			$("#order-group-grid").grid({
				header:[
					[
						{name : "<s:interpret word='지시그룹번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시그룹유형' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시그룹일자' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시그룹시작일시' abbr='' />"},
						{name : "<s:interpret word='지시그룹완료일시' abbr='' />"},
						{name : "<s:interpret word='지시그룹상태코드' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='지시그룹완료유형' abbr='' /><span class='required'></span>"},
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
				$("#order-group-grid").grid("addRows", {});
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/getList'/>", null
				, function(list) {
					$("#order-group-grid").grid("draw", list, function(row){
						row.propReadonly = row.orderGroupId != undefined ? 'readonly="readonly"' : "";
					});
			});
		}
		, _saveList = function(){
			var $contents = $("#order-group-grid");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/saveList'/>", $contents.grid("getDataListCRUD"), function(data) {
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
		<h2><s:interpret word='지시그룹' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
			</div>
			<div id="order-group-grid"></div>
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

<script type="text/sfp-template" data-model="order-group-grid">
<tr>
	<td><input type="text" name="orderGroupId" placeholder="<s:interpret word='지시그룹번호' abbr='' />" data-valid-max-size='30' data-required="true"  @{propReadonly} /></td>
	<td><input type="text" name="orderGroupTypeCd" placeholder="<s:interpret word='지시그룹유형' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="orderGroupDate" placeholder="<s:interpret word='지시그룹일자' abbr='' />" data-valid-max-size='10' data-required="true"   /></td>
	<td><input type="text" name="orderGroupStartDt" placeholder="<s:interpret word='지시그룹시작일시' abbr='' />" data-valid-max-size='23'    /></td>
	<td><input type="text" name="orderGroupEndDt" placeholder="<s:interpret word='지시그룹완료일시' abbr='' />" data-valid-max-size='23'    /></td>
	<td><input type="text" name="orderGroupStatusCd" placeholder="<s:interpret word='지시그룹상태코드' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
	<td><input type="text" name="orderGroupFinishTypeCd" placeholder="<s:interpret word='지시그룹완료유형' abbr='' />" data-valid-max-size='30' data-required="true"   /></td>
</tr>
</script>
