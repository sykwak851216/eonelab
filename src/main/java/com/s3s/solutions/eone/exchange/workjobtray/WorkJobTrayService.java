package com.s3s.solutions.eone.exchange.workjobtray;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.exchange.workjobtray.dto.WorkJobTrayDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class WorkJobTrayService extends DefaultService<WorkJobTrayDTO, WorkJobTrayMapper>{

	private static final Logger logger = LoggerFactory.getLogger(WorkJobTrayService.class);
	
	public PagingListDTO<WorkJobTrayVO> getYudoWorkPagingList(WorkJobTrayVO param, PagingDTO paging) throws Exception {
		return getPaingList(getMapper().selectYudoWorkPagingList(param, paging), paging, getMapper().selectYudoWorkListTotalRows(param));
	}
	
	public WorkJobTrayVO getDetailByPlanNo(WorkJobTrayVO param) throws Exception {
		return getMapper().selectDetailByPlanNo(param);
	}
	

}