package com.s3s.solutions.eone.service.wmd.machinestatushistory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.solutions.eone.service.wmd.machinestatushistory.dto.MachineStatusHistoryDTO;
import com.s3s.sfp.service.mybatis.DefaultService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class MachineStatusHistoryService extends DefaultService<MachineStatusHistoryDTO, MachineStatusHistoryMapper>{

	private static final Logger logger = LoggerFactory.getLogger(MachineStatusHistoryService.class);

}