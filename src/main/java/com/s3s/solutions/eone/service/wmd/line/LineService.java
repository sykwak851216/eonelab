package com.s3s.solutions.eone.service.wmd.line;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.service.wmd.line.dto.LineDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class LineService extends DefaultService<LineDTO, LineMapper>{

	private static final Logger logger = LoggerFactory.getLogger(LineService.class);

}