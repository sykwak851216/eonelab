package com.s3s.solutions.eone.service.wmd.ordertray;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.ordertray.dto.OrderTrayDTO;

@Mapper
public interface OrderTrayMapper extends DefaultMapper<OrderTrayDTO>{}