package com.s3s.solutions.eone.exchange.jobtray;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.exchange.jobtray.dto.JobTrayDTO;

@Mapper
public interface JobTrayMapper extends DefaultMapper<JobTrayDTO>{


}