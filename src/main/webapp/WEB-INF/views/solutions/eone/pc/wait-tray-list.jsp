<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.EOrderType" %>
<%@ page import="com.s3s.solutions.eone.define.ETrayStatus" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<script>
$(function(){
	window.WaitTrayList = (function($){
		var init = function(){
			$("#wait-tray-list-grid").grid({
				header:[
					[
						{name : "<s:interpret word='선택' abbr='' />", width: "60px"},
						{name : "<s:interpret word='그룹번호' abbr='' />"},
						{name : "<s:interpret word='등록No' abbr='' />", width: "180px"},
						{name : "<s:interpret word='업무유형' abbr='' />", width: "80px"},
						{name : "<s:interpret word='긴급여부' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Rack번호' abbr='' />", width: "120px"},
						{name : "<s:interpret word='보관일자' abbr='' />", width: "140px"},
						{name : "<s:interpret word='보관일수' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Line번호' abbr='' />", width: "100px"},
						{name : "<s:interpret word='Shelf번호' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Floor' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Column' abbr='' />", width: "80px"},
						{name : "<s:interpret word='등록구분' abbr='' />", width: "80px"},
						{name : "<s:interpret word='삭제여부' abbr='' />", width: "80px"}
					]
				]
				, height : "620px"
// 				, addClasses : "big"
			});
			_setForm();
			_bindEvent();
			$(".footer-wrap").pager({"click" : list, "btnSearch" : ".btn-srch"});
			//list();
			
		}
		, _bindEvent = function(){
			//[등록취소] 버튼 클릭 시
			$(".btn-cancel").on("click", function(e){
				e.preventDefault();
				var paramList = [];
				$("input:checkbox[name=choice]:checked").each(function(){
					paramList[paramList.length] = $("#wait-tray-list-grid").grid("getData", this).planNo;
				});

				if(paramList.length <= 0){
					//MessageBox.alarm("", { isAutoHide : true });
					//alert(SfpUtils.getPhrase("msg-055"));
					alert("삭제 할 Rack을 선택해주세요.");
					return;
				}

				SfpAjax.ajaxRequestBody("<c:url value='/solutions/eone/wmd/workplantray/deleteWorkPlantray'/>", { planNoList : paramList }, function(data) {
					alert(SfpUtils.getPhrase("msg-055"));
					list();
				});
			});

			//[선택] 체크박스 클릭 시
			$("#wait-tray-list-grid").on("touchend click", "input[type=checkbox]", function() {
				$("#checkedTrayCount").text($("input[type=checkbox]:checked").length);
			});

			// Rack 등록 클릭 시
			$(".btn-add").on("touchend click", function(e){
				e.preventDefault();
				location.href="<c:url value='/solutions/eone/pc/wait-tray-regist.tmpage' />"
			});

			/*
			$(".btn-srch").on("touchend click", function(e){
				e.preventDefault();
				list();
			});
			*/
		}
		, _setForm = function(){
			var now = moment();
			var tomorrow = moment().add(1,'d');

			$("#stRegDt").val(now.format('YYYY-MM-DD'));
			$("#edRegDt").val(tomorrow.format('YYYY-MM-DD'));
			
			var $select = $("#stRegTm, #edRegTm");
			var selected = "";
			for (var hr = 0; hr < 24; hr++) {
				var hrStr = hr.toString().padStart(2, "0") + ":";
				var val = hrStr + "00";
				if (hr===0) selected = "selected";
				$select.append('<option value="'+ val + '"' + selected + '>' + val + '</option>');
				selected = "";
				val = hrStr + "30";
				$select.append('<option value="'+ val + '">' + val + '</option>');
			}
			
			var $select = $("#stRegTm, #edRegTm");
			var selected = "";
			for (var hr = 0; hr < 24; hr++) {
				var hrStr = hr.toString().padStart(2, "0") + ":";
				var val = hrStr + "00";
				if (hr===0) selected = "selected";
				$select.append('<option value="'+ val + '"' + selected + '>' + val + '</option>');
				selected = "";
				val = hrStr + "30";
				$select.append('<option value="'+ val + '">' + val + '</option>');
			}

			BoxTag.selectBox.draw([
				{
					selector : "#orderTypeCd",
					firstTxt : "업무유형",
					masterCd : "order_type_cd"
				}
			]);
		}
		, list = function(paging){
			if ($("#stRegDt").val() != '' || $("#stRegTm").val() != '' || $("#edRegDt").val() != '' || $("#edRegTm").val() != '') {
				if ($("#stRegDt").val() == '') {
					alert("검색시작일자를 선택해주세요");
					return;
				}

				if ($("#stRegTm").val() == '') {
					alert("검색시작시간을 선택해주세요");
					return;
				}

				if ($("#edRegDt").val() == '') {
					alert("검색종료일자를 선택해주세요");
					return;
				}

				if ($("#edRegTm").val() == '') {
					alert("검색종료시간을 선택해주세요");
					return;
				}

				var startDttm = $("#stRegDt").val() + "" + $("#stRegTm").val();
				var endDttm = $("#edRegDt").val() + "" + $("#edRegTm").val();

				if (startDttm > endDttm) {
					alert("검색시작일시가 검색종료일시보다 늦을 수 없습니다.");
					return;
				}
			}

			// 지시유형이 출고인 등록된 트레이 목록
			var searchDateParam = {};
			var searchStartDt = $("#stRegDt").val() + " " + $("#stRegTm").val();
			var searchEndDt = $("#edRegDt").val() + " " + $("#edRegTm").val();

			
			if($("#stRegDt").val() != '' || $("#edRegDt").val() != '') {
				searchDateParam.searchStartDt = searchStartDt;
				searchDateParam.searchEndDt = searchEndDt;
			}
			
			var _param = $.extend($(".function-area").find("select, input").serializeObject(), searchDateParam, paging);
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/getPagingList'/>", _param, function(data) {
				$("#wait-tray-list-grid").grid("draw", data.list, function(row){
					if(row.cancelYn === 'Y' || row.excuteYn === 'Y'){
						row.disabledYn = 'disabled="disabled"';
					}
				});
				$(".footer-wrap").pager("setPage", data.paging);
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
		<h2><s:interpret word='현황 - 대기 Rack 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area horizontal">
				<div class="align-left">
					<input type="hidden" name="trayStatusCd" id="trayStatusCd" value=''/>
					<span>
						<label class="label-text"><s:interpret word='등록일시' abbr='' /></label>
						<input type="text" name="stRegDt" id="stRegDt" class="calendar" placeholder="<s:interpret word='검색시작일자' abbr='' />" data-nokeypad='true' readonly='readonly'>
						<select name="stRegTm" id="stRegTm">
							<option value=""><s:interpret word='검색시작시간' abbr='' /></option>
						</select> 
						-<input type="text" name="edRegDt" id="edRegDt" class="calendar" placeholder="<s:interpret word='검색종료일자' abbr='' />" data-nokeypad='true' readonly='readonly'>
						<select name="edRegTm" id="edRegTm">
							<option value=""><s:interpret word='검색종료시간' abbr='' /></option>
						</select>
					</span>
					<span>
						<select name="orderTypeCd" id="orderTypeCd"></select>
					</span>
					<span>
						<select name="emergencyYn" id="emergencyYn">
							<option value="">긴급여부</option>
							<option value="N">N</option>
							<option value="Y">Y</option>
						</select>
					</span>
					<span>
						<input type="text" name="trayId" id="trayId" placeholder="<s:interpret word='Rack번호' abbr='' />">
					</span>
					<span>
						<select name="lineNo" id="lineNo">
							<option value="">라인번호</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
						</select>
					</span>
					<span>
						<select name="cancelYn" id="cancelYn">
							<option value="">삭제여부</option>
							<option value="N">N</option>
							<option value="Y">Y</option>
						</select>
					</span>
					<span>
						<select name="orderKindCd" id="orderKindCd">
							<option value="">등록구분</option>
							<option value="INTERFACE">IF</option>
							<option value="HADNWRITE">수기</option>
						</select>
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
					
				</div>
				<div class="align-center"></div>
				<div class="align-right"><button class="btn-add"><s:interpret word='Rack 등록' abbr='' /></button></div>
			</div>
			<div id="wait-tray-list-grid"></div>
			<div class="footer-wrap"></div>
		</section>
		<footer>
			<div class="align-left"></div>
			<div class="align-center"></div>
			<div class="align-right">
				<label class="label-text" style="color:#000; padding: 10px 5px;"><s:interpret word='선택된 Rack' abbr='' /></label>
				<button class="btn-cancel"><s:interpret word='삭제' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="wait-tray-list-grid">
<tr>
	<td><label><input type="checkbox" name="choice" @{disabledYn}><span class="check-mark"></span></label></td>	
	<td>@{planGroupNo}</td>	
	<td>@{planNo}</td>
	<td>@{orderTypeNameCache}</td>
	<td>@{emergencyYn}</td>
	<td>@{trayId}</td>
	<td>@{inputDate}</td>
	<td>@{storageDay}</td>
	<td>@{lineNo}</td>
	<td>@{rackNameCache}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{orderKindNameCache}</td>
	<td>@{cancelYn}</td>
</tr>
</script>
