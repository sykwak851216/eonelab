package com.s3s.solutions.eone.exchange.workjobtray.dto;

import com.s3s.sfp.service.common.CrudModeDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WorkJobTrayDTO extends CrudModeDTO {
	private String ifWorkTrayId;
	private String ifId;
	private String refIfId;
	private String trayId;
	private String ifWorkTypeCd;
	private String resultYn;
	private String emergencyYn;
	private String lineNo;
	private String rackId;
	private Integer rackCellXAxis;
	private Integer rackCellYAxis;
	private String entYmd;
	private String remark;
	private String seq;

}
