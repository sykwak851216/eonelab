package com.s3s.solutions.eone.service.wmd.ordertray.dto;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.solutions.eone.EoneConst;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderTrayDTO extends CrudModeDTO {

	@DTOKey("WOT")
	/** 지시번호. */
	private String orderId;
	/** 버퍼번호. */
	private String bufferId;
	/** 입출유형. */
	private String inOutTypeCd;
	/** 트레이번호. */
	private String trayId;
	/** 랙ID. */
	private String rackId;
	/** 랙셀x축. */
	private Integer rackCellXAxis;
	/** 랙셀y축. */
	private Integer rackCellYAxis;
	/** 등록일시. */
	private String regDt;

	public String getInOutTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "in_out_type_cd", inOutTypeCd);
	}

	public String getRackNameCache() {
		return MemoryManager.getName(EoneConst.WMD_RACK, rackId);
	}

}