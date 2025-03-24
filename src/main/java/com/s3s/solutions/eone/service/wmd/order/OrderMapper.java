package com.s3s.solutions.eone.service.wmd.order;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.order.dto.OrderDTO;

@Mapper
public interface OrderMapper extends DefaultMapper<OrderDTO>{

	public OrderVO selectOrderDetail(String orderId);

	public OrderVO selectReadyOrIngOrder();
	
	public OrderVO selectReadyOrIngOrderByLineNo(String lineNo);

}