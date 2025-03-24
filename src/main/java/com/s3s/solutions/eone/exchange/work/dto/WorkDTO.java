package com.s3s.solutions.eone.exchange.work.dto;

import com.s3s.sfp.service.common.CrudModeDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WorkDTO extends CrudModeDTO {
	private String div;
	private String result;
	
	
}