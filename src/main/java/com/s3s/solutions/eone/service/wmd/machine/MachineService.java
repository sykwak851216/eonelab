package com.s3s.solutions.eone.service.wmd.machine;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.solutions.eone.service.wmd.machine.dto.MachineDTO;
import com.s3s.sfp.service.mybatis.DefaultService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class MachineService extends DefaultService<MachineDTO, MachineMapper>{

	private static final Logger logger = LoggerFactory.getLogger(MachineService.class);

}