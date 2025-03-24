package com.s3s.solutions.eone.service.wmd.rack;

import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.service.wmd.rack.dto.RackDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class RackService extends DefaultService<RackDTO, RackMapper>{

}