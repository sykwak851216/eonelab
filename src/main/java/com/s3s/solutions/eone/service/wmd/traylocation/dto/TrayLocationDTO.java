package com.s3s.solutions.eone.service.wmd.traylocation.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.sfp.SfpConst;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TrayLocationDTO extends CrudModeDTO {

	@DTOKey("WTL")
	/** 트레이번호. */
	private String trayId;
	/** 입고일자. */
	private String inputDate;
	/** 위치유형. */
	private String locTypeCd;
	/** 버퍼번호. */
	private String bufferId;
	/** 랙셀ID. */
	private String rackCellId;
	/** 라인NO. */
	private String lineNo;
	/** 랙ID. */
	private String rackId;
	/** 렉셀X축. */
	private Integer rackCellXAxis;
	/** 렉셀Y축. */
	private Integer rackCellYAxis;
	/** 등록일시. */
	private String regDt;
	/** 수정일시. */
	private String modDt;

	public String getLocTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "loc_type_cd", locTypeCd);
	}

	public String getRackNameCache() {
		return MemoryManager.getName(EoneConst.WMD_RACK, rackId);
	}
}