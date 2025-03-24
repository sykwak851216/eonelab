package com.s3s.solutions.eone.service.wmd.ordergroup;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.ordergroup.dto.OrderGroupDTO;

@Mapper
public interface OrderGroupMapper extends DefaultMapper<OrderGroupDTO>{

	public OrderGroupVO selectReadyOrIngOrderGroup();
	
	public OrderGroupVO selectReadyOrIngOrderGroupByLineNo(String lineNo);

	public OrderGroupVO selectIngInquiryOrderGroup(String lineNo);
	
	public OrderGroupVO selectIngOutputInQuiryOrderGroup(String lineNo);
	
	public OrderGroupVO selectByOrderId(String orderId);
	
}