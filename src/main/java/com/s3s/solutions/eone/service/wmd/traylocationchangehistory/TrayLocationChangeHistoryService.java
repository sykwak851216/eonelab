package com.s3s.solutions.eone.service.wmd.traylocationchangehistory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.service.wmd.traylocationchangehistory.dto.TrayLocationChangeHistoryDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class TrayLocationChangeHistoryService extends DefaultService<TrayLocationChangeHistoryDTO, TrayLocationChangeHistoryMapper>{

	private static final Logger logger = LoggerFactory.getLogger(TrayLocationChangeHistoryService.class);
	
	public TrayLocationChangeHistoryVO getBufferDetailByOrderGroupId(TrayLocationChangeHistoryVO vo){
		return getMapper().selectBufferDetailByOrderGroupId(vo);
	}

}