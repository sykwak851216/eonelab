<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.TrayCurrent = (function($){
		var init = function(){
			initData();
			$("#tray-current-grid").grid({
				header:[
					[
						{name : "<s:interpret word='NO' abbr='' />"},
						{name : "<s:interpret word='Rack번호' abbr='' />"},
						{name : "<s:interpret word='보관일자' abbr='' />"},
						{name : "<s:interpret word='보관일' abbr='' />"},
						{name : "<s:interpret word='Line' abbr='' />"},
						{name : "<s:interpret word='Shelf' abbr='' />"},
						{name : "<s:interpret word='Floor' abbr='' />"},
						{name : "<s:interpret word='Column' abbr='' />"}
					]
				]
				, height : "650px"
			});
			_setForm();
			_bindEvent();
			list();
			//setTimeout(list, 200);
		}
		, _bindEvent = function(){
			// [조회]
			$(".btn-srch").on("touchend click", function(e){
				e.preventDefault();
				list();
			});
		}
		, _setForm = function(){
			//$("#totalCount").text("0");
		}
		, initData = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/getSystemSetting'/>", {}, function(data) {
				$("#expirationDay").val(data.maxExpirationDay);
			});
		}
		, list = function(){
			var _param = $(".function-area").find("select, input").serializeObject();
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getRackInTrayList'/>", _param, function(list) {
				$("#totalCount").text(list.length);
				$("#tray-current-grid").grid("draw", list, function(row){
				});
			});
		}
		;
		init();
		return {
			list : list
		}
	})(jQuery);
});
</script>
<style>
.sfp-grid tbody tr.warning td{ background-color: #F5ACAF; }
</style>

<main>
	<header>
		<h2><s:interpret word='현황 - Rack 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area  horizontal">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='Line번호' abbr='' /></label>
						<select name="lineNo" id="lineNo">
							<option value="">-전체-</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
						</select>
					</span>
					<span>
						<label class="label-text"><s:interpret word='Floor' abbr='' /></label>
						<select name="rackCellYAxis" id="rackCellYAxis">
							<option value="">-전체-</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
							<option value="13">13</option>
							<option value="14">14</option>
							<option value="15">15</option>
							<option value="16">16</option>
						</select>
					</span>
					<span>
						<label class="label-text"><s:interpret word='Rack번호' abbr='' /></label>
						<input type="text" name="trayId" id="trayId" placeholder="<s:interpret word='Rack번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='보관일수' abbr='' /></label>
						<input type="text" name="expirationDay" id="expirationDay" placeholder="<s:interpret word='보관일수' abbr='' />" data-valid='number'>
						<label class="label-text"><s:interpret word='일 이상' abbr='' /></label>
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="tray-current-grid"></div>
<!-- 			<div class="footer-wrap"></div> -->
		</section>
		<footer>
			<div class="footer-wrap">
				<div class="footer-title">
					<span>총 :<strong id="totalCount"></strong> 건</span>
				</div>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="tray-current-grid">
<tr class="@{expirationDayOver}">
	<td>@{rowNum}</td>
	<td>@{trayId}</td>
	<td>@{inputDate}</td>
	<td>@{storageDay}</td>
	<td>@{lineNo}</td>
	<td>@{rackId}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{rackCellXAxis}</td>
</tr>
</script>
