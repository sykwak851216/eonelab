package com.s3s.solutions.eone.service.wmd.machinestatushistory;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.machinestatushistory.dto.MachineStatusHistoryDTO;

@Mapper
public interface MachineStatusHistoryMapper extends DefaultMapper<MachineStatusHistoryDTO>{}