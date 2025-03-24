package com.s3s.solutions.eone.exchange.workjobtray;

import com.s3s.solutions.eone.exchange.workjobtray.dto.WorkJobTrayDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WorkJobTrayVO  extends WorkJobTrayDTO {
	private String rtnResult;
	private String reqDt;
	private String planNo;
	
}
