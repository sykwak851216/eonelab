package com.s3s.solutions.eone.service.wmd.rack.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RackDTO extends CrudModeDTO {

	@DTOKey("WR")
	/** 랙ID. */
	private String rackId;
	/** 랙명. */
	private String rackName;
	/** 랙X축 사이즈. */
	private Integer rackXAxisSize;
	/** 랙Y축 사이즈. */
	private Integer rackYAxisSize;
	/** 창고ID. */
	private String warehouseId;
	/** 설비ID. */
	private String mcId;
	/** 라인NO. */
	private String lineNo;
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