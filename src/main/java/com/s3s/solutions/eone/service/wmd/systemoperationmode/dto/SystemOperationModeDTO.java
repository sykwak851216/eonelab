package com.s3s.solutions.eone.service.wmd.systemoperationmode.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SystemOperationModeDTO extends CrudModeDTO {

	@DTOKey("WSOM")
	/** 시스템동작모드ID. */
	private String systemOperationModeId;
	/** 시스템동작모드명. */
	private String systemOperationModeName;
	/** 시스템동작모드설명. */
	private String systemOperationModeDesc;
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