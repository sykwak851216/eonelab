package com.s3s.solutions.eone.exchange.jobtray.dto;

import com.s3s.sfp.service.common.CrudModeDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JobTrayDTO extends CrudModeDTO {
	private String ifTrayId;
	private String ifId;
	private String trayId;
	private String inOutTypeCd;
	private String entYmd;
	private String emergencyYn;
	private String seq;
	

}
