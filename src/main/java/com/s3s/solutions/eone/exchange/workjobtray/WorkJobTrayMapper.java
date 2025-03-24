package com.s3s.solutions.eone.exchange.workjobtray;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.exchange.workjobtray.dto.WorkJobTrayDTO;

@Mapper
public interface WorkJobTrayMapper extends DefaultMapper<WorkJobTrayDTO>{

	public List<WorkJobTrayVO> selectYudoWorkPagingList(@Param("param") WorkJobTrayVO param, @Param("paging") PagingDTO paging);

	public int selectYudoWorkListTotalRows(@Param("param") WorkJobTrayVO param);
	
	public WorkJobTrayVO selectDetailByPlanNo(@Param("param") WorkJobTrayVO param);
}