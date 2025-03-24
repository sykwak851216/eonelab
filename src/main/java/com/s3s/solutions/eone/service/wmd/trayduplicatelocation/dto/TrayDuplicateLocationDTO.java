package com.s3s.solutions.eone.service.wmd.trayduplicatelocation.dto;

import com.s3s.sfp.service.common.CrudModeDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TrayDuplicateLocationDTO extends CrudModeDTO {

	/** 트레이번호. */
	private String trayId;
	/** 입고일자. */
	private String inputDate;
	/** 위치유형. */
	private String locTypeCd;
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

}