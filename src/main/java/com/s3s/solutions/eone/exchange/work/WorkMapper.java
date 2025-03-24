package com.s3s.solutions.eone.exchange.work;

import com.s3s.OracleConnMapper;
import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.exchange.work.dto.WorkDTO;

@OracleConnMapper
public interface WorkMapper extends DefaultMapper<WorkDTO>{

	public void readWorkList(WorkVO workVO);
	
	public void writeWork(WorkWriteTrayVO workWriteTrayVO);

}