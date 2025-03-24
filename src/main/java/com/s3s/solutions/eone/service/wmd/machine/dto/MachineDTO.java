package com.s3s.solutions.eone.service.wmd.machine.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MachineDTO extends CrudModeDTO {

	@DTOKey("WM")
	/** 설비ID. */
	private String mcId;
	/** 설비명. */
	private String mcName;
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