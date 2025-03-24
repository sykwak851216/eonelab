package com.s3s.solutions.eone.service.wmd.ordermanagerhistory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.service.wmd.ordermanagerhistory.dto.OrderManagerHistoryDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class OrderManagerHistoryService extends DefaultService<OrderManagerHistoryDTO, OrderManagerHistoryMapper>{

	private static final Logger logger = LoggerFactory.getLogger(OrderManagerHistoryService.class);

}