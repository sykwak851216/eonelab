<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.TrayCurrent = (function($){
		var lineNo = Dialog.getParams();
		var init = function(){
			initData();
			$("#rack-current-by-line-grid").grid({
				header:[
					[
						{name : "<s:interpret word='NO' abbr='' />"},
						{name : "<s:interpret word='Rack번호' abbr='' />"},
						{name : "<s:interpret word='보관일자' abbr='' />"},
						{name : "<s:interpret word='보관일수' abbr='' />"},
						{name : "<s:interpret word='위치유형' abbr='' />"},
						{name : "<s:interpret word='Shelf' abbr='' />"},
						{name : "<s:interpret word='Floor' abbr='' />"},
						{name : "<s:interpret word='Column' abbr='' />"},
						{name : "<s:interpret word='Cell' abbr='' />"}
					]
				]
				, height : "590px"
				, isSortable : true
			});
			_setForm();
			_bindEvent();
			setTimeout(list, 200);
		}
		, _bindEvent = function(){
			// [조회]
			$(".btn-srch").on("touchend click", function(e){
				e.preventDefault();
				list();
			});
			// [닫기]
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
		}
		, _setForm = function(){

			BoxTag.selectBox.draw([
				{
					selector : "#locTypeCd",
					firstTxt : "-전체-",
					masterCd : "loc_type_cd"
				}
			]);
		}
		, initData = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/getSystemSetting'/>", {lineNo : lineNo}, function(data) {
				$("#expirationDay").val(data.maxExpirationDay);
			});
		}
		, list = function(){
			$("#lineNo").val(lineNo);
			var _param = $(".function-area").find("select, input").serializeObject();
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getList'/>", _param, function(list) {
				$("#rack-current-by-line-grid").grid("draw", list, function(row){

				});
				$("#totalCount").html(list.length);

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
.total-count {font-size: 18px;}
</style>

<main class="pop-view">
	<header>
		<h2><s:interpret word='Line 별 Rack 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area  horizontal">
				<div class="align-left">
					<input type="hidden" name="lineNo" id="lineNo" value=''/>
					<span>
						<label class="label-text"><s:interpret word='Rack번호' abbr='' /></label>
						<input type="text" name="trayId" id="trayId" placeholder="<s:interpret word='Rack번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='보관일수' abbr='' /></label>
						<input type="text" name="expirationDay" id="expirationDay" placeholder="<s:interpret word='보관일수' abbr='' />" data-valid='number'>
						<label class="label-text"><s:interpret word='일 이상' abbr='' /></label>
					</span>
					<span>
						<label class="label-text"><s:interpret word='위치유형' abbr='' /></label>
						<select name="locTypeCd" id="locTypeCd"></select>
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="rack-current-by-line-grid"></div>
			<div class="footer-wrap">
				<div class="footer-title">Total <strong id="totalCount">0</strong></div>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="rack-current-by-line-grid">
<tr class="@{expirationDayOver}">
	<td>@{rowNum}</td>
	<td>@{showPopTrayId}</td>
	<td>@{inputDate}</td>
	<td>@{storageDay}</td>
	<td>@{locTypeNameCache}</td>
	<td>@{rackNameCache}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{bufferId}</td>
</tr>
</script>
