package com.s3s.solutions.eone.biz;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.define.EInOutType;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.define.EOrderWorkStatus;
import com.s3s.solutions.eone.define.ETrayProcStatus;
import com.s3s.solutions.eone.define.EWorkStatus;
import com.s3s.solutions.eone.dmw.command.message.body.OrderReportBody;
import com.s3s.solutions.eone.service.wmd.order.OrderService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkService;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.orderwork.dto.OrderWorkDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class OrderWorkBizService {

	private final OrderWorkService orderWorkService;

	private final OrderService orderService;

	private final OrderGroupService orderGroupService;

	private final TrayLocationBizService trayLocationBizService;
	
	private final OrderTrayBizService orderTrayBizService;
	
	private final InterfaceBizService interfaceBizService;

	/**
	 * 새롭게 들어온 주문의 버퍼 셀 정보를 바탕으로
	 * 지시 작업 목록 수정
	 * @param order : DB 주문
	 * @param changeOrder : plc 주문
	 * @return
	 * @throws Exception
	 */
	public int trayProcess(OrderVO order, OrderReportBody changeOrder) throws Exception {
		int resultTrayCnt = 0;
		Map<String, Object> orderTrayMap = changeOrder.getOrderTrayProcStatus(); //새롭게 들어온 주문의 버퍼셀 정보
		List<OrderWorkVO> workList = orderWorkService.getOrderWorkListByOrderId(order.getOrderId()); //해당 지시 작업 트레이 목록 조회 
		
		for(String bufferId : orderTrayMap.keySet()) {
			Map<String, String> bufferMap = (Map<String, String>)orderTrayMap.get(bufferId);
			
			String procStatus = bufferMap.getOrDefault("orderProcBufferQRReadStatus", "0"); // 0:대기, 1:성공, 2:실패
			String trayId = bufferMap.get("orderProcBufferQRReadInfo");
			
			if (StringUtils.isBlank(trayId) || "null".equals(trayId)) {
				trayId = null;
			}

			//READY 가 아니면.
			if(!StringUtils.equals(procStatus, ETrayProcStatus.READY.getCode())) {
				//여기서 order_work의 단건식 처리하는 부분
				//TODO yudo-work 부분 추가 되는 자리임(다 처리하고 난뒤에 하는건지 여기서 하는건지 확인이 필요함) -아래 workComplete 안에서 해야하는것도 고려
				//작업 buffer cell 조회
				OrderWorkVO work = ListTools.getFirst(workList.stream().filter(o -> StringUtils.equals(o.getBufferId(), bufferId)).collect(Collectors.toList()));
				if(work == null) {
					continue;
				}

				if (StringUtils.equals(procStatus, ETrayProcStatus.COMPLETE.getCode()) && StringUtils.isNotBlank(trayId)){
					work.setOrderGroupId(order.getOrderGroupId());
					work.setTrayId(trayId);
					workComplete(work, order);
				} else if (StringUtils.equals(procStatus, ETrayProcStatus.EXCEPTION.getCode())){
					work.setOrderGroupId(order.getOrderGroupId());
					//work.setTrayId(trayId);
					workError(work);
				}
			}
		}
		
		//입고일 경우에는 완료된 수를 카운트하여 오더에 반영
		if(StringUtils.equals(order.getOrderTypeCd(), EOrderType.INPUT.name())) {
			List<OrderWorkVO> completeWorkList = orderWorkService.getList(new OrderWorkVO() {{
				setOrderId(order.getOrderId());
				setWorkStatusCd(EWorkStatus.COMPLETE.name());
			}});
			resultTrayCnt = ListTools.getSize(completeWorkList);
		}
		return resultTrayCnt;
	}

	public void workStart(OrderWorkVO work) throws Exception{
		if(StringUtils.equals(work.getWorkStatusCd(), EOrderWorkStatus.READY.name()) == false) {
			return;
		}
		work.setWorkStatusCd(EOrderWorkStatus.ING.name());
		orderWorkService.modify(work);
	}

	/**
	 * 작업 처리 상태가 완료일 경우 DB의 트레이가 진행중이 아닐경우 업데이트 하지 않고 진행중일 경우 완료처리한다.
	 * TO-BE 대기 상태가 아닐 경우 skip하고 대기 상태일 경우 완료 처리한다.
	 * @param work
	 * @throws Exception
	 */
	public void workComplete(OrderWorkVO work, OrderVO order) throws Exception{
		//완료이면 반환

		if(!StringUtils.equals(work.getWorkStatusCd(), EOrderWorkStatus.READY.name())) {
			return;
		}
		work.setWorkStatusCd(EOrderWorkStatus.COMPLETE.name());
		orderWorkService.modify(work);
		
		//완료일 때 지시별 트레이 정보에 트레이번호를 변경해준다
		orderTrayBizService.updateTrayNoByPlc(work);

		//완료일 때는 위치 변경 및 트레이 위치 변경
		trayLocationBizService.updateTrayLocationByPlc(work, order);
		
		try {
			if (StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INPUT.name()) || 
					(StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name()) && StringUtils.equals(order.getOrderTypeCd(), EOrderType.INPUT.name()))) {
				interfaceBizService.procYudoWork(work);
			}
		} catch (Exception e) {
			log.error("트레이 처리 완료시 이원 작업완료 프로시저 오류");
		}
	}

	public void workError(OrderWorkVO work) throws Exception{
		//완료이면 반환
		if(StringUtils.equals(work.getWorkStatusCd(), EOrderWorkStatus.ERROR.name())) {
			return;
		}
		work.setWorkStatusCd(EOrderWorkStatus.ERROR.name());
		orderWorkService.modify(work);

		//완료일 때는 위치 변경 및 트레이 위치 변경
//		trayLocationBizService.updateTrayLocationByPlc(work);
		
		try {
			interfaceBizService.procYudoWork(work);
		} catch (Exception e) {
			log.error("트레이 처리 완료시 이원 작업완료 프로시저 오류");
		}
	}


	public List<OrderWorkVO> getOrderWorkListByOrderGroupId(OrderVO orderVO) throws Exception {

		if(StringUtils.isEmpty(orderVO.getOrderGroupId())) {
			return new ArrayList<>();
		}

		OrderVO selectOrderVO = ListTools.getFirst(orderService.getList(new OrderVO() {{
			setOrderGroupId(orderVO.getOrderGroupId());
			//setOrderTypeCd(EOrderType.OUTPUT.name());
		}}));

		if(selectOrderVO == null) {
			return new ArrayList<>();
		}

		List<OrderWorkVO> orderWorkList = orderWorkService.getList(new OrderWorkVO() {{
			setOrderId(selectOrderVO.getOrderId());
		}});

		return orderWorkList;
	}

	public List<OrderWorkVO> getOrderWorkHistoryListByOrderGroupId(OrderVO orderVO) throws Exception {

		if(StringUtils.isEmpty(orderVO.getOrderGroupId())) {
			return new ArrayList<>();
		}

		OrderGroupVO orderGroupVO = orderGroupService.getDetail(new OrderGroupVO() {{
			setOrderGroupId(orderVO.getOrderGroupId());
		}});

		if(orderGroupVO == null) {
			return new ArrayList<>();
		}

		OrderVO outputOrderVO = ListTools.getFirst(orderService.getList(new OrderVO() {{
			setOrderGroupId(orderVO.getOrderGroupId());
			setOrderTypeCd(EOrderType.OUTPUT.name());
		}}));


		OrderVO inputOrderVO = ListTools.getFirst(orderService.getList(new OrderVO() {{
			setOrderGroupId(orderVO.getOrderGroupId());
			setOrderTypeCd(EOrderType.INPUT.name());
		}}));

		return makeOrderWorkHistory(orderGroupVO, outputOrderVO, inputOrderVO);
	}

	public List<OrderWorkVO> makeOrderWorkHistory(OrderGroupVO orderGroupVO, OrderVO outputOrderVO, OrderVO inputOrderVO) throws Exception{
		List<OrderWorkVO> orderWorkHistoryList = new ArrayList<>();

		if(StringUtils.equals(orderGroupVO.getOrderGroupTypeCd(), EOrderGroupType.OUTPUT.name())) {
			if(outputOrderVO == null) {
				return orderWorkHistoryList;
			}
			return orderWorkService.getList(new OrderWorkVO() {{
				setOrderId(outputOrderVO.getOrderId());
			}});
		}else if(StringUtils.equals(orderGroupVO.getOrderGroupTypeCd(), EOrderGroupType.INPUT.name())) {
			if(inputOrderVO == null) {
				return orderWorkHistoryList;
			}
			return orderWorkService.getList(new OrderWorkVO() {{
				setOrderId(inputOrderVO.getOrderId());
			}});
		}else if(StringUtils.equals(orderGroupVO.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name())) {
			if(outputOrderVO == null) {
				return orderWorkHistoryList;
			}

			List<OrderWorkVO> outputOrderWorkList = orderWorkService.getList(new OrderWorkVO() {{
				setOrderId(outputOrderVO.getOrderId());
			}});

			if(inputOrderVO == null) {
				return outputOrderWorkList;
			}

			List<OrderWorkVO> inputOrderWorkList = orderWorkService.getList(new OrderWorkVO() {{
				setOrderId(inputOrderVO.getOrderId());
			}});

			for (OrderWorkVO orderWorkVO : outputOrderWorkList) {
				orderWorkHistoryList.add(orderWorkVO);
				OrderWorkVO inputOrderWorkVO = getOrderWork(inputOrderWorkList, orderWorkVO.getTrayId());
				if(inputOrderWorkVO == null) {
					orderWorkHistoryList.add(new OrderWorkVO() {{
						setTrayId(orderWorkVO.getTrayId());
						setBufferId(orderWorkVO.getBufferId());
						setInOutTypeCd(EInOutType.INPUT.name());
					}});
				}else {
					orderWorkHistoryList.add(inputOrderWorkVO);
				}
			}
		}

		return orderWorkHistoryList;
	}

	public OrderWorkVO getOrderWork(List<OrderWorkVO> orderWorkList, String trayId) {
		for (OrderWorkVO orderWorkVO : orderWorkList) {
			if(StringUtils.equals(orderWorkVO.getTrayId(), trayId)) {
				return orderWorkVO;
			}
		}
		return null;
	}

	/**
	 * @param orderTrayList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void addOrderWorkByOrderTrayList(List<OrderTrayVO> orderTrayList) throws Exception{
		for (OrderTrayVO orderTrayVO : orderTrayList) {
			//orderTrayVO에 tray 정보가 있는경우만 orderWork에 반영 해준다!
			if(StringUtils.isNotEmpty(orderTrayVO.getTrayId())) {
				orderWorkService.add(new OrderWorkDTO() {{
					setOrderId(orderTrayVO.getOrderId());
					setBufferId(orderTrayVO.getBufferId());
					setInOutTypeCd(orderTrayVO.getInOutTypeCd());
					if(StringUtils.isNotEmpty(orderTrayVO.getPlanNo())) {
						setPlanNo(orderTrayVO.getPlanNo());
					}
					setTrayId(orderTrayVO.getTrayId());
					setRackId(orderTrayVO.getRackId());
					setRackCellXAxis(orderTrayVO.getRackCellXAxis());
					setRackCellYAxis(orderTrayVO.getRackCellYAxis());
					setInquiryQty(0);
					setWorkStatusCd(EWorkStatus.READY.name());
				}});
			}
		}
	}
	
	/**
	 * new
	 * @param orderTrayList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void addOrderWorkByOrderTrayListByLineNo(List<OrderTrayVO> orderTrayList) throws Exception{
		for (OrderTrayVO orderTrayVO : orderTrayList) {
			//orderTrayVO에 tray 정보가 있는경우만 orderWork에 반영 해준다!
			//if(StringUtils.isNotEmpty(orderTrayVO.getTrayId())) {
				orderWorkService.add(new OrderWorkDTO() {{
					setOrderId(orderTrayVO.getOrderId());
					setBufferId(orderTrayVO.getBufferId());
					setInOutTypeCd(orderTrayVO.getInOutTypeCd());
					if(StringUtils.isNotEmpty(orderTrayVO.getPlanNo())) {
						setPlanNo(orderTrayVO.getPlanNo());
					}
					setTrayId(orderTrayVO.getTrayId());
					setRackId(orderTrayVO.getRackId());
					setRackCellXAxis(orderTrayVO.getRackCellXAxis());
					setRackCellYAxis(orderTrayVO.getRackCellYAxis());
					setInquiryQty(0);
					setWorkStatusCd(EWorkStatus.READY.name());
					setPlanNo(orderTrayVO.getPlanNo());
				}});
			//}
		}
	}

	/**
	 * 해당 지시번호의 작업 목록(wmd_order_work)을 반환한다.
	 * @param order : 현재 진행중인 호출 주문
	 * @return 현재 대기중인 지시의 작업 목록
	 * @throws Exception
	 */
	public List<OrderWorkVO> getOrderWorkListByOrder(OrderVO order) throws Exception{
		return orderWorkService.getOrderWorkListByOrderId(order.getOrderId());
	}
}