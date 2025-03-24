<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.EOrderType" %>
<%@ page import="com.s3s.solutions.eone.define.ETrayStatus" %>
<%@ page import="com.s3s.solutions.eone.define.ELocType" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<script>
$(function(){
	var params = Dialog.getParams();
	window.OutputTrayRegist = (function($){
		var init = function(){
			$("#output-tray-regist-grid").grid({
				header:[
					[
						{name : "<s:interpret word='Rack번호' abbr='' /><span class='required'></span>"},
						{name : "<s:interpret word='보관일자' abbr='' />", width: "140px"},
						{name : "<s:interpret word='보관일수' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Line번호' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Shelf' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Floor' abbr='' />", width: "140px"},
						{name : "<s:interpret word='Column' abbr='' />", width: "140px"}
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
				$('#output-tray-regist-grid').grid("addRows", params, _convert);
				
				//현재목록에 있는 렉인지 확인
				
				$(".btn-srch").off("click");
				$(".btn-srch").on("click" , function() {
					_getTray($(this).closest('tr'));
				});
			});
			//[등록] 버튼 클릭 시
			$(".btn-regist").on("touchend click", function(e){
				e.preventDefault();
				//저장 불가한 렉이 있는지 확인
				_registTray();
			});
			//[닫기] 버튼 클릭 시
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
		}
		, _setForm = function(){

		}
		, _convert = function(data){
			data.groupReadonly = data.guideGroupCd != undefined ? 'readonly="readonly"' : "";

			if(data.guideCd != ''){
				data.guideCdReadonly = 'readonly="readonly"';
			}

			data.functionReadonly = data.functionCd != undefined ? 'readonly="readonly"' : "";
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
		, _getTray = function($tr){
			var param = $("#output-tray-regist-grid").grid("getData", $tr)
			console.log("param", $($tr).find('td'));
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getTrayLocation'/>", param, function(data) {
				if (data) {
					console.log("data", data);
					$($tr).find('td').eq(2).text(data.inputDate); //보관일자
					$($tr).find('td').eq(3).text(data.storageDay); //보관일수
					$($tr).find('td').eq(4).text(data.lineNo); //Line번호
					$($tr).find('td').eq(5).text(data.rackId); //Shelf
					$($tr).find('td').eq(6).text(data.rackCellYAxis); //Floor
					$($tr).find('td').eq(7).text(data.rackCellXAxis); //Column
				} else {
					MessageBox.message("해당 렉이 없습니다.", { isAutoHide : true });
				}
			});
		}
		, _registTray = function(){
			var $contents = $("#output-tray-regist-grid");
			if($contents.validate()){
				var gridData = $contents.grid("getDataListCRUD");
				if (gridData.length > 0) {
					$.each(gridData, function(index, item){
						item.emergencyYn = $("#emergencyYn").val();
					});
				}
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/registerOutputTrayList'/>", gridData, function(data) {
					MessageBox.message("저장에 성공하였습니다.", { isAutoHide : true });
					Dialog.close();
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
.sfp-grid.small input[type="text"]{width: 80% !important; */}
</style>

<main class="pop-view">
	<header>
		<h2><s:interpret word='폐기업무 > Rack 등록' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area  horizontal">
				<div class="align-left">
					<select name="emergencyYn" id="emergencyYn">
						<option value="N">일반</option>
						<option value="Y">긴급</option>
					</select>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="output-tray-regist-grid"></div>
			<div class="table-btn-wrap">
				<button class="grid-line-add"><s:interpret word='추가 등록' abbr='' /></button>
			</div>
		</section>
		<footer>
			<div class="align-right">
				<!-- 
				<label class="label-text"><s:interpret word='선택된' abbr='' /></label>
				<label class="label-text" style="font-weight: bold; color:#000; font-size: 20px;" id="checkedTrayCount">0</label>
				<label class="label-text" style="padding-right: 10px;"><s:interpret word='개의 Rack 폐기' abbr='' /></label>
				 -->
				<button class="btn-regist"><s:interpret word='등록' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="output-tray-regist-grid">
<tr>
	<td><input type="text" name="trayId" placeholder="<s:interpret word='Rack번호' abbr='' />" data-valid-max-size='30' data-required="true"/><button class='btn-srch'><s:interpret word='조회' abbr='' /></button></td>
	<td>@{inputDate}</td>
	<td>@{storageDay}</td>
	<td>@{lineNo}</td>
	<td>@{rackId}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{rackCellXAxis}</td>
</tr>
</script>
