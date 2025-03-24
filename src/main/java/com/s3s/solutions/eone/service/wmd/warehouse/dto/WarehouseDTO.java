package com.s3s.solutions.eone.service.wmd.warehouse.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WarehouseDTO extends CrudModeDTO {

	@DTOKey("WW")
	/** 창고ID. */
	private String warehouseId;
	/** 창고명. */
	private String warehouseName;
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
}