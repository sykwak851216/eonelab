package com.s3s.solutions.eone.biz;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.tools.BeanTools;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.define.EOrderGroupStatus;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.dmw.command.message.body.OrderReportBody;
import com.s3s.solutions.eone.service.wmd.order.OrderService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryService;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryVO;
import com.s3s.solutions.eone.service.wmd.systemoperationmodestep.SystemOperationModeStepService;
import com.s3s.solutions.eone.service.wmd.systemoperationmodestep.SystemOperationModeStepVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class OrderOperationHistoryBizService {

	private final SystemOperationModeStepService systemOperationModeStepService;

	private final OrderOperationHistoryService orderOperationHistoryService;

//	private final OrderManager orderManager;

	private final OrderService orderService;
	
	private final OrderGroupService orderGroupService;

	/**
	 * 작업 히스토리 입력
	 * @param order
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void updateOperationHistoryByPlc(String orderId) throws Exception{
		this.updateOperationHistoryByPlc(orderService.getOrderById(orderId), null);
	}

	/**
	 * 현재 등록된 지시의 운영 순서 기록을 기반으로 동작 기록이 없으면 처음 데이터를 넣어주고,
	 * 기록이 있을 경우 다음 운영이 없으면 동작을 마치며,
	 * 
	 * @param order
	 * @param vo
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void updateOperationHistoryByPlc(OrderVO order, OrderReportBody vo) throws Exception{

		String nowDate = DateTools.getDateTimeString();

		//현재 등록된 동작 히스토리 조회
		List<OrderOperationHistoryVO> opList = orderOperationHistoryService.getOrderOperationHistoryList(new OrderOperationHistoryVO() {{
			setOrderId(order.getOrderId());
		}});

		//현재 오더 그룹 유형(입고, 출고, 조회)로 현재 스탭을 조회
		List<SystemOperationModeStepVO> stepList = systemOperationModeStepService.getList(new SystemOperationModeStepVO() {{
			setSystemOperationModeId(order.getOrderGroupTypeCd());
		}});

		//동작 히스토리가 없으면.
		if(ListTools.getSize(opList) == 0) {
			SystemOperationModeStepVO firstStep = ListTools.getFirst(stepList);
			addOpByStep(order, nowDate, firstStep);
		} else {
			OrderOperationHistoryVO lastOp = ListTools.getLast(opList);

			//이전 op의 다음 code 가 없으면. 반환
			if(StringUtils.isEmpty(lastOp.getSystemOperationModeStepEndCode())){
				return;
			}

			if(vo == null) {
				return;
			}

			//현재 진행 스탭이 종료 코드와 같으면.(0:대기, 2:처리중, 9:완료) 해당 운영의 종료시간을 수정해준다.
			if(StringUtils.equals(vo.getOrderProcStatus(), lastOp.getSystemOperationModeStepEndCode())) {
				lastOp.setOperationEndDt(nowDate);
				orderOperationHistoryService.modify(lastOp);
			}

			//마지막 스탭의 종료 코드가 도킹 완료 이고 입고일 경우
//			if(StringUtils.equals("9", lastOp.getSystemOperationModeStepEndCode())
//					&& StringUtils.equals(EOrderGroupType.INPUT.name(), lastOp.getSystemOperationModeId())) {
//				orderManager.processOrder(order);
//			}

			SystemOperationModeStepVO nextStep = findNextStep(lastOp, stepList);
			if(nextStep == null) {
				return;
			}

			if(StringUtils.equals(vo.getOrderProcStatus(), nextStep.getSystemOperationModeStepStartCode())) {
				//다음 op를 추가.
				if ( !(StringUtils.equals(order.getOrderTypeCd(), "INPUT") && StringUtils.equals(order.getOrderStatusCd(),"COMPLETE")) ) {
					addOpByStep(order, nowDate, nextStep);
				}
			}

		}
	}

	public void updateOperationHistoryByInquiryInput(String orderId) throws Exception{
		OrderVO order = orderService.getOrderById(orderId);
		this.updateOperationHistoryByInquiryInput(order);
	}

	/*
	 *	조회 입고 요청 시 호출
	 */
//	@Transactional(rollbackFor = { Exception.class })
	public void updateOperationHistoryByInquiryInput(OrderVO order) throws Exception{
		//현재 등록된 동작 히스토리 조회
		List<OrderOperationHistoryVO> opList = orderOperationHistoryService.getOrderOperationHistoryList(new OrderOperationHistoryVO() {{
			setOrderGroupId(order.getOrderGroupId());
		}});

		//현재 오더 그룹 유형(입고, 출고, 조회)로 현재 스탭을 조회
		List<SystemOperationModeStepVO> stepList = systemOperationModeStepService.getList(new SystemOperationModeStepVO() {{
			setSystemOperationModeId(order.getOrderGroupTypeCd());
		}});

		OrderOperationHistoryVO lastOp = ListTools.getLast(opList);

		lastOp.setOperationEndDt(DateTools.getDateTimeString());
		orderOperationHistoryService.modify(lastOp);

		SystemOperationModeStepVO nextStep = findNextStep(lastOp, stepList);
		if(nextStep == null) {
			return;
		}
		//다음 op를 추가.
		addOpByStep(order, DateTools.getDateTimeString(), nextStep);
	}

	/*
	 *	박스를 다 뺏을 경우 출고 완료 시 호출
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void updateOperationHistoryByOutput(String orderGroupId) throws Exception{
		//현재 등록된 동작 히스토리 조회
		List<OrderOperationHistoryVO> opList = orderOperationHistoryService.getOrderOperationHistoryList(new OrderOperationHistoryVO() {{
			setOrderGroupId(orderGroupId);
		}});

		//출고가 완료되면 마지막 히스토리 update
		OrderOperationHistoryVO lastOp = ListTools.getLast(opList);
		lastOp.setOperationEndDt(DateTools.getDateTimeString());
		orderOperationHistoryService.modify(lastOp);
	}

	private void addOpByStep(OrderVO order, String nowDate, SystemOperationModeStepVO firstStep) throws Exception {
		OrderOperationHistoryVO op = new OrderOperationHistoryVO();
		//TODO - daniel 체크 해당 vo 복사
		op = BeanTools.mergeBean(op, firstStep, OrderOperationHistoryVO.class);
		op.setOrderId(order.getOrderId());
		op.setOrderGroupId(order.getOrderGroupId());
		op.setOperationStartDt(nowDate);
		orderOperationHistoryService.add(op);
	}

	/**
	 * 다음 운영 step 있으면 해당 운영 step을 반환하고 없으면 null 반환
	 * @param vo
	 * @param stepList
	 * @return
	 */
	private SystemOperationModeStepVO findNextStep(OrderOperationHistoryVO vo, List<SystemOperationModeStepVO> stepList) {
		int nextStep = vo.getSystemOperationModeStepSort() + 1;
		for(SystemOperationModeStepVO step : stepList) {
			if(StringUtils.equals(vo.getSystemOperationModeId(), step.getSystemOperationModeId())
				&& nextStep == step.getSystemOperationModeStepSort()){
				return step;
			}
		}
		return null;
	}
	
	public boolean isDialogOpenStatus(OrderVO orderVO) throws Exception {
		
		OrderGroupVO orderGroup = orderGroupService.getOrderGroupVO(orderVO.getOrderGroupId());
		if (orderGroup != null) {
			if (StringUtils.equals(orderGroup.getOrderGroupStatusCd(), EOrderGroupStatus.COMPLETE.name())) {
				return false;
			}
		} else {
			return false;
		}
		
		
		OrderOperationHistoryVO orderOperationHistory = orderOperationHistoryService.getLastOperation(new OrderOperationHistoryVO() {{
			setOrderGroupId(orderVO.getOrderGroupId());
		}});
		if (orderOperationHistory != null) {
			if (StringUtils.equals(orderVO.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name())) {
				if (!"INQUIRY-TRAY-INQUIRY".equals(orderOperationHistory.getSystemOperationModeStepId())) {
					return false;
				}
			} else if (StringUtils.equals(orderVO.getOrderGroupTypeCd(), EOrderGroupType.OUTPUT.name())) {
				if (!"OUTPUT-TRAY-OUTPUT".equals(orderOperationHistory.getSystemOperationModeStepId())) {
					return false;
				}
			} else if (StringUtils.equals(orderVO.getOrderGroupTypeCd(), EOrderGroupType.INPUT.name())) {
				if (! ("REDOCKING-STANDYBY".equals(orderOperationHistory.getSystemOperationModeStepId()) || "INPUT-TRAY-OUTPUT".equals(orderOperationHistory.getSystemOperationModeStepId()))) {
					return false;
				}
			}
		} else {
			return false;
		}
		return true;
	}
}