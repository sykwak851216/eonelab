package com.s3s.solutions.eone.service.wmd.ordertray;

import com.s3s.solutions.eone.service.wmd.ordertray.dto.OrderTrayDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderTrayVO extends OrderTrayDTO {

	private String sensorYn;

	private String planNo;
	
	private String lineNo;

}