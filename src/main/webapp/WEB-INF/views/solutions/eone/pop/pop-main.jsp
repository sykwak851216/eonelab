<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<link rel="stylesheet" href="<c:url value='/resources/css/pop/pop-eone.css' />">
<%@ page import="com.s3s.solutions.eone.define.EWorkStatus" %>
<%@ page import="com.s3s.solutions.eone.define.EOrderGroupType" %>
<%@ page import="com.s3s.solutions.eone.define.EOrderType" %>
<%@ page import="com.s3s.solutions.eone.define.ETrayStatus" %>
<script>
if(external && external.getAppData){
}else{
	location.href="<c:url value='/' />";
}
$(function(){
	window.PopMain = (function($){
		var isSoundStop = true;
		var intervalId = "";
		var dialogOpenCheck = {
			 inputTray : false
			,outputTray : false
			,inquiryTray : false
			,usableEtcDialog : true
		};
		var mParam = {};
		var init = function(){
			$("#progress-template").template({
				height : "110px"
			});
			_setForm();
			_bindEvent();
			_setLineNm();
			initData();
			intervalId = setInterval(initData, 2000);// 2초당 한번씩 갱신 처리
		}
		, _setForm = function(){
			if(typeof(external.getCustomDeviceId) == 'function') {
				mParam.lineNo = external.getCustomDeviceId();
				external.setNativeTitle("이원의료재단");
			} else {
				var lineNo = "${param.line}"
				if (lineNo === "") {
					mParam.lineNo = "1";
				} else {
					mParam.lineNo = lineNo;
				}
			}
		}
		, _bindEvent = function(){
			// 로고 클릭 시 화면 리로드
			$("#title-logo").on("touchend click", function(e){
				e.preventDefault();
				window.location.reload(true);
			});

			// [설정] 버튼 클릭 시
			$("#system-setting").on("touchend click", function(e){
				e.preventDefault();
				console.log("system-setting", mParam.lineNo);
				Dialog.open("<c:url value='/solutions/eone/pop/system-setting.pdialog' />", { width: "600px", height: "220px", fixed : true, isHiddenCloseBtn : false  }, mParam.lineNo, function(){
					initData();
				});
				$(this).blur();
			});

			// 타이틀[라인] 클릭 시
			$("#titleLineNm").on("touchend click", function(e){
				e.preventDefault();
				Dialog.open("<c:url value='/solutions/eone/pop/rack-current-by-line.pdialog' />", { width: "1800px", height: "900px", fixed : true, isHiddenCloseBtn : false  }, mParam.lineNo, function(){
				});
			});

			// [렉 현황] 클릭 시
			$("#storageTrayBtn").on("touchend click", function(e){
				e.preventDefault();
				Dialog.open("<c:url value='/solutions/eone/pop/tray-current.pdialog' />", { width: "1800px", height: "900px", fixed : true, isHiddenCloseBtn : false  }, mParam.lineNo, function(){
				});
			});

			// [작업지시 현황] 클릭 시
			$("#orderInfo").on("touchend click", function(e){
				e.preventDefault();
				Dialog.open("<c:url value='/solutions/eone/pop/order-list.pdialog' />", { width: "1800px", height: "850px", fixed : true, isHiddenCloseBtn : false  }, mParam.lineNo, function(){
				});
			});

			// [시스템 상세 진행 상태] 클릭 시
			$("#operationHistory").on("touchend click", function(e){
				e.preventDefault();
				Dialog.open("<c:url value='/solutions/eone/pop/order-operation-history-list.pdialog' />", { width: "1800px", height: "850px", fixed : true, isHiddenCloseBtn : false  }, mParam.lineNo, function(){
				});
			});

			// [랙] 클릭 시
			$(".gantry").on("touchend click", function(e){
				e.preventDefault();
				Dialog.open("<c:url value='/solutions/eone/pop/rack-current.pdialog' />", { width: "1800px", height: "950px", fixed : true, isHiddenCloseBtn : false  }, $(this).attr("id"), function(){
				});
			});

			// [버퍼] 클릭 시
			$(".buffer").on("touchend click", function(e){
				e.preventDefault();
				Dialog.open("<c:url value='/solutions/eone/pop/buffer-current.pdialog' />", { width: "800px", height: "500px", fixed : true }, mParam.lineNo, function(){
				});
			});

			// [보관] 버튼 클릭 시
			$("#INPUT").on("touchend click", function(e){
				e.preventDefault();
				if(_isUsableModeClick($(this), "INPUT") == false){
					return;
				}

				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getRackEmptyCellListByLineNo'/>", {lineNo : mParam.lineNo}, function(data) {
					if(data != null && data.length > 0){
						_openInputTrayDialog();
					}else{
						MessageBox.message("Shelf안에 빈공간이 존재 하지 않습니다!", { isAutoHide : true });
					}
				});
			});

			// [폐기-트레이목록] 버튼 클릭 시
			$("#OUTPUT-TRAY-LIST-BTN").on("touchend click", function(e){
				e.preventDefault();
				var wParam = {};
				wParam.lineNo =  mParam.lineNo;
				wParam.orderTypeCd = '<%=EOrderType.OUTPUT.name()%>';
				wParam.trayStatusCd = '<%=ETrayStatus.READY.name()%>';
				Dialog.open("<c:url value='/solutions/eone/pop/wait-tray-list.pdialog' />", { width: "1600px", height: "850px", fixed : true, isHiddenCloseBtn : false  }, wParam, function(){
					initData();
				});
			});

			// [대기-트레이목록] 버튼 클릭 시
			$("#WAIT-TRAY-LIST-BTN").on("touchend click", function(e){
				e.preventDefault();
				var wParam = {};
				wParam.lineNo =  mParam.lineNo;
				wParam.orderTypeCd = '<%=EOrderType.INQUIRY.name()%>';
				wParam.trayStatusCd = '<%=ETrayStatus.READY.name()%>';
				Dialog.open("<c:url value='/solutions/eone/pop/wait-tray-list.pdialog' />", { width: "1600px", height: "850px", fixed : true, isHiddenCloseBtn : false  }, wParam, function(){
					initData();
				});
			});
		}
		, _isOpenTrayDialog = function(){
			if(dialogOpenCheck.inputTray == false && dialogOpenCheck.outputTray == false && dialogOpenCheck.inquiryTray == false){
				return false;
			}
			return true;
		}
		// 보관-트레이매핑 다이얼로그
		, _openInputTrayDialog = function(){
			if(_isOpenTrayDialog() == false){
				dialogOpenCheck.inputTray = true;
				// 버퍼가 워킹존에 무조건 있다고 했는데 있는지 체크하여 "트레이 매핑" 다이얼로그 띄워준다
				Dialog.open("<c:url value='/solutions/eone/pop/input-tray-mapping.pdialog' />", { width: "1200px", height: "820px", fixed : true, isHiddenCloseBtn : true }, mParam.lineNo, function(){
					dialogOpenCheck.inputTray = false;
				});
			}
		}
		// 보관-에러 트레이 배출 다이얼로그
		, _openInputDischargeTrayDialog = function(){
			if(_isOpenTrayDialog() == false){

				var checkParam = {};
				checkParam.orderGroupId = mParam.orderGroup.orderGroupId;
				checkParam.orderGroupTypeCd = mParam.orderGroup.orderGroupTypeCd;
				checkParam.orderTypeCd = mParam.orderGroup.ingOrder.orderTypeCd;
				//console.log("checkParam", checkParam);
				//상태확인
				SfpAjax.ajax("<c:url value='/solutions/eone/pop/isDialogOpenStatus'/>", checkParam, function(data) {
					if (data) {
						dialogOpenCheck.inputTray = true;
						Dialog.open("<c:url value='/solutions/eone/pop/input-tray-discharge.pdialog' />", { width: "1200px", height: "820px", fixed : true, isHiddenCloseBtn : true }, mParam.orderGroup, function(){
							dialogOpenCheck.inputTray = false;
						});
					}
				});
			}
		}
		// 폐기-트레이배출 다이얼로그
		, _openOututTrayDialog = function(){
			if(_isOpenTrayDialog() == false){
				//console.log("checkParam", mParam.orderGroup);
				var checkParam = {};
				checkParam.orderGroupId = mParam.orderGroup.orderGroupId;
				checkParam.orderGroupTypeCd = mParam.orderGroup.orderGroupTypeCd;
				checkParam.orderTypeCd = mParam.orderGroup.ingOrder.orderTypeCd;

				//상태확인
				SfpAjax.ajax("<c:url value='/solutions/eone/pop/isDialogOpenStatus'/>", checkParam, function(data) {
					if (data) {
						dialogOpenCheck.outputTray = true;
						// 버퍼가 워킹존에 무조건 있다고 했는데 있는지 체크하여 "트레이 매핑" 다이얼로그 띄워준다
						Dialog.open("<c:url value='/solutions/eone/pop/output-tray-discharge.pdialog' />", { width: "1200px", height: "820px", fixed : true, isHiddenCloseBtn : true }, mParam.orderGroup, function(){
							dialogOpenCheck.outputTray = false;
						});
					}
				});
			}
		}
		// 호출-트레이조회 다이얼로그
		, _openInqiuryTrayDialog = function(){
			if(_isOpenTrayDialog() == false){
				var checkParam = {};
				checkParam.orderGroupId = mParam.orderGroup.orderGroupId;
				checkParam.orderGroupTypeCd = mParam.orderGroup.orderGroupTypeCd;
				checkParam.orderTypeCd = mParam.orderGroup.ingOrder.orderTypeCd;

				//상태확인
				SfpAjax.ajax("<c:url value='/solutions/eone/pop/isDialogOpenStatus'/>", checkParam, function(data) {
					if (data) {
						dialogOpenCheck.inquiryTray = true;
						// 버퍼가 워킹존에 무조건 있다고 했는데 있는지 체크하여 "트레이 매핑" 다이얼로그 띄워준다
						Dialog.open("<c:url value='/solutions/eone/pop/inquiry-output-tray-discharge.pdialog' />", { width: "1200px", height: "820px", fixed : true, isHiddenCloseBtn : true }, mParam.orderGroup, function(){
							dialogOpenCheck.inquiryTray = false;
						});
					}
				});
			}
		}
		//보관, 폐기, 조회 클릭 가능한지 체크
		, _isUsableModeClick = function($this, _mode){
			if($this.hasClass("off")){
				return false;
			}
			if($("#orderGroupId").text() != ''){
				MessageBox.info("진행중인 지시가 있습니다.", { isAutoHide : true });
				return false;
			}
			return true;
		}
		//지시정보 세팅 관련
		//initData 함수에서 호출됨
		, _orderSetting = function(data){
			console.log("지시정보", data);
			if(data == null){
				if($("#orderGroupId").text() !== ''){
					MessageBox.message("지시가 정상적으로 완료되었습니다.", { isAutoHide : true });
				}

				if ( parseInt(mParam.inquiryRegistedTrayCount) > 0 || parseInt(mParam.outputRegistedTrayCount) > 0) {
					_continueOrderStart();
				} else {
					$(".full-button").first().removeClass("off");
					$("#operationMode").text("대기");// 시스템 동작모드 세팅
					$(".inner-group").removeClass("ing");
					$(".order-content").text("");
				}
			} else {
				$(".full-button").addClass("off"); //보관, 폐기, 조회 버튼 class off
				$("#operationMode").text(data.orderGroupTypeNameCache);// 시스템 동작모드 세팅
				$(".inner-group").removeClass("ing");
				$("."+ data.orderGroupTypeCd).addClass("ing"); //해당 업무 영역에 ing 클래스 추가
				$(".order-group").setData(data);//진행중인 지시그룹정보 세팅
			}

		}
		, _continueOrderStart = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/isCallOUTByLineNo'/>", {lineNo : mParam.lineNo}, function(data) {
				if (data !== "") {
					var msg = "";
					if (data === "1") {
						msg = "Door 상태를 확인하세요.";
					} else if (data === "2") {
						msg = "Gantry 상태를 확인하세요.";
					} else if (data === "3") {
						msg = "Gantry 상태를 확인하세요.";
					} else if (data === "4") {
						msg = "PLC 수신 가능 상태를 확인하세요.";
					} else if (data === "5") {
						msg = "Buffer Sensor에 ON 상태가 존재하여 출고 불가 합니다!";
					}
					MessageBox.alarm(msg, { isAutoHide : true });
					return;
				} else {
					if(Number($("#inquiryRegistedTrayCount").text()) <= 0 && Number($("#outputRegistedTrayCount").text()) <= 0){
						MessageBox.info("대기 Rack이 없습니다.", { isAutoHide : true });
						return;
					}

					$(".full-button").first().addClass("off");
					SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getRackInTrayList'/>", {lineNo : mParam.lineNo}, function(data) {
						if(data != null && data.length > 0){
							//continuousOrderByLineNo
							SfpAjax.ajax("<c:url value='/solutions/eone/wmd/ordergroup/continuousOrderByLineNo'/>", {lineNo : mParam.lineNo}, function(data) {
								initData();
							});
						}else{
							$(".full-button").first().removeClass('off');
							MessageBox.message("Shelf안에 Rack이 존재 하지 않습니다!", { isAutoHide : true });
						}
					});
				}
			});

		}
		//현재 시스템 상세 진행 단계
		//initData 함수에서 호출됨
		, _doStepOn = function(list){
			$(".process-flow .process").removeClass("on");
			if(list != null && list.length > 0){
				console.log("현재 시스템 상세 진행 단계", list[list.length-1].systemOperationModeStepId);
				$("#"+list[list.length-1].systemOperationModeStepId).addClass("on");
				if(list[list.length-1].systemOperationModeStepId === 'OUTPUT-TRAY-OUTPUT'){//폐기
					_openOututTrayDialog();
				}else if(list[list.length-1].systemOperationModeStepId === 'INQUIRY-TRAY-INQUIRY'){//조회
					_openInqiuryTrayDialog();
				}else if(list[list.length-1].systemOperationModeStepId === 'REDOCKING-STANDYBY' || list[list.length-1].systemOperationModeStepId === 'INPUT-TRAY-OUTPUT'){//보관배출
					_openInputDischargeTrayDialog();
				}
			}else{
				$(".process-flow .process").removeClass("on");
			}
		}
		//시스템 상세 진행 상태 목록
		, _setProgressList = function(list, orderGroupInfo){
			$("#progress-template").template("clear");
			if(list != null && list.length > 0){

				$("#progress-template").template("draw", list.reverse(), function(row){
					console.log("row.workStatusCd", row.workStatusCd);
					if(row.workStatusCd === '<%=EWorkStatus.READY.name()%>' || row.workStatusCd === '<%=EWorkStatus.CANCEL.name()%>'){
						return false;
					}

					if(row.workStatusCd === '<%=EWorkStatus.ING.name()%>'){
						row.modDt = DateUtils.fnYmdhms();
					}

					if (row.showPopTrayId == null) {
						if (orderGroupInfo.orderGroupTypeCd === "INPUT") {
							row.workText = row.fromLocation + " Rack 바코드 스캔 오류";
						}
					} else {
						row.workText = row.showPopTrayId + " Rack이 " + row.fromLocation + "에서 " + row.toLocation + "로 적재 " + row.workStatusNameCache;
					}
				});
			}
		}
		//설비 상태
		, _setGantryInfo = function(data){
			console.log("겐트리 상태", data);
			$(".gantry-block .block-content").removeClass("move");
			$(".gantry-block .block-content").removeClass("alarm");
			// 0: 대기, 1: 입고, 2: 출고
			if (data.gantryOperationMode != null && data.gantryOperationMode != "0") {
				$("#GANTRY"+mParam.lineNo+" .gantry-block .block-content").addClass("move");
			}

			// 1: 정상, 2: 알람
			if (data.gantryStatus != null && data.gantryStatus != "1") {
				$("#GANTRY"+mParam.lineNo+" .gantry-block .block-content").addClass("alarm");
			}
		}
		, _setBufferPosition = function(data){
			// 7: 워킹존, 1:워킹위치
			console.log("셔틀 위치", data.bufferPosition);
			$(".buffer").removeClass("on");
			$("#gshuttle"+mParam.lineNo).text("");
			$("#wshuttle"+mParam.lineNo).text("");
			var bufferInfo = data.bufferPosition;
			if(bufferInfo){
				if(bufferInfo === '7'){
					$("#working-buffer"+mParam.lineNo).addClass("on");
					$("#wshuttle"+mParam.lineNo).text("("+data.lineBufferCensingOnCount+"/12)");
				}else {
					$("#gantry-buffer"+mParam.lineNo).addClass("on");
					$("#gshuttle"+mParam.lineNo).text("("+data.lineBufferCensingOnCount+"/12)");
				}
			}
		},
		_setLineStorage =  function(data){
			var totalStorageCount = 0;
			data.forEach(function(element, idx){
				$("#storeRackLine"+element.lineNo).text("("+element.storeRackCount+"/640)");
				totalStorageCount = totalStorageCount + parseInt(element.storeRackCount);
			});
			$("#totalStorageCount").html("&nbsp;&nbsp;&nbsp;Total "+totalStorageCount+" / 1920");
		}
		, initData = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/getPopMainInit'/>", mParam, function(data) {
				mParam = $.extend(mParam, data);
				_setGantryInfo(data.gantryReportBody);//설비 상태
				_setBufferPosition(data);//버퍼셔틀 위치 정보
				_orderSetting(data.orderGroup);//지시정보
				_doStepOn(data.orderOperationHistoryList);//시스템 현재 진행 상태
				_setProgressList(data.orderWorkList, data.orderGroup);//시스템 상세 진행 상태
				_setLineStorage(data.lineStorageCount);

				$("#storageTrayListCount").text(data.storageTrayListCount);//보관중인 트레이 수
				$("#outputRegistedTrayCount").text(data.outputRegistedTrayCount);//폐기 등록 트레이수
				$("#inquiryRegistedTrayCount").text(data.inquiryRegistedTrayCount);//조회 등록 트레이수

				$(".setup-group").setData(data.popSetting);//시스템 설정
			});
		}
		, _setLineNm = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/line/getDetail'/>", {lineNo : mParam.lineNo}, function(data) {
				$("#titleLineNm").text(data.lineNm);
			});
		}
		;
		init();
		return {
			initData : initData
		}
	})(jQuery);
});

</script>
<style>
.gantry, #title-logo, #storageTrayBtn, #operationHistory, #orderInfo, #titleLineNm{ cursor: pointer; }
.question{
	background: url("<c:url value='/resources/images/icons/windows3.png'/>") 0 0 no-repeat;
	background-size: 100% auto;
	width: 30px;
	height: 30px;
	float: left;
	margin-right: 10px;
}
.order-content{ font-weight: bold; }
.process-flow .process {
	width: 119px;
	height: 50px;
	line-height: 50px;
	text-align: center;
	border: 2px solid #747474;
	float: left
}
#storageTrayBtn{ height: 30px; }
#operationHistory{ width: 200px; height: 50px; }
#orderInfo{ width: 120px; height: 30px; }
</style>
<main>
	<header>
		<h2><span id="title-logo"><s:interpret word='ILC for U-Storage' abbr='' /></span></h2>
		<div class="search-box">
			<button class="btn-setup ico" id="system-setting"><s:interpret word='설정' abbr='' /></button>
		</div>
	</header>
	<section>
		<div class="col">
			<div class="item-wrap row no-flex">
				<div class="col">
					<div class="function-area search-box">
						<div class="align-left">
							<span><s:interpret word='시스템 동작모드' abbr='' /> : </span>
							<span><strong id="operationMode">대기</strong></span>
						</div>
					</div>
				</div>
				<div class="col">
					<div class="function-area search-box">
						<div class="align-center">
							<span><strong id="titleLineNm">Line 1</strong></span>
						</div>
					</div>
				</div>
				<div class="col">
					<div class="function-area search-box">
						<div class="align-right">
							<div id="storageTrayBtn">
								<span><s:interpret word='보관중인 Rack수' abbr='' /> : </span>
								<span><strong id="storageTrayListCount">0</strong>개</span>
								<div class="question"></div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="item-wrap row">
				<div class="col" style="flex-grow: 0.7;">
					<div class="item-wrap row" style="flex-grow: 0.8;">
						<div class="item-inner">
							<h3 class="card-title">설비 상태 <span id="totalStorageCount"></span></h3>
							<div class="item-cont">
								<div style="width:100%; height:50%;">
									<div class="card-area bg-none same-size">
										<div class="row">
											<div class="card-wrap col" style="padding: 0 10px 10px 20px;">
												<div class="card-inner gantry" id="GANTRY1">
													<h3 class="card-title">Line 1 <span id="storeRackLine1"></span></h3>
													<div class="card-cont">
														<div class="long-block left" style="margin: 0 20px 0 20px;"><!-- on 클래스 추가 시 색깔 반전-->
															<div class="block-content"><span>Shelf-1</span></div>

														</div>
														<div class="center-block" style="margin: 0 20px 0 0;">
															<div class="gantry-block" style="margin: 0 20px 0 0;">
																<div class="block-content"><span>Gantry-1</span></div>
															</div>
														</div>
														<div class="long-block right" style="margin: 0;">
															<div class="block-content"><span>Shelf-2</span></div>
														</div>
													</div>
												</div>
											</div>
											<div class="card-wrap col">
												<div class="card-inner gantry" id="GANTRY2">
													<h3 class="card-title">Line 2 <span id="storeRackLine2"></span></h3>
													<div class="card-cont">
														<div class="long-block left" style="margin: 0 20px 0 20px;">
															<div class="block-content"><span>Shelf-3</span></div>
														</div>
														<div class="center-block" style="margin: 0 20px 0 0;">
															<div class="gantry-block" style="margin: 0 20px 0 0;">
																<div class="block-content"><span>Gantry-2</span></div>
															</div>
														</div>
														<div class="long-block right" style="margin: 0;">
															<div class="block-content"><span>Shelf-4</span></div>
														</div>
													</div>
												</div>
											</div>
											<div class="card-wrap col">
												<div class="card-inner no-title gantry" id="GANTRY3">
													<h3 class="card-title">Line 3 <span id="storeRackLine3"></span></h3>
													<div class="card-cont">
														<div class="long-block left" style="margin: 0 20px 0 20px;">
															<div class="block-content"><span>Shelf-5</span></div>
														</div>
														<div class="center-block" style="margin: 0 20px 0 0;">
															<div class="gantry-block" style="margin: 0 20px 0 0;">
																<div class="block-content"><span>Gantry-3</span></div>
															</div>
														</div>
														<div class="long-block right" style="margin: 0;">
															<div class="block-content"><span>Shelf-6</span></div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div style="width:100%; height:25%;">
									<div class="card-area bg-none same-size no-border">
										<div class="row">
											<div class="card-wrap col" style="padding: 0 10px 10px 20px;">
												<div class="card-inner no-title">
													<div class="card-cont">
														<div class="empty-block" style="margin: 0 20px 0 20px;"></div>
														<div id="gantry-buffer1" class="buffer status-block" style="margin: 0 20px 0 0; z-index: 10;"><!-- status-block에 on 클래스 추가하면 보이고 빼면 안보인다 -->
<%-- 															<div class="block-title"><span class="status on"></span></div><!-- status에 on 클래스 추가하면 초록색 동그라미 --> --%>
															<div class="block-content"><span>Shuttle 1</span> <span id="gshuttle1"></span></div>
														</div>
														<div class="empty-block" style="margin: 0;"></div>
													</div>
												</div>
											</div>
											<div class="card-wrap col">
												<div class="card-inner no-title">
													<div class="card-cont">
														<div class="empty-block" style="margin: 0 20px 0 20px;"></div>
														<div id="gantry-buffer2" class="buffer status-block" style="margin: 0 20px 0 0; z-index: 10;"><!-- status-block에 on 클래스 추가하면 보이고 빼면 안보인다 -->
<%-- 															<div class="block-title"><span class="status on"></span></div><!-- status에 on 클래스 추가하면 초록색 동그라미 --> --%>
															<div class="block-content"><span>Shuttle 2</span>  <span id="gshuttle2"></span></div>
														</div>
														<div class="empty-block" style="margin: 0;"></div>
													</div>
												</div>
											</div>
											<div class="card-wrap col">
												<div class="card-inner no-title">
													<div class="card-cont">
														<div class="empty-block" style="margin: 0 20px 0 20px;"></div>
														<div id="gantry-buffer3" class="buffer status-block" style="margin: 0 20px 0 0; z-index: 10;"><!-- status-block에 on 클래스 추가하면 보이고 빼면 안보인다 -->
<%-- 															<div class="block-title"><span class="status on"></span></div><!-- status에 on 클래스 추가하면 초록색 동그라미 --> --%>
															<div class="block-content"><span>Shuttle 3</span>  <span id="gshuttle3"></span></div>
														</div>
														<div class="empty-block" style="margin: 0;"></div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div style="width:100%; height:25%;">
									<div class="card-area bg-none same-size">
										<div class="row">
											<div class="card-wrap col" style="padding: 0 10px 10px 20px;">
												<div class="card-inner" style="padding-right:0px;">
													<h3 class="card-title">Working Zone 1 <span id="wshuttle1"></span></h3>
													<div class="card-cont">
														<div class="empty-block" style="margin: 0 20px 0 20px;"></div>
														<div id="working-buffer1" class="buffer status-block" style="margin: 0 20px 0 0; z-index: 10;"><!-- status-block에 on 클래스 추가하면 보이고 빼면 안보인다 -->
<%-- 															<div class="block-title"><span class="status on"></span></div><!-- status에 on 클래스 추가하면 초록색 동그라미 --> --%>
															<div class="block-content"><span>Shuttle 1</span></div>
														</div>
														<div class="empty-block" style="margin: 0;"></div>
													</div>
												</div>
											</div>
											<div class="card-wrap col">
												<div class="card-inner" style="padding-right:0px;">
													<h3 class="card-title">Working Zone 2 <span id="wshuttle2"></span></h3>
													<div class="card-cont">
														<div class="empty-block" style="margin: 0 20px 0 20px;"></div>
														<div id="working-buffer2" class="buffer status-block" style="margin: 0 20px 0 0; z-index: 10;"><!-- status-block에 on 클래스 추가하면 보이고 빼면 안보인다 -->
<%-- 															<div class="block-title"><span class="status on"></span></div><!-- status에 on 클래스 추가하면 초록색 동그라미 --> --%>
															<div class="block-content"><span>Shuttle 2</span></div>
														</div>
														<div class="empty-block" style="margin: 0;"></div>
													</div>
												</div>
											</div>
											<div class="card-wrap col">
												<div class="card-inner" style="padding-right:0px;">
													<h3 class="card-title">Working Zone 3 <span id="wshuttle3"></span></h3>
													<div class="card-cont">
														<div class="empty-block" style="margin: 0 20px 0 20px;"></div>
														<div id="working-buffer3" class="buffer status-block" style="margin: 0 20px 0 0; z-index: 10;"><!-- status-block에 on 클래스 추가하면 보이고 빼면 안보인다 -->
<%-- 															<div class="block-title"><span class="status on"></span></div><!-- status에 on 클래스 추가하면 초록색 동그라미 --> --%>
															<div class="block-content"><span>Shuttle 3</span></div>
														</div>
														<div class="empty-block" style="margin: 0;"></div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="item-wrap row" style="flex-grow: 0.2;">
						<div class="item-inner">
							<h3 class="card-title">
								<div id="operationHistory">
									<div class="question" style="margin-top: 10px;"></div><span>System Log</span>
								</div>
							</h3>
							<div class="item-cont">
								<ul class="process-status" id="progress-template">
								</ul>
							</div>
						</div>
					</div>
				</div>
				<div class="col" style="flex-grow: 0.3;">
					<div class="item-wrap row">
						<div class="item-inner no-title">
							<div class="item-cont">
								<div class="command-group">
									<div class="inner-group INPUT">
										<div class="inner-group-up">
											<div class="full-button" id="INPUT"><span>보관업무</span></div>
										</div>
										<div class="inner-group-down">
											<div class="process-flow">
												<div class="process" id="INPUT-TRAY-INQUIRY"><span>Rack매핑</span></div>
												<div class="flow"><span>>></span></div>
												<div class="process" id="INPUT-MOVE"><span>Stowing</span></div><!-- on 클래스 추가 시 색깔 반전-->
												<div class="flow"><span>>></span></div>
												<div class="process" id="INPUT-TRAY-OUTPUT"><span>스캔오류제거</span></div>

											</div>
										</div>
									</div>
									<div class="inner-group OUTPUT">
										<div class="inner-group-up">
											<div class="full-button off" id="OUTPUT"><span>폐기업무</span></div>
											<div class="half-button-wrap">
												<div class="half-button" id="OUTPUT-TRAY-LIST-BTN"><span>대기 Rack</span></div>
												<div class="label-wrap-value">대기 Rack 수 : <span id="outputRegistedTrayCount">0</span>개</div>
											</div>
										</div>
										<div class="inner-group-down">
											<div class="process-flow">
												<div class="process" id="OUTPUT-MOVE"><span>Picking</span></div>
												<div class="flow"><span>>></span></div>
												<div class="process" id="OUTPUT-TRAY-OUTPUT"><span>Rack배출</span></div>
											</div>
										</div>
									</div>
									<div class="inner-group INQUIRY">
										<div class="inner-group-up">
											<div class="full-button off" id="INQUIRY"><span>호출 업무</span></div>
											<div class="half-button-wrap">
												<div class="half-button" id="WAIT-TRAY-LIST-BTN"><span>대기 Rack</span></div>
												<div class="label-wrap-value">대기 Rack 수 : <span id="inquiryRegistedTrayCount">0</span>개</div>
											</div>
										</div>
										<div class="inner-group-down">
											<div class="process-flow">
												<div class="process" id="INQUIRY-OUTPUT-MOVE"><span>Picking</span></div>
												<div class="flow"><span>>></span></div>
												<div class="process" id="INQUIRY-TRAY-INQUIRY"><span>Rack확인</span></div>
												<div class="flow"><span>>></span></div>
												<div class="process" id="INQUIRY-INPUT-MOVE"><span>Stowing</span></div>
											</div>
										</div>
									</div>
								</div>
								<div class="setup-group">
									<div class="setup"><span>최대보관일 :</span><span><strong id="maxExpirationDay"></strong>일</span></div>
									<!-- <div class="setup"><span>연속업무 :</span><span><strong id="continuousType"></strong></span></div>-->
								</div>
								<div class="order-group">
									<div class="register-table small">
										<h3 class="grid-title big">
											<div id="orderInfo">
												<span>작업지시</span><div class="question"></div>
											</div>
										</h3>
										<ul>
											<li>
												<div class="title">지시번호</div>
												<div class="cont"><div class="line-wrap"><span class="order-content" id="orderGroupId"></span></div></div>
												<div class="title"></div>
												<div class="cont"></div>
											</li>
											<li>
												<div class="title">지시유형</div>
												<div class="cont"><div class="line-wrap"><span class="order-content" id="orderGroupTypeNameCache"></span></div></div>
												<div class="title">지시일자</div>
												<div class="cont"><div class="line-wrap"><span class="order-content" id="orderGroupDate"></span></div></div>
											</li>
											<li>
												<div class="title">지시Rack(개)</div>
												<div class="cont"><div class="line-wrap"><span class="order-content" id="orderTrayQty"></span></div></div>
												<div class="title">처리Rack(개)</div>
												<div class="cont"><div class="line-wrap"><span class="order-content" id="workTrayQty"></span></div></div>
											</li>
											<li>
												<div class="title">시작시점</div>
												<div class="cont"><div class="line-wrap"><span class="order-content" id="orderGroupStartHms"></span></div></div>
												<div class="title">완료시점</div>
												<div class="cont"><div class="line-wrap"><span class="order-content" id="orderGroupEndHms"></span></div></div>
											</li>
											<li>
												<div class="title">지시상태</div>
												<div class="cont"><div class="line-wrap"><span class="order-content" id="orderGroupStatusNameCache"></span></div></div>
												<div class="title"></div>
												<div class="cont"></div>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</main>
<script type="text/sfp-template" data-model="progress-template">
<li><span>[@{modDt}]</span><span>@{workText}</span></li>
</script>
