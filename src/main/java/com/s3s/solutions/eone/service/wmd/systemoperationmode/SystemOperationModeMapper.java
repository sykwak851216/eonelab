package com.s3s.solutions.eone.service.wmd.systemoperationmode;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.systemoperationmode.dto.SystemOperationModeDTO;

@Mapper
public interface SystemOperationModeMapper extends DefaultMapper<SystemOperationModeDTO>{}