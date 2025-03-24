package com.s3s.solutions.eone.service.wmd.systemoperationmode;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.solutions.eone.service.wmd.systemoperationmode.dto.SystemOperationModeDTO;
import com.s3s.sfp.service.mybatis.DefaultService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class SystemOperationModeService extends DefaultService<SystemOperationModeDTO, SystemOperationModeMapper>{

	private static final Logger logger = LoggerFactory.getLogger(SystemOperationModeService.class);

}