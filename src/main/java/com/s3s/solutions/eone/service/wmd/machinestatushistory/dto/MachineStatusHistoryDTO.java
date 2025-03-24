package com.s3s.solutions.eone.service.wmd.machinestatushistory.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MachineStatusHistoryDTO extends CrudModeDTO {

	@DTOKey("WMSH")
	/** 이력번호. */
	private String historySeq;
	/** 설비ID. */
	private String mcId;
	/** 설비상태코드. */
	private String mcStatusCd;
	/** 상태시작일시. */
	private String delYn;
	/** 상태종료일시. */
	private String regDt;
}