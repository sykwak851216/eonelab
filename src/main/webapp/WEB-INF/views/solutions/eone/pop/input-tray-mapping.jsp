<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/sfp/sfp-ui-messagebox.css' />">
<script>
$(function(){
	window.InputTrayMapping = (function($){
		var lineNo = Dialog.getParams();
		var bufferPositionId = "";
		var init = function(){
			_setForm();
			_bindEvent();
			isBufferOnWorkingstation();
			bufferPositionId = setInterval(isBufferOnWorkingstation, 1000);// 1초당 한번씩 갱신 처리
			gatheringBufferSensor();
			setInterval(gatheringBufferSensor, 1000);// 1초당 한번씩 갱신 처리
		}
		, _bindEvent = function(){

			$(".btn-close").on("touchend click", function(e){
				e.preventDefault();

				if($("#move-progress").is(':visible')){
					Dialog.close();
				}else{
					MessageBox.confirm("화면을 닫으면 매핑된 Rack정보가 삭제됩니다.\r\n화면을 닫으시겠습니까?", {cbFn : function(){
						Dialog.close();
					}});
				}
			});

			$(".btn-save").on("touchend click", function(e){
				e.preventDefault();

				if($("#move-progress").is(':visible')){
					return;
				}
				var orderTrayList = saveInputTray()
				if (orderTrayList.length < 1) {
					return;
				}

				SfpAjax.ajax("<c:url value='/solutions/eone/pop/isCallOrderByLineNo'/>", {lineNo : lineNo}, function(data) {
					if(data !== ""){
						var msg = "";
						if (data === "1") {
							msg = "보관을 시작할 수 없습니다.\nDoor 상태를 확인하세요.";
						} else if (data === "2") {
							msg = "보관을 시작할 수 없습니다.\nGantry 상태를 확인하세요.";
						} else if (data === "3") {
							msg = "보관을 시작할 수 없습니다.\nGantry 상태를 확인하세요.";
						} else if (data === "4") {
							msg = "보관을 시작할 수 없습니다.\nPLC 수신 가능 상태를 확인하세요.";
						}
						MessageBox.alarm(msg, { isAutoHide : true });
						return;
					}else{
						_generateInputLocation(orderTrayList);
					}
				});

			});
		}
		, _setForm = function(){

		}
		//입고처리
		, saveInputTray = function(){
			var returnResult = false;
			var orderTrayList = [];
			$("#buffer-current-template li").each(function(e){
				var $this = $(this);
				var bufferId = $this.data("bufferId");
				var trayId   = $this.find("input[name='trayId']").val();
				
				console.log("Duplicate :"lineNo);
				console.log("Duplicate :"bufferId);
				console.log("Duplicate :"trayId);
				//Tray 중복 체크
				SfpAjax.ajaxRequestBody("<c:url value='/solutions/eone/wmd/ordertray/dulipCheck'/>", {trayId : trayId}, function(data) {
					if(data !== 0){
						MessageBox.alarm("Tray["+trayId+"]가 이미 입고되어 있습니다. \n중복 Tray를 확인하세요", { isAutoHide : true });
						return;
						//PLC 경광등 인터페이스 로직 추가.
					}
				});

				if(_checkSensing($this)){
					orderTrayList.push({
						lineNo : lineNo,
						bufferId : bufferId
					});
				}

			});

			if(returnResult){
				return;
			}

			if(orderTrayList.length < 1){
				MessageBox.message("보관 처리할 Rack이 없습니다.\n매핑된 Rack 이 없습니다.", { isAutoHide : true });
			}
			return orderTrayList;
		}
		, _generateInputLocation = function(orderTrayList) {
			SfpAjax.ajaxRequestBody("<c:url value='/solutions/eone/wmd/traylocation/generateInputTrayLocationByLineNo/'/>", orderTrayList, function(data) {
				//console.log("orderTrayList", orderTrayList.length, data.length);
				if (orderTrayList.length != data.length) {
					var needTrayCnt = orderTrayList.length - data.length;
					MessageBox.message("보관 처리할 Rack이 "+needTrayCnt+"개 부족합니다!!", { isAutoHide : true });
					return;
				} else {
					data.forEach(function(element, idx){
						$("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0')).find("input[name='rackId']").val(element.rackId);
						$("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0')).find("input[name='rackName']").val(element.rackName);
						$("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0')).find("input[name='rackCellYAxis']").val(element.rackCellYAxis);
						$("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0')).find("input[name='rackCellXAxis']").val(element.rackCellXAxis);
					});

					MessageBox.confirm("매핑된 Rack이 " + data.length + "개 있습니다.\n보관 처리 하시겠습니까?", {cbFn : function(){
						_generateInputOrderGroup(data);
					}});
				}
			});
		}
		, _generateInputOrderGroup = function(orderTrayList){
			//긴급인지
			SfpAjax.ajaxRequestBody("<c:url value='/solutions/eone/wmd/ordergroup/generateInputOrderGroupByLineNo/'/>", orderTrayList, function(data) {
				Dialog.close();
			});
		}
		// buffer censing 조회
		, gatheringBufferSensor = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/buffer/getBufferSensorsByLineNo'/>", {lineNo : lineNo} , function(data) {
				console.log("buffer cesing", data)
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
		}
		, _isValidText = function(text){
			return text != undefined && text !=null && String(text).trim().length > 0;
		}
		, _checkSensing = function(selector){
			return selector.find("span.status").hasClass("sensing");
		}
		//buffer 위치 확인
		, isBufferOnWorkingstation = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/isBufferOnWorkingstationByLineNo'/>", {lineNo : lineNo} , function(data) {
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
		;
		init();
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
.fix-card .card-cont .card-cont-left{ width: 100%; float: left; padding-left: 10px; }
.fix-card .card-cont .card-cont-right{ width:0%; float: right; padding-left: 10px; }
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
		<h2><s:interpret word='보관업무 > Rack 매핑' abbr='' /></h2>
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
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
				<button class="btn-save"><s:interpret word='보관시작' abbr='' /></button>
			</div>
		</footer>
	</div>


</main>