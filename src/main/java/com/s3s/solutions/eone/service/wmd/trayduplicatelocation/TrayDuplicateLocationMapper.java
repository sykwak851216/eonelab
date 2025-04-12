package com.s3s.solutions.eone.service.wmd.trayduplicatelocation;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.trayduplicatelocation.dto.TrayDuplicateLocationDTO;

@Mapper
public interface TrayDuplicateLocationMapper extends DefaultMapper<TrayDuplicateLocationDTO>{
	public List<TrayDuplicateLocationVO> selectTrayduplicationResult(@Param("param") String trayId);
}