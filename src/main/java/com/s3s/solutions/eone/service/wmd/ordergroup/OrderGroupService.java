package com.s3s.solutions.eone.service.wmd.ordergroup;

import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.sfp.tools.DateTools;
import com.s3s.solutions.eone.define.EOrderGroupFinishStatus;
import com.s3s.solutions.eone.define.EOrderGroupStatus;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.service.wmd.ordergroup.dto.OrderGroupDTO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class OrderGroupService extends DefaultService<OrderGroupDTO, OrderGroupMapper>{

	public OrderGroupVO getOrderGroupVO(String orderGroupId) throws Exception {
		if(StringUtils.isEmpty(orderGroupId)) {
			return null;
		}
		return super.getDetail(new OrderGroupVO() {{
			setOrderGroupId(orderGroupId);
		}});
	}

	public int addOrderGroupByOrderGroupType(List<OrderTrayVO> orderTrayList, EOrderGroupType eOrderGroupType) throws Exception {
		return addOrderGroupByOrderGroupType(null, eOrderGroupType);
	}

	public int addOrderGroupByOrderGroupType(String orderGroupId, List<OrderTrayVO> orderTrayList, EOrderGroupType eOrderGroupType) throws Exception {
		//실제 TRAY 처리 개수
		int orderTrayQty = orderTrayList.stream().filter(r -> StringUtils.isNotEmpty(r.getTrayId())).collect(Collectors.toList()).size();
		return addOrderGroupByOrderGroupType(orderGroupId, orderTrayQty, eOrderGroupType);
	}
	
	/**
	 * new
	 * @param lineNo
	 * @param orderGroupId
	 * @param orderTrayList
	 * @param eOrderGroupType
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public int addOrderGroupByOrderGroupTypeLineNo(String lineNo, String orderGroupId, List<OrderTrayVO> orderTrayList, EOrderGroupType eOrderGroupType, String emergencyType) throws Exception {
		//실제 TRAY 처리 개수
		int orderTrayQty = orderTrayList.size();
		return addOrderGroupByOrderGroupTypeLineNo(lineNo, orderGroupId, orderTrayQty, eOrderGroupType, emergencyType);
	}

	public int addOrderGroupByOrderGroupType(String orderGroupId, int orderTrayQty, EOrderGroupType eOrderGroupType) throws Exception {
		return add(new OrderGroupVO() {{
			if(StringUtils.isNotEmpty(orderGroupId)) {
				setOrderGroupId(orderGroupId);
			}
			setOrderGroupTypeCd(eOrderGroupType.name());
			setOrderTrayQty(orderTrayQty);
			setWorkTrayQty(0);
			setOrderGroupStatusCd(EOrderGroupStatus.READY.name());
			setOrderGroupDate(DateTools.getDateString());
			setOrderGroupStartDt(DateTools.getDateTimeString());
//			setOrderGroupFinishTypeCd(EOrderGroupFinishStatus.SUCCESS.name());
		}});
	}
	
	/**
	 * 보관 지시 그룹 입력
	 * @param lineNo
	 * @param orderGroupId
	 * @param orderTrayQty
	 * @param eOrderGroupType
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public int addOrderGroupByOrderGroupTypeLineNo(String lineNo, String orderGroupId, int orderTrayQty, EOrderGroupType eOrderGroupType, String emergencyType) throws Exception {
		return add(new OrderGroupVO() {{
			if(StringUtils.isNotEmpty(orderGroupId)) {
				setOrderGroupId(orderGroupId);
			}
			setLineNo(lineNo);
			setOrderGroupTypeCd(eOrderGroupType.name());
			setOrderTrayQty(orderTrayQty);
			setWorkTrayQty(0);
			setOrderGroupStatusCd(EOrderGroupStatus.READY.name());
			setOrderGroupDate(DateTools.getDateString());
			setOrderGroupStartDt(DateTools.getDateTimeString());
			setEmergencyYn(emergencyType);
		}});
	}

	public OrderGroupVO getReadyOrIngOrderGroup() {
		return getMapper().selectReadyOrIngOrderGroup();
	}
	
	public OrderGroupVO getReadyOrIngOrderGroupByLineNo(String lineNo) {
		return getMapper().selectReadyOrIngOrderGroupByLineNo(lineNo);
	}

	/**
	 * 진행중이 호출 지시그룹 정보 반환
	 * @return
	 */
	public OrderGroupVO getIngInquiryOrderGroup(String lineNo) {
		return getMapper().selectIngInquiryOrderGroup(lineNo);
	}
	
	/**
	 * 진행중이 호출 지시그룹 정보 반환
	 * @return
	 */
	public OrderGroupVO getIngOutputInQuiryOrderGroup(String lineNo) {
		return getMapper().selectIngOutputInQuiryOrderGroup(lineNo);
	}
	
	public OrderGroupVO getGroupByOrderId(String orderId) {
		return getMapper().selectByOrderId(orderId);
	}
}