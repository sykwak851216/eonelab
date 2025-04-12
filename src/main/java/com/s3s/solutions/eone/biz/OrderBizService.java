package com.s3s.solutions.eone.biz;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.exception.SFPException;
import com.s3s.sfp.tools.BeanTools;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.GeneratorIDTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.sfp.tools.NumberTools;
import com.s3s.solutions.eone.define.EInOutType;
import com.s3s.solutions.eone.define.EOrderGroupFinishStatus;
import com.s3s.solutions.eone.define.EOrderGroupStatus;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderStatus;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.define.ETrayStatus;
import com.s3s.solutions.eone.manager.BufferManager;
import com.s3s.solutions.eone.manager.PLCManager;
import com.s3s.solutions.eone.service.wmd.order.OrderService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.dto.OrderGroupDTO;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryService;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryVO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayService;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkService;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.systemoperationmodestep.SystemOperationModeStepService;
import com.s3s.solutions.eone.service.wmd.systemoperationmodestep.SystemOperationModeStepVO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayService;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class OrderBizService {

	private final OrderService orderService;

	private final OrderGroupService orderGroupService;

	private final OrderTrayService orderTrayService;

	private final OrderTrayBizService orderTrayBizService;

	private final WorkPlanTrayService workPlanTrayService;

	private final OrderWorkBizService orderWorkBizService;

	private final TrayLocationBizService trayLocationBizService;

	private final OrderOperationHistoryBizService orderOperationHistoryBizService;

	private final BufferManager bufferManager;

	private final PLCManager plcManager;
	
	private final InterfaceBizService interfaceBizService;
	
	private final OrderWorkService orderWorkService;
	
	private final SystemOperationModeStepService systemOperationModeStepService;
	
	private final OrderOperationHistoryService orderOperationHistoryService;

	/**
	 * 보관 - 배출처리
	 * @param orderVO
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void changeOperationDischargeInputOrderTray(OrderVO order) throws Exception {
		if(order.getOrderId() == null){
			log.error("지시번호가 없습니다!!");
			throw new SFPException("지시번호가 없습니다!!", new Throwable());
		}
		
		//현재 등록된 동작 히스토리 조회
		List<OrderOperationHistoryVO> opList = orderOperationHistoryService.getOrderOperationHistoryList(new OrderOperationHistoryVO() {{
			setOrderId(order.getOrderId());
		}});
		
		if (opList != null && opList.size() == 2 ) {
			String nowDate = DateTools.getDateTimeString();
			
			OrderOperationHistoryVO lastOp = ListTools.getLast(opList);
			
			lastOp.setOperationEndDt(nowDate);
			orderOperationHistoryService.modify(lastOp);
			
			//현재 오더 그룹 유형(입고, 출고, 조회)로 현재 스탭을 조회
			List<SystemOperationModeStepVO> stepList = systemOperationModeStepService.getList(new SystemOperationModeStepVO() {{
				setSystemOperationModeId(order.getOrderGroupTypeCd());
			}});
			
			OrderOperationHistoryVO op = new OrderOperationHistoryVO();
			op = BeanTools.mergeBean(op, ListTools.getLast(stepList), OrderOperationHistoryVO.class);
			op.setOrderId(order.getOrderId());
			op.setOrderGroupId(order.getOrderGroupId());
			op.setOperationStartDt(nowDate);
			orderOperationHistoryService.add(op);
		}
	}
	
	/**
	 * 보관 - 배출처리
	 * @param orderVO
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void dischargeInputOrderTray(OrderVO orderVO) throws Exception {

		if(orderVO.getOrderId() == null){
			log.error("지시번호가 없습니다!!");
			throw new SFPException("지시번호가 없습니다!!", new Throwable());
		}

		//배출 처리시 센서가 ON 되어있는 놈이 하나라도 있으면 안됨.
		if(bufferManager.getBufferSensorOnCountByLineNo(orderVO.getLineNo()) > 0) {
			throw new SFPException("미 배출된 TRAY가 있습니다.\\r\\n배출완료 할수 없습니다!", new Throwable());
		}

		OrderVO selectOrderVO = orderService.getOrderById(orderVO.getOrderId());

		if(selectOrderVO == null) {
			return;
		}
		
		//오더 완료 처리
		this.orderCompleteInputdischage(selectOrderVO);
		
		//현재 등록된 동작 히스토리 조회
		List<OrderOperationHistoryVO> opList = orderOperationHistoryService.getOrderOperationHistoryList(new OrderOperationHistoryVO() {{
			setOrderId(orderVO.getOrderId());
		}});
		OrderOperationHistoryVO lastOp = ListTools.getLast(opList);
		lastOp.setOperationEndDt(DateTools.getDateTimeString());
		orderOperationHistoryService.modify(lastOp);
	}
	
	/**
	 * 폐기 - 배출처리
	 * @param orderVO
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void dischargeOutputOrderTray(OrderVO orderVO) throws Exception {

		if(orderVO.getOrderId() == null){
			log.error("지시번호가 없습니다!!");
			throw new SFPException("지시번호가 없습니다!!", new Throwable());
		}

		//배출 처리시 센서가 ON 되어있는 놈이 하나라도 있으면 안됨.
		if(bufferManager.getBufferSensorOnCountByLineNo(orderVO.getLineNo()) > 0) {
			throw new SFPException("미 배출된 TRAY가 있습니다.\\r\\n배출완료 할수 없습니다!", new Throwable());
		}

		OrderVO selectOrderVO = orderService.getOrderById(orderVO.getOrderId());

		if(selectOrderVO == null) {
			return;
		}

		for (OrderTrayVO orderTrayVO : orderVO.getOrderTrayList()) {
			trayLocationBizService.updateTrayLocationByManual(selectOrderVO.getOrderGroupId(), selectOrderVO.getOrderId(), selectOrderVO.getOrderTypeCd(), orderTrayVO.getTrayId(), orderTrayVO.getBufferId());
			//
			try {
				
				OrderWorkVO orderWorkVO = orderWorkService.getOrderWorkByTrayId(new OrderWorkVO() {{
					setTrayId(orderTrayVO.getTrayId());
					setOrderId(orderVO.getOrderId());
				}});
				interfaceBizService.procYudoWork(orderWorkVO);
			} catch (Exception e) {
				log.error("트레이 처리 완료시 이원 작업완료 프로시저 오류");
			}
		}

		selectOrderVO.setWorkTrayQty(ListTools.getSize(orderVO.getOrderTrayList()));
		//오더 완료 처리
		this.orderComplete(selectOrderVO);
		orderOperationHistoryBizService.updateOperationHistoryByInquiryInput(orderVO.getOrderId());
	}

	/**
	 * 호출 - 배출처리
	 * @param orderVO
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void dischargeInquiryOutputOrderTray(OrderVO orderVO) throws Exception {

		if(orderVO.getOrderId() == null){
			log.error("오더아디가 없습니다!!");
			throw new SFPException("오더아디가 없습니다!!", new Throwable());
		}

		OrderVO selectOrderVO = orderService.getOrderById(orderVO.getOrderId());
 		for (OrderTrayVO orderTrayVO : orderVO.getOrderTrayList()) {
			trayLocationBizService.updateTrayLocationByManual(selectOrderVO.getOrderGroupId(), selectOrderVO.getOrderId(), selectOrderVO.getOrderTypeCd(), orderTrayVO.getTrayId(), orderTrayVO.getBufferId());
		}

		//처리 수량 업데이트
		orderService.modify(new OrderVO() {{
			setOrderId(selectOrderVO.getOrderId());
			plusWorkTrayQty(ListTools.getSize(orderVO.getOrderTrayList()));
		}});

		orderOperationHistoryBizService.updateOperationHistoryByOutput(orderVO.getOrderGroupId());
	}

	/**
	 * 호출 업무 - 트레이 확인완료
	 * @param orderVO
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void completeInquiryOutputOrderTray(OrderVO orderVO) throws Exception {

		if(orderVO.getOrderId() == null){
			log.error("지시번호가 없습니다!!");
			throw new SFPException("지시번호가 없습니다!!", new Throwable());
		}

		OrderVO selectOrderVO = orderService.getOrderById(orderVO.getOrderId());
		if(selectOrderVO == null) {
			return;
		}
		
		for (OrderTrayVO orderTrayVO : orderVO.getOrderTrayList()) {
			trayLocationBizService.updateTrayLocationByManual(selectOrderVO.getOrderGroupId(), selectOrderVO.getOrderId(), selectOrderVO.getOrderTypeCd(), orderTrayVO.getTrayId(), orderTrayVO.getBufferId());
		}
		
		
		List<TrayLocationVO> newTrayLocationList = trayLocationBizService.generateInputTrayLocationByLineNo(orderVO.getOrderTrayList());
		
		for (OrderTrayVO orderTrayVO : orderVO.getOrderTrayList()) {
			List<TrayLocationVO> filterTrayList = newTrayLocationList.stream().filter(r -> StringUtils.equals(orderTrayVO.getBufferId(), r.getBufferId())).collect(Collectors.toList());
			TrayLocationVO filterTray= ListTools.getFirst(filterTrayList);
			orderTrayVO.setRackId(filterTray.getRackId());
			orderTrayVO.setRackCellXAxis(filterTray.getRackCellXAxis());
			orderTrayVO.setRackCellYAxis(filterTray.getRackCellYAxis());
			//orderTrayVO.set
		}

		//호출 지시완료 처리
		this.orderComplete(selectOrderVO);

		int orderTyayCount = ListTools.getSize(orderVO.getOrderTrayList());

		if(orderTyayCount > 0) {
			//조회 입고 오더 생성
			this.generateInquiryInputOrder(selectOrderVO.getOrderGroupId(), orderVO.getOrderTrayList(), orderVO.getLineNo());
		}else {
			//입고할 목록이 없으면 오더 그룹도 완료 처리!
			orderGroupService.modify(new OrderGroupDTO() {{
				setOrderGroupId(selectOrderVO.getOrderGroupId());
				setOrderGroupStatusCd(EOrderGroupStatus.COMPLETE.name());
				setOrderGroupEndDt(DateTools.getDateTimeString());
			}});
		}
	}

	/**
	 * INPUT - 입고 오더 생성 및 TRAY 위치 선정
	 * @param orderTraySaveList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void generateInputOrder(String orderGroupId, String orderId, List<OrderTrayVO> orderTraySaveList) throws Exception {
		//오더 저장
		orderService.addOrderByOrderType(orderGroupId, orderId, orderTraySaveList, EOrderType.INPUT);
		//오더 TRAY 저장
		orderTrayService.addList(orderTraySaveList);
		//wmd_order_work 저장
		orderWorkBizService.addOrderWorkByOrderTrayList(orderTraySaveList);
	}
	
	/**
	 * 지시 및 지시 작업 목록 입력
	 * @param lineNo
	 * @param orderGroupId
	 * @param orderId
	 * @param orderTraySaveList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void generateInputOrderByLineNo(String lineNo, String orderGroupId, String orderId, List<OrderTrayVO> orderTraySaveList) throws Exception {
		//오더 저장
		orderService.addOrderByOrderTypeByLineNo(lineNo, orderGroupId, orderId, orderTraySaveList, EOrderType.INPUT);
		for(OrderTrayVO orderTrayVO : orderTraySaveList) {
			orderTrayVO.setInOutTypeCd(EInOutType.INPUT.name());
			orderTrayVO.setOrderId(orderId);
		}
		//오더 TRAY 저장
		orderTrayService.addList(orderTraySaveList);
		//wmd_order_work 저장
		orderWorkBizService.addOrderWorkByOrderTrayListByLineNo(orderTraySaveList);
	}


	/**
	 * INQUIRY INPUT - 입고 오더 생성 및 TRAY 위치 선정
	 * @param orderTraySaveList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void generateInquiryInputOrder(String orderGroupId, List<OrderTrayVO> orderTrayList, String lineNo) throws Exception {

		//진행중인 오더 체크
		if(orderService.getReadyOrIngOrderByLineNo(lineNo) != null) {
			log.error("진행중인 지시가 존재합니다!");
			throw new SFPException("진행중인 지시가 존재합니다!", new Throwable());
		}

		if(StringUtils.isEmpty(orderGroupId)) {
			log.error("지시그룹번호는 필수 입니다!");
			throw new SFPException("지시그룹번호는 필수 입니다!", new Throwable());
		}

		OrderGroupVO orderGroupVO = orderGroupService.getOrderGroupVO(orderGroupId);

		if(orderGroupVO == null) {
			log.error(orderGroupId + " 지시그룹이 조회 되지 않습니다.!");
			throw new SFPException(orderGroupId + " 지시그룹이 조회 되지 않습니다.!", new Throwable());
		}

		if(!StringUtils.equalsIgnoreCase(orderGroupVO.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name())) {
			log.error(orderGroupId + " 호출지시그룹이 아닙니다!");
			throw new SFPException(orderGroupId + " 호출지시그룹이 아닙니다!", new Throwable());
		}

		//String orderId = GeneratorIDTools.getId("WO");
		String orderId = GeneratorIDTools.getId("");

		//입고 TRAY 목록 생성
		List<OrderTrayVO> orderTraySaveList = orderTrayBizService.generateInputOrderTrayByLineNo(orderGroupVO.getLineNo(), orderId, orderTrayList);

		//입고 오더 등록
		generateInputOrderByLineNo(orderGroupVO.getLineNo(), orderGroupId, orderId, orderTraySaveList);

		//TODO - daniel 우선 조회 입고 생성시에 이력 update
		orderOperationHistoryBizService.updateOperationHistoryByInquiryInput(orderId);
	}

	/**
	 * OUTPUT - 출고 Order, Order Tray 생성
	 * @param orderTraySaveList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void generateOutputOrder(String lineNo, String orderGroupId, String orderId, List<OrderTrayVO> orderTraySaveList) throws Exception {

		//작업 계획 TRAY 상태 변경
		workPlanTrayService.changeTrayStatus(orderTraySaveList, ETrayStatus.ING, SfpConst.YN_Y);

		//오더 저장
		orderService.addOrderByOrderTypeByLineNo(lineNo, orderGroupId, orderId, orderTraySaveList, EOrderType.OUTPUT);

		//오더 TRAY 저장
		orderTrayService.addList(orderTraySaveList);

		//wmd_order_work 저장
		orderWorkBizService.addOrderWorkByOrderTrayList(orderTraySaveList);
	}

	/*
	 * 오더 id로 오더 조회
	 */
	public OrderVO getOrderById(String orderId) throws Exception{
		return orderService.getOrderById(orderId);
	}
	
	

	/**
	 * 지시 시작
	 * @param order
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void orderStart(OrderVO order) throws Exception{
		boolean changeStatus = false;
		boolean changeWorkQty = false;

		//대기 상태 일 경우  진행상태로 변경
		if(StringUtils.equals(order.getOrderStatusCd(), EOrderStatus.READY.name())) {
			order.setOrderStatusCd(EOrderStatus.ING.name());
			order.setOrderStartDt(DateTools.getDateTimeString());
			changeStatus = true;
		}

		//지시 트레이수 
		int workTrayQty = NumberTools.nullToZero(order.getWorkTrayQty());
		//기존 데이터와 같으면 반환
		if(workTrayQty != order.getChangeWorkTrayQty() && order.getChangeWorkTrayQty() != 0) {
			order.setWorkTrayQty(order.getChangeWorkTrayQty());
			changeWorkQty = true;
		}

		//뭔가 바뀌면 modify 해야함.
		if(changeStatus || changeWorkQty) {
			orderService.modify(order);
			OrderGroupVO orderGroup = orderGroupService.getOrderGroupVO(order.getOrderGroupId());
			
			if(StringUtils.equals(orderGroup.getOrderGroupStatusCd(), EOrderGroupStatus.READY.name())) {
				orderGroup.setOrderGroupStatusCd(EOrderGroupStatus.ING.name());
				orderGroup.setOrderGroupStartDt(DateTools.getDateTimeString());
			}
			orderGroup.setWorkTrayQty(order.getChangeWorkTrayQty());
			orderGroupService.modify(orderGroup);
		}
	}

	/**
	 * 지시 정보 완료처리, 작업계획 트레이 완료처리
	 * 지시그룹 수정 처리
	 * @param order : 디비에 있는 지시정보
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void orderComplete(OrderVO order) throws Exception{
		boolean changeStatus = false;
		boolean changeWorkQty = false;
		if(!StringUtils.equals(order.getOrderStatusCd(), EOrderStatus.COMPLETE.name())) {
			order.setOrderStatusCd(EOrderStatus.COMPLETE.name());
			order.setOrderEndDt(DateTools.getDateTimeString());
			changeStatus = true;
		}

		int workTrayQty = NumberTools.nullToZero(order.getWorkTrayQty());
		if(workTrayQty != order.getChangeWorkTrayQty() && order.getChangeWorkTrayQty() != 0) {
			order.setWorkTrayQty(order.getChangeWorkTrayQty());
			changeWorkQty = true;
		}

		//뭔가 바뀌면 modify 해야함.
		if(changeStatus || changeWorkQty) {
			if (StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name())  && StringUtils.equals(order.getOrderTypeCd(), EOrderType.OUTPUT.name())) {
				order.setWorkTrayQty(order.getOrderTrayQty());
			}
			orderService.modify(order);
			if(changeStatus) {
				List<OrderWorkVO> workList = orderWorkBizService.getOrderWorkListByOrder(order);
				List<String> planNoList = new ArrayList<>();
				for (OrderWorkVO work : workList) {
					planNoList.add(work.getPlanNo());
				}
				
				//호출 업무의 배출업무가 아닐경우
				if ( !(StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name())  && StringUtils.equals(order.getOrderTypeCd(), EOrderType.OUTPUT.name()))) {
					workPlanTrayService.updateCompleteWorkPlanTrayListByPlanNo(new WorkPlanTrayVO() {{
						setPlanNoList(planNoList);
					}});
				}
				
			}
			
			OrderGroupVO orderGroup = orderGroupService.getOrderGroupVO(order.getOrderGroupId());
			//호출이고 입고가 완료될 경우 orderGroup 완료 변경
			if(StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name()) && StringUtils.equals(order.getOrderTypeCd(), EOrderType.INPUT.name())) {
				if(!StringUtils.equals(orderGroup.getOrderGroupStatusCd(), EOrderGroupStatus.COMPLETE.name())) { //지시그룹 완료가 아닐때 완료처리
					orderGroup.setOrderGroupStatusCd(EOrderGroupStatus.COMPLETE.name());
					orderGroup.setOrderGroupFinishTypeCd(EOrderGroupFinishStatus.SUCCESS.name());
					orderGroup.setWorkTrayQty(orderGroup.getOrderTrayQty());
					orderGroup.setOrderGroupEndDt(DateTools.getDateTimeString());
				} else {
					//조회이면 작업수량은 오더 수량과같기때문에 위와 같이 처리
					orderGroup.setWorkTrayQty(orderGroup.getOrderTrayQty());
				}
			} else if(StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name()) && StringUtils.equals(order.getOrderTypeCd(), EOrderType.OUTPUT.name())) {
				orderGroup.setWorkTrayQty(order.getWorkTrayQty());
			} else {
				//나머지는 해당 작업수량으로 처리해야하므로
				orderGroup.setOrderGroupStatusCd(EOrderGroupStatus.COMPLETE.name());
				orderGroup.setOrderGroupFinishTypeCd(EOrderGroupFinishStatus.SUCCESS.name());
 				orderGroup.setWorkTrayQty(order.getWorkTrayQty());
				orderGroup.setOrderGroupEndDt(DateTools.getDateTimeString());
			}
			orderGroupService.modify(orderGroup);
		}
	}
	
	/**
	 * 보관 - 배출 처리
	 * @param order
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void orderCompleteInputdischage(OrderVO order)  throws Exception {
		if(!StringUtils.equals(order.getOrderStatusCd(), EOrderStatus.COMPLETE.name())) {
			order.setOrderStatusCd(EOrderStatus.COMPLETE.name());
			order.setOrderEndDt(DateTools.getDateTimeString());
		}
		orderService.modify(order);
		
		OrderGroupVO orderGroup = orderGroupService.getOrderGroupVO(order.getOrderGroupId());
		if(StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INPUT.name())
				&& StringUtils.equals(order.getOrderTypeCd(), EOrderType.INPUT.name())) {
			orderGroup.setOrderGroupStatusCd(EOrderGroupStatus.COMPLETE.name());
			orderGroup.setOrderGroupFinishTypeCd(EOrderGroupFinishStatus.SUCCESS.name());
			orderGroup.setOrderGroupEndDt(DateTools.getDateTimeString());
		}
		orderGroupService.modify(orderGroup);
	}

	/**
	 * 현재 대기중인 지시 목록 조회
	 * @return
	 * @throws Exception
	 */
	public List<OrderVO> getReadyOrderList() throws Exception{
		return orderService.getReadyOrderList();
	}

	/**
	 * 호출 진행 중인 지시그룹을 조회하여
	 * 반출(order_type_cd = 'OUTPUT')의 진행 중(order_status_cd = 'ING')인 지시를 조회하여 반환한다.
	 * @return
	 * @throws Exception
	 */
	public OrderVO getOutputOrderByIngInquiryOrderGroup(String lineNo) throws Exception{
		OrderGroupVO orderGroup = orderGroupService.getIngInquiryOrderGroup(lineNo);

		if(orderGroup == null) {
			return null;
		}

		List<OrderVO> orderList = orderService.getList(new OrderVO() {{
			setOrderGroupId(orderGroup.getOrderGroupId());
			setOrderTypeCd(EOrderType.OUTPUT.name());
			setOrderStatusCd(EOrderStatus.ING.name());
		}});

		//아마 하나밖에 없을 것임.
		if(ListTools.getSize(orderList) == 0) {
			return null;
		}
		return ListTools.getFirst(orderList);
	}
	
	/**
	 * 반출(폐기, 호출) 진행중인 지시그룹 조회
	 * @return
	 * @throws Exception
	 */
	public OrderVO getOutputOrderByIngOrderGroup(String lineNo) throws Exception{
		OrderGroupVO orderGroup = orderGroupService.getIngOutputInQuiryOrderGroup(lineNo);

		if(orderGroup == null) {
			return null;
		}

		List<OrderVO> orderList = orderService.getList(new OrderVO() {{
			setOrderGroupId(orderGroup.getOrderGroupId());
			setOrderTypeCd(EOrderType.OUTPUT.name());
			setOrderStatusCd(EOrderStatus.ING.name());
		}});

		//아마 하나밖에 없을 것임.
		if(ListTools.getSize(orderList) == 0) {
			return null;
		}
		return ListTools.getFirst(orderList);
	}
	
	
}