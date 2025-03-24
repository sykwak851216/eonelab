package com.s3s.solutions.eone.service.wmd.warehouse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.s3s.solutions.eone.service.wmd.warehouse.dto.WarehouseDTO;
import com.s3s.sfp.service.mybatis.DefaultService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class WarehouseService extends DefaultService<WarehouseDTO, WarehouseMapper>{

	private static final Logger logger = LoggerFactory.getLogger(WarehouseService.class);

}