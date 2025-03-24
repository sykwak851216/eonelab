package com.s3s.solutions.eone.exchange.jobtray;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.exchange.jobtray.dto.JobTrayDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class JobTrayService extends DefaultService<JobTrayDTO, JobTrayMapper>{

	private static final Logger logger = LoggerFactory.getLogger(JobTrayService.class);
	
	

}