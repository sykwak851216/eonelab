package com.s3s.solutions.eone.service.wmd.warehouse;

import org.apache.ibatis.annotations.Mapper;

import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.warehouse.dto.WarehouseDTO;

@Mapper
public interface WarehouseMapper extends DefaultMapper<WarehouseDTO>{}