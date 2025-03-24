package com.s3s.solutions.eone.service.wmd.orderoperationhistory;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.dto.OrderOperationHistoryDTO;

@Mapper
public interface OrderOperationHistoryMapper extends DefaultMapper<OrderOperationHistoryDTO>{

	public List<OrderOperationHistoryVO> selectOrderOperationHistoryList(@Param("param") OrderOperationHistoryVO vo);

	//이미 selectOrderOperationHistoryList 을쓰고 있어야 History --> His로만 쓴다!
	public List<OrderOperationHistoryVO> selectOrderOperationHisList(@Param("param") OrderOperationHistoryVO param, @Param("paging") PagingDTO paging);

	//이미 selectOrderOperationHistoryList 을쓰고 있어야 History --> His로만 쓴다!
	public int selectOrderOperationHisListTotalRows(@Param("param") OrderOperationHistoryVO param);
	
	
	public int updateOperationEndDt(@Param("param") OrderOperationHistoryVO param);
	
	public OrderOperationHistoryVO selectLastOperation(@Param("param") OrderOperationHistoryVO vo);
	

}