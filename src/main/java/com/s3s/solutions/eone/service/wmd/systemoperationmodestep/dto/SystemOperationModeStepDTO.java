package com.s3s.solutions.eone.service.wmd.systemoperationmodestep.dto;

import com.s3s.sfp.service.common.CrudModeDTO;
import com.s3s.sfp.service.mybatis.DTOKey;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SystemOperationModeStepDTO extends CrudModeDTO {

	@DTOKey("WSOMS")
	/** 시스템동작모드ID. */
	private String systemOperationModeId;
	/** 시스템동작모드단계ID. */
	private String systemOperationModeStepId;
	/** 시스템동작모드단계명. */
	private String systemOperationModeStepName;
	/** 시스템동작모드단계순서. */
	private Integer systemOperationModeStepSort;
	private String systemOperationModeStepStartCode;
	private String systemOperationModeStepEndCode;
	/** 시스템동작모드단계설명. */
	private String systemOperationModeStepDesc;
	/** 병행처리여부. */
	private String parallelProcessYn;
	/** 삭제여부. */
	private String delYn;
	/** 등록일시. */
	private String regDt;
	/** 등록자. */
	private String regId;
	/** 수정일시. */
	private String modDt;
	/** 수정자. */
	private String modId;
}