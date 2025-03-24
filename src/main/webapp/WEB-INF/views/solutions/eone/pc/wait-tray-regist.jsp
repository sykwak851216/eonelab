<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.EOrderType" %>
<%@ page import="com.s3s.solutions.eone.define.ETrayStatus" %>
<%@ page import="com.s3s.solutions.eone.define.ELocType" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<script>
$(function(){
	window.WaitTrayRegist = (function($){
		var init = function(){
			$("#wait-tray-regist-grid").grid({
				header:[
					[
						{name : "<s:interpret word='Rack번호' abbr='' /><span class='required'></span>", width: "160px"},
						{name : "<s:interpret word='보관일자' abbr='' />", width: "100px"},
						{name : "<s:interpret word='보관일수' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Line번호' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Shelf' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Floor' abbr='' />", width: "80px"},
						{name : "<s:interpret word='Column' abbr='' />", width: "80px"},
						{name : "<s:interpret word='유효성 검사결과' abbr='' />"}
					]
				]
				, height : "560px"
				, addClasses : "small"
				, isCRUD : true
				, isFocus : true
			});
			_setForm();
			_bindEvent();
		}
		, _bindEvent = function(){
			// [조회]
			
			$(".grid-line-add").click(function() {
				var params = {}
				$('#wait-tray-regist-grid').grid("addRows", params, _convert);
			});
			//[등록] 버튼 클릭 시
			$(".btn-add").on("touchend click", function(e){
				e.preventDefault();
				_registTray();
			});
			//[닫기] 버튼 클릭 시
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
		}
		, _setForm = function(){
			/*
			BoxTag.selectBox.draw([
				{
					selector : "#orderTypeCd",
					firstTxt : "업무유형",
					masterCd : "order_type_cd"
				}
			]);
			*/
		}
		, _convert = function(data){
// 			data.groupReadonly = data.guideGroupCd != undefined ? 'readonly="readonly"' : "";

// 			if(data.guideCd != ''){
// 				data.guideCdReadonly = 'readonly="readonly"';
// 			}

// 			data.functionReadonly = data.functionCd != undefined ? 'readonly="readonly"' : "";
		}
		, _doDisabledTrue = function(){
			$(".btn-regist").attr("disabled", true);
			$(".btn-all-check-y").attr("disabled", true);
			$(".btn-all-check-n").attr("disabled", true);
		}
		, _doDisabledFalse = function(){
			$(".btn-regist").attr("disabled", false);
			$(".btn-all-check-y").attr("disabled", false);
			$(".btn-all-check-n").attr("disabled", false);
		}
		, _registTray = function(){
			//업무유형체크
			if ($("#orderTypeCd").val() == '') {
				alert("업무유형을 선택해주세요.");
				return;
			}
			//긴급여부체크
			if ($("#emergencyYn").val() == '') {
				alert("긴급여부를 선택해주세요.");
				return;
			}

			var $contents = $("#wait-tray-regist-grid");
			if($contents.validate()){
				var gridData = $contents.grid("getDataListCRUD");
				if (gridData.length > 0) {
					$.each(gridData, function(index, item){
						item.emergencyYn = $("#emergencyYn").val();
						item.orderTypeCd = $("#orderTypeCd").val();
					});
				} else if (gridData.length == 0) {
					alert("등록할 Rack을 입력해 주세요.");
					return;
				}
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/registerWaitTrayList'/>", gridData, function(data) {
					console.log("data", data);
					if (data.result === "200") {
						alert(SfpUtils.getPhrase("msg-054"));
						location.href="<c:url value='/solutions/eone/pc/wait-tray-list.tmpage' />";
					} else {
						$('#wait-tray-regist-grid').grid("clear");
						$.each(data.list, function (index, item) {
							$('#wait-tray-regist-grid').grid("addRows", item, _convert);
						});
					}
				});
			}
		}
		;
		init();
		return {
		}
	})(jQuery);
});
</script>
<style>
.sfp-grid tbody tr.warning td{ background-color: #F5ACAF; }
.sfp-grid.small input[type="text"]{width: 80% !important;}
</style>

<main class="pop-view">
	<header>
		<h2><s:interpret word='대기 Rack 수기 등록' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area  horizontal">
				<div class="align-left">
					<select name="orderTypeCd" id="orderTypeCd">
						<option value="">업무유형</option>
						<option value="OUTPUT">폐기</option>
						<option value="INQUIRY">호출</option>
					</select>
					<select name="emergencyYn" id="emergencyYn">
						<option value="">긴급여부</option>
						<option value="N">일반</option>
						<option value="Y">긴급</option>
					</select>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="wait-tray-regist-grid"></div>
			<div class="table-btn-wrap">
				<button class="grid-line-add"><s:interpret word='추가 등록' abbr='' /></button>
			</div>
		</section>
		<footer>
			<div class="align-right">
				<button class="btn-add"><s:interpret word='등록' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="wait-tray-regist-grid">
<tr>
	<td><input type="text" name="trayId" placeholder="<s:interpret word='Rack번호' abbr='' />" data-valid-max-size='30' data-required="true" value="@{trayId}"/></td>
	<td>@{inputDate}</td>
	<td>@{storageDay}</td>
	<td>@{lineNo}</td>
	<td>@{rackId}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{validateResult}</td>
</tr>
</script>
