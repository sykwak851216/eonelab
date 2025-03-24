package com.s3s.solutions.eone.service.wmd.workplantray.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.sfp.SfpConst;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WorkPlanTrayDTO extends CrudModeDTO {

	@DTOKey("WWPT")
	/** 계획번호. */
	private String planNo;
	/** 계획그룹번호. */
	private String planGroupNo;
	/** 트레이번호. */
	private String trayId;
	/** 지시유형. */
	private String orderTypeCd;
	/** 지시순서. */
	private Integer trayOrderSort;
	/** 긴급여부. */
	private String emergencyYn;
	/** 입고일자. */
	private String inputDate;
	/** 라인번호. */
	private String lineNo;
	/** 랙ID. */
	private String rackId;
	/** 랙셀x축. */
	private Integer rackCellXAxis;
	/** 랙셀y축. */
	private Integer rackCellYAxis;
	/** 실행여부. */
	private String excuteYn;
	/** 트레이상태. */
	private String trayStatusCd;
	/** 등록일시. */
	private String regDt;
	/** 수정일시. */
	private String modDt;
	/** 취소여부. */
	private String cancelYn;
	/** 취소여부. */
	private String orderKindCd;

	private String ifWorkTrayId;
	private String refIfId;

	public String getOrderTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "order_type_cd", orderTypeCd);
	}

	public String getTrayStatusNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "tray_status_cd", trayStatusCd);
	}

	public String getOrderKindNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "order_kind_cd", orderKindCd);
	}

	public String getRackNameCache() {
		return MemoryManager.getName(EoneConst.WMD_RACK, rackId);
	}

}