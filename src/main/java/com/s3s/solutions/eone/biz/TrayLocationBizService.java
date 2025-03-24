package com.s3s.solutions.eone.biz;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.exception.SFPException;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.sfp.tools.NumberTools;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.define.EInOutType;
import com.s3s.solutions.eone.define.ELocType;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.manager.BufferManager;
import com.s3s.solutions.eone.manager.BufferSensorVO;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryVO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkService;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.rackcell.RackCellService;
import com.s3s.solutions.eone.service.wmd.rackcell.RackCellVO;
import com.s3s.solutions.eone.service.wmd.trayduplicatelocation.TrayDuplicateLocationService;
import com.s3s.solutions.eone.service.wmd.trayduplicatelocation.dto.TrayDuplicateLocationDTO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationService;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.traylocationchangehistory.TrayLocationChangeHistoryService;
import com.s3s.solutions.eone.service.wmd.traylocationchangehistory.TrayLocationChangeHistoryVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class TrayLocationBizService {

	private final TrayLocationService trayLocationService;

	private final TrayLocationChangeHistoryService trayLocationChangeHistoryService;

	private final RackCellService rackCellService;

	private final BufferManager bufferManager;

	private final OrderWorkService orderWorkService;
	
	private final TrayDuplicateLocationService trayDuplicateLocationService;

	private final OrderOperationHistoryBizService orderOperationHistoryBizService;
	

	/**
	 * trayId 중복 체크 - exception 발생
	 * @param orderTrayList
	 * @throws Exception
	 */
	public void duplicationCheckTrayIdByException(List<OrderTrayVO> orderTrayList) throws Exception {
		//TRAY LOCATION 목록
		List<TrayLocationVO> trayLocationList = trayLocationService.getList();
		
		List<String> trayIdList = trayLocationList.stream().map(TrayLocationVO::getTrayId).collect(Collectors.toList());
		for (OrderTrayVO orderTrayVO : orderTrayList) {
			if(StringUtils.isEmpty(orderTrayVO.getTrayId())) {
				continue;
			}
			if(trayIdList.contains(orderTrayVO.getTrayId())) {
				log.error(orderTrayVO.getTrayId() + " TRAY ID는 이미 시스템에서 사용중으로 입고 할수 없습니다!");
				throw new SFPException(orderTrayVO.getTrayId() + " TRAY ID는 이미 시스템에서 사용중으로 입고 할수 없습니다!", new Throwable());
			}
		}
	}

	/**
	 * trayId 중복 체크
	 * @param orderTrayList
	 * @return
	 * @throws Exception
	 */
	public boolean duplicationCheckTrayId(List<OrderTrayVO> orderTrayList) throws Exception {
		//TRAY LOCATION 목록
		List<TrayLocationVO> trayLocationList = trayLocationService.getList();
		List<String> trayIdList = trayLocationList.stream().map(TrayLocationVO::getTrayId).collect(Collectors.toList());
		for (OrderTrayVO orderTrayVO : orderTrayList) {
			if(trayIdList.contains(orderTrayVO.getTrayId())) {
				log.error(orderTrayVO.getTrayId() + " TRAY ID는 이미 시스템에서 사용중입니다!");
				return true;
			}
		}
		return false;
	}

	/**
	 * trayId 중복 체크
	 * @param trayId
	 * @return
	 * @throws Exception
	 */
	public boolean duplicationCheckTrayId(String trayId) throws Exception {
		if(StringUtils.isEmpty(trayId)) {
			return true;
		}
		List<OrderTrayVO> orderTrayList = new ArrayList<>();
		orderTrayList.add(new OrderTrayVO() {{
			setTrayId(trayId);
		}});
		return duplicationCheckTrayId(orderTrayList);
	}

	/**
	 * 버퍼 로케이션 8개와 센서 정보를 같이 리턴.
	 * @return
	 * @throws Exception
	 */
	/*
	public List<TrayLocationVO> getBufferTrayLocationListIncludeSensor() throws Exception {
		List<TrayLocationVO> trayLocationList = generateTemplateTrayLoctaionListIncludeSensor();
		List<TrayLocationVO> currentTrayLocationList = getCurrentTrayLocationList();
		for (TrayLocationVO trayLocationVO : trayLocationList) {
			for (TrayLocationVO currentTrayLocation : currentTrayLocationList) {
				if(StringUtils.equalsIgnoreCase(trayLocationVO.getBufferId(), currentTrayLocation.getBufferId())) {
					trayLocationVO.setTrayId(currentTrayLocation.getTrayId());
				}
			}
		}
		return trayLocationList;
	}
	*/
	
	public List<TrayLocationVO> getBufferTrayLocationListIncludeSensorByLineNo(String lineNo) throws Exception {
		List<TrayLocationVO> trayLocationList = generateTemplateTrayLoctaionListIncludeSensorByLineNo(lineNo);
		List<TrayLocationVO> currentTrayLocationList = getCurrentTrayLocationList();
		for (TrayLocationVO trayLocationVO : trayLocationList) {
			for (TrayLocationVO currentTrayLocation : currentTrayLocationList) {
				if(StringUtils.equalsIgnoreCase(trayLocationVO.getBufferId(), currentTrayLocation.getBufferId())) {
					trayLocationVO.setTrayId(currentTrayLocation.getTrayId());
				}
			}
		}
		return trayLocationList;
	}

	/**
	 * 버퍼 로케이션 8개와 센서 정보 그리고 조회수량 리턴
	 * @return
	 * @throws Exception
	 */
	/*
	public List<TrayLocationVO> getBufferTrayLocationListIncludeSensorAndInqueryQty(OrderVO orderVO) throws Exception {
		List<TrayLocationVO> trayLocationList = generateTemplateTrayLoctaionListIncludeSensor();
		if(orderVO.getOrderId() == null) {
			return trayLocationList;
		}
		List<TrayLocationVO> currentTrayLocationList = getCurrentTrayLocationListIncludeCount(orderVO.getOrderId());
		for (TrayLocationVO trayLocationVO : trayLocationList) {
			for (TrayLocationVO currentTrayLocation : currentTrayLocationList) {
				if(StringUtils.equalsIgnoreCase(trayLocationVO.getBufferId(), currentTrayLocation.getBufferId())) {
					trayLocationVO.setTrayId(currentTrayLocation.getTrayId());
					trayLocationVO.setInquiryQty(NumberTools.nullToZero(currentTrayLocation.getInquiryQty()));
				}
			}
		}
		return trayLocationList;
	}
	*/
	
	/**
	 * 해당 라인 버퍼 센서 정보를 읽어와서 
	 * @param orderVO
	 * @return
	 * @throws Exception
	 */
	public List<TrayLocationVO> getBufferTrayLocationListIncludeSensorAndInqueryQtyByLineNo(OrderVO orderVO) throws Exception {
		if (!orderOperationHistoryBizService.isDialogOpenStatus(orderVO)) {
			return null;
		}
		
		List<TrayLocationVO> trayLocationList = generateTemplateTrayLoctaionListIncludeSensorByLineNo(orderVO.getLineNo());
		if(orderVO.getOrderId() == null) {
			return trayLocationList;
		}
		
		List<TrayLocationVO> currentTrayLocationList = trayLocationService.getTrayLocationListByOrderId(new TrayLocationVO() {{
			setOrderId(orderVO.getOrderId());
			setLineNo(orderVO.getLineNo());
			//setLocTypeCd(ELocType.BUFFER.name());
		}});
		for (TrayLocationVO trayLocationVO : trayLocationList) {
			for (TrayLocationVO currentTrayLocation : currentTrayLocationList) {
				if(StringUtils.equalsIgnoreCase(trayLocationVO.getBufferId(), currentTrayLocation.getBufferId())) {
					trayLocationVO.setTrayId(currentTrayLocation.getTrayId());
					trayLocationVO.setInquiryQty(NumberTools.nullToZero(currentTrayLocation.getInquiryQty()));
					trayLocationVO.setRackCellXAxis(currentTrayLocation.getRackCellXAxis());
					trayLocationVO.setRackCellYAxis(currentTrayLocation.getRackCellYAxis());
					trayLocationVO.setRackId(currentTrayLocation.getRackId());
					trayLocationVO.setRackName(currentTrayLocation.getRackName());
					trayLocationVO.setPlanNo(currentTrayLocation.getPlanNo());
				}
			}
		}
		return trayLocationList;
	}

	/**
	 * shelf에서 
	 * @return
	 * @throws Exception
	 */
	public List<TrayLocationVO> getCurrentTrayLocationList() throws Exception{
		return trayLocationService.getList(new TrayLocationVO() {{
			setLocTypeCd(ELocType.BUFFER.name());
		}});
	}
	
	/**
	 * 
	 * @param lineNo
	 * @return
	 * @throws Exception
	 */
	public List<TrayLocationVO> getCurrentTrayLocationListByLineNo(String lineNo) throws Exception{
		return trayLocationService.getList(new TrayLocationVO() {{
			setLineNo(lineNo);
			setLocTypeCd(ELocType.BUFFER.name());
		}});
	}

	/**
	 * 현재 버퍼에서 TRAY 현황 (조회 수량 포함)
	 * @param orderId
	 * @return
	 * @throws Exception
	 */
	public List<TrayLocationVO> getCurrentTrayLocationListIncludeCount(OrderVO orderVO) throws Exception{
		List<TrayLocationVO> currentTrayLocationList = getCurrentTrayLocationListByLineNo(orderVO.getLineNo());
		
		List<OrderWorkVO> orderWorkList = orderWorkService.getOrderWorkListByOrderId(orderVO.getOrderId());
		
		for (TrayLocationVO currentTrayLocation : currentTrayLocationList) {
			OrderWorkVO orderWorkVO = getOrderWorkVO(orderWorkList, currentTrayLocation.getTrayId());
			if(orderWorkVO != null) {
				currentTrayLocation.setInquiryQty(orderWorkVO.getInquiryQty());
			}
		}
		return currentTrayLocationList;
	}

	public OrderWorkVO getOrderWorkVO(List<OrderWorkVO> orderWorkList, String trayId) throws Exception{
		for (OrderWorkVO orderWorkVO : orderWorkList) {
			if(StringUtils.equalsIgnoreCase(orderWorkVO.getTrayId(), trayId)){
				return orderWorkVO;
			}
		}
		return null;
	}

	/*
	public List<TrayLocationVO> generateTemplateTrayLoctaionListIncludeSensor() {
		List<TrayLocationVO> trayLocationList = new ArrayList<>();
		IntStream.range(1, (EoneConst.MAX_BUFFER_CELL_SIZE + 1)).forEach(r -> {
			TrayLocationVO trayLocationVO = new TrayLocationVO();
			BufferSensorVO buffSensorVO = bufferManager.getBufferSensor(String.valueOf(r));
			trayLocationVO.setBufferId(String.valueOf(r));
			trayLocationVO.setSensor(buffSensorVO == null ? "0" : buffSensorVO.getSensor());
			trayLocationList.add(trayLocationVO);
		});
		return trayLocationList;
	}
	*/
	
	/**
	 * 해당 라인 셔틀의 버퍼만큼 셔틀의 센서 정보를 가지고 와서 트레이 위치 객체 목록을 반환한다.
	 * @param lineNo
	 * @return
	 */
	public List<TrayLocationVO> generateTemplateTrayLoctaionListIncludeSensorByLineNo(String lineNo) {
		List<TrayLocationVO> trayLocationList = new ArrayList<>();
		IntStream.range(1, (EoneConst.MAX_BUFFER_CELL_SIZE + 1)).forEach(r -> {
			TrayLocationVO trayLocationVO = new TrayLocationVO();
			BufferSensorVO buffSensorVO = bufferManager.getBufferSensorByLineNo(String.valueOf(r), lineNo);
			trayLocationVO.setBufferId(String.valueOf(r));
			trayLocationVO.setSensor(buffSensorVO == null ? "0" : buffSensorVO.getSensor());
			trayLocationList.add(trayLocationVO);
		});
		return trayLocationList;
	}

	/*
	public List<TrayLocationVO> generateTemplateTrayLoctaionVO() {
		List<TrayLocationVO> trayLocationList = new ArrayList<>();
		IntStream.range(1, (EoneConst.MAX_BUFFER_CELL_SIZE + 1)).forEach(r -> {
			TrayLocationVO trayLocationVO = new TrayLocationVO();
			BufferSensorVO buffSensorVO = bufferManager.getBufferSensor(String.valueOf(r));
			trayLocationVO.setBufferId(String.valueOf(r));
			trayLocationVO.setSensor(buffSensorVO == null ? "0" : buffSensorVO.getSensor());
			trayLocationList.add(trayLocationVO);
		});
		return trayLocationList;
	}
	*/
	
	public List<TrayLocationVO> generateTemplateTrayLoctaionVOByLineNo(String lineNo) {
		List<TrayLocationVO> trayLocationList = new ArrayList<>();
		IntStream.range(1, (EoneConst.MAX_BUFFER_CELL_SIZE + 1)).forEach(r -> {
			TrayLocationVO trayLocationVO = new TrayLocationVO();
			BufferSensorVO buffSensorVO = bufferManager.getBufferSensorByLineNo(String.valueOf(r), lineNo);
			trayLocationVO.setBufferId(String.valueOf(r));
			trayLocationVO.setSensor(buffSensorVO == null ? "0" : buffSensorVO.getSensor());
			trayLocationList.add(trayLocationVO);
		});
		return trayLocationList;
	}

	/**
	 * 트레이 위치 정보 변경 및 히스토리 적재
	 * @param work
	 * @throws Exception
	 */
	public void updateTrayLocationByPlc(OrderWorkVO work, OrderVO order) throws Exception {
		TrayLocationVO trayLoc = trayLocationService.getDetail(new TrayLocationVO() {{
			setTrayId(work.getTrayId());
		}});
		//기존 데이터가 있으면 삭제
//		if(trayLoc != null) {
//			trayLocationService.delete(trayLoc);
//		}
		TrayLocationVO loc = new TrayLocationVO();
		loc.setTrayId(work.getTrayId());
		
		if(StringUtils.equals(work.getInOutTypeCd(), EInOutType.INPUT.name())) { //입고일경우
			loc.setLineNo(order.getLineNo());
			loc.setLocTypeCd(ELocType.RACKCELL.name());
			loc.setRackId(work.getRackId());
			loc.setRackCellXAxis(work.getRackCellXAxis());
			loc.setRackCellYAxis(work.getRackCellYAxis());
			RackCellVO rackCell = rackCellService.getRackCellByRackAndXY(work.getRackId(), work.getRackCellXAxis(), work.getRackCellYAxis());
			loc.setRackCellId(rackCell.getRackCellId());
			loc.setBufferId(null);
			loc.setModDt(DateTools.getDateTimeString());
		} else { //폐기나 조회일 경우
			loc.setLocTypeCd(ELocType.BUFFER.name());
			loc.setBufferId(work.getBufferId());
			loc.setRackId(null);
			loc.setRackCellId(null);
			loc.setRackCellXAxis(null);
			loc.setRackCellYAxis(null);
			loc.setLineNo(order.getLineNo());
		}

		//TODO - daniel 우선 1로 등록. task 돌면서 update 해야하는 것으로 알고있음.
		//TODO - daniel 현재 조건으로 merge
		//기존에 없으면 add
		if(trayLoc == null) {
			loc.setExpirationDay(1);
			loc.setInputDate(DateTools.getDateString());
			work.setInputDate(DateTools.getDateString());
			if (StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name()) && (StringUtils.equals(order.getOrderTypeCd(), EOrderType.INPUT.name()))) {
				// 호출의 입고 일 경우 최조 보관일자로 넣어줘야 한다.
				TrayLocationChangeHistoryVO changeLocation = trayLocationChangeHistoryService.getBufferDetailByOrderGroupId(new TrayLocationChangeHistoryVO() {{
					setOrderGroupId(order.getOrderGroupId());
					setTrayId(work.getTrayId());
					setToLocTypeCd(ELocType.OUT.name());
				}});
				loc.setInputDate(changeLocation.getInputDate());
				work.setInputDate(changeLocation.getInputDate());
			}
		} else {
			
			work.setOrderGroupId(order.getOrderGroupId());
			work.setInputDate(trayLoc.getInputDate());
			
			if (StringUtils.equals(order.getOrderGroupTypeCd(), EOrderGroupType.INPUT.name())) {
				//tray dup 나는 경우
				trayDuplicateLocationService.add(new TrayDuplicateLocationDTO() {{
					setTrayId(trayLoc.getTrayId());
					setInputDate(trayLoc.getInputDate());
					setLocTypeCd(trayLoc.getLocTypeCd());
					setRackCellId(trayLoc.getRackCellId());
					setLineNo(trayLoc.getLineNo());
					setRackId(trayLoc.getRackId());
					setRackCellXAxis(trayLoc.getRackCellXAxis());
					setRackCellYAxis(trayLoc.getRackCellYAxis());
				}});
			}
		}
		trayLocationService.merge(loc);
		if (StringUtils.isBlank(work.getOrderGroupId())) {
			work.setOrderGroupId(order.getOrderGroupId());
		}
		this.updateTrayLocationHistoryByPlc(work);
	}

	public void updateTrayLocationHistoryByPlc(OrderWorkVO work) throws Exception {
		TrayLocationChangeHistoryVO history = new TrayLocationChangeHistoryVO();
		history.setOrderId(work.getOrderId());
		history.setOrderGroupId(work.getOrderGroupId());
		history.setTrayId(work.getTrayId());
		history.setBufferId(work.getBufferId());
		history.setRackId(work.getRackId());
		history.setRackCellXAxis(work.getRackCellXAxis());
		history.setRackCellYAxis(work.getRackCellYAxis());
		history.setInputDate(work.getInputDate());
		
		//랙이 없으면.
		if(StringUtils.isEmpty(work.getRackId())) {
			RackCellVO rackCell = rackCellService.getRackCellByRackAndXY(work.getRackId(), work.getRackCellXAxis(), work.getRackCellYAxis());
			history.setRackCellId(rackCell.getRackCellId());
		}
		//입고이면 위치유형은 RACKCELL
		if (StringUtils.equals(work.getInOutTypeCd(), EInOutType.INPUT.name())) {
			history.setFromLocTypeCd(ELocType.BUFFER.name());
			history.setToLocTypeCd(ELocType.RACKCELL.name());
		} else {
			history.setFromLocTypeCd(ELocType.RACKCELL.name());
			history.setToLocTypeCd(ELocType.BUFFER.name());
		}
		history.setChangeDt(DateTools.getDateTimeString());
		trayLocationChangeHistoryService.add(history);
	}


	/**
	 * 
	 * @param orderGroupId
	 * @param orderId
	 * @param inOutType
	 * @param trayId
	 * @param bufferId
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void updateTrayLocationByManual(String orderGroupId, String orderId, String inOutType, String trayId, String bufferId) throws Exception{
		TrayLocationChangeHistoryVO history = new TrayLocationChangeHistoryVO();
		history.setChangeDt(DateTools.getDateTimeString());
		history.setOrderGroupId(orderGroupId);
		history.setOrderId(orderId);
		
		//buffer input 이면.
		if (StringUtils.equals(EInOutType.INPUT.name(), inOutType)) {
			history.setFromLocTypeCd(ELocType.OUT.name());
			history.setToLocTypeCd(ELocType.BUFFER.name());
		} else if (StringUtils.equals(EInOutType.OUTPUT.name(), inOutType)) {
			history.setFromLocTypeCd(ELocType.BUFFER.name());
			history.setToLocTypeCd(ELocType.OUT.name());
			TrayLocationVO changeLocation = trayLocationService.getTrayLocationByTrayIdLocType(new TrayLocationVO() {{
				setTrayId(trayId);
				setLocTypeCd(ELocType.BUFFER.name());
			}});
			history.setInputDate(changeLocation.getInputDate());
		}
		
		history.setTrayId(trayId);
		history.setBufferId(bufferId);
		updateTrayLocationByManual(history);
	}
	
	/**
	 * 
	 * @param vo
	 * @throws Exception
	 */
	public void updateTrayLocationByManual(TrayLocationChangeHistoryVO vo) throws Exception{
		//OUT
		if (StringUtils.equals(ELocType.BUFFER.name(), vo.getFromLocTypeCd()) && StringUtils.equals(ELocType.OUT.name(), vo.getToLocTypeCd())) {
			this.updateTrayLocationByOutManual(vo);
		}
		//IN
		if (StringUtils.equals(ELocType.OUT.name(), vo.getFromLocTypeCd()) && StringUtils.equals(ELocType.BUFFER.name(), vo.getToLocTypeCd())) {
			this.updateTrayLocationByInManual(vo);
		}
		trayLocationChangeHistoryService.add(vo);
	}

	/**
	 * 배출업무 - 
	 * 
	 * @param vo
	 * @throws Exception
	 */
	private void updateTrayLocationByOutManual(TrayLocationChangeHistoryVO vo) throws Exception{
		//해당 tray를 조회하여 뺀다.
		TrayLocationVO tray = trayLocationService.getDetail(new TrayLocationVO() {{
			setTrayId(vo.getTrayId());
		}});
		if(tray != null) {
			//삭제
			trayLocationService.delete(tray);
		}
	}

	private void updateTrayLocationByInManual(TrayLocationChangeHistoryVO vo) throws Exception{
		//해당 tray를 조회하여 뺀다.
		TrayLocationVO tray = trayLocationService.getDetail(new TrayLocationVO() {{
			setTrayId(vo.getTrayId());
		}});
		//입고인데 이미 다른곳에 있을 경우 해당 loc를 삭제.
//		if(tray != null) {
//			trayLocationService.delete(tray);
//		}

		TrayLocationVO inputTray = new TrayLocationVO();
		inputTray.setInputDate(DateTools.getDateString()); //TODO CHOI 임시 처리 - 손D 확인 필요
		inputTray.setExpirationDay(1);
		inputTray.setTrayId(vo.getTrayId()); //TODO CHOI 임시 처리 - 손D 확인 필요
		inputTray.setLocTypeCd(vo.getToLocTypeCd());
		inputTray.setBufferId(vo.getBufferId());

		trayLocationService.add(inputTray);
	}
	
	/**
	 * 보관 화면에서 해당 tray에 입고 후 선반에 입고할 위치를 선정해 해당 위치 리스트를 반환한다.
	 * @param lineNo
	 * @param list
	 * @return
	 * @throws Exception
	 */
	public List<TrayLocationVO> generateInputTrayLocationByLineNo(List<OrderTrayVO> list) throws Exception {
		List<TrayLocationVO> trayLocationList = new ArrayList<TrayLocationVO>();
		if (!ListTools.isNullOrEmpty(list)) {
			int trayCount = list.size();
			//리스트 bufferId별로 정렬
			list = list.stream().sorted(Comparator.comparing(OrderTrayVO::getBufferId)).collect(Collectors.toList());
			String lineNo = ListTools.getFirst(list).getLineNo();
			trayLocationList = trayLocationService.getGenerateRackEmptyCellListByLineNo(lineNo, trayCount);
			
			for (int i=0; i<trayLocationList.size(); i++) {
				trayLocationList.get(i).setBufferId(list.get(i).getBufferId());
			}
		}
		return trayLocationList;
	}

}