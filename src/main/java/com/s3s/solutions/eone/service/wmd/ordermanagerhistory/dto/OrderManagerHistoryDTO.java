package com.s3s.solutions.eone.service.wmd.ordermanagerhistory.dto;

import com.s3s.sfp.service.common.CrudModeDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderManagerHistoryDTO extends CrudModeDTO {

	private String req;
	private String regDt;
}