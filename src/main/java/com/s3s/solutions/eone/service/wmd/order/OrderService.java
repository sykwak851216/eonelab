package com.s3s.solutions.eone.service.wmd.order;

import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.sfp.tools.DateTools;
import com.s3s.solutions.eone.define.EOrderStatus;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.service.wmd.order.dto.OrderDTO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class OrderService extends DefaultService<OrderDTO, OrderMapper>{

	public List<OrderVO> getReadyOrderList() throws Exception{
		return getList(new OrderVO() {{
			setOrderStatusCd(EOrderStatus.READY.name());
		}});
	}

	public OrderVO getReadyOrIngOrder() {
		return getMapper().selectReadyOrIngOrder();
	}
	
	public OrderVO getReadyOrIngOrderByLineNo(String lineNo) {
		return getMapper().selectReadyOrIngOrderByLineNo(lineNo);
	}

	public int addOrderByOrderType(String orderGroupId, String orderId, List<OrderTrayVO> orderTrayList, EOrderType eOrderType) throws Exception {
		int orderTrayQty = orderTrayList.stream().filter(r -> StringUtils.isNotEmpty(r.getTrayId())).collect(Collectors.toList()).size();
		return addOrderByOrderType(orderGroupId, orderId, orderTrayQty, eOrderType);
	}
	
	/**
	 * new
	 * @param orderGroupId
	 * @param orderId
	 * @param orderTrayList
	 * @param eOrderType
	 * @return
	 * @throws Exception
	 */
	public int addOrderByOrderTypeByLineNo(String lineNo, String orderGroupId, String orderId, List<OrderTrayVO> orderTrayList, EOrderType eOrderType) throws Exception {
		int orderTrayQty = orderTrayList.size();
		return addOrderByOrderTypeByLineNo(lineNo, orderGroupId, orderId, orderTrayQty, eOrderType);
	}
	

	public int addOrderByOrderType(String orderGroupId, String orderId, int orderTrayQty, EOrderType eOrderType) throws Exception {
		return add(new OrderVO() {{
			setOrderGroupId(orderGroupId);
			if(orderId != null) {
				setOrderId(orderId);
			}
			setOrderTrayQty(orderTrayQty);
			setWorkTrayQty(0);//초기화
			setOrderStatusCd(EOrderStatus.READY.name());
			setOrderDate(DateTools.getDateString());
			setOrderStartDt(DateTools.getDateTimeString());
			setOrderTypeCd(eOrderType.name());
			//setOrderFinishTypeCd(EOrderFinishStatus.SUCCESS.name());
		}});
	}
	
	/**
	 * new
	 * @param orderGroupId
	 * @param orderId
	 * @param orderTrayQty
	 * @param eOrderType
	 * @return
	 * @throws Exception
	 */
	public int addOrderByOrderTypeByLineNo(String lineNo, String orderGroupId, String orderId, int orderTrayQty, EOrderType eOrderType) throws Exception {
		return add(new OrderVO() {{
			setOrderGroupId(orderGroupId);
			if(orderId != null) {
				setOrderId(orderId);
			}
			setLineNo(lineNo);
			setOrderTrayQty(orderTrayQty);
			setWorkTrayQty(0);//초기화
			setOrderStatusCd(EOrderStatus.READY.name());
			setOrderDate(DateTools.getDateString());
			setOrderStartDt(DateTools.getDateTimeString());
			setOrderTypeCd(eOrderType.name());
			//setOrderFinishTypeCd(EOrderFinishStatus.SUCCESS.name());
		}});
	}

	public OrderVO getOrderById(String orderId) throws Exception{
		return getMapper().selectOrderDetail(orderId);
	}
}