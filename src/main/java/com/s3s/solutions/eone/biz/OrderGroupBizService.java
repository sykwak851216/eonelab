package com.s3s.solutions.eone.biz;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.exception.SFPException;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.GeneratorIDTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.define.EOrderGroupFinishStatus;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderStatus;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.define.EOrderWorkStatus;
import com.s3s.solutions.eone.manager.BufferManager;
import com.s3s.solutions.eone.service.wmd.order.OrderService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayService;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkService;
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
	
	private final OrderTrayService orderTrayService;
	
	private final OrderWorkService orderWorkService;
		
	
	@Transactional(rollbackFor = { Exception.class })
	public boolean forceCompleteOrderGroup(OrderVO orderVO) throws Exception {
		log.info("작업지시 완료 처리 ...[ " + orderVO.getOrderGroupId() + " ]");
		
		/* 0. 대부분 문제가 발생한 후 중단되거나 꼬인 데이터들은 다음과 같이 처리함.
		 * 1. 현장 재고 상태를 확인해서 문제가 된 검체관 Rack (Tray Id) 들이 전산과 상태가 일치 한지 확인
		 * 	1-1. 작업 중 일부만 처리가 되다가 문제가 생겨 멈추는 경우, 겐트리 로봇이 들고 있는 검체관 Rack만 확인하여 보관 또는 수동 제거 처리 하면됨.
		 * 		 나머지는 PLC가 Reset 되면 자동모드에서 동작을 계속 할 것임.
		 * 	1-2. 창고 관점에서 재고(검체관 Rack)가 창고에서 버퍼셔틀에 안착하는 순간 Location 정보가 지워짐.
		 * 		 동일하게 투입시에도 버퍼셔틀에서 창고 Rack에 안착하여 완료하는 순간 Lcoation 정보가 업데이트됨.(이점을 참고하여 재고확인 필요.)
		 * 2. 해당 작업지시를 완료처리하고, 연루된 검체관 Rack (Tray Id)들의 상태값을 완료 또는 성공 처리함.
		 * 3. 수정이 필요한 함목은 상태값(XXX_STATUS_CD)와 수정일자(MOD_DT) 항목 뿐임.
		 * 4. 위의 내용들을 처리하고자 할 경우, 각각의 상태값을 아래와 같이 변경함.
		 *  4-1. 'ING' -> 'COMPLETE'
		 *  4-2. 'READY' -> 'COMPLETE'
		 *  4-3. 수정일자(MOD_DT)는 NOW() 로 값을 처리함.
		 * 5. 위의 함목들을 처리하기 위한 순서
		 *  5-0. 작업지시그룹id에 해당하는 작업지시를 구한다.
		 *  5-1. 작업지시에 해당하는 검체관 Rack(Tray Id) 목록을 구한다.
		 *  5-2. 해당 작업지시에 연결된 검체관 Rack(Tray Id)들을 하나씩 찾아 해달 테이블(아래기술)의 상태(아래참고)를 완료 처리함.
		 *  	- wmd_work_plan ('ING' -> 'COMPLETE')
		 *  	- wmd_order_work ('READY' -> 'COMPLETE')
		 * 	5-3. 작업지시 (WMD_ORDER) 완료처리 함.
		 * 	5-4. 작업지시그룹 (WMD_ORDER_GROUP) 완료처리 함.
		 */			
		
		if(StringUtils.isEmpty(orderVO.getOrderGroupId())) {
			log.error("작업지시 번호가 없습니다.[ " + orderVO.getOrderGroupId() + " ]");
			return false;
		}
		
		// wmd_order 작업지시 목록 조회(by orderGroupId)
		List<OrderVO> orderList = orderService.getList(new OrderVO() {{
			setOrderGroupId(orderVO.getOrderGroupId());
			setOrderStatusCd(EOrderStatus.ING.name());			
		}});
		int resultCnt = ListTools.getSize(orderList);
		
		if(resultCnt <= 0) {
			log.error("WMD_ORDER 테이블 작업지시 정보가 없습니다.[ " + orderVO.getOrderGroupId() + " ]");
			return false;			
		}else {
			log.info("WMD_ORDER 테이블 작업지시 정보 :[ " + orderVO.getOrderGroupId() + " ]" + String.valueOf(resultCnt) + " 개");
			for(OrderVO order: orderList) {
				// 할당된 Order Tray 목록 조회( by OrderId)
				List<OrderTrayVO> orderTrayList = orderTrayService.getList(new OrderTrayVO() {{
					setOrderId(order.getOrderId());						
				}});
				
				for(OrderTrayVO tray: orderTrayList) {
					if(StringUtils.isEmpty(tray.getTrayId())){
						continue;
					}
					
					// 할당된 Tray Id 가 있는 Order Id 만으로 Order Work 테이블을 완료 처리한다.
					// Order Work 목록 조회 (by OrderId)
					List<OrderWorkVO> orderWorkList = orderWorkService.getList(new OrderWorkVO() {{
						setOrderId(order.getOrderId());
						setWorkStatusCd(EOrderWorkStatus.READY.name());	
						setTrayId(tray.getTrayId());
					}});
					log.info("WMD_ORDER_WORK 테이블 작업지시, Tray Id :[ " + order.getOrderId() + "," + tray.getTrayId()+ " ]" + String.valueOf(ListTools.getSize(orderWorkList)) + " 개");
					// Order Work 완료 처리
					for(OrderWorkVO work: orderWorkList) {
						orderWorkService.modify(new OrderWorkVO() {{
							setWorkId(work.getWorkId());
							setWorkStatusCd(EOrderWorkStatus.COMPLETE.name());
							setModDt(DateTools.getDateTimeString());							
						}});
					}
					
					// Work Plan Tray 목록 조회 (by TrayId)
					List<WorkPlanTrayVO> workPlanList = workPlanTrayService.getList(new WorkPlanTrayVO(){{
						setTrayId(tray.getTrayId());
						setTrayStatusCd(EOrderStatus.ING.name());							
					}});
					log.info("WMD_WORK_PLAN_TRAY 테이블 Tray Id :[ " + tray.getTrayId()+ " ]" + String.valueOf(ListTools.getSize(workPlanList)) + " 개");
					
					// Order Work 완료 처리
					for(WorkPlanTrayVO planTray: workPlanList) {
						workPlanTrayService.modify(new WorkPlanTrayVO() {{
							setPlanNo(planTray.getPlanNo());
							setTrayId(planTray.getTrayId());
							setTrayStatusCd(EOrderStatus.COMPLETE.name());
							setModDt(DateTools.getDateTimeString());							
						}});
					}
				}// tray 기준 처리 마무리
				
				orderService.modify(new OrderVO(){{
					setOrderId(order.getOrderId());
					setWorkTrayQty(order.getOrderTrayQty());
					setOrderStatusCd(EOrderStatus.COMPLETE.name());					
					setOrderEndDt(DateTools.getDateTimeString());							
				}});										
			}// Order 테이블 완료 처리 마무리
			
			// Order Group 테이블 완료 처리
			// Work Plan Tray 목록 조회 (by TrayId)
			List<OrderGroupVO> orderGroupList = orderGroupService.getList(new OrderGroupVO(){{
				setOrderGroupId(orderVO.getOrderGroupId());										
			}});
			log.info("WMD_ORDER_GROUP 테이블 작업지시 정보 :[ " + orderVO.getOrderGroupId() + " ]" + String.valueOf(orderGroupList) + " 개");
			
			// Order Group 완료 처리
			for(OrderGroupVO orderGroup: orderGroupList) {
				orderGroupService.modify(new OrderGroupVO() {{
					setOrderGroupId(orderGroup.getOrderGroupId());
					setWorkTrayQty(orderGroup.getOrderTrayQty());
					setOrderGroupStatusCd(EOrderStatus.COMPLETE.name());
					setOrderGroupFinishTypeCd(EOrderGroupFinishStatus.SUCCESS.name());
					setOrderGroupEndDt(DateTools.getDateTimeString());								
				}});
			}				
		}
		return true;
	}
	
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
