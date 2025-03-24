package com.s3s.solutions.eone.service.wmd.line;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.line.dto.LineDTO;

@Mapper
public interface LineMapper extends DefaultMapper<LineDTO>{}