package com.s3s.solutions.eone.service.wmd.rackcell.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RackCellDTO extends CrudModeDTO {

	@DTOKey("WRC")
	/** 랙셀ID. */
	private String rackCellId;
	/** 랙셀명. */
	private String rackCellName;
	/** 랙ID. */
	private String rackId;
	/** 랙셀X축. */
	private Integer rackCellXAxis;
	/** 랙셀Y축. */
	private Integer rackCellYAxis;
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

	public String getRackNameCache() {
		return MemoryManager.getName(EoneConst.WMD_RACK, rackId);
	}

}