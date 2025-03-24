<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<%@ page import="com.s3s.solutions.eone.define.ELocType" %>
<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/sfp/sfp-ui-messagebox.css' />">
<script>
$(function(){

	var params = Dialog.getParams();

	window.OutputTrayDischarge = (function($){
		var init = function(){
			_setForm();
			_bindEvent();
			list();
			setInterval(list, 2000);// 2초당 한번씩 갱신 처리
		}
		, _bindEvent = function(){
			$(".btn-save").on("touchend click", function(e){
				e.preventDefault();

				SfpAjax.ajax("<c:url value='/solutions/eone/pop/isCallOrderByLineNo'/>", {lineNo : params.ingOrder.lineNo}, function(data) {
					var msg = "";
					var isError = false;
					if (data === "4") {
						msg = "배출완료를 할 수 없습니다.\nPLC 수신 가능 상태를 확인하세요.";
						isError = true;
					}

					if (isError) {
						MessageBox.alarm(msg, { isAutoHide : true });
						return;
					} else {
						discharge();
					}
				});
			});
		}
		, _setForm = function(){
		}
		, list = function(){
			params.ingOrder.orderGroupTypeCd = params.orderGroupTypeCd;
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getBufferTrayLocationListIncludeSensorAndInqueryQtyByLineNo'/>", params.ingOrder, function(data) {
				if (data === '') {
					Dialog.close();
					return;
				}

				$("#buffer-current-template > li span").text("");
				var trayCount = 0;
				var sencingOnCount = 0;
				data.forEach(function(element){
					var $li = $("#BC-0"+SfpUtils.pad(element.bufferId, 2, '0'))
					if(element.sensor === "1"){
						$li.find("span.status").addClass("sensing");
						sencingOnCount++;
					}else if(element.sensor === "0"){
						$li.find("span.status").removeClass("sensing");
					}
					$li.find("span").text(element.trayId);

					$li.find("input[name='rackId']").val(element.rackId);
					$li.find("input[name='rackName']").val(element.rackName);
					$li.find("input[name='rackCellYAxis']").val(element.rackCellYAxis);
					$li.find("input[name='rackCellXAxis']").val(element.rackCellXAxis);

					//TRAY ID가 있으면 셋팅하고 없으면 초기화!
					_isValidText(element.trayId) == true ? $li.data('tray-id', element.trayId) : $li.removeData('tray-id');

					if($("#dischargeComplete").css("display") == "none"){ 
						var trayId = element.trayId;
						if(_isValidText(trayId)){
							trayCount++;
							if (element.sensor === "0") {
								MessageBox.alarm("BC-0"+SfpUtils.pad(element.bufferId, 2, '0')+" 센서 신호 이상 발생", { isAutoHide : true });
							}
						}
					}
				});
				if (trayCount === sencingOnCount) {
					if($("#dischargeComplete").css("display") == "none"){ 
						$("#dischargeComplete").css("display", "block");
					}
				}
			});

		}
		, discharge = function(){
			if(!_isValidText(params.ingOrder) || !_isValidText(params.ingOrder.orderId)){
				MessageBox.message("지시번호를 체크 해주세요!", { isAutoHide : true });
			}
			var returnResult = false;
			var param = {};
			param.orderId = params.ingOrder.orderId;
			param.lineNo = params.ingOrder.lineNo;
			param.orderTrayList = [];
			$("#buffer-current-template li").each(function(e){
				var $this = $(this);
				var bufferId = $this.data("bufferId");
				var trayId = $this.data("trayId");

				if(_isValidText(trayId)){
					//TRAY가 있는데 센서가 켜진 경우
					if(_checkSensing($this)){
						returnResult = true;
						MessageBox.message("배출을 완료 할 수 없습니다.\n미 배출된 Rack이 있습니다.", { isAutoHide : true });
						return false;
					}
					param.orderTrayList.push({
						bufferId : bufferId,
						trayId : trayId
					});
				}else{
					//tray가 없을 경우
					if(_checkSensing($this)){ //센서가 켜져 있을 경우
						returnResult = true;
						MessageBox.message("미확인된 Rack이 Shuttle에 존재 합니다.\n미확인 Rack을 제거해 주세요.", { isAutoHide : true });
						return false;
					}
				}
			})

			if(returnResult){
				return;
			}

			if(param.orderTrayList.length < 1){
				MessageBox.message("배출을 완료 할 수 없습니다.\n배출 처리할 Rack이 없습니다.", { isAutoHide : true });
				return;
			}

			MessageBox.confirm("배출 완료 하시겠습니까?", {cbFn : function(){
				SfpAjax.ajaxRequestBody("<c:url value='/solutions/eone/wmd/order/dischargeOutputOrderTray'/>", param, function(data) {
					Dialog.close(data)
				});
			}});
		}
		, _isValidText = function(text){
			return text != undefined && text !=null && String(text).trim().length > 0;
		}
		, _checkSensing = function(selector){
			return selector.find("span.status").hasClass("sensing");
		};
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

/*.fix-card.oee-list.two-col{ display: none; }*/
.fix-card.oee-list.two-col{ display: block; }
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
		<h2><s:interpret word='폐기업무 > Rack 배출' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="fix-card oee-list two-col">
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
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-save" id="dischargeComplete" style="display:none"><s:interpret word='배출완료' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>