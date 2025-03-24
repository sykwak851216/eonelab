package com.s3s.solutions.eone.exchange.work;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.exchange.work.dto.WorkDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class WorkService extends DefaultService<WorkDTO, WorkMapper>{

	private static final Logger logger = LoggerFactory.getLogger(WorkService.class);
	
	public WorkVO procRead() {
		WorkVO workVO = new WorkVO();
		getMapper().readWorkList(workVO);
		return workVO;
	}
	
	public WorkWriteTrayVO procWork(WorkWriteTrayVO workWriteTrayVO) {
		getMapper().writeWork(workWriteTrayVO);
		return workWriteTrayVO;
	}

}