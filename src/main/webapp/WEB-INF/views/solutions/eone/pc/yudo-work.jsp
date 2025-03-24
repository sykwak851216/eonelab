<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.EOrderType" %>
<%@ page import="com.s3s.solutions.eone.define.ETrayStatus" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<script>
$(function(){
	window.YudoWorkList = (function($){
		var init = function(){
			$("#yudo-work-tray-list-grid").grid({
				header:[
					[
						{name : "<s:interpret word='IF No' abbr='' />", width: "100px"},
						{name : "<s:interpret word='IF 일시' abbr='' />", width: "140px"},
						{name : "<s:interpret word='GB' abbr='' />", width: "60px"},
						{name : "<s:interpret word='ENT_YMD' abbr='' />", width: "100px"},
						{name : "<s:interpret word='TARGETNO' abbr='' />", width: "140px"},
						{name : "<s:interpret word='RESULT' abbr='' />", width: "140px"},
						{name : "<s:interpret word='REMARK' abbr='' />"},
						{name : "<s:interpret word='위치A' abbr='' />", width: "140px"},
						{name : "<s:interpret word='위치B' abbr='' />", width: "140px"},
						{name : "<s:interpret word='위치C' abbr='' />", width: "140px"},
						{name : "<s:interpret word='위치D' abbr='' />", width: "140px"},
						{name : "<s:interpret word='seq' abbr='' />", width: "100px"},
						{name : "<s:interpret word='rReturn' abbr='' />", width: "140px"}
					]
				]
 				, height : "620px"
// 				, addClasses : "big"
			});
			_setForm();
			_bindEvent();
			$(".footer-wrap").pager({"click" : list, "btnSearch" : ".btn-srch", "paging" : {"countPerPages" : 10}});
		}
		, _bindEvent = function(){

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
				//if (hr===0) selected = "selected";
				$select.append('<option value="'+ val + '"' + selected + '>' + val + '</option>');
				selected = "";
				val = hrStr + "30";
				$select.append('<option value="'+ val + '">' + val + '</option>');
			}
		}
		, list = function(paging){
			// 지시유형이 호출인 등록된 트레이 목록
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
			
			var searchDateParam = {};
			var searchStartDt = $("#stRegDt").val() + " " + $("#stRegTm").val();
			var searchEndDt = $("#edRegDt").val() + " " + $("#edRegTm").val();

			if($("#stRegDt").val() != '' || $("#edRegDt").val() != '') {
				searchDateParam.searchStartDt = searchStartDt;
				searchDateParam.searchEndDt = searchEndDt;
			}

			var _param = $.extend($(".function-area").find("select, input").serializeObject(), searchDateParam, paging);
			SfpAjax.ajax("<c:url value='/solutions/eone/pc/getYudoWorkPagingList'/>", _param, function(data) {
				var firstPageNum = (data.paging.number * data.paging.size)+1;
				$("#yudo-work-tray-list-grid").grid("draw", data.list, function(row){
					row.rowNum = firstPageNum++;
					//row.rowNum = (data.paging.totalElements-varStatus++) - ( (data.paging.number) * data.paging.size );
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
		<h2><s:interpret word='YUDO WORK' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area horizontal">
				<div class="align-left">
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
						<select name="rtnResult" id="rtnResult">
							<option value="">rRETURN</option>
							<option value="OK">OK</option>
							<option value="ERROR">ERROR</option>
						</select>
					</span>

					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
			</div>
			<div id="yudo-work-tray-list-grid"></div>
			<div class="footer-wrap"></div>
		</section>
	</div>
</main>

<script type="text/sfp-template" data-model="yudo-work-tray-list-grid">
<tr>
	<td>@{rowNum}</td>
	<td>@{reqDt}</td>
	<td>@{ifWorkTypeCd}</td>
	<td>@{entYmd}</td>
	<td>@{trayId}</td>
	<td>@{resultYn}</td>
	<td>@{remark}</td>
	<td>@{lineNo}</td>
	<td>@{rackId}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{seq}</td>
	<td>@{rtnResult}</td>
</tr>
</script>
