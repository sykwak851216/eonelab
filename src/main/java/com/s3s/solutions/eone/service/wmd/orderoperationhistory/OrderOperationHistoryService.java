package com.s3s.solutions.eone.service.wmd.orderoperationhistory;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.dto.OrderOperationHistoryDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class OrderOperationHistoryService extends DefaultService<OrderOperationHistoryDTO, OrderOperationHistoryMapper>{

	private static final Logger logger = LoggerFactory.getLogger(OrderOperationHistoryService.class);

	public PagingListDTO<OrderOperationHistoryVO> getOrderOperationHistoryPagingList(OrderOperationHistoryVO param, PagingDTO paging) throws Exception {
		return getPaingList(getMapper().selectOrderOperationHisList(param, paging), paging, getMapper().selectOrderOperationHisListTotalRows(param));
	}

	public List<OrderOperationHistoryVO> getOrderOperationHistoryList(OrderOperationHistoryVO vo) throws Exception{
		return getMapper().selectOrderOperationHistoryList(vo);
	}
	
	public int modifyOperationEndDt(OrderOperationHistoryVO vo) {
		return getMapper().updateOperationEndDt(vo);
	}
	
	
	public OrderOperationHistoryVO getLastOperation(OrderOperationHistoryVO vo) {
		return getMapper().selectLastOperation(vo);
	}
}