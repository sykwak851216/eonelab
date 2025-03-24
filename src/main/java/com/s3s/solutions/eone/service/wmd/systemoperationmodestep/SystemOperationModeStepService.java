package com.s3s.solutions.eone.service.wmd.systemoperationmodestep;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.solutions.eone.service.wmd.systemoperationmodestep.dto.SystemOperationModeStepDTO;
import com.s3s.sfp.service.mybatis.DefaultService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class SystemOperationModeStepService extends DefaultService<SystemOperationModeStepDTO, SystemOperationModeStepMapper>{

	private static final Logger logger = LoggerFactory.getLogger(SystemOperationModeStepService.class);

}