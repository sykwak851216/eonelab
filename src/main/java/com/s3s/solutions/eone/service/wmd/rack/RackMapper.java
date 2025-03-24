package com.s3s.solutions.eone.service.wmd.rack;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.rack.dto.RackDTO;

@Mapper
public interface RackMapper extends DefaultMapper<RackDTO>{}