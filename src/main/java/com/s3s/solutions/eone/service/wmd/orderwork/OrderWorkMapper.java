package com.s3s.solutions.eone.service.wmd.orderwork;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.orderwork.dto.OrderWorkDTO;

@Mapper
public interface OrderWorkMapper extends DefaultMapper<OrderWorkDTO>{

	public List<OrderWorkVO> selectOrderWorkList(@Param("param") OrderWorkVO orderWorkVO);
	
	public OrderWorkVO selectDetailOrderWorkByTrayId(@Param("param") OrderWorkVO orderWorkVO);
	
	

}