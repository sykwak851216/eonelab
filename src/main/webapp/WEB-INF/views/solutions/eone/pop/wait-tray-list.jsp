<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.EOrderType" %>
<%@ page import="com.s3s.solutions.eone.define.ETrayStatus" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<script>
$(function(){
	window.TrayList = (function($){
		var params = Dialog.getParams();
		var init = function(){
			$("#wait-tray-list-grid").grid({
				header:[
					[
						{name : "<s:interpret word='순서' abbr='' />", width: "80px"},
						{name : "<s:interpret word='그룹번호' abbr='' />"},
						{name : "<s:interpret word='업무구분' abbr='' />", width: "120px"},
						{name : "<s:interpret word='긴급' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Rack번호' abbr='' />", width: "180px"},
						{name : "<s:interpret word='보관일자' abbr='' />", width: "140px"},
						{name : "<s:interpret word='보관일수' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Shelf' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Floor' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Column' abbr='' />", width: "140px"}
					]
				]
				, height : "580px"
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

			$(".btn-srch").on("touchend click", function(e){
				list();
			});
		}
		, _setForm = function(){
			$("#orderTypeCd").val(params.orderTypeCd);
		}
		, list = function(){
			// 지시유형이 출고인 등록된 트레이 목록
			var _param = {};
			_param.lineNo = params.lineNo;
			_param.trayStatusCd = params.trayStatusCd;
			_param.cancelYn = 'N';
			_param.orderTypeCd = $("#orderTypeCd").val();

			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/getWorkPlanTrayListByLineNo'/>", _param, function(list) {
				$("#wait-tray-list-grid").grid("draw", list, function(row){

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
		<h2><s:interpret word='현황 > 대기 Rack 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area horizontal">
				<div class="align-left">
					<input type="hidden" name="lineNo" id="lineNo" value=''/>
					<span>
						<label class="label-text"><s:interpret word='업무유형' abbr='' /></label>
						<select name="orderTypeCd" id="orderTypeCd">
							<option value="">전체</option>
							<option value="OUTPUT">폐기업무</option>
							<option value="INQUIRY">호출업무</option>
						</select>
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="wait-tray-list-grid"></div>
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

<script type="text/sfp-template" data-model="wait-tray-list-grid">
<tr class="@{expirationDayOver}">
	<td>@{rowNum}</td>
	<td>@{planGroupNo}</td>
	<td>@{orderTypeNameCache}</td>
	<td>@{emergencyYn}</td>
	<td>@{showPopTrayId}</td>
	<td>@{inputDate}</td>
	<td>@{storageDay}</td>
	<td>@{rackId}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{rackCellXAxis}</td>
</tr>
</script>
