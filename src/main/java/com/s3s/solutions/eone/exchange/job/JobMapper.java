package com.s3s.solutions.eone.exchange.job;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.exchange.job.dto.JobDTO;

@Mapper
public interface JobMapper extends DefaultMapper<JobDTO>{


}