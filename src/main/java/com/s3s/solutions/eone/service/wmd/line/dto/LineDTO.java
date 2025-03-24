package com.s3s.solutions.eone.service.wmd.line.dto;

import com.s3s.sfp.service.common.CrudModeDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LineDTO extends CrudModeDTO {

	private String lineNo;
	private String lineNm;
}