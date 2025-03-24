package com.s3s.solutions.eone.service.wmd.workplantray;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderKind;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.define.ETrayStatus;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.workplantray.dto.WorkPlanTrayDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * @author 최종철
 *
 */
@RequiredArgsConstructor
@Service
@Slf4j
public class WorkPlanTrayService extends DefaultService<WorkPlanTrayDTO, WorkPlanTrayMapper>{

	/**
	 * 작업계획 TRAY 긴급건 - READY
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getWorkPlanTrayListByReadyEmengency() throws Exception{
		return getWorkPlanTrayListByReadyEmengency(null);
	}

	/**
	 * 작업계획 TRAY 긴급건 - READY
	 * @param eOrderType
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getWorkPlanTrayListByReadyEmengency(EOrderType eOrderType) throws Exception{
		List<WorkPlanTrayVO> workPlanTrayList = getMapper().selectWorkPlanTrayList(new WorkPlanTrayVO() {{
			setTrayStatusCd(ETrayStatus.READY.name());
			setExcuteYn(SfpConst.YN_N);
			setEmergencyYn(SfpConst.YN_Y);
			setOrderTypeCd(eOrderType == null ? EOrderType.OUTPUT.name() : eOrderType.name());
		}});
		return workPlanTrayList;
	}
	
	/**
	 * 작업계획 TRAY 긴급건 - READY
	 * @param eOrderType
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getWorkPlanTrayListByReadyEmengencyByLineNo(EOrderType eOrderType, String lineNo) throws Exception{
		List<WorkPlanTrayVO> workPlanTrayList = getMapper().selectWorkPlanTrayList(new WorkPlanTrayVO() {{
			setTrayStatusCd(ETrayStatus.READY.name());
			setExcuteYn(SfpConst.YN_N);
			setEmergencyYn(SfpConst.YN_Y);
			setLineNo(lineNo);
			setOrderTypeCd(eOrderType == null ? EOrderType.OUTPUT.name() : eOrderType.name());
		}});
		return workPlanTrayList;
	}

	/**
	 * 작업계획 TRAY 일반건 - READY
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getWorkPlanTrayListByReadyNormal() throws Exception{
		return getWorkPlanTrayListByReadyNormal(null);
	}

	/**
	 * 작업계획 TRAY 일반건 - READY
	 * @param eOrderType
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getWorkPlanTrayListByReadyNormal(EOrderType eOrderType) throws Exception{
		List<WorkPlanTrayVO> workPlanTrayList = getMapper().selectWorkPlanTrayList(new WorkPlanTrayVO() {{
			setTrayStatusCd(ETrayStatus.READY.name());
			setExcuteYn(SfpConst.YN_N);
			setEmergencyYn(SfpConst.YN_N);
			setOrderTypeCd(eOrderType == null ? EOrderType.OUTPUT.name() : eOrderType.name());
		}});
		return workPlanTrayList;
	}
	
	/**
	 * 작업계획 TRAY 일반건 - READY
	 * @param eOrderType
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getWorkPlanTrayListByReadyNormalByLineNo(EOrderType eOrderType, String lineNo) throws Exception{
		List<WorkPlanTrayVO> workPlanTrayList = getMapper().selectWorkPlanTrayList(new WorkPlanTrayVO() {{
			setTrayStatusCd(ETrayStatus.READY.name());
			setExcuteYn(SfpConst.YN_N);
			setEmergencyYn(SfpConst.YN_N);
			setLineNo(lineNo);
			setOrderTypeCd(eOrderType == null ? EOrderType.OUTPUT.name() : eOrderType.name());
		}});
		return workPlanTrayList;
	}

	/**
	 * 트래이 상태 변경
	 * @param orderList
	 * @param eTrayStatus
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void changeTrayStatus(List<OrderTrayVO> orderTrayList, ETrayStatus eTrayStatus, String excuteYn) throws Exception{
		for (OrderTrayVO orderTrayVO : orderTrayList) {
			if(StringUtils.isNotEmpty(orderTrayVO.getPlanNo())) {
				changeTrayStatus(orderTrayVO.getPlanNo(), eTrayStatus, excuteYn);
			}
		}
	}

	/**
	 * 트래이 상태 변경
	 * @param planNo
	 * @param eTrayStatus
	 * @throws Exception
	 */
	public int changeTrayStatus(String planNo, ETrayStatus eTrayStatus, String excuteYn) throws Exception{
		return super.modify(new WorkPlanTrayDTO() {{
			setPlanNo(planNo);
			setTrayStatusCd(eTrayStatus.name());
			setExcuteYn(excuteYn);
		}});
	}

	public int maxTrayOrderSort(EOrderGroupType eOrderGroupType) {
		return getMapper().maxTrayOrderSort(new WorkPlanTrayVO() {{
			setOrderTypeCd(eOrderGroupType.name());
			setTrayStatusCd(ETrayStatus.READY.name());
			setExcuteYn(SfpConst.YN_N);
		}});
	}

	public void registerTrayList(List<WorkPlanTrayDTO> list, EOrderGroupType eOrderGroupType, EOrderKind eOrderKind) throws Exception {
		List<WorkPlanTrayDTO> distinctList = distinctArray(list);
		int maxOrderSort = maxTrayOrderSort(eOrderGroupType);
		for (WorkPlanTrayDTO plan : distinctList) {
			
			if(isRegistedTray(plan.getTrayId())) {
				continue;
			}
			plan.setTrayOrderSort(++maxOrderSort);
			plan.setExcuteYn(SfpConst.YN_N);
			plan.setTrayStatusCd(ETrayStatus.READY.name());
			plan.setOrderTypeCd(eOrderGroupType.name());
			plan.setRegDt(DateTools.getDateTimeString());
			plan.setOrderKindCd(eOrderKind.name());
			plan.setCancelYn(SfpConst.YN_N);
			plan.setInputDate(DateTools.getDateTimeString(DateTools.YYYY_MM_DD));
			add(plan);
		}
	}
	
	public void registerWaitTrayList(List<WorkPlanTrayVO> list) throws Exception {
		List<WorkPlanTrayVO> distinctList = distinctWaitArray(list);
		int maxOrderSort = 0;
		for (WorkPlanTrayDTO plan : distinctList) {
			plan.setTrayOrderSort(++maxOrderSort);
			plan.setExcuteYn(SfpConst.YN_N);
			plan.setTrayStatusCd(ETrayStatus.READY.name());
			plan.setRegDt(DateTools.getDateTimeString());
			plan.setCancelYn(SfpConst.YN_N);
			plan.setOrderKindCd(EOrderKind.HADNWRITE.name());
			add(plan);
		}
	}

	public boolean isRegistedTray(String trayId) {
		WorkPlanTrayVO vo = getMapper().selectTrayInfoReadyIng(trayId);
		return vo == null ? false : true;
	}

	//중복제거 메소드
	public static List<WorkPlanTrayDTO> distinctArray(List<WorkPlanTrayDTO> target){
		if(target != null){
			target = target.stream().filter(distinctByKey(o-> o.getTrayId())).collect(Collectors.toList());
		}
		return target;
	}
	
	public static List<WorkPlanTrayVO> distinctWaitArray(List<WorkPlanTrayVO> target){
		if(target != null){
			target = target.stream().filter(distinctByKey(o-> o.getTrayId())).collect(Collectors.toList());
		}
		return target;
	}


	//중복 제거를 위한 함수
	public static <T> Predicate<T> distinctByKey(Function<? super T,Object> keyExtractor) {
		Map<Object,Boolean> seen = new ConcurrentHashMap<>();
		return t -> seen.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
	}

	public void doEmergencyList(WorkPlanTrayVO workPlanTrayVO) {
		getMapper().doEmergency(workPlanTrayVO);
	}

	public void deleteWorkPlantray(WorkPlanTrayVO workPlanTrayVO) {
		getMapper().deleteWorkPlantray(workPlanTrayVO);
	}

	public List<WorkPlanTrayVO> getWorkPlanTrayList(WorkPlanTrayVO workPlanTrayVO){
		return getMapper().selectWorkPlanTrayList(workPlanTrayVO);
	}

	// 등록된 출고 트레이 목록
	public List<WorkPlanTrayVO> getOutputRegistedTray() throws Exception {
		return getWorkPlanTrayList(new WorkPlanTrayVO()
		{{
			setOrderTypeCd(EOrderGroupType.OUTPUT.name());
			setTrayStatusCd(ETrayStatus.READY.name());
		}});
	}
	
	/**
	 * new
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getOutputRegistedTrayByLineNo(String lineNo) throws Exception {
		return getWorkPlanTrayList(new WorkPlanTrayVO()
		{{
			setOrderTypeCd(EOrderGroupType.OUTPUT.name());
			setTrayStatusCd(ETrayStatus.READY.name());
			setLineNo(lineNo);
			setCancelYn(SfpConst.YN_N);
		}});
	}

	// 등록된 조회 트레이 목록
	public List<WorkPlanTrayVO> getInquiryRegistedTray() throws Exception {
		return getWorkPlanTrayList(new WorkPlanTrayVO()
		{{
			setOrderTypeCd(EOrderGroupType.INQUIRY.name());
			setTrayStatusCd(ETrayStatus.READY.name());
		}});
	}
	
	/**
	 * new
	 * @param lineNo
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getInquiryRegistedTrayByLineNo(String lineNo) throws Exception {
		return getWorkPlanTrayList(new WorkPlanTrayVO()
		{{
			setOrderTypeCd(EOrderGroupType.INQUIRY.name());
			setTrayStatusCd(ETrayStatus.READY.name());
			setLineNo(lineNo);
		}});
	}

	public void updateCompleteWorkPlanTrayListByPlanNo(WorkPlanTrayVO vo) throws Exception{
		getMapper().updateCompleteWorkPlanTrayListByPlanNo(vo);
	}
	
	/**
	 * 해당 라인의 작업 대기 건이 있는지 확인
	 * @param lineNo
	 * @return
	 * @throws Exception
	 */
	public List<WorkPlanTrayVO> getContinuousFistOrderByLineNo(String lineNo) throws Exception{
		return getMapper().selectContinuousFistOrderByLineNo(lineNo);
	}
	
	public int getTotalCountWorkPlanTrayLimitListByLineNo(WorkPlanTrayVO vo) throws Exception {
		return getMapper().selectTotalCountWorkPlanTrayLimitListByLineNo(vo);
	}
	
	public List<WorkPlanTrayVO> getWorkPlanTrayLimitListByLineNo(WorkPlanTrayVO vo, PagingDTO workPaging) throws Exception {
		return getMapper().selectWorkPlanTrayLimitListByLineNo(vo, workPaging);
	}
	
	@Transactional(rollbackFor = { Exception.class })
	public void registerGroupTrayList(List<WorkPlanTrayDTO> list) throws Exception {
		List<WorkPlanTrayDTO> outputWorkPlanTrayList = new ArrayList<WorkPlanTrayDTO>();
		List<WorkPlanTrayDTO> inquiryWorkPlanTrayList = new ArrayList<WorkPlanTrayDTO>();
		String firstOrderType = "";
		if (!ListTools.isNullOrEmpty(list)) {
			WorkPlanTrayDTO workPlanTrayDTO = ListTools.getFirst(list);
			firstOrderType = workPlanTrayDTO.getOrderTypeCd();
			List<WorkPlanTrayDTO> distinctList = distinctArray(list);
			outputWorkPlanTrayList = distinctList.stream().filter(r -> StringUtils.equals(r.getOrderTypeCd(), EOrderType.OUTPUT.name())).collect(Collectors.toList());
			inquiryWorkPlanTrayList = distinctList.stream().filter(r -> StringUtils.equals(r.getOrderTypeCd(), EOrderType.INQUIRY.name())).collect(Collectors.toList());
		}
		
		int sort = 1;
		if (StringUtils.equals(firstOrderType, EOrderType.INQUIRY.name())) {
			for (WorkPlanTrayDTO workPlanTrayDTO : inquiryWorkPlanTrayList) {
				workPlanTrayDTO.setTrayOrderSort(sort++);
				add(workPlanTrayDTO);
			}
			for (WorkPlanTrayDTO workPlanTrayDTO : outputWorkPlanTrayList) {
				workPlanTrayDTO.setTrayOrderSort(sort++);
				add(workPlanTrayDTO);
			}
		} else {
			for (WorkPlanTrayDTO workPlanTrayDTO : outputWorkPlanTrayList) {
				workPlanTrayDTO.setTrayOrderSort(sort++);
				add(workPlanTrayDTO);
			}
			for (WorkPlanTrayDTO workPlanTrayDTO : inquiryWorkPlanTrayList) {
				workPlanTrayDTO.setTrayOrderSort(sort++);
				add(workPlanTrayDTO);
			}
		}
	}
	
	public List<WorkPlanTrayVO> getInterfaceOrderTrayList(String planNo, String lineNo, String orderId) {
		return getMapper().selectInterfaceOrderTrayList(planNo, lineNo, orderId);
	}
}