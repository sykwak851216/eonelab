package com.s3s.solutions.eone.biz;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.stereotype.Service;

import com.s3s.sfp.apps.service.sys.variable.VariableDTO;
import com.s3s.sfp.apps.service.sys.variable.VariableService;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderStatus;
import com.s3s.solutions.eone.define.EWorkStatus;
import com.s3s.solutions.eone.dmw.command.PLCCommand;
import com.s3s.solutions.eone.manager.BufferManager;
import com.s3s.solutions.eone.service.wmd.order.OrderService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryService;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryVO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayService;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkService;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationService;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayService;
import com.s3s.solutions.eone.vo.PopMainVO;
import com.s3s.solutions.eone.vo.PopSettingVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class PopBizService {

	private final VariableService variableService;
	private final WorkPlanTrayService workPlanTrayService;
	private final OrderTrayService orderTrayService;
	private final TrayLocationService trayLocationService;
	private final OrderGroupService orderGroupService;
	private final OrderService orderService;
	private final OrderOperationHistoryService orderOperationHistoryService;
	private final OrderWorkService orderWorkService;
	private final BufferManager bufferManager;

	/*
	public PopMainVO getPopMainInit(String lineNo) throws Exception {
		PopMainVO result = new PopMainVO();
		result.setGantryReportBody(PLCCommand.getGantry());
		result.setOrderGroup(currentOrderGroup());
		result.setOrderOperationHistoryList(currentOrderOperationHistory(result.getOrderGroup()));
		result.setPopSetting(getPopSettingData());
//		result.setStorageTrayList(trayLocationService.getRackCellStoragedTrayList());
		result.setStorageTrayList(trayLocationService.getRackInTrayList(null));
		result.setOutputRegistedTrayList(workPlanTrayService.getOutputRegistedTray());
		result.setInquiryRegistedTrayList(workPlanTrayService.getInquiryRegistedTray());
		result.setOrderWorkList(getOrderWorkList(result.getOrderGroup()));
		return result;
	}
	*/
	
	/**
	 * 
	 * @param lineNo
	 * @return
	 * @throws Exception
	 */
	public PopMainVO getPopMainInitByLineNo(String lineNo) throws Exception {
		PopMainVO result = new PopMainVO();
		result.setLineNo(lineNo);
		result.setGantryReportBody(PLCCommand.getGantry(lineNo)); //겐트리 상태
		result.setOrderGroup(currentOrderGroupByLineNo(lineNo)); //진행중이거나 대기중인 지시그룹 정보
		//아래 결과값에 따라 호출, 폐기 다이얼 로그를 오픈함
		result.setOrderOperationHistoryList(currentOrderOperationHistory(result.getOrderGroup())); //현재 대기나 진행중인 지시그룹이 있으면 해당 지시의 이력 세팅
		result.setPopSetting(getPopSettingData(lineNo)); //키오스크 설정
		result.setStorageTrayList(trayLocationService.getRackInTrayList(new TrayLocationVO() {{
			setLineNo(lineNo);
		}})); //보관중인 트레이 조회
		result.setLineStorageCount(trayLocationService.getRackInTrayCountPerLineNo());
		result.setOutputRegistedTrayList(workPlanTrayService.getOutputRegistedTrayByLineNo(lineNo)); //대기중인 폐기 트레이 목록 조회
		result.setInquiryRegistedTrayList(workPlanTrayService.getInquiryRegistedTrayByLineNo(lineNo)); //대기중이 호출 트레이 목록 조회
		result.setOrderWorkList(getOrderWorkList(result.getOrderGroup()));
		result.setLineBufferCensingOnCount(bufferManager.getBufferSensorOnCountByLineNo(lineNo));
		
		return result;
	}

	public List<OrderWorkVO> getOrderWorkList(OrderGroupVO orderGroup){
		if(orderGroup != null) {
			try {
				return orderWorkService.getOrderWorkListByOrderGroupId(orderGroup.getOrderGroupId());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return new ArrayList<OrderWorkVO>();
	}
	
	/*
	public boolean isBufferOnWorkingstation() {
		return PLCCommand.isBufferOnWorkingstation();
	}
	*/
	
	public boolean isBufferOnWorkingstationByLineNo(String lineNo) {
		return PLCCommand.isBufferOnWorkingstation(lineNo);
	}

	/**
	 * 
	 * @param orderGroup : 진행중이거나 대기중인 지시그룹 정보
	 * @return
	 */
	public List<OrderOperationHistoryVO> currentOrderOperationHistory(OrderGroupVO orderGroup){
		if(orderGroup != null && orderGroup.getIngOrder() != null) {
			if (StringUtils.isNotBlank(orderGroup.getIngOrder().getOrderId())) {
				try {
					return orderOperationHistoryService.getList(new OrderOperationHistoryVO() {{ setOrderId(orderGroup.getIngOrder().getOrderId()); }});
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return new ArrayList<OrderOperationHistoryVO>();
	}
	
	/**
	 * new 현재 라인에 진행중이거나 대기중인 지시그룹이 있는지 조회하여 
	 * 지시그룹이 있을 경우 해당 지시목록을 조회하여 지시그룹에 지시목록과 진행중인 지시를 세팅하여 반환한다.
	 * @return
	 */
	public OrderGroupVO currentOrderGroupByLineNo(String lineNo) {
		//현재 라인에 진행중이거나 대기중인 지시그룹이 있는지 조회
		OrderGroupVO orderGroup = orderGroupService.getReadyOrIngOrderGroupByLineNo(lineNo);
		try {
			if(orderGroup != null) {
				List<OrderVO> list = orderService.getList(new OrderVO() {{ setOrderGroupId(orderGroup.getOrderGroupId()); }});
				orderGroup.setOrderList(list);
				if (StringUtils.equals(EOrderGroupType.INQUIRY.name(), orderGroup.getOrderGroupTypeCd()) && list.size() > 1) {
					orderGroup.setIngOrder(list.stream().filter(o -> (StringUtils.equals(EOrderStatus.ING.name(), o.getOrderStatusCd()) || StringUtils.equals(EOrderStatus.READY.name(), o.getOrderStatusCd()))).findFirst().orElse(new OrderVO()));
				} else {
					orderGroup.setIngOrder(list.stream().filter(o -> StringUtils.equals(EOrderStatus.ING.name(), o.getOrderStatusCd())).findFirst().orElse(new OrderVO()));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return orderGroup;
	}

	// 설정 데이터
	public PopSettingVO getPopSettingData(String lineNo) {
		PopSettingVO result = new PopSettingVO();

		VariableDTO dto = new VariableDTO();
		//system_setting_line2
		dto.setVariableGroupCd(EoneConst.POP_SETTING+"_line"+lineNo);
		try {
			List<VariableDTO> popSettingList = variableService.getList(dto);
			for (VariableDTO x : popSettingList) {
				/*
				if(StringUtils.equals(EoneConst.MAX_EXPIRATION_DAY, x.getVariableCd())) {
					result.setMaxExpirationDay(Integer.valueOf(x.getVariableValue()));
				}else if(StringUtils.equals(EoneConst.CONTINUOUS_OUTPUT, x.getVariableCd())) {
					result.setContinuousOutput(x.getVariableValue());
				}else if(StringUtils.equals(EoneConst.CONTINUOUS_INQUIRY, x.getVariableCd())) {
					result.setContinuousInquiry(x.getVariableValue());
				}
				*/
				
				if(StringUtils.equals(EoneConst.MAX_EXPIRATION_DAY, x.getVariableCd())) {
					result.setMaxExpirationDay(Integer.valueOf(x.getVariableValue()));
				}else if(StringUtils.equals(EoneConst.CONTINUOUS_TYPE, x.getVariableCd())) {
					result.setContinuousType(x.getVariableValue());
				}
			}
		} catch (Exception e) {
			log.debug(ExceptionUtils.getMessage(e));
		}
		return result;
	}


	public Map<String, Object> getPlcReportData(String lineNo){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("gantry", PLCCommand.getGantry(lineNo));
		map.put("order", PLCCommand.getOrder(lineNo));
		map.put("buffer", PLCCommand.getBuffer(lineNo));
		return map;
	}

}