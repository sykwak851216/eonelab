package com.s3s.solutions.eone.service.wmd.orderwork.dto;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.solutions.eone.EoneConst;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderWorkDTO extends CrudModeDTO {

	@DTOKey("WOW")
	/** 작업번호. */
	private String workId;
	/** 지시번호. */
	private String orderId;
	/** 버퍼번호. */
	private String bufferId;
	/** 입출유형. */
	private String inOutTypeCd;
	/** 계획번호. */
	private String planNo;
	/** 트레이번호. */
	private String trayId;
	/** 랙ID. */
	private String rackId;
	/** 랙셀x축. */
	private Integer rackCellXAxis;
	/** 랙셀y축. */
	private Integer rackCellYAxis;

	private Integer inquiryQty;

	private String workStatusCd;
	/** 등록일시. */
	private String regDt;
	/** 수정일시. */
	private String modDt;

	public String getInOutTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "in_out_type_cd", inOutTypeCd);
	}

	public String getWorkStatusNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "work_status_cd", workStatusCd);
	}

	public String getRackNameCache() {
		return MemoryManager.getName(EoneConst.WMD_RACK, rackId);
	}

}