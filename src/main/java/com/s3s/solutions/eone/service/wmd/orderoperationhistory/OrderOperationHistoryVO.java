package com.s3s.solutions.eone.service.wmd.orderoperationhistory;

import com.s3s.solutions.eone.service.wmd.orderoperationhistory.dto.OrderOperationHistoryDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderOperationHistoryVO extends OrderOperationHistoryDTO {

	private String systemOperationModeStepStartCode;
	private String systemOperationModeStepEndCode;
	private String schLineNo;

}
