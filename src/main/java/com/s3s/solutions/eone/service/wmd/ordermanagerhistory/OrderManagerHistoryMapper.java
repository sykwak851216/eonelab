package com.s3s.solutions.eone.service.wmd.ordermanagerhistory;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.ordermanagerhistory.dto.OrderManagerHistoryDTO;

@Mapper
public interface OrderManagerHistoryMapper extends DefaultMapper<OrderManagerHistoryDTO>{}