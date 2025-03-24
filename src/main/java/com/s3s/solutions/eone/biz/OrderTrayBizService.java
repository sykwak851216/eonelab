package com.s3s.solutions.eone.biz;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.exception.SFPException;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.define.EInOutType;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.service.wmd.order.OrderSaveVO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayService;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationService;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationSummaryVO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayService;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayVO;
import com.s3s.solutions.eone.service.wmd.workplantray.dto.WorkPlanTrayDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class OrderTrayBizService {

	private final WorkPlanTrayService workPlanTrayService;

	private final TrayLocationService trayLocationService;
	
	private final OrderTrayService orderTrayService;
	
	private final InterfaceBizService interfaceBizService;

	/**
	 * 출고 TRAY 선정
	 * @param orderId
	 * @param eOrderType
	 * @return
	 * @throws Exception
	 */
	public List<OrderTrayVO> generateOuputOrderTray(String orderId, EOrderType eOrderType) throws Exception {

		//긴급 출고 대기건 조회
		List<WorkPlanTrayVO> workPlanTrayEmergencyList = workPlanTrayService.getWorkPlanTrayListByReadyEmengency(eOrderType);

		//일반 출고 대기건 조회
		List<WorkPlanTrayVO> workPlanTrayNormalList = workPlanTrayService.getWorkPlanTrayListByReadyNormal(eOrderType);

		if(workPlanTrayEmergencyList.size() == 0 && workPlanTrayNormalList.size() == 0) {
			log.error("출고 계획 TRAY가 존재 하지 않습니다.!");
			throw new SFPException("출고 계획 TRAY가 존재 하지 않습니다.!", new Throwable());
		}

		//RACK 안에 있는 TRAY 목록 - GANTRY별
		List<TrayLocationSummaryVO> trayLocationSummaryList = trayLocationService.getRackInTrayListGroupByMcId();

		if(ListTools.isNullOrEmpty(trayLocationSummaryList)) {
			log.error("RACK에 TRAY가 존재 하지 않습니다.");
			throw new SFPException("RACK에 TRAY가 존재 하지 않습니다.", new Throwable());
		}

		//긴급 출고건을 GANTRY별로 출고 가능한 수량을 계산
		List<OrderSaveVO> orderSaveEmergencyList = makeOuputOrderTrayListByTrayLocationSummary(workPlanTrayEmergencyList, trayLocationSummaryList);

		//일반 출고건을 GANTRY별로 출고 가능한 수량을 계산일반 출고건 계산 결과
		List<OrderSaveVO> orderSaveNormalList = makeOuputOrderTrayListByTrayLocationSummary(workPlanTrayNormalList, trayLocationSummaryList);

		//출고 order tray 결과
		List<OrderTrayVO> orderTraySaveList = new ArrayList<>();

		//긴급 계산 결과 가지고 MaxBufferSize 만큼 가져온다
		extractionOutputOrderTrayByMaxBufferSize(orderId, orderSaveEmergencyList, orderTraySaveList);

		//일반 계산 결과 가지고 MaxBufferSize 만큼 가져온다
		extractionOutputOrderTrayByMaxBufferSize(orderId, orderSaveNormalList, orderTraySaveList);

		if(ListTools.isNullOrEmpty(orderTraySaveList)) {
			log.error("계획 출고 TRAY이 목록이 RACK에 존재 하지 않습니다.");
			throw new SFPException("계획 출고 TRAY이 목록이 RACK에 존재 하지 않습니다.", new Throwable());
		}

		//RACK ID로 오름 차순 정렬
		orderTraySaveList = orderTraySaveList.stream().sorted(Comparator.comparing(OrderTrayVO::getRackId)).collect(Collectors.toList());

		AtomicInteger bufferId = new AtomicInteger(1);
		for (OrderTrayVO orderTrayVO : orderTraySaveList) {
			//버퍼ID 셋팅
			orderTrayVO.setBufferId(String.valueOf(bufferId.getAndIncrement()));
		}

		//8개가 안찼으면 빈값으로 채운다!
		//fillOutputOrderTrayByMaxBufferSize(orderId, EInOutType.OUTPUT, orderTraySaveList);

		return orderTraySaveList;
	}
	
	/**
	 * 출고 TRAY 선정
	 * @param orderId
	 * @param eOrderType
	 * @return
	 * @throws Exception
	 */
	public List<OrderTrayVO> generateOuputOrderTrayByLineNo(String lineNo, String orderId, EOrderType eOrderType) throws Exception {
		List<OrderTrayVO> orderTraySaveList = new ArrayList<OrderTrayVO>();
		//긴급 출고 대기건 조회
		List<WorkPlanTrayVO> workPlanTrayEmergencyList = workPlanTrayService.getWorkPlanTrayListByReadyEmengencyByLineNo(eOrderType, lineNo);

		//일반 출고 대기건 조회
		List<WorkPlanTrayVO> workPlanTrayNormalList = new ArrayList<WorkPlanTrayVO>();
		if (workPlanTrayEmergencyList.size() == 0) {
			workPlanTrayNormalList = workPlanTrayService.getWorkPlanTrayListByReadyNormalByLineNo(eOrderType, lineNo);
		}
		
		int trayCount = workPlanTrayEmergencyList.size() + workPlanTrayNormalList.size();
		if(trayCount == 0) {
			log.error("출고 계획 TRAY가 존재 하지 않습니다.!");
			throw new SFPException("출고 계획 TRAY가 존재 하지 않습니다.!", new Throwable());
		}

		
		/*
		 * TO-DO
		if(ListTools.isNullOrEmpty(trayLocationSummaryList)) {
			log.error("RACK에 TRAY가 존재 하지 않습니다.");
			throw new SFPException("RACK에 TRAY가 존재 하지 않습니다.", new Throwable());
		}
		*/

		List<TrayLocationVO> trayLocationList = trayLocationService.getGenerateRackEmptyCellListByLineNo(lineNo, trayCount);
		if(ListTools.isNullOrEmpty(trayLocationList)) {
			log.error("계획 출고 TRAY이 목록이 RACK에 존재 하지 않습니다.");
			throw new SFPException("계획 출고 TRAY이 목록이 RACK에 존재 하지 않습니다.", new Throwable());
		}
		
		
		if (workPlanTrayEmergencyList.size() > 0) {
			for (WorkPlanTrayVO workPlanTrayVO: workPlanTrayEmergencyList) {
				orderTraySaveList.add(new OrderTrayVO() {{
					setOrderId(orderId);
					setLineNo(workPlanTrayVO.getLineNo());
					setPlanNo(workPlanTrayVO.getPlanNo());
					setInOutTypeCd(EInOutType.OUTPUT.name());
					setTrayId(workPlanTrayVO.getTrayId());
					setRackId(workPlanTrayVO.getRackId());
					setRackCellXAxis(workPlanTrayVO.getRackCellXAxis());
					setRackCellYAxis(workPlanTrayVO.getRackCellYAxis());
				}});
			}
		} else {
			for (WorkPlanTrayVO workPlanTrayVO: workPlanTrayNormalList) {
				orderTraySaveList.add(new OrderTrayVO() {{
					setOrderId(orderId);
					setLineNo(workPlanTrayVO.getLineNo());
					setPlanNo(workPlanTrayVO.getPlanNo());
					setInOutTypeCd(EInOutType.OUTPUT.name());
					setTrayId(workPlanTrayVO.getTrayId());
					setRackId(workPlanTrayVO.getRackId());
					setRackCellXAxis(workPlanTrayVO.getRackCellXAxis());
					setRackCellYAxis(workPlanTrayVO.getRackCellYAxis());
				}});
			}
		}


		//RACK ID로 오름 차순 정렬
		orderTraySaveList = orderTraySaveList.stream().sorted(Comparator.comparing(OrderTrayVO::getRackId)).collect(Collectors.toList());
		if (orderTraySaveList.size() > 12) {
			orderTraySaveList = orderTraySaveList.stream().skip(0).limit(12).collect(Collectors.toList());
		}
		
		AtomicInteger bufferId = new AtomicInteger(1);
		for (OrderTrayVO orderTrayVO : orderTraySaveList) {
			//버퍼ID 셋팅
			orderTrayVO.setBufferId(String.valueOf(bufferId.getAndIncrement()));
		}
		return orderTraySaveList;
	}
	

	/**
	 * 입고 TRAY 선정
	 * @param orderId
	 * @param orderTrayList
	 * @return
	 * @throws Exception
	 */
	public List<OrderTrayVO> generateInputOrderTray(String orderId, List<OrderTrayVO> orderTrayList) throws Exception {

		//밸리데이션 체크!!
		checkInputOrderTrayValidation(orderTrayList);

		//GANTRY별로 그룹바이된 빈공간
		List<TrayLocationSummaryVO> trayLocationSummaryList = trayLocationService.getRackEmptyCellListGroupByMcId();

		//TRAY 있는 목록
		//List<OrderTrayVO> orderTrayListFilterTray = orderTrayList.stream().filter(r -> StringUtils.isNotEmpty(r.getTrayId())).collect(Collectors.toList());

		//TRAY 없는 목록
		//List<OrderTrayVO> orderTrayListFilterNoTray = orderTrayList.stream().filter(r -> StringUtils.isEmpty(r.getTrayId())).collect(Collectors.toList());

		//TRAY 있는 항목만 매핑
		List<OrderTrayVO> orderTraySaveList = extractionInputOrderTrayByMaxBufferSize(orderId, trayLocationSummaryList, orderTrayList);

		if(orderTrayList.size() > orderTraySaveList.size()) {
			int shortEmptyCellQty = (orderTrayList.size() - orderTraySaveList.size());
			log.error("RACK에 입고 공간 " + shortEmptyCellQty + "개의 셀이 부족 합니다!");
			throw new SFPException("RACK에 입고 공간 " + shortEmptyCellQty + "개의 셀이 부족 합니다!", new Throwable());
		}

		//TRAY 매핑 안된 버퍼 목록도 기존 목록에 추가!
//		orderTraySaveList.addAll(fillInputOrderTrayByMaxBufferSize(orderId, orderTrayList));

		//RACK 빈공간에 입고할 Tray 매핑
//		return extractionInputOrderTrayByMaxBufferSize(orderId, trayLocationSummaryList, orderTrayList);
		return orderTraySaveList;
	}
	
	/**
	 * 입고 TRAY 선정
	 * @param orderId
	 * @param orderTrayList
	 * @return
	 * @throws Exception
	 */
	public List<OrderTrayVO> generateInputOrderTrayByLineNo(String lineNo, String orderId, List<OrderTrayVO> orderTrayList) throws Exception {

		//밸리데이션 체크!!
		checkInputOrderTrayValidationByLineNo(orderTrayList);

		//GANTRY별로 그룹바이된 빈공간
		//FIXME order by에 rack_cell_x_axis 추가(door에서 가까운 것 부터 채움)
		// as-is : List<TrayLocationSummaryVO> trayLocationSummaryList = trayLocationService.getRackEmptyCellListGroupByMcId();
		
		List<TrayLocationSummaryVO> trayLocationSummaryList = trayLocationService.getRackEmptyCellListGroupByLineNo(lineNo);

		//TRAY 있는 목록
		//List<OrderTrayVO> orderTrayListFilterTray = orderTrayList.stream().filter(r -> StringUtils.isNotEmpty(r.getTrayId())).collect(Collectors.toList());

		//TRAY 없는 목록
		//List<OrderTrayVO> orderTrayListFilterNoTray = orderTrayList.stream().filter(r -> StringUtils.isEmpty(r.getTrayId())).collect(Collectors.toList());

		//TRAY 있는 항목만 매핑
		List<OrderTrayVO> orderTraySaveList = extractionInputOrderTrayByMaxBufferSize(orderId, trayLocationSummaryList, orderTrayList);

		if(orderTrayList.size() > orderTraySaveList.size()) {
			int shortEmptyCellQty = (orderTrayList.size() - orderTraySaveList.size());
			log.error("RACK에 입고 공간 " + shortEmptyCellQty + "개의 셀이 부족 합니다!");
			throw new SFPException("RACK에 입고 공간 " + shortEmptyCellQty + "개의 셀이 부족 합니다!", new Throwable());
		}

		//TRAY 매핑 안된 버퍼 목록도 기존 목록에 추가!
//		orderTraySaveList.addAll(fillInputOrderTrayByMaxBufferSize(orderId, orderTrayList));

		//RACK 빈공간에 입고할 Tray 매핑
//		return extractionInputOrderTrayByMaxBufferSize(orderId, trayLocationSummaryList, orderTrayList);
		return orderTraySaveList;
	}

	/**
	 * 버퍼 사이즈 만큼만 매핑 - 출고
	 * @param orderId
	 * @param orderSaveList
	 * @param orderTraySaveList
	 */
	private void extractionOutputOrderTrayByMaxBufferSize(String orderId, List<OrderSaveVO> orderSaveList, List<OrderTrayVO> orderTraySaveList) {
		if(orderTraySaveList == null || orderId == null) {
			return;
		}
		if(orderTraySaveList.size() == EoneConst.MAX_BUFFER_CELL_SIZE) {
			log.info(orderId + " orderTrayList bufffer size is full" + orderTraySaveList.toString());
			return;
		}
		for (OrderSaveVO orderSaveVO : orderSaveList) {
			for(OrderTrayVO orderTrayVO:orderSaveVO.getOrderTrayList()) {

				//orderTrayVO.setBufferId(String.valueOf(orderTraySaveList.size() + 1)); //버퍼 ID 셋팅
				orderTrayVO.setOrderId(orderId);//오더 ID 셋팅
				orderTraySaveList.add(orderTrayVO);

				//버퍼가 찼으면 리턴
				if(orderTraySaveList.size() == EoneConst.MAX_BUFFER_CELL_SIZE) {
					log.info(orderId + " orderTrayList bufffer size is full" + orderTraySaveList.toString());
					return;
				}
			}
		}
	}

	/**
	 * orderTrayList에 8개가 안찼으면 빈걸로 채워준다!
	 * @param orderId
	 * @param orderSaveList
	 * @param orderTraySaveList
	 */
	private void fillOutputOrderTrayByMaxBufferSize(String orderId, EInOutType eInOutType, List<OrderTrayVO> orderTraySaveList) {
		if(orderTraySaveList == null || orderId == null) {
			return;
		}
		if(orderTraySaveList.size() == EoneConst.MAX_BUFFER_CELL_SIZE) {
			log.info(orderId + " orderTrayList bufffer size is full" + orderTraySaveList.toString());
			return;
		}
		IntStream.range(orderTraySaveList.size(), EoneConst.MAX_BUFFER_CELL_SIZE).forEach(i->{
			OrderTrayVO orderTrayVO = new OrderTrayVO();
			orderTrayVO.setBufferId(String.valueOf(orderTraySaveList.size() + 1)); //버퍼 ID 셋팅
			orderTrayVO.setInOutTypeCd(eInOutType.name());
			orderTrayVO.setOrderId(orderId);//오더 ID 셋팅
			orderTrayVO.setRackCellXAxis(0);
			orderTrayVO.setRackCellYAxis(0);
			orderTraySaveList.add(orderTrayVO);
		});
	}

	/**
	 * 버퍼 사이즈 만큼만 매핑 - 입고
	 * @param orderId
	 * @param trayLocationSummaryList : 겐트리별 비어 있는 랙셀목록
	 * @param orderTrayList : 화면에서 받은 트레이 목록
	 * @return
	 */
	private List<OrderTrayVO> extractionInputOrderTrayByMaxBufferSize(String orderId, List<TrayLocationSummaryVO> trayLocationSummaryList, List<OrderTrayVO> orderTrayList) {
		List<OrderTrayVO> orderTraySaveList = new ArrayList<>();

		//버퍼ID로 정렬
		orderTrayList = orderTrayList.stream().sorted(Comparator.comparing(OrderTrayVO::getBufferId)).collect(Collectors.toList());

		for(OrderTrayVO orderTrayVO : orderTrayList) {
			TrayLocationVO trayLocationVO = getTrayLocationVOTopOne(trayLocationSummaryList);
			//입고 빈공간이 없는경우! 입셉션 발생 시킬까??
			if(trayLocationVO == null) {
				return orderTraySaveList;
			}
			orderTraySaveList.add(new OrderTrayVO() {{
				setOrderId(orderId);
				setRackId(trayLocationVO.getRackId());
				setRackCellXAxis(trayLocationVO.getRackCellXAxis());
				setRackCellYAxis(trayLocationVO.getRackCellYAxis());
				setTrayId(orderTrayVO.getTrayId());
				setBufferId(orderTrayVO.getBufferId());
				setInOutTypeCd(EInOutType.INPUT.name());
				if (StringUtils.isNotBlank(orderTrayVO.getPlanNo())) {
					setPlanNo(orderTrayVO.getPlanNo());
				}
			}});
			if(orderTraySaveList.size() == EoneConst.MAX_BUFFER_CELL_SIZE) {
				return orderTraySaveList;
			}
		}
		return orderTraySaveList;
	}

	/**
	 * 버퍼 사이즈 만큼만 매핑 - 입고
	 * @param workPlanTrayReadyList
	 * @param trayLocationSummaryList
	 * @return
	 */
	private List<OrderTrayVO> fillInputOrderTrayByMaxBufferSize(String orderId, List<OrderTrayVO> orderTrayList) {
		List<OrderTrayVO> fillOrderTrayList = new ArrayList<>();
		IntStream.range(1, (EoneConst.MAX_BUFFER_CELL_SIZE + 1)).forEach(r -> {
			OrderTrayVO orderTrayVO = getOrderTrayVO(orderTrayList, r);
			//비어 있는 TRAY는 템플릿을 생성 해준다!
			if(orderTrayVO == null) {
				fillOrderTrayList.add(new OrderTrayVO() {{
					setOrderId(orderId);
					setBufferId(String.valueOf(r));
					setInOutTypeCd(EInOutType.INPUT.name());
					setRackCellXAxis(0);
					setRackCellYAxis(0);
				}});
			}
		});
		return fillOrderTrayList;
	}

//	private List<OrderTrayVO> fillInputOrderTrayByMaxBufferSize(Long orderId, List<OrderTrayVO> orderTrayList) {
//		List<OrderTrayVO> orderTraySaveList = new ArrayList<>();
//		for(OrderTrayVO orderTrayVO:orderTrayList) {
//			if(StringUtils.isEmpty(orderTrayVO.getTrayId())) {
//				orderTraySaveList.add(new OrderTrayVO() {{
//					setOrderId(orderId);
//					setBufferId(orderTrayVO.getBufferId());
//					setInOutTypeCd(EInOutType.INPUT.name());
//					setRackCellXAxis(0);
//					setRackCellYAxis(0);
//				}});
//			}
//		}
//		return orderTraySaveList;
//	}

	public TrayLocationVO getTrayLocationVOTopOne(List<TrayLocationSummaryVO> trayLocationSummaryList) {
		//갠트리별 LIST
		for (TrayLocationSummaryVO trayLocationSummaryVO : trayLocationSummaryList) {
			//갠트리별 빈공간 목록!!
			for(TrayLocationVO trayLocationVO:trayLocationSummaryVO.getTrayLocationList()) {
				if(StringUtils.equals(trayLocationVO.getUsedYn(), SfpConst.YN_Y)) {
					continue;
				}
				trayLocationVO.setUsedYn(SfpConst.YN_Y);
				return trayLocationVO;
			}
		}
		return null;
	}

	/**
	 * 출고 대상 TRAY를 GANTRY별로 생성하여 리턴
	 * @param workPlanTrayReadyList :대상 트레이
	 * @param trayLocationSummaryList : 비어있는 트레이
	 * @return
	 */
	private List<OrderSaveVO> makeOuputOrderTrayListByTrayLocationSummary(List<WorkPlanTrayVO> workPlanTrayReadyList, List<TrayLocationSummaryVO> trayLocationSummaryList) {
		List<OrderSaveVO> orderSaveList = new ArrayList<>();
		for (TrayLocationSummaryVO trayLocationSummaryVO : trayLocationSummaryList) {
			OrderSaveVO orderSaveVO = getOrderSaveVO(orderSaveList, trayLocationSummaryVO.getMcId());
			if(orderSaveVO == null) {
				orderSaveVO = new OrderSaveVO();
				orderSaveVO.setMcId(trayLocationSummaryVO.getMcId());
				orderSaveVO.setLineNo(trayLocationSummaryVO.getLineNo());
				orderSaveList.add(orderSaveVO);
			}
			for(TrayLocationVO trayLocationVO:trayLocationSummaryVO.getTrayLocationList()) {
				for(WorkPlanTrayVO workPlanTrayVO:workPlanTrayReadyList) {
					if(StringUtils.equals(trayLocationVO.getTrayId(), workPlanTrayVO.getTrayId())) {
						orderSaveVO.getOrderTrayList().add(new OrderTrayVO() {{
							setRackId(trayLocationVO.getRackId());
							setRackCellXAxis(trayLocationVO.getRackCellXAxis());
							setRackCellYAxis(trayLocationVO.getRackCellYAxis());
							setTrayId(workPlanTrayVO.getTrayId());
							setPlanNo(workPlanTrayVO.getPlanNo());
							setInOutTypeCd(EInOutType.OUTPUT.name());
						}});

						if(workPlanTrayVO.getTrayOrderSort() != null) {
							orderSaveVO.plusSortWeightValue(workPlanTrayVO.getTrayOrderSort());
						}
					}
				}
			}
		}
		return orderSaveList
				.stream()
				.sorted(Comparator.comparing(OrderSaveVO::getOrderTrayListSize).reversed().thenComparing(Comparator.comparing(OrderSaveVO::getSortWeightValue)))
				.collect(Collectors.toList());
	}

	public OrderSaveVO getOrderSaveVO(List<OrderSaveVO> orderSaveList, String mcId) {
		for (OrderSaveVO orderSaveVO : orderSaveList) {
			if(StringUtils.equals(orderSaveVO.getMcId(), mcId)) {
				return orderSaveVO;
			}
		}
		return null;
	}

	public OrderTrayVO getOrderTrayVO(List<OrderTrayVO> orderTrayList, int bufferId) {
		for (OrderTrayVO orderTrayVO : orderTrayList) {
			if(Integer.valueOf(orderTrayVO.getBufferId()) == bufferId) {
				return orderTrayVO;
			}
		}
		return null;
	}

	private void checkInputOrderTrayValidation(List<OrderTrayVO> orderTrayList) throws SFPException {

		if(ListTools.isNullOrEmpty(orderTrayList)) {
			log.error("입고 TRAY 수량 0개는 입고 될수 없습니다!");
			throw new SFPException("입고 TRAY 수량 0개는 입고 될수 없습니다!", new Throwable());
		}

//		if(orderTrayList.size() != EoneConst.MAX_BUFFER_CELL_SIZE) {
//			log.error("입고 TRAY는 반드시 " + EoneConst.MAX_BUFFER_CELL_SIZE+ " 개를 등록하세요.!");
//			throw new SFPException("입고 TRAY는 반드시 " + EoneConst.MAX_BUFFER_CELL_SIZE+ " 개를 등록하세요.!", new Throwable());
//		}

		//boolean bufferIdDuplicate = orderTrayList.stream().map(OrderTrayVO::getBufferId).allMatch(new HashSet<>()::add);
		boolean bufferIdDuplicate = orderTrayList.stream().map(OrderTrayVO::getBufferId).distinct().count() != orderTrayList.size();

		if(bufferIdDuplicate) {
			log.error("BUFFER CELL ID가 중복 입니다!");
			throw new SFPException("BUFFER CELL ID가 중복 입니다!", new Throwable());
		}

		//Tray 있는 놈만 필터링
		//List<OrderTrayVO> orderTrayListFilterTray = orderTrayList.stream().filter(r -> StringUtils.isNotEmpty(r.getTrayId())).collect(Collectors.toList());

		boolean trayDuplicate = orderTrayList.stream().map(OrderTrayVO::getTrayId).distinct().count() != orderTrayList.size();
//		boolean trayDuplicate = orderTrayListFilterTray.stream().map(OrderTrayVO::getTrayId).allMatch(new HashSet<>()::add);

		if(trayDuplicate) {
			log.error("TRAY ID가 중복 입니다!");
			throw new SFPException("TRAY ID가 중복 입니다!", new Throwable());
		}

	}
	
	private void checkInputOrderTrayValidationByLineNo(List<OrderTrayVO> orderTrayList) throws SFPException {

		if(ListTools.isNullOrEmpty(orderTrayList)) {
			log.error("입고 TRAY 수량 0개는 입고 될수 없습니다!");
			throw new SFPException("입고 TRAY 수량 0개는 입고 될수 없습니다!", new Throwable());
		}

		boolean bufferIdDuplicate = orderTrayList.stream().map(OrderTrayVO::getBufferId).distinct().count() != orderTrayList.size();

		if(bufferIdDuplicate) {
			log.error("BUFFER CELL ID가 중복 입니다!");
			throw new SFPException("BUFFER CELL ID가 중복 입니다!", new Throwable());
		}
	}
	
	public void updateTrayNoByPlc(OrderWorkVO work) throws Exception {
		orderTrayService.modify(new OrderTrayVO() {{
			setOrderId(work.getOrderId());
			setBufferId(work.getBufferId());
			setTrayId(work.getTrayId());
		}});
	}
	
	/**
	 * 
	 * @param orderId
	 * @param workPlanTrayVO
	 * @return
	 * @throws Exception
	 */
	public List<OrderTrayVO> generateOuputContinuousByLineNo(String orderId, WorkPlanTrayVO workPlanTrayVO) throws Exception {
		List<OrderTrayVO> orderTraySaveList = new ArrayList<OrderTrayVO>();
		//총 몇개 있는지 조사
		int totalCount = workPlanTrayService.getTotalCountWorkPlanTrayLimitListByLineNo(workPlanTrayVO);
//		return this.getPaingList(this.getMapper().selectList(param, paging), paging, this.getMapper().selectListTotalRows(param));
		if (totalCount > 0) {
			PagingDTO workPaging = new PagingDTO();
			int pageNumber = 0;
			int maxPageNumber = totalCount / EoneConst.MAX_BUFFER_CELL_SIZE;
			workPaging.setNumber(pageNumber);
			workPaging.setSize(EoneConst.MAX_BUFFER_CELL_SIZE);
			//loop
			do {
				List<WorkPlanTrayVO> workPlanTrayList = workPlanTrayService.getWorkPlanTrayLimitListByLineNo(workPlanTrayVO, workPaging);
				if (workPlanTrayList != null && workPlanTrayList.size()>0) {
					for (WorkPlanTrayVO wptrayVO : workPlanTrayList) {
						List<TrayLocationVO> list =  trayLocationService.getRackInTrayList(new TrayLocationVO() {{
							setTrayId(wptrayVO.getTrayId());
							setLineNo(wptrayVO.getLineNo());
						}});
						
						if (list != null && list.size() > 0) {
							orderTraySaveList.add(new OrderTrayVO() {{
								setOrderId(orderId);
								setLineNo(wptrayVO.getLineNo());
								setPlanNo(wptrayVO.getPlanNo());
								setInOutTypeCd(EInOutType.OUTPUT.name());
								setTrayId(wptrayVO.getTrayId());
								setRackId(wptrayVO.getRackId());
								setRackCellXAxis(wptrayVO.getRackCellXAxis());
								setRackCellYAxis(wptrayVO.getRackCellYAxis());
							}});
						} else {
							//yudo_work error 발송
							interfaceBizService.procYudoWork(wptrayVO, "해당랙이 Shelf에 없습니다.");
							workPlanTrayService.modify(new WorkPlanTrayDTO() {{
								setPlanNo(wptrayVO.getPlanNo());
								setCancelYn(SfpConst.YN_Y);
								setModDt(DateTools.getDateTimeString());
							}});
						}
						
						if (orderTraySaveList.size() >= EoneConst.MAX_BUFFER_CELL_SIZE) {
							break;
						}
					}
				}
				pageNumber++;
				workPaging.setNumber(pageNumber);
			} while (orderTraySaveList.size() < EoneConst.MAX_BUFFER_CELL_SIZE && pageNumber <= maxPageNumber);
			
			AtomicInteger bufferId = new AtomicInteger(1);
			for (OrderTrayVO orderTrayVO : orderTraySaveList) {
				//버퍼ID 셋팅
				orderTrayVO.setBufferId(String.valueOf(bufferId.getAndIncrement()));
			}
		}
		return orderTraySaveList;
	}

}