package com.s3s.solutions.eone.service.wmd.orderwork;

import java.util.List;

import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.service.wmd.orderwork.dto.OrderWorkDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class OrderWorkService extends DefaultService<OrderWorkDTO, OrderWorkMapper>{

	public List<OrderWorkVO> getOrderWorkListByOrderId(String orderId) throws Exception{
		return getList(new OrderWorkVO() {{
			setOrderId(orderId);
		}});
	}

	public List<OrderWorkVO> getOrderWorkListByOrderGroupId(String orderGroupId) throws Exception{
		return getMapper().selectOrderWorkList(new OrderWorkVO() {{
			setOrderGroupId(orderGroupId);
		}});
	}
	
	public OrderWorkVO getOrderWorkByTrayId(OrderWorkVO orderWorkVO) throws Exception{
		return getMapper().selectDetailOrderWorkByTrayId(orderWorkVO);
	}
}