package com.s3s.solutions.eone.biz;

import java.util.List;

import org.apache.commons.codec.binary.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.exception.SFPException;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.GeneratorIDTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.manager.BufferManager;
import com.s3s.solutions.eone.service.wmd.order.OrderService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationService;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayService;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayVO;
import com.s3s.solutions.eone.service.wmd.workplantray.dto.WorkPlanTrayDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class OrderGroupBizService {

	private final OrderGroupService orderGroupService;

	private final OrderService orderService;

	private final OrderBizService orderBizService;

	private final TrayLocationBizService trayLocationBizService;

	private final BufferManager bufferManager;

	private final OrderTrayBizService orderTrayBizService;

	private final OrderOperationHistoryBizService orderOperationHistoryBizService;

	private final WorkPlanTrayService workPlanTrayService;
	
	private final TrayLocationService trayLocationService;

	private final InterfaceBizService interfaceBizService;

	/**
	 * INPUT - 입고 오더 생성 및 TRAY 위치 선정
	 * @param orderTrayList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void generateInputOrderGroup(List<OrderTrayVO> orderTrayList) throws Exception {

		//진행중인 ORDER GROUP 체크
		if(orderGroupService.getReadyOrIngOrderGroup() != null) {
			log.error("진행중인 OrderGroup이 존재합니다!");
			throw new SFPException("진행중인 OrderGroup이 존재합니다!", new Throwable());
		}

		//진행중인 ORDER 체크
		if(orderService.getReadyOrIngOrder() != null) {
			log.error("진행중인 Order가 존재합니다!");
			throw new SFPException("진행중인 Order가 존재합니다!", new Throwable());
		}

		//TRAY 중복 체크!
		trayLocationBizService.duplicationCheckTrayIdByException(orderTrayList);

		String orderGroupId = GeneratorIDTools.getId("WOG");
		String orderId = GeneratorIDTools.getId("");

		//입고 TRAY 목록 생성
		List<OrderTrayVO> orderTraySaveList = orderTrayBizService.generateInputOrderTray(orderId, orderTrayList);

		//입고 오더 그룹 등록
		orderGroupService.addOrderGroupByOrderGroupType(orderGroupId, orderTraySaveList, EOrderGroupType.INPUT);

		//입고 오더 등록
		orderBizService.generateInputOrder(orderGroupId, orderId, orderTraySaveList);

		for (OrderTrayVO orderTrayVO : orderTrayList) {
			trayLocationBizService.updateTrayLocationByManual(orderGroupId, orderId, EOrderType.INPUT.name(), orderTrayVO.getTrayId(), orderTrayVO.getBufferId());
		}

		orderOperationHistoryBizService.updateOperationHistoryByPlc(orderId);

	}

	/**
	 * 라인의 입고 처리
	 * @param lineId
	 * @param orderTrayList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void generateInputOrderGroupByLineNo(List<OrderTrayVO> orderTrayList) throws Exception {
		if (ListTools.isNullOrEmpty(orderTrayList)) {
			log.error("보관할 Rack이 없습니다!");
			throw new SFPException("보관할 Rack이 없습니다!", new Throwable());
		}

		String lineNo = ListTools.getFirst(orderTrayList).getLineNo();

		//진행중인 ORDER GROUP 체크
		if(orderGroupService.getReadyOrIngOrderGroupByLineNo(lineNo) != null) {
			log.error(lineNo + "Line에 진행중인 지시그룹이 존재합니다!");
			throw new SFPException(lineNo + "Line에 진행중인 지시그룹이 존재합니다!", new Throwable());
		}

		//진행중인 ORDER 체크
		if(orderService.getReadyOrIngOrderByLineNo(lineNo) != null) {
			log.error(lineNo + "Line에 진행중인 지시가 존재합니다!");
			throw new SFPException(lineNo + "Line에 진행중인 지시가 존재합니다!", new Throwable());
		}

		//orderGroupId, orderId 생성
		String orderGroupId = GeneratorIDTools.getId("WOG");
		String orderId = GeneratorIDTools.getId("");

		//입고 TRAY 목록 생성
		//List<OrderTrayVO> orderTraySaveList = orderTrayBizService.generateInputOrderTrayByLindId(lineId, orderId, orderTrayList);

		//입고 오더 그룹 등록
		orderGroupService.addOrderGroupByOrderGroupTypeLineNo(lineNo, orderGroupId, orderTrayList, EOrderGroupType.INPUT ,"N");

		//입고 오더 등록
		orderBizService.generateInputOrderByLineNo(lineNo, orderGroupId, orderId, orderTrayList);

		/*
		for (OrderTrayVO orderTrayVO : orderTrayList) {
			trayLocationBizService.updateTrayLocationByManual(orderGroupId, orderId, EOrderType.INPUT.name(), orderTrayVO.getTrayId(), orderTrayVO.getBufferId());
		}
		*/
		orderOperationHistoryBizService.updateOperationHistoryByPlc(orderId);

	}

	/**
	 * 연속지시
	 * @param lineNo
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public synchronized void continuousOrderByLineNo(String lineNo) throws Exception {
		if(orderGroupService.getReadyOrIngOrderGroupByLineNo(lineNo) != null) {
			log.error("진행중인 지시그룹이 존재합니다!");
			throw new SFPException("진행중인 지시그룹이 존재합니다!", new Throwable());
		}

		if(orderService.getReadyOrIngOrderByLineNo(lineNo) != null) {
			log.error("진행중인 지시가 존재합니다!");
			throw new SFPException("진행중인 지시가 존재합니다!", new Throwable());
		}

		//TRAY LOCATION에 TRAY가 있는지 체크!
		if(ListTools.getSize(trayLocationBizService.getCurrentTrayLocationListByLineNo(lineNo)) > 0) {
			log.error("Buffer에 Rack이 존재하여 지시처리가 불가능 합니다!");
			throw new SFPException("Buffer에 Rack이 존재하여 지시처리가 불가능 합니다!", new Throwable());
		};

		//버퍼에 ON 상태 체크!
		if(bufferManager.getBufferSensorOnCountByLineNo(lineNo) > 0) {
			log.error("Buffer Sensor에 ON 상태가 존재하여 지시처리가 불가능 합니다!");
			throw new SFPException("Buffer Sensor에 ON 상태가 존재하여 지시처리가 불가능 합니다!", new Throwable());
		}

		//1. wmd_order_work work의 in_out_type_cd 조회 (plan_no not null, work_id asc)
		List<WorkPlanTrayVO> workPlanTrayVOList = workPlanTrayService.getContinuousFistOrderByLineNo(lineNo);
		WorkPlanTrayVO workPlanTrayVO = new WorkPlanTrayVO();
		if (workPlanTrayVOList != null && workPlanTrayVOList.size() > 0) {
			//ILC 디비에 있는 tray인지 확인하여 없으면 yudo_work error 처리
			for (WorkPlanTrayVO wptrayVO : workPlanTrayVOList) {
				List<TrayLocationVO> list =  trayLocationService.getRackInTrayList(new TrayLocationVO() {{
					setTrayId(wptrayVO.getTrayId());
					setLineNo(lineNo);
				}});
				if (list != null && list.size() > 0) {
					workPlanTrayVO = wptrayVO;
					break;
				} else {
					//yudo_work error 발송
					interfaceBizService.procYudoWork(wptrayVO, "해당랙이 Shelf에 없습니다.");
					
					workPlanTrayService.modify(new WorkPlanTrayDTO() {{
						setPlanNo(wptrayVO.getPlanNo());
						setCancelYn(SfpConst.YN_Y);
						setModDt(DateTools.getDateTimeString());
					}});
				}
			}
		}
		

		if (workPlanTrayVO != null) {
			String orderGroupId = GeneratorIDTools.getId("WOG");
			String orderId = GeneratorIDTools.getId("");
			String emergencyType = workPlanTrayVO.getEmergencyYn();

			//출고 TRAY 목록 생성
			List<OrderTrayVO> orderTraySaveList = orderTrayBizService.generateOuputContinuousByLineNo(orderId, workPlanTrayVO);
			
			EOrderGroupType eOrderGroupType = EOrderGroupType.OUTPUT;

			if (StringUtils.equals(workPlanTrayVO.getOrderTypeCd(), EOrderType.INQUIRY.name())) {
				eOrderGroupType = EOrderGroupType.INQUIRY;
			}
			//오더 그룹 등록
			if(orderGroupService.getReadyOrIngOrderGroupByLineNo(lineNo) != null) {
				log.error("진행중인 지시그룹이 존재합니다!");
				throw new SFPException("진행중인 지시그룹이 존재합니다!", new Throwable());
			}
			orderGroupService.addOrderGroupByOrderGroupTypeLineNo(lineNo, orderGroupId, orderTraySaveList, eOrderGroupType, emergencyType);

			//오더 등록
			orderBizService.generateOutputOrder(lineNo, orderGroupId, orderId, orderTraySaveList);

			orderOperationHistoryBizService.updateOperationHistoryByPlc(orderId);
		}
		
	}
	
	/**
	 * 알람 처리를 위한 라인의 마지막 작업인지 판단
	 * @param orderGroupId
	 * @return
	 */
	public boolean isInterfaceFinishOrder(String orderGroupId, String orderId, String orderTypeCd, List<OrderWorkVO> workList) throws Exception {
		boolean result = false;
		OrderGroupVO orderGroup = orderGroupService.getOrderGroupVO(orderGroupId);
		boolean checkTarget = false;
		//호출의 입고, 폐기
		if (StringUtils.equals(orderGroup.getOrderGroupTypeCd(), EOrderGroupType.OUTPUT.name())) {
			checkTarget = true;
		} else if (StringUtils.equals(orderGroup.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name())) {
			if (StringUtils.equals(orderTypeCd, EOrderType.INPUT.name())) {
				checkTarget = true;
			}
		}
		
		if (checkTarget) {
			if (!ListTools.isNullOrEmpty(workList)) {
				OrderWorkVO work = ListTools.getFirst(workList);
				List<WorkPlanTrayVO> workPlanList = workPlanTrayService.getInterfaceOrderTrayList(work.getPlanNo(), orderGroup.getLineNo(), orderId);
				if (ListTools.isNullOrEmpty(workPlanList)) {
					result = true;
				}
			}
		}
		
		return result;
	}
	

	/**
	 * 알람 처리를 위한 라인의 마지막 작업인지 판단 수정본
	 * @param orderGroupId
	 * @return
	 */
	public boolean isInterfaceFinishOrder(OrderVO order, List<OrderWorkVO> workList) throws Exception {
		boolean result = false;
//		OrderGroupVO orderGroup = orderGroupService.getOrderGroupVO(orderGroupId);
		boolean checkTarget = false;
		//호출의 입고, 폐기
		if (StringUtils.equals(order.getOrderTypeCd(), EOrderType.OUTPUT.name())) {
			checkTarget = true;
		}
		
		if (checkTarget) {
			if (!ListTools.isNullOrEmpty(workList)) {
				OrderWorkVO work = ListTools.getFirst(workList);
				List<WorkPlanTrayVO> workPlanList = workPlanTrayService.getInterfaceOrderTrayList(work.getPlanNo(), order.getLineNo(), order.getOrderId());
				if (ListTools.isNullOrEmpty(workPlanList)) {
					result = true;
				}
			}
		}
		
		return result;
	}

}
