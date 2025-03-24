package com.s3s.solutions.eone.service.wmd.machine;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.machine.dto.MachineDTO;

@Mapper
public interface MachineMapper extends DefaultMapper<MachineDTO>{}