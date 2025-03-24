<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.YudoListList = (function($){
		var init = function(){
			$("#yudo-list-grid").grid({
				header:[
					[
						{name : "<s:interpret word='IF No' abbr='' />"},
						{name : "<s:interpret word='IF 일시' abbr='' />"},
						{name : "<s:interpret word='rRETURN' abbr='' />"},
						{name : "<s:interpret word='pCUR' abbr='' />"}
					]
				]
				, addClasses : "small"
				, isCRUD : false
				, isSelected : true
				, isSortable : false
				, isFocus : true
				, height : "680px"
			});
			_setForm();
			_bindEvent();
			list();
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
		}
		, _bindEvent = function(){
			$(".btn-detail").click(function() {
			});
			$("#yudo-list-grid").on("click", "table tbody td" , function(e, row, index) {
				$("#yudo-list-grid").find("table tbody tr").removeClass("selected");
				$(this).closest("tr").addClass("selected");
				var data = $("#yudo-list-grid").grid("getData", this);
				window.YudoListTrayList.list(data.ifId);
			});

			$(".btn-srch").on("touchend click", function(e){
				e.preventDefault();
				list();
			});
		}
		, refresh = function(){
			$("#yudo-list-grid").grid("refresh", null);
		}
		, list = function(){
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

			var _param = $.extend($(".function-area").find("select, input").serializeObject(), searchDateParam, {ifTypeCd : 'LIST'});
			console.log("_param", _param);
			SfpAjax.ajax("<c:url value='/solutions/eone/pc/getYudoList'/>", _param
				, function(list) {
					$("#yudo-list-grid").grid("draw", list, function(row){
						//row.propReadonly = row.masterCd != undefined ? 'readonly="readonly"' : "";
					});
			});
		};
		init();
		return {
			list : list
		}
	})(jQuery);

	window.YudoListTrayList = (function($){
		var init = function(){
			$("#yudo-list-tray-grid").grid({
				header:[
					[
						{name : "<s:interpret word='No' abbr='' />"},
						{name : "<s:interpret word='DIV' abbr='' />"},
						{name : "<s:interpret word='ENT_YMD' abbr='' />"},
						{name : "<s:interpret word='TARGETNO' abbr='' />"},
						{name : "<s:interpret word='EMER_YN' abbr='' />"},
						{name : "<s:interpret word='SEQ' abbr='' />"}
					]
				]
				, addClasses : "small"
				, isCRUD : false
				, isSelected : false
				, isSortable : false
				, isFocus : true
				, height : "680px"
			});
			_setForm();
			_bindEvent();
		}
		, _setForm = function(){
		}
		, _bindEvent = function(){

		}
		, refresh = function(){
			$("#yudo-list-tray-grid").grid("refresh", null);
		}
		, list = function(ifId){
			if(ifId !== undefined && ifId !== ""){
				SfpAjax.ajax("<c:url value='/solutions/eone/pc/getYudoTrayList'/>", { ifId : ifId}
				, function(list) {
					$("#yudo-list-tray-grid").grid("draw", list, function(row){
						//row.propReadonly = row.masterCd != undefined ? 'readonly="readonly"' : ''
					});
				});
			}
		};
		init();
		return {
			list : list
			,refresh : refresh
		}
	})(jQuery);

});

</script>
<style>
.col-2-wrap{font-size:0; margin-top: 20px;}
.col-2-wrap > div{display:inline-block;width:50%;box-sizing:border-box;vertical-align:top; }
.col-2-wrap > div + div{padding-left:20px}
</style>
<main>
	<header>
		<h2><s:interpret word='YUDO LIST' abbr='' /></h2>
		<label id="menuNo"></label>
	</header>
	<div class="contents-wrap no-footer">
		<section>
			<div class="function-area horizontal">
				<div class="align-left">
					<input type="hidden" name="orderTypeCd" id="orderTypeCd" value=''/>
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
						<select name="result" id="result">
							<option value="">rRETURN</option>
							<option value="OK">OK</option>
							<option value="ERROR">ERROR</option>
						</select>
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
			</div>

			<div class="col-2-wrap">
				<div id="yudo-list-grid"></div>
				<div id="yudo-list-tray-grid"></div>
			</div>

		</section>
	</div>
</main>

<script type="text/sfp-template" data-model="yudo-list-grid">
<tr>
	<td>@{ifId}</td>
	<td>@{reqDt}</td>
	<td>@{result}</td>
	<td><button class='btn-detail'><s:interpret word='보기' abbr='' /></button></td>
</tr>
</script>

<script type="text/sfp-template" data-model="yudo-list-tray-grid">
<tr>
	<td>@{rowNum}</td>
	<td>@{inOutTypeCd}</td>
	<td>@{entYmd}</td>
	<td>@{trayId}</td>
	<td>@{emergencyYn}</td>
	<td>@{seq}</td>
</tr>
</script>
