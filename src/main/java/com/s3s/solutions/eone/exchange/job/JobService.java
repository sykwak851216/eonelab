package com.s3s.solutions.eone.exchange.job;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.exchange.job.dto.JobDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class JobService extends DefaultService<JobDTO, JobMapper>{

	private static final Logger logger = LoggerFactory.getLogger(JobService.class);
	
	

}