<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.ELocType" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/sfp/sfp-ui-messagebox.css' />">
<script>
$(function(){
	window.InputTrayDischarge = (function($){
		//var lineNo = Dialog.getParams();
		var _params = Dialog.getParams();
		console.log("보관 배출 start", _params);
		var bufferPositionId = "";
		var init = function(){
			_setForm();
			_bindEvent();
			setOperationHistory();
			isBufferOnWorkingstation();
			bufferPositionId = setInterval(isBufferOnWorkingstation, 1000);
			gatheringBufferSensor();
			setInterval(gatheringBufferSensor, 1000);// 1초당 한번씩 갱신 처리
		}
		, _bindEvent = function(){
			$("#closeForce").on("touchend click", function(e){
				e.preventDefault();
				closeForce();
			});
			$("#inputComplte").on("touchend click", function(e){
				e.preventDefault();
				inputComplte();
			});
		}
		, _setForm = function(){

		}
		, list = function(){
			var param = {};
			param.orderId = params.ingOrder.orderId;
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getBufferTrayLocationListIncludeSensorAndInqueryQty'/>", param, function(data) {
				$("#buffer-current-template > li span").text("");

				data.forEach(function(element){
					var $li = $("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0'))
					if(element.sensor == "1"){
						$li.find("span.status").addClass("sensing");
					}else if(element.sensor == "0"){
						$li.find("span.status").removeClass("sensing");
					}
					$li.find("input").val(element.inquiryQty);
					$li.find("span").text(element.trayId);

					//TRAY ID가 있으면 셋팅하고 없으면 초기화!
					_isValidText(element.trayId) == true ? $li.data('tray-id', element.trayId) : $li.removeData('tray-id');
					//조회 수량 셋팅
					$li.data('inquiry-qty', element.inquiryQty);
				});
			});
		}
		, closeForce = function(){
			var inTrayList = [];
			$("#buffer-current-template li").each(function(e){
				var $this = $(this);
				var bufferId = $this.data("bufferId");

				if(_checkSensing($this)){
					inTrayList.push({
						bufferId : bufferId
					});
				}
			});

			if(inTrayList.length > 0){
				MessageBox.confirm("배출 할 Rack이 " + inTrayList.length + "개 있습니다.\n창을 닫으시겠습니까?", {cbFn : function(){
					Dialog.close();
				}});
			}
		}
		, inputComplte = function(){
			console.log("_params", _params);

			if(!_isValidText(_params.ingOrder) || !_isValidText(_params.ingOrder.orderId)){
				MessageBox.message("지시번호를 체크 해주세요!", { isAutoHide : true });
			}

			var returnResult = false;
			var param = {};
			param.orderGroupId = _params.ingOrder.orderGroupId;
			param.orderId = _params.ingOrder.orderId;
			param.lineNo = _params.ingOrder.lineNo;
			param.orderTrayList = [];

			$("#buffer-current-template li").each(function(e){
				var $this = $(this);
				var bufferId = $this.data("bufferId");

				//TRAY가 있는데 센서가 꺼진 경우!
				if(_checkSensing($this)){
					returnResult = true;
					MessageBox.message("스캔오류 제거를 완료할 수 없습니다.\n스캔오류가 발생한 Rack을 제거하세요.", { isAutoHide : true });
					return false;
				}

				//TRAY 목록 담기!
				param.orderTrayList.push({
					bufferId : bufferId
				});

			})

			if(returnResult){
				return;
			}

			SfpAjax.ajaxRequestBody("<c:url value='/solutions/eone/wmd/order/dischargeInputOrderTray'/>", param, function(data) {
				Dialog.close()
			});
		}
		// buffer censing 조회
		, gatheringBufferSensor = function(){
			var checkParam = {};
			checkParam.orderGroupId = _params.orderGroupId;
			checkParam.orderGroupTypeCd = _params.orderGroupTypeCd;
			checkParam.orderTypeCd = _params.ingOrder.orderTypeCd;
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/isDialogOpenStatus'/>", checkParam, function(data) {
				if (data) {
					SfpAjax.ajax("<c:url value='/solutions/eone/wmd/buffer/getBufferSensorsByLineNo'/>", {lineNo : _params.lineNo} , function(data) {
						if(data){
							data.forEach(function(element, idx){
								if(element.sensor === "1"){
									$("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0')).find("span.status").addClass("sensing");
								}else if(element.sensor === "0"){
									$("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0')).find("span.status").removeClass("sensing");
								}
							});
						}
					});
				} else {
					Dialog.close();
					return;
				}
			});
			
			
		}
		, _checkSensing = function(selector){
			return selector.find("span.status").hasClass("sensing");
		}
		, _isValidText = function(text){
			return text != undefined && text !=null && String(text).trim().length > 0;
		}
		//buffer 위치 확인
		, isBufferOnWorkingstation = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/isBufferOnWorkingstationByLineNo'/>", {lineNo : _params.lineNo} , function(data) {
				if(data){
					clearInterval(bufferPositionId);
					$("#buffer").show();
					$("#move-progress").hide();
				}else{
					$("#buffer").hide();
					$("#move-progress").show();
				}
			});
		}
		, setOperationHistory = function(){
			var param = {};
			param.orderGroupId = _params.ingOrder.orderGroupId;
			param.orderGroupTypeCd = _params.orderGroupTypeCd;
			param.orderId = _params.ingOrder.orderId;
			param.lineNo = _params.ingOrder.lineNo;
			
			SfpAjax.ajaxRequestBody("<c:url value='/solutions/eone/wmd/order/changeOperationDischargeInputOrderTray'/>", param , function(data) {
				
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
.fix-card h3 {
	padding-left: 10px;
	padding-top: 10px;
}
.fix-card .card-cont{
	min-height: 80px;
	height: 80px;
	line-height: 60px;
	display: flex;
	align-items: center;
}
.fix-card.two-col > ul > li{ cursor: pointer; }

.fix-card .card-cont span{ font-size: 30px; padding-left: 10px; }
.fix-card .card-cont .card-cont-left{ width: 80%; float: left; padding-left: 10px; }
.fix-card .card-cont .card-cont-right{ width:20%; float: right; padding-left: 10px; }
.fix-card .card-cont .card-cont-right button{ margin-top: 13px; }
.fix-card .card-cont .card-cont-left input[type='text']{ width: 25%; margin-left: 20px; }
.fix-card.two-col > ul > li {
	width: 32%;
	border: 5px solid #fff;
}
.fix-card.two-col > ul > li.selected {
	background-color: #F89406;
	color: #fff;
}

.status{ background-color: #fff; border:1px solid #9e9e9f; }

.fix-card .card-cont span{ font-size: 30px; padding-left: 10px;}
.sensing h3{ background-color: #219244; color: #fff; }

.fix-card h3 .status { margin-top: -14px; }
.fix-card .status { width: 25px; height: 25px; }
.fix-card .status.sensing { background-color: #219244; border:1px solid #219244; }

.fix-card.oee-list.two-col{ display: none; }
.progress-block{ width : 100%; height: 670px; line-height: 600px; text-align: center; position:relative; }
.progress-block span{ font-size: 20px; }
.progress-block img {
	position:absolute;
	max-width:100%; max-height:100%;
	width:auto; height:auto;
	margin:auto;
	top:0; bottom:0; left:0; right:0;
}
.btn-choice{
	display: none;
}
</style>
<main class="pop-view">
	<header>
		<h2><s:interpret word='보관업무 > 스캔오류제거' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div id="buffer" class="fix-card oee-list two-col">
				<ul id="buffer-current-template">
					<li id="BC-010" data-buffer-id="10"><h3>BC-010<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-011" data-buffer-id="11"><h3>BC-011<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-012" data-buffer-id="12"><h3>BC-012<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-007" data-buffer-id="7" ><h3>BC-007<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-008" data-buffer-id="8" ><h3>BC-008<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-009" data-buffer-id="9" ><h3>BC-009<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-004" data-buffer-id="4" ><h3>BC-004<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-005" data-buffer-id="5" ><h3>BC-005<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-006" data-buffer-id="6" ><h3>BC-006<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-001" data-buffer-id="1" ><h3>BC-001<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-002" data-buffer-id="2" ><h3>BC-002<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
					<li id="BC-003" data-buffer-id="3" ><h3>BC-003<span class="status"></span></h3><div class="card-cont"><div class="card-cont-left"><input type="hidden" name="rackId"/><input type="text" name="rackName" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellYAxis" readonly="readonly" data-nokeypad='true' ><input type="text" name="rackCellXAxis" readonly="readonly" data-nokeypad='true' ></div><div class="card-cont-right"><button class="btn-choice"><s:interpret word='매핑해제' abbr='' /></button></div></div></li>
				</ul>
			</div>
			<div id="move-progress" class="fix-card oee-list two-col">
				<div class="progress-block">
					<img src="<c:url value='/resources/images/progress-bar.gif'/>">
					<span>Shuttle이 Working Zone으로 오는중입니다.</span>
				</div>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close" id="closeForce"><s:interpret word='닫기' abbr='' /></button>
				<button class="btn-save" id="inputComplte"><s:interpret word='완료' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>