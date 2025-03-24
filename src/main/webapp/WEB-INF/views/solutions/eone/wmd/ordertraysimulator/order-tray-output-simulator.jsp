<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderTrayList = (function($){
		var init = function(){
			$("#order-tray-grid").grid({
				header:[
					[
						{name : "<s:interpret word='TRAY계획번호' abbr='' />"},
						{name : "<s:interpret word='지시번호' abbr='' />"},
						{name : "<s:interpret word='버퍼번호' abbr='' />"},
						{name : "<s:interpret word='입출유형' abbr='' />"},
						{name : "<s:interpret word='트레이번호' abbr='' />"},
						{name : "<s:interpret word='랙ID' abbr='' />"},
						{name : "<s:interpret word='랙셀x축' abbr='' />"},
						{name : "<s:interpret word='랙셀y축' abbr='' />"}
					]
				]
				, addClasses : "small"
			});
			_setForm();
			_bindEvent();
		}
		, _setForm = function(){

		}
		, _bindEvent = function(){
			$("#normalOutput").click(function() {
				$("#order-tray-grid").grid('clear');
				generateNormal();
			});
			$("#inquiryOutput").click(function() {
				$("#order-tray-grid").grid('clear');
				generateInquiry();
			});
		}
		, generateNormal = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordertraysimulator/generateOutputOrderTraySimulator'/>",
				{}
				, function(data) {
					if(data){
						$("#order-tray-grid").grid("draw", data, function(row){
						});
						alert("order tray 생성 완료!");
					}
			});
		}
		, generateInquiry = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordertraysimulator/generateInquiryOutputOrderTraySimulator'/>",
				{}
				, function(data) {
					if(data){
						$("#order-tray-grid").grid("draw", data, function(row){
						});
						alert("order tray 생성 완료!");
					}
			});
		}
		init();
		return {
		}
	})(jQuery);
});

</script>
<style></style>

<main>
	<header>
		<h2><s:interpret word='출고 오더 트레이 생성 시뮬레이터' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
				</div>
				<div class="align-center"></div>
				<div class="align-right">
					<button class="btn-mod orange" id="normalOutput"><s:interpret word='출고(일반) TRAY 생성' abbr='' /></button>
					<button class="btn-mod blue" id="inquiryOutput"><s:interpret word='출고(조회) TRAY 생성' abbr='' /></button>
				</div>
			</div>
			<div id="order-tray-grid"></div>
		</section>
	</div>
</main>

<script type="text/sfp-template" data-model="order-tray-grid">
<tr>
	<td>@{planNo}</td>
	<td>@{orderId}</td>
	<td>@{bufferId}</td>
	<td>@{inOutTypeCd}</td>
	<td>@{trayId}</td>
	<td>@{rackId}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{rackCellYAxis}</td>
</tr>
</script>
