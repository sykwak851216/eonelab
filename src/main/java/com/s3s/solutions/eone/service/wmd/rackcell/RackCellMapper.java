package com.s3s.solutions.eone.service.wmd.rackcell;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.rackcell.dto.RackCellDTO;

@Mapper
public interface RackCellMapper extends DefaultMapper<RackCellDTO>{

	public List<RackCellVO> selectRackCellListByGantry(@Param("param") RackCellVO vo);
	

}