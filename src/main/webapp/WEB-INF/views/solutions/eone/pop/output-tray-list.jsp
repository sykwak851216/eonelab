<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.EOrderType" %>
<%@ page import="com.s3s.solutions.eone.define.ETrayStatus" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<script>
$(function(){

	window.TrayList = (function($){
		var lineNo = Dialog.getParams();
		var init = function(){
			$("#output-tray-list-grid").grid({
				header:[
					[
						{name : "<s:interpret word='순서' abbr='' />", width: "80px"},
						{name : "<s:interpret word='긴급' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Rack번호' abbr='' />"},
						{name : "<s:interpret word='보관일자' abbr='' />", width: "140px"},
						{name : "<s:interpret word='보관일수' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Shelf' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Floor' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Column' abbr='' />", width: "140px"}
					]
				]
				, height : "620px"
// 				, addClasses : "big"
			});
			_setForm();
			_bindEvent();
			list();
		}
		, _bindEvent = function(){
			//[닫기] 버튼 클릭 시
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
		}
		, _setForm = function(){

		}
		, list = function(){
			// 지시유형이 출고인 등록된 트레이 목록
			var _param = { lineNo: lineNo, orderTypeCd : '<%=EOrderType.OUTPUT.name()%>', trayStatusCd : '<%=ETrayStatus.READY.name()%>' };
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/getWorkPlanTrayListByLineNo'/>", _param, function(list) {
				$("#output-tray-list-grid").grid("draw", list, function(row){

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

<main class="pop-view">
	<header>
		<h2><s:interpret word='폐기업무 > Rack 목록' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div id="output-tray-list-grid"></div>
		</section>
		<footer>
			<div class="align-left"></div>
			<div class="align-center"></div>
			<div class="align-right">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="output-tray-list-grid">
<tr class="@{expirationDayOver}">
	<td data-template-checked name="emergencyYn"></td>
	<td>@{trayId}</td>
	<td>@{inputDate}</td>
	<td>@{storageDay}</td>
	<td>@{rackId}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{rackCellXAxis}</td>
</tr>
</script>
