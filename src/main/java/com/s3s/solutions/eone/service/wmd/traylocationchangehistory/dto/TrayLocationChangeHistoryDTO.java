package com.s3s.solutions.eone.service.wmd.traylocationchangehistory.dto;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.solutions.eone.EoneConst;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TrayLocationChangeHistoryDTO extends CrudModeDTO {

	@DTOKey("WTLCH")
	/** 이력SEQ. */
	private String historySeq;
	/** 트레이번호. */
	private String trayId;
	/** 출발위치유형. */
	private String fromLocTypeCd;
	/** 도착위치유형. */
	private String toLocTypeCd;
	/** 버퍼번호. */
	private String bufferId;
	/** 렉셀ID. */
	private String rackCellId;
	/** 랙ID. */
	private String rackId;
	/** 랙셀X축. */
	private Integer rackCellXAxis;
	/** 랙셀Y축. */
	private Integer rackCellYAxis;
	/** 지시번호. */
	private String orderId;
	/** 지시그룹ID. */
	private String orderGroupId;
	/** 변경일시. */
	private String changeDt;
	
	private String inputDate;

	public String getFromLocTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "loc_type_cd", fromLocTypeCd);
	}

	public String getToLocTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "loc_type_cd", toLocTypeCd);
	}

	public String getRackNameCache() {
		return MemoryManager.getName(EoneConst.WMD_RACK, rackId);
	}

}