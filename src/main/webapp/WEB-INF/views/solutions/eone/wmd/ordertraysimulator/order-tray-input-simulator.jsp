<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.InputTrayList = (function($){
		var init = function(){
			$("#input-tray-grid").grid({
				header:[
					[
						{name : "<s:interpret word='버퍼ID' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='TRAYID' abbr='' /><span class='required'></span>"}
					]
				]
				, addClasses : "small"
				, isSelected : true
				, isSortable : true
				, isFocus : true
			});
			_setForm();
			_bindEvent();
			drawDefaultData();
		}
		, _setForm = function(){

		}
		, _bindEvent = function(){
			$(".master .btn-save").click(function() {
				generateInput();
			});
		}
		, generateInput = function(){
			var $contents = $("#input-tray-grid");
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordertraysimulator/generateInputOrderTraySimulator'/>",
				$contents.grid("getDataList")
				, function(data) {
					if(data){
						InputTrayResultList.list(data);
					}
			});
		}
		, drawDefaultData = function(){
			var data = [
				{bufferId : "1", trayId : "TRAY0001"},
				{bufferId : "2", trayId : "TRAY0002"},
				{bufferId : "3", trayId : "TRAY0003"},
				{bufferId : "4", trayId : "TRAY0004"},
				{bufferId : "5", trayId : "TRAY0005"},
				{bufferId : "6", trayId : "TRAY0006"},
				{bufferId : "7", trayId : "TRAY0007"},
				{bufferId : "8", trayId : "TRAY0008"}
			]
			$("#input-tray-grid").grid("draw", data, function(row){
			});
		}
		init();
		return {
			drawDefaultData : drawDefaultData
		}
	})(jQuery);

	window.InputTrayResultList = (function($){
		var init = function(){
			$("#order-tray-grid").grid({
				header:[
					[
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
			$(".slave .btn-save").click(function() {
				$("#order-tray-grid").grid('clear');
			});
		}
		, list = function(data){
			$("#order-tray-grid").grid("draw", data, function(row){
			});
			alert("order tray 생성 완료!");
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
		<h2><s:interpret word='출고 오더 트레이 생성 시뮬레이터' abbr='' /></h2>
		<label id="menuNo"></label>
	</header>

	<div class="contents-wrap no-footer master" style="width:30%;">
		<section>
			<div class="function-area no-border">
				<div class="align-right">
					<button class="btn-save ico"><s:interpret word='입고 TRAY 생성' abbr='' /></button>
				</div>
			</div>
			<div id="input-tray-grid"></div>
		</section>
	</div>
	<div class="contents-wrap no-footer slave" style="width:70%;">
		<section>
			<div class="function-area no-border">
				<div class="align-right">
					 <button class="btn-save ico"><s:interpret word='초기화' abbr='' /></button>
				</div>
			</div>
			<div id="order-tray-grid"></div>
		</section>
	</div>
</main>

<script type="text/sfp-template" data-model="input-tray-grid">
<tr>
	<td><input type="text" name="bufferId" @{propReadonly} value="@{bufferId}" data-required="true" maxbyte="50"/></td>
	<td><input type="text" name="trayId" value="@{masterName}" data-required="true" maxbyte="30" label="<s:interpret word='trayId' abbr='' />" /></td>
</tr>
</script>

<script type="text/sfp-template" data-model="order-tray-grid">
<tr>
	<td>@{orderId}</td>
	<td>@{bufferId}</td>
	<td>@{inOutTypeCd}</td>
	<td>@{trayId}</td>
	<td>@{rackId}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{rackCellYAxis}</td>
</tr>
</script>