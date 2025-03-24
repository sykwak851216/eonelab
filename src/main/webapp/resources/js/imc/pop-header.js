if(external && external.clearEvent){
	external.clearEvent();
}

$(function(){
	window.POPHeader = (function($){
		var eventList = [];
		var init = function(){
			_setForm();
			_isPopSettingCheckInit();
			_bindEvent();
		}
		, _setForm = function(){
			if(external && external.getStorage){
				_setWarehouse(external.getStorage("warehouse"));// 창고 정보 POP저장소에서 얻어와서 input에 세팅
				_setWorkingStation(external.getStorage("workingStation"));// 작업장 정보 POP저장소에서 얻어와서 input에 세팅
				_setWorker(external.getStorage("worker"));// 작업자 정보 POP저장소에서 얻어와서 input에 세팅
			}
		}
		, _bindEvent = function(){
			// 창고 클릭 시 선택 팝업
			$("#warehouseName").click(function() {
				Dialog.open(IMCURL.getUrl("/solutions/wms/pop/warehouse-search.pdialog"), 1000, '', function(result){
					var _tempWarehouseId = $("#warehouseId").val();
					setStorageWarehouse(result);
					// 이전값과 달라졌을때... workingStationName을 비우고 노티해야함.
					if(_tempWarehouseId !== result.warehouseId){
//						clearInputWorkingStation();// 작업장 정보 input에 초기화
						_clearStorage("workingStation");
						MessageBox.alarm("작업장을 다시 설정해주시기 바랍니다.");
					}
//					location.reload();
				});
			});
			// 작업장 클릭 시 선택 팝업
			$("#workingStationName").click(function() {
				var _param  = { warehouseId : $("#warehouseId").val() , workingStationTypeCd : $("#workingStationTypeCd").val() };
				Dialog.open(IMCURL.getUrl("/solutions/wms/pop/working-station-search.pdialog"), 1000, _param, function(result){
					setStorageWorkingStation(result);
					for(var i = 0, len = eventList.length ; i < len ; i++){
						eventList[i].call(null, getWarehouseId(), getWorkingStationId());
					}
					location.reload();
				});
			});
			// 작업자 클릭 시 선택 팝업
			$("#workerName").click(function() {
				Dialog.open(IMCURL.getUrl("/solutions/wms/pop/worker-search.pdialog"), 1000, '', function(result){
					setStorageWorker(result);
				});
			});
			// 작업자 클릭 시 선택 팝업
			$("#popSetting").click(function() {
				Dialog.open(IMCURL.getUrl("/solutions/wms/pop/pop-setting.pdialog"), {width : '500px'}, '', function(result){
				});
			});
		}
		//
		, onchange = function(callbackFn){
			eventList[eventList.length] = callbackFn;
		}
		// 배치 작업 시작 클릭 시
		, batchStart = function(){
			if(isPopSettingCheck){
				$(".user-info").find('input[type=text]').each(function(idx, elem){
					$(this).prop('disabled', true);
				});
			}
			$("#workBatchStatus").val("작업중");
		}
		// 배치 작업 시작 클릭 시
		, batchEnd = function(){
			$("#workBatchStatus").val("준비");
			$(".user-info").find('input[type=text]').each(function(idx, elem){
				$(this).prop('disabled', false);
			});
		}
		// 창고 정보 input에 세팅
		, _setWarehouse = function(data){
			if(data){
				_setWarehouseInput(JSON.parse(data));
			}
		}
		// 작업장 정보 input에 세팅
		, _setWorkingStation = function(data){
			if(data){
				_setWorkingStationInput(JSON.parse(data));
			}
		}
		// 작업자 정보 input에 세팅
		, _setWorker = function(data){
			if(data){
				_setWorkerInput(JSON.parse(data));
			}
		}
		// 창고 정보 input에 세팅
		, _setWarehouseInput = function(data){
			$("#warehouseId").val(data.warehouseId);
			$("#warehouseName").val(data.warehouseName);
		}
		// 작업장 정보 input에 세팅
		, _setWorkingStationInput = function(data){
			$("#workingStationId").val(data.workingStationId);
			$("#workingStationName").val(data.workingStationName);
		}
		// 작업자 정보 input에 세팅
		, _setWorkerInput = function(data){
			$("#workerId").val(data.workerId);
			$("#workerName").val(data.workerName);
		}
		// 화면 상단 좌측에 타이틀 세팅
		, setTitle = function(title){
			$("#header_title").text(title);
		}
		, getWarehouse = function(){
			if(external && external.getStorage){
				var data = external.getStorage("warehouse");
				if(data){
					data = JSON.parse(data);
					return data
				}
			}
			return null;
		}
		, getWorkingStation = function(){
			if(external && external.getStorage){
				var data = external.getStorage("workingStation");
				if(data){
					data = JSON.parse(data);
					return data
				}
			}
			return null;
		}
		, getWorker = function(){
			if(external && external.getStorage){
				var data = external.getStorage("worker");
				if(data){
					data = JSON.parse(data);
					return data
				}
			}
			return null;
		}
		, getWarehouseId = function(){
			var data = getWarehouse();
			if(data != null){
				return data.warehouseId;
			}
			return null;
		}
		, getWorkingStationId = function(){
			var data = getWorkingStation();
			if(data != null){
				return data.workingStationId;
			}
			return null;
		}
		, getWorkerId = function(){
			var data = getWorker();
			if(data != null){
				return data.workerId;
			}
			return null;
		}
		, getWarehouseDeviceType = function(){
			var data = getWarehouse();
			if(data != null){
				return data.warehouseDeviceTypeCd;
			}
			return null;
		}
		, getAutoContainerSendYn = function(){
			if(external && external.getStorage){
				var data = external.getStorage("autoContainerSend");
				if(data){
					return data;
				}
			}
			return null;
		}

		, getWorkGuideBalloonYn = function(){
			if(external && external.getStorage){
				var data = external.getStorage("workGuideBalloon");
				if(data){
					return data;
				}
			}
			return null;
		}
		, getAlarmMessageYn = function(){
			if(external && external.getStorage){
				var data = external.getStorage("alarmMessage");
				if(data){
					return data;
				}
			}
			return null;
		}

		, isAutoContainerSend = function(){
			if(external && external.getStorage){
				var data = external.getStorage("autoContainerSend");
				if(data){
					return data == 'Y' ? true : false;
				}
			}
			return false;
		}

		, isWorkGuideBalloon = function(){
			if(external && external.getStorage){
				var data = external.getStorage("workGuideBalloon");
				if(data){
					return data == 'Y' ? true : false;
				}
			}
			return false;
		}
		, isAlarmMessage = function(){
			if(external && external.getStorage){
				var data = external.getStorage("alarmMessage");
				if(data){
					return data == 'Y' ? true : false;
				}
			}
			return false;
		}
		, getInputWarehouseId = function(){
			return $("#warehouseId").val();
		}
		, getInputWorkingStationId = function(){
			return $("#workingStationId").val();
		}
		, getInputWorkerId = function(){
			return $("#workerId").val();
		}
		, _isPopSettingCheckInit = function(){
			if($("#warehouseId").val() == null || $("#warehouseId").val().length == 0){
				MessageBox.alarm("창고를 설정해주시기 바랍니다.");
				return false;
			}
			if( $("#workingStationId").val() == null || $("#workingStationId").val().length == 0){
				MessageBox.alarm("작업장을 설정해주시기 바랍니다.");
				return false;
			}
			if( $("#workerId").val() == null || $("#workerId").val().length == 0){
				MessageBox.alarm("작업자를 설정해주시기 바랍니다.");
				return false;
			}

			return true;
		}
		, isPopSettingCheck = function(){
			if($("#warehouseId").val() == null || $("#warehouseId").val().length == 0){
				return false;
			}
			if( $("#workingStationId").val() == null || $("#workingStationId").val().length == 0){
				return false;
			}
			if( $("#workerId").val() == null || $("#workerId").val().length == 0){
				return false;
			}

			return true;
		}
		//{warehouseId: "WH0001", workingStationId: "WS0001", workerId: "B20170001"}
		, getHeaderValueJson = function(){
			return $(".user-info").find('input[type=hidden]').serializeObject();
		}
		, setItemImage = function(selector, itemId){
			if(itemId != null && itemId.length > 0){
				itemId = itemId.toLowerCase();
				$(selector).prop("src", IMCURL.getUrl("/resources/images/item/" + itemId+ ".jpg"));
				return;
			}
			$(selector).prop("src", IMCURL.getUrl("/resources/images/temp/no-image.jpg"));
		}
		, clearInputWarehouse = function(){
			$("#warehouseId").val("");
			$("#warehouseName").val("");
		}
		, clearInputWorkingStation = function(){
			$("#workingStationId").val("");
			$("#workingStationName").val("");
		}
		, clearInputWorker = function(){
			$("#workerId").val("");
			$("#workerName").val("");
		}
		, clearInput = function(key){
			if(key && key.length > 0){
				if(key === 'warehouse'){
					clearInputWarehouse();
				}else if(key === 'workingStation'){
					clearInputWorkingStation();
				}else if(key === 'worker'){
					clearInputWorker();
				}
			}else{
				clearInputWarehouse();
				clearInputWorkingStation();
				clearInputWorker();
			}
		}
		, _clearStorage = function(key){
			if(external && external.getStorage){
				if(key && key.length > 0){
					external.clearStorage(key);
					clearInput(key);
				}else{
					external.clearStorage();
					clearInput();
				}
			}
		}
		, getWorkingStationType = function(){
			if(external && external.getStorage){
				var data = external.getStorage("workingStationType");
				if(data){
					return data;
				}
			}
			return null;
		}
		, setPageInfo = function(setPageInfo){
			if(setPageInfo){
				$("#header_title").text(setPageInfo.title);
				$("#workingStationTypeCd").val(setPageInfo.workingStationTypeCd);
				if(getWorkingStationType() == null){
					if(external && external.getStorage){
						external.setStorage("workingStationType", setPageInfo.workingStationTypeCd);
					}
				}else{
					if(getWorkingStationType() != setPageInfo.workingStationTypeCd){
//						_clearStorage();
						_clearStorage("workingStationType");
						_clearStorage("workingStation");
						_clearStorage("worker");

					}
				}
			}
		}
		, setStorageWarehouse = function(json){
			if(external && external.setStorage){
				external.setStorage("warehouse", JSON.stringify(json));// 선택된 작업장 정보 POP저장소에 세팅
			}
			_setWarehouseInput(json);// 선택된 창고 정보 input에 세팅
		}
		, setStorageWorkingStation = function(json){
			if(external && external.setStorage){
				external.setStorage("workingStation", JSON.stringify(json));// 선택된 작업장 정보 POP저장소에 세팅
			}
			_setWorkingStationInput(json);// 선택된 작업장 정보 input에 세팅
		}
		, setStorageWorker = function(json){
			if(external && external.setStorage){
				external.setStorage("worker", JSON.stringify(json));// 선택된 창고 정보 POP저장소에 세팅
			}
			_setWorkerInput(json);// 선택된 작업자 정보 input에 세팅
		}
		, getPopHeaderInputData = function(){
			var result = {
				 warehouseId : $("#warehouseId").val()
				,workingStationId :$("#workingStationId").val()
				,workerId : $("#workerId").val()
			}
			return result;
		}
		, getPopHeaderData = function(){
			var result = {
				 warehouseId : getWarehouseId()
				,workingStationId : getWorkingStationId()
				,workerId : getWorkerId()
			}
			return result;
		};
		init();
		return {
			 setTitle : setTitle
			,getWarehouse : getWarehouse
			,getWorkingStation : getWorkingStation
			,getWorker : getWorker
			,getWarehouseId : getWarehouseId
			,getWorkingStationId : getWorkingStationId
			,getWorkerId : getWorkerId
			,getWarehouseDeviceType : getWarehouseDeviceType
			,getInputWarehouseId : getInputWarehouseId
			,getInputWorkingStationId : getInputWorkingStationId
			,getInputWorkerId : getInputWorkerId
			,getAutoContainerSendYn : getAutoContainerSendYn
			,getWorkGuideBalloonYn : getWorkGuideBalloonYn
			,getAlarmMessageYn : getAlarmMessageYn
			,isAutoContainerSend : isAutoContainerSend
			,isWorkGuideBalloon : isWorkGuideBalloon
			,isAlarmMessage : isAlarmMessage
			,isPopSettingCheck : isPopSettingCheck
			,getHeaderValueJson : getHeaderValueJson
			,batchStart : batchStart
			,batchEnd : batchEnd
			,setItemImage : setItemImage
			,clearInputWarehouse : clearInputWarehouse
			,clearInputWorkingStation : clearInputWorkingStation
			,clearInputWorker : clearInputWorker
			,clearInput : clearInput
			,setPageInfo : setPageInfo
			,setStorageWarehouse : setStorageWarehouse
			,setStorageWorkingStation : setStorageWorkingStation
			,setStorageWorker : setStorageWorker
			,onchange : onchange
			,getPopHeaderInputData : getPopHeaderInputData
			,getPopHeaderData : getPopHeaderData
		}
	})(jQuery);

});