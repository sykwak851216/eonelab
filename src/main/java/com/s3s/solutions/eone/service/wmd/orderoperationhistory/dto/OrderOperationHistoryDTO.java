package com.s3s.solutions.eone.service.wmd.orderoperationhistory.dto;

import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.solutions.eone.EoneConst;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderOperationHistoryDTO extends CrudModeDTO {

	@DTOKey("WOOH")
	/** 지시번호. */
	private String orderId;
	/** 지시그룹번호. */
	private String orderGroupId;
	/** 시스템동작모드ID. */
	private String systemOperationModeId;
	/** 시스템동작모드단계ID. */
	private String systemOperationModeStepId;
	/** 시스템동작모드단계순서. */
	private Integer systemOperationModeStepSort;
	/** 시작일시. */
	private String operationStartDt;
	/** 완료일시. */
	private String operationEndDt;

	public String getSystemOperationModeNameCache() {
		return MemoryManager.getName(EoneConst.WMD_SYSTEM_OPERATION_MODE, getSystemOperationModeId());
	}

	public String getSystemOperationModeStepNameCache() {
		return MemoryManager.getColumn(EoneConst.WMD_SYSTEM_OPERATION_MODE_STEP, "system_operation_mode_step_name", getSystemOperationModeId(), getSystemOperationModeStepId());
	}

	public String getSystemOperationModeStepDescCache() {
		return MemoryManager.getColumn(EoneConst.WMD_SYSTEM_OPERATION_MODE_STEP, "system_operation_mode_step_desc", getSystemOperationModeId(), getSystemOperationModeStepId());
	}

}