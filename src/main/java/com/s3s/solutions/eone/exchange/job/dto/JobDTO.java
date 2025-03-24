package com.s3s.solutions.eone.exchange.job.dto;

import com.s3s.sfp.service.common.CrudModeDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JobDTO extends CrudModeDTO {

	private String ifId;
	private String ifTypeCd;
	private String entYmd;
	private String reqDt;
	private String result;
	
	
}
