package com.s3s.solutions.eone.service.wmd.traylocationchangehistory;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.traylocationchangehistory.dto.TrayLocationChangeHistoryDTO;

@Mapper
public interface TrayLocationChangeHistoryMapper extends DefaultMapper<TrayLocationChangeHistoryDTO>{
	
	public TrayLocationChangeHistoryVO selectBufferDetailByOrderGroupId(@Param("param") TrayLocationChangeHistoryVO vo);
}